BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    Import-Module (Join-Path $PSScriptRoot "ADMXFixture.psm1") -Force
}

Describe "ADMX Cross-Reference" -Tag "Integration" {
    It "ADMX file should exist" {
        Test-Path (Join-Path $ProjectRoot "admx\brave.admx") | Should -Be $true
    }

    It "ADML file should exist" {
        Test-Path (Join-Path $ProjectRoot "admx\brave.adml") | Should -Be $true
    }

    It "ADMX validation script should exist" {
        Test-Path (Join-Path $ProjectRoot "admx\admx-validate.ps1") | Should -Be $true
    }

    It "script should contain at least some ADMX-referenced policy names" {
        $admxNames = Get-AdmxPolicyNames
        $scriptNames = Get-ScriptPolicyNames
        $overlap = $admxNames | Where-Object { $_ -in $scriptNames }
        $overlap.Count | Should -BeGreaterOrEqual 10
    }

    It "ADMX should have at least one category defined" {
        $cats = Get-AdmxCategoryTree
        $cats.Count | Should -BeGreaterOrEqual 1
    }
}

Describe "ADMX Cross-Reference - Documented Exceptions" -Tag "Integration" {
    It "validator should declare a documented-exception map" {
        $validatorPath = Join-Path $PSScriptRoot "..\admx\admx-validate.ps1"
        $content = Get-Content -Path $validatorPath -Raw
        $content -match '\$knownAdmxExceptions\s*=\s*@\{' | Should -Be $true
        $content -match 'DeviceAttributesAllowedForOrigins' | Should -Be $true
    }

    It "validator should run cleanly with no failures" {
        $validatorPath = Join-Path $PSScriptRoot "..\admx\admx-validate.ps1"
        & $validatorPath 2>&1 | Out-Null
        $LASTEXITCODE | Should -Be 0
    }

    It "validator should check documented exceptions before reporting a not-found error" {
        $validatorPath = Join-Path $PSScriptRoot "..\admx\admx-validate.ps1"
        $content = Get-Content -Path $validatorPath -Raw
        $exceptionIdx = $content.IndexOf('$knownAdmxExceptions.ContainsKey($policyName)')
        $errorIdx = $content.IndexOf('Policy ''$policyName'' not found in ADMX')
        $exceptionIdx | Should -BeGreaterThan 0
        $errorIdx | Should -BeGreaterThan 0
        $exceptionIdx | Should -BeLessThan $errorIdx
        $content -match '\$knownExceptions\+\+' | Should -Be $true
    }
}
