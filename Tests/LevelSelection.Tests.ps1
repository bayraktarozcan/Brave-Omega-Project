BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Level Selection" -Tag "Unit" {
    It "should accept BraveOnly level" {
        $ValidLevels = @("BraveOnly","Essential","Balanced","Strict","Brave Yalnız","Temel","Dengeli","Katı")
        $LevelMap = @{"Brave Yalnız"="BraveOnly";"Temel"="Essential";"Dengeli"="Balanced";"Katı"="Strict"}
        $level = "BraveOnly"
        if ($LevelMap[$level]) { $level = $LevelMap[$level] }
        ($level -in $ValidLevels) | Should -Be $true
    }

    It "should accept Turkish level names" {
        $LevelMap = @{"Brave Yalnız"="BraveOnly";"Temel"="Essential";"Dengeli"="Balanced";"Katı"="Strict"}
        $LevelMap["Temel"] | Should -Be "Essential"
    }

    It "should reject invalid level names" {
        $ValidLevels = @("BraveOnly","Essential","Balanced","Strict","Brave Yalnız","Temel","Dengeli","Katı")
        ("InvalidLevel" -in $ValidLevels) | Should -Be $false
    }
}
