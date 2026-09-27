param(
    [Parameter(Mandatory = $true)]
    [string]$Canonical,

    [Parameter(Mandatory = $true)]
    [string]$Mirror,

    [switch]$AllowMissingMirror,

    [switch]$VerboseOutput
)

$ExitCode = 0
$ErrorMessages = @()
$WarningMessages = @()
$InfoMessages = @()

# Resolved here so the verbose switch is consumed in the script body; the
# Write-Result helper then only reads a plain flag.
$ShowInfo = [bool]$VerboseOutput

# Declared value, e.g. sync-sha=<40 hex chars>
$ShaPattern = 'sync-sha=([0-9a-f]{40})'

# The whole marker line, including its terminator, is what gets removed
$SyncLinePattern = '(?m)^[ \t]*<!--\s*mirror-sync:.*?-->[ \t]*\n?'

# Checks are counted as they run rather than declared up front. The structural
# parity group is skipped when no mirror is present, and a hardcoded total would
# then report coverage that never happened.
$ChecksRun = 0
$ChecksPassed = 0

function Add-CheckResult {
    param([bool]$Passed, [string]$Message)

    $script:ChecksRun++
    if ($Passed) {
        $script:ChecksPassed++
        Write-Result $Message -Level "Info"
    } else {
        Write-Result $Message -Level "Error"
    }
}

function Write-Result {
    param([string]$Message, [string]$Level = "Info")
    switch ($Level) {
        "Error"   { $script:ErrorMessages += $Message; $script:ExitCode = 1; Write-Host "[FAIL] $Message" -ForegroundColor Red }
        "Warning" { $script:WarningMessages += $Message; Write-Host "[WARN] $Message" -ForegroundColor Yellow }
        "Info"    { if ($ShowInfo) { $script:InfoMessages += $Message; Write-Host "[INFO] $Message" -ForegroundColor Cyan } }
    }
}

# ─── Read as UTF-8 and normalize to LF so the hash is EOL-independent ───
# A checkout on Windows may hold CRLF while the committed blob holds LF.
# Hashing the LF form keeps one value valid across platforms and EOL styles.
function Get-NormalizedText {
    param([string]$Path)

    $bytes = [System.IO.File]::ReadAllBytes($Path)
    $offset = 0
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        $offset = 3
    }
    $text = [System.Text.Encoding]::UTF8.GetString($bytes, $offset, $bytes.Length - $offset)
    return (($text -replace "`r`n", "`n") -replace "`r", "`n")
}

function Get-ContentSha {
    param([string]$Text)

    $stripped = [regex]::Replace($Text, $SyncLinePattern, '')
    $sha = [System.Security.Cryptography.SHA1]::Create()
    try {
        $hash = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($stripped))
    } finally {
        $sha.Dispose()
    }
    return (($hash | ForEach-Object { $_.ToString('x2') }) -join '')
}

function Get-DeclaredSha {
    param([string]$Text)

    # Read the value from the marker line only. A document may legitimately
    # mention sync-sha elsewhere - for example in an illustrative comment - and
    # a loose search over the whole file would pick that up instead.
    $marker = [regex]::Match($Text, $SyncLinePattern)
    if (-not $marker.Success) { return $null }

    $match = [regex]::Match($marker.Value, $ShaPattern)
    if ($match.Success) { return $match.Groups[1].Value }
    return $null
}

# ─── Structural profile ───
# A translation cannot be compared textually, so the only mechanical signal
# available is structural: the same section sequence, the same number of rules
# under each section, the same code blocks, the same tables. Granularity that a
# translation is allowed to add - a rule split across two table rows, a rule
# expanded into nested sub-items - leaves every one of these numbers untouched,
# which is why they are compared instead of line or word counts.
#
# Headings, bullets and tables inside a fenced block are not counted: a shell
# comment that starts with '#' is not a section, and a list inside a code sample
# is not a rule.
function Get-StructureProfile {
    param([string]$Text)

    $structureProfile = [ordered]@{
        # Slot 0 is the preamble before the first heading, so both files are
        # compared over the same number of slots.
        SectionLevels  = New-Object System.Collections.Generic.List[int]
        SectionBullets = New-Object System.Collections.Generic.List[int]
        CodeFences      = 0
        TableBlocks     = 0
        TopLevelBullets = 0
        NestedBullets   = 0
    }
    $structureProfile.SectionLevels.Add(0)

    $inFence = $false
    $inTable = $false
    $bulletsInSection = 0

    foreach ($line in ($Text -split "`n")) {
        if ($line.TrimStart().StartsWith('```')) {
            $structureProfile.CodeFences++
            $inFence = -not $inFence
            $inTable = $false
            continue
        }
        if ($inFence) { continue }

        $heading = [regex]::Match($line, '^(#{1,6})\s')
        if ($heading.Success) {
            $structureProfile.SectionLevels.Add($heading.Groups[1].Value.Length)
            $structureProfile.SectionBullets.Add($bulletsInSection)
            $bulletsInSection = 0
            $inTable = $false
            continue
        }

        if ($line.TrimStart().StartsWith('|')) {
            if (-not $inTable) {
                $structureProfile.TableBlocks++
                $inTable = $true
            }
            continue
        }
        $inTable = $false

        if ($line -match '^- ') {
            $structureProfile.TopLevelBullets++
            $bulletsInSection++
        } elseif ($line -match '^\s+- ') {
            $structureProfile.NestedBullets++
        }
    }
    $structureProfile.SectionBullets.Add($bulletsInSection)

    return $structureProfile
}

# ─── Canonical file ───
if (-not (Test-Path -LiteralPath $Canonical -PathType Leaf)) {
    Write-Host "Canonical file not found: $Canonical" -ForegroundColor Red
    exit 1
}

$CanonicalText = Get-NormalizedText -Path $Canonical
$CanonicalDeclared = Get-DeclaredSha -Text $CanonicalText
$CanonicalComputed = Get-ContentSha -Text $CanonicalText

Write-Result "Canonical: $Canonical" -Level "Info"
Write-Result "Declared sync-sha: $(if ($CanonicalDeclared) { $CanonicalDeclared } else { '(none)' })" -Level "Info"
Write-Result "Computed sync-sha: $CanonicalComputed" -Level "Info"

if (-not $CanonicalDeclared) {
    Add-CheckResult -Passed $false -Message "Canonical file declares no well-formed sync-sha marker"
} elseif ($CanonicalDeclared -ne $CanonicalComputed) {
    Add-CheckResult -Passed $false -Message "Canonical sync-sha is stale: declared $CanonicalDeclared, content hashes to $CanonicalComputed"
} else {
    Add-CheckResult -Passed $true -Message "Canonical sync-sha matches its own content"
}

# ─── Mirror file ───
$MirrorPresent = Test-Path -LiteralPath $Mirror -PathType Leaf
$MirrorChecked = $MirrorPresent
$MirrorDeclared = $null

if (-not $MirrorPresent) {
    if ($AllowMissingMirror) {
        # Intentionally absent, so it is left out of the count instead of being
        # scored as a pass it never ran.
        Write-Result "Mirror not present at the supplied path; mirror checks skipped" -Level "Warning"
    } else {
        Add-CheckResult -Passed $false -Message "Mirror file not found at the supplied path"
    }
} else {
    $MirrorText = Get-NormalizedText -Path $Mirror
    $MirrorDeclared = Get-DeclaredSha -Text $MirrorText

    if (-not $MirrorDeclared) {
        Add-CheckResult -Passed $false -Message "Mirror declares no well-formed sync-sha marker"
    } elseif (-not $CanonicalDeclared) {
        Add-CheckResult -Passed $false -Message "Cannot compare declared values: canonical marker is missing"
    } elseif ($MirrorDeclared -ne $CanonicalDeclared) {
        Add-CheckResult -Passed $false -Message "Mirror drift: mirror declares $MirrorDeclared, canonical declares $CanonicalDeclared"
    } else {
        Add-CheckResult -Passed $true -Message "Mirror and canonical declare the same sync-sha"
    }

    # ─── Structural parity ───
    # Only meaningful with a mirror in hand. Under -AllowMissingMirror there is
    # nothing to compare, so no claim is made about structure either.
    $CanonicalProfile = Get-StructureProfile -Text $CanonicalText
    $MirrorProfile    = Get-StructureProfile -Text $MirrorText

    Write-Result "Canonical structure: $($CanonicalProfile.SectionLevels.Count) sections, $($CanonicalProfile.TopLevelBullets) top-level rules, $($CanonicalProfile.CodeFences) code fences, $($CanonicalProfile.TableBlocks) tables" -Level "Info"
    Write-Result "Mirror structure:    $($MirrorProfile.SectionLevels.Count) sections, $($MirrorProfile.TopLevelBullets) top-level rules, $($MirrorProfile.CodeFences) code fences, $($MirrorProfile.TableBlocks) tables" -Level "Info"
    # A rule split across two table rows, or expanded into nested sub-items to
    # stay readable in the mirror's own language, is legitimate translation work.
    # It changes none of the counts below, which is exactly why they are the
    # ones compared.
    Write-Result "Nested sub-items: canonical $($CanonicalProfile.NestedBullets), mirror $($MirrorProfile.NestedBullets) (informational)" -Level "Info"

    $SectionCountMatches = $CanonicalProfile.SectionLevels.Count -eq $MirrorProfile.SectionLevels.Count
    if ($SectionCountMatches) {
        Add-CheckResult -Passed $true -Message "Mirror has the same number of sections as the canonical file"
    } else {
        Add-CheckResult -Passed $false -Message "Mirror section count differs: canonical $($CanonicalProfile.SectionLevels.Count), mirror $($MirrorProfile.SectionLevels.Count)"
    }

    # The two remaining comparisons line the sections up by position, so they
    # only carry meaning when the counts already agree.
    if ($SectionCountMatches) {
        if (($CanonicalProfile.SectionLevels -join ',') -eq ($MirrorProfile.SectionLevels -join ',')) {
            Add-CheckResult -Passed $true -Message "Section depth sequence matches"
        } else {
            Add-CheckResult -Passed $false -Message "Section depth sequence differs; a heading was added, removed or re-levelled on one side"
        }

        $DriftedSections = @()
        for ($i = 0; $i -lt $CanonicalProfile.SectionBullets.Count; $i++) {
            if ($CanonicalProfile.SectionBullets[$i] -ne $MirrorProfile.SectionBullets[$i]) { $DriftedSections += $i }
        }
        if ($DriftedSections.Count -eq 0) {
            Add-CheckResult -Passed $true -Message "Rule count matches under every section"
        } else {
            $detail = ($DriftedSections | Select-Object -First 5 | ForEach-Object {
                "slot $_ (canonical $($CanonicalProfile.SectionBullets[$_]), mirror $($MirrorProfile.SectionBullets[$_]))"
            }) -join '; '
            Add-CheckResult -Passed $false -Message "Rule count differs under $($DriftedSections.Count) section(s): $detail"
        }
    }

    if ($CanonicalProfile.CodeFences -eq $MirrorProfile.CodeFences) {
        Add-CheckResult -Passed $true -Message "Code fence count matches"
    } else {
        Add-CheckResult -Passed $false -Message "Code fence count differs: canonical $($CanonicalProfile.CodeFences), mirror $($MirrorProfile.CodeFences)"
    }

    if ($CanonicalProfile.TableBlocks -eq $MirrorProfile.TableBlocks) {
        Add-CheckResult -Passed $true -Message "Table block count matches"
    } else {
        Add-CheckResult -Passed $false -Message "Table block count differs: canonical $($CanonicalProfile.TableBlocks), mirror $($MirrorProfile.TableBlocks); a table was added or lost"
    }
}

# ─── Summary ───
Write-Host ""
Write-Host "================================================" -ForegroundColor Magenta
Write-Host "   Mirror Sync Summary" -ForegroundColor Magenta
Write-Host "================================================" -ForegroundColor Magenta

Write-Host "  Canonical computed:   $CanonicalComputed" -ForegroundColor White
Write-Host "  Canonical declared:   $(if ($CanonicalDeclared) { $CanonicalDeclared } else { '(none)' })" -ForegroundColor $(if ($CanonicalDeclared -eq $CanonicalComputed) { "Green" } else { "Red" })
Write-Host "  Mirror declared:      $(if ($MirrorDeclared) { $MirrorDeclared } else { '(none)' })" -ForegroundColor $(if ($MirrorPresent -and $MirrorDeclared -and $MirrorDeclared -eq $CanonicalDeclared) { "Green" } else { "Yellow" })
Write-Host "  Checks passed:        $ChecksPassed of $ChecksRun" -ForegroundColor $(if ($ErrorMessages.Count -eq 0) { "Green" } else { "Red" })
Write-Host ""

if ($ErrorMessages.Count -gt 0) {
    Write-Host "  FAIL: $($ErrorMessages.Count) error(s), $($WarningMessages.Count) warning(s)" -ForegroundColor Red
    Write-Host "  Fix: set sync-sha to the computed value in the canonical file and the mirror," -ForegroundColor Yellow
    Write-Host "       refresh the mirror content, then re-run this check." -ForegroundColor Yellow
} elseif ($MirrorChecked -eq $false) {
    Write-Host "  PASS: canonical sync-sha verified. Mirror check was skipped" -ForegroundColor Green
    Write-Host "        (no mirror at the supplied path), so no claim is made about it." -ForegroundColor Green
} else {
    Write-Host "  PASS: Mirror is in sync with the canonical file." -ForegroundColor Green
    Write-Host "        Marker values agree, and the structure matches section for section:" -ForegroundColor Green
    Write-Host "        same sections, same rule count under each, same code fences, same tables." -ForegroundColor Green
    Write-Host "        Rule wording still needs a human read - structure cannot prove" -ForegroundColor DarkGray
    Write-Host "        that a translated sentence carries the same meaning." -ForegroundColor DarkGray
}

exit $ExitCode
