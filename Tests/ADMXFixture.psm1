$ProjectRoot = Split-Path -Parent $PSScriptRoot
$admxPath = Join-Path $ProjectRoot "admx\brave.admx"
$admxValidatePath = Join-Path $ProjectRoot "admx\admx-validate.ps1"
$scriptMain = Join-Path $ProjectRoot "Brave Omega\BraveOmega.ps1"

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
    if (-not (Test-Path $scriptMain)) { throw "Script not found: $scriptMain" }
    $dataDir = Split-Path -Path $scriptMain -Parent
    $config = Get-Content -Path (Join-Path $dataDir "config.json") -Raw | ConvertFrom-Json
    $profilesDir = Join-Path $dataDir "profiles"
    $names = @()
    foreach ($tier in @($config.levelOrder)) {
        if (-not (Test-Path (Join-Path $profilesDir "$tier.json"))) { continue }
        $profile = Get-Content -Path (Join-Path $profilesDir "$tier.json") -Raw | ConvertFrom-Json
        foreach ($p in @($profile.policies)) { $names += $p.name }
    }
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
    $dataDir = Split-Path -Path $scriptMain -Parent
    $config = Get-Content -Path (Join-Path $dataDir "config.json") -Raw | ConvertFrom-Json
    $profilesDir = Join-Path $dataDir "profiles"
    foreach ($tier in @($config.levelOrder)) {
        if (-not (Test-Path (Join-Path $profilesDir "$tier.json"))) { continue }
        $profile = Get-Content -Path (Join-Path $profilesDir "$tier.json") -Raw | ConvertFrom-Json
        foreach ($p in @($profile.policies)) {
            if ($p.name -eq $PolicyName -and $p.value -eq $ExpectedValue) { return $true }
        }
    }
    return $false
}

function Invoke-AdmxValidation {
    & $admxValidatePath
}

Export-ModuleMember -Function Get-AdmxPolicyNames, Get-ScriptPolicyNames, Get-AdmxCategoryTree, Test-PolicyTypeMatch, Invoke-AdmxValidation
