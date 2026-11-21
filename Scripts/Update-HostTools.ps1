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

$script:WingetTools = @(
    @{ Name = 'gitleaks';   Id = 'Gitleaks.Gitleaks' }
    @{ Name = 'actionlint'; Id = 'rhysd.actionlint' }
    @{ Name = 'lychee';     Id = 'lycheeverse.lychee' }
    @{ Name = 'shellcheck'; Id = 'koalamer.ShellCheck' }
    @{ Name = 'yamllint';   Id = 'tamasfe.yamllint' }
    @{ Name = 'markdownlint-cli2'; Id = 'DavidAnson.markdownlint-cli2' }
    @{ Name = 'PowerShell 7'; Id = 'Microsoft.PowerShell' }
)

$script:ModuleTools = @('Pester', 'PSScriptAnalyzer')

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
    return $plan
}

function Invoke-HostToolUpdate {
    param([object[]]$Plan)
    foreach ($row in $Plan) {
        if ($row.Action -notin @('Update available', 'Install available')) { continue }
        if ($row.Source -like 'winget:*') {
            $id = $row.Source.Substring(7)
            $flag = if ($row.Action -eq 'Install available') { 'install' } else { 'upgrade' }
            & winget $flag --id $id --exact --scope user --accept-source-agreements --accept-package-agreements
            if ($LASTEXITCODE -ne 0) { Write-Warning "winget failed for $($row.Name)" }
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
