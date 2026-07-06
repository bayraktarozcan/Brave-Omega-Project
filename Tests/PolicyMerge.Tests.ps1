BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Policy Merge" -Tag "Unit" {
    It "should merge policies cumulatively across levels" {
        $LevelOrder = @("BraveOnly","Essential","Balanced","Advanced","Strict")
        $PolicyDefinitions = @{
            "BraveOnly" = @(@{Name="PolicyA";Value=1;Type="DWord"})
            "Essential" = @(@{Name="PolicyB";Value=0;Type="DWord"})
            "Balanced"  = @(@{Name="PolicyC";Value=2;Type="DWord"})
            "Advanced"  = @(@{Name="PolicyD";Value=2;Type="DWord"})
            "Strict"    = @(@{Name="PolicyE";Value=2;Type="DWord"})
        }
        $MergedPolicies = @{}
        foreach ($level in $LevelOrder[0..2]) {
            foreach ($p in $PolicyDefinitions[$level]) {
                $MergedPolicies[$p.Name] = $p
            }
        }
        $MergedPolicies.Count | Should -Be 3
        $MergedPolicies.ContainsKey("PolicyA") | Should -Be $true
        $MergedPolicies.ContainsKey("PolicyB") | Should -Be $true
        $MergedPolicies.ContainsKey("PolicyC") | Should -Be $true
    }

    It "later level should override earlier policy with same name" {
        $LevelOrder = @("BraveOnly","Essential")
        $PolicyDefinitions = @{
            "BraveOnly" = @(@{Name="SharedPolicy";Value=1;Type="DWord"})
            "Essential" = @(@{Name="SharedPolicy";Value=0;Type="DWord"})
        }
        $MergedPolicies = @{}
        foreach ($level in $LevelOrder[0..1]) {
            foreach ($p in $PolicyDefinitions[$level]) {
                $MergedPolicies[$p.Name] = $p
            }
        }
        $MergedPolicies["SharedPolicy"].Value | Should -Be 0
    }

    It "Strict level should contain all policies" {
        $LevelOrder = @("BraveOnly","Essential","Balanced","Advanced","Strict")
        $PolicyDefinitions = @{
            "BraveOnly" = @(@{Name="A";Value=1;Type="DWord"})
            "Essential" = @(@{Name="B";Value=0;Type="DWord"})
            "Balanced"  = @(@{Name="C";Value=2;Type="DWord"})
            "Advanced"  = @(@{Name="D";Value=2;Type="DWord"})
            "Strict"    = @(@{Name="E";Value=2;Type="DWord"})
        }
        $MergedPolicies = @{}
        foreach ($level in $LevelOrder) {
            foreach ($p in $PolicyDefinitions[$level]) {
                $MergedPolicies[$p.Name] = $p
            }
        }
        $MergedPolicies.Count | Should -Be 5
    }
}
