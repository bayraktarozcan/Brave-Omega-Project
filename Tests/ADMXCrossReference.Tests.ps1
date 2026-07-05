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
