param(
    [string]$AdmxUrl = "https://dl.google.com/update2/installers/ChromePolicyTemplate_149.zip",
    [string]$BraveVersion = "1.91.175",
    [string]$PolicyFile = "Brave Omega/BraveOmega-EN.ps1"
)

$ErrorActionPreference = "Stop"
$reportPath = Join-Path $PSScriptRoot "admx-validation-report.json"

Write-Host "=== ADMX Policy Validation ===" -ForegroundColor Cyan
Write-Host "Brave Version : $BraveVersion" -ForegroundColor Gray
Write-Host "ADMX URL      : $AdmxUrl`n" -ForegroundColor Gray

# ─────────────────────────────────────────────────────────────────────────────
# STEP 1: Download and extract ADMX
# ─────────────────────────────────────────────────────────────────────────────
$tmpDir = Join-Path $env:TEMP "admx-validate-$(Get-Random)"
New-Item -Path $tmpDir -ItemType Directory -Force | Out-Null

$zipPath = Join-Path $tmpDir "admx.zip"
Write-Host "[1/4] Downloading ADMX template from $AdmxUrl..." -ForegroundColor Gray
try {
    Invoke-WebRequest -Uri $AdmxUrl -OutFile $zipPath -ErrorAction Stop
    Write-Host "  -> Downloaded to $zipPath" -ForegroundColor DarkGreen
} catch {
    Write-Host "  [WARN] Could not download ADMX template: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "  -> Writing empty report (validation skipped)."
    $report = @{
        date = (Get-Date -Format "yyyy-MM-dd HH:mm:ss UTC")
        braveVersion = $BraveVersion
        status = "skipped"
        mismatches = @()
        unmatchedAdmx = @()
        unmatchedScript = @()
        message = "ADMX download failed: $($_.Exception.Message)"
    }
    $report | ConvertTo-Json -Depth 3 | Set-Content $reportPath -Encoding utf8
    exit 0
}

Write-Host "[2/4] Extracting ADMX..." -ForegroundColor Gray
try {
    Expand-Archive -Path $zipPath -DestinationPath $tmpDir -Force
    Write-Host "  -> Extracted to $tmpDir" -ForegroundColor DarkGreen
} catch {
    Write-Host "  [WARN] Could not extract archive: $($_.Exception.Message)"
    exit 0
}

# Find the ADMX file
$admxFiles = Get-ChildItem -Path $tmpDir -Recurse -Filter "*.admx" -ErrorAction SilentlyContinue
if (-not $admxFiles) {
    Write-Host "  [WARN] No ADMX files found in archive."
    exit 0
}
Write-Host "  -> Found $($admxFiles.Count) ADMX files" -ForegroundColor DarkGreen

# ─────────────────────────────────────────────────────────────────────────────
# STEP 2: Parse ADMX policies
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[3/4] Parsing ADMX definitions..." -ForegroundColor Gray

$admxPolicies = @{}
foreach ($admxFile in $admxFiles) {
    [xml]$admxXml = Get-Content $admxFile.FullName -Raw

    # Each <policy> element has name, class, and child <elements> with value info
    $policies = $admxXml.SelectNodes("//policy") | Where-Object { $_.name }
    foreach ($pol in $policies) {
        $name = $pol.name
        $polClass = $pol.class
        $type = "DWord"  # Default for Chromium policies

        # Check for enumeration (string-type) policies
        $enum = $pol.SelectSingleNode(".//enum")
        if ($enum) {
            $type = "String"
        }

        # Check for list (multi-string) policies
        $list = $pol.SelectSingleNode(".//list")
        if ($list) {
            $type = "MultiString"
        }

        # Check for decimal (DWord) policies explicitly
        $decimal = $pol.SelectSingleNode(".//decimal")
        if ($decimal) {
            $type = "DWord"
        }

        # Get supported values if available
        $supportedValues = @()
        if ($enum) {
            $items = $enum.SelectNodes(".//item")
            foreach ($item in $items) {
                $displayName = $item.GetAttribute("displayName")
                $value = $item.GetAttribute("value")
                $supportedValues += @{ displayName = $displayName; value = $value }
            }
        }

        if (-not $admxPolicies.ContainsKey($name)) {
            $admxPolicies[$name] = @{
                Name = $name
                Class = $polClass
                Type = $type
                SupportedValues = $supportedValues
            }
        }
    }

    # Also check <string> elements for value definitions
    $stringTable = $admxXml.SelectNodes("//stringTable/string")
    # Not needed for basic validation
}

Write-Host "  -> Parsed $($admxPolicies.Count) policies from ADMX`n" -ForegroundColor DarkGreen

# ─────────────────────────────────────────────────────────────────────────────
# STEP 3: Parse script policies
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[4/4] Parsing script policy definitions..." -ForegroundColor Gray

$scriptPolicies = @{}
if (Test-Path $PolicyFile) {
    $scriptContent = Get-Content $PolicyFile -Raw

    # Extract policy definitions from $PolicyDefinitions hash table
    # Pattern: @{Name="PolicyName"; Value=...; Type="DWord|String|MultiString"}
    $pattern = [regex]'@\{Ad="([^"]+)"[^}]+Deger=([^;]+)[^}]+Tur="([^"]+)"\}'
    $matches = $pattern.Matches($scriptContent)

    # Also try English parameter name pattern
    if ($matches.Count -eq 0) {
        $pattern = [regex]'@\{Name="([^"]+)"[^}]+Value=([^;]+)[^}]+Type="([^"]+)"\}'
        $matches = $pattern.Matches($scriptContent)
    }

    foreach ($m in $matches) {
        $polName = $m.Groups[1].Value
        $polValue = $m.Groups[2].Value.Trim()
        $polType = $m.Groups[3].Value.Trim()
        $scriptPolicies[$polName] = @{
            Name = $polName
            Value = $polValue
            Type = $polType
        }
    }

    Write-Host "  -> Parsed $($scriptPolicies.Count) policies from script" -ForegroundColor DarkGreen
} else {
    Write-Host "  [WARN] Policy file not found: $PolicyFile" -ForegroundColor Yellow
    exit 0
}

# ─────────────────────────────────────────────────────────────────────────────
# STEP 4: Compare
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "`nComparing policies..." -ForegroundColor Cyan

$mismatches = @()
$unmatchedScript = @()
$unmatchedAdmx = @()

foreach ($sp in $scriptPolicies.Keys) {
    if ($admxPolicies.ContainsKey($sp)) {
        $admxPol = $admxPolicies[$sp]
        $scriptPol = $scriptPolicies[$sp]

        # Compare types
        if ($admxPol.Type -ne $scriptPol.Type) {
            $mismatches += @{
                policy = $sp
                scriptType = $scriptPol.Type
                admxType = $admxPol.Type
                scriptValue = $scriptPol.Value
                admxValue = "type: $($admxPol.Type)"
            }
        }
    } else {
        $unmatchedScript += $sp
    }
}

# Find ADMX policies not in script (limited to Chromium-level policies)
$knownPrefixes = @(
    "Brave", "Tor", "MetricsReporting", "SafeBrowsing", "UrlKeyed",
    "SearchSuggest", "NetworkPrediction", "Translate", "Spellcheck",
    "AlternateErrorPages", "BrowserNetworkTime", "DomainReliability",
    "BackgroundMode", "WebRtc", "AudioCapture", "VideoCapture",
    "HttpsOnlyMode", "DnsOverHttps", "BlockThirdPartyCookies",
    "PasswordManager", "Autofill", "ShowFullUrls", "DisableSafeBrowsing",
    "QuicAllowed", "ChromeVariations", "NetworkServiceSandbox",
    "AudioSandbox", "DefaultGeolocation", "DefaultNotifications",
    "DefaultPopups", "DefaultMediaStream", "DefaultSensors",
    "DefaultLocalFonts", "DefaultClipboard", "DefaultFileSystem",
    "DefaultSerial", "DefaultIdleDetection", "DefaultInsecureContent",
    "DefaultJavaScriptJit", "DefaultCookies", "BrowserGuestMode",
    "BrowserAddPerson", "CloudPrintProxy", "ImportAutofill",
    "ImportBookmarks", "ImportHistory", "ImportSavedPasswords",
    "ImportSearchEngine", "ImportHomepage", "UsageStatsInSample",
    "TorDisabled"
)

$interestingNewPolicies = @()
foreach ($ap in $admxPolicies.Keys) {
    if (-not $scriptPolicies.ContainsKey($ap)) {
        # Check if this is a policy relevant to Brave/Chromium privacy
        $isRelevant = $false
        foreach ($prefix in $knownPrefixes) {
            if ($ap -like "$prefix*") {
                $isRelevant = $true
                break
            }
        }
        if ($isRelevant) {
            $interestingNewPolicies += $ap
        }
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# STEP 5: Generate report
# ─────────────────────────────────────────────────────────────────────────────
$report = @{
    date = (Get-Date -Format "yyyy-MM-dd HH:mm:ss UTC")
    braveVersion = $BraveVersion
    status = "completed"
    policiesInScript = $scriptPolicies.Count
    policiesInAdmx = $admxPolicies.Count
    mismatches = $mismatches
    unmatchedScript = $unmatchedScript
    unmatchedAdmx = $interestingNewPolicies
    message = "$($mismatches.Count) mismatches, $($interestingNewPolicies.Count) new policies available in ADMX"
}

$report | ConvertTo-Json -Depth 3 | Set-Content $reportPath -Encoding utf8
Write-Host "`nReport written to: $reportPath" -ForegroundColor DarkGreen

if ($mismatches.Count -gt 0) {
    Write-Host "`n[MISMATCHES FOUND]" -ForegroundColor Red
    foreach ($m in $mismatches) {
        Write-Host "  $($m.policy): Script=$($m.scriptType)/$($m.scriptValue) vs ADMX=$($m.admxType)/$($m.admxValue)" -ForegroundColor Yellow
    }
}
if ($interestingNewPolicies.Count -gt 0) {
    Write-Host "`n[NEW POLICIES AVAILABLE]" -ForegroundColor Green
    foreach ($p in $interestingNewPolicies) {
        Write-Host "  $p" -ForegroundColor DarkGray
    }
}
if ($mismatches.Count -eq 0 -and $interestingNewPolicies.Count -eq 0) {
    Write-Host "`n[OK] All policies match ADMX definitions. No new policies found." -ForegroundColor Green
}

# Cleanup
Remove-Item -Path $tmpDir -Recurse -Force -ErrorAction SilentlyContinue

exit ($mismatches.Count -gt 0 ? 1 : 0)
