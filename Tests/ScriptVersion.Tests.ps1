BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Script Version Consistency" -Tag "Integration" {
    It "EN script should have correct version string" {
        $v = Get-VariableRegex -ScriptPath $ScriptEN -VariableName "ScriptVersion"
        $v | Should -BeExactly "v2.3.0.0"
    }

    It "TR script should have correct version string" {
        $v = Get-VariableRegex -ScriptPath $ScriptTR -VariableName "BetikSurum"
        $v | Should -BeExactly "v2.3.0.0"
    }

    It "EN and TR script versions should match" {
        $enV = Get-VariableRegex -ScriptPath $ScriptEN -VariableName "ScriptVersion"
        $trV = Get-VariableRegex -ScriptPath $ScriptTR -VariableName "BetikSurum"
        $enV | Should -BeExactly $trV
    }

    It "EN should have validated Brave version" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '1\.92\.138' | Should -Be $true
    }

    It "EN should have validated Chromium version" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '\b150\b' | Should -Be $true
    }
}
