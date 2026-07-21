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

    It "should have correct policy counts per tier from EN script" {
        $content = Get-Content -Path $ScriptEN -Raw
        $expectedCounts = @{
            "BraveOnly" = 24
            "Essential" = 29
            "Balanced"  = 33
            "Advanced"  = 38
            "Strict"    = 27
        }
        foreach ($tier in @("BraveOnly","Essential","Balanced","Advanced","Strict")) {
            $pattern = '"' + $tier + '"\s*=\s*@\('
            $tierMatch = [regex]::Match($content, $pattern)
            $tierMatch.Success | Should -Be $true -Because "tier '$tier' should exist in EN script"
            $startIdx = $tierMatch.Index + $tierMatch.Length
            $depth = 1
            for ($i = $startIdx; $i -lt $content.Length; $i++) {
                if ($content[$i] -eq '(') { $depth++ }
                if ($content[$i] -eq ')') {
                    $depth--
                    if ($depth -eq 0) {
                        $section = $content.Substring($tierMatch.Index, $i - $tierMatch.Index)
                        $policyCount = ([regex]::Matches($section, '@\{Name=')).Count
                        $policyCount | Should -BeExactly $expectedCounts[$tier] -Because "tier '$tier' should have $($expectedCounts[$tier]) policies"
                        break
                    }
                }
            }
        }
    }

    It "should have 151 total policy definitions (EN script)" {
        $content = Get-Content -Path $ScriptEN -Raw
        $policyDefStart = $content.IndexOf('$PolicyDefinitions')
        $policyDefSection = $content.Substring($policyDefStart)
        $totalMatches = ([regex]::Matches($policyDefSection, '@\{Name=')).Count
        $totalMatches | Should -BeExactly 151
    }
}
