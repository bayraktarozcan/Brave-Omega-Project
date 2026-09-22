BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $rawContent = Get-Content -Path $ScriptMain -Raw
    $tokens = $null; $errors = $null
    [System.Management.Automation.Language.Parser]::ParseInput($rawContent, [ref]$tokens, [ref]$errors)
    $syntaxErrors = $errors
}

Describe "Full Pipeline (Unified)" -Tag "Integration" {
    It "should load without unhandled syntax errors" {
        $unhandled = $syntaxErrors | Where-Object {
            $_.Id -ne "ParserMissingEndCurlyBrace" -and
            ($_.Id -ne "ParserError" -or $_.Message -notmatch "Missing closing '}'")
        }
        $unhandled | Should -BeNullOrEmpty
    }

    It "should define Get-BraveVersion function" {
        $names = Get-ScriptFunctions -ScriptPath $ScriptMain
        $names -contains "Get-BraveVersion" | Should -Be $true
    }

    It "should define Write-PolicyValue function" {
        $names = Get-ScriptFunctions -ScriptPath $ScriptMain
        $names -contains "Write-PolicyValue" | Should -Be $true
    }

    It "should have required level order from the data layer" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\$LevelOrder\s*=\s*\$OmegaState\.LevelOrder' | Should -Be $true
        $order = Get-OmegaLevelOrder -ScriptPath $ScriptMain
        ($order -join ",") | Should -Be "BraveOnly,Essential,Balanced,Advanced,Strict"
    }

    It "should define valid level names from the data layer" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\$ValidLevels\s*=\s*\$OmegaState\.LevelOrder' | Should -Be $true
    }
}
