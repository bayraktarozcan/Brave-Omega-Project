BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $scriptBlock = New-FunctionScriptBlock -ScriptPath $ScriptEN
    $rawContent = Get-Content -Path $ScriptEN -Raw
    $tokens = $null; $errors = $null
    [System.Management.Automation.Language.Parser]::ParseInput($rawContent, [ref]$tokens, [ref]$errors)
    $syntaxErrors = $errors
}

Describe "Full Pipeline (EN)" -Tag "Integration" {
    It "should load without syntax errors" {
        $syntaxErrors | Where-Object { $_.Id -ne "ParserMissingEndCurlyBrace" } | Should -BeNullOrEmpty
    }

    It "should define all required functions" {
        $names = Get-ScriptFunctions -ScriptPath $ScriptEN
        $names -contains "Get-BraveVersion" | Should -Be $true
        $names -contains "Write-PolicyValue" | Should -Be $true
    }

    It "should have required level order" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '\$LevelOrder\s*=\s*@\("BraveOnly"\s*,\s*"Essential"\s*,\s*"Balanced"\s*,\s*"Advanced"\s*,\s*"Strict"\)' | Should -Be $true
    }

    It "should define valid level names" {
        $names = Get-VariableRegex -ScriptPath $ScriptEN -VariableName "ValidLevels"
        $names -ne $null | Should -Be $true
    }
}
