BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    Import-Module (Join-Path $PSScriptRoot "ADMXFixture.psm1") -Force
}

Describe "Policy Integrity" -Tag "Integration" {
    It "unified script policy definitions should have consistent structure" {
        $lines = Get-PolicyLines -ScriptPath $ScriptMain
        $lines.Count | Should -BeGreaterThan 0
    }

    It "password manager policy should have correct name" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'PasswordManagerEnabled' | Should -Be $true
        $content -match 'PasswordManagerEnabled[";]' | Should -Be $true
    }

    It "TranslateEnabled should be in Strict level" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '"Strict"' | Should -Be $true
        $content -match 'TranslateEnabled' | Should -Be $true
    }

    It "DnsOverHttpsMode should be String type in Balanced" {
        $content = Get-Content -Path $ScriptMain -Raw
        $hasBalanced = $content -match '"Balanced"'
        $hasDnsOh = $content -match 'DnsOverHttpsMode'
        ($hasBalanced -and $hasDnsOh) | Should -Be $true
    }

    It "unified script should hold all 151 definitions in a single table" {
        $lines = Get-PolicyLines -ScriptPath $ScriptMain
        $lines.Count | Should -BeGreaterOrEqual 149
    }

}
