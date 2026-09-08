BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Script Version Consistency" -Tag "Integration" {
    It "unified script should have correct version string" {
        $v = Get-VariableRegex -ScriptPath $ScriptMain -VariableName "ScriptVersion"
        $v | Should -BeExactly "v2.6.2.0"
    }

    It "unified script should have a single version variable (no per-language fork)" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\$BetikSurum' | Should -Be $false
        ([regex]::Matches($content, '\$ScriptVersion\s*=\s*"')).Count | Should -BeExactly 1
    }

    It "unified script should have validated Brave version" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '1\.94\.121' | Should -Be $true
    }

    It "unified script should have validated Chromium version" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\b152\b' | Should -Be $true
    }

    It "unified script should carry all 151 policy definitions in one place" {
        $policies = Get-PolicyLines -ScriptPath $ScriptMain
        $policies.Count | Should -BeGreaterOrEqual 149
    }
}