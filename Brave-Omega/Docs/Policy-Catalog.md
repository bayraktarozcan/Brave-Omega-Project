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

> **Source:** `BraveOmega.ps1` v3.1.0.1 (bilingual EN/TR)\
> **Date:** 2026-10-22\
> **Total unique policies:** 149 (no overlaps)\
> **Type distribution:** 121 DWord · 8 String · 19 MultiString · 1 ExpandString\
> **Validated on:** V3 version-agnostic — all Brave + Chromium versions (no pinned validation target)

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
| 26 | `UrlKeyedAnonymizedDataCollectionEnabled` | DWord | `0` | Essential | Windows | Visited URLs to Google |
| 27 | `SearchSuggestEnabled` | DWord | `0` | Essential | Windows | Keystroke data leak |
| 28 | `NetworkPredictionOptions` | DWord | `2` | Essential | Windows | DNS prefetch / pre-connect |
| 29 | `SpellcheckEnabled` | DWord | `1` | Essential | Windows | Spellcheck (local engine) |
| 30 | `AlternateErrorPagesEnabled` | DWord | `0` | Essential | Windows | DNS failure network requests |
| 31 | `BrowserNetworkTimeQueriesEnabled` | DWord | `0` | Essential | Windows | Time sync to Google |
| 32 | `DomainReliabilityAllowed` | DWord | `0` | Essential | Windows | Diagnostic data to Google |
| 33 | `BackgroundModeEnabled` | DWord | `0` | Essential | Windows | Background process tracking |
| 34 | `SafeBrowsingSurveysEnabled` | DWord | `0` | Essential | Windows | Post-browsing surveys |
| 35 | `WebRtcEventLogCollectionAllowed` | DWord | `0` | Essential | Windows | WebRTC event logs to Google |
| 36 | `WebRtcTextLogCollectionAllowed` | DWord | `0` | Essential | Windows | WebRTC text logs to Google |
| 37 | `AudioCaptureAllowed` | DWord | `0` | Essential | Windows | Microphone access |
| 38 | `VideoCaptureAllowed` | DWord | `0` | Essential | Windows | Camera access |
| 39 | `BraveGlobalPrivacyControlEnabled` | DWord | `1` | Essential | Windows | GPC header |
| 40 | `DefaultWebUsbGuardSetting` | DWord | `2` | Essential | Windows | USB device access |
| 41 | `DefaultWebBluetoothGuardSetting` | DWord | `2` | Essential | Windows | Bluetooth device access |
| 42 | `DefaultWebHidGuardSetting` | DWord | `2` | Essential | Windows | HID device access |
| 43 | `EncryptedClientHelloEnabled` | DWord | `1` | Essential | Windows | TLS ClientHello encryption |
| 44 | `PaymentMethodQueryEnabled` | DWord | `0` | Essential | Windows | Payment method fingerprint |
| 45 | `SuppressDifferentOriginSubframeDialogs` | DWord | `1` | Essential | Windows | Cross-origin dialog abuse |
| 46 | `EnableOnlineRevocationChecks` | DWord | `1` | Essential | Windows | Certificate revocation checks |
| 47 | `ProxySettings` | String | `{"ProxyMode":"system"}` | Essential | Windows | Proxy configuration |
| 48 | `ExtensionInstallSources` | MultiString | `@()` | Essential | Windows | Extension install sources |
| 49 | `ScreenCaptureAllowed` | DWord | `0` | Essential | Windows | Screen capture API |
| 50 | `DownloadRestrictions` | DWord | `4` | Essential | Windows | Dangerous download warnings suppressed |
| 51 | `WebRtcIPHandling` | String | `disable_non_proxied_udp` | Balanced | Windows | WebRTC IP exposure |
| 52 | `WebRtcLocalIpsAllowedUrls` | MultiString | `@()` | Balanced | Windows | Local IP via ICE |
| 53 | `HttpsOnlyMode` | String | `force_enabled` | Balanced | Windows | HTTPS enforcement |
| 54 | `DnsOverHttpsMode` | String | `automatic` | Balanced | Windows | Encrypted DNS |
| 55 | `BlockThirdPartyCookies` | DWord | `1` | Balanced | Windows | Cross-site tracking |
| 56 | `PasswordManagerEnabled` | DWord | `0` | Balanced | Windows | Built-in password storage |
| 57 | `PasswordManagerPasskeysEnabled` | DWord | `0` | Balanced | Windows | Passkey storage |
| 58 | `AutofillSettings` | String | `[{"url_pattern":"*","blocked_types":["all"]}]` | Balanced | Windows | Blocks all autofill data types |
| 59 | `ShowFullUrlsInAddressBar` | DWord | `1` | Balanced | Windows | Anti-phishing URL display |
| 60 | `QuicAllowed` | DWord | `0` | Balanced | Windows | QUIC protocol |
| 61 | `ChromeVariations` | DWord | `1` | Balanced | Windows | Critical field trials only |
| 62 | `NetworkServiceSandboxEnabled` | DWord | `1` | Balanced | Windows | Network sandbox |
| 63 | `AudioSandboxEnabled` | DWord | `1` | Balanced | Windows | Audio sandbox |
| 64 | `DefaultGeolocationSetting` | DWord | `2` | Balanced | Windows | Device location access |
| 65 | `DefaultNotificationsSetting` | DWord | `2` | Balanced | Windows | Notification prompts |
| 66 | `DefaultPopupsSetting` | DWord | `2` | Balanced | Windows | Pop-up windows |
| 67 | `DefaultBraveHttpsUpgradeSetting` | DWord | `2` | Balanced | Windows | Brave HTTPS upgrade |
| 68 | `DefaultBraveReferrersSetting` | DWord | `2` | Balanced | Windows | Brave referrer cap |
| 69 | `BraveSyncUrl` | String | `https://sync-v2.brave.com/v2` | Balanced | Windows | Sync server URL |
| 70 | `DefaultWindowManagementSetting` | DWord | `2` | Balanced | Windows | Window management permission |
| 71 | `SitePerProcess` | DWord | `1` | Balanced | Windows | Site isolation |
| 72 | `IntensiveWakeUpThrottlingEnabled` | DWord | `1` | Balanced | Windows | Background timer throttling |
| 73 | `UserFeedbackAllowed` | DWord | `0` | Balanced | Windows | User feedback prompts |
| 74 | `ExtensionInstallForcelist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh;…, maafgiompdekodanheihhgilkjchcakm;https://outlook.office.com/owa/SmimeCrxUpdate.ashx` | Balanced | Windows | Force-installed extension |
| 75 | `DownloadDirectory` | ExpandString | `${env:USERPROFILE}\Downloads\` | Balanced | Windows | Download path |
| 76 | `PromptForDownloadLocation` | DWord | `0` | Balanced | Windows | Download location prompt |
| 77 | `RelaunchNotification` | DWord | `2` | Balanced | Windows | Browser relaunch notification |
| 78 | `RelaunchNotificationPeriod` | DWord | `3600000` | Balanced | Windows | Relaunch timer (1 hour) |
| 79 | `LocalNetworkAccessPermissionsPolicyDefaultEnabled` | DWord | `0` | Balanced | Windows | Local network permission default |
| 80 | `GenAILocalFoundationalModelSettings` | DWord | `1` | Balanced | Windows | On-device AI model |
| 81 | `DisableSafeBrowsingProceedAnyway` | DWord | `1` | Balanced | Windows | Malware warning bypass |
| 82 | `DefaultSensorsSetting` | DWord | `2` | Advanced | Windows | Device motion/light sensors |
| 83 | `DefaultLocalFontsSetting` | DWord | `2` | Advanced | Windows | Font fingerprinting |
| 84 | `DefaultSerialGuardSetting` | DWord | `2` | Advanced | Windows | Serial API access |
| 85 | `DefaultIdleDetectionSetting` | DWord | `2` | Advanced | Windows | Idle state detection |
| 86 | `BrowserGuestModeEnabled` | DWord | `0` | Advanced | Windows | Guest profile |
| 87 | `BrowserAddPersonEnabled` | DWord | `0` | Advanced | Windows | New profile creation |
| 88 | `ImportAutofillFormData` | DWord | `0` | Advanced | Windows | Cross-browser autofill |
| 89 | `ImportHistory` | DWord | `0` | Advanced | Windows | Cross-browser history |
| 90 | `ImportSavedPasswords` | DWord | `0` | Advanced | Windows | Cross-browser passwords |
| 91 | `ImportSearchEngine` | DWord | `0` | Advanced | Windows | Cross-browser search engine |
| 92 | `ImportHomepage` | DWord | `0` | Advanced | Windows | Cross-browser homepage |
| 93 | `ExtensionInstallBlocklist` | MultiString | `*` | Advanced | Windows | Extension blocklist |
| 94 | `ExtensionInstallAllowlist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh, maafgiompdekodanheihhgilkjchcakm` | Advanced | Windows | Extension allowlist |
| 95 | `ExtensionAllowedTypes` | MultiString | `extension` | Advanced | Windows | Allowed extension types |
| 96 | `BlockExternalExtensions` | DWord | `1` | Advanced | Windows | External extension install |
| 97 | `ExtensionSettings` | String | `{"*":{"installation_mode":"blocked"},…,"maafgiompdekodanheihhgilkjchcakm":{"installation_mode":"allowed","override_update_url":true}}` | Advanced | Windows | Extension policy matrix |
| 98 | `NativeMessagingAllowlist` | MultiString | `com.microsoft.outlook.smime.chromenativeapp` | Advanced | Windows | Native messaging host allowlist |
| 99 | `NativeMessagingUserLevelHosts` | DWord | `1` | Advanced | Windows | User-level native messaging hosts |
| 100 | `BuiltInDnsClientEnabled` | DWord | `0` | Advanced | Windows | Built-in DNS client |
| 101 | `ShowHomeButton` | DWord | `0` | Advanced | Windows | Home button visibility |
| 102 | `HideWebStoreIcon` | DWord | `1` | Advanced | Windows | Web Store icon |
| 103 | `DefaultJavaScriptSetting` | DWord | `0` | Advanced | Windows | JavaScript execution |
| 104 | `GeminiSettings` | DWord | `1` | Advanced | Windows | Gemini AI suggestions |
| 105 | `AIModeSettings` | DWord | `1` | Advanced | Windows | AI Mode in Search |
| 106 | `AutofillPredictionSettings` | DWord | `2` | Advanced | Windows | Autofill predictions |
| 107 | `ChromeSuggestionsSettings` | DWord | `1` | Advanced | Windows | Chrome suggestions |
| 108 | `CreateThemesSettings` | DWord | `2` | Advanced | Windows | Theme creation |
| 109 | `DevToolsGenAiSettings` | DWord | `2` | Advanced | Windows | DevTools AI assistant |
| 110 | `HelpMeWriteSettings` | DWord | `2` | Advanced | Windows | Help Me Write |
| 111 | `HistorySearchSettings` | DWord | `2` | Advanced | Windows | History search |
| 112 | `SearchContentSharingSettings` | DWord | `1` | Advanced | Windows | Search content sharing |
| 113 | `SmartTabSharingSettings` | DWord | `1` | Advanced | Windows | Smart tab sharing |
| 114 | `TabCompareSettings` | DWord | `2` | Advanced | Windows | Tab comparison |
| 115 | `GeminiActOnWebSettings` | DWord | `1` | Advanced | Windows | Gemini web actions |
| 116 | `GeminiSparkSettings` | DWord | `1` | Advanced | Windows | Gemini page spark |
| 117 | `RendererAppContainerEnabled` | DWord | `1` | Advanced | Windows | Renderer sandbox |
| 118 | `LocalNetworkAccessAllowedForUrls` | MultiString | `@()` | Advanced | Windows | Local network allowlist |
| 119 | `LocalNetworkAccessBlockedForUrls` | MultiString | `@()` | Advanced | Windows | Local network blocklist |
| 120 | `LocalNetworkAccessIpAddressSpaceOverrides` | MultiString | `@()` | Advanced | Windows | Local network IP overrides |
| 121 | `LocalNetworkAccessRestrictionsTemporaryOptOut` | DWord | `0` | Advanced | Windows | Local network opt-out |
| 122 | `TranslateEnabled` | DWord | `0` | Strict | Windows | Text to Google for translation |
| 123 | `DefaultClipboardSetting` | DWord | `2` | Strict | Windows | Clipboard read/write |
| 124 | `DefaultFileSystemReadGuardSetting` | DWord | `2` | Strict | Windows | File system read |
| 125 | `DefaultFileSystemWriteGuardSetting` | DWord | `2` | Strict | Windows | File system write |
| 126 | `DefaultInsecureContentSetting` | DWord | `2` | Strict | Windows | Mixed content |
| 127 | `DefaultJavaScriptJitSetting` | DWord | `2` | Strict | Windows | JIT compilation |
| 128 | `DefaultCookiesSetting` | DWord | `2` | Strict | Windows | All cookies |
| 129 | `ImportBookmarks` | DWord | `0` | Strict | Windows | Cross-browser bookmarks |
| 130 | `DefaultBraveRemember1PStorageSetting` | DWord | `2` | Strict | Windows | First-party storage |
| 131 | `IncognitoModeAvailability` | DWord | `1` | Strict | Windows | Incognito mode |
| 132 | `TaskManagerEndProcessEnabled` | DWord | `0` | Strict | Windows | Task Manager |
| 133 | `PrintingEnabled` | DWord | `0` | Strict | Windows | Print function |
| 134 | `DisablePrintPreview` | DWord | `1` | Strict | Windows | Print preview |
| 135 | `SafeBrowsingDeepScanningEnabled` | DWord | `0` | Strict | Windows | Server-side download scan |
| 136 | `DeveloperToolsAvailability` | DWord | `2` | Strict | Windows | Developer Tools |
| 137 | `BrowsingDataLifetime` | String | `{"data_types"=@(…);"time_to_live…"=24}` | Strict | Windows | Auto-clear browsing data |
| 138 | `AlwaysOpenPdfExternally` | DWord | `1` | Strict | Windows | Built-in PDF viewer |
| 139 | `CertificateTransparencyEnforcementDisabledForUrls` | MultiString | `@()` | Strict | Windows | Certificate Transparency |
| 140 | `PasswordLeakDetectionEnabled` | DWord | `1` | Strict | Windows | Password leak detection |
| 141 | `SpellCheckServiceEnabled` | DWord | `0` | Strict | Windows | Spell check network service |
| 142 | `BrowserSignin` | DWord | `0` | Strict | Windows | Chrome sign-in prompt |
| 143 | `SyncDisabled` | DWord | `1` | Strict | Windows | Brave Sync |
| 144 | `ScreenCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows | Screen capture allowlist |
| 145 | `SameOriginTabCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows | Same-origin tab capture |
| 146 | `TabCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows | Tab capture allowlist |
| 147 | `WindowCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows | Window capture allowlist |
| 148 | `LocalNetworkAllowedForUrls` | MultiString | `@()` | Strict | Windows | Local network capture allowlist |
| 149 | `LocalNetworkBlockedForUrls` | MultiString | `@()` | Strict | Windows | Local network capture blocklist |

---

## Tier Breakdown

### BraveOnly — 24 policies
All Brave-specific features disabled or restricted. Zero usability impact for power users.

### Essential — 26 policies (+26 = 50 cumulative)
Data leak prevention. No usability impact. Stops all Chromium/Brave telemetry, background networking, and media capture. Blocks USB/Bluetooth/HID device access.

### Balanced — 31 policies (+31 = 81 cumulative)
Security & convenience balance. WebRTC hardening, encrypted DNS, cookie blocking, password/autofill disable, permission defaults, site isolation, download controls, Dark Reader extension.

### Advanced — 40 policies (+40 = 121 cumulative)
Extended hardening. Disables sensors, fonts, serial, idle detection, guest mode, cross-browser imports, extension restrictions, JavaScript default off, AI features disabled.

### Strict — 28 policies (+28 = 149 cumulative)
Maximum privacy. Disables translation, clipboard, file system, JIT, cookies, printing, downloads, developer tools, cloud reporting. Auto-clears browsing data every 24 hours.

---

## Type Distribution

| Type | Count | Percentage |
|------|-------|------------|
| DWord | 121 | 81.2% |
| String | 8 | 5.4% |
| MultiString | 19 | 12.8% |
| ExpandString | 1 | 0.7% |
| **Total (unique)** | **149** | **100%** |

---

## Excluded Policies

| Policy Name | Reason |
|-------------|--------|
| `CloudPrintProxyEnabled` | Present in `$allPolicyNames` (reset list) but deprecated by Chromium; not assigned to any tier |

---

## Cross-Platform Availability

| Platform | Script | Notes |
|----------|--------|-------|
| Windows | `BraveOmega.ps1` | Primary target: HKLM registry + Omaha GUID |
| macOS | _(planned)_ | Brave-only tier via `defaults write` |
| Linux | _(planned)_ | Brave-only tier via Chromium policy JSON |

All 24 BraveOnly policies are also applied on macOS and Linux, though the mechanism differs (CLI/JSON instead of registry). Essential/Balanced/Advanced/Strict tiers are Windows-only due to HKLM+GUID dependency.

---

<!-- ============================================================ -->
<!-- TÜRKÇE / TURKISH                                           -->
<!-- ============================================================ -->

<a id="-türkçe-katalog"></a>

# Brave Omega — Politika Kataloğu

> **Kaynak:** `BraveOmega.ps1` v3.1.0.1 (iki dilli EN/TR)\
> **Tarih:** 2026-10-22\
> **Toplam benzersiz politika:** 149 (çakışma yok)\
> **Tür dağılımı:** 121 DWord · 8 String · 19 MultiString · 1 ExpandString\
> **Doğrulandı:** V3 sürüm-bağımsız — tüm Brave + Chromium sürümleri (sabit doğrulama hedefi yok)

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
| 26 | `UrlKeyedAnonymizedDataCollectionEnabled` | DWord | `0` | Temel | Windows | Ziyaret edilen URL'ler Google'a |
| 27 | `SearchSuggestEnabled` | DWord | `0` | Temel | Windows | Tuş vuruşu veri sızıntısı |
| 28 | `NetworkPredictionOptions` | DWord | `2` | Temel | Windows | DNS ön getirme / ön bağlantı |
| 29 | `SpellcheckEnabled` | DWord | `1` | Temel | Windows | Yazım denetimi (yerel motor) |
| 30 | `AlternateErrorPagesEnabled` | DWord | `0` | Temel | Windows | DNS hatasında ağ istekleri |
| 31 | `BrowserNetworkTimeQueriesEnabled` | DWord | `0` | Temel | Windows | Google'a zaman senkronizasyonu |
| 32 | `DomainReliabilityAllowed` | DWord | `0` | Temel | Windows | Google'a tanı verisi |
| 33 | `BackgroundModeEnabled` | DWord | `0` | Temel | Windows | Arka plan işlem izleme |
| 34 | `SafeBrowsingSurveysEnabled` | DWord | `0` | Temel | Windows | Gezinti sonrası anketler |
| 35 | `WebRtcEventLogCollectionAllowed` | DWord | `0` | Temel | Windows | WebRTC olay günlükleri Google'a |
| 36 | `WebRtcTextLogCollectionAllowed` | DWord | `0` | Temel | Windows | WebRTC metin günlükleri Google'a |
| 37 | `AudioCaptureAllowed` | DWord | `0` | Temel | Windows | Mikrofon erişimi |
| 38 | `VideoCaptureAllowed` | DWord | `0` | Temel | Windows | Kamera erişimi |
| 39 | `BraveGlobalPrivacyControlEnabled` | DWord | `1` | Temel | Windows | GPC başlığı |
| 40 | `DefaultWebUsbGuardSetting` | DWord | `2` | Temel | Windows | USB cihaz erişimi |
| 41 | `DefaultWebBluetoothGuardSetting` | DWord | `2` | Temel | Windows | Bluetooth cihaz erişimi |
| 42 | `DefaultWebHidGuardSetting` | DWord | `2` | Temel | Windows | HID cihaz erişimi |
| 43 | `EncryptedClientHelloEnabled` | DWord | `1` | Temel | Windows | TLS ClientHello şifreleme |
| 44 | `PaymentMethodQueryEnabled` | DWord | `0` | Temel | Windows | Ödeme yöntemi parmak izi |
| 45 | `SuppressDifferentOriginSubframeDialogs` | DWord | `1` | Temel | Windows | Farklı köken alt çerçeve diyalogları |
| 46 | `EnableOnlineRevocationChecks` | DWord | `1` | Temel | Windows | Sertifika iptal kontrolleri |
| 47 | `ProxySettings` | String | `{"ProxyMode":"system"}` | Temel | Windows | Vekil sunucu yapılandırması |
| 48 | `ExtensionInstallSources` | MultiString | `@()` | Temel | Windows | Eklenti yükleme kaynakları |
| 49 | `ScreenCaptureAllowed` | DWord | `0` | Temel | Windows | Ekran yakalama API'si |
| 50 | `DownloadRestrictions` | DWord | `4` | Temel | Windows | Tehlikeli indirme uyarıları bastırılır |
| 51 | `WebRtcIPHandling` | String | `disable_non_proxied_udp` | Dengeli | Windows | WebRTC IP ifşası |
| 52 | `WebRtcLocalIpsAllowedUrls` | MultiString | `@()` | Dengeli | Windows | ICE yoluyla yerel IP |
| 53 | `HttpsOnlyMode` | String | `force_enabled` | Dengeli | Windows | HTTPS zorlaması |
| 54 | `DnsOverHttpsMode` | String | `automatic` | Dengeli | Windows | Şifreli DNS |
| 55 | `BlockThirdPartyCookies` | DWord | `1` | Dengeli | Windows | Siteler arası izleme |
| 56 | `PasswordManagerEnabled` | DWord | `0` | Dengeli | Windows | Yerleşik parola depolama |
| 57 | `PasswordManagerPasskeysEnabled` | DWord | `0` | Dengeli | Windows | Passkey depolama |
| 58 | `AutofillSettings` | String | `[{"url_pattern":"*","blocked_types":["all"]}]` | Dengeli | Windows | Tüm otomatik doldurma veri türlerini engeller |
| 59 | `ShowFullUrlsInAddressBar` | DWord | `1` | Dengeli | Windows | Oltalama önleme URL gösterimi |
| 60 | `QuicAllowed` | DWord | `0` | Dengeli | Windows | QUIC protokolü |
| 61 | `ChromeVariations` | DWord | `1` | Dengeli | Windows | Yalnızca kritik alan denemeleri |
| 62 | `NetworkServiceSandboxEnabled` | DWord | `1` | Dengeli | Windows | Ağ kum havuzu |
| 63 | `AudioSandboxEnabled` | DWord | `1` | Dengeli | Windows | Ses kum havuzu |
| 64 | `DefaultGeolocationSetting` | DWord | `2` | Dengeli | Windows | Cihaz konumu erişimi |
| 65 | `DefaultNotificationsSetting` | DWord | `2` | Dengeli | Windows | Bildirim istemleri |
| 66 | `DefaultPopupsSetting` | DWord | `2` | Dengeli | Windows | Açılır pencereler |
| 67 | `DefaultBraveHttpsUpgradeSetting` | DWord | `2` | Dengeli | Windows | Brave HTTPS yükseltme |
| 68 | `DefaultBraveReferrersSetting` | DWord | `2` | Dengeli | Windows | Brave yönlendiren sınırı |
| 69 | `BraveSyncUrl` | String | `https://sync-v2.brave.com/v2` | Dengeli | Windows | Senkronizasyon sunucu URL'si |
| 70 | `DefaultWindowManagementSetting` | DWord | `2` | Dengeli | Windows | Pencere yönetimi izni |
| 71 | `SitePerProcess` | DWord | `1` | Dengeli | Windows | Site izolasyonu |
| 72 | `IntensiveWakeUpThrottlingEnabled` | DWord | `1` | Dengeli | Windows | Arka plan zamanlayıcı kısıtlaması |
| 73 | `UserFeedbackAllowed` | DWord | `0` | Dengeli | Windows | Kullanıcı geri bildirim istemleri |
| 74 | `ExtensionInstallForcelist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh;…, maafgiompdekodanheihhgilkjchcakm;https://outlook.office.com/owa/SmimeCrxUpdate.ashx` | Dengeli | Windows | Zorunlu eklenti |
| 75 | `DownloadDirectory` | ExpandString | `${env:USERPROFILE}\Downloads\` | Dengeli | Windows | İndirme yolu |
| 76 | `PromptForDownloadLocation` | DWord | `0` | Dengeli | Windows | İndirme konumu istemi |
| 77 | `RelaunchNotification` | DWord | `2` | Dengeli | Windows | Tarayıcı yeniden başlatma bildirimi |
| 78 | `RelaunchNotificationPeriod` | DWord | `3600000` | Dengeli | Windows | Yeniden başlatma zamanlayıcı (1 saat) |
| 79 | `LocalNetworkAccessPermissionsPolicyDefaultEnabled` | DWord | `0` | Dengeli | Windows | Yerel ağ izin varsayılanı |
| 80 | `GenAILocalFoundationalModelSettings` | DWord | `1` | Dengeli | Windows | Cihaz içi yapay zeka modeli |
| 81 | `DisableSafeBrowsingProceedAnyway` | DWord | `1` | Dengeli | Windows | Kötü amaçlı yazılım uyarı atlama |
| 82 | `DefaultSensorsSetting` | DWord | `2` | İleri | Windows | Hareket/ışık sensörleri |
| 83 | `DefaultLocalFontsSetting` | DWord | `2` | İleri | Windows | Yazı tipi parmak izi |
| 84 | `DefaultSerialGuardSetting` | DWord | `2` | İleri | Windows | Serial API erişimi |
| 85 | `DefaultIdleDetectionSetting` | DWord | `2` | İleri | Windows | Boşta algılama |
| 86 | `BrowserGuestModeEnabled` | DWord | `0` | İleri | Windows | Misafir profili |
| 87 | `BrowserAddPersonEnabled` | DWord | `0` | İleri | Windows | Yeni profil oluşturma |
| 88 | `ImportAutofillFormData` | DWord | `0` | İleri | Windows | Tarayıcılar arası otomatik doldurma |
| 89 | `ImportHistory` | DWord | `0` | İleri | Windows | Tarayıcılar arası geçmiş |
| 90 | `ImportSavedPasswords` | DWord | `0` | İleri | Windows | Tarayıcılar arası parolalar |
| 91 | `ImportSearchEngine` | DWord | `0` | İleri | Windows | Tarayıcılar arası arama motoru |
| 92 | `ImportHomepage` | DWord | `0` | İleri | Windows | Tarayıcılar arası ana sayfa |
| 93 | `ExtensionInstallBlocklist` | MultiString | `*` | İleri | Windows | Eklenti engelleme listesi |
| 94 | `ExtensionInstallAllowlist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh, maafgiompdekodanheihhgilkjchcakm` | İleri | Windows | Eklenti izin listesi |
| 95 | `ExtensionAllowedTypes` | MultiString | `extension` | İleri | Windows | İzin verilen eklenti türleri |
| 96 | `BlockExternalExtensions` | DWord | `1` | İleri | Windows | Harici eklenti yükleme |
| 97 | `ExtensionSettings` | String | `{"*":{"installation_mode":"blocked"},…,"maafgiompdekodanheihhgilkjchcakm":{"installation_mode":"allowed","override_update_url":true}}` | İleri | Windows | Eklenti politika matrisi |
| 98 | `NativeMessagingAllowlist` | MultiString | `com.microsoft.outlook.smime.chromenativeapp` | İleri | Windows | S/MIME yerel mesajlaşma ana bilgisayarı |
| 99 | `NativeMessagingUserLevelHosts` | DWord | `1` | İleri | Windows | Kullanıcı düzeyi yerel mesajlaşma ana bilgisayarları |
| 100 | `BuiltInDnsClientEnabled` | DWord | `0` | İleri | Windows | Yerleşik DNS istemcisi |
| 101 | `ShowHomeButton` | DWord | `0` | İleri | Windows | Ana sayfa düğmesi görünürlüğü |
| 102 | `HideWebStoreIcon` | DWord | `1` | İleri | Windows | Web Mağazası simgesi |
| 103 | `DefaultJavaScriptSetting` | DWord | `0` | İleri | Windows | JavaScript çalıştırma |
| 104 | `GeminiSettings` | DWord | `1` | İleri | Windows | Gemini AI önerileri |
| 105 | `AIModeSettings` | DWord | `1` | İleri | Windows | Arama'da AI Modu |
| 106 | `AutofillPredictionSettings` | DWord | `2` | İleri | Windows | Otomatik doldurma tahminleri |
| 107 | `ChromeSuggestionsSettings` | DWord | `1` | İleri | Windows | Chrome önerileri |
| 108 | `CreateThemesSettings` | DWord | `2` | İleri | Windows | Tema oluşturma |
| 109 | `DevToolsGenAiSettings` | DWord | `2` | İleri | Windows | Geliştirici araçları AI asistanı |
| 110 | `HelpMeWriteSettings` | DWord | `2` | İleri | Windows | Yazmaya Yardım Et |
| 111 | `HistorySearchSettings` | DWord | `2` | İleri | Windows | Geçmiş arama |
| 112 | `SearchContentSharingSettings` | DWord | `1` | İleri | Windows | Arama içeriği paylaşma |
| 113 | `SmartTabSharingSettings` | DWord | `1` | İleri | Windows | Akıllı sekme paylaşma |
| 114 | `TabCompareSettings` | DWord | `2` | İleri | Windows | Sekme karşılaştırma |
| 115 | `GeminiActOnWebSettings` | DWord | `1` | İleri | Windows | Gemini web işlemleri |
| 116 | `GeminiSparkSettings` | DWord | `1` | İleri | Windows | Gemini sayfa kıvılcımı |
| 117 | `RendererAppContainerEnabled` | DWord | `1` | İleri | Windows | İşleyici kum havuzu |
| 118 | `LocalNetworkAccessAllowedForUrls` | MultiString | `@()` | İleri | Windows | Yerel ağ izin listesi |
| 119 | `LocalNetworkAccessBlockedForUrls` | MultiString | `@()` | İleri | Windows | Yerel ağ engelleme listesi |
| 120 | `LocalNetworkAccessIpAddressSpaceOverrides` | MultiString | `@()` | İleri | Windows | Yerel ağ IP overrides |
| 121 | `LocalNetworkAccessRestrictionsTemporaryOptOut` | DWord | `0` | İleri | Windows | Yerel ağ çıkış seçeneği |
| 122 | `TranslateEnabled` | DWord | `0` | Katı | Windows | Google'a çeviri için metin |
| 123 | `DefaultClipboardSetting` | DWord | `2` | Katı | Windows | Pano okuma/yazma |
| 124 | `DefaultFileSystemReadGuardSetting` | DWord | `2` | Katı | Windows | Dosya sistemi okuma |
| 125 | `DefaultFileSystemWriteGuardSetting` | DWord | `2` | Katı | Windows | Dosya sistemi yazma |
| 126 | `DefaultInsecureContentSetting` | DWord | `2` | Katı | Windows | Karma içerik |
| 127 | `DefaultJavaScriptJitSetting` | DWord | `2` | Katı | Windows | JIT derleme |
| 128 | `DefaultCookiesSetting` | DWord | `2` | Katı | Windows | Tüm çerezler |
| 129 | `ImportBookmarks` | DWord | `0` | Katı | Windows | Tarayıcılar arası yer imleri |
| 130 | `DefaultBraveRemember1PStorageSetting` | DWord | `2` | Katı | Windows | Birinci taraf depolama |
| 131 | `IncognitoModeAvailability` | DWord | `1` | Katı | Windows | Gizli mod |
| 132 | `TaskManagerEndProcessEnabled` | DWord | `0` | Katı | Windows | Görev Yöneticisi |
| 133 | `PrintingEnabled` | DWord | `0` | Katı | Windows | Yazdırma işlevi |
| 134 | `DisablePrintPreview` | DWord | `1` | Katı | Windows | Yazdırma önizleme |
| 135 | `SafeBrowsingDeepScanningEnabled` | DWord | `0` | Katı | Windows | Sunucu tarafı indirme taraması |
| 136 | `DeveloperToolsAvailability` | DWord | `2` | Katı | Windows | Geliştirici araçları |
| 137 | `BrowsingDataLifetime` | String | `{"data_types"=@(…);"time_to_live…"=24}` | Katı | Windows | Otomatik gezinti verisi temizleme |
| 138 | `AlwaysOpenPdfExternally` | DWord | `1` | Katı | Windows | Yerleşik PDF görüntüleyici |
| 139 | `CertificateTransparencyEnforcementDisabledForUrls` | MultiString | `@()` | Katı | Windows | Sertifika Saydamlığı |
| 140 | `PasswordLeakDetectionEnabled` | DWord | `1` | Katı | Windows | Parola sızıntısı algılama |
| 141 | `SpellCheckServiceEnabled` | DWord | `0` | Katı | Windows | Yazım denetimi ağ hizmeti |
| 142 | `BrowserSignin` | DWord | `0` | Katı | Windows | Chrome giriş istemi |
| 143 | `SyncDisabled` | DWord | `1` | Katı | Windows | Brave Sync |
| 144 | `ScreenCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows | Ekran yakalama izin listesi |
| 145 | `SameOriginTabCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows | Aynı köken sekme yakalama |
| 146 | `TabCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows | Sekme yakalama izin listesi |
| 147 | `WindowCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows | Pencere yakalama izin listesi |
| 148 | `LocalNetworkAllowedForUrls` | MultiString | `@()` | Katı | Windows | Yerel ağ yakalama izin listesi |
| 149 | `LocalNetworkBlockedForUrls` | MultiString | `@()` | Katı | Windows | Yerel ağ yakalama engelleme listesi |

---

## Katman Bazında Dağılım

### Brave Yalnız — 24 politika
Tüm Brave'e özgü özellikler devre dışı bırakıldı veya kısıtlandı. Güç kullanıcıları için sıfır kullanılabilirlik etkisi.

### Temel — 26 politika (+26 = 50 kümülatif)
Veri sızıntısı önleme. Kullanılabilirlik etkisi yok. Tüm Chromium/Brave telemetrisini, arka plan ağ iletişimini ve medya yakalamayı durdurur. USB/Bluetooth/HID cihaz erişimini engeller.

### Dengeli — 31 politika (+31 = 81 kümülatif)
Güvenlik ve kullanım dengesi. WebRTC sıkılaştırması, şifreli DNS, çerez engelleme, parola/otomatik doldurma devre dışı bırakma, izin varsayılanları, site izolasyonu, indirme kontrolleri, Dark Reader eklentisi.

### İleri — 40 politika (+40 = 121 kümülatif)
Genişletilmiş sıkılaştırma. Sensörler, yazı tipleri, seri bağlantı noktası, boşta algılama, misafir modu, tarayıcılar arası içe aktarmalar, eklenti kısıtlamaları, JavaScript varsayılanı kapalı, yapay zeka özellikleri devre dışı.

### Katı — 28 politika (+28 = 149 kümülatif)
Azami gizlilik. Çeviri, pano, dosya sistemi, JIT, çerezler, yazdırma, indirmeler, geliştirici araçları, bulut raporlama devre dışı. Gezinti verilerini her 24 saatte bir otomatik temizler.

---

## Tür Dağılımı

| Tür | Adet | Yüzde |
|-----|------|-------|
| DWord | 121 | %81,2 |
| String | 8 | %5,4 |
| MultiString | 19 | %12,8 |
| ExpandString | 1 | %0,7 |
| **Toplam (benzersiz)** | **149** | **%100** |

---

## Hariç Tutulan Politikalar

| Politika Adı | Gerekçe |
|-------------|---------|
| `CloudPrintProxyEnabled` | `$allPolicyNames` listesinde (sıfırlama) mevcut ancak Chromium tarafından kullanımdan kaldırıldı; hiçbir katmana atanmamıştır |

---

## Platformlar Arası Kullanılabilirlik

| Platform | Betik | Notlar |
|----------|-------|--------|
| Windows | `BraveOmega.ps1` | Birincil hedef: HKLM kayıt defteri + Omaha GUID |
| macOS | _(planlandı)_ | Yalnızca Brave Yalnız katmanı, `defaults write` ile |
| Linux | _(planlandı)_ | Yalnızca Brave Yalnız katmanı, Chromium JSON politika dosyası |

24 Brave Yalnız politikasının tamamı macOS ve Linux'ta da uygulanır, ancak mekanizma farklıdır (CLI/JSON, kayıt defteri yerine). Temel/Dengeli/İleri/Katı katmanları yalnızca Windows'a özgüdür (HKLM+GUID bağımlılığı).
