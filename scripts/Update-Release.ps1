<#
=========================================================================
  BRAVE OMEGA PROJECT -- UPDATE-RELEASE.ps1 (v1.0.0)

  Deterministic one-shot release updater. Brings every user-facing
  surface in the repository to a new Brave/Chromium compatibility
  release in a single run. Every transformation is anchored on the
  exact current bytes and asserted (count == expected); a transform
  fails loudly instead of silently producing a malformed file.

  Compatible with Windows PowerShell 5.1 (no pwsh-only syntax).

  USAGE (simulated -- no files written):
    powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Update-Release.ps1 `
      -BraveVersion "1.97.0" -ChromiumVersion "155.0.8100.1" -AdmxVersion "155.1.99.0" `
      -DryRun

  REAL RUN (after -DryRun review):
    ... same args, WITHOUT -DryRun -Regression

  The script never commits or pushes. See AGENTS.md: origin dual-pushes
  to GitHub + GitLab and there is no PR/MR flow for own commits -- a
  human verifies the diff and commits/pushes explicitly.
=========================================================================
#>

[CmdletBinding()]
param(
    # New validated Brave version, e.g. "1.97.0"
    [Parameter(Mandatory = $true)][string]$BraveVersion,

    # New full Chromium version, e.g. "155.0.8100.1"
    [Parameter(Mandatory = $true)][string]$ChromiumVersion,

    # New official ADMX template version, e.g. "155.1.99.0"
    [Parameter(Mandatory = $false)][string]$AdmxVersion,

    # Directory that contains the extracted official policy zip
    # (windows/admx/brave.admx + windows/admx/en-US/brave.adml + VERSION).
    # When provided, admx artifacts are copied INTO the repo.
    [Parameter(Mandatory = $false)][string]$AdmxSourceDir,

    # Windows build used for validation, e.g. "26200.9550"
    [string]$WindowsBuild = "26200.9550",

    # Script version override. Default = current patch + 1 (v2.8.1.0 -> v2.8.2.0).
    [string]$ScriptVersion,

    # Brave upstream release date. Default = ValidationDate - 1 day.
    [string]$BraveReleaseDate,

    # Validation/archive date (ISO yyyy-MM-dd). Default = today.
    [string]$ValidationDate,

    # Skip Wiki/ markdown page updates.
    [switch]$SkipWiki,

    # Do not regenerate enterprise/levels.json + .reg from the script.
    [switch]$SkipCatalogRegen,

    # Do not run Pester / admx-validate / PSScriptAnalyzer after writing.
    [switch]$SkipRegression,

    # Show and validate every transformation without writing any file.
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$script:RepoRoot   = Split-Path -Parent $PSScriptRoot
$script:Text       = ""
$script:Bom        = $false
$script:CurrentFile = ""
$script:Dirty      = $false
$script:FinalText  = @{}
$script:FileBom    = @{}
$script:EditCount  = 0
$script:SkipCount  = 0
$script:FailedPostCheck = $false

# ------------------------------------------------------------------
# Tiny edit logging
# ------------------------------------------------------------------
function Write-Step   { Write-Host ("  {0}" -f $args[0]) -ForegroundColor DarkGray }
function Write-Status { Write-Host ("  [OK] {0}" -f $args[0]) -ForegroundColor Green }
function Write-Skip   { $script:SkipCount++; Write-Host ("  [--] {0} (no change needed)" -f $args[0]) -ForegroundColor DarkGray }
function Write-Warn   { Write-Host ("  [!!] {0}" -f $args[0]) -ForegroundColor Yellow }

function Read-TextFile {
    param([string]$Path)
    $bytes = [System.IO.File]::ReadAllBytes($Path)
    $hasBom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    if ($hasBom) { $text = $text.Substring(1) }
    return [pscustomobject]@{ Text = $text; HasBom = $hasBom }
}

function Write-TextFile {
    param([string]$Path, [string]$Text, [bool]$HasBom)
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    if ($HasBom) {
        $out = New-Object byte[] ($bytes.Length + 3)
        $out[0] = 0xEF; $out[1] = 0xBB; $out[2] = 0xBF
        [System.Array]::Copy($bytes, 0, $out, 3, $bytes.Length)
        $bytes = $out
    }
    [System.IO.File]::WriteAllBytes($Path, $bytes)
}

function Get-Eol {
    param([string]$Text)
    if (([regex]::Matches($Text, "`r`n")).Count -gt 0) { return "`r`n" }
    return "`n"
}

function Convert-ToFileEol {
    param([string]$Block, [string]$Eol)
    return $Block.Replace("`r`n", "`n").Replace("`n", $Eol)
}

function Expand-Skel {
    param([string]$Skel, [System.Collections.IDictionary]$Vars)
    foreach ($key in $Vars.Keys) {
        $Skel = $Skel.Replace("{{$key}}", [string]$Vars[$key])
    }
    return $Skel
}

# Turkish non-ASCII -> \uXXXX escape (index.html TR dict convention).
function ConvertTo-JsEscape {
    param([string]$Text)
    $sb = New-Object System.Text.StringBuilder
    foreach ($ch in $Text.ToCharArray()) {
        $code = [int]$ch
        if ($code -gt 127)     { [void]$sb.Append('\u'); [void]$sb.Append($code.ToString('x4')) }
        elseif ($ch -eq '"')   { [void]$sb.Append('\"') }
        elseif ($ch -eq '\')   { [void]$sb.Append('\\') }
        else                   { [void]$sb.Append($ch) }
    }
    return $sb.ToString()
}

function Format-DateTr {
    param([datetime]$Date)
    $months = @('Ocak','Şubat','Mart','Nisan','Mayıs','Haziran','Temmuz','Ağustos','Eylül','Ekim','Kasım','Aralık')
    return ('{0} {1} {2}' -f $Date.Day, $months[$Date.Month - 1], $Date.Year)
}

function Format-DateEn {
    param([datetime]$Date)
    return $Date.ToString('MMMM d, yyyy', [System.Globalization.CultureInfo]::GetCultureInfo('en-US'))
}

# ------------------------------------------------------------------
# Edit engine. Every edit asserts the anchor was found the expected
# number of times; inserting operations are guarded (idempotent).
# ------------------------------------------------------------------
function Edit-Literal {
    param([string]$Old, [string]$New, [string]$Label, [int]$ExpectedCount = 1)
    $count = ([regex]::Matches($script:Text, [regex]::Escape($Old))).Count
    if ($count -ne $ExpectedCount) {
        $preview = if ($Old.Length -gt 60) { $Old.Substring(0, 60) + "..." } else { $Old }
        throw "Edit '$Label' [$script:CurrentFile]: expected $ExpectedCount occurrence(s) of anchor, found $count.`n  anchor: <$preview>"
    }
    $script:Text = $script:Text.Replace($Old, $New)
    $script:Dirty = $true
    $script:EditCount++
}

function Edit-Regex {
    param([string]$Pattern, [string]$Replacement, [string]$Label, [int]$ExpectedCount = 1)
    $rx = New-Object System.Text.RegularExpressions.Regex($Pattern)
    $count = $rx.Matches($script:Text).Count
    if ($count -ne $ExpectedCount) {
        throw "Edit '$Label' [$script:CurrentFile]: regex expected $ExpectedCount match(es), found $count.`n  pattern: <$Pattern>"
    }
    $script:Text = $rx.Replace($script:Text, $Replacement)
    $script:Dirty = $true
    $script:EditCount++
}

# Replace all occurrences (must be at least MinCount).
function Edit-Global {
    param([string]$Old, [string]$New, [string]$Label, [int]$MinCount = 1)
    $count = ([regex]::Matches($script:Text, [regex]::Escape($Old))).Count
    if ($count -lt $MinCount) {
        throw "Edit '$Label' [$script:CurrentFile]: expected at least $MinCount occurrence(s), found $count.`
  anchor: <$($Old.Substring(0, [Math]::Min(60, $Old.Length)))...>"
    }
    if ($count -gt 0) {
        $script:Text = $script:Text.Replace($Old, $New)
        $script:Dirty = $true
        $script:EditCount += $count
    }
}

# Insert Block before the Nth occurrence of Anchor. Guarded by GuardLiteral.
function Insert-BeforeNth {
    param([string]$Anchor, [string]$InsertText, [string]$Label, [string]$GuardLiteral = "", [int]$Nth = 0)
    if ($GuardLiteral -and $script:Text.Contains($GuardLiteral)) {
        Write-Skip $Label
        return
    }
    $rel = 0; $seen = 0; $hit = -1
    do {
        $rel = $script:Text.IndexOf($Anchor, $rel, [System.StringComparison]::Ordinal)
        if ($rel -lt 0) { break }
        if ($seen -eq $Nth) { $hit = $rel; break }
        $rel += $Anchor.Length
        $seen++
    } while ($true)
    if ($hit -lt 0) {
        throw "Insert '$Label' [$script:CurrentFile]: Nth=$Nth occurrence of anchor not found: <$($Anchor.Substring(0, [Math]::Min(60, $Anchor.Length)))...>"
    }
    $script:Text = $script:Text.Insert($hit, $InsertText)
    $script:Dirty = $true
    $script:EditCount++
}

# Insert a sibling line (e.g. new dict key) directly after the line that
# contains AnchorSubstring, matching that line's leading whitespace.
function Insert-KeyLineAfter {
    param([string]$AnchorSubstring, [string]$NewLine, [string]$Label, [string]$GuardSubstring = "")
    if ($GuardSubstring -and $script:Text.Contains($GuardSubstring)) {
        Write-Skip $Label
        return
    }
    $i = $script:Text.IndexOf($AnchorSubstring, [System.StringComparison]::Ordinal)
    if ($i -lt 0) {
        throw "Insert '$Label' [$script:CurrentFile]: anchor substring not found: <$($AnchorSubstring.Substring(0, [Math]::Min(60, $AnchorSubstring.Length)))...>"
    }
    $lineStart = $script:Text.LastIndexOf("`n", $i)
    if ($lineStart -lt 0) { $lineStart = -1 }
    $lineStart++
    $lineEnd = $script:Text.IndexOf("`n", $i)
    if ($lineEnd -lt 0) { $lineEnd = $script:Text.Length }
    $prefix  = $script:Text.Substring($lineStart, $i - $lineStart)
    $wsMatch = [regex]::Match($prefix, '^[ \t]*')
    $ws = $wsMatch.Value
    $eol = Get-Eol $script:Text
    $textToInsert = $ws + $NewLine + $eol
    $insertAt = $lineEnd + $eol.Length
    $script:Text = $script:Text.Insert($insertAt, $textToInsert)
    $script:Dirty = $true
    $script:EditCount++
}

# Sequential renumber of a numbered TOC list ("### Table of Contents" /
# "### İçindekiler") up to the first following "---" line.
function Update-TocNumbers {
    param([string]$Marker, [string]$Label)
    $lines = $script:Text -split "`n"
    $start = -1
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i].Contains($Marker)) { $start = $i; break }
    }
    if ($start -lt 0) { throw "Renumber '$Label': TOC marker not found: $Marker" }
    $end = -1
    for ($j = $start + 1; $j -lt $lines.Length; $j++) {
        if ($lines[$j].Trim() -eq '---') { $end = $j; break }
    }
    if ($end -lt 0) { throw "Renumber '$Label': closing '---' not found after marker" }
    $n = 1
    for ($k = $start + 1; $k -lt $end; $k++) {
        if ($lines[$k] -match '^\d+\. ') {
            $lines[$k] = [regex]::Replace($lines[$k], '^\d+(?=\. )', [string]$n)
            $n++
        }
    }
    $script:Text = $lines -join "`n"
    $script:Dirty = $true
    $script:EditCount++
}

# ------------------------------------------------------------------
# File processing driver
# ------------------------------------------------------------------
function Process-File {
    param([string]$RelativePath, [string]$Label, [scriptblock]$Block)
    $path = Join-Path $script:RepoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $path)) {
        Write-Warn "$Label skipped: file not found ($RelativePath)"
        return
    }
    if ($script:FinalText.ContainsKey($RelativePath)) {
        $script:Text = $script:FinalText[$RelativePath]
    } else {
        $reader = Read-TextFile -Path $path
        $script:Text = $reader.Text
        $script:FileBom[$RelativePath] = $reader.HasBom
    }
    $script:Bom = $script:FileBom[$RelativePath]
    $script:CurrentFile = $RelativePath
    $script:Dirty = $false
    $before = $script:EditCount
    & $Block
    $did = $script:EditCount - $before
    $script:FinalText[$RelativePath] = $script:Text
    if (-not $script:Dirty) { Write-Skip $Label }
    else {
        Write-Status ("{0} ({1} anchor edit(s))" -f $Label, $did)
        if (-not $DryRun) { Write-TextFile -Path $path -Text $script:Text -HasBom $script:Bom }
    }
}

function Assert-FileValue {
    param([string]$RelativePath, [string]$Pattern, [string]$Label)
    $text = $script:FinalText[$RelativePath]
    if ($null -eq $text) { throw "Post-check '$Label': file not processed: $RelativePath" }
    $rx = New-Object System.Text.RegularExpressions.Regex($Pattern)
    if ($rx.IsMatch($text)) {
        $m = $rx.Match($text)
        $snippet = $m.Value
        throw "Post-check FAILED '$Label' [$RelativePath]: stale pattern still present: <$snippet>"
    }
}

# ==================================================================
# 1. DETECT CURRENT STATE + BUILD VARS
# ==================================================================
$rawScript = (Read-TextFile -Path (Join-Path $script:RepoRoot 'Brave Omega\BraveOmega.ps1')).Text

function Get-ScriptVersionValue {
    param([string]$Text, [string]$Pattern)
    $m = [regex]::Match($Text, $Pattern)
    if (-not $m.Success) { throw "Could not detect value with pattern: $Pattern" }
    return $m.Groups[1].Value
}

$oldScriptVer = Get-ScriptVersionValue -Text $rawScript -Pattern '\$ScriptVersion\s*=\s*"([^"]+)"'
$oldBrave     = Get-ScriptVersionValue -Text $rawScript -Pattern '\$ValidatedBrave\s*=\s*"([^"]+)"'
$oldChromium  = Get-ScriptVersionValue -Text $rawScript -Pattern '\$ValidatedChromium\s*=\s*"([^"]+)"'
$oldChromiumFull = Get-ScriptVersionValue -Text $rawScript -Pattern 'Chromium:\s*([\d.]+)'
$oldWinBuild  = Get-ScriptVersionValue -Text $rawScript -Pattern 'Build ([\d.]+)'

$oldAdmxVer = ""
$versionFilePath = Join-Path $script:RepoRoot 'admx\VERSION_BRAVE_ADMX'
if (Test-Path -LiteralPath $versionFilePath) {
    $vfc = Get-Content -LiteralPath $versionFilePath -Raw -ErrorAction SilentlyContinue
    if ($vfc) {
        $maj = [regex]::Match($vfc, 'MAJOR=([^\r\n]+)').Groups[1].Value
        $min = [regex]::Match($vfc, 'MINOR=([^\r\n]+)').Groups[1].Value
        $bld = [regex]::Match($vfc, 'BUILD=([^\r\n]+)').Groups[1].Value
        $pat = [regex]::Match($vfc, 'PATCH=([^\r\n]+)').Groups[1].Value
        $oldAdmxVer = "$maj.$min.$bld.$pat"
    }
}

# Default script version = current patch + 1  (v2.8.1.0 -> v2.8.2.0)
if (-not $ScriptVersion) {
    $parts = $oldScriptVer.TrimStart('v') -split '\.'
    if ($parts.Count -ne 4) { throw "Unexpected script version format: $oldScriptVer" }
    $ScriptVersion = 'v{0}.{1}.{2}.{3}' -f $parts[0], $parts[1], ([int]$parts[2] + 1), $parts[3]
}

# Defaults for dates
if (-not $ValidationDate) {
    $ValidationDate = Get-Date -Format 'yyyy-MM-dd'
}
if (-not $BraveReleaseDate) {
    $BraveReleaseDate = (Get-Date $ValidationDate).AddDays(-1).ToString('yyyy-MM-dd')
}
$vd = Get-Date $ValidationDate
$br = Get-Date $BraveReleaseDate

if (-not $ChromiumVersion) { $ChromiumVersion = "$($oldChromium).0.0.0" }
$newChromiumMajor = $ChromiumVersion.Split('.')[0]

# Early exit: repository already at requested targets.
if ($oldScriptVer -eq $ScriptVersion -and $oldBrave -eq $BraveVersion -and $oldChromium -eq $newChromiumMajor) {
    Write-Host "Repository is already at $ScriptVersion / Brave $BraveVersion / Chromium $newChromiumMajor -- nothing to do." -ForegroundColor Green
    exit 0
}

$v = [ordered]@{
    OldScriptVer        = $oldScriptVer
    NewScriptVer        = $ScriptVersion
    OldScriptVerNums    = $oldScriptVer.TrimStart('v')
    NewScriptVerNums    = $ScriptVersion.TrimStart('v')
    OldKeyBase          = $oldScriptVer.TrimStart('v').Replace('.', '')
    NewKeyBase          = $ScriptVersion.TrimStart('v').Replace('.', '')
    OldBrave            = $oldBrave
    NewBrave            = $BraveVersion
    OldBraveEsc         = [System.Text.RegularExpressions.Regex]::Escape($oldBrave)
    NewBraveEsc         = [System.Text.RegularExpressions.Regex]::Escape($BraveVersion)
    OldChromium         = $oldChromium
    NewChromiumMajor    = $newChromiumMajor
    OldChromiumFull     = $oldChromiumFull
    NewChromiumFull     = $ChromiumVersion
    OldWindowsBuild     = $oldWinBuild
    NewWindowsBuild     = $WindowsBuild
    OldAdmxVersion      = $oldAdmxVer
    NewAdmxVersion      = $AdmxVersion
    ChainArrow          = '24 → 51 → 83 → 123 → 151'
    ChainPlain          = '24→51→83→123→151'
    ChainIndex          = 'BraveOnly 24 / Essential 51 / Balanced 83 / Advanced 123 / Strict 151'
    ValidationDateIso   = $ValidationDate
    ValidationDateEn    = Format-DateEn -Date $vd
    ValidationDateTr    = Format-DateTr -Date $vd
    BraveReleaseDateEn  = Format-DateEn -Date $br
    BraveReleaseDateTr  = Format-DateTr -Date $br
}

$buildChanged   = ($oldWinBuild -ne $WindowsBuild)
$admxChanged    = ($oldAdmxVer -ne $AdmxVersion)

Write-Host ""
Write-Host "BRAVE OMEGA RELEASE UPDATER" -ForegroundColor Cyan
Write-Host ("  {0,-16} {1,-22} -> {2}" -f "Script version", $oldScriptVer, $ScriptVersion) -ForegroundColor White
Write-Host ("  {0,-16} {1,-22} -> {2}" -f "Brave", $oldBrave, $BraveVersion) -ForegroundColor White
Write-Host ("  {0,-16} {1,-22} -> {2}" -f "Chromium", $oldChromiumFull, $ChromiumVersion) -ForegroundColor White
Write-Host ("  {0,-16} {1,-22} -> {2}" -f "Windows build", $oldWinBuild, $WindowsBuild) -ForegroundColor White
Write-Host ("  {0,-16} {1,-22} -> {2}" -f "ADMX", $oldAdmxVer, $AdmxVersion) -ForegroundColor White
Write-Host ("  {0,-16} {1}" -f "Validation date", $ValidationDate) -ForegroundColor White
if ($DryRun) {
    Write-Host ""
    Write-Host "DRY RUN -- validating every anchor; NO files will be written." -ForegroundColor Yellow
    Write-Host ""
}

# ==================================================================
# 2. VERSION CONSTANT + HEADER (BraveOmega.ps1)
# ==================================================================
$T_HeaderBlock = @'
# v{{NewScriptVerNums}}             Patch release — Brave {{NewBrave}} compatibility validation:
#
#     [CHANGED]     Validated against Brave {{NewBrave}} (Chromium {{NewChromiumFull}}),
#                   released {{BraveReleaseDateEn}}. Brave {{OldBrave}} (Chromium
#                   {{OldChromiumFull}}) remains supported.
#
#     [UNCHANGED]   No policy changes. Totals remain 151 across 5 tiers
#                   (chain: 24 → 51 → 83 → 123 → 151).
#
'@

Process-File 'Brave Omega\BraveOmega.ps1' 'BraveOmega.ps1 body' {
    Edit-Literal -Old ('$ScriptVersion   = "' + $v.OldScriptVer + '"') -New ('$ScriptVersion   = "' + $v.NewScriptVer + '"') -Label 'constants: ScriptVersion'
    Edit-Literal -Old ('$ValidatedBrave  = "' + $v.OldBrave + '"') -New ('$ValidatedBrave  = "' + $v.NewBrave + '"') -Label 'constants: ValidatedBrave'
    Edit-Literal -Old ('$ValidatedChromium = "' + $v.OldChromium + '"') -New ('$ValidatedChromium = "' + $v.NewChromiumMajor + '"') -Label 'constants: ValidatedChromium'
    Edit-Literal -Old ('# VERSION CONTEXT  : Windows 11 25H2 (Build ' + $v.OldWindowsBuild + ')') -New ('# VERSION CONTEXT  : Windows 11 25H2 (Build ' + $v.NewWindowsBuild + ')') -Label 'header: version context build'
    Edit-Literal -Old ('#                    Brave ' + $v.OldBrave + ' (Official Build) (64 bit) Chromium: ' + $v.OldChromiumFull) -New ('#                    Brave ' + $v.NewBrave + ' (Official Build) (64 bit) Chromium: ' + $v.NewChromiumFull) -Label 'header: brave/chromium line'
    Edit-Literal -Old ('    Brave ' + $v.OldBrave + ', dated ' + $v.BraveReleaseDateEn + ',') -New ('    Brave ' + $v.NewBrave + ', dated ' + $v.BraveReleaseDateEn + ',') -Label 'header: channel warning date'
    Edit-Literal -Old ('# CHANGELOG (' + $v.OldScriptVer + ')') -New ('# CHANGELOG (' + $v.NewScriptVer + ')') -Label 'header: CHANGELOG label'
    $headerBlock = Expand-Skel -Skel $T_HeaderBlock -Vars $v
    $eol = Get-Eol $script:Text
    $insert = Convert-ToFileEol -Block $headerBlock -Eol $eol
    Insert-BeforeNth -Anchor ('# v' + $v.OldScriptVerNums) -InsertText $insert -Label ('header: insert ' + $v.NewScriptVer + ' changelog entry') -GuardLiteral ('v' + $v.NewScriptVerNums) -Nth 0
}

# ==================================================================
# 3. TESTS
# ==================================================================
Process-File 'Tests\ScriptVersion.Tests.ps1' 'Tests/ScriptVersion.Tests.ps1' {
    Edit-Literal -Old ('Should -BeExactly "' + $v.OldScriptVer + '"') -New ('Should -BeExactly "' + $v.NewScriptVer + '"') -Label 'ScriptVersion.Tests: script version'
    Edit-Literal -Old ('"' + $v.OldChromium + '"') -New ('"' + $v.NewChromiumMajor + '"') -Label 'ScriptVersion.Tests: chromium regex'
}

Process-File 'Tests\VersionCheck.Tests.ps1' 'Tests/VersionCheck.Tests.ps1' {
    Edit-Literal -Old ('"' + $v.OldBraveEsc + '"') -New ('"' + $v.NewBraveEsc + '"') -Label 'VersionCheck: validated brave regex'
    Edit-Literal -Old ('"' + $v.OldChromium + '"') -New ('"' + $v.NewChromiumMajor + '"') -Label 'VersionCheck: validated chromium regex'
    Edit-Literal -Old ('$braveVersion = "' + $v.OldBrave + '"') -New ('$braveVersion = "' + $v.NewBrave + '"') -Label 'VersionCheck: fixture brave'
    Edit-Literal -Old ('$ValidatedBrave = "' + $v.OldBrave + '"') -New ('$ValidatedBrave = "' + $v.NewBrave + '"') -Label 'VersionCheck: fixture validated'
}

Process-File 'Tests\Get-BraveVersion.Tests.ps1' 'Tests/Get-BraveVersion.Tests.ps1' {
    $mockOld = $v.OldChromium + '.1.' + $v.OldBrave.TrimStart('1.')
    $mockNew = $v.NewChromiumMajor + '.1.' + $v.NewBrave.TrimStart('1.')
    Edit-Literal -Old $mockOld -New $mockNew -Label 'Get-BraveVersion: mock ProductVersion'
    Edit-Literal -Old ('Should -Be "' + $v.OldBrave + '"') -New ('Should -Be "' + $v.NewBrave + '"') -Label 'Get-BraveVersion: expected brave'
}

Process-File 'Tests\StaleCleanup.Tests.ps1' 'Tests/StaleCleanup.Tests.ps1' {
    Edit-Literal -Old ('Describe "Stale Policy Cleanup - ' + $v.OldScriptVer + '"') -New ('Describe "Stale Policy Cleanup - ' + $v.NewScriptVer + '"') -Label 'StaleCleanup: describe'
    Edit-Literal -Old ('Should -Be "' + $v.OldScriptVer + '"') -New ('Should -Be "' + $v.NewScriptVer + '"') -Label 'StaleCleanup: version'
}

Process-File 'Tests\FullPipeline-TR.Tests.ps1' 'Tests/FullPipeline-TR.Tests.ps1' {
    Edit-Literal -Old ('Should -BeExactly "' + $v.OldScriptVer + '"') -New ('Should -BeExactly "' + $v.NewScriptVer + '"') -Label 'FullPipeline-TR: version'
}

Process-File 'Tests\TestHelper.ps1' 'Tests/TestHelper.ps1' {
    Edit-Literal -Old ('Version = "' + $v.OldBrave + '"') -New ('Version = "' + $v.NewBrave + '"') -Label 'TestHelper: brave default'
    Edit-Literal -Old ('ChromiumMajor = "' + $v.OldChromium + '"') -New ('ChromiumMajor = "' + $v.NewChromiumMajor + '"') -Label 'TestHelper: chromium default'
}

# ==================================================================
# 4. README / SUPPORT / SECURITY / AGENTS
# ==================================================================
Process-File 'README.md' 'README.md' {
    Edit-Literal -Old ('Brave-' + $v.OldBrave + '%20%7C%20Chromium%20' + $v.OldChromium) -New ('Brave-' + $v.NewBrave + '%20%7C%20Chromium%20' + $v.NewChromiumMajor) -Label 'README: brave badge'
    # EN matrix: current+demote
    $enRow = '| **' + $v.OldScriptVer + '** *(current)* | ' + $v.OldBrave + ' | ' + $v.OldChromium + ' | 11 25H2 | ✅ Active |'
    if ($script:Text.Contains($enRow)) {
        $eol = Get-Eol $script:Text
        $insert = ('{0}{1}{2}' -f ('| **' + $v.NewScriptVer + '** *(current)* | ' + $v.NewBrave + ' | ' + $v.NewChromiumMajor + ' | 11 25H2 | ✅ Active |'), $eol, ('| ' + $v.OldScriptVer + ' | ' + $v.OldBrave + ' | ' + $v.OldChromium + ' | 11 25H2 | 📦 Previous |'))
        Edit-Literal -Old $enRow -New $insert -Label 'README: EN matrix current+demote'
    } else {
        throw "README EN current matrix row not found: $enRow"
    }
    # TR matrix: current+demote
    $trCheck = '| **' + $v.OldScriptVer + '** *(güncel)*'
    if ($script:Text.Contains($trCheck)) {
        $trRow = '| **' + $v.OldScriptVer + '** *(güncel)* | ' + $v.OldBrave + ' | ' + $v.OldChromium + ' | 11 25H2 | ✅ Etkin |'
        Edit-Literal -Old $trRow -New ('| **' + $v.NewScriptVer + '** *(güncel)* | ' + $v.NewBrave + ' | ' + $v.NewChromiumMajor + ' | 11 25H2 | ✅ Etkin |' + (Get-Eol $script:Text) + '| ' + $v.OldScriptVer + ' | ' + $v.OldBrave + ' | ' + $v.OldChromium + ' | 11 25H2 | 📦 Önceki |') -Label 'README: TR matrix current+demote'
    }
    Edit-Literal -Old ('(currently Brave ' + $v.OldBrave + ' / Chromium ' + $v.OldChromium + ')') -New ('(currently Brave ' + $v.NewBrave + ' / Chromium ' + $v.NewChromiumMajor + ')') -Label 'README: EN channel note'
    Edit-Literal -Old ('(güncel Brave ' + $v.OldBrave + ' / Chromium ' + $v.OldChromium + ')') -New ('(güncel Brave ' + $v.NewBrave + ' / Chromium ' + $v.NewChromiumMajor + ')') -Label 'README: TR channel note'
}

Process-File 'SUPPORT.md' 'SUPPORT.md' {
    Edit-Literal -Old ('Brave-' + $v.OldBrave + '%20%7C%20Chromium%20' + $v.OldChromium) -New ('Brave-' + $v.NewBrave + '%20%7C%20Chromium%20' + $v.NewChromiumMajor) -Label 'SUPPORT: brave badge'
    Edit-Literal -Old ('| Brave | Stable ' + $v.OldBrave + ' (Chromium ' + $v.OldChromium + ')') -New ('| Brave | Stable ' + $v.NewBrave + ' (Chromium ' + $v.NewChromiumMajor + ')') -Label 'SUPPORT: EN brave row'
    Edit-Literal -Old ('| Brave | Kararlı ' + $v.OldBrave + ' (Chromium ' + $v.OldChromium + ')') -New ('| Brave | Kararlı ' + $v.NewBrave + ' (Chromium ' + $v.NewChromiumMajor + ')') -Label 'SUPPORT: TR brave row'
}

Process-File 'SECURITY.md' 'SECURITY.md' {
    $badgeOld = 'Brave-' + $v.OldBrave + '%20%7C%20Chromium%20' + $v.OldChromium
    if ($script:Text.Contains($badgeOld)) {
        Edit-Literal -Old $badgeOld -New ('Brave-' + $v.NewBrave + '%20%7C%20Chromium%20' + $v.NewChromiumMajor) -Label 'SECURITY: brave badge'
    }
    Edit-Literal -Old ('(currently ' + $v.OldScriptVer + ')') -New ('(currently ' + $v.NewScriptVer + ')') -Label 'SECURITY: EN current version'
    Edit-Literal -Old ('(şu an ' + $v.OldScriptVer + ')') -New ('(şu an ' + $v.NewScriptVer + ')') -Label 'SECURITY: TR current version'
}

Process-File 'AGENTS.md' 'AGENTS.md' {
    Edit-Global -Old ('| Script | `' + $v.OldScriptVer + '` |') -New ('| Script | `' + $v.NewScriptVer + '` |') -Label 'AGENTS: script version rows' -MinCount 1
    Edit-Global -Old ('| Betik | `' + $v.OldScriptVer + '` |') -New ('| Betik | `' + $v.NewScriptVer + '` |') -Label 'AGENTS: TR script version rows' -MinCount 1
    Edit-Global -Old ('| Brave | `' + $v.OldBrave + '` |') -New ('| Brave | `' + $v.NewBrave + '` |') -Label 'AGENTS: brave rows' -MinCount 2
    Edit-Global -Old ('| Chromium | `' + $v.OldChromium + '` |') -New ('| Chromium | `' + $v.NewChromiumMajor + '` |') -Label 'AGENTS: chromium rows' -MinCount 2
}

# ==================================================================
# 5. index.html
# ==================================================================

$T_ClEn = 'cl_v{{NewKeyBase}}: "Compatibility validation - Brave {{NewBrave}} (Chromium {{NewChromiumFull}}) validation, released {{BraveReleaseDateEn}}. Brave {{OldBrave}} (Chromium {{OldChromiumFull}}) remains supported; ADMX artifacts refreshed to official {{NewAdmxVersion}} policy templates; no policy changes and no regressions observed across all 5 tiers; totals remain 151; cumulative chain: {{ChainIndex}}",'
$T_ClTr = 'cl_v{{NewKeyBase}}: "Uyumluluk doğrulaması - Brave {{NewBrave}} (Chromium {{NewChromiumFull}}) doğrulaması, {{BraveReleaseDateTr}} tarihinde yayınlandı. Brave {{OldBrave}} (Chromium {{OldChromiumFull}}) sürümü desteklenmeye devam ediyor; ADMX yapıtları resmî {{NewAdmxVersion}} politika şablonlarıyla tazelendi; politika değişikliği yok ve 5 seviyenin tamamında gerileme gözlenmedi; toplam 151 olarak kalır; kümülatif zincir: {{ChainIndex}}",'

Process-File 'index.html' 'index.html' {
    # hero
    $hero = '>v' + $v.OldScriptVerNums + '</span>'
    if ($script:Text.Contains($hero)) {
        Edit-Literal -Old $hero -New ('>v' + $v.NewScriptVerNums + '</span>') -Label 'index: hero badge'
    }
    Edit-Literal -Old ('Brave ' + $v.OldBrave + ' <span class="text-gray-600">/</span> Chromium ' + $v.OldChromium) -New ('Brave ' + $v.NewBrave + ' <span class="text-gray-600">/</span> Chromium ' + $v.NewChromiumMajor) -Label 'index: hero brave/chromium'
    Edit-Global -Old ('Brave Omega ' + $v.OldScriptVer) -New ('Brave Omega ' + $v.NewScriptVer) -Label 'index: terminal inline version(s)' -MinCount 2
    # prereq browser inline
    $prereqOld = '(' + $v.OldBrave + ' önerilir)'
    if ($script:Text.Contains($prereqOld)) {
        Edit-Literal -Old $prereqOld -New ('(' + $v.NewBrave + ' önerilir)') -Label 'index: prereq browser inline'
    }
    # stale policies_desc markup repair (actual stale byte: v2.8.0.0) -> NEW version
    Edit-Regex -Pattern 'data-i18n="policies_desc">v[\d.]+ ile birlikte' -Replacement ('data-i18n="policies_desc">' + $v.NewScriptVer + ' ile birlikte') -Label 'index: policies_desc markup stale repair' -ExpectedCount 1
    # compatibility table: current row + demote
    $oldCompatRow = $null
    $mChem = [regex]::Match($script:Text, '<tr class="security-row">(?s:<td class="py-3 px-4 font-mono text-sm font-bold text-\[#22c55e\]">v' + $v.OldScriptVerNums + '.*?</tr>)')
    if ($mChem.Success) { $oldCompatRow = $mChem.Value }
    if ($oldCompatRow) {
        $eol = Get-Eol $script:Text
        $newRow = ('<tr class="security-row"><td class="py-3 px-4 font-mono text-sm font-bold text-[#22c55e]">v' + $v.NewScriptVerNums + ' <span class="text-[10px] font-normal text-gray-500" data-i18n="compat_current">(current)</span></td><td class="py-3 px-4 text-sm">' + $v.NewBrave + '</td><td class="py-3 px-4 text-sm">' + $v.NewChromiumMajor + '</td><td class="py-3 px-4 text-sm">11 25H2</td><td class="py-3 px-4"><span class="badge badge-green" data-i18n="compat_status_active">&#x2705; Aktif</span></td></tr>')
        $demoteRow = ('<tr class="security-row"><td class="py-3 px-4 font-mono text-sm text-gray-300">v' + $v.OldScriptVerNums + '</td><td class="py-3 px-4 text-sm text-gray-400">' + $v.OldBrave + '</td><td class="py-3 px-4 text-sm text-gray-400">' + $v.OldChromium + '</td><td class="py-3 px-4 text-sm text-gray-400">11 25H2</td><td class="py-3 px-4"><span class="badge badge-gray" data-i18n="compat_status_previous">&#x1F517; Önceki</span></td></tr>')
        $script:Text = $script:Text.Replace($oldCompatRow, ($newRow + $eol + $demoteRow))
        $script:Dirty = $true; $script:EditCount++
    } else {
        Write-Verbose 'index: compatibility current row unchanged (anchor not found -- will validate via post-check)'
    }
    # changelog table: current row + demote
    $oldChRow = $null
    $mChl = [regex]::Match($script:Text, '<tr class="security-row">(?s:<td class="py-3 px-4 font-mono text-sm font-bold text-\[#22c55e\]">v' + $v.OldScriptVerNums + '</td>.*?</tr>)')
    if ($mChl.Success) { $oldChRow = $mChl.Value }
    if ($oldChRow) {
        $enText = Expand-Skel -Skel $T_ClEn -Vars $v
        $enText = ($enText -split '"', 2)[1]
        $enText = $enText.TrimEnd('",')
        $eol = Get-Eol $script:Text
        $newRow = ('<tr class="security-row"><td class="py-3 px-4 font-mono text-sm font-bold text-[#22c55e]">v' + $v.NewScriptVerNums + '</td><td class="py-3 px-4 text-sm">' + $v.ValidationDateIso + '</td><td class="py-3 px-4 text-sm">151</td><td class="py-3 px-4 text-gray-400 text-sm hidden md:table-cell" data-i18n="cl_v' + $v.NewKeyBase + '">' + $enText + '</td></tr>')
        $demoteRow = ('<tr class="security-row"><td class="py-3 px-4 font-mono text-sm text-gray-300">v' + $v.OldScriptVerNums + '</td><td class="py-3 px-4 text-sm">' + $v.ValidationDateIso + '</td><td class="py-3 px-4 text-sm">151</td><td class="py-3 px-4 text-gray-400 text-sm hidden md:table-cell" data-i18n="cl_v' + $v.OldKeyBase + '">' + ($oldChRow -replace '^.*data-i18n="cl_v' + $v.OldKeyBase + '">(.*)</td></tr>.*$', '$1') + '</td></tr>')
        $script:Text = $script:Text.Replace($oldChRow, ($newRow + $eol + $demoteRow))
        $script:Dirty = $true; $script:EditCount++
    } else {
        Write-Verbose 'index: changelog current row (anchor not found -- will validate via post-check)'
    }
    # dict: cl_v2820 lines
    $enKeyOld = 'cl_v' + $v.OldKeyBase + ': "Compatibility validation - Brave '
    $trKeyOld = 'cl_v' + $v.OldKeyBase + ': "Uyum'
    $enLine = Expand-Skel -Skel $T_ClEn -Vars $v
    $trLine = ConvertTo-JsEscape -Text (Expand-Skel -Skel $T_ClTr -Vars $v)
    Insert-KeyLineAfter -AnchorSubstring $enKeyOld -NewLine $enLine -Label 'index: dict cl_v2820 (EN)' -GuardSubstring ('cl_v' + $v.NewKeyBase + ': "Compatibility validation')
    Insert-KeyLineAfter -AnchorSubstring $trKeyOld -NewLine $trLine -Label 'index: dict cl_v2820 (TR)' -GuardSubstring ('cl_v' + $v.NewKeyBase + ': "Uyumluluk')
    # dict: policies_desc version
    Edit-Literal -Old ('with ' + $v.OldScriptVer + ' \u2014 unified bilingual script') -New ('with ' + $v.NewScriptVer + ' \u2014 unified bilingual script') -Label 'index: dict policies_desc (EN)'
    Edit-Literal -Old ($v.OldScriptVer + ' ile birlikte') -New ($v.NewScriptVer + ' ile birlikte') -Label 'index: dict policies_desc (TR)'
    # dict: prereq browser recommended
    Edit-Literal -Old ('(' + $v.OldBrave + ' recommended)') -New ('(' + $v.NewBrave + ' recommended)') -Label 'index: dict prereq browser (EN)'
    Edit-Literal -Old ('(' + $v.OldBrave + ' \u00f6nerilir)') -New ('(' + $v.NewBrave + ' \u00f6nerilir)') -Label 'index: dict prereq browser (TR)'
    if ($buildChanged) {
        Edit-Literal -Old ('build ' + $v.OldWindowsBuild) -New ('build ' + $v.NewWindowsBuild) -Label 'index: build tokens'
    }
}

# ==================================================================
# 6. CHANGELOG.md
# ==================================================================
$T_ChangelogEn = @'
<a id="en-v{{NewKeyBase}}"></a>

## [v{{NewScriptVerNums}}] — {{ValidationDateIso}}

<a id="en-v{{NewKeyBase}}-summary"></a>

### Summary

**Brave {{NewBrave}} compatibility validation.** {{NewScriptVer}} validates the configuration against Brave {{NewBrave}} (Chromium {{NewChromiumFull}}), released {{BraveReleaseDateEn}}. Brave {{OldBrave}} (Chromium {{OldChromiumFull}}) remains supported. No policies changed: totals remain **151** across 5 tiers; cumulative chain remains 24 → 51 → 83 → 123 → 151.

| Metric | Before ({{OldScriptVer}}) | After ({{NewScriptVer}}) |
|--------|---------------------------|---------------------------|
| Hardening levels | 5 | 5 |
| Total policies | 151 | **151** (no change) |
| Cumulative chain | 24→51→83→123→151 | **24→51→83→123→151** |
| Script version | {{OldScriptVer}} | {{NewScriptVer}} |
| Validated Brave | {{OldBrave}} | {{NewBrave}} |
| Validated Chromium | {{OldChromiumFull}} | {{NewChromiumFull}} |

<a id="en-v{{NewKeyBase}}-changed"></a>

### Changed

- **BraveOmega.ps1** — `$ScriptVersion` → `{{NewScriptVer}}`; `$ValidatedBrave` → `{{NewBrave}}`; `$ValidatedChromium` → `{{NewChromiumMajor}}`; header changelog, version context, and channel warning updated.

- **ADMX artifacts** — `admx/brave.admx` + `admx/brave.adml` + `admx/VERSION_BRAVE_ADMX` refreshed to official {{NewAdmxVersion}} policy templates.

- **Version matrices and catalog** — README, SECURITY, index.html, Wiki compatibility matrix, and regenerated `levels.json` updated; `.reg` artifacts byte-identical (no policy drift).

---
'@

$T_ChangelogTr = @'
<a id="tr-v{{NewKeyBase}}"></a>

## [v{{NewScriptVerNums}}] — {{ValidationDateIso}}

<a id="tr-v{{NewKeyBase}}-ozet"></a>

### Özet

**Brave {{NewBrave}} uyumluluk doğrulaması.** {{NewScriptVer}} yapılandırmayı Brave {{NewBrave}} (Chromium {{NewChromiumFull}}) sürümüne karşı doğrular, {{BraveReleaseDateTr}} tarihinde yayınlandı. Brave {{OldBrave}} (Chromium {{OldChromiumFull}}) desteklenmeye devam ediyor. Politika değişmedi: toplam 5 katmanda **151** olarak kalıyor; kümülatif zincir 24 → 51 → 83 → 123 → 151 olarak kalıyor.

| Metrik | Önce ({{OldScriptVer}}) | Sonra ({{NewScriptVer}}) |
|--------|---------------------------|---------------------------|
| Sıkılaştırma katmanları | 5 | 5 |
| Toplam politika | 151 | **151** (değişiklik yok) |
| Kümülatif zincir | 24→51→83→123→151 | **24→51→83→123→151** |
| Betik sürümü | {{OldScriptVer}} | {{NewScriptVer}} |
| Doğrulanan Brave | {{OldBrave}} | {{NewBrave}} |
| Doğrulanan Chromium | {{OldChromiumFull}} | {{NewChromiumFull}} |

<a id="tr-v{{NewKeyBase}}-degistirildi"></a>

### Değiştirildi

- **BraveOmega.ps1** — `$ScriptVersion` → `{{NewScriptVer}}`; `$ValidatedBrave` → `{{NewBrave}}`; `$ValidatedChromium` → `{{NewChromiumMajor}}`; başlık değişiklik günlüğü, sürüm bağlamı ve kanal uyarısı güncellendi.

- **ADMX yapıtları** — `admx/brave.admx` + `admx/brave.adml` + `admx/VERSION_BRAVE_ADMX` resmî {{NewAdmxVersion}} politika şablonlarıyla tazelendi.

- **Sürüm matrisleri ve katalog** — README, SECURITY, index.html, Wiki uyumluluk matrisi ve yeniden üretilen `levels.json` güncellendi; `.reg` yapıtları bit düzeyinde aynı (politika kayması yok).

---
'@

Process-File 'CHANGELOG.md' 'CHANGELOG.md' {
    # EN block
    $enBlock = Expand-Skel -Skel $T_ChangelogEn -Vars $v
    $eol = Get-Eol $script:Text
    $enInsert = (Convert-ToFileEol -Block $enBlock -Eol $eol) + (Get-Eol $script:Text)
    Insert-BeforeNth -Anchor ('<a id="en-v' + $v.OldKeyBase + '"></a>') -InsertText $enInsert -Label 'CHANGELOG: insert EN v2.8.2.0 block' -GuardLiteral ('<a id="en-v' + $v.NewKeyBase + '"></a>')
    # TR block
    $trBlock = Expand-Skel -Skel $T_ChangelogTr -Vars $v
    $trInsert = (Convert-ToFileEol -Block $trBlock -Eol $eol) + (Get-Eol $script:Text)
    Insert-BeforeNth -Anchor ('<a id="tr-v' + $v.OldKeyBase + '"></a>') -InsertText $trInsert -Label 'CHANGELOG: insert TR v2.8.2.0 block' -GuardLiteral ('<a id="tr-v' + $v.NewKeyBase + '"></a>')
    # TOC inserts + renumber
    $enTocEntry = ('1. [v' + $v.NewScriptVerNums + ' — ' + $v.ValidationDateIso + '](#en-v' + $v.NewKeyBase + ')')
    $enTocOld = ('1. [v' + $v.OldScriptVerNums + ' — ')
    if ($script:Text.Contains($enTocEntry)) { Write-Skip 'CHANGELOG: EN TOC entry' }
    else {
        $Eol = Get-Eol $script:Text
        $tocInsert = ($enTocEntry + $Eol + ('    * [Summary](#en-v' + $v.NewKeyBase + '-summary)') + $Eol + ('    * [Changed](#en-v' + $v.NewKeyBase + '-changed)') + $Eol)
        Insert-BeforeNth -Anchor $enTocOld -InsertText $tocInsert -Label 'CHANGELOG: insert EN TOC entry' -Nth 0
        Update-TocNumbers -Marker '### Table of Contents' -Label 'CHANGELOG: renumber EN TOC'
    }
    $trTocEntry = ('1. [v' + $v.NewScriptVerNums + ' — ' + $v.ValidationDateIso + '](#tr-v' + $v.NewKeyBase + ')')
    $trTocOld = ('1. [v' + $v.OldScriptVerNums + ' — ')
    if ($script:Text.Contains($trTocEntry)) { Write-Skip 'CHANGELOG: TR TOC entry' }
    else {
        $Eol = Get-Eol $script:Text
        $tocInsert = ($trTocEntry + $Eol + ('    * [Özet](#tr-v' + $v.NewKeyBase + '-ozet)') + $Eol + ('    * [Değiştirildi](#tr-v' + $v.NewKeyBase + '-degistirildi)') + $Eol)
        Insert-BeforeNth -Anchor $trTocOld -InsertText $tocInsert -Label 'CHANGELOG: insert TR TOC entry' -Nth 0
        Update-TocNumbers -Marker '### İçindekiler' -Label 'CHANGELOG: renumber TR TOC'
    }
    # history summary rows
    $enHistoryRow = '| ' + $v.OldScriptVer + ' | ' + $v.ValidationDateIso + ' | 151   | Compatibility validation: Brave ' + $v.OldBrave + ' (Chromium ' + $v.OldChromiumFull + '); no policy changes; total 151; cumulative chain 24→51→83→123→151 |'
    if ($script:Text.Contains('| ' + $v.NewScriptVer + ' | ' + $v.ValidationDateIso + ' | 151   | Compatibility validation:')) { Write-Skip 'CHANGELOG: EN history row' }
    else {
        $newRow = '| ' + $v.NewScriptVer + ' | ' + $v.ValidationDateIso + ' | 151   | Compatibility validation: Brave ' + $v.NewBrave + ' (Chromium ' + $v.NewChromiumFull + '); no policy changes; total 151; cumulative chain 24→51→83→123→151 |' + (Get-Eol $script:Text)
        Edit-Literal -Old $enHistoryRow -New ($newRow + $enHistoryRow) -Label 'CHANGELOG: insert EN history row'
    }
    $trHistoryRow = '| ' + $v.OldScriptVer + ' | ' + $v.ValidationDateIso + ' | 151   | Uyumluluk doğrulaması: Brave ' + $v.OldBrave + ' (Chromium ' + $v.OldChromiumFull + '); politika değişikliği yok; toplam 151; kümülatif zincir 24→51→83→123→151 |'
    if ($script:Text.Contains('| ' + $v.NewScriptVer + ' | ' + $v.ValidationDateIso + ' | 151   | Uyumluluk doğrulaması:')) { Write-Skip 'CHANGELOG: TR history row' }
    else {
        $newRowTr = '| ' + $v.NewScriptVer + ' | ' + $v.ValidationDateIso + ' | 151   | Uyumluluk doğrulaması: Brave ' + $v.NewBrave + ' (Chromium ' + $v.NewChromiumFull + '); politika değişikliği yok; toplam 151; kümülatif zincir 24→51→83→123→151 |' + (Get-Eol $script:Text)
        Edit-Literal -Old $trHistoryRow -New ($newRowTr + $trHistoryRow) -Label 'CHANGELOG: insert TR history row'
    }
}

# ==================================================================
# 7. policy-catalog.md header
# ==================================================================
Process-File 'Brave Omega\docs\policy-catalog.md' 'docs/policy-catalog.md' {
    Edit-Literal -Old ('`BraveOmega.ps1` ' + $v.OldScriptVer) -New ('`BraveOmega.ps1` ' + $v.NewScriptVer) -Label 'catalog: generated-from version'
    $dateOld = $v.ValidationDateIso
    Edit-Regex -Pattern ('>\s*\*\*Date:\*\*\s*' + $v.ValidationDateIso) -Replacement ('> **Date:** ' + $v.ValidationDateIso) -Label 'catalog: date header'
    Edit-Literal -Old ('> **Validated on:** Brave ' + $v.OldBrave + ' / Chromium ' + $v.OldChromiumFull + ' / Windows 11 25H2 (Build ' + $v.OldWindowsBuild + ')') -New ('> **Validated on:** Brave ' + $v.NewBrave + ' / Chromium ' + $v.NewChromiumFull + ' / Windows 11 25H2 (Build ' + $v.NewWindowsBuild + ')') -Label 'catalog: validated-on header'
}

# ==================================================================
# 8. Wiki pages
# ==================================================================
function Update-WikiMatrix {
    param([string]$RelativePath, [string]$Label)
    Process-File $RelativePath $Label {
        $eol = Get-Eol $script:Text
        # EN current (Home/Overview/Changelog style -- no date column)
        $enOld = '| **' + $v.OldScriptVer + '** *(current)* | ' + $v.OldBrave + ' | ' + $v.OldChromium + ' | 11 25H2 | ✅ Current |'
        if ($script:Text.Contains($enOld)) {
            $insert = ('| **' + $v.NewScriptVer + '** *(current)* | ' + $v.NewBrave + ' | ' + $v.NewChromiumMajor + ' | 11 25H2 | ✅ Current |' + $eol + '| ' + $v.OldScriptVer + ' | ' + $v.OldBrave + ' | ' + $v.OldChromium + ' | 11 25H2 | 📦 Previous |')
            Edit-Literal -Old $enOld -New $insert -Label "$($Label): EN matrix current+demote"
        } else {
            $enOld2 = '| **' + $v.OldScriptVer + '** *(current)* | ' + $v.OldBrave + ' | ' + $v.OldChromium + ' | 11 25H2 | ✅ Active |'
            if ($script:Text.Contains($enOld2)) {
                $insert = ('| **' + $v.NewScriptVer + '** *(current)* | ' + $v.NewBrave + ' | ' + $v.NewChromiumMajor + ' | 11 25H2 | ✅ Active |' + $eol + '| ' + $v.OldScriptVer + ' | ' + $v.OldBrave + ' | ' + $v.OldChromium + ' | 11 25H2 | 📦 Previous |')
                Edit-Literal -Old $enOld2 -New $insert -Label "$($Label): EN matrix (Active) current+demote"
            } else {
                Write-Verbose "$($Label): EN matrix row not present (may use date-column format -- handled separately)"
            }
        }
        # TR current
        $trOld = '| **' + $v.OldScriptVer + '** *(güncel)* | ' + $v.OldBrave + ' | ' + $v.OldChromium + ' | 11 25H2 | ✅ Etkin |'
        if ($script:Text.Contains($trOld)) {
            $insert = ('| **' + $v.NewScriptVer + '** *(güncel)* | ' + $v.NewBrave + ' | ' + $v.NewChromiumMajor + ' | 11 25H2 | ✅ Etkin |' + $eol + '| ' + $v.OldScriptVer + ' | ' + $v.OldBrave + ' | ' + $v.OldChromium + ' | 11 25H2 | 📦 Önceki |')
            Edit-Literal -Old $trOld -New $insert -Label "$($Label): TR matrix current+demote"
        }
        # latest-release link (EN + TR)
        $enLink = '[' + $v.OldScriptVer + ' - Brave ' + $v.OldBrave + ' compatibility validation](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/latest)'
        if ($script:Text.Contains($enLink)) {
            Edit-Literal -Old $enLink -New ('[' + $v.NewScriptVer + ' - Brave ' + $v.NewBrave + ' compatibility validation](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/latest)') -Label "$($Label): latest release (EN)"
        }
        $trLink = '[' + $v.OldScriptVer + ' - Brave ' + $v.OldBrave + ' uyumluluk doğrulaması](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/latest)'
        if ($script:Text.Contains($trLink)) {
            Edit-Literal -Old $trLink -New ('[' + $v.NewScriptVer + ' - Brave ' + $v.NewBrave + ' uyumluluk doğrulaması](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/latest)') -Label "$($Label): latest release (TR)"
        }
    }
}

Update-WikiMatrix 'Wiki\Home.md'             'Wiki/Home'
Update-WikiMatrix 'Wiki\Overview.md'         'Wiki/Overview'
Update-WikiMatrix 'Wiki\Changelog.md'        'Wiki/Changelog (compat table)'

Process-File 'Wiki\Version-Compatibility-Matrix.md' 'Wiki/Version-Compatibility-Matrix' {
    $eol = Get-Eol $script:Text
    $enOld = '| **' + $v.OldScriptVer + '** ✅ | ' + $v.OldBrave + ' | ' + $v.OldChromiumFull + ' | Windows 11 25H2 | ✅ Active | ' + $v.ValidationDateIso + ' |'
    $enNew = '| **' + $v.NewScriptVer + '** ✅ | ' + $v.NewBrave + ' | ' + $v.NewChromiumFull + ' | Windows 11 25H2 | ✅ Active | ' + $v.ValidationDateIso + ' |'
    $enOldD = '| ' + $v.OldScriptVer + ' 📦 | ' + $v.OldBrave + ' | ' + $v.OldChromiumFull + ' | Windows 11 25H2 | 📦 Previous | ' + $v.ValidationDateIso + ' |'
    if ($script:Text.Contains($enOld)) {
        Edit-Literal -Old $enOld -New ($enNew + $eol + $enOldD) -Label 'VCM: EN matrix current+demote'
    }
    $trOld = '| **' + $v.OldScriptVer + '** ✅ | ' + $v.OldBrave + ' | ' + $v.OldChromiumFull + ' | Windows 11 25H2 | ✅ Etkin | ' + $v.ValidationDateIso + ' |'
    $trNew = '| **' + $v.NewScriptVer + '** ✅ | ' + $v.NewBrave + ' | ' + $v.NewChromiumFull + ' | Windows 11 25H2 | ✅ Etkin | ' + $v.ValidationDateIso + ' |'
    $trOldD = '| ' + $v.OldScriptVer + ' 📦 | ' + $v.OldBrave + ' | ' + $v.OldChromiumFull + ' | Windows 11 25H2 | 📦 Önceki | ' + $v.ValidationDateIso + ' |'
    if ($script:Text.Contains($trOld)) {
        Edit-Literal -Old $trOld -New ($trNew + $eol + $trOldD) -Label 'VCM: TR matrix current+demote'
    }
    # selection guide EN
    Edit-Literal -Old ('### Use Current (' + $v.OldScriptVer + ') If') -New ('### Use Current (' + $v.NewScriptVer + ') If') -Label 'VCM: EN guide current heading'
    Edit-Literal -Old ('- Running Brave ' + $v.OldBrave + ' (latest stable)') -New ('- Running Brave ' + $v.NewBrave + ' (latest stable)') -Label 'VCM: EN guide current brave'
    Edit-Literal -Old '### Use Previous (v2.8.0.0) If' -New ('### Use Previous (' + $v.OldScriptVer + ') If') -Label 'VCM: EN guide previous heading'
    Edit-Literal -Old ('Cannot update to ' + $v.OldScriptVer + ' immediately') -New ('Cannot update to ' + $v.NewScriptVer + ' immediately') -Label 'VCM: EN guide previous note'
    Edit-Literal -Old '- Running Brave 1.95.104' -New ('- Running Brave ' + $v.OldBrave + '') -Label 'VCM: EN guide previous brave'
    # selection guide TR
    Edit-Literal -Old ('### Güncel (' + $v.OldScriptVer + ') Kullan Eğer') -New ('### Güncel (' + $v.NewScriptVer + ') Kullan Eğer') -Label 'VCM: TR guide current heading'
    Edit-Literal -Old ('Brave ' + $v.OldBrave + ' (en güncel kararlı) çalışıyorsa') -New ('Brave ' + $v.NewBrave + ' (en güncel kararlı) çalışıyorsa') -Label 'VCM: TR guide current brave'
    Edit-Literal -Old '### Önceki (v2.8.0.0) Kullan Eğer' -New ('### Önceki (' + $v.OldScriptVer + ') Kullan Eğer') -Label 'VCM: TR guide previous heading'
    Edit-Literal -Old ('Hemen ' + $v.OldScriptVer + "'a güncelleyemiyorsanız") -New ("Hemen " + $v.NewScriptVer + "'a güncelleyemiyorsanız") -Label 'VCM: TR guide previous note'
    Edit-Literal -Old 'Brave 1.95.104 çalışıyorsa' -New ('Brave ' + $v.OldBrave + ' çalışıyorsa') -Label 'VCM: TR guide previous brave'
    # coverage tables (EN + TR)
    $mEn = [regex]::Match($script:Text, '(?m)^\| ' + $v.OldScriptVer + ' \| 151 \| 100% \|[^\r\n]*')
    if ($mEn.Success) {
        $newEnRow = '| ' + $v.NewScriptVer + ' | 151 | 100% | Patch release — Brave ' + $v.NewBrave + ' compatibility validation (Chromium ' + $v.NewChromiumFull + '); ' + $v.ValidationDateIso + '; ADMX artifacts refreshed to official ' + $v.NewAdmxVersion + ' templates; no policy changes |'
        $script:Text = $script:Text.Replace($mEn.Value, ($newEnRow + $eol + $mEn.Value))
        $script:Dirty = $true; $script:EditCount++
    }
    $mTrArr = [regex]::Matches($script:Text, '(?m)^\| ' + $v.OldScriptVer + ' \| 151 \| 100% \|[^\r\n]*')
    $mTr = if ($mTrArr.Count -gt 1) { $mTrArr[1] } else { $null }
    if ($mTr) {
        $newTrRow = '| ' + $v.NewScriptVer + ' | 151 | 100% | Yama sürümü — Brave ' + $v.NewBrave + ' uyumluluk doğrulaması (Chromium ' + $v.NewChromiumFull + '); ' + $v.ValidationDateIso + '; ADMX yapıtları resmî ' + $v.NewAdmxVersion + ' şablonlarıyla tazelendi; politika değişikliği yok |'
        $script:Text = $script:Text.Replace($mTr.Value, ($newTrRow + $eol + $mTr.Value))
        $script:Dirty = $true; $script:EditCount++
    } else {
        Write-Verbose 'VCM: TR coverage row not matched'
    }
}

$T_WikiChEn = @'
### v{{NewScriptVerNums}} - {{ValidationDateIso}}

**Patch Release - Brave {{NewBrave}} compatibility validation**

**Changed:**

- Validated against Brave {{NewBrave}} (Chromium {{NewChromiumFull}}), released {{BraveReleaseDateEn}}; Brave {{OldBrave}} (Chromium {{OldChromiumFull}}) remains supported
- ADMX artifacts refreshed to official {{NewAdmxVersion}} policy templates (`brave.admx`, `brave.adml`, `VERSION_BRAVE_ADMX`)
- No policy changes; cumulative chain unchanged: 24 → 51 → 83 → 123 → 151
- Script updated to {{NewScriptVer}}

---

'@

$T_WikiChTr = @'
### v{{NewScriptVerNums}} - {{ValidationDateIso}}

**Yama Sürümü - Brave {{NewBrave}} uyumluluk doğrulaması**

**Değiştirildi:**

- Brave {{NewBrave}} (Chromium {{NewChromiumFull}}) ile doğrulandı, {{BraveReleaseDateTr}} tarihli; Brave {{OldBrave}} (Chromium {{OldChromiumFull}}) desteklenmeye devam ediyor
- ADMX yapıtları resmî {{NewAdmxVersion}} politika şablonlarıyla tazelendi (`brave.admx`, `brave.adml`, `VERSION_BRAVE_ADMX`)
- Politika değişikliği yok; kümülatif zincir değişmedi: 24 → 51 → 83 → 123 → 151
- Betik {{NewScriptVer}} sürümüne güncellendi

---

'@

Process-File 'Wiki\Changelog.md' 'Wiki/Changelog (release-history block)' {
    $anchor = '### v' + $v.OldScriptVerNums + ' - ' + $v.ValidationDateIso
    $enB = Expand-Skel -Skel $T_WikiChEn -Vars $v
    $trB = Expand-Skel -Skel $T_WikiChTr -Vars $v
    $eol = Get-Eol $script:Text
    $enIns = (Convert-ToFileEol -Block $enB -Eol $eol) + $eol
    $trIns = (Convert-ToFileEol -Block $trB -Eol $eol) + $eol
    Insert-BeforeNth -Anchor $anchor -InsertText $enIns -Label 'Wiki/Changelog: insert EN release block' -GuardLiteral ('**Patch Release - Brave ' + $v.NewBrave + ' compatibility validation**') -Nth 0
    Insert-BeforeNth -Anchor $anchor -InsertText $trIns -Label 'Wiki/Changelog: insert TR release block' -GuardLiteral ('**Yama Sürümü - Brave ' + $v.NewBrave + ' uyumluluk doğrulaması**') -Nth 1
}

Process-File 'Wiki\Installation.md' 'Wiki/Installation' {
    Edit-Literal -Old ($v.OldScriptVer + ' (Brave ' + $v.OldBrave + ' / Chromium ' + $v.OldChromiumFull + ' compatibility validation)') -New ($v.NewScriptVer + ' (Brave ' + $v.NewBrave + ' / Chromium ' + $v.NewChromiumFull + ' compatibility validation)') -Label 'Wiki/Install: EN subtitle'
    Edit-Literal -Old ('Brave Omega ' + $v.OldScriptVer + ' uses the safest method:') -New ('Brave Omega ' + $v.NewScriptVer + ' uses the safest method:') -Label 'Wiki/Install: EN safest method'
    Edit-Literal -Old ($v.OldScriptVer + ' için tam kurulum kılavuzu (Brave ' + $v.OldBrave + ' / Chromium ' + $v.OldChromiumFull + ' uyumluluk doğrulaması)') -New ($v.NewScriptVer + ' için tam kurulum kılavuzu (Brave ' + $v.NewBrave + ' / Chromium ' + $v.NewChromiumFull + ' uyumluluk doğrulaması)') -Label 'Wiki/Install: TR subtitle'
    Edit-Literal -Old ('Brave Omega ' + $v.OldScriptVer + ' en güvenli yöntemi kullanır:') -New ('Brave Omega ' + $v.NewScriptVer + ' en güvenli yöntemi kullanır:') -Label 'Wiki/Install: TR safest method'
}

Process-File 'Wiki\Policy-Reference.md' 'Wiki/Policy-Reference' {
    Edit-Literal -Old ('Brave Omega ' + $v.OldScriptVer + ' —') -New ('Brave Omega ' + $v.NewScriptVer + ' —') -Label 'Wiki/PolicyRef: EN title'
    Edit-Literal -Old ('Brave Omega ' + $v.OldScriptVer + ' için') -New ('Brave Omega ' + $v.NewScriptVer + ' için') -Label 'Wiki/PolicyRef: TR title'
}

Process-File 'Wiki\Security.md' 'Wiki/Security' {
    Edit-Literal -Old ('validated version ' + $v.OldBrave) -New ('validated version ' + $v.NewBrave) -Label 'Wiki/Security: EN version'
    Edit-Literal -Old ('doğrulanmış sürüm ' + $v.OldBrave) -New ('doğrulanmış sürüm ' + $v.NewBrave) -Label 'Wiki/Security: TR version'
}

Process-File 'Wiki\Roadmap.md' 'Wiki/Roadmap' {
    $eol = Get-Eol $script:Text
    # EN current version header + body
    Edit-Literal -Old ('**' + $v.OldScriptVer + '** — *Brave ' + $v.OldBrave + ' compatibility validation* (' + $v.ValidationDateIso + ')') -New ('**' + $v.NewScriptVer + '** — *Brave ' + $v.NewBrave + ' compatibility validation* (' + $v.ValidationDateIso + ')') -Label 'Roadmap: EN current header'
    Edit-Regex -Pattern ('(?m)^Current release: 151 policies across 5 hardening tiers.*Brave ' + $v.OldBraveEsc + ' \(Chromium ' + [regex]::Escape($v.OldChromiumFull) + '\).*$') -Replacement ('Current release: 151 policies across 5 hardening tiers (Brave Only 24 / Essential 27 / Balanced 32 / Advanced 40 / Strict 28), validated against Brave ' + $v.NewBrave + ' (Chromium ' + $v.NewChromiumFull + '). ADMX artifacts refreshed to official ' + $v.NewAdmxVersion + ' policy templates. Cumulative chain: 24→51→83→123→151.') -Label 'Roadmap: EN current body'
    # EN previous version (v2.8.1.0 becomes previous) -- promote old second line to previous
    $oldPrev = '**v2.8.0.0** — *Brave 1.95.104 data-layer refactor* (2026-09-22)'
    if ($script:Text.Contains($oldPrev)) {
        Edit-Literal -Old $oldPrev -New ('**' + $v.OldScriptVer + '** — *Brave ' + $v.OldBrave + ' compatibility validation* (' + $v.ValidationDateIso + ')') -Label 'Roadmap: EN previous header'
    }
    $prevBodyOld = 'Current release: 151 policies across 5 hardening tiers (Brave Only 24 / Essential 27 / Balanced 32 / Advanced 40 / Strict 28), single bilingual script with `-Language EN|TR|Auto`, validated against Brave 1.95.104 (Chromium 153.0.8010.53). Policy definitions live in the data layer (`config.json` + `profiles/*.json`). Cumulative chain: 24→51→83→123→151.'
    if ($script:Text.Contains($prevBodyOld)) {
        Edit-Literal -Old $prevBodyOld -New ('Current release: 151 policies across 5 hardening tiers (Brave Only 24 / Essential 27 / Balanced 32 / Advanced 40 / Strict 28), validated against Brave ' + $v.OldBrave + ' (Chromium ' + $v.OldChromiumFull + '). ADMX artifacts refreshed to official ' + $v.OldAdmxVersion + ' policy templates. Cumulative chain: 24→51→83→123→151.') -Label 'Roadmap: EN previous body'
    }
    # TR current
    Edit-Literal -Old ('**' + $v.OldScriptVer + '** — *Brave ' + $v.OldBrave + ' uyumluluk doğrulaması* (' + $v.ValidationDateIso + ')') -New ('**' + $v.NewScriptVer + '** — *Brave ' + $v.NewBrave + ' uyumluluk doğrulaması* (' + $v.ValidationDateIso + ')') -Label 'Roadmap: TR current header'
    Edit-Regex -Pattern ('(?m)^Güncel sürüm: 5 sıkılaştırma katmanında 151 politika.*Brave ' + $v.OldBraveEsc + ' \(Chromium ' + [regex]::Escape($v.OldChromiumFull) + '\).*$') -Replacement ('Güncel sürüm: 5 sıkılaştırma katmanında 151 politika (Brave Yalnız 24 / Temel 27 / Dengeli 32 / Gelişmiş 40 / Katı 28), Brave ' + $v.NewBrave + ' (Chromium ' + $v.NewChromiumFull + ') ile doğrulandı. ADMX yapıtları resmî ' + $v.NewAdmxVersion + ' politika şablonlarıyla tazelendi. Kümülatif zincir: 24→51→83→123→151.') -Label 'Roadmap: TR current body'
    $oldPrevTr = '**v2.8.0.0** — *Brave 1.95.104 veri katmanı yeniden düzenlemesi* (2026-09-22)'
    if ($script:Text.Contains($oldPrevTr)) {
        Edit-Literal -Old $oldPrevTr -New ('**' + $v.OldScriptVer + '** — *Brave ' + $v.OldBrave + ' uyumluluk doğrulaması* (' + $v.ValidationDateIso + ')') -Label 'Roadmap: TR previous header'
    }
    $prevBodyTrOld = 'Güncel sürüm: 5 sıkılaştırma katmanında 151 politika (Brave Yalnız 24 / Temel 27 / Dengeli 32 / Gelişmiş 40 / Katı 28), `-Language EN|TR|Auto` seçenekli tek iki dilli betik, Brave 1.95.104 (Chromium 153.0.8010.53) ile doğrulandı. Politika tanımları veri katmanında yaşar (`config.json` + `profiles/*.json`). Kümülatif zincir: 24→51→83→123→151.'
    if ($script:Text.Contains($prevBodyTrOld)) {
        Edit-Literal -Old $prevBodyTrOld -New ('Güncel sürüm: 5 sıkılaştırma katmanında 151 politika (Brave Yalnız 24 / Temel 27 / Dengeli 32 / Gelişmiş 40 / Katı 28), Brave ' + $v.OldBrave + ' (Chromium ' + $v.OldChromiumFull + ') ile doğrulandı. ADMX yapıtları resmî ' + $v.OldAdmxVersion + ' politika şablonlarıyla tazelendi. Kümülatif zincir: 24→51→83→123→151.') -Label 'Roadmap: TR previous body'
    }
}

Process-File 'Wiki\Rejected-Policies.md' 'Wiki/Rejected-Policies' {
    Edit-Global -Old 'v2.8.0.0 (2026-09-22)' -New ($v.NewScriptVer + ' (' + $v.ValidationDateIso + ')') -Label 'RejectedPolicies: last-updated footer' -MinCount 2
    Edit-Global -Old '(v2.8.0.0' -New '(' + $v.NewScriptVer -Label 'RejectedPolicies: active count footer' -MinCount 2
}

# ==================================================================
# 9. ADMX + VERSION_BRAVE_ADMX (optional copy); enterprise regen
# ==================================================================
if ($AdmxSourceDir -and (Test-Path -LiteralPath $AdmxSourceDir)) {
    $admxFrom = Join-Path $AdmxSourceDir 'windows\admx\brave.admx'
    $admlFrom = Join-Path $AdmxSourceDir 'windows\admx\en-US\brave.adml'
    if ((Test-Path -LiteralPath $admxFrom) -and (Test-Path -LiteralPath $admlFrom)) {
        if ($DryRun) {
            Write-Step "would copy admx: brave.admx + brave.adml from $AdmxSourceDir into admx/ (ADMX template refresh)"
        } else {
            Copy-Item -LiteralPath $admxFrom -Destination (Join-Path $script:RepoRoot 'admx\brave.admx') -Force
            Copy-Item -LiteralPath $admlFrom -Destination (Join-Path $script:RepoRoot 'admx\en-US\brave.adml') -Force
            Write-Status "ADMX templates copied from $AdmxSourceDir"
        }
    } else {
        Write-Warn "ADMX source dir provided but windows\admx\brave.admx / en-US\brave.adml not found"
        Write-Skip 'ADMX template copy'
    }
} else {
    Write-Skip 'ADMX template copy (no -AdmxSourceDir provided)'
}

if ($AdmxVersion) {
    Process-File 'admx\VERSION_BRAVE_ADMX' 'admx/VERSION_BRAVE_ADMX' {
        $oldParts = $v.OldAdmxVersion -split '\.'
        $newParts = $AdmxVersion -split '\.'
        $labels = @('MAJOR', 'MINOR', 'BUILD', 'PATCH')
        for ($i = 0; $i -lt [Math]::Min($oldParts.Count, $newParts.Count); $i++) {
            if ($oldParts[$i] -ne $newParts[$i]) {
                Edit-Literal -Old ($labels[$i] + '=' + $oldParts[$i]) -New ($labels[$i] + '=' + $newParts[$i]) -Label ('admx/VERSION: ' + $labels[$i])
            }
        }
    }
}
if (-not $SkipCatalogRegen) {
    Write-Host ""
    Write-Host "ENTERPRISE CATALOG REGENERATION" -ForegroundColor Cyan
    if ($DryRun) {
        Write-Step "would run: powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Export-PolicyCatalog.ps1"
        Write-Step "would rewrite: enterprise/levels.json + 5 x .reg from the updated script"
    } else {
        $ps = Start-Process -FilePath "powershell.exe" `
            -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File', (Join-Path $script:RepoRoot 'scripts\Export-PolicyCatalog.ps1')) `
            -WorkingDirectory $script:RepoRoot -PassThru -Wait -WindowStyle Hidden
        if ($ps.ExitCode -ne 0) {
            throw "Export-PolicyCatalog.ps1 exited with code $($ps.ExitCode)"
        }
        Write-Status "enterprise/levels.json + .reg regenerated (from updated BraveOmega.ps1)"
    }
} else {
    Write-Skip 'enterprise catalog regeneration'
}

# ==================================================================
# 10. POST-CHECK (stale current-context markers must be gone)
# ==================================================================
Write-Host ""
Write-Host "POST-CHECK: stale current-release markers" -ForegroundColor Cyan

try {
    $bad = 0
    $pairs = @(
        @{ f = 'Brave Omega\BraveOmega.ps1'; p = ('\$ScriptVersion\s*=\s*"v' + $v.OldScriptVerNums + '"') },
        @{ f = 'Brave Omega\BraveOmega.ps1'; p = ('\$ValidatedBrave\s*=\s*"' + $v.OldBraveEsc + '"') },
        @{ f = 'Brave Omega\BraveOmega.ps1'; p = ('\$ValidatedChromium\s*=\s*"' + $v.OldChromium + '"') },
        @{ f = 'Tests\ScriptVersion.Tests.ps1'; p = ('BeExactly "' + $v.OldScriptVer + '"') },
        @{ f = 'Tests\VersionCheck.Tests.ps1';  p = ('\$ValidatedBrave.*=.*"' + $v.OldBraveEsc + '"') },
        @{ f = 'README.md';                    p = ('Badge-Brave-' + $v.OldBraveEsc) },
        @{ f = 'SUPPORT.md';                   p = ('Badge-Brave-' + $v.OldBraveEsc) },
        @{ f = 'SECURITY.md';                  p = ('currently ' + $v.OldScriptVer) },
        @{ f = 'SECURITY.md';                  p = ('şu an ' + $v.OldScriptVer) },
        @{ f = 'index.html';                   p = ('>v' + $v.OldScriptVerNums + '</span>') },
        @{ f = 'index.html';                   p = ('Brave Omega v' + $v.OldScriptVerNums) },
        @{ f = 'index.html';                   p = ('(' + $v.OldBraveEsc + ' önerilir)') },
        @{ f = 'README.md';                    p = ('\*\*' + $v.OldScriptVer + '\*\* \*\(current\)\*') },
        @{ f = 'README.md';                    p = ('\*\*' + $v.OldScriptVer + '\*\* \*\(güncel\)\*') },
        @{ f = 'Wiki\Home.md';                 p = ('\*\*' + $v.OldScriptVer + '\*\* \*\(current\)\*') },
        @{ f = 'Wiki\Home.md';                 p = ('\*\*' + $v.OldScriptVer + '\*\* \*\(güncel\)\*') },
        @{ f = 'Wiki\Overview.md';             p = ('\*\*' + $v.OldScriptVer + '\*\* \*\(current\)\*') },
        @{ f = 'Wiki\Overview.md';             p = ('\*\*' + $v.OldScriptVer + '\*\* \*\(güncel\)\*') },
        @{ f = 'Wiki\Changelog.md';            p = ('\*\*' + $v.OldScriptVer + '\*\* \*\(current\)\*') },
        @{ f = 'Wiki\Changelog.md';            p = ('\*\*' + $v.OldScriptVer + '\*\* \*\(güncel\)\*') },
        @{ f = 'Wiki\Version-Compatibility-Matrix.md'; p = ('\*\*' + $v.OldScriptVer + '\*\* ✅') },
        @{ f = 'Wiki\Version-Compatibility-Matrix.md'; p = ('\*\*' + $v.OldScriptVer + '\*\* \*\(current\)\*') },
        @{ f = 'Brave Omega\docs\policy-catalog.md'; p = ('Validated on.*' + $v.OldBraveEsc) }
    )
    foreach ($pc in $pairs) {
        $text = $script:FinalText[$pc.f]
        if ($null -eq $text) { continue }
        $rx = New-Object System.Text.RegularExpressions.Regex($pc.p)
        if ($rx.IsMatch($text)) {
            $m = $rx.Match($text)
            Write-Warn ("STALE in {0}: <{1}>" -f $pc.f, $m.Value)
            $bad++
        }
    }
    if ($bad -gt 0) {
        throw "$bad stale marker(s) still present after update -- see warnings above."
    }
    Write-Status "no stale current-release markers"
}
catch {
    Write-Host ("POST-CHECK FAILED: " + $_.Exception.Message) -ForegroundColor Red
    if (-not $DryRun) { $script:FailedPostCheck = $true }
    throw
}

# Residual report (informational -- old tokens are allowed inside history)
Write-Host ""
Write-Host "RESIDUAL OLD TOKENS (informational -- must only be historical)" -ForegroundColor DarkGray
foreach ($tok in @($v.OldScriptVer, $v.OldBrave, $v.OldChromiumFull)) {
    $rx = New-Object System.Text.RegularExpressions.Regex([regex]::Escape($tok))
    $files = @($script:FinalText.Keys | Where-Object { $script:FinalText[$_] -and $rx.IsMatch($script:FinalText[$_]) })
    foreach ($f in $files) {
        $c = $rx.Matches($script:FinalText[$f]).Count
        Write-Host ("  {0,-8} {1,3} occurrence(s) in {2}" -f $tok, $c, $f) -ForegroundColor DarkGray
    }
}

# ==================================================================
# 11. REGRESSION (live run only)
# ==================================================================
if (-not $DryRun -and -not $SkipRegression) {
    Write-Host ""
    Write-Host "REGRESSION CHECKS" -ForegroundColor Cyan
    $tmpOut = Join-Path $env:TEMP ("omega-admx-{0}.log" -f [guid]::NewGuid().ToString('N'))
    $p = Start-Process -FilePath "powershell.exe" `
        -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File', (Join-Path $script:RepoRoot 'admx\admx-validate.ps1')) `
        -WorkingDirectory $script:RepoRoot -PassThru -Wait -WindowStyle Hidden -RedirectStandardOutput $tmpOut -RedirectStandardError ($tmpOut + '.err')
    Get-Content -LiteralPath $tmpOut | Write-Host
    if ($p.ExitCode -ne 0) { throw "admx-validate.ps1 exited with code $($p.ExitCode)" }
    Write-Status 'admx-validate PASS'

    $res = Invoke-Pester (Join-Path $script:RepoRoot 'Tests') -PassThru -Output Minimal
    if ($res.FailedCount -gt 0 -or $res.TotalCount -eq 0) {
        throw "Pester: $($res.FailedCount) failed / $($res.TotalCount) total"
    }
    Write-Status ("Pester PASS ({0}/{0} passed)" -f $res.TotalCount)

    try {
        $sas = Invoke-ScriptAnalyzer (Join-Path $script:RepoRoot 'Brave Omega\BraveOmega.ps1') -Severity Warning `
            -ExcludeRule PSAvoidUsingWriteHost,PSAvoidUsingEmptyCatchBlock,PSUseSupportsShouldProcess,PSUseShouldProcessForStateChangingFunctions
        $issues = @($sas | Where-Object { $_.Severity -eq 'Error' -or $_.Severity -eq 'Warning' })
        if ($issues.Count -gt 0) {
            $issues | ForEach-Object { Write-Warn ("  {0} at {1}:{2} -- {3}" -f $_.Severity, $_.ScriptName, $_.Line, $_.Message) }
            throw "PSScriptAnalyzer: $($issues.Count) issue(s)"
        }
        Write-Status "PSScriptAnalyzer PASS (0)"
    } catch {
        if ($_.Exception.Message -match 'PSScriptAnalyzer') { throw }
        Write-Warn "PSScriptAnalyzer unavailable -- skipped"
    }
}

# ==================================================================
# 12. SUMMARY
# ==================================================================
Write-Host ""
Write-Host ("{0}" -f (('=' * 70))) -ForegroundColor DarkGray
if ($DryRun) {
    Write-Host ("DRY RUN COMPLETE -- {0} anchor edit(s) validated, {1} no-op skip(s). NO FILES WERE WRITTEN." -f $script:EditCount, $script:SkipCount) -ForegroundColor Yellow
} else {
    Write-Host ("UPDATE COMPLETE -- {0} anchor edit(s) applied across {1} file(s)." -f $script:EditCount, $script:FinalText.Count) -ForegroundColor Green
}
if ($script:FailedPostCheck) { Write-Host "!! POST-CHECK FAILED -- inspect the diff and re-run." -ForegroundColor Red }
Write-Host ""
Write-Host "NEXT STEPS (manual, per AGENTS.md):" -ForegroundColor White
Write-Host "  1. Review the diff:  git diff --stat && git diff" -ForegroundColor DarkGray
Write-Host "  2. Confirm admx-validate / Pester / PSScriptAnalyzer all green (already ran unless -SkipRegression)." -ForegroundColor DarkGray
Write-Host "  3. Commit and dual-push explicitly (origin pushes to GitHub + GitLab)." -ForegroundColor DarkGray
if ($script:FailedPostCheck) { exit 1 }
