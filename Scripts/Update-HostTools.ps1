<#
.SYNOPSIS
    Probes and optionally updates the host tools declared by this project.
.DESCRIPTION
    The project requires every host tool to be at its latest release, but CI
    resolves tools at run time and cannot keep a developer machine current.
    This helper probes winget and PowerShell Gallery, prints one row per tool,
    and changes nothing unless -Apply is given. It never elevates: winget runs
    with --scope user and PowerShell modules with -Scope CurrentUser.

    This is a probe-first tool: the default run is the dry run.

.PARAMETER Apply
    Perform the updates shown by the probe. Without it the script only reports.
.PARAMETER Library
    Define the functions without running a command. Used by the Pester suite.
#>
param(
    [switch]$Apply,
    [switch]$Library
)

$ErrorActionPreference = 'Stop'

# Verified with `winget show --id <id> --exact` on 2026-11-21. An ID that does
# not resolve must not sit here: the probe would report it as "not installed"
# forever and no update could ever be offered.
$script:WingetTools = @(
    @{ Name = 'gitleaks';   Id = 'Gitleaks.Gitleaks' }
    @{ Name = 'actionlint'; Id = 'rhysd.actionlint' }
    @{ Name = 'lychee';     Id = 'lycheeverse.lychee' }
    @{ Name = 'shellcheck'; Id = 'koalaman.shellcheck' }
    @{ Name = 'PowerShell 7'; Id = 'Microsoft.PowerShell' }
)

$script:ModuleTools = @('Pester', 'PSScriptAnalyzer')

# These two have no winget package. They are installed at per-user scope with
# their own package managers, so the probe and the update stay elevation-free.
$script:PackageTools = @(
    @{ Name = 'yamllint'; Id = 'yamllint'; Manager = 'pip' }
    @{ Name = 'markdownlint-cli2'; Id = 'markdownlint-cli2'; Manager = 'npm' }
)

function Get-VersionKey {
    param([string]$Version)
    if ([string]::IsNullOrWhiteSpace($Version)) { return $null }
    $match = [regex]::Match($Version, '(\d+)\.(\d+)(?:\.(\d+))?')
    if (-not $match.Success) { return $null }
    $major = [int]$match.Groups[1].Value
    $minor = [int]$match.Groups[2].Value
    $patch = 0
    if ($match.Groups[3].Success) { $patch = [int]$match.Groups[3].Value }
    try { return [version]::new($major, $minor, $patch) } catch { return $null }
}

function Compare-ToolVersion {
    param([string]$Current, [string]$Available)
    $availableKey = Get-VersionKey -Version $Available
    if ($null -eq $availableKey) { return 'Unknown' }
    if ([string]::IsNullOrWhiteSpace($Current) -or $Current -eq 'not installed') {
        return 'Install available'
    }
    $currentKey = Get-VersionKey -Version $Current
    if ($null -eq $currentKey) { return 'Unknown' }
    if ($availableKey -gt $currentKey) { return 'Update available' }
    if ($availableKey -lt $currentKey) { return 'Current above source' }
    return 'Up to date'
}

function Test-CommandExists {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Get-WingetVersion {
    param([string]$Id, [switch]$Installed)
    # Native stderr is an ErrorRecord in Windows PowerShell 5.1; without this
    # local preference a harmless warning would terminate the probe.
    $ErrorActionPreference = 'Continue'
    if (-not (Test-CommandExists -Name 'winget')) { return 'winget unavailable' }
    $flag = if ($Installed) { 'list' } else { 'show' }
    $output = & winget $flag --id $Id --exact --accept-source-agreements 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0) { return 'not installed' }
    $match = [regex]::Match($output, '(?m)^\s*(?:Version|Installed Version)\s*:\s*([^\r\n]+)')
    if ($match.Success) { return $match.Groups[1].Value.Trim() }
    return 'unknown'
}

function Get-ModuleVersion {
    param([string]$Name, [switch]$Gallery)
    if ($Gallery) {
        $module = Find-Module -Name $Name -Repository PSGallery -ErrorAction SilentlyContinue |
            Select-Object -First 1
        if ($module) { return $module.Version.ToString() }
        return 'gallery unavailable'
    }
    $module = Get-Module -ListAvailable -Name $Name |
        Sort-Object Version -Descending | Select-Object -First 1
    if ($module) { return $module.Version.ToString() }
    return 'not installed'
}

function Get-PythonCommand {
    $ErrorActionPreference = 'Continue'
    foreach ($candidate in @(@('py', '-3'), @('python3'), @('python'))) {
        $cmd = Get-Command $candidate[0] -ErrorAction SilentlyContinue
        if (-not $cmd) { continue }
        $prefix = @($candidate | Select-Object -Skip 1)
        try {
            & $cmd.Source @prefix --version 2>$null | Out-Null
            if ($LASTEXITCODE -eq 0) { return @($cmd.Source) + $prefix }
        } catch { continue }
    }
    return $null
}

function Get-PackageVersion {
    param([string]$Id, [string]$Manager, [switch]$Latest)
    $ErrorActionPreference = 'Continue'
    if ($Manager -eq 'pip') {
        $python = @(Get-PythonCommand | Where-Object { $_ })
        if ($python.Count -eq 0) { return 'python unavailable' }
        if ($Latest) {
            try {
                $release = Invoke-RestMethod -Uri "https://pypi.org/pypi/$Id/json" -TimeoutSec 20
                return $release.info.version
            } catch { return 'index unavailable' }
        }
        $output = & $python[0] @($python | Select-Object -Skip 1) -m pip show $Id 2>&1 | Out-String
        $match = [regex]::Match($output, '(?m)^Version:\s*([^\r\n]+)')
        if ($match.Success) { return $match.Groups[1].Value.Trim() }
        return 'not installed'
    }
    if (-not (Test-CommandExists -Name 'npm')) { return 'npm unavailable' }
    if ($Latest) {
        $output = & npm view $Id version 2>&1 | Out-String
        if ($LASTEXITCODE -eq 0 -and $output.Trim()) { return $output.Trim() }
        return 'index unavailable'
    }
    $output = & npm list -g --depth=0 --json 2>&1 | Out-String
    try {
        $tree = $output | ConvertFrom-Json
        $entry = $tree.dependencies.PSObject.Properties[$Id]
        if ($entry) { return $entry.Value.version }
    } catch { return 'unknown' }
    return 'not installed'
}

function Get-HostToolPlan {
    $plan = @()
    foreach ($tool in $script:WingetTools) {
        $current = Get-WingetVersion -Id $tool.Id -Installed
        $available = Get-WingetVersion -Id $tool.Id
        $plan += [pscustomobject]@{
            Name      = $tool.Name
            Source    = "winget: $($tool.Id)"
            Current   = $current
            Available = $available
            Action    = Compare-ToolVersion -Current $current -Available $available
        }
    }
    foreach ($name in $script:ModuleTools) {
        $current = Get-ModuleVersion -Name $name
        $available = Get-ModuleVersion -Name $name -Gallery
        $plan += [pscustomobject]@{
            Name      = $name
            Source    = 'PSGallery'
            Current   = $current
            Available = $available
            Action    = Compare-ToolVersion -Current $current -Available $available
        }
    }
    foreach ($tool in $script:PackageTools) {
        $current = Get-PackageVersion -Id $tool.Id -Manager $tool.Manager
        $available = Get-PackageVersion -Id $tool.Id -Manager $tool.Manager -Latest
        $plan += [pscustomobject]@{
            Name      = $tool.Name
            Source    = "$($tool.Manager): $($tool.Id)"
            Current   = $current
            Available = $available
            Action    = Compare-ToolVersion -Current $current -Available $available
        }
    }
    return $plan
}

function Invoke-HostToolUpdate {
    param([object[]]$Plan)
    $ErrorActionPreference = 'Continue'
    foreach ($row in $Plan) {
        if ($row.Action -notin @('Update available', 'Install available')) { continue }
        if ($row.Source -like 'winget:*') {
            $id = $row.Source.Substring(7)
            $flag = if ($row.Action -eq 'Install available') { 'install' } else { 'upgrade' }
            & winget $flag --id $id --exact --scope user --accept-source-agreements --accept-package-agreements
            if ($LASTEXITCODE -ne 0) { Write-Warning "winget failed for $($row.Name)" }
        } elseif ($row.Source -like 'pip:*') {
            $python = @(Get-PythonCommand | Where-Object { $_ })
            if ($python.Count -eq 0) { Write-Warning "python unavailable for $($row.Name)"; continue }
            & $python[0] @($python | Select-Object -Skip 1) -m pip install --user --upgrade $row.Name
            if ($LASTEXITCODE -ne 0) { Write-Warning "pip failed for $($row.Name)" }
        } elseif ($row.Source -like 'npm:*') {
            & npm install --global $row.Name
            if ($LASTEXITCODE -ne 0) { Write-Warning "npm failed for $($row.Name)" }
        } else {
            Install-Module -Name $row.Name -Scope CurrentUser -Force -AllowClobber -Repository PSGallery
        }
    }
}

if ($Library) { return }

$plan = @(Get-HostToolPlan)
$plan | Format-Table -AutoSize | Out-String | Write-Host
if (-not $Apply) {
    Write-Host 'Probe only; no changes made. Rerun with -Apply to update at per-user scope.'
    exit 0
}
Invoke-HostToolUpdate -Plan $plan
Write-Host 'Host tool update pass finished.'
