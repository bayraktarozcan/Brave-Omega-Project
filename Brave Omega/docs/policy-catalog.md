# Brave Omega — Policy Catalog

> **Generated from:** `BraveOmega-EN.ps1` v2.1.6.0  
> **Date:** 2026-07-06  
> **Total unique policies:** 81 (82 raw entries, 1 overlap merged)  
> **Type distribution:** 74 DWord · 4 String · 3 MultiString  
> **Validated on:** Brave 1.92.134 / Chromium 150.0.7871.63 / Windows 11 25H2

---

## Legend

| Column | Meaning |
|--------|---------|
| **#** | Sequential catalog ID |
| **Policy Name** | Chromium/Brave enterprise policy registry name |
| **Type** | Registry data type |
| **Default** | Value applied by Brave Omega |
| **Tier** | First hardening tier that includes this policy |
| **Source** | Platform(s) where this policy is applied |
| **Min. Chromium** | Earliest Chromium version that recognizes this policy |
| **Risk** | Privacy/Security impact if not applied |

---

## All Policies

| # | Policy Name | Type | Default | Tier | Source | Risk |
|---|-------------|------|---------|------|--------|------|
| 1 | `BraveRewardsDisabled` | DWord | `1` | BraveOnly | Windows·Mac·Linux | Brave Rewards data collection |
| 2 | `BraveWalletDisabled` | DWord | `1` | BraveOnly | Windows·Mac·Linux | Crypto wallet exposes addresses |
| 3 | `BraveVPNDisabled` | DWord | `1` | BraveOnly | Windows·Mac·Linux | VPN service metadata leaks |
| 4 | `BraveAIChatEnabled` | DWord | `0` | BraveOnly | Windows·Mac·Linux | Leo AI sends prompts to Brave servers |
| 5 | `BraveTalkDisabled` | DWord | `1` | BraveOnly | Windows·Mac·Linux | Video conferencing metadata |
| 6 | `BraveNewsDisabled` | DWord | `1` | BraveOnly | Windows·Mac·Linux | News feed network requests |
| 7 | `BravePlaylistEnabled` | DWord | `0` | BraveOnly | Windows·Mac·Linux | Offline media content |
| 8 | `BraveSpeedreaderEnabled` | DWord | `0` | BraveOnly | Windows·Mac·Linux | Reader mode page analysis |
| 9 | `BraveWaybackMachineEnabled` | DWord | `0` | BraveOnly | Windows·Mac·Linux | Internet Archive queries |
| 10 | `BraveP3AEnabled` | DWord | `0` | BraveOnly | Windows·Mac·Linux | P3A telemetry data |
| 11 | `BraveStatsPingEnabled` | DWord | `0` | BraveOnly | Windows·Mac·Linux | Authentication / status ping |
| 12 | `BraveWebDiscoveryEnabled` | DWord | `0` | BraveOnly | Windows·Mac·Linux | Search index contribution |
| 13 | `TorDisabled` | DWord | `1` | BraveOnly | Windows·Mac·Linux | Tor integration code path |
| 14 | `BraveDeAmpEnabled` | DWord | `1` | BraveOnly | Windows·Mac·Linux | AMP circumvention (Phase 2) |
| 15 | `BraveDebouncingEnabled` | DWord | `1` | BraveOnly | Windows·Mac·Linux | Bounce tracking (Phase 2) |
| 16 | `BraveReduceLanguageEnabled` | DWord | `1` | BraveOnly | Windows·Mac·Linux | Language fingerprint (Phase 2) |
| 17 | `BraveTrackingQueryParametersFilteringEnabled` | DWord | `1` | BraveOnly | Windows·Mac·Linux | URL tracking params (Phase 2) |
| 18 | `DefaultBraveAdblockSetting` | DWord | `2` | BraveOnly | Windows·Mac·Linux | Shields ad block (Phase 2) |
| 19 | `DefaultBraveFingerprintingV2Setting` | DWord | `3` | BraveOnly | Windows·Mac·Linux | Shields fingerprinting (Phase 2) |
| 20 | `BraveShieldsDisabledForUrls` | MultiString | `@()` | BraveOnly | Windows·Mac·Linux | Shields bypass list (Phase 2) |
| 21 | `BraveShieldsEnabledForUrls` | MultiString | `@()` | BraveOnly | Windows·Mac·Linux | Shields force list (Phase 2) |
| 22 | `BraveLocalAIEnabled` | DWord | `0` | BraveOnly | Windows·Mac·Linux | On-device AI features (Phase 2) |
| 23 | `EmailAliasesEnabled` | DWord | `0` | BraveOnly | Windows·Mac·Linux | Anonymous email aliases (Phase 2) |
| 24 | `MetricsReportingEnabled` | DWord | `0` | Essential | Windows | Chromium usage/crash metrics |
| 25 | `SafeBrowsingExtendedReportingEnabled` | DWord | `0` | Essential | Windows | Page content to Google |
| 26 | `UrlKeyedAnonymizedDataCollectionEnabled` | DWord | `0` | Essential | Windows | Visited URLs to Google |
| 27 | `SearchSuggestEnabled` | DWord | `0` | Essential | Windows | Keystroke data leak |
| 28 | `NetworkPredictionOptions` | DWord | `2` | Essential | Windows | DNS prefetch / pre-connect |
| 29 | `SpellcheckEnabled` | DWord | `0` | Essential | Windows | Text sent to Google servers |
| 30 | `AlternateErrorPagesEnabled` | DWord | `0` | Essential | Windows | DNS failure network requests |
| 31 | `BrowserNetworkTimeQueriesEnabled` | DWord | `0` | Essential | Windows | Time sync to Google |
| 32 | `DomainReliabilityAllowed` | DWord | `0` | Essential | Windows | Diagnostic data to Google |
| 33 | `BackgroundModeEnabled` | DWord | `0` | Essential | Windows | Background process tracking |
| 34 | `SafeBrowsingSurveysEnabled` | DWord | `0` | Essential | Windows | Post-browsing surveys |
| 35 | `SafeBrowsingDeepScanningEnabled` | DWord | `0` | Essential | Windows | Server-side download scan |
| 36 | `WebRtcEventLogCollectionAllowed` | DWord | `0` | Essential | Windows | WebRTC event logs to Google |
| 37 | `WebRtcTextLogCollectionAllowed` | DWord | `0` | Essential | Windows | WebRTC text logs to Google |
| 38 | `AudioCaptureAllowed` | DWord | `0` | Essential | Windows | Microphone access |
| 39 | `VideoCaptureAllowed` | DWord | `0` | Essential | Windows | Camera access |
| 40 | `BraveGlobalPrivacyControlEnabled` | DWord | `1` | Essential | Windows | GPC header (Phase 2) |
| 41 | `WebRtcIPHandling` | String | `default_public_interface_only` | Balanced | Windows | WebRTC IP exposure |
| 42 | `WebRtcLocalIpsAllowedUrls` | MultiString | `@()` | Balanced | Windows | Local IP via ICE |
| 43 | `HttpsOnlyMode` | String | `force_enabled` | Balanced | Windows | HTTPS enforcement |
| 44 | `DnsOverHttpsMode` | String | `automatic` | Balanced | Windows | Encrypted DNS |
| 45 | `BlockThirdPartyCookies` | DWord | `1` | Balanced | Windows | Cross-site tracking |
| 46 | `PasswordManagerEnabled` | DWord | `0` | Balanced | Windows | Built-in password storage |
| 47 | `PasswordManagerPasskeysEnabled` | DWord | `0` | Balanced | Windows | Passkey storage |
| 48 | `AutofillAddressEnabled` | DWord | `0` | Balanced | Windows | Address form data |
| 49 | `AutofillCreditCardEnabled` | DWord | `0` | Balanced | Windows | Payment method data |
| 50 | `ShowFullUrlsInAddressBar` | DWord | `1` | Balanced | Windows | Anti-phishing URL display |
| 51 | `DisableSafeBrowsingProceedAnyway` | DWord | `1` | Balanced | Windows | Malware warning bypass |
| 52 | `QuicAllowed` | DWord | `0` | Balanced | Windows | QUIC protocol |
| 53 | `ChromeVariations` | DWord | `1` | Balanced | Windows | Critical field trials only |
| 54 | `NetworkServiceSandboxEnabled` | DWord | `1` | Balanced | Windows | Network sandbox |
| 55 | `AudioSandboxEnabled` | DWord | `1` | Balanced | Windows | Audio sandbox |
| 56 | `DefaultGeolocationSetting` | DWord | `2` | Balanced | Windows | Device location access |
| 57 | `DefaultNotificationsSetting` | DWord | `2` | Balanced | Windows | Notification prompts |
| 58 | `DefaultPopupsSetting` | DWord | `2` | Balanced | Windows | Pop-up windows |
| 59 | `DefaultBraveHttpsUpgradeSetting` | DWord | `2` | Balanced | Windows | Brave HTTPS upgrade (Phase 2) |
| 60 | `DefaultBraveReferrersSetting` | DWord | `2` | Balanced | Windows | Brave referrer cap (Phase 2) |
| 61 | `BraveSyncUrl` | String | `https://sync-v2.brave.com/v2` | Balanced | Windows | Sync server URL (Phase 2) |
| 62 | `TranslateEnabled` | DWord | `0` | Strict | Windows | Text to Google for translation |
| 63 | `WebRtcIPHandling` | String | `disable_non_proxied_udp` | Strict | Windows | WebRTC proxy override |
| 64 | `DefaultSensorsSetting` | DWord | `2` | Strict | Windows | Device motion/light sensors |
| 65 | `DefaultLocalFontsSetting` | DWord | `2` | Strict | Windows | Font fingerprinting |
| 66 | `DefaultClipboardSetting` | DWord | `2` | Strict | Windows | Clipboard read/write |
| 67 | `DefaultFileSystemReadGuardSetting` | DWord | `2` | Strict | Windows | File system read |
| 68 | `DefaultFileSystemWriteGuardSetting` | DWord | `2` | Strict | Windows | File system write |
| 69 | `DefaultSerialGuardSetting` | DWord | `2` | Strict | Windows | Serial API access |
| 70 | `DefaultIdleDetectionSetting` | DWord | `2` | Strict | Windows | Idle state detection |
| 71 | `DefaultInsecureContentSetting` | DWord | `2` | Strict | Windows | Mixed content |
| 72 | `DefaultJavaScriptJitSetting` | DWord | `2` | Strict | Windows | JIT compilation |
| 73 | `DefaultCookiesSetting` | DWord | `2` | Strict | Windows | All cookies |
| 74 | `BrowserGuestModeEnabled` | DWord | `0` | Strict | Windows | Guest profile |
| 75 | `BrowserAddPersonEnabled` | DWord | `0` | Strict | Windows | New profile creation |
| 76 | `DefaultBraveRemember1PStorageSetting` | DWord | `2` | Strict | Windows | First-party storage (Phase 2) |
| 77 | `ImportAutofillFormData` | DWord | `0` | Strict | Windows | Cross-browser autofill (Phase 2) |
| 78 | `ImportBookmarks` | DWord | `0` | Strict | Windows | Cross-browser bookmarks (Phase 2) |
| 79 | `ImportHistory` | DWord | `0` | Strict | Windows | Cross-browser history (Phase 2) |
| 80 | `ImportSavedPasswords` | DWord | `0` | Strict | Windows | Cross-browser passwords (Phase 2) |
| 81 | `ImportSearchEngine` | DWord | `0` | Strict | Windows | Cross-browser search engine (Phase 2) |
| 82 | `ImportHomepage` | DWord | `0` | Strict | Windows | Cross-browser homepage (Phase 2) |

> **Note:** Row 63 (Strict `WebRtcIPHandling`) merges with row 41 (Balanced) — only 1 unique policy, Strict value overrides Balancing at runtime due to cumulative merge order. This is why 82 raw rows = 81 unique policies.

---

## Tier Breakdown

### BraveOnly — 23 policies
All Brave-specific features disabled or restricted. Zero usability impact for power users.

**New in Phase 2:** `BraveDeAmpEnabled`, `BraveDebouncingEnabled`, `BraveReduceLanguageEnabled`, `BraveTrackingQueryParametersFilteringEnabled`, `DefaultBraveAdblockSetting`, `DefaultBraveFingerprintingV2Setting`, `BraveShieldsDisabledForUrls`, `BraveShieldsEnabledForUrls`, `BraveLocalAIEnabled`, `EmailAliasesEnabled`

### Essential — 17 policies (+17 = 40 cumulative)
Data leak prevention. No usability impact. Stops all Chromium/Brave telemetry, background networking, and media capture.

**New in Phase 2:** `BraveGlobalPrivacyControlEnabled`

### Balanced — 21 policies (+21 = 61 cumulative)
Security & convenience balance. WebRTC hardening, encrypted DNS, cookie blocking, password/autofill disable, permission defaults.

**New in Phase 2:** `DefaultBraveHttpsUpgradeSetting`, `DefaultBraveReferrersSetting`, `BraveSyncUrl`

### Strict — 20 policies (+20 = 81 cumulative)
Maximum privacy. Disables JIT, cookies, translation, sensors, fonts, clipboard, file system, serial, idle detection, guest mode, cross-browser imports. Some login/session breakage expected.

**New in Phase 2:** `DefaultBraveRemember1PStorageSetting`, `ImportAutofillFormData`, `ImportBookmarks`, `ImportHistory`, `ImportSavedPasswords`, `ImportSearchEngine`, `ImportHomepage`

---

## Type Distribution

| Type | Count | Percentage |
|------|-------|------------|
| DWord | 74 | 91.4% |
| String | 4 | 4.9% |
| MultiString | 3 | 3.7% |
| **Total** | **81** | **100%** |

### String policies (4)
- `WebRtcIPHandling` — enum: `default_public_interface_only` (Balanced) / `disable_non_proxied_udp` (Strict)
- `HttpsOnlyMode` — enum: `force_enabled`
- `DnsOverHttpsMode` — enum: `automatic`
- `BraveSyncUrl` — URL: `https://sync-v2.brave.com/v2`

### MultiString policies (3)
- `WebRtcLocalIpsAllowedUrls`
- `BraveShieldsDisabledForUrls`
- `BraveShieldsEnabledForUrls`

---

## Overlap Register

| Policy Name | Appears In | Conflict |
|-------------|------------|----------|
| `WebRtcIPHandling` | Balanced → `default_public_interface_only` · Strict → `disable_non_proxied_udp` | Strict value wins (same type: String) |

---

## Excluded Policies

| Policy Name | Reason |
|-------------|--------|
| `CloudPrintProxyEnabled` | Present in `$allPolicyNames` (reset list) but deprecated by Chromium; not assigned to any tier |

---

## Cross-Platform Availability

| Platform | Script | Notes |
|----------|--------|-------|
| Windows | `BraveOmega-EN.ps1` / `BraveOmega-TR.ps1` | Primary target: HKLM registry + Omaha GUID |
| macOS | `BraveOmega-Mac-BraveOnly.sh` | Brave-only tier via `defaults write` |
| Linux | `BraveOmega-Linux-BraveOnly.json` | Brave-only tier via Chromium policy JSON |

All 23 BraveOnly policies are also applied on macOS and Linux, though the mechanism differs (CLI/JSON instead of registry). Essential/Balanced/Strict tiers are Windows-only due to HKLM+GUID dependency.
