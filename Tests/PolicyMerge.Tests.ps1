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

    It "should produce 150 unique policies after cumulative merge from EN script" {
        $content = Get-Content -Path $ScriptEN -Raw
        $LevelOrder = @("BraveOnly","Essential","Balanced","Advanced","Strict")
        $MergedPolicies = @{}
        foreach ($tier in $LevelOrder) {
            $pattern = '"' + $tier + '"\s*=\s*@\('
            $tierMatch = [regex]::Match($content, $pattern)
            $startIdx = $tierMatch.Index + $tierMatch.Length
            $depth = 1
            for ($i = $startIdx; $i -lt $content.Length; $i++) {
                if ($content[$i] -eq '(') { $depth++ }
                if ($content[$i] -eq ')') {
                    $depth--
                    if ($depth -eq 0) {
                        $section = $content.Substring($tierMatch.Index, $i - $tierMatch.Index)
                        $policyMatches = [regex]::Matches($section, '@\{Name="([^"]+)"')
                        foreach ($m in $policyMatches) {
                            $MergedPolicies[$m.Groups[1].Value] = $tier
                        }
                        break
                    }
                }
            }
        }
        $MergedPolicies.Count | Should -BeExactly 150
    }

    It "DownloadRestrictions should appear in both Balanced and Strict" {
        $content = Get-Content -Path $ScriptEN -Raw
        $balancedMatch = [regex]::Match($content, '"Balanced"\s*=\s*@\([\s\S]*?"DownloadRestrictions"')
        $balancedMatch.Success | Should -Be $true
        $strictMatch = [regex]::Match($content, '"Strict"\s*=\s*@\([\s\S]*?"DownloadRestrictions"')
        $strictMatch.Success | Should -Be $true
    }
}
