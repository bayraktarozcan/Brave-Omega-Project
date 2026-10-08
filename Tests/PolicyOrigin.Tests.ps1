# Invariant: every policy declares its origin and platform footprint, and the
# Brave set is an explicit list rather than a name pattern. A policy without
# an origin silently joins the generic Chromium set on Linux, and a Brave-only
# policy with a Chromium-sounding name (TorDisabled) would ship to Chrome
# unmanaged. This file holds the schema and the Brave roster.
#
# What this check cannot see:
#   - Whether an origin label is TRUE. The label is a human classification
#     against brave://policy, the ADML explain text, and Chromium
#     policy_template.json; the test proves the label exists and is shaped
#     right, not that the research behind it was correct.
BeforeAll {
    . $PSScriptRoot\TestHelper.ps1

    $script:Profiles = @('BraveOnly', 'Essential', 'Balanced', 'Advanced', 'Strict')

    function Get-OmegaTaggedPolicies {
        $all = @()
        foreach ($tier in $script:Profiles) {
            $prof = Get-Content -LiteralPath (Join-Path $ProjectRoot "Brave-Omega/Profiles/$tier.json") -Raw |
                ConvertFrom-Json
            foreach ($p in $prof.policies) {
                $all += [pscustomobject]@{ Tier = $tier; Name = $p.name; Origin = $p.origin; Platforms = @($p.platforms) }
            }
        }
        return $all
    }

    # The complete Brave-origin roster. A name enters this list by research
    # (policy page + ADML + upstream template), never by prefix match.
    $script:BraveRoster = @(
        'BraveAIChatEnabled', 'BraveDeAmpEnabled', 'BraveDebouncingEnabled',
        'BraveNewsDisabled', 'BraveP3AEnabled', 'BravePlaylistEnabled',
        'BraveReduceLanguageEnabled', 'BraveRewardsDisabled',
        'BraveShieldsDisabledForUrls', 'BraveShieldsEnabledForUrls',
        'BraveSpeedreaderEnabled', 'BraveStatsPingEnabled', 'BraveTalkDisabled',
        'BraveTrackingQueryParametersFilteringEnabled', 'BraveVPNDisabled',
        'BraveWalletDisabled', 'BraveWaybackMachineEnabled',
        'BraveWebDiscoveryEnabled', 'BraveGlobalPrivacyControlEnabled',
        'BraveSyncUrl', 'DefaultBraveAdblockSetting',
        'DefaultBraveFingerprintingV2Setting',
        'DefaultBraveHttpsUpgradeSetting', 'DefaultBraveReferrersSetting',
        'DefaultBraveRemember1PStorageSetting', 'EmailAliasesEnabled',
        'TorDisabled'
    )
}

Describe 'Policy origin and platform schema' -Tag 'Unit' {

    It 'every policy carries a closed-set origin' {
        $bad = @(Get-OmegaTaggedPolicies | Where-Object { $_.Origin -cnotin @('chromium', 'brave') })
        ($bad | ForEach-Object { "$($_.Tier)/$($_.Name)" }) -join [Environment]::NewLine |
            Should -BeNullOrEmpty -Because 'a policy without an origin silently joins the generic set on Linux'
    }

    It 'every policy carries a platforms subset of windows,linux' {
        $bad = @(Get-OmegaTaggedPolicies | Where-Object {
            -not $_.Platforms -or (@($_.Platforms | Where-Object { $_ -cnotin @('windows', 'linux') })).Count -gt 0
        })
        ($bad | ForEach-Object { "$($_.Tier)/$($_.Name)" }) -join [Environment]::NewLine |
            Should -BeNullOrEmpty -Because 'an unknown platform is a target no exporter or installer understands'
    }

    It 'brave-origin count matches the expected roster' {
        $got = @(Get-OmegaTaggedPolicies | Where-Object { $_.Origin -ceq 'brave' } | ForEach-Object { $_.Name } | Sort-Object -Unique)
        $want = @($script:BraveRoster | Sort-Object -Unique)
        Compare-Object $got $want | Should -BeNullOrEmpty -Because 'the roster is explicit research, so a difference in either direction is a classification that changed without review'
    }

    It 'TorDisabled is origin brave' {
        $found = @(Get-OmegaTaggedPolicies | Where-Object { $_.Name -ceq 'TorDisabled' -and $_.Origin -ceq 'brave' })
        $found.Count | Should -BeExactly 1 -Because 'name-prefix filtering is insufficient and this is the case that proves it'
    }
}

Describe 'Browser profiles' -Tag 'Unit' {

    It 'chrome profile resolves to the chromium-origin subset' {
        $prof = Get-Content -LiteralPath (Join-Path $ProjectRoot 'Brave-Omega/Browsers/chrome.json') -Raw |
            ConvertFrom-Json
        $all = @(Get-OmegaTaggedPolicies)
        $chromium = @($all | Where-Object { $_.Origin -ceq 'chromium' })
        $chromium.Count | Should -BeGreaterThan 0
        $prof.origins | Should -BeExactly @('chromium')
        $chromium.Count | Should -Be ($all.Count - 27) -Because 'the roster above fixes the Brave set, so the generic set is whatever remains'
    }

    It 'brave profile carries every policy directory variant' {
        $prof = Get-Content -LiteralPath (Join-Path $ProjectRoot 'Brave-Omega/Browsers/brave.json') -Raw |
            ConvertFrom-Json
        @($prof.origins | Sort-Object) -join ',' | Should -BeExactly 'brave,chromium'
        @($prof.policyDirs) -join ',' | Should -BeExactly 'brave,chromium,chromium-browser,chrome'
    }
}
