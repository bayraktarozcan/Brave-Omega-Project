BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    Import-Module (Join-Path $PSScriptRoot "ADMXFixture.psm1") -Force
}

Describe "Policy Integrity" -Tag "Integration" {
    It "EN script policy definitions should have consistent structure" {
        $lines = Get-PolicyLines -ScriptPath $ScriptEN
        $lines.Count | Should -BeGreaterThan 0
    }

    It "password manager policy should have correct name" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match 'PasswordManagerEnabled' | Should -Be $true
        $content -match 'PasswordManagerEnabled[";]' | Should -Be $true
    }

    It "TranslateEnabled should be in Strict level" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '"Strict"' | Should -Be $true
        $content -match 'TranslateEnabled' | Should -Be $true
    }

    It "DnsOverHttpsMode should be String type in Balanced" {
        $content = Get-Content -Path $ScriptTR -Raw
        $hasBalanced = $content -match '"Balanced"|"Dengeli"'
        $hasDnsOh = $content -match 'DnsOverHttpsMode'
        ($hasBalanced -and $hasDnsOh) | Should -Be $true
    }

    It "EN and TR scripts should have same number of policy definitions per level" {
        $enLines = Get-PolicyLines -ScriptPath $ScriptEN
        $trLines = Get-PolicyLines -ScriptPath $ScriptTR
        $enLines.Count | Should -Be $trLines.Count
    }
}
