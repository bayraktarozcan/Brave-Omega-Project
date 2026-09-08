BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Parameter Binding - Unified Script" -Tag "Unit" {
    It "should declare Level as string parameter" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[string\]\$Level\s*=\s*""' | Should -Be $true
    }

    It "should declare WhatIf as switch parameter" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[switch\]\$WhatIf' | Should -Be $true
    }

    It "should declare Reset as switch parameter" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[switch\]\$Reset' | Should -Be $true
    }

    It "should declare AllowSync as switch parameter" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[switch\]\$AllowSync' | Should -Be $true
    }

    It "should declare Language with EN/TR/Auto validation" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[ValidateSet\("EN", "TR", "Auto"\)\]\[string\]\$Language' | Should -Be $true
    }

    It "should have exactly 5 parameters in param block" {
        $content = Get-Content -Path $ScriptMain -Raw
        $paramMatch = [regex]::Match($content, 'param\(\s*\[Alias\("Seviye"\)\]\[string\]\$Level.*?\[string\]\$Language\s*=\s*"Auto"\s*\)', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        $paramMatch.Success | Should -Be $true
        $paramBlock = $paramMatch.Value
        $paramCount = ([regex]::Matches($paramBlock, '\$(Level|WhatIf|Reset|AllowSync|Language)\b')).Count
        $paramCount | Should -Be 5
    }
}

Describe "Parameter Binding - TR Aliases and Wrappers" -Tag "Unit" {
    It "should alias Seviye to Level" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[Alias\("Seviye"\)\]\[string\]\$Level' | Should -Be $true
    }

    It "should alias Sifirla to Reset" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[Alias\("Sifirla"\)\]\[switch\]\$Reset' | Should -Be $true
    }

    It "should alias SenkronizasyonaIzinVer to AllowSync" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[Alias\("SenkronizasyonaIzinVer"\)\]\[switch\]\$AllowSync' | Should -Be $true
    }

    It "EN and TR wrappers should mirror the unified param block" {
        function Get-ParamAstNames {
            param([string]$Path)
            $tokens = $null; $errs = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$tokens, [ref]$errs)
            $paramBlock = $ast.Find({ param($n) $n -is [System.Management.Automation.Language.ParamBlockAst] }, $true)
            return @($paramBlock.Parameters | ForEach-Object { $_.Name.VariablePath.UserPath })
        }
        $mainNames = Get-ParamAstNames -Path $ScriptMain
        foreach ($name in @('Level', 'WhatIf', 'Reset', 'AllowSync', 'Language')) {
            $mainNames -contains $name | Should -Be $true -Because "unified script should declare $name"
        }
        foreach ($wrapper in @($ScriptEN, $ScriptTR)) {
            $wrapNames = Get-ParamAstNames -Path $wrapper
            foreach ($name in @('Level', 'WhatIf', 'Reset', 'AllowSync', 'Language')) {
                $wrapNames -contains $name | Should -Be $true -Because "$wrapper should declare $name"
            }
        }
    }
}

Describe "Parameter Binding - Write-PolicyValue Function" -Tag "Unit" {
    It "unified function should have all required parameters" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'function\s+Write-PolicyValue' | Should -Be $true
        $content -match '\[string\]\$TargetPath' | Should -Be $true
        $content -match '\[string\]\$PolicyName' | Should -Be $true
        $content -match '\$PolicyValue' | Should -Be $true
        $content -match '\[string\]\$ValueType' | Should -Be $true
        $content -match '\[switch\]\$WhatIf' | Should -Be $true
    }

    It "wrappers should contain no policy-writing logic" {
        foreach ($wrapper in @($ScriptEN, $ScriptTR)) {
            $content = Get-Content -Path $wrapper -Raw
            $content -match 'function\s+Write-PolicyValue' | Should -Be $false
            $content -match 'New-ItemProperty' | Should -Be $false
        }
    }
}
