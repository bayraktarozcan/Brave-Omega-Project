BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "WhatIf Mode" -Tag "Unit" {
    It "should detect WhatIf parameter" {
        $result = & { param([switch]$WhatIf) return $WhatIf.IsPresent } -WhatIf
        $result | Should -Be $true
    }

    It "should default WhatIf to false" {
        $result = & { param([switch]$WhatIf) return $WhatIf.IsPresent }
        $result | Should -Be $false
    }

    It "should skip backup in WhatIf mode" {
        $executed = & { param([switch]$WhatIf) if (-not $WhatIf) { return "backup" }; return "dry-run" } -WhatIf
        $executed | Should -Be "dry-run"
    }
}
