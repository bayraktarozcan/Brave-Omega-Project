param(
    [switch]$VerboseOutput
)

$ExitCode = 0
$ErrorMessages = @()
$WarningMessages = @()
$InfoMessages = @()

function Write-Result {
    param([string]$Message, [string]$Level = "Info")
    switch ($Level) {
        "Error"   { $script:ErrorMessages += $Message; Write-Host "[FAIL] $Message" -ForegroundColor Red }
        "Warning" { $script:WarningMessages += $Message; Write-Host "[WARN] $Message" -ForegroundColor Yellow }
        "Info"    { if ($VerboseOutput) { $script:InfoMessages += $Message; Write-Host "[INFO] $Message" -ForegroundColor Cyan } }
    }
}

# ─── ADMX File Check ───
$admxPath = Join-Path -Path $PSScriptRoot -ChildPath "brave.admx"
if (-not (Test-Path -LiteralPath $admxPath)) {
    Write-Host "ADMX file not found: $admxPath" -ForegroundColor Red
    exit 1
}

$admxContent = Get-Content -LiteralPath $admxPath -Raw -Encoding UTF8
$admxXml = [xml]$admxContent
$policies = $admxXml.policyDefinitions.policies.policy

Write-Result "Parsed ADMX: $($policies.Count) total policy entries (including _recommended variants)" -Level "Info"

# ─── Build ADMX lookup: policy name → { valueName, type, class } ───
$admxPolicyMap = @{}
foreach ($p in $policies) {
    $name = $p.name
    $valueName = $p.valueName
    $class = $p.class
    $elements = $p.elements

    # Determine ADMX type
    $admxType = "Unknown"
    if ($p.enabledValue) {
        $admxType = "DWord"  # has enabledValue/disabledValue = boolean
    } elseif ($elements) {
        $child = $elements.ChildNodes | Where-Object { $_.NodeType -eq "Element" } | Select-Object -First 1
        if ($child) {
            switch ($child.LocalName) {
                "list"    { $admxType = "MultiString" }
                "string"  { $admxType = "String" }
                "text"    { $admxType = "String" }
                "enum"    {
                    # Enum can have string values or decimal values
                    # Check the first item's value type: item > value > string/decimal
                    $firstItem = $child.ChildNodes | Where-Object { $_.NodeType -eq "Element" -and $_.LocalName -eq "item" } | Select-Object -First 1
                    $firstValue = $firstItem.ChildNodes | Where-Object { $_.NodeType -eq "Element" -and $_.LocalName -eq "value" } | Select-Object -First 1
                    $firstVal = $firstValue.ChildNodes | Where-Object { $_.NodeType -eq "Element" } | Select-Object -First 1
                    if ($firstVal -and $firstVal.LocalName -eq "string") {
                        $admxType = "String"
                    } else {
                        $admxType = "DWord"
                    }
                }
                "decimal" { $admxType = "DWord" }
                "boolean" { $admxType = "DWord" }
                "longDecimal" { $admxType = "DWord" }
                default   { $admxType = "Unknown" }
            }
        }
    }

    $admxPolicyMap[$name] = @{
        Name      = $name
        ValueName = $valueName
        Type      = $admxType
        Class     = $class
    }
}

Write-Result "ADMX lookup built: $($admxPolicyMap.Count) unique policy names" -Level "Info"

# ─── Our script's policy definitions (auto-discovered from BraveOmega-EN.ps1) ───
# Parsed dynamically so every policy added to the script is validated — no manual sync.
$scriptPath = Join-Path -Path $PSScriptRoot -ChildPath "..\Brave Omega\BraveOmega-EN.ps1"
if (-not (Test-Path -LiteralPath $scriptPath)) {
    Write-Host "Script file not found: $scriptPath" -ForegroundColor Red
    exit 1
}

$scriptContent = Get-Content -LiteralPath $scriptPath -Raw -Encoding UTF8
$scriptPolicyMap = @{}
$duplicateTypes = @()
$policyEntryPattern = '^\s*@\{Name\s*=\s*"([^"]+)".*Type\s*=\s*"([^"]+)"\s*\}'
foreach ($line in ($scriptContent -split "`r?`n")) {
    $m = [regex]::Match($line, $policyEntryPattern)
    if (-not $m.Success) { continue }
    $name = $m.Groups[1].Value
    $type = $m.Groups[2].Value
    if ($scriptPolicyMap.ContainsKey($name)) {
        if ($scriptPolicyMap[$name].Type -ne $type) {
            $duplicateTypes += "$name ($($scriptPolicyMap[$name].Type) vs $type)"
        }
        continue
    }
    $scriptPolicyMap[$name] = @{ Type = $type }
}

foreach ($dup in $duplicateTypes) {
    Write-Result "Policy '$dup' declared with conflicting types across levels" -Level "Error"
}
if ($duplicateTypes.Count -gt 0) { $ExitCode = 1 }

Write-Result "Script policies loaded: $($scriptPolicyMap.Count) unique policy names (auto-discovered)" -Level "Info"

# ─── Known exceptions: valid Chromium policies intentionally absent from Brave's ADMX ───
# Brave's ADMX bundle is generated from Chromium's Windows GPO policy templates. A few
# policies this script applies are real Chromium enterprise policies that are only shipped
# for non-Windows surfaces (e.g. ChromeOS web-capability / IWA policies) and therefore never
# appear in brave.admx. Each entry is verified against chromeenterprise.google/policies and
# cross-referenced in CHANGELOG.md / README.md. Do not add entries here to silence typos.
$knownAdmxExceptions = @{
    "DeviceAttributesAllowedForOrigins" = "ChromeOS-only web-capability policy (Device Attributes API); intentionally included for future-proofing - see CHANGELOG.md"
}

# ─── Cross-Reference: Check each script policy against ADMX ───
Write-Host ""
Write-Host "================================================" -ForegroundColor Magenta
Write-Host "   ADMX Cross-Reference Validation" -ForegroundColor Magenta
Write-Host "================================================" -ForegroundColor Magenta

$found = 0
$notFound = 0
$knownExceptions = 0
$typeMismatch = 0
$valueNameMismatch = 0

foreach ($policyName in $scriptPolicyMap.Keys | Sort-Object) {
    $scriptEntry = $scriptPolicyMap[$policyName]
    $expectedType = $scriptEntry.Type

    if (-not $admxPolicyMap.ContainsKey($policyName)) {
        if ($knownAdmxExceptions.ContainsKey($policyName)) {
            Write-Result "Policy '$policyName' not in ADMX but is a documented exception: $($knownAdmxExceptions[$policyName])" -Level "Warning"
            $knownExceptions++
            continue
        }
        Write-Result "Policy '$policyName' not found in ADMX" -Level "Error"
        $notFound++
        $ExitCode = 1
        continue
    }

    $found++
    $admxEntry = $admxPolicyMap[$policyName]
    $admxType = $admxEntry.Type

    if ($VerboseOutput) {
        Write-Result "  $policyName → ADMX Type=$admxType, Script Type=$expectedType, ValueName=$($admxEntry.ValueName)" -Level "Info"
    }

    if ($admxType -eq "Unknown") {
        Write-Result "Policy '$policyName': ADMX has unknown type (check ADMX structure)" -Level "Warning"
    }

    if ($admxType -ne $expectedType) {
        # Special case: some ADMX boolean policies use "enabledValue" which maps to DWord
        # This is our expected mapping, but if ADMX shows something else we should flag it
        # Only flag actual mismatches where our type is wrong
        if ($admxType -ne "DWord" -or ($expectedType -ne "DWord" -and $expectedType -ne "String" -and $expectedType -ne "MultiString")) {
            # ADMX says DWord but we use String → error
            Write-Result "Policy '$policyName': Type mismatch! ADMX=$admxType, Script=$expectedType" -Level "Error"
            $typeMismatch++
            $ExitCode = 1
        } elseif ($admxType -eq "DWord" -and $expectedType -eq "String") {
            Write-Result "Policy '$policyName': ADMX expects DWord but script uses String" -Level "Error"
            $typeMismatch++
            $ExitCode = 1
        }
    }

    # Check ValueName consistency
    if ($admxEntry.ValueName -and $admxEntry.ValueName -ne $policyName) {
        Write-Result "Policy '$policyName': ValueName in ADMX is '$($admxEntry.ValueName)' but policy name is '$policyName'" -Level "Warning"
        $valueNameMismatch++
    }
}

# ─── Check for ADMX Brave-specific policies missing from our script ───
Write-Host ""
Write-Host "================================================" -ForegroundColor Magenta
Write-Host "   ADMX Brave-Only Policies Not In Script" -ForegroundColor Magenta
Write-Host "================================================" -ForegroundColor Magenta

# Identify policies that are Brave-specific (parentCategory starts with "BraveSoftware" or key starts with Brave namespace)
$braveCategories = @("BraveSoftware", "BraveVPN", "BraveRewards", "BraveWallet", "BraveShields", "BraveNews", "BraveSync", "BraveAI", "BraveTalk", "BravePlaylist", "BraveSpeedreader", "BraveP3A", "BraveStats", "BraveWebDiscovery")
$braveOnlyInAdmx = @()
foreach ($p in $policies) {
    $name = $p.name
    if ($name -like "Brave*" -and -not $name.EndsWith("_recommended") -and -not $scriptPolicyMap.ContainsKey($name)) {
        # Check parentCategory to see if it's under a Brave-specific category
        $parentCat = $p.parentCategory
        if ($parentCat) {
            $catRef = $parentCat.ref
            $isBraveSpecific = $false
            foreach ($bc in $braveCategories) {
                if ($catRef -and $catRef.StartsWith($bc)) { $isBraveSpecific = $true; break }
            }
            # Also include any policy with name starting with Brave that isn't in our list
            if (-not $isBraveSpecific) {
                # Check ADMX category hierarchy...
                # Simplified: just include any Brave-prefixed policy not in our script
                $isBraveSpecific = $true
            }
        } else {
            # No parentCategory, still flag as Brave-specific
        }
        $braveOnlyInAdmx += $name
    }
}

# Additional check: known Brave-specific policies from ADMX that we might be missing
$knownBraveOnlyPolicies = @()
foreach ($p in $policies) {
    $name = $p.name
    if ($name.EndsWith("_recommended")) { continue }
    # Check if parentCategory ref starts with "BraveSoftware" which is the main Brave-specific category
    $parentCat = $p.parentCategory
    if ($parentCat -and $parentCat.ref -eq "BraveSoftware") {
        if (-not $scriptPolicyMap.ContainsKey($name)) {
            $knownBraveOnlyPolicies += $name
        }
    }
}

$braveCategoriesAllRefs = @("BraveSoftware", "Accessibility", "ScreenCapture")
$braveOnlyParentCats = @("BraveSoftware", "Cat_Brave")
$otherBravePoliciesNotInScript = @()
foreach ($p in $policies) {
    $name = $p.name
    if ($name.EndsWith("_recommended")) { continue }
    if ($scriptPolicyMap.ContainsKey($name)) { continue }
    $parentCat = $p.parentCategory
    if ($parentCat) {
        $catRef = $parentCat.ref
        # Check if this policy is under BraveSoftware category (Brave-specific, not Chromium)
        if ($catRef -eq "BraveSoftware" -and $name -like "Brave*") {
            $otherBravePoliciesNotInScript += $name
        }
    }
}

if ($otherBravePoliciesNotInScript.Count -gt 0) {
    Write-Result "Brave-specific policies in ADMX (under `"BraveSoftware`" category) not in script:" -Level "Warning"
    foreach ($bp in ($otherBravePoliciesNotInScript | Sort-Object)) {
        $admxType = "?"
        if ($admxPolicyMap.ContainsKey($bp)) { $admxType = $admxPolicyMap[$bp].Type }
        Write-Result "  $bp (ADMX type: $admxType)" -Level "Warning"
    }
} else {
    Write-Result "All BraveSoftware-category policies in ADMX are covered by script" -Level "Info"
}

# ─── Summary ───
Write-Host ""
Write-Host "================================================" -ForegroundColor Magenta
Write-Host "   Validation Summary" -ForegroundColor Magenta
Write-Host "================================================" -ForegroundColor Magenta

Write-Host "  ADMX total entries:           $($policies.Count)" -ForegroundColor White
Write-Host "  ADMX unique policy names:     $($admxPolicyMap.Count)" -ForegroundColor White
Write-Host "  Script policies checked:      $($scriptPolicyMap.Count)" -ForegroundColor White
Write-Host "  Found in ADMX:                $found" -ForegroundColor Green
Write-Host "  Documented exceptions:        $knownExceptions" -ForegroundColor Yellow
Write-Host "  Not found in ADMX:            $notFound" -ForegroundColor $(if ($notFound -gt 0) { "Red" } else { "Green" })
Write-Host "  Type mismatches:              $typeMismatch" -ForegroundColor $(if ($typeMismatch -gt 0) { "Red" } else { "Green" })
Write-Host "  ValueName mismatches:         $valueNameMismatch" -ForegroundColor $(if ($valueNameMismatch -gt 0) { "Yellow" } else { "Green" })
Write-Host "  Brave policies not in script: $($otherBravePoliciesNotInScript.Count)" -ForegroundColor $(if ($otherBravePoliciesNotInScript.Count -gt 0) { "Yellow" } else { "Green" })
Write-Host ""

if ($ExitCode -eq 0 -and $ErrorMessages.Count -eq 0) {
    Write-Host "  PASS: All policies validated successfully." -ForegroundColor Green
} else {
    Write-Host "  FAIL: $($ErrorMessages.Count) error(s), $($WarningMessages.Count) warning(s)" -ForegroundColor Red
}

exit $ExitCode
