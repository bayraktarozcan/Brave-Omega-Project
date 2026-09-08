BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "WhatIf Mode - Script Parameter" -Tag "Unit" {
    It "unified script should declare -WhatIf as switch parameter" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[switch\]\$WhatIf' | Should -Be $true
    }

    It "unified param block should include Level, WhatIf, Reset, AllowSync, and Language" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[string\]\$Level\s*=\s*""' | Should -Be $true
        $content -match '\[switch\]\$WhatIf' | Should -Be $true
        $content -match '\[switch\]\$Reset' | Should -Be $true
        $content -match '\[switch\]\$AllowSync' | Should -Be $true
        $content -match '\$Language' | Should -Be $true
    }
}

Describe "WhatIf Mode - Write-PolicyValue Behavior" -Tag "Unit" {
    It "unified Write-PolicyValue should accept -WhatIf parameter" {
        $content = Get-Content -Path $ScriptMain -Raw
        $funcMatch = [regex]::Match($content, 'function\s+Write-PolicyValue\s*\{[^}]*param\([^)]*\[switch\]\$WhatIf', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        $funcMatch.Success | Should -Be $true
    }
}
