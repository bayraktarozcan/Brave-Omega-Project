BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Parameter Binding - EN Script" -Tag "Unit" {
    It "should declare Level as string parameter" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '\[string\]\$Level\s*=\s*""' | Should -Be $true
    }

    It "should declare WhatIf as switch parameter" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '\[switch\]\$WhatIf' | Should -Be $true
    }

    It "should declare Reset as switch parameter" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '\[switch\]\$Reset' | Should -Be $true
    }

    It "should have exactly 3 parameters in param block" {
        $content = Get-Content -Path $ScriptEN -Raw
        $paramMatch = [regex]::Match($content, 'param\(\s*\[string\]\$Level.*?\[switch\]\$Reset\s*\)', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        $paramMatch.Success | Should -Be $true
        $paramBlock = $paramMatch.Value
        $paramCount = ([regex]::Matches($paramBlock, '\[')).Count
        $paramCount | Should -Be 3
    }
}

Describe "Parameter Binding - TR Script" -Tag "Unit" {
    It "should declare Seviye as string parameter" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match '\[string\]\$Seviye\s*=\s*""' | Should -Be $true
    }

    It "should declare WhatIf as switch parameter" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match '\[switch\]\$WhatIf' | Should -Be $true
    }

    It "should declare Sifirla as switch parameter" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match '\[switch\]\$Sifirla' | Should -Be $true
    }

    It "should have exactly 3 parameters in param block" {
        $content = Get-Content -Path $ScriptTR -Raw
        $paramMatch = [regex]::Match($content, 'param\(\s*\[string\]\$Seviye.*?\[switch\]\$Sifirla\s*\)', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        $paramMatch.Success | Should -Be $true
    }
}

Describe "Parameter Binding - Write-PolicyValue Function" -Tag "Unit" {
    It "EN function should have all required parameters" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match 'function\s+Write-PolicyValue' | Should -Be $true
        $content -match '\[string\]\$TargetPath' | Should -Be $true
        $content -match '\[string\]\$PolicyName' | Should -Be $true
        $content -match '\$PolicyValue' | Should -Be $true
        $content -match '\[string\]\$ValueType' | Should -Be $true
        $content -match '\[switch\]\$WhatIf' | Should -Be $true
    }

    It "TR function should have all required parameters" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match 'function\s+Yaz-KayitDegeri' | Should -Be $true
        $content -match '\[string\]\$HedefYol' | Should -Be $true
        $content -match '\[string\]\$PolitikaAdi' | Should -Be $true
        $content -match '\$PolitikaDegeri' | Should -Be $true
        $content -match '\[string\]\$DegerTuru' | Should -Be $true
        $content -match '\[switch\]\$WhatIf' | Should -Be $true
    }
}
