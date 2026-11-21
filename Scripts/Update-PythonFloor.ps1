<#
.SYNOPSIS
    Resolves and applies the Python compatibility floor from the upstream calendar.
.DESCRIPTION
    The Python core team publishes the release calendar at the fixed HTTPS URL
    below. A version is supported when it is not marked end-of-life and its
    scheduled EOL date has not passed. The oldest supported minor is the floor.

    The declared floor has one source: the first PYTHON_VERSION matrix entry in
    .gitlab-ci.yml. Every other CI declaration must match it; Find-Drift reports
    any mismatch. Apply-Floor rewrites only CI declarations and preserves each
    file's UTF-8 BOM state.

    check: compare the declared floor with upstream, emit current/desired/changed
           (also to $env:GITHUB_OUTPUT), report declaration drift, exit 2 on drift.
    apply: rewrite every declaration to -Version; refuses a downgrade.

.PARAMETER Command
    check or apply.
.PARAMETER Version
    New floor for apply, in MAJOR.MINOR form (for example 3.12).
.PARAMETER Root
    Repository root. Defaults to the parent of this script's directory.
.PARAMETER Library
    Define the functions without running a command. Used by the Pester suite.
#>
param(
    [ValidateSet('check', 'apply')]
    [string]$Command,
    [string]$Version,
    [string]$Root,
    [switch]$Library
)

$ErrorActionPreference = 'Stop'
$script:PePsUrl = 'https://peps.python.org/api/release-cycle.json'

# Each declaration is matched with a version-agnostic regex and rendered from
# the template. The first entry is the single source of truth.
$script:Declarations = @(
    @{
        File     = '.gitlab-ci.yml'
        Template = 'PYTHON_VERSION: ["{old}", "latest"]'
        Regex    = 'PYTHON_VERSION:\s*\["\d+\.\d+",\s*"latest"\]'
    },
    @{
        File     = '.github/workflows/quality.yml'
        Template = 'python-version: ["{old}", "3.x"]'
        Regex    = 'python-version:\s*\["\d+\.\d+",\s*"3\.x"\]'
    }
)

function Get-VersionKey {
    param([string]$V)
    try { return [version]$V } catch { throw "invalid Python version: $V" }
}

function Read-RepoFile {
    param([string]$Path)
    $bytes = [System.IO.File]::ReadAllBytes($Path)
    $bom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
    $offset = if ($bom) { 3 } else { 0 }
    return @{
        Text = [System.Text.Encoding]::UTF8.GetString($bytes, $offset, $bytes.Length - $offset)
        Bom  = $bom
    }
}

function Write-RepoFile {
    param([string]$Path, [string]$Text, [bool]$Bom)
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    if ($Bom) { $bytes = [byte[]](0xEF, 0xBB, 0xBF) + $bytes }
    [System.IO.File]::WriteAllBytes($Path, $bytes)
}

function Get-DeclaredFloor {
    param([string]$RepoRoot)
    $source = $script:Declarations[0]
    $path = Join-Path $RepoRoot $source.File
    if (-not (Test-Path -LiteralPath $path)) { throw "floor source not found: $($source.File)" }
    $text = (Read-RepoFile -Path $path).Text
    $match = [regex]::Match($text, $source.Regex)
    if (-not $match.Success) { throw "declared Python floor not found in $($source.File)" }
    return [regex]::Match($match.Value, '\d+\.\d+').Value
}

function Find-Drift {
    param([string]$RepoRoot, [string]$Floor)
    $problems = @()
    foreach ($decl in $script:Declarations) {
        $path = Join-Path $RepoRoot $decl.File
        if (-not (Test-Path -LiteralPath $path)) {
            $problems += "$($decl.File): missing file"
            continue
        }
        $text = (Read-RepoFile -Path $path).Text
        $matches = [regex]::Matches($text, $decl.Regex)
        if ($matches.Count -eq 0) {
            $problems += "$($decl.File): no declaration matching '$($decl.Template -replace '\{old\}', $Floor)'"
            continue
        }
        foreach ($match in $matches) {
            $found = [regex]::Match($match.Value, '\d+\.\d+').Value
            if ($found -cne $Floor) { $problems += "$($decl.File): declares $found, expected $Floor" }
        }
    }
    return $problems
}

function Resolve-Floor {
    param($Cycles, [datetime]$Today)
    $supported = @()
    if ($Cycles -is [System.Collections.IDictionary]) {
        $entries = @($Cycles.GetEnumerator() | ForEach-Object {
            [pscustomobject]@{ Name = [string]$_.Key; Value = $_.Value }
        })
    } else {
        $entries = @($Cycles.PSObject.Properties)
    }
    foreach ($entry in $entries) {
        $version = $entry.Name
        $detail = $entry.Value
        if ([string]$detail.status -eq 'end-of-life') { continue }
        $eol = [string]$detail.end_of_life
        if ($eol -match '^(\d{4})-(\d{2})') {
            $year = [int]$Matches[1]
            $month = [int]$Matches[2]
            $eolStart = if ($month -eq 12) { [datetime]::new($year + 1, 1, 1) } else { [datetime]::new($year, $month + 1, 1) }
            if ($eolStart -le $Today) { continue }
        }
        $supported += $version
    }
    if ($supported.Count -eq 0) { throw 'no supported Python version in the release calendar' }
    return ($supported | Sort-Object { Get-VersionKey $_ } | Select-Object -First 1)
}

function Fetch-Cycles {
    param([int]$Attempts = 3)
    $lastError = $null
    for ($attempt = 1; $attempt -le $Attempts; $attempt++) {
        try {
            $data = Invoke-RestMethod -Uri $script:PePsUrl -TimeoutSec 30 -UseBasicParsing -ErrorAction Stop
            if (@($data.PSObject.Properties).Count -lt 10) { throw 'release calendar looks incomplete' }
            return $data
        } catch {
            $lastError = $_
            if ($attempt -lt $Attempts) { Start-Sleep -Seconds ([math]::Pow(2, $attempt)) }
        }
    }
    throw "could not fetch $($script:PePsUrl) after $Attempts attempts: $lastError"
}

function Apply-Floor {
    param([string]$RepoRoot, [string]$Old, [string]$New)
    $changed = @()
    foreach ($decl in $script:Declarations) {
        $path = Join-Path $RepoRoot $decl.File
        if (-not (Test-Path -LiteralPath $path)) { continue }
        $file = Read-RepoFile -Path $path
        $rendered = $decl.Template.Replace('{old}', $New)
        $updated = [regex]::Replace($file.Text, $decl.Regex, $rendered)
        if ($updated -cne $file.Text) {
            Write-RepoFile -Path $path -Text $updated -Bom $file.Bom
            $changed += $decl.File
        }
    }
    return $changed
}

function Invoke-Check {
    param([string]$RepoRoot)
    $current = Get-DeclaredFloor -RepoRoot $RepoRoot
    $cycles = Fetch-Cycles
    $desired = Resolve-Floor -Cycles $cycles -Today (Get-Date)
    if ((Get-VersionKey $desired) -lt (Get-VersionKey $current)) {
        Write-Warning "upstream floor $desired is below declared $current; refusing to downgrade"
        $desired = $current
    }
    $changed = $desired -cne $current
    $lines = @("current=$current", "desired=$desired", "changed=$($changed.ToString().ToLowerInvariant())")
    $lines | ForEach-Object { Write-Host $_ }
    if ($env:GITHUB_OUTPUT) {
        [System.IO.File]::AppendAllText($env:GITHUB_OUTPUT, (($lines -join "`n") + "`n"))
    }
    $problems = @(Find-Drift -RepoRoot $RepoRoot -Floor $current)
    if ($problems.Count -gt 0) {
        Write-Host 'floor parity problems:'
        $problems | ForEach-Object { Write-Host "  $_" }
        return 2
    }
    return 0
}

if ($Library) { return }
if (-not $Command) { throw 'Command is required (check or apply)' }
$repoRoot = if ($Root) { $Root } else { Split-Path -Parent $PSScriptRoot }
if ($Command -eq 'check') { exit (Invoke-Check -RepoRoot $repoRoot) }

if ($Version -notmatch '^\d+\.\d+$') { throw "version must look like 3.12 (got: $Version)" }
$old = Get-DeclaredFloor -RepoRoot $repoRoot
if ((Get-VersionKey $Version) -lt (Get-VersionKey $old)) {
    throw "refusing to downgrade the Python floor from $old to $Version"
}
$changed = @(Apply-Floor -RepoRoot $repoRoot -Old $old -New $Version)
Write-Output "Python floor $old -> $Version : $($changed.Count) files updated"
$changed | ForEach-Object { Write-Output "  $_" }
exit 0
