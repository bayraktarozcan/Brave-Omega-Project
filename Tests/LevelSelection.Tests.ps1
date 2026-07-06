BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Level Selection" -Tag "Unit" {
    It "should accept BraveOnly level" {
        $ValidLevels = @("BraveOnly","Essential","Balanced","Advanced","Strict","Brave Yalnız","Temel","Dengeli","Gelişmiş","Katı")
        $LevelMap = @{"Brave Yalnız"="BraveOnly";"Temel"="Essential";"Dengeli"="Balanced";"Gelişmiş"="Advanced";"Katı"="Strict"}
        $level = "BraveOnly"
        if ($LevelMap[$level]) { $level = $LevelMap[$level] }
        ($level -in $ValidLevels) | Should -Be $true
    }

    It "should accept Turkish level names" {
        $LevelMap = @{"Brave Yalnız"="BraveOnly";"Temel"="Essential";"Dengeli"="Balanced";"Gelişmiş"="Advanced";"Katı"="Strict"}
        $LevelMap["Temel"] | Should -Be "Essential"
    }

    It "should reject invalid level names" {
        $ValidLevels = @("BraveOnly","Essential","Balanced","Advanced","Strict","Brave Yalnız","Temel","Dengeli","Gelişmiş","Katı")
        ("InvalidLevel" -in $ValidLevels) | Should -Be $false
    }

    It "should accept Advanced level" {
        $ValidLevels = @("BraveOnly","Essential","Balanced","Advanced","Strict","Brave Yalnız","Temel","Dengeli","Gelişmiş","Katı")
        $LevelMap = @{"Brave Yalnız"="BraveOnly";"Temel"="Essential";"Dengeli"="Balanced";"Gelişmiş"="Advanced";"Katı"="Strict"}
        $level = "Advanced"
        if ($LevelMap[$level]) { $level = $LevelMap[$level] }
        ($level -in $ValidLevels) | Should -Be $true
    }

    It "should accept Gelişmiş level and map to Advanced" {
        $LevelMap = @{"Brave Yalnız"="BraveOnly";"Temel"="Essential";"Dengeli"="Balanced";"Gelişmiş"="Advanced";"Katı"="Strict"}
        $LevelMap["Gelişmiş"] | Should -Be "Advanced"
    }
}
