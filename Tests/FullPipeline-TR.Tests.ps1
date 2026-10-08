BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $dotlessI = [char]0x0131
}

Describe "Full Pipeline (TR coverage via unified script)" -Tag "Integration" {
    It "should load without unhandled syntax errors" {
        (Get-OmegaUnhandledSyntaxErrors -ScriptPath $ScriptMain) | Should -BeNullOrEmpty
    }

    It "should define shared functions (single source)" {
        $names = Get-ScriptFunctions -ScriptPath $ScriptMain
        $names -contains "Get-BraveVersion" | Should -Be $true
        $names -contains "Write-PolicyValue" | Should -Be $true
        $names -contains "Get-LocalizedString" | Should -Be $true
    }

    It "should carry Turkish UI text in the strings table" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content.Contains("Brave Yaln$($dotlessI)z") | Should -Be $true
        $content -match '"Temel"' | Should -Be $true
        $content -match '"Dengeli"' | Should -Be $true
        $content.Contains("Kat$($dotlessI)") | Should -Be $true
    }

    It "should have a single script version variable" {
        $v = Get-VariableRegex -ScriptPath $ScriptMain -VariableName "ScriptVersion"
        $v | Should -BeExactly "v3.1.0.0"
    }
}
