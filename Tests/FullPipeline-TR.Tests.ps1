BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $rawContent = Get-Content -Path $ScriptMain -Raw
    $tokens = $null; $errors = $null
    [System.Management.Automation.Language.Parser]::ParseInput($rawContent, [ref]$tokens, [ref]$errors)
    $syntaxErrors = $errors
    $dotlessI = [char]0x0131
}

Describe "Full Pipeline (TR coverage via unified script)" -Tag "Integration" {
    It "should load without unhandled syntax errors" {
        $unhandled = $syntaxErrors | Where-Object {
            $_.Id -ne "ParserMissingEndCurlyBrace" -and
            ($_.Id -ne "ParserError" -or $_.Message -notmatch "Missing closing '}'")
        }
        $unhandled | Should -BeNullOrEmpty
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

    It "should pin the TR wrapper to Turkish" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match "\['Language'\] = 'TR'" | Should -Be $true
    }

    It "should have a single script version variable" {
        $v = Get-VariableRegex -ScriptPath $ScriptMain -VariableName "ScriptVersion"
        $v | Should -BeExactly "v2.6.2.0"
    }
}
