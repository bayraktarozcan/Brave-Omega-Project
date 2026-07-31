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
}

Describe "AllowSync - EN Script" -Tag "Unit" {
    It "should declare -AllowSync as switch parameter" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '\[switch\]\$AllowSync' | Should -Be $true
    }

    It "should exclude BrowserSignin and SyncDisabled when AllowSync is used at Strict level" {
        $content = Get-Content -Path $ScriptEN -Raw
        $merged = Get-MergedPolicyNames -ScriptPath $ScriptEN -Level "Strict"
        $merged.ContainsKey("BrowserSignin") | Should -Be $true
        $merged.ContainsKey("SyncDisabled") | Should -Be $true
        $content -match '\$MergedPolicies\.Remove\(\$SyncPolicyName\)' | Should -Be $true
        $content -match '\$SyncBlockingPolicies\s*=\s*@\("BrowserSignin"\s*,\s*"SyncDisabled"\)' | Should -Be $true
    }

    It "should have BrowserSignin only at Strict and not at lower levels" {
        $content = Get-Content -Path $ScriptEN -Raw
        $advanced = Get-MergedPolicyNames -ScriptPath $ScriptEN -Level "Advanced"
        $advanced.ContainsKey("BrowserSignin") | Should -Be $false
        $advanced.ContainsKey("SyncDisabled") | Should -Be $false
        $strict = Get-MergedPolicyNames -ScriptPath $ScriptEN -Level "Strict"
        $strict.ContainsKey("BrowserSignin") | Should -Be $true
        $strict.ContainsKey("SyncDisabled") | Should -Be $true
    }
}

Describe "AllowSync - TR Script" -Tag "Unit" {
    It "should declare -SenkronizasyonaIzinVer as switch parameter" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match '\[switch\]\$SenkronizasyonaIzinVer' | Should -Be $true
    }

    It "should exclude BrowserSignin and SyncDisabled when SenkronizasyonaIzinVer is used at Strict level" {
        $content = Get-Content -Path $ScriptTR -Raw
        $merged = Get-MergedPolicyNames -ScriptPath $ScriptTR -Level "Strict"
        $merged.ContainsKey("BrowserSignin") | Should -Be $true
        $merged.ContainsKey("SyncDisabled") | Should -Be $true
        $content -match '\$BirlestirilmisPolitikalar\.Remove\(\$SyncPolitikaAdi\)' | Should -Be $true
        $content -match '\$SyncEngelleyenPolitikalar\s*=\s*@\("BrowserSignin"\s*,\s*"SyncDisabled"\)' | Should -Be $true
    }

    It "should have BrowserSignin only at Strict and not at lower levels" {
        $content = Get-Content -Path $ScriptTR -Raw
        $advanced = Get-MergedPolicyNames -ScriptPath $ScriptTR -Level "Advanced"
        $advanced.ContainsKey("BrowserSignin") | Should -Be $false
        $advanced.ContainsKey("SyncDisabled") | Should -Be $false
        $strict = Get-MergedPolicyNames -ScriptPath $ScriptTR -Level "Strict"
        $strict.ContainsKey("BrowserSignin") | Should -Be $true
        $strict.ContainsKey("SyncDisabled") | Should -Be $true
    }
}
