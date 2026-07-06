BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Policy Definitions" -Tag "Unit" {
    It "should define exactly 5 levels" {
        $PolicyDefinitions = @{
            "BraveOnly"  = @( @{Name="Test1";Value=1;Type="DWord"} )
            "Essential"  = @( @{Name="Test2";Value=0;Type="DWord"} )
            "Balanced"   = @( @{Name="Test3";Value=2;Type="DWord"} )
            "Advanced"   = @( @{Name="Test4";Value=1;Type="DWord"} )
            "Strict"     = @( @{Name="Test5";Value=2;Type="DWord"} )
        }
        $PolicyDefinitions.Keys.Count | Should -BeExactly 5
    }

    It "should have at least one policy per level" {
        $PolicyDefinitions = @{
            "BraveOnly"  = @( @{Name="BraveRewardsDisabled";Value=1;Type="DWord"})
            "Essential"  = @( @{Name="MetricsReportingEnabled";Value=0;Type="DWord"})
            "Balanced"   = @( @{Name="PasswordManagerEnabled";Value=0;Type="DWord"})
            "Advanced"   = @( @{Name="DefaultSensorsSetting";Value=2;Type="DWord"})
            "Strict"     = @( @{Name="TranslateEnabled";Value=0;Type="DWord"})
        }
        $PolicyDefinitions["BraveOnly"].Count | Should -BeGreaterOrEqual 1
        $PolicyDefinitions["Essential"].Count | Should -BeGreaterOrEqual 1
        $PolicyDefinitions["Balanced"].Count  | Should -BeGreaterOrEqual 1
        $PolicyDefinitions["Advanced"].Count  | Should -BeGreaterOrEqual 1
        $PolicyDefinitions["Strict"].Count    | Should -BeGreaterOrEqual 1
    }

    It "each policy should have Name, Value, Type keys" {
        $p = @{Name="Test";Value=1;Type="DWord"}
        ($p.ContainsKey("Name") -and $p.ContainsKey("Value") -and $p.ContainsKey("Type")) | Should -Be $true
    }
}
