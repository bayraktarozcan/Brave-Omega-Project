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

> **Generated from:** `BraveOmega-EN.ps1` v2.6.1.0 | `BraveOmega-TR.ps1` v2.6.1.0  
> **Date:** 2026-08-31  
> **Total unique policies:** 151 (no overlaps)  
> **Type distribution:** 124 DWord · 8 String · 19 MultiString  
> **Validated on:** Brave 1.94.117 / Chromium 152.0.7977.64 / Windows 11 26200

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
| 22 | `EmailAliasesEnabled` | DWord | `0` | BraveOnly | Windows·Mac·Linux | Anonymous email aliases |
| 23 | `SafeBrowsingProtectionLevel` | DWord | `2` | BraveOnly | Windows·Mac·Linux | Safe Browsing protection level |
| 24 | `PasswordProtectionWarningTrigger` | DWord | `3` | BraveOnly | Windows·Mac·Linux | Password leak warning trigger |
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
| 36 | `WebRtcEventLogCollectionAllowed` | DWord | `0` | Essential | Windows | WebRTC event logs to Google |
| 37 | `WebRtcTextLogCollectionAllowed` | DWord | `0` | Essential | Windows | WebRTC text logs to Google |
| 38 | `AudioCaptureAllowed` | DWord | `0` | Essential | Windows | Microphone access |
| 39 | `VideoCaptureAllowed` | DWord | `0` | Essential | Windows | Camera access |
| 40 | `BraveGlobalPrivacyControlEnabled` | DWord | `1` | Essential | Windows | GPC header |
| 41 | `DefaultWebUsbGuardSetting` | DWord | `2` | Essential | Windows | USB device access |
| 42 | `DefaultWebBluetoothGuardSetting` | DWord | `2` | Essential | Windows | Bluetooth device access |
| 43 | `DefaultWebHidGuardSetting` | DWord | `2` | Essential | Windows | HID device access |
| 44 | `EncryptedClientHelloEnabled` | DWord | `1` | Essential | Windows | TLS ClientHello encryption |
| 45 | `PaymentMethodQueryEnabled` | DWord | `0` | Essential | Windows | Payment method fingerprint |
| 46 | `SuppressDifferentOriginSubframeDialogs` | DWord | `1` | Essential | Windows | Cross-origin dialog abuse |
| 47 | `EnableOnlineRevocationChecks` | DWord | `1` | Essential | Windows | Certificate revocation checks |
| 48 | `ProxySettings` | String | `{"ProxyMode":"system"}` | Essential | Windows | Proxy configuration |
| 49 | `ExtensionInstallSources` | MultiString | `@()` | Essential | Windows | Extension install sources |
| 50 | `ScreenCaptureAllowed` | DWord | `0` | Essential | Windows | Screen capture API |
| 51 | `DownloadRestrictions` | DWord | `4` | Essential | Windows | Dangerous download warnings suppressed |
| 52 | `WebRtcIPHandling` | String | `disable_non_proxied_udp` | Balanced | Windows | WebRTC IP exposure |
| 53 | `WebRtcLocalIpsAllowedUrls` | MultiString | `@()` | Balanced | Windows | Local IP via ICE |
| 54 | `HttpsOnlyMode` | String | `force_enabled` | Balanced | Windows | HTTPS enforcement |
| 55 | `DnsOverHttpsMode` | String | `automatic` | Balanced | Windows | Encrypted DNS |
| 56 | `BlockThirdPartyCookies` | DWord | `1` | Balanced | Windows | Cross-site tracking |
| 57 | `PasswordManagerEnabled` | DWord | `0` | Balanced | Windows | Built-in password storage |
| 58 | `PasswordManagerPasskeysEnabled` | DWord | `0` | Balanced | Windows | Passkey storage |
| 59 | `AutofillAddressEnabled` | DWord | `0` | Balanced | Windows | Address form data |
| 60 | `AutofillCreditCardEnabled` | DWord | `0` | Balanced | Windows | Payment method data |
| 61 | `ShowFullUrlsInAddressBar` | DWord | `1` | Balanced | Windows | Anti-phishing URL display |
| 62 | `QuicAllowed` | DWord | `0` | Balanced | Windows | QUIC protocol |
| 63 | `ChromeVariations` | DWord | `1` | Balanced | Windows | Critical field trials only |
| 64 | `NetworkServiceSandboxEnabled` | DWord | `1` | Balanced | Windows | Network sandbox |
| 65 | `AudioSandboxEnabled` | DWord | `1` | Balanced | Windows | Audio sandbox |
| 66 | `DefaultGeolocationSetting` | DWord | `2` | Balanced | Windows | Device location access |
| 67 | `DefaultNotificationsSetting` | DWord | `2` | Balanced | Windows | Notification prompts |
| 68 | `DefaultPopupsSetting` | DWord | `2` | Balanced | Windows | Pop-up windows |
| 69 | `DefaultBraveHttpsUpgradeSetting` | DWord | `2` | Balanced | Windows | Brave HTTPS upgrade |
| 70 | `DefaultBraveReferrersSetting` | DWord | `2` | Balanced | Windows | Brave referrer cap |
| 71 | `BraveSyncUrl` | String | `https://sync-v2.brave.com/v2` | Balanced | Windows | Sync server URL |
| 72 | `DefaultWindowManagementSetting` | DWord | `2` | Balanced | Windows | Window management permission |
| 73 | `SitePerProcess` | DWord | `1` | Balanced | Windows | Site isolation |
| 74 | `IntensiveWakeUpThrottlingEnabled` | DWord | `1` | Balanced | Windows | Background timer throttling |
| 75 | `UserFeedbackAllowed` | DWord | `0` | Balanced | Windows | User feedback prompts |
| 76 | `ExtensionInstallForcelist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh;…, maafgiompdekodanheihhgilkjchcakm;https://outlook.office.com/owa/SmimeCrxUpdate.ashx` | Balanced | Windows | Force-installed extension |
| 77 | `DownloadDirectory` | String | `${env:USERPROFILE}\Downloads\` | Balanced | Windows | Download path |
| 78 | `PromptForDownloadLocation` | DWord | `0` | Balanced | Windows | Download location prompt |
| 79 | `RelaunchNotification` | DWord | `2` | Balanced | Windows | Browser relaunch notification |
| 80 | `RelaunchNotificationPeriod` | DWord | `3600000` | Balanced | Windows | Relaunch timer (1 hour) |
| 81 | `LocalNetworkAccessPermissionsPolicyDefaultEnabled` | DWord | `0` | Balanced | Windows | Local network permission default |
| 82 | `GenAILocalFoundationalModelSettings` | DWord | `1` | Balanced | Windows | On-device AI model |
| 83 | `DisableSafeBrowsingProceedAnyway` | DWord | `1` | Balanced | Windows | Malware warning bypass |
| 84 | `DefaultSensorsSetting` | DWord | `2` | Advanced | Windows | Device motion/light sensors |
| 85 | `DefaultLocalFontsSetting` | DWord | `2` | Advanced | Windows | Font fingerprinting |
| 86 | `DefaultSerialGuardSetting` | DWord | `2` | Advanced | Windows | Serial API access |
| 87 | `DefaultIdleDetectionSetting` | DWord | `2` | Advanced | Windows | Idle state detection |
| 88 | `BrowserGuestModeEnabled` | DWord | `0` | Advanced | Windows | Guest profile |
| 89 | `BrowserAddPersonEnabled` | DWord | `0` | Advanced | Windows | New profile creation |
| 90 | `ImportAutofillFormData` | DWord | `0` | Advanced | Windows | Cross-browser autofill |
| 91 | `ImportHistory` | DWord | `0` | Advanced | Windows | Cross-browser history |
| 92 | `ImportSavedPasswords` | DWord | `0` | Advanced | Windows | Cross-browser passwords |
| 93 | `ImportSearchEngine` | DWord | `0` | Advanced | Windows | Cross-browser search engine |
| 94 | `ImportHomepage` | DWord | `0` | Advanced | Windows | Cross-browser homepage |
| 95 | `ExtensionInstallBlocklist` | MultiString | `*` | Advanced | Windows | Extension blocklist |
| 96 | `ExtensionInstallAllowlist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh, maafgiompdekodanheihhgilkjchcakm` | Advanced | Windows | Extension allowlist |
| 97 | `ExtensionAllowedTypes` | MultiString | `extension, shared_module` | Advanced | Windows | Allowed extension types |
| 98 | `BlockExternalExtensions` | DWord | `1` | Advanced | Windows | External extension install |
| 99 | `ExtensionSettings` | String | `{"*":{"installation_mode":"blocked"},…,"maafgiompdekodanheihhgilkjchcakm":{"installation_mode":"allowed","override_update_url":true}}` | Advanced | Windows | Extension policy matrix |
| 100 | `NativeMessagingAllowlist` | MultiString | `com.microsoft.outlook.smime.chromenativeapp` | Advanced | Windows | Native messaging host allowlist |
| 101 | `NativeMessagingUserLevelHosts` | DWord | `1` | Advanced | Windows | User-level native messaging hosts |
| 102 | `BuiltInDnsClientEnabled` | DWord | `0` | Advanced | Windows | Built-in DNS client |
| 103 | `ShowHomeButton` | DWord | `0` | Advanced | Windows | Home button visibility |
| 104 | `HideWebStoreIcon` | DWord | `1` | Advanced | Windows | Web Store icon |
| 105 | `DefaultJavaScriptSetting` | DWord | `0` | Advanced | Windows | JavaScript execution |
| 106 | `GeminiSettings` | DWord | `1` | Advanced | Windows | Gemini AI suggestions |
| 107 | `AIModeSettings` | DWord | `1` | Advanced | Windows | AI Mode in Search |
| 108 | `AutofillPredictionSettings` | DWord | `2` | Advanced | Windows | Autofill predictions |
| 109 | `ChromeSuggestionsSettings` | DWord | `1` | Advanced | Windows | Chrome suggestions |
| 110 | `CreateThemesSettings` | DWord | `2` | Advanced | Windows | Theme creation |
| 111 | `DevToolsGenAiSettings` | DWord | `2` | Advanced | Windows | DevTools AI assistant |
| 112 | `HelpMeWriteSettings` | DWord | `2` | Advanced | Windows | Help Me Write |
| 113 | `HistorySearchSettings` | DWord | `2` | Advanced | Windows | History search |
| 114 | `SearchContentSharingSettings` | DWord | `1` | Advanced | Windows | Search content sharing |
| 115 | `SmartTabSharingSettings` | DWord | `1` | Advanced | Windows | Smart tab sharing |
| 116 | `TabCompareSettings` | DWord | `2` | Advanced | Windows | Tab comparison |
| 117 | `GeminiActOnWebSettings` | DWord | `1` | Advanced | Windows | Gemini web actions |
| 118 | `GeminiSparkSettings` | DWord | `1` | Advanced | Windows | Gemini page spark |
| 119 | `RendererAppContainerEnabled` | DWord | `1` | Advanced | Windows | Renderer sandbox |
| 120 | `LocalNetworkAccessAllowedForUrls` | MultiString | `@()` | Advanced | Windows | Local network allowlist |
| 121 | `LocalNetworkAccessBlockedForUrls` | MultiString | `@()` | Advanced | Windows | Local network blocklist |
| 122 | `LocalNetworkAccessIpAddressSpaceOverrides` | MultiString | `@()` | Advanced | Windows | Local network IP overrides |
| 123 | `LocalNetworkAccessRestrictionsTemporaryOptOut` | DWord | `0` | Advanced | Windows | Local network opt-out |
| 124 | `TranslateEnabled` | DWord | `0` | Strict | Windows | Text to Google for translation |
| 125 | `DefaultClipboardSetting` | DWord | `2` | Strict | Windows | Clipboard read/write |
| 126 | `DefaultFileSystemReadGuardSetting` | DWord | `2` | Strict | Windows | File system read |
| 127 | `DefaultFileSystemWriteGuardSetting` | DWord | `2` | Strict | Windows | File system write |
| 128 | `DefaultInsecureContentSetting` | DWord | `2` | Strict | Windows | Mixed content |
| 129 | `DefaultJavaScriptJitSetting` | DWord | `2` | Strict | Windows | JIT compilation |
| 130 | `DefaultCookiesSetting` | DWord | `2` | Strict | Windows | All cookies |
| 131 | `ImportBookmarks` | DWord | `0` | Strict | Windows | Cross-browser bookmarks |
| 132 | `DefaultBraveRemember1PStorageSetting` | DWord | `2` | Strict | Windows | First-party storage |
| 133 | `IncognitoModeAvailability` | DWord | `1` | Strict | Windows | Incognito mode |
| 134 | `TaskManagerEndProcessEnabled` | DWord | `0` | Strict | Windows | Task Manager |
| 135 | `PrintingEnabled` | DWord | `0` | Strict | Windows | Print function |
| 136 | `DisablePrintPreview` | DWord | `1` | Strict | Windows | Print preview |
| 137 | `SafeBrowsingDeepScanningEnabled` | DWord | `0` | Strict | Windows | Server-side download scan |
| 138 | `DeveloperToolsAvailability` | DWord | `2` | Strict | Windows | Developer Tools |
| 139 | `BrowsingDataLifetime` | String | `{"data_types"=@(…);"time_to_live…"=24}` | Strict | Windows | Auto-clear browsing data |
| 140 | `AlwaysOpenPdfExternally` | DWord | `1` | Strict | Windows | Built-in PDF viewer |
| 141 | `CertificateTransparencyEnforcementDisabledForUrls` | MultiString | `@()` | Strict | Windows | Certificate Transparency |
| 142 | `PasswordLeakDetectionEnabled` | DWord | `1` | Strict | Windows | Password leak detection |
| 143 | `SpellCheckServiceEnabled` | DWord | `0` | Strict | Windows | Spell check network service |
| 144 | `BrowserSignin` | DWord | `0` | Strict | Windows | Chrome sign-in prompt |
| 145 | `SyncDisabled` | DWord | `1` | Strict | Windows | Brave Sync |
| 146 | `ScreenCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows | Screen capture allowlist |
| 147 | `SameOriginTabCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows | Same-origin tab capture |
| 148 | `TabCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows | Tab capture allowlist |
| 149 | `WindowCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows | Window capture allowlist |
| 150 | `LocalNetworkAllowedForUrls` | MultiString | `@()` | Strict | Windows | Local network capture allowlist |
| 151 | `LocalNetworkBlockedForUrls` | MultiString | `@()` | Strict | Windows | Local network capture blocklist |

---

## Tier Breakdown

### BraveOnly — 24 policies
All Brave-specific features disabled or restricted. Zero usability impact for power users.

### Essential — 27 policies (+27 = 51 cumulative)
Data leak prevention. No usability impact. Stops all Chromium/Brave telemetry, background networking, and media capture. Blocks USB/Bluetooth/HID device access.

### Balanced — 32 policies (+32 = 83 cumulative)
Security & convenience balance. WebRTC hardening, encrypted DNS, cookie blocking, password/autofill disable, permission defaults, site isolation, download controls, Dark Reader extension.

### Advanced — 40 policies (+40 = 123 cumulative)
Extended hardening. Disables sensors, fonts, serial, idle detection, guest mode, cross-browser imports, extension restrictions, JavaScript default off, AI features disabled.

### Strict — 28 policies (+28 = 151 cumulative)
Maximum privacy. Disables translation, clipboard, file system, JIT, cookies, printing, downloads, developer tools, cloud reporting. Auto-clears browsing data every 24 hours.

---

## Type Distribution

| Type | Count | Percentage |
|------|-------|------------|
| DWord | 124 | 82.1% |
| String | 8 | 5.3% |
| MultiString | 19 | 12.6% |
| **Total (unique)** | **151** | **100%** |

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

> **Kaynak:** `BraveOmega-EN.ps1` v2.6.1.0 | `BraveOmega-TR.ps1` v2.6.1.0  
> **Tarih:** 2026-08-31  
> **Toplam benzersiz politika:** 151 (çakışma yok)  
> **Tür dağılımı:** 124 DWord · 8 String · 19 MultiString  
> **Doğrulandı:** Brave 1.94.117 / Chromium 152.0.7977.64 / Windows 11 26200

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
| 22 | `EmailAliasesEnabled` | DWord | `0` | Brave Yalnız | Windows·Mac·Linux | Anonim e-posta takma adları |
| 23 | `SafeBrowsingProtectionLevel` | DWord | `2` | Brave Yalnız | Windows·Mac·Linux | Safe Browsing koruma düzeyi |
| 24 | `PasswordProtectionWarningTrigger` | DWord | `3` | Brave Yalnız | Windows·Mac·Linux | Parola sızıntısı uyarı tetikleyici |
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
| 36 | `WebRtcEventLogCollectionAllowed` | DWord | `0` | Temel | Windows | WebRTC olay günlükleri Google'a |
| 37 | `WebRtcTextLogCollectionAllowed` | DWord | `0` | Temel | Windows | WebRTC metin günlükleri Google'a |
| 38 | `AudioCaptureAllowed` | DWord | `0` | Temel | Windows | Mikrofon erişimi |
| 39 | `VideoCaptureAllowed` | DWord | `0` | Temel | Windows | Kamera erişimi |
| 40 | `BraveGlobalPrivacyControlEnabled` | DWord | `1` | Temel | Windows | GPC başlığı |
| 41 | `DefaultWebUsbGuardSetting` | DWord | `2` | Temel | Windows | USB cihaz erişimi |
| 42 | `DefaultWebBluetoothGuardSetting` | DWord | `2` | Temel | Windows | Bluetooth cihaz erişimi |
| 43 | `DefaultWebHidGuardSetting` | DWord | `2` | Temel | Windows | HID cihaz erişimi |
| 44 | `EncryptedClientHelloEnabled` | DWord | `1` | Temel | Windows | TLS ClientHello şifreleme |
| 45 | `PaymentMethodQueryEnabled` | DWord | `0` | Temel | Windows | Ödeme yöntemi parmak izi |
| 46 | `SuppressDifferentOriginSubframeDialogs` | DWord | `1` | Temel | Windows | Farklı köken alt çerçeve diyalogları |
| 47 | `EnableOnlineRevocationChecks` | DWord | `1` | Temel | Windows | Sertifika iptal kontrolleri |
| 48 | `ProxySettings` | String | `{"ProxyMode":"system"}` | Temel | Windows | Vekil sunucu yapılandırması |
| 49 | `ExtensionInstallSources` | MultiString | `@()` | Temel | Windows | Eklenti yükleme kaynakları |
| 50 | `ScreenCaptureAllowed` | DWord | `0` | Temel | Windows | Ekran yakalama API'si |
| 51 | `DownloadRestrictions` | DWord | `4` | Temel | Windows | Tehlikeli indirme uyarıları bastırılır |
| 52 | `WebRtcIPHandling` | String | `disable_non_proxied_udp` | Dengeli | Windows | WebRTC IP ifşası |
| 53 | `WebRtcLocalIpsAllowedUrls` | MultiString | `@()` | Dengeli | Windows | ICE yoluyla yerel IP |
| 54 | `HttpsOnlyMode` | String | `force_enabled` | Dengeli | Windows | HTTPS zorlaması |
| 55 | `DnsOverHttpsMode` | String | `automatic` | Dengeli | Windows | Şifreli DNS |
| 56 | `BlockThirdPartyCookies` | DWord | `1` | Dengeli | Windows | Siteler arası izleme |
| 57 | `PasswordManagerEnabled` | DWord | `0` | Dengeli | Windows | Yerleşik parola depolama |
| 58 | `PasswordManagerPasskeysEnabled` | DWord | `0` | Dengeli | Windows | Passkey depolama |
| 59 | `AutofillAddressEnabled` | DWord | `0` | Dengeli | Windows | Adres form verileri |
| 60 | `AutofillCreditCardEnabled` | DWord | `0` | Dengeli | Windows | Ödeme yöntemi verileri |
| 61 | `ShowFullUrlsInAddressBar` | DWord | `1` | Dengeli | Windows | Oltalama önleme URL gösterimi |
| 62 | `QuicAllowed` | DWord | `0` | Dengeli | Windows | QUIC protokolü |
| 63 | `ChromeVariations` | DWord | `1` | Dengeli | Windows | Yalnızca kritik alan denemeleri |
| 64 | `NetworkServiceSandboxEnabled` | DWord | `1` | Dengeli | Windows | Ağ kum havuzu |
| 65 | `AudioSandboxEnabled` | DWord | `1` | Dengeli | Windows | Ses kum havuzu |
| 66 | `DefaultGeolocationSetting` | DWord | `2` | Dengeli | Windows | Cihaz konumu erişimi |
| 67 | `DefaultNotificationsSetting` | DWord | `2` | Dengeli | Windows | Bildirim istemleri |
| 68 | `DefaultPopupsSetting` | DWord | `2` | Dengeli | Windows | Açılır pencereler |
| 69 | `DefaultBraveHttpsUpgradeSetting` | DWord | `2` | Dengeli | Windows | Brave HTTPS yükseltme |
| 70 | `DefaultBraveReferrersSetting` | DWord | `2` | Dengeli | Windows | Brave yönlendiren sınırı |
| 71 | `BraveSyncUrl` | String | `https://sync-v2.brave.com/v2` | Dengeli | Windows | Senkronizasyon sunucu URL'si |
| 72 | `DefaultWindowManagementSetting` | DWord | `2` | Dengeli | Windows | Pencere yönetimi izni |
| 73 | `SitePerProcess` | DWord | `1` | Dengeli | Windows | Site izolasyonu |
| 74 | `IntensiveWakeUpThrottlingEnabled` | DWord | `1` | Dengeli | Windows | Arka plan zamanlayıcı kısıtlaması |
| 75 | `UserFeedbackAllowed` | DWord | `0` | Dengeli | Windows | Kullanıcı geri bildirim istemleri |
| 76 | `ExtensionInstallForcelist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh;…, maafgiompdekodanheihhgilkjchcakm;https://outlook.office.com/owa/SmimeCrxUpdate.ashx` | Dengeli | Windows | Zorunlu eklenti |
| 77 | `DownloadDirectory` | String | `${env:USERPROFILE}\Downloads\` | Dengeli | Windows | İndirme yolu |
| 78 | `PromptForDownloadLocation` | DWord | `0` | Dengeli | Windows | İndirme konumu istemi |
| 79 | `RelaunchNotification` | DWord | `2` | Dengeli | Windows | Tarayıcı yeniden başlatma bildirimi |
| 80 | `RelaunchNotificationPeriod` | DWord | `3600000` | Dengeli | Windows | Yeniden başlatma zamanlayıcı (1 saat) |
| 81 | `LocalNetworkAccessPermissionsPolicyDefaultEnabled` | DWord | `0` | Dengeli | Windows | Yerel ağ izin varsayılanı |
| 82 | `GenAILocalFoundationalModelSettings` | DWord | `1` | Dengeli | Windows | Cihaz içi yapay zeka modeli |
| 83 | `DisableSafeBrowsingProceedAnyway` | DWord | `1` | Dengeli | Windows | Kötü amaçlı yazılım uyarı atlama |
| 84 | `DefaultSensorsSetting` | DWord | `2` | İleri | Windows | Hareket/ışık sensörleri |
| 85 | `DefaultLocalFontsSetting` | DWord | `2` | İleri | Windows | Yazı tipi parmak izi |
| 86 | `DefaultSerialGuardSetting` | DWord | `2` | İleri | Windows | Serial API erişimi |
| 87 | `DefaultIdleDetectionSetting` | DWord | `2` | İleri | Windows | Boşta algılama |
| 88 | `BrowserGuestModeEnabled` | DWord | `0` | İleri | Windows | Misafir profili |
| 89 | `BrowserAddPersonEnabled` | DWord | `0` | İleri | Windows | Yeni profil oluşturma |
| 90 | `ImportAutofillFormData` | DWord | `0` | İleri | Windows | Tarayıcılar arası otomatik doldurma |
| 91 | `ImportHistory` | DWord | `0` | İleri | Windows | Tarayıcılar arası geçmiş |
| 92 | `ImportSavedPasswords` | DWord | `0` | İleri | Windows | Tarayıcılar arası parolalar |
| 93 | `ImportSearchEngine` | DWord | `0` | İleri | Windows | Tarayıcılar arası arama motoru |
| 94 | `ImportHomepage` | DWord | `0` | İleri | Windows | Tarayıcılar arası ana sayfa |
| 95 | `ExtensionInstallBlocklist` | MultiString | `*` | İleri | Windows | Eklenti engelleme listesi |
| 96 | `ExtensionInstallAllowlist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh, maafgiompdekodanheihhgilkjchcakm` | İleri | Windows | Eklenti izin listesi |
| 97 | `ExtensionAllowedTypes` | MultiString | `extension, shared_module` | İleri | Windows | İzin verilen eklenti türleri |
| 98 | `BlockExternalExtensions` | DWord | `1` | İleri | Windows | Harici eklenti yükleme |
| 99 | `ExtensionSettings` | String | `{"*":{"installation_mode":"blocked"},…,"maafgiompdekodanheihhgilkjchcakm":{"installation_mode":"allowed","override_update_url":true}}` | İleri | Windows | Eklenti politika matrisi |
| 100 | `NativeMessagingAllowlist` | MultiString | `com.microsoft.outlook.smime.chromenativeapp` | İleri | Windows | S/MIME yerel mesajlaşma ana bilgisayarı |
| 101 | `NativeMessagingUserLevelHosts` | DWord | `1` | İleri | Windows | Kullanıcı düzeyi yerel mesajlaşma ana bilgisayarları |
| 102 | `BuiltInDnsClientEnabled` | DWord | `0` | İleri | Windows | Yerleşik DNS istemcisi |
| 103 | `ShowHomeButton` | DWord | `0` | İleri | Windows | Ana sayfa düğmesi görünürlüğü |
| 104 | `HideWebStoreIcon` | DWord | `1` | İleri | Windows | Web Mağazası simgesi |
| 105 | `DefaultJavaScriptSetting` | DWord | `0` | İleri | Windows | JavaScript çalıştırma |
| 106 | `GeminiSettings` | DWord | `1` | İleri | Windows | Gemini AI önerileri |
| 107 | `AIModeSettings` | DWord | `1` | İleri | Windows | Arama'da AI Modu |
| 108 | `AutofillPredictionSettings` | DWord | `2` | İleri | Windows | Otomatik doldurma tahminleri |
| 109 | `ChromeSuggestionsSettings` | DWord | `1` | İleri | Windows | Chrome önerileri |
| 110 | `CreateThemesSettings` | DWord | `2` | İleri | Windows | Tema oluşturma |
| 111 | `DevToolsGenAiSettings` | DWord | `2` | İleri | Windows | Geliştirici araçları AI asistanı |
| 112 | `HelpMeWriteSettings` | DWord | `2` | İleri | Windows | Yazmaya Yardım Et |
| 113 | `HistorySearchSettings` | DWord | `2` | İleri | Windows | Geçmiş arama |
| 114 | `SearchContentSharingSettings` | DWord | `1` | İleri | Windows | Arama içeriği paylaşma |
| 115 | `SmartTabSharingSettings` | DWord | `1` | İleri | Windows | Akıllı sekme paylaşma |
| 116 | `TabCompareSettings` | DWord | `2` | İleri | Windows | Sekme karşılaştırma |
| 117 | `GeminiActOnWebSettings` | DWord | `1` | İleri | Windows | Gemini web işlemleri |
| 118 | `GeminiSparkSettings` | DWord | `1` | İleri | Windows | Gemini sayfa kıvılcımı |
| 119 | `RendererAppContainerEnabled` | DWord | `1` | İleri | Windows | İşleyici kum havuzu |
| 120 | `LocalNetworkAccessAllowedForUrls` | MultiString | `@()` | İleri | Windows | Yerel ağ izin listesi |
| 121 | `LocalNetworkAccessBlockedForUrls` | MultiString | `@()` | İleri | Windows | Yerel ağ engelleme listesi |
| 122 | `LocalNetworkAccessIpAddressSpaceOverrides` | MultiString | `@()` | İleri | Windows | Yerel ağ IP overrides |
| 123 | `LocalNetworkAccessRestrictionsTemporaryOptOut` | DWord | `0` | İleri | Windows | Yerel ağ çıkış seçeneği |
| 124 | `TranslateEnabled` | DWord | `0` | Katı | Windows | Google'a çeviri için metin |
| 125 | `DefaultClipboardSetting` | DWord | `2` | Katı | Windows | Pano okuma/yazma |
| 126 | `DefaultFileSystemReadGuardSetting` | DWord | `2` | Katı | Windows | Dosya sistemi okuma |
| 127 | `DefaultFileSystemWriteGuardSetting` | DWord | `2` | Katı | Windows | Dosya sistemi yazma |
| 128 | `DefaultInsecureContentSetting` | DWord | `2` | Katı | Windows | Karma içerik |
| 129 | `DefaultJavaScriptJitSetting` | DWord | `2` | Katı | Windows | JIT derleme |
| 130 | `DefaultCookiesSetting` | DWord | `2` | Katı | Windows | Tüm çerezler |
| 131 | `ImportBookmarks` | DWord | `0` | Katı | Windows | Tarayıcılar arası yer imleri |
| 132 | `DefaultBraveRemember1PStorageSetting` | DWord | `2` | Katı | Windows | Birinci taraf depolama |
| 133 | `IncognitoModeAvailability` | DWord | `1` | Katı | Windows | Gizli mod |
| 134 | `TaskManagerEndProcessEnabled` | DWord | `0` | Katı | Windows | Görev Yöneticisi |
| 135 | `PrintingEnabled` | DWord | `0` | Katı | Windows | Yazdırma işlevi |
| 136 | `DisablePrintPreview` | DWord | `1` | Katı | Windows | Yazdırma önizleme |
| 137 | `SafeBrowsingDeepScanningEnabled` | DWord | `0` | Katı | Windows | Sunucu tarafı indirme taraması |
| 138 | `DeveloperToolsAvailability` | DWord | `2` | Katı | Windows | Geliştirici araçları |
| 139 | `BrowsingDataLifetime` | String | `{"data_types"=@(…);"time_to_live…"=24}` | Katı | Windows | Otomatik gezinti verisi temizleme |
| 140 | `AlwaysOpenPdfExternally` | DWord | `1` | Katı | Windows | Yerleşik PDF görüntüleyici |
| 141 | `CertificateTransparencyEnforcementDisabledForUrls` | MultiString | `@()` | Katı | Windows | Sertifika Saydamlığı |
| 142 | `PasswordLeakDetectionEnabled` | DWord | `1` | Katı | Windows | Parola sızıntısı algılama |
| 143 | `SpellCheckServiceEnabled` | DWord | `0` | Katı | Windows | Yazım denetimi ağ hizmeti |
| 144 | `BrowserSignin` | DWord | `0` | Katı | Windows | Chrome giriş istemi |
| 145 | `SyncDisabled` | DWord | `1` | Katı | Windows | Brave Sync |
| 146 | `ScreenCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows | Ekran yakalama izin listesi |
| 147 | `SameOriginTabCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows | Aynı köken sekme yakalama |
| 148 | `TabCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows | Sekme yakalama izin listesi |
| 149 | `WindowCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows | Pencere yakalama izin listesi |
| 150 | `LocalNetworkAllowedForUrls` | MultiString | `@()` | Katı | Windows | Yerel ağ yakalama izin listesi |
| 151 | `LocalNetworkBlockedForUrls` | MultiString | `@()` | Katı | Windows | Yerel ağ yakalama engelleme listesi |

---

## Katman Bazında Dağılım

### Brave Yalnız — 24 politika
Tüm Brave'e özgü özellikler devre dışı bırakıldı veya kısıtlandı. Güç kullanıcıları için sıfır kullanılabilirlik etkisi.

### Temel — 27 politika (+27 = 51 kümülatif)
Veri sızıntısı önleme. Kullanılabilirlik etkisi yok. Tüm Chromium/Brave telemetrisini, arka plan ağ iletişimini ve medya yakalamayı durdurur. USB/Bluetooth/HID cihaz erişimini engeller.

### Dengeli — 32 politika (+32 = 83 kümülatif)
Güvenlik ve kullanım dengesi. WebRTC sıkılaştırması, şifreli DNS, çerez engelleme, parola/otomatik doldurma devre dışı bırakma, izin varsayılanları, site izolasyonu, indirme kontrolleri, Dark Reader eklentisi.

### İleri — 40 politika (+40 = 123 kümülatif)
Genişletilmiş sıkılaştırma. Sensörler, yazı tipleri, seri bağlantı noktası, boşta algılama, misafir modu, tarayıcılar arası içe aktarmalar, eklenti kısıtlamaları, JavaScript varsayılanı kapalı, yapay zeka özellikleri devre dışı.

### Katı — 28 politika (+28 = 151 kümülatif)
Azami gizlilik. Çeviri, pano, dosya sistemi, JIT, çerezler, yazdırma, indirmeler, geliştirici araçları, bulut raporlama devre dışı. Gezinti verilerini her 24 saatte bir otomatik temizler.

---

## Tür Dağılımı

| Tür | Adet | Yüzde |
|-----|------|-------|
| DWord | 124 | %82,1 |
| String | 8 | %5,3 |
| MultiString | 19 | %12,6 |
| **Toplam (benzersiz)** | **151** | **%100** |

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
