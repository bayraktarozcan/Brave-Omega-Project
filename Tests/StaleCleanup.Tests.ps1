BeforeAll {
    . $PSScriptRoot\TestHelper.ps1

    function Get-MergedPolicyNames {
        param([string]$ScriptPath, [string]$Level)
        $content = Get-Content -Path $ScriptPath -Raw
        $LevelOrder = @("BraveOnly","Essential","Balanced","Advanced","Strict")
        $Merged = @{}
        foreach ($tier in $LevelOrder[0..([array]::IndexOf($LevelOrder, $Level))]) {
            $pattern = '"' + $tier + '"\s*=\s*@\('
            $tierMatch = [regex]::Match($content, $pattern)
            if (-not $tierMatch.Success) { continue }
            $startIdx = $tierMatch.Index + $tierMatch.Length
            $depth = 1
            for ($i = $startIdx; $i -lt $content.Length; $i++) {
                if ($content[$i] -eq '(') { $depth++ }
                if ($content[$i] -eq ')') {
                    $depth--
                    if ($depth -eq 0) {
                        $section = $content.Substring($tierMatch.Index, $i - $tierMatch.Index)
                        $policyMatches = [regex]::Matches($section, '@\{(?:Name|Ad)="([^"]+)"')
                        foreach ($m in $policyMatches) {
                            $Merged[$m.Groups[1].Value] = $true
                        }
                        break
                    }
                }
            }
        }
        return $Merged
    }

    function Get-AllPolicyNames {
        param([string]$ScriptPath, [string]$ArrayVar)
        $content = Get-Content -Path $ScriptPath -Raw
        $m = [regex]::Match($content, '\$' + [regex]::Escape($ArrayVar) + '\s*=\s*@\((.*?)\)\s*(?=if \(\$)', 'Singleline')
        if (-not $m.Success) { return @() }
        return @([regex]::Matches($m.Groups[1].Value, '"([^"]+)"') | ForEach-Object { $_.Groups[1].Value })
    }
}

Describe "Stale Policy Cleanup - v2.5.5.1" -Tag "Unit" {

    It "should declare v2.5.5.1 in both scripts" {
        (Get-VariableRegex -ScriptPath $ScriptEN -VariableName "ScriptVersion") | Should -Be "v2.5.5.1"
        (Get-VariableRegex -ScriptPath $ScriptTR -VariableName "BetikSurum") | Should -Be "v2.5.5.1"
    }

    It "should define the known-policy array OUTSIDE the -Reset block in EN script" {
        $content = Get-Content -Path $ScriptEN -Raw
        $defIdx  = $content.IndexOf('$allPolicyNames = @(')
        $resetIdx = $content.IndexOf('if ($Reset) {')
        $defIdx   | Should -BeGreaterThan 0
        $resetIdx | Should -BeGreaterThan 0
        $defIdx   | Should -BeLessThan $resetIdx
    }

    It "should define the known-policy array OUTSIDE the -Sifirla block in TR script" {
        $content = Get-Content -Path $ScriptTR -Raw
        $defIdx  = $content.IndexOf('$tumPolitikalar = @(')
        $resetIdx = $content.IndexOf('if ($Sifirla) {')
        $defIdx   | Should -BeGreaterThan 0
        $resetIdx | Should -BeGreaterThan 0
        $defIdx   | Should -BeLessThan $resetIdx
    }

    It "EN script should include the stale cleanup step (smart filter)" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match 'STALE POLICY CLEANUP \(v2\.5\.4\.0\)' | Should -Be $true
        $content -match '\$StaleCandidates' | Should -Be $true
        $content -match '\$_.Name -in \$allPolicyNames' | Should -Be $true
        $content -match '\$_.Name -notin \$MergedPolicies\.Keys' | Should -Be $true
        $content -match 'Remove-ItemProperty -Path \$HKLM_Target -Name \$StaleName' | Should -Be $true
    }

    It "TR script should include the stale cleanup step (smart filter)" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match 'BAYAT POL' | Should -Be $true
        $content -match '\$BayatAdaylar' | Should -Be $true
        $content -match '\$_.Name -in \$tumPolitikalar' | Should -Be $true
        $content -match '\$_.Name -notin \$BirlestirilmisPolitikalar\.Keys' | Should -Be $true
        $content -match 'Remove-ItemProperty -Path \$HKLM_Hedef -Name \$BayatAd' | Should -Be $true
    }

    It "cleanup should respect -WhatIf (preview only, no removal)" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match 'if \(-not \$WhatIf\) \{\s*Remove-ItemProperty' | Should -Be $true
        $content -match '\[WhatIf\] \$StaleName would be removed' | Should -Be $true
    }

    It "should list stale cleanup in the summary report and exit code (EN)" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match 'Stale Cleanup      : \$StaleRemovedCount' | Should -Be $true
        $content -match 'if \(\$ErrorCount -gt 0 -or \$StaleFailCount -gt 0\)' | Should -Be $true
    }

    It "should list stale cleanup in the summary report and exit code (TR)" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match 'Bayat Temizli' | Should -Be $true
        $content -match 'if \(\$HataSayaci -gt 0 -or \$BayatHataSayac -gt 0\)' | Should -Be $true
    }

    It "EN smart filter should flag stale Strict-only policies for Advanced but preserve foreign values" {
        $known = Get-AllPolicyNames -ScriptPath $ScriptEN -ArrayVar "allPolicyNames"
        $known.Count | Should -BeGreaterThan 100
        $known -contains "BrowsingDataLifetime" | Should -Be $true

        $merged = Get-MergedPolicyNames -ScriptPath $ScriptEN -Level "Advanced"
        $merged.ContainsKey("BrowsingDataLifetime") | Should -Be $false
        $merged.ContainsKey("BraveRewardsDisabled") | Should -Be $true

        $simProps = @{
            "BrowsingDataLifetime" = "stale"
            "BraveRewardsDisabled" = 1
            "MyForeignValue"       = "keep"
        }

        $stale = @($simProps.Keys | Where-Object {
            $_ -in $known -and $_ -notin $merged.Keys
        })

        $stale -contains "BrowsingDataLifetime" | Should -Be $true
        $stale -contains "BraveRewardsDisabled" | Should -Be $false
        $stale -contains "MyForeignValue" | Should -Be $false
        $stale.Count | Should -Be 1
    }

    It "TR smart filter should flag stale Strict-only policies for Advanced but preserve foreign values" {
        $known = Get-AllPolicyNames -ScriptPath $ScriptTR -ArrayVar "tumPolitikalar"
        $known.Count | Should -BeGreaterThan 100
        $known -contains "BrowsingDataLifetime" | Should -Be $true

        $merged = Get-MergedPolicyNames -ScriptPath $ScriptTR -Level "Advanced"
        $merged.ContainsKey("BrowsingDataLifetime") | Should -Be $false
        $merged.ContainsKey("BraveRewardsDisabled") | Should -Be $true

        $simProps = @{
            "BrowsingDataLifetime" = "stale"
            "BraveRewardsDisabled" = 1
            "MyForeignValue"       = "keep"
        }

        $stale = @($simProps.Keys | Where-Object {
            $_ -in $known -and $_ -notin $merged.Keys
        })

        $stale -contains "BrowsingDataLifetime" | Should -Be $true
        $stale -contains "BraveRewardsDisabled" | Should -Be $false
        $stale -contains "MyForeignValue" | Should -Be $false
        $stale.Count | Should -Be 1
    }
}
