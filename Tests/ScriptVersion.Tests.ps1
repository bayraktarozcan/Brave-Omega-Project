BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Script Version Consistency" -Tag "Integration" {
    It "EN script should have correct version string" {
        $v = Get-VariableRegex -ScriptPath $ScriptEN -VariableName "ScriptVersion"
        $v | Should -BeExactly "v2.4.2.0"
    }

    It "TR script should have correct version string" {
        $v = Get-VariableRegex -ScriptPath $ScriptTR -VariableName "BetikSurum"
        $v | Should -BeExactly "v2.4.2.0"
    }

    It "EN and TR script versions should match" {
        $enV = Get-VariableRegex -ScriptPath $ScriptEN -VariableName "ScriptVersion"
        $trV = Get-VariableRegex -ScriptPath $ScriptTR -VariableName "BetikSurum"
        $enV | Should -BeExactly $trV
    }

    It "EN should have validated Brave version" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '1\.92\.141' | Should -Be $true
    }

    It "EN should have validated Chromium version" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '\b150\b' | Should -Be $true
    }

    It "TR should have validated Brave version" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match '1\.92\.141' | Should -Be $true
    }

    It "TR should have validated Chromium version" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match '\b150\b' | Should -Be $true
    }

    It "EN and TR should have same policy count in definitions" {
        $enPolicies = Get-PolicyLines -ScriptPath $ScriptEN
        $trPolicies = Get-PolicyLines -ScriptPath $ScriptTR
        $enPolicies.Count | Should -Be $trPolicies.Count
    }
}
