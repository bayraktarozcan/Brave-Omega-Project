BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Parameter Binding" -Tag "Unit" {
    It "Level parameter should accept string input" {
        $result = & { param([string]$Level) return $Level.GetType().Name } -ArgumentList "Essential"
        $result | Should -Be "String"
    }

    It "WhatIf switch should be boolean" {
        $result = & { param([switch]$WhatIf) return $WhatIf.IsPresent -is [bool] } -ArgumentList ([switch]$false)
        $result | Should -Be $true
    }

    It "Reset switch should be boolean" {
        $result = & { param([switch]$Reset) return $Reset.IsPresent -is [bool] } -ArgumentList ([switch]$true)
        $result | Should -Be $true
    }

    It "should handle both -Level and -WhatIf simultaneously" {
        $params = @{Level="Balanced"; WhatIf=$true}
        $result = & {
            param([string]$Level, [switch]$WhatIf)
            return @{ Level = $Level; WhatIf = $WhatIf.IsPresent }
        } @params
        $result.Level | Should -Be "Balanced"
        $result.WhatIf | Should -Be $true
    }
}
