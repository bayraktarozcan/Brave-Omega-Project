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
}

Describe "AllowSync - Unified Script" -Tag "Unit" {
    It "should declare -AllowSync as switch parameter" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[switch\]\$AllowSync' | Should -Be $true
    }

    It "should alias -SenkronizasyonaIzinVer to -AllowSync" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[Alias\("SenkronizasyonaIzinVer"\)\]\[switch\]\$AllowSync' | Should -Be $true
    }

    It "should exclude BrowserSignin and SyncDisabled when AllowSync is used at Strict level" {
        $content = Get-Content -Path $ScriptMain -Raw
        $merged = Get-MergedPolicyNames -ScriptPath $ScriptMain -Level "Strict"
        $merged.ContainsKey("BrowserSignin") | Should -Be $true
        $merged.ContainsKey("SyncDisabled") | Should -Be $true
        $content -match '\$MergedPolicies\.Remove\(\$SyncPolicyName\)' | Should -Be $true
        $content -match '\$SyncBlockingPolicies\s*=\s*@\("BrowserSignin"\s*,\s*"SyncDisabled"\)' | Should -Be $true
    }

    It "should have BrowserSignin only at Strict and not at lower levels" {
        $content = Get-Content -Path $ScriptMain -Raw
        $advanced = Get-MergedPolicyNames -ScriptPath $ScriptMain -Level "Advanced"
        $advanced.ContainsKey("BrowserSignin") | Should -Be $false
        $advanced.ContainsKey("SyncDisabled") | Should -Be $false
        $strict = Get-MergedPolicyNames -ScriptPath $ScriptMain -Level "Strict"
        $strict.ContainsKey("BrowserSignin") | Should -Be $true
        $strict.ContainsKey("SyncDisabled") | Should -Be $true
    }
}
