BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $rawContent = Get-Content -Path $ScriptEN -Raw
    $tokens = $null; $errors = $null
    [System.Management.Automation.Language.Parser]::ParseInput($rawContent, [ref]$tokens, [ref]$errors)
    $syntaxErrors = $errors
}

Describe "Full Pipeline (EN)" -Tag "Integration" {
    It "should load without unhandled syntax errors" {
        $unhandled = $syntaxErrors | Where-Object {
            $_.Id -ne "ParserMissingEndCurlyBrace" -and
            ($_.Id -ne "ParserError" -or $_.Message -notmatch "Missing closing '}'")
        }
        $unhandled | Should -BeNullOrEmpty
    }

    It "should define Get-BraveVersion function" {
        $names = Get-ScriptFunctions -ScriptPath $ScriptEN
        $names -contains "Get-BraveVersion" | Should -Be $true
    }

    It "should define Write-PolicyValue function" {
        $names = Get-ScriptFunctions -ScriptPath $ScriptEN
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
