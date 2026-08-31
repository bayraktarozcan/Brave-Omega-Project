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

    It "should produce 151 unique policies after cumulative merge from EN script" {
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
        $MergedPolicies.Count | Should -BeExactly 151
    }

    It "DownloadRestrictions should live in Essential only (smart value, not a blanket block)" {
        function Get-TierSection {
            param([string]$Content, [string]$Tier)
            $m = [regex]::Match($Content, '"' + $Tier + '"\s*=\s*@\(')
            if (-not $m.Success) { return $null }
            $startIdx = $m.Index + $m.Length
            $depth = 1
            for ($i = $startIdx; $i -lt $Content.Length; $i++) {
                if ($Content[$i] -eq '(') { $depth++ }
                if ($Content[$i] -eq ')') {
                    $depth--
                    if ($depth -eq 0) { return $Content.Substring($m.Index, $i - $m.Index) }
                }
            }
            return $null
        }

        $content   = Get-Content -Path $ScriptEN -Raw
        $essential = Get-TierSection -Content $content -Tier "Essential"
        $balanced  = Get-TierSection -Content $content -Tier "Balanced"
        $advanced  = Get-TierSection -Content $content -Tier "Advanced"
        $strict    = Get-TierSection -Content $content -Tier "Strict"

        $essential -match '"DownloadRestrictions"' | Should -Be $true
        $essential -match '"DownloadRestrictions"[\s\S]*?Value=4' | Should -Be $true
        $balanced  -match '"DownloadRestrictions"' | Should -Be $false
        $advanced  -match '"DownloadRestrictions"' | Should -Be $false
        $strict    -match '"DownloadRestrictions"' | Should -Be $false

        $balanced -match '"DisableSafeBrowsingProceedAnyway"' | Should -Be $true
        $strict   -match '"DisableSafeBrowsingProceedAnyway"' | Should -Be $false
    }
}
