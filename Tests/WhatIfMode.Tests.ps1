BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "WhatIf Mode - Script Parameter" -Tag "Unit" {
    It "EN script should declare -WhatIf as switch parameter" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '\[switch\]\$WhatIf' | Should -Be $true
    }

    It "TR script should declare -WhatIf as switch parameter" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match '\[switch\]\$WhatIf' | Should -Be $true
    }

    It "EN param block should include Level, WhatIf, and Reset" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '\[string\]\$Level\s*=\s*""' | Should -Be $true
        $content -match '\[switch\]\$WhatIf' | Should -Be $true
        $content -match '\[switch\]\$Reset' | Should -Be $true
    }
}

Describe "WhatIf Mode - Write-PolicyValue Behavior" -Tag "Unit" {
    It "EN Write-PolicyValue should accept -WhatIf parameter" {
        $content = Get-Content -Path $ScriptEN -Raw
        $funcMatch = [regex]::Match($content, 'function\s+Write-PolicyValue\s*\{[^}]*param\([^)]*\[switch\]\$WhatIf', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        $funcMatch.Success | Should -Be $true
    }

    It "TR Write-PolicyValue should accept -WhatIf parameter" {
        $content = Get-Content -Path $ScriptTR -Raw
        $funcMatch = [regex]::Match($content, 'function\s+Yaz-KayitDegeri\s*\{[^}]*param\([^)]*\[switch\]\$WhatIf', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        $funcMatch.Success | Should -Be $true
    }
}
