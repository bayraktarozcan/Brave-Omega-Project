param(
    [string]$AdmxUrl = "https://dl.google.com/dl/edgedl/chrome/policy/policy_templates.zip",
    [string]$BraveVersion = "1.92.134",
    [string]$PolicyFile = "Brave Omega/BraveOmega-EN.ps1",
    [string]$OutputPath = ".github/workflows/admx-validation-report.json"
)

$ErrorActionPreference = "Stop"

# -------------------------------------------------------------------
# 1. Download and extract Chrome ADMX template
# -------------------------------------------------------------------
Write-Host "::group::Download ADMX template"
$zipPath = Join-Path ([System.IO.Path]::GetTempPath()) "chrome-policy-template.zip"
$admxDir = Join-Path ([System.IO.Path]::GetTempPath()) "chrome-admx"

if (Test-Path $admxDir) { Remove-Item -Path $admxDir -Recurse -Force }
New-Item -Path $admxDir -ItemType Directory -Force | Out-Null

Write-Host "Downloading ADMX from: $AdmxUrl"
Invoke-WebRequest -Uri $AdmxUrl -OutFile $zipPath -UseBasicParsing
Write-Host "Extracting..."
Expand-Archive -Path $zipPath -DestinationPath $admxDir -Force
Write-Host "::endgroup::"

# Locate the main ADMX file
$admxFiles = Get-ChildItem -Path $admxDir -Recurse -Filter "*.admx"
if (-not $admxFiles) {
    Write-Host "::warning::No ADMX files found in the downloaded archive"
    return
}

$admxFile = $admxFiles | Select-Object -First 1
Write-Host "Using ADMX: $($admxFile.FullName)"

# -------------------------------------------------------------------
# 2. Parse ADMX policies
# -------------------------------------------------------------------
Write-Host "::group::Parse ADMX policies"

[xml]$admxXml = Get-Content -Path $admxFile.FullName -Raw
$ns = New-Object -TypeName System.Xml.XmlNamespaceManager -ArgumentList $admxXml.NameTable
$ns.AddNamespace("admx", "http://schemas.microsoft.com/GroupPolicy/2006/07/GroupPolicy.ADMX")

# Extract all policies
$admxPolicies = @{}
$policyNodes = $admxXml.SelectNodes("//admx:policy[@key='Software\Policies\BraveSoftware\Brave']", $ns)

if (-not $policyNodes -or $policyNodes.Count -eq 0) {
    Write-Host "No Brave-specific policies found; searching all policies..."
    $policyNodes = $admxXml.SelectNodes("//admx:policy", $ns)
}

foreach ($policyNode in $policyNodes) {
    $name = $policyNode.GetAttribute("name")
    if (-not $name) { continue }

    $elements = $policyNode.SelectSingleNode("admx:elements", $ns)
    $admxType = "Unknown"

    if ($elements) {
        foreach ($child in $elements.ChildNodes) {
            $tag = $child.LocalName
            if ($tag -eq "boolean" ) { $admxType = "DWord"; break }
            if ($tag -eq "decimal" ) { $admxType = "DWord"; break }
            if ($tag -eq "enum"    ) { 
                # Check if enum values are decimal or string
                $firstItem = $child.SelectSingleNode("admx:item/admx:value/admx:decimal", $ns)
                if ($firstItem) { $admxType = "DWord" } else { $admxType = "String" }
                break
            }
            if ($tag -eq "text"     ) { $admxType = "String"; break }
            if ($tag -eq "multiText") { $admxType = "MultiString"; break }
            if ($tag -eq "list"     ) { $admxType = "MultiString"; break }
        }
    }

    $admxPolicies[$name] = @{
        Name = $name
        Type = $admxType
        Class = $policyNode.GetAttribute("class")
    }
}

Write-Host "Parsed $($admxPolicies.Count) policies from ADMX"
Write-Host "::endgroup::"

# -------------------------------------------------------------------
# 3. Parse PowerShell script policies
# -------------------------------------------------------------------
Write-Host "::group::Parse PowerShell script policies"

$scriptContent = Get-Content -Path $PolicyFile -Raw
$scriptPolicies = @{}

# Match all policy hashtables: @{Name="PolicyName"; Value=...; Type="..."}
$pattern = '@\{Name="([^"]+)"\s*;\s*Value=([^;]+)\s*;\s*Type="([^"]+)"\}'
$matches = [regex]::Matches($scriptContent, $pattern)

foreach ($match in $matches) {
    $name = $match.Groups[1].Value
    $value = $match.Groups[2].Value.Trim()
    $type = $match.Groups[3].Value

    $scriptPolicies[$name] = @{
        Name = $name
        Value = $value
        Type = $type
    }
}

Write-Host "Parsed $($scriptPolicies.Count) policies from PowerShell script"
Write-Host "::endgroup::"

# -------------------------------------------------------------------
# 4. Compare policies
# -------------------------------------------------------------------
Write-Host "::group::Compare policies"

$mismatches = @()
$matchedPolicies = 0

foreach ($sName in $scriptPolicies.Keys) {
    $sPolicy = $scriptPolicies[$sName]

    if ($admxPolicies.ContainsKey($sName)) {
        $aPolicy = $admxPolicies[$sName]

        # Compare types
        $scriptType = $sPolicy.Type
        $admxType = $aPolicy.Type

        if ($scriptType -ne $admxType) {
            $mismatches += @{
                policy = $sName
                field = "Type"
                scriptType = $scriptType
                admxType = $admxType
                scriptValue = $sPolicy.Value
                admxValue = "N/A"
            }
        } else {
            $matchedPolicies++
        }
    }
}

# Policies in ADMX but not in script
$unmatchedAdmx = @()
foreach ($aName in $admxPolicies.Keys) {
    if (-not $scriptPolicies.ContainsKey($aName)) {
        $unmatchedAdmx += $aName
    }
}

# Policies in script but not in ADMX
$unmatchedScript = @()
foreach ($sName in $scriptPolicies.Keys) {
    if (-not $admxPolicies.ContainsKey($sName)) {
        $unmatchedScript += $sName
    }
}

Write-Host "Matched: $matchedPolicies | Mismatches: $($mismatches.Count) | ADMX-only: $($unmatchedAdmx.Count) | Script-only: $($unmatchedScript.Count)"
Write-Host "::endgroup::"

# -------------------------------------------------------------------
# 5. Generate report
# -------------------------------------------------------------------
$report = @{
    date = (Get-Date -Format "yyyy-MM-dd HH:mm:ss UTC")
    braveVersion = $BraveVersion
    admxUrl = $AdmxUrl
    matchedPolicies = $matchedPolicies
    mismatches = $mismatches
    unmatchedAdmx = $unmatchedAdmx | Sort-Object
    unmatchedScript = $unmatchedScript | Sort-Object
    summary = @{
        totalInAdmx = $admxPolicies.Count
        totalInScript = $scriptPolicies.Count
        matched = $matchedPolicies
        typeMismatches = $mismatches.Count
        newInAdmx = $unmatchedAdmx.Count
        braveSpecific = $unmatchedScript.Count
    }
}

$reportJson = $report | ConvertTo-Json -Depth 5
$reportJson | Out-File -FilePath $OutputPath -Encoding utf8

Write-Host "Report saved to: $OutputPath"

# Also write to GitHub step summary
$summaryPath = $env:GITHUB_STEP_SUMMARY
if ($summaryPath) {
    $markdown = @"
## ADMX Validation Report

| Metric | Value |
|--------|-------|
| Brave Version | $BraveVersion |
| ADMX Source | $AdmxUrl |
| Total in ADMX | $($admxPolicies.Count) |
| Total in Script | $($scriptPolicies.Count) |
| Matched | $matchedPolicies |
| Type Mismatches | $($mismatches.Count) |
| New in ADMX (not in script) | $($unmatchedAdmx.Count) |
| Brave-specific (not in ADMX) | $($unmatchedScript.Count) |
"@
    Add-Content -Path $summaryPath -Value $markdown
}

# -------------------------------------------------------------------
# 6. Exit with appropriate code
# -------------------------------------------------------------------
if ($mismatches.Count -gt 0) {
    Write-Host "::warning title=ADMX Mismatch::$($mismatches.Count) policy type mismatch(es) found"
}
if ($unmatchedAdmx.Count -gt 0) {
    Write-Host "::notice title=New ADMX Policies::$($unmatchedAdmx.Count) new policies in ADMX not yet in script"
}
if ($unmatchedScript.Count -gt 0) {
    Write-Host "::notice title=Brave-specific Policies::$($unmatchedScript.Count) script policies not found in Chrome ADMX"
}
