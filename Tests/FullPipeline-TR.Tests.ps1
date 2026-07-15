BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $rawContent = Get-Content -Path $ScriptTR -Raw
    $tokens = $null; $errors = $null
    [System.Management.Automation.Language.Parser]::ParseInput($rawContent, [ref]$tokens, [ref]$errors)
    $syntaxErrors = $errors
}

$dotlessI = [char]0x0131

Describe "Full Pipeline (TR)" -Tag "Integration" {
    It "should load without syntax errors" {
        $syntaxErrors | Where-Object { $_.Id -ne "ParserMissingEndCurlyBrace" } | Should -BeNullOrEmpty
    }

    It "should define Turkish-named functions" {
        $names = Get-ScriptFunctions -ScriptPath $ScriptTR
        $names -contains "Get-BraveVersion" | Should -Be $true
        $names -contains "Yaz-KayitDegeri" | Should -Be $true
    }

    It "should define Turkish level names" {
        $content = Get-Content -Path $ScriptTR -Raw
        Write-Debug "dotlessI val: '$([char]0x0131)'"
        Write-Debug "Yalnız check: $($content.Contains("Brave Yaln$([char]0x0131)z"))"
        $content.Contains("Brave Yaln$([char]0x0131)z") | Should -Be $true
        $content -match '"Temel"' | Should -Be $true
        $content -match '"Dengeli"' | Should -Be $true
        $content.Contains("Kat$([char]0x0131)") | Should -Be $true
    }

    It "should have Turkish version variable" {
        $v = Get-VariableRegex -ScriptPath $ScriptTR -VariableName "BetikSurum"
        $v | Should -BeExactly "v2.4.1.0"
    }
}
