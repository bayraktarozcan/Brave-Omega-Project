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

# canonical marker present, canonical marker matches content, mirror present,
# mirror marker matches canonical
$TotalChecks = 4

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
    Write-Result "Canonical file declares no well-formed sync-sha marker" -Level "Error"
} elseif ($CanonicalDeclared -ne $CanonicalComputed) {
    Write-Result "Canonical sync-sha is stale: declared $CanonicalDeclared, content hashes to $CanonicalComputed" -Level "Error"
} else {
    Write-Result "Canonical sync-sha matches its own content" -Level "Info"
}

# ─── Mirror file ───
$MirrorPresent = Test-Path -LiteralPath $Mirror -PathType Leaf
$MirrorChecked = $MirrorPresent
$MirrorDeclared = $null

if (-not $MirrorPresent) {
    if ($AllowMissingMirror) {
        Write-Result "Mirror not present at the supplied path; mirror checks skipped" -Level "Warning"
    } else {
        Write-Result "Mirror file not found at the supplied path" -Level "Error"
    }
} else {
    $MirrorText = Get-NormalizedText -Path $Mirror
    $MirrorDeclared = Get-DeclaredSha -Text $MirrorText

    if (-not $MirrorDeclared) {
        Write-Result "Mirror declares no well-formed sync-sha marker" -Level "Error"
    } elseif (-not $CanonicalDeclared) {
        Write-Result "Cannot compare declared values: canonical marker is missing" -Level "Error"
    } elseif ($MirrorDeclared -ne $CanonicalDeclared) {
        Write-Result "Mirror drift: mirror declares $MirrorDeclared, canonical declares $CanonicalDeclared" -Level "Error"
    } else {
        Write-Result "Mirror and canonical declare the same sync-sha" -Level "Info"
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
Write-Host "  Checks passed:        $($TotalChecks - $ErrorMessages.Count) of $TotalChecks" -ForegroundColor $(if ($ErrorMessages.Count -eq 0) { "Green" } else { "Red" })
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
}

exit $ExitCode
