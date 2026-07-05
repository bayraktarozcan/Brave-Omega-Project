$ProjectRoot = Split-Path -Parent $PSScriptRoot
$admxPath = Join-Path $ProjectRoot "admx\brave.admx"
$admxValidatePath = Join-Path $ProjectRoot "admx\admx-validate.ps1"
$scriptEN = Join-Path $ProjectRoot "Brave Omega\BraveOmega-EN.ps1"

function Get-AdmxPolicyNames {
    if (-not (Test-Path $admxPath)) { throw "ADMX file not found: $admxPath" }
    $xml = [xml](Get-Content -Path $admxPath -Raw)
    $policies = @()
    $nodes = $xml.SelectNodes("//*[local-name()='policy']")
    foreach ($node in $nodes) {
        $name = $node.GetAttribute("name")
        if ($name -and $name -notin $policies) { $policies += $name }
    }
    return $policies | Sort-Object
}

function Get-ScriptPolicyNames {
    if (-not (Test-Path $scriptEN)) { throw "Script not found: $scriptEN" }
    $content = Get-Content -Path $scriptEN -Raw
    $pattern = 'Name\s*=\s*"([^"]+)"'
    $matches = [regex]::Matches($content, $pattern)
    $names = @()
    foreach ($m in $matches) { $names += $m.Groups[1].Value }
    return $names | Sort-Object -Unique
}

function Get-AdmxCategoryTree {
    if (-not (Test-Path $admxPath)) { throw "ADMX file not found: $admxPath" }
    $xml = [xml](Get-Content -Path $admxPath -Raw)
    $categories = @()
    $nodes = $xml.SelectNodes("//*[local-name()='category']")
    foreach ($node in $nodes) {
        $categories += @{
            Name = $node.GetAttribute("name")
            DisplayName = $node.GetAttribute("displayName")
        }
    }
    return $categories
}

function Test-PolicyTypeMatch {
    param(
        [string]$PolicyName,
        [int]$ExpectedValue
    )
    $scriptContent = Get-Content -Path $scriptEN -Raw
    $pattern = "Name\s*=\s*`"$PolicyName`"\s*;\s*Value\s*=\s*(\d+)"
    $match = [regex]::Match($scriptContent, $pattern)
    if (-not $match.Success) { return $false }
    $actualValue = [int]$match.Groups[1].Value
    return ($actualValue -eq $ExpectedValue)
}

function Invoke-AdmxValidation {
    & $admxValidatePath
}

Export-ModuleMember -Function Get-AdmxPolicyNames, Get-ScriptPolicyNames, Get-AdmxCategoryTree, Test-PolicyTypeMatch, Invoke-AdmxValidation
