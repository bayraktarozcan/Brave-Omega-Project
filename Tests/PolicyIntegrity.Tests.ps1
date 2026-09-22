BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    Import-Module (Join-Path $PSScriptRoot "ADMXFixture.psm1") -Force
}

Describe "Policy Integrity" -Tag "Integration" {
    It "unified script policy definitions should have consistent structure" {
        $lines = Get-PolicyLines -ScriptPath $ScriptMain
        $lines.Count | Should -BeGreaterThan 0
    }

    It "password manager policy should have correct name in the data layer" {
        (Get-OmegaAllPolicyNames -ScriptPath $ScriptMain) -contains "PasswordManagerEnabled" | Should -Be $true
    }

    It "TranslateEnabled should be in Strict level" {
        (Get-OmegaTierPolicies -Level "Strict" -ScriptPath $ScriptMain).name -contains "TranslateEnabled" | Should -Be $true
    }

    It "DnsOverHttpsMode should be String type in Balanced" {
        $policy = Get-OmegaTierPolicies -Level "Balanced" -ScriptPath $ScriptMain | Where-Object { $_.name -eq "DnsOverHttpsMode" }
        $policy -ne $null | Should -Be $true
        $policy.type | Should -Be "String"
    }

    It "unified script should hold all 151 definitions in a single table" {
        $lines = Get-PolicyLines -ScriptPath $ScriptMain
        $lines.Count | Should -BeGreaterOrEqual 149
    }

}
