<div align="center">

<br>

# Brave Omega — Policy Catalog

> **Language / Dil** &nbsp;
> [EN English](#-english-catalog) &nbsp;·&nbsp; [TR Türkçe](#-türkçe-katalog)

<br>

</div>

---

<a id="-english-catalog"></a>

# Brave Omega — Policy Catalog

> **Generated from:** `BraveOmega-EN.ps1` v2.5.0.0 | `BraveOmega-TR.ps1` v2.5.0.0  
> **Date:** 2026-07-21  
> **Total unique policies:** 150 (151 raw entries, 1 overlap merged)  
> **Type distribution:** 116 DWord · 7 String · 17 MultiString  
> **Validated on:** Brave 1.92.141 / Chromium 150.0.7871.128 / Windows 11 26200

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
| 14 | `BraveDeAmpEnabled` | DWord | `1` | BraveOnly | Windows·Mac·Linux | AMP circumvention |
| 15 | `BraveDebouncingEnabled` | DWord | `1` | BraveOnly | Windows·Mac·Linux | Bounce tracking |
| 16 | `BraveReduceLanguageEnabled` | DWord | `1` | BraveOnly | Windows·Mac·Linux | Language fingerprint |
| 17 | `BraveTrackingQueryParametersFilteringEnabled` | DWord | `1` | BraveOnly | Windows·Mac·Linux | URL tracking params |
| 18 | `DefaultBraveAdblockSetting` | DWord | `2` | BraveOnly | Windows·Mac·Linux | Shields ad block level |
| 19 | `DefaultBraveFingerprintingV2Setting` | DWord | `3` | BraveOnly | Windows·Mac·Linux | Shields fingerprinting level |
| 20 | `BraveShieldsDisabledForUrls` | MultiString | `@()` | BraveOnly | Windows·Mac·Linux | Shields bypass list |
| 21 | `BraveShieldsEnabledForUrls` | MultiString | `@()` | BraveOnly | Windows·Mac·Linux | Shields force list |
| 22 | `SafeBrowsingProtectionLevel` | DWord | `2` | BraveOnly | Windows·Mac·Linux | Safe Browsing protection level |
| 23 | `PasswordProtectionWarningTrigger` | DWord | `3` | BraveOnly | Windows·Mac·Linux | Password leak warning trigger |
| 24 | `EmailAliasesEnabled` | DWord | `0` | BraveOnly | Windows·Mac·Linux | Anonymous email aliases |
| 25 | `MetricsReportingEnabled` | DWord | `0` | Essential | Windows | Chromium usage/crash metrics |
| 26 | `SafeBrowsingExtendedReportingEnabled` | DWord | `0` | Essential | Windows | Page content to Google |
| 27 | `UrlKeyedAnonymizedDataCollectionEnabled` | DWord | `0` | Essential | Windows | Visited URLs to Google |
| 28 | `SearchSuggestEnabled` | DWord | `0` | Essential | Windows | Keystroke data leak |
| 29 | `NetworkPredictionOptions` | DWord | `2` | Essential | Windows | DNS prefetch / pre-connect |
| 30 | `SpellcheckEnabled` | DWord | `1` | Essential | Windows | Spellcheck (local engine) |
| 31 | `AlternateErrorPagesEnabled` | DWord | `0` | Essential | Windows | DNS failure network requests |
| 32 | `BrowserNetworkTimeQueriesEnabled` | DWord | `0` | Essential | Windows | Time sync to Google |
| 33 | `DomainReliabilityAllowed` | DWord | `0` | Essential | Windows | Diagnostic data to Google |
| 34 | `BackgroundModeEnabled` | DWord | `0` | Essential | Windows | Background process tracking |
| 35 | `SafeBrowsingSurveysEnabled` | DWord | `0` | Essential | Windows | Post-browsing surveys |
| 36 | `SafeBrowsingDeepScanningEnabled` | DWord | `0` | Essential | Windows | Server-side download scan |
| 37 | `WebRtcEventLogCollectionAllowed` | DWord | `0` | Essential | Windows | WebRTC event logs to Google |
| 38 | `WebRtcTextLogCollectionAllowed` | DWord | `0` | Essential | Windows | WebRTC text logs to Google |
| 39 | `AudioCaptureAllowed` | DWord | `0` | Essential | Windows | Microphone access |
| 40 | `VideoCaptureAllowed` | DWord | `0` | Essential | Windows | Camera access |
| 41 | `BraveGlobalPrivacyControlEnabled` | DWord | `1` | Essential | Windows | GPC header |
| 42 | `DefaultWebUsbGuardSetting` | DWord | `2` | Essential | Windows | USB device access |
| 43 | `DefaultWebBluetoothGuardSetting` | DWord | `2` | Essential | Windows | Bluetooth device access |
| 44 | `DefaultWebHidGuardSetting` | DWord | `2` | Essential | Windows | HID device access |
| 45 | `DeviceAttributesAllowedForOrigins` | MultiString | `@()` | Essential | Windows | Device attribute exposure |
| 46 | `EncryptedClientHelloEnabled` | DWord | `1` | Essential | Windows | TLS ClientHello encryption |
| 47 | `PaymentMethodQueryEnabled` | DWord | `0` | Essential | Windows | Payment method fingerprint |
| 48 | `SuppressDifferentOriginSubframeDialogs` | DWord | `1` | Essential | Windows | Cross-origin dialog abuse |
| 49 | `EnableOnlineRevocationChecks` | DWord | `1` | Essential | Windows | Certificate revocation checks |
| 50 | `ProxySettings` | String | `{"ProxyMode":"system"}` | Essential | Windows | Proxy configuration |
| 51 | `BrowserSignin` | DWord | `0` | Essential | Windows | Chrome sign-in prompt |
| 52 | `ExtensionInstallSources` | MultiString | `@()` | Essential | Windows | Extension install sources |
| 53 | `ScreenCaptureAllowed` | DWord | `0` | Essential | Windows | Screen capture API |
| 54 | `WebRtcIPHandling` | String | `disable_non_proxied_udp` | Balanced | Windows | WebRTC IP exposure |
| 55 | `WebRtcLocalIpsAllowedUrls` | MultiString | `@()` | Balanced | Windows | Local IP via ICE |
| 56 | `HttpsOnlyMode` | String | `force_enabled` | Balanced | Windows | HTTPS enforcement |
| 57 | `DnsOverHttpsMode` | String | `automatic` | Balanced | Windows | Encrypted DNS |
| 58 | `BlockThirdPartyCookies` | DWord | `1` | Balanced | Windows | Cross-site tracking |
| 59 | `PasswordManagerEnabled` | DWord | `0` | Balanced | Windows | Built-in password storage |
| 60 | `PasswordManagerPasskeysEnabled` | DWord | `0` | Balanced | Windows | Passkey storage |
| 61 | `AutofillAddressEnabled` | DWord | `0` | Balanced | Windows | Address form data |
| 62 | `AutofillCreditCardEnabled` | DWord | `0` | Balanced | Windows | Payment method data |
| 63 | `ShowFullUrlsInAddressBar` | DWord | `1` | Balanced | Windows | Anti-phishing URL display |
| 64 | `DisableSafeBrowsingProceedAnyway` | DWord | `1` | Balanced | Windows | Malware warning bypass |
| 65 | `QuicAllowed` | DWord | `0` | Balanced | Windows | QUIC protocol |
| 66 | `ChromeVariations` | DWord | `1` | Balanced | Windows | Critical field trials only |
| 67 | `NetworkServiceSandboxEnabled` | DWord | `1` | Balanced | Windows | Network sandbox |
| 68 | `AudioSandboxEnabled` | DWord | `1` | Balanced | Windows | Audio sandbox |
| 69 | `DefaultGeolocationSetting` | DWord | `2` | Balanced | Windows | Device location access |
| 70 | `DefaultNotificationsSetting` | DWord | `2` | Balanced | Windows | Notification prompts |
| 71 | `DefaultPopupsSetting` | DWord | `2` | Balanced | Windows | Pop-up windows |
| 72 | `DefaultBraveHttpsUpgradeSetting` | DWord | `2` | Balanced | Windows | Brave HTTPS upgrade |
| 73 | `DefaultBraveReferrersSetting` | DWord | `2` | Balanced | Windows | Brave referrer cap |
| 74 | `BraveSyncUrl` | String | `https://sync-v2.brave.com/v2` | Balanced | Windows | Sync server URL |
| 75 | `DefaultWindowManagementSetting` | DWord | `2` | Balanced | Windows | Window management permission |
| 76 | `SitePerProcess` | DWord | `1` | Balanced | Windows | Site isolation |
| 77 | `IntensiveWakeUpThrottlingEnabled` | DWord | `1` | Balanced | Windows | Background timer throttling |
| 78 | `UserFeedbackAllowed` | DWord | `0` | Balanced | Windows | User feedback prompts |
| 79 | `ExtensionInstallForcelist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh;…` | Balanced | Windows | Force-installed extension |
| 80 | `DownloadRestrictions` | DWord | `1` | Balanced | Windows | Dangerous download warning |
| 81 | `DownloadDirectory` | String | `${env:USERPROFILE}\Downloads\` | Balanced | Windows | Download path |
| 82 | `PromptForDownloadLocation` | DWord | `0` | Balanced | Windows | Download location prompt |
| 83 | `RelaunchNotification` | DWord | `2` | Balanced | Windows | Browser relaunch notification |
| 84 | `RelaunchNotificationPeriod` | DWord | `3600000` | Balanced | Windows | Relaunch timer (1 hour) |
| 85 | `LocalNetworkAccessPermissionsPolicyDefaultEnabled` | DWord | `0` | Balanced | Windows | Local network permission default |
| 86 | `GenAILocalFoundationalModelSettings` | DWord | `1` | Balanced | Windows | On-device AI model |
| 88 | `DefaultSensorsSetting` | DWord | `2` | Advanced | Windows | Device motion/light sensors |
| 89 | `DefaultLocalFontsSetting` | DWord | `2` | Advanced | Windows | Font fingerprinting |
| 90 | `DefaultSerialGuardSetting` | DWord | `2` | Advanced | Windows | Serial API access |
| 91 | `DefaultIdleDetectionSetting` | DWord | `2` | Advanced | Windows | Idle state detection |
| 92 | `BrowserGuestModeEnabled` | DWord | `0` | Advanced | Windows | Guest profile |
| 93 | `BrowserAddPersonEnabled` | DWord | `0` | Advanced | Windows | New profile creation |
| 94 | `ImportAutofillFormData` | DWord | `0` | Advanced | Windows | Cross-browser autofill |
| 95 | `ImportHistory` | DWord | `0` | Advanced | Windows | Cross-browser history |
| 96 | `ImportSavedPasswords` | DWord | `0` | Advanced | Windows | Cross-browser passwords |
| 97 | `ImportSearchEngine` | DWord | `0` | Advanced | Windows | Cross-browser search engine |
| 98 | `ImportHomepage` | DWord | `0` | Advanced | Windows | Cross-browser homepage |
| 99 | `ExtensionInstallBlocklist` | MultiString | `*` | Advanced | Windows | Extension blocklist |
| 100 | `ExtensionInstallAllowlist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh` | Advanced | Windows | Extension allowlist |
| 101 | `ExtensionAllowedTypes` | MultiString | `extension, shared_module` | Advanced | Windows | Allowed extension types |
| 102 | `BlockExternalExtensions` | DWord | `1` | Advanced | Windows | External extension install |
| 103 | `ExtensionSettings` | String | `{"*":{"installation_mode":"blocked"},…}` | Advanced | Windows | Extension policy matrix |
| 104 | `BuiltInDnsClientEnabled` | DWord | `0` | Advanced | Windows | Built-in DNS client |
| 105 | `ShowHomeButton` | DWord | `0` | Advanced | Windows | Home button visibility |
| 106 | `HideWebStoreIcon` | DWord | `1` | Advanced | Windows | Web Store icon |
| 107 | `DefaultJavaScriptSetting` | DWord | `0` | Advanced | Windows | JavaScript execution |
| 108 | `GeminiSettings` | DWord | `1` | Advanced | Windows | Gemini AI suggestions |
| 109 | `AIModeSettings` | DWord | `1` | Advanced | Windows | AI Mode in Search |
| 110 | `AutofillPredictionSettings` | DWord | `2` | Advanced | Windows | Autofill predictions |
| 111 | `ChromeSuggestionsSettings` | DWord | `1` | Advanced | Windows | Chrome suggestions |
| 112 | `CreateThemesSettings` | DWord | `2` | Advanced | Windows | Theme creation |
| 113 | `DevToolsGenAiSettings` | DWord | `2` | Advanced | Windows | DevTools AI assistant |
| 114 | `HelpMeWriteSettings` | DWord | `2` | Advanced | Windows | Help Me Write |
| 115 | `HistorySearchSettings` | DWord | `2` | Advanced | Windows | History search |
| 116 | `SearchContentSharingSettings` | DWord | `1` | Advanced | Windows | Search content sharing |
| 117 | `SmartTabSharingSettings` | DWord | `1` | Advanced | Windows | Smart tab sharing |
| 118 | `TabCompareSettings` | DWord | `2` | Advanced | Windows | Tab comparison |
| 119 | `GeminiActOnWebSettings` | DWord | `1` | Advanced | Windows | Gemini web actions |
| 120 | `GeminiSparkSettings` | DWord | `1` | Advanced | Windows | Gemini page spark |
| 121 | `RendererAppContainerEnabled` | DWord | `1` | Advanced | Windows | Renderer sandbox |
| 122 | `LocalNetworkAccessAllowedForUrls` | MultiString | `@()` | Advanced | Windows | Local network allowlist |
| 123 | `LocalNetworkAccessBlockedForUrls` | MultiString | `@()` | Advanced | Windows | Local network blocklist |
| 124 | `LocalNetworkAccessIpAddressSpaceOverrides` | MultiString | `@()` | Advanced | Windows | Local network IP overrides |
| 125 | `LocalNetworkAccessRestrictionsTemporaryOptOut` | DWord | `0` | Advanced | Windows | Local network opt-out |
| 126 | `TranslateEnabled` | DWord | `0` | Strict | Windows | Text to Google for translation |
| 127 | `DefaultClipboardSetting` | DWord | `2` | Strict | Windows | Clipboard read/write |
| 128 | `DefaultFileSystemReadGuardSetting` | DWord | `2` | Strict | Windows | File system read |
| 129 | `DefaultFileSystemWriteGuardSetting` | DWord | `2` | Strict | Windows | File system write |
| 130 | `DefaultInsecureContentSetting` | DWord | `2` | Strict | Windows | Mixed content |
| 131 | `DefaultJavaScriptJitSetting` | DWord | `2` | Strict | Windows | JIT compilation |
| 132 | `DefaultCookiesSetting` | DWord | `2` | Strict | Windows | All cookies |
| 133 | `ImportBookmarks` | DWord | `0` | Strict | Windows | Cross-browser bookmarks |
| 134 | `DefaultBraveRemember1PStorageSetting` | DWord | `2` | Strict | Windows | First-party storage |
| 135 | `IncognitoModeAvailability` | DWord | `1` | Strict | Windows | Incognito mode |
| 136 | `TaskManagerEndProcessEnabled` | DWord | `0` | Strict | Windows | Task Manager |
| 137 | `PrintingEnabled` | DWord | `0` | Strict | Windows | Print function |
| 138 | `DisablePrintPreview` | DWord | `1` | Strict | Windows | Print preview |
| 139 | `DownloadRestrictions` | DWord | `3` | Strict | Windows | Block all downloads |
| 140 | `DeveloperToolsAvailability` | DWord | `2` | Strict | Windows | Developer Tools |
| 141 | `BrowsingDataLifetime` | String | `{"data_types"=@(…);"time_to_live…"=24}` | Strict | Windows | Auto-clear browsing data |
| 142 | `AlwaysOpenPdfExternally` | DWord | `1` | Strict | Windows | Built-in PDF viewer |
| 143 | `CertificateTransparencyEnforcementDisabledForUrls` | MultiString | `@()` | Strict | Windows | Certificate Transparency |
| 144 | `PasswordLeakDetectionEnabled` | DWord | `1` | Strict | Windows | Password leak detection |
| 145 | `SpellCheckServiceEnabled` | DWord | `0` | Strict | Windows | Spell check network service |
| 146 | `SyncDisabled` | DWord | `1` | Strict | Windows | Brave Sync |
| 147 | `ScreenCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows | Screen capture allowlist |
| 148 | `SameOriginTabCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows | Same-origin tab capture |
| 149 | `TabCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows | Tab capture allowlist |
| 150 | `WindowCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows | Window capture allowlist |
| 151 | `LocalNetworkAllowedForUrls` | MultiString | `@()` | Strict | Windows | Local network capture allowlist |
| 152 | `LocalNetworkBlockedForUrls` | MultiString | `@()` | Strict | Windows | Local network capture blocklist |

> **Note:** Row 139 (Strict `DownloadRestrictions`) merges with row 80 (Balanced) — only 1 unique policy. Balanced applies `1` (warn on dangerous downloads); Strict overrides with `3` (block all downloads). This is why 151 raw rows = 150 unique policies.

---

## Tier Breakdown

### BraveOnly — 24 policies
All Brave-specific features disabled or restricted. Zero usability impact for power users.

### Essential — 29 policies (+29 = 53 cumulative)
Data leak prevention. No usability impact. Stops all Chromium/Brave telemetry, background networking, and media capture. Blocks USB/Bluetooth/HID device access.

### Balanced — 33 policies (+33 = 86 cumulative)
Security & convenience balance. WebRTC hardening, encrypted DNS, cookie blocking, password/autofill disable, permission defaults, site isolation, download controls, Dark Reader extension.

### Advanced — 38 policies (+38 = 124 cumulative)
Extended hardening. Disables sensors, fonts, serial, idle detection, guest mode, cross-browser imports, extension restrictions, JavaScript default off, AI features disabled.

### Strict — 27 policies (+27 = 150 cumulative)
Maximum privacy. Disables translation, clipboard, file system, JIT, cookies, printing, downloads, developer tools, cloud reporting. Auto-clears browsing data every 24 hours.

---

## Type Distribution

| Type | Count | Percentage |
|------|-------|------------|
| DWord | 116 | 77.3% |
| String | 7 | 4.7% |
| MultiString | 17 | 11.3% |
| **Total (unique)** | **150** | **100%** |

---

## Overlap Register

| Policy Name | Appears In | Conflict |
|-------------|------------|----------|
| `DownloadRestrictions` | Balanced (`1`) → Strict (`3`) | Strict overrides Balanced value |

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

All 24 BraveOnly policies are also applied on macOS and Linux, though the mechanism differs (CLI/JSON instead of registry). Essential/Balanced/Advanced/Strict tiers are Windows-only due to HKLM+GUID dependency.

---

<!-- ============================================================ -->
<!-- TÜRKÇE / TURKISH                                           -->
<!-- ============================================================ -->

<a id="-türkçe-katalog"></a>

# Brave Omega — Politika Kataloğu

> **Kaynak:** `BraveOmega-EN.ps1` v2.5.0.0 | `BraveOmega-TR.ps1` v2.5.0.0  
> **Tarih:** 2026-07-21  
> **Toplam benzersiz politika:** 150 (151 ham girdi, 1 çakışma birleştirildi)  
> **Tür dağılımı:** 116 DWord · 7 String · 17 MultiString  
> **Doğrulandı:** Brave 1.92.141 / Chromium 150.0.7871.128 / Windows 11 26200

---

## Gösterge

| Sütun | Anlamı |
|-------|--------|
| **#** | Sıralı katalog kimliği |
| **Politika Adı** | Chromium/Brave kurumsal politika kayıt defteri adı |
| **Tür** | Kayıt defteri veri türü |
| **Varsayılan** | Brave Omega tarafından uygulanan değer |
| **Katman** | Bu politikayı içeren ilk sıkılaştırma katmanı |
| **Kaynak** | Politikanın uygulandığı platform(lar) |
| **Risk** | Uygulanmadığı takdirde gizlilik/güvenlik etkisi |

---

## Tüm Politikalar

| # | Politika Adı | Tür | Varsayılan | Katman | Kaynak | Risk |
|---|-------------|-----|-----------|--------|--------|------|
| 1 | `BraveRewardsDisabled` | DWord | `1` | Brave Yalnız | Windows·Mac·Linux | Brave Rewards veri toplama |
| 2 | `BraveWalletDisabled` | DWord | `1` | Brave Yalnız | Windows·Mac·Linux | Kripto cüzdan adres ifşası |
| 3 | `BraveVPNDisabled` | DWord | `1` | Brave Yalnız | Windows·Mac·Linux | VPN hizmeti meta veri sızıntısı |
| 4 | `BraveAIChatEnabled` | DWord | `0` | Brave Yalnız | Windows·Mac·Linux | Leo AI, Brave sunucularına prompt gönderir |
| 5 | `BraveTalkDisabled` | DWord | `1` | Brave Yalnız | Windows·Mac·Linux | Video konferans meta verileri |
| 6 | `BraveNewsDisabled` | DWord | `1` | Brave Yalnız | Windows·Mac·Linux | Haber akışı ağ istekleri |
| 7 | `BravePlaylistEnabled` | DWord | `0` | Brave Yalnız | Windows·Mac·Linux | Çevrimdışı medya içeriği |
| 8 | `BraveSpeedreaderEnabled` | DWord | `0` | Brave Yalnız | Windows·Mac·Linux | Okuma modu sayfa analizi |
| 9 | `BraveWaybackMachineEnabled` | DWord | `0` | Brave Yalnız | Windows·Mac·Linux | İnternet Arşivi sorguları |
| 10 | `BraveP3AEnabled` | DWord | `0` | Brave Yalnız | Windows·Mac·Linux | P3A telemetri verileri |
| 11 | `BraveStatsPingEnabled` | DWord | `0` | Brave Yalnız | Windows·Mac·Linux | Kimlik doğrulama / durum pingi |
| 12 | `BraveWebDiscoveryEnabled` | DWord | `0` | Brave Yalnız | Windows·Mac·Linux | Arama dizini katkısı |
| 13 | `TorDisabled` | DWord | `1` | Brave Yalnız | Windows·Mac·Linux | Tor entegrasyon kod yolu |
| 14 | `BraveDeAmpEnabled` | DWord | `1` | Brave Yalnız | Windows·Mac·Linux | AMP atlatma |
| 15 | `BraveDebouncingEnabled` | DWord | `1` | Brave Yalnız | Windows·Mac·Linux | Sıçrama izleme |
| 16 | `BraveReduceLanguageEnabled` | DWord | `1` | Brave Yalnız | Windows·Mac·Linux | Dil parmak izi |
| 17 | `BraveTrackingQueryParametersFilteringEnabled` | DWord | `1` | Brave Yalnız | Windows·Mac·Linux | URL izleme parametreleri |
| 18 | `DefaultBraveAdblockSetting` | DWord | `2` | Brave Yalnız | Windows·Mac·Linux | Kalkan reklam engelleme düzeyi |
| 19 | `DefaultBraveFingerprintingV2Setting` | DWord | `3` | Brave Yalnız | Windows·Mac·Linux | Kalkan parmak izi düzeyi |
| 20 | `BraveShieldsDisabledForUrls` | MultiString | `@()` | Brave Yalnız | Windows·Mac·Linux | Kalkan atlama listesi |
| 21 | `BraveShieldsEnabledForUrls` | MultiString | `@()` | Brave Yalnız | Windows·Mac·Linux | Kalkan zorlama listesi |
| 22 | `SafeBrowsingProtectionLevel` | DWord | `2` | Brave Yalnız | Windows·Mac·Linux | Safe Browsing koruma düzeyi |
| 23 | `PasswordProtectionWarningTrigger` | DWord | `3` | Brave Yalnız | Windows·Mac·Linux | Parola sızıntısı uyarı tetikleyici |
| 24 | `EmailAliasesEnabled` | DWord | `0` | Brave Yalnız | Windows·Mac·Linux | Anonim e-posta takma adları |
| 25 | `MetricsReportingEnabled` | DWord | `0` | Temel | Windows | Chromium kullanım/çökme metrikleri |
| 26 | `SafeBrowsingExtendedReportingEnabled` | DWord | `0` | Temel | Windows | Sayfa içeriğini Google'a gönderme |
| 27 | `UrlKeyedAnonymizedDataCollectionEnabled` | DWord | `0` | Temel | Windows | Ziyaret edilen URL'ler Google'a |
| 28 | `SearchSuggestEnabled` | DWord | `0` | Temel | Windows | Tuş vuruşu veri sızıntısı |
| 29 | `NetworkPredictionOptions` | DWord | `2` | Temel | Windows | DNS ön getirme / ön bağlantı |
| 30 | `SpellcheckEnabled` | DWord | `1` | Temel | Windows | Yazım denetimi (yerel motor) |
| 31 | `AlternateErrorPagesEnabled` | DWord | `0` | Temel | Windows | DNS hatasında ağ istekleri |
| 32 | `BrowserNetworkTimeQueriesEnabled` | DWord | `0` | Temel | Windows | Google'a zaman senkronizasyonu |
| 33 | `DomainReliabilityAllowed` | DWord | `0` | Temel | Windows | Google'a tanı verisi |
| 34 | `BackgroundModeEnabled` | DWord | `0` | Temel | Windows | Arka plan işlem izleme |
| 35 | `SafeBrowsingSurveysEnabled` | DWord | `0` | Temel | Windows | Gezinti sonrası anketler |
| 36 | `SafeBrowsingDeepScanningEnabled` | DWord | `0` | Temel | Windows | Sunucu tarafı indirme taraması |
| 37 | `WebRtcEventLogCollectionAllowed` | DWord | `0` | Temel | Windows | WebRTC olay günlükleri Google'a |
| 38 | `WebRtcTextLogCollectionAllowed` | DWord | `0` | Temel | Windows | WebRTC metin günlükleri Google'a |
| 39 | `AudioCaptureAllowed` | DWord | `0` | Temel | Windows | Mikrofon erişimi |
| 40 | `VideoCaptureAllowed` | DWord | `0` | Temel | Windows | Kamera erişimi |
| 41 | `BraveGlobalPrivacyControlEnabled` | DWord | `1` | Temel | Windows | GPC başlığı |
| 42 | `DefaultWebUsbGuardSetting` | DWord | `2` | Temel | Windows | USB cihaz erişimi |
| 43 | `DefaultWebBluetoothGuardSetting` | DWord | `2` | Temel | Windows | Bluetooth cihaz erişimi |
| 44 | `DefaultWebHidGuardSetting` | DWord | `2` | Temel | Windows | HID cihaz erişimi |
| 45 | `DeviceAttributesAllowedForOrigins` | MultiString | `@()` | Temel | Windows | Cihaz öznitelik ifşası |
| 46 | `EncryptedClientHelloEnabled` | DWord | `1` | Temel | Windows | TLS ClientHello şifreleme |
| 47 | `PaymentMethodQueryEnabled` | DWord | `0` | Temel | Windows | Ödeme yöntemi parmak izi |
| 48 | `SuppressDifferentOriginSubframeDialogs` | DWord | `1` | Temel | Windows | Farklı köken alt çerçeve диалогları |
| 49 | `EnableOnlineRevocationChecks` | DWord | `1` | Temel | Windows | Sertifika iptal kontrolleri |
| 50 | `ProxySettings` | String | `{"ProxyMode":"system"}` | Temel | Windows | Vekil sunucu yapılandırması |
| 51 | `BrowserSignin` | DWord | `0` | Temel | Windows | Chrome giriş istemi |
| 52 | `ExtensionInstallSources` | MultiString | `@()` | Temel | Windows | Eklenti yükleme kaynakları |
| 53 | `ScreenCaptureAllowed` | DWord | `0` | Temel | Windows | Ekran yakalama API'si |
| 54 | `WebRtcIPHandling` | String | `disable_non_proxied_udp` | Dengeli | Windows | WebRTC IP ifşası |
| 55 | `WebRtcLocalIpsAllowedUrls` | MultiString | `@()` | Dengeli | Windows | ICE yoluyla yerel IP |
| 56 | `HttpsOnlyMode` | String | `force_enabled` | Dengeli | Windows | HTTPS zorlaması |
| 57 | `DnsOverHttpsMode` | String | `automatic` | Dengeli | Windows | Şifreli DNS |
| 58 | `BlockThirdPartyCookies` | DWord | `1` | Dengeli | Windows | Siteler arası izleme |
| 59 | `PasswordManagerEnabled` | DWord | `0` | Dengeli | Windows | Yerleşik parola depolama |
| 60 | `PasswordManagerPasskeysEnabled` | DWord | `0` | Dengeli | Windows | Passkey depolama |
| 61 | `AutofillAddressEnabled` | DWord | `0` | Dengeli | Windows | Adres form verileri |
| 62 | `AutofillCreditCardEnabled` | DWord | `0` | Dengeli | Windows | Ödeme yöntemi verileri |
| 63 | `ShowFullUrlsInAddressBar` | DWord | `1` | Dengeli | Windows | Oltalama önleme URL gösterimi |
| 64 | `DisableSafeBrowsingProceedAnyway` | DWord | `1` | Dengeli | Windows | Kötü amaçlı yazılım uyarı atlama |
| 65 | `QuicAllowed` | DWord | `0` | Dengeli | Windows | QUIC protokolü |
| 66 | `ChromeVariations` | DWord | `1` | Dengeli | Windows | Yalnızca kritik alan denemeleri |
| 67 | `NetworkServiceSandboxEnabled` | DWord | `1` | Dengeli | Windows | Ağ kum havuzu |
| 68 | `AudioSandboxEnabled` | DWord | `1` | Dengeli | Windows | Ses kum havuzu |
| 69 | `DefaultGeolocationSetting` | DWord | `2` | Dengeli | Windows | Cihaz konumu erişimi |
| 70 | `DefaultNotificationsSetting` | DWord | `2` | Dengeli | Windows | Bildirim istemleri |
| 71 | `DefaultPopupsSetting` | DWord | `2` | Dengeli | Windows | Açılır pencereler |
| 72 | `DefaultBraveHttpsUpgradeSetting` | DWord | `2` | Dengeli | Windows | Brave HTTPS yükseltme |
| 73 | `DefaultBraveReferrersSetting` | DWord | `2` | Dengeli | Windows | Brave yönlendiren sınırı |
| 74 | `BraveSyncUrl` | String | `https://sync-v2.brave.com/v2` | Dengeli | Windows | Senkronizasyon sunucu URL'si |
| 75 | `DefaultWindowManagementSetting` | DWord | `2` | Dengeli | Windows | Pencere yönetimi izni |
| 76 | `SitePerProcess` | DWord | `1` | Dengeli | Windows | Site izolasyonu |
| 77 | `IntensiveWakeUpThrottlingEnabled` | DWord | `1` | Dengeli | Windows | Arka plan zamanlayıcı kısıtlaması |
| 78 | `UserFeedbackAllowed` | DWord | `0` | Dengeli | Windows | Kullanıcı geri bildirim istemleri |
| 79 | `ExtensionInstallForcelist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh;…` | Dengeli | Windows | Zorunlu eklenti |
| 80 | `DownloadRestrictions` | DWord | `1` | Dengeli | Windows | Tehlikeli indirme uyarısı |
| 81 | `DownloadDirectory` | String | `${env:USERPROFILE}\Downloads\` | Dengeli | Windows | İndirme yolu |
| 82 | `PromptForDownloadLocation` | DWord | `0` | Dengeli | Windows | İndirme konumu istemi |
| 83 | `RelaunchNotification` | DWord | `2` | Dengeli | Windows | Tarayıcı yeniden başlatma bildirimi |
| 84 | `RelaunchNotificationPeriod` | DWord | `3600000` | Dengeli | Windows | Yeniden başlatma zamanlayıcı (1 saat) |
| 85 | `LocalNetworkAccessPermissionsPolicyDefaultEnabled` | DWord | `0` | Dengeli | Windows | Yerel ağ izin varsayılanı |
| 86 | `GenAILocalFoundationalModelSettings` | DWord | `1` | Dengeli | Windows | Cihaz içi yapay zeka modeli |
| 87 | `DefaultSensorsSetting` | DWord | `2` | İleri | Windows | Hareket/ışık sensörleri |
| 89 | `DefaultLocalFontsSetting` | DWord | `2` | İleri | Windows | Yazı tipi parmak izi |
| 90 | `DefaultSerialGuardSetting` | DWord | `2` | İleri | Windows | Serial API erişimi |
| 91 | `DefaultIdleDetectionSetting` | DWord | `2` | İleri | Windows | Boşta algılama |
| 92 | `BrowserGuestModeEnabled` | DWord | `0` | İleri | Windows | Misafir profili |
| 93 | `BrowserAddPersonEnabled` | DWord | `0` | İleri | Windows | Yeni profil oluşturma |
| 94 | `ImportAutofillFormData` | DWord | `0` | İleri | Windows | Tarayıcılar arası otomatik doldurma |
| 95 | `ImportHistory` | DWord | `0` | İleri | Windows | Tarayıcılar arası geçmiş |
| 96 | `ImportSavedPasswords` | DWord | `0` | İleri | Windows | Tarayıcılar arası parolalar |
| 97 | `ImportSearchEngine` | DWord | `0` | İleri | Windows | Tarayıcılar arası arama motoru |
| 98 | `ImportHomepage` | DWord | `0` | İleri | Windows | Tarayıcılar arası ana sayfa |
| 99 | `ExtensionInstallBlocklist` | MultiString | `*` | İleri | Windows | Eklenti engelleme listesi |
| 100 | `ExtensionInstallAllowlist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh` | İleri | Windows | Eklenti izin listesi |
| 101 | `ExtensionAllowedTypes` | MultiString | `extension, shared_module` | İleri | Windows | İzin verilen eklenti türleri |
| 102 | `BlockExternalExtensions` | DWord | `1` | İleri | Windows | Harici eklenti yükleme |
| 103 | `ExtensionSettings` | String | `{"*":{"installation_mode":"blocked"},…}` | İleri | Windows | Eklenti politika matrisi |
| 104 | `BuiltInDnsClientEnabled` | DWord | `0` | İleri | Windows | Yerleşik DNS istemcisi |
| 105 | `ShowHomeButton` | DWord | `0` | İleri | Windows | Ana sayfa düğmesi görünürlüğü |
| 106 | `HideWebStoreIcon` | DWord | `1` | İleri | Windows | Web Mağazası simgesi |
| 107 | `DefaultJavaScriptSetting` | DWord | `0` | İleri | Windows | JavaScript çalıştırma |
| 108 | `GeminiSettings` | DWord | `1` | İleri | Windows | Gemini AI önerileri |
| 109 | `AIModeSettings` | DWord | `1` | İleri | Windows | Arama'da AI Modu |
| 110 | `AutofillPredictionSettings` | DWord | `2` | İleri | Windows | Otomatik doldurma tahminleri |
| 111 | `ChromeSuggestionsSettings` | DWord | `1` | İleri | Windows | Chrome önerileri |
| 112 | `CreateThemesSettings` | DWord | `2` | İleri | Windows | Tema oluşturma |
| 113 | `DevToolsGenAiSettings` | DWord | `2` | İleri | Windows | Geliştirici araçları AI asistanı |
| 114 | `HelpMeWriteSettings` | DWord | `2` | İleri | Windows | Yazmama Yardım Et |
| 115 | `HistorySearchSettings` | DWord | `2` | İleri | Windows | Geçmiş arama |
| 116 | `SearchContentSharingSettings` | DWord | `1` | İleri | Windows | Arama içeriği paylaşma |
| 117 | `SmartTabSharingSettings` | DWord | `1` | İleri | Windows | Akıllı sekme paylaşma |
| 118 | `TabCompareSettings` | DWord | `2` | İleri | Windows | Sekme karşılaştırma |
| 119 | `GeminiActOnWebSettings` | DWord | `1` | İleri | Windows | Gemini web işlemleri |
| 120 | `GeminiSparkSettings` | DWord | `1` | İleri | Windows | Gemini sayfa kıvılcımı |
| 121 | `RendererAppContainerEnabled` | DWord | `1` | İleri | Windows | İşleyici kum havuzu |
| 122 | `LocalNetworkAccessAllowedForUrls` | MultiString | `@()` | İleri | Windows | Yerel ağ izin listesi |
| 123 | `LocalNetworkAccessBlockedForUrls` | MultiString | `@()` | İleri | Windows | Yerel ağ engelleme listesi |
| 124 | `LocalNetworkAccessIpAddressSpaceOverrides` | MultiString | `@()` | İleri | Windows | Yerel ağ IP overrides |
| 125 | `LocalNetworkAccessRestrictionsTemporaryOptOut` | DWord | `0` | İleri | Windows | Yerel ağ çıkış seçeneği |
| 126 | `TranslateEnabled` | DWord | `0` | Katı | Windows | Google'a çeviri için metin |
| 127 | `DefaultClipboardSetting` | DWord | `2` | Katı | Windows | Pano okuma/yazma |
| 128 | `DefaultFileSystemReadGuardSetting` | DWord | `2` | Katı | Windows | Dosya sistemi okuma |
| 129 | `DefaultFileSystemWriteGuardSetting` | DWord | `2` | Katı | Windows | Dosya sistemi yazma |
| 130 | `DefaultInsecureContentSetting` | DWord | `2` | Katı | Windows | Karma içerik |
| 131 | `DefaultJavaScriptJitSetting` | DWord | `2` | Katı | Windows | JIT derleme |
| 132 | `DefaultCookiesSetting` | DWord | `2` | Katı | Windows | Tüm çerezler |
| 133 | `ImportBookmarks` | DWord | `0` | Katı | Windows | Tarayıcılar arası yer imleri |
| 134 | `DefaultBraveRemember1PStorageSetting` | DWord | `2` | Katı | Windows | Birinci taraf depolama |
| 135 | `IncognitoModeAvailability` | DWord | `1` | Katı | Windows | Gizli mod |
| 136 | `TaskManagerEndProcessEnabled` | DWord | `0` | Katı | Windows | Görev Yöneticisi |
| 137 | `PrintingEnabled` | DWord | `0` | Katı | Windows | Yazdırma işlevi |
| 138 | `DisablePrintPreview` | DWord | `1` | Katı | Windows | Yazdırma önizleme |
| 139 | `DownloadRestrictions` | DWord | `3` | Katı | Windows | Tüm indirmeleri engelle |
| 140 | `DeveloperToolsAvailability` | DWord | `2` | Katı | Windows | Geliştirici araçları |
| 141 | `BrowsingDataLifetime` | String | `{"data_types"=@(…);"time_to_live…"=24}` | Katı | Windows | Otomatik gezinti verisi temizleme |
| 142 | `AlwaysOpenPdfExternally` | DWord | `1` | Katı | Windows | Yerleşik PDF görüntüleyici |
| 143 | `CertificateTransparencyEnforcementDisabledForUrls` | MultiString | `@()` | Katı | Windows | Sertifika Saydamlığı |
| 144 | `PasswordLeakDetectionEnabled` | DWord | `1` | Katı | Windows | Parola sızıntısı algılama |
| 145 | `SpellCheckServiceEnabled` | DWord | `0` | Katı | Windows | Yazım denetimi ağ hizmeti |
| 146 | `SyncDisabled` | DWord | `1` | Katı | Windows | Brave Sync |
| 147 | `ScreenCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows | Ekran yakalama izin listesi |
| 148 | `SameOriginTabCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows | Aynı köken sekme yakalama |
| 149 | `TabCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows | Sekme yakalama izin listesi |
| 150 | `WindowCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows | Pencere yakalama izin listesi |
| 151 | `LocalNetworkAllowedForUrls` | MultiString | `@()` | Katı | Windows | Yerel ağ yakalama izin listesi |
| 152 | `LocalNetworkBlockedForUrls` | MultiString | `@()` | Katı | Windows | Yerel ağ yakalama engelleme listesi |

> **Not:** 139. satır (Katı `DownloadRestrictions`), 80. satırla (Dengeli) birleşir — yalnızca 1 benzersiz politika. Dengeli `1` (tehlikeli indirmelerde uyarı) uygular; Katı `3` (tüm indirmeleri engelle) ile ezdir. Bu nedenle 151 ham satır = 150 benzersiz politika.

---

## Katman Bazında Dağılım

### Brave Yalnız — 24 politika
Tüm Brave'e özgü özellikler devre dışı bırakıldı veya kısıtlandı. Güç kullanıcıları için sıfır kullanılabilirlik etkisi.

### Temel — 29 politika (+29 = 53 kümülatif)
Veri sızıntısı önleme. Kullanılabilirlik etkisi yok. Tüm Chromium/Brave telemetrisini, arka plan ağ iletişimini ve medya yakalamayı durdurur. USB/Bluetooth/HID cihaz erişimini engeller.

### Dengeli — 33 politika (+33 = 86 kümülatif)
Güvenlik ve kullanım dengesi. WebRTC sıkılaştırması, şifreli DNS, çerez engelleme, parola/otomatik doldurma devre dışı bırakma, izin varsayılanları, site izolasyonu, indirme kontrolleri, Dark Reader eklentisi.

### İleri — 38 politika (+38 = 124 kümülatif)
Genişletilmiş sıkılaştırma. Sensörler, yazı tipleri, seri bağlantı noktası, boşta algılama, misafir modu, tarayıcılar arası içe aktarmalar, eklenti kısıtlamaları, JavaScript varsayılanı kapalı, yapay zeka özellikleri devre dışı.

### Katı — 27 politika (+27 = 150 kümülatif)
Azami gizlilik. Çeviri, pano, dosya sistemi, JIT, çerezler, yazdırma, indirmeler, geliştirici araçları, bulut raporlama devre dışı. Gezinti verilerini her 24 saatte bir otomatik temizler.

---

## Tür Dağılımı

| Tür | Adet | Yüzde |
|-----|------|-------|
| DWord | 116 | %77,3 |
| String | 7 | %4,7 |
| MultiString | 17 | %11,3 |
| **Toplam (benzersiz)** | **150** | **%100** |

---

## Çakışma Kaydı

| Politika Adı | Görüldüğü Yerler | Çakışma |
|-------------|------------------|---------|
| `DownloadRestrictions` | Dengeli (`1`) → Katı (`3`) | Katı, Dengeli değerini ezdir |

---

## Hariç Tutulan Politikalar

| Politika Adı | Gerekçe |
|-------------|---------|
| `CloudPrintProxyEnabled` | `$allPolicyNames` listesinde (sıfırlama) mevcut ancak Chromium tarafından kullanımdan kaldırıldı; hiçbir katmana atanmamıştır |

---

## Platformlar Arası Kullanılabilirlik

| Platform | Betik | Notlar |
|----------|-------|--------|
| Windows | `BraveOmega-EN.ps1` / `BraveOmega-TR.ps1` | Birincil hedef: HKLM kayıt defteri + Omaha GUID |
| macOS | `BraveOmega-Mac-BraveOnly.sh` | Yalnızca Brave Yalnız katmanı, `defaults write` ile |
| Linux | `BraveOmega-Linux-BraveOnly.json` | Yalnızca Brave Yalnız katmanı, Chromium JSON politika dosyası |

24 Brave Yalnız politikasının tamamı macOS ve Linux'ta da uygulanır, ancak mekanizma farklıdır (CLI/JSON, kayıt defteri yerine). Temel/Dengeli/İleri/Katı katmanları yalnızca Windows'a özgüdür (HKLM+GUID bağımlılığı).
