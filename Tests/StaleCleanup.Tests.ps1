BeforeAll {
    . $PSScriptRoot\TestHelper.ps1

    function Get-MergedPolicyNames {
        param([string]$ScriptPath, [string]$Level)
        $LevelOrder = Get-OmegaLevelOrder -ScriptPath $ScriptPath
        $Merged = @{}
        foreach ($tier in $LevelOrder[0..([array]::IndexOf($LevelOrder, $Level))]) {
            foreach ($p in (Get-OmegaTierPolicies -Level $tier -ScriptPath $ScriptPath)) {
                $Merged[$p.name] = $true
            }
        }
        return $Merged
    }

    function Get-AllPolicyNames {
        param([string]$ScriptPath, [string]$ArrayVar)
        return Get-OmegaAllPolicyNames -ScriptPath $ScriptPath
    }
}

Describe "Stale Policy Cleanup - v2.8.1.0" -Tag "Unit" {

    It "should declare v2.8.1.0 in the unified script" {
        (Get-VariableRegex -ScriptPath $ScriptMain -VariableName "ScriptVersion") | Should -Be "v2.8.1.0"
    }

    It "should define the known-policy array OUTSIDE the -Reset block in unified script" {
        $content = Get-Content -Path $ScriptMain -Raw
        $defIdx  = $content.IndexOf('$allPolicyNames = ')
        $resetIdx = $content.IndexOf('if ($Reset) {')
        $defIdx   | Should -BeGreaterThan 0
        $resetIdx | Should -BeGreaterThan 0
        $defIdx   | Should -BeLessThan $resetIdx
    }

    It "unified script should include the stale cleanup step (smart filter)" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'STALE POLICY CLEANUP \(v2\.5\.4\.0\)' | Should -Be $true
        $content -match '\$StaleCandidates' | Should -Be $true
        $content -match '\$_.Name -in \$allPolicyNames' | Should -Be $true
        $content -match '\$_.Name -notin \$MergedPolicies\.Keys' | Should -Be $true
        $content -match 'Remove-ItemProperty -Path \$HKLM_Target -Name \$StaleName' | Should -Be $true
        $content -match 'Get-ChildItem -Path \$HKLM_Target -ErrorAction SilentlyContinue' | Should -Be $true
        $content -match 'Sort-Object -Unique' | Should -Be $true
        $content -match 'Remove-Item -LiteralPath \$StaleListKeyPath -Recurse -Force' | Should -Be $true
    }

    It "unified strings table should carry the Turkish stale-cleanup text" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'Bayat Politika Temizli' | Should -Be $true
        $content -match 'Bayat Temizli' | Should -Be $true
    }

    It "cleanup should respect -WhatIf (preview only, no removal)" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'if \(-not \$WhatIf\) \{\s*Remove-ItemProperty' | Should -Be $true
        $content -match '\[WhatIf\] \$StaleName would be removed' | Should -Be $true
    }

    It "should list stale cleanup in the summary report and exit code" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match "Get-LocalizedString 'SummaryStale'" | Should -Be $true
        $content -match 'Stale Cleanup      : \{0\} removed' | Should -Be $true
        $content -match 'if \(\$ErrorCount -gt 0 -or \$StaleFailCount -gt 0\)' | Should -Be $true
    }

    It "unified smart filter should flag stale Strict-only policies for Advanced but preserve foreign values" {
        $known = Get-AllPolicyNames -ScriptPath $ScriptMain -ArrayVar "allPolicyNames"
        $known.Count | Should -BeGreaterThan 100
        $known -contains "BrowsingDataLifetime" | Should -Be $true

        $merged = Get-MergedPolicyNames -ScriptPath $ScriptMain -Level "Advanced"
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
