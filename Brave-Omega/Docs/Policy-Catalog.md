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

> **Source:** `BraveOmega.ps1` v3.1.0.2 (bilingual EN/TR)\
> **Date:** 2026-10-23\
> **Total unique policies:** 150 (no overlaps)\
> **Type distribution:** 121 DWord · 8 String · 20 MultiString · 1 ExpandString\
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
| 1 | `BraveRewardsDisabled` | DWord | `1` | BraveOnly | Windows·Linux | Brave Rewards data collection |
| 2 | `BraveWalletDisabled` | DWord | `1` | BraveOnly | Windows·Linux | Crypto wallet exposes addresses |
| 3 | `BraveVPNDisabled` | DWord | `1` | BraveOnly | Windows·Linux | VPN service metadata leaks |
| 4 | `BraveAIChatEnabled` | DWord | `0` | BraveOnly | Windows·Linux | Leo AI sends prompts to Brave servers |
| 5 | `BraveTalkDisabled` | DWord | `1` | BraveOnly | Windows·Linux | Video conferencing metadata |
| 6 | `BraveNewsDisabled` | DWord | `1` | BraveOnly | Windows·Linux | News feed network requests |
| 7 | `BravePlaylistEnabled` | DWord | `0` | BraveOnly | Windows·Linux | Offline media content |
| 8 | `BraveSpeedreaderEnabled` | DWord | `0` | BraveOnly | Windows·Linux | Reader mode page analysis |
| 9 | `BraveWaybackMachineEnabled` | DWord | `0` | BraveOnly | Windows·Linux | Internet Archive queries |
| 10 | `BraveP3AEnabled` | DWord | `0` | BraveOnly | Windows·Linux | P3A telemetry data |
| 11 | `BraveStatsPingEnabled` | DWord | `0` | BraveOnly | Windows·Linux | Authentication / status ping |
| 12 | `BraveWebDiscoveryEnabled` | DWord | `0` | BraveOnly | Windows·Linux | Search index contribution |
| 13 | `TorDisabled` | DWord | `1` | BraveOnly | Windows·Linux | Tor integration code path |
| 14 | `BraveDeAmpEnabled` | DWord | `1` | BraveOnly | Windows·Linux | AMP circumvention |
| 15 | `BraveDebouncingEnabled` | DWord | `1` | BraveOnly | Windows·Linux | Bounce tracking |
| 16 | `BraveReduceLanguageEnabled` | DWord | `1` | BraveOnly | Windows·Linux | Language fingerprint |
| 17 | `BraveTrackingQueryParametersFilteringEnabled` | DWord | `1` | BraveOnly | Windows·Linux | URL tracking params |
| 18 | `DefaultBraveAdblockSetting` | DWord | `2` | BraveOnly | Windows·Linux | Shields ad block level |
| 19 | `DefaultBraveFingerprintingV2Setting` | DWord | `3` | BraveOnly | Windows·Linux | Shields fingerprinting level |
| 20 | `BraveShieldsDisabledForUrls` | MultiString | `@()` | BraveOnly | Windows·Linux | Shields bypass list |
| 21 | `BraveShieldsEnabledForUrls` | MultiString | `@()` | BraveOnly | Windows·Linux | Shields force list |
| 22 | `EmailAliasesEnabled` | DWord | `0` | BraveOnly | Windows·Linux | Anonymous email aliases |
| 23 | `SafeBrowsingProtectionLevel` | DWord | `2` | BraveOnly | Windows·Linux | Safe Browsing protection level |
| 24 | `PasswordProtectionWarningTrigger` | DWord | `3` | BraveOnly | Windows·Linux | Password leak warning trigger |
| 25 | `NotificationsAllowedForUrls` | MultiString | `@("https://web.whatsapp.com")` | BraveOnly | Windows·Linux | Allows WhatsApp Web notifications while every other origin stays blocked |
| 26 | `MetricsReportingEnabled` | DWord | `0` | Essential | Windows·Linux | Chromium usage/crash metrics |
| 27 | `UrlKeyedAnonymizedDataCollectionEnabled` | DWord | `0` | Essential | Windows·Linux | Visited URLs to Google |
| 28 | `SearchSuggestEnabled` | DWord | `0` | Essential | Windows·Linux | Keystroke data leak |
| 29 | `NetworkPredictionOptions` | DWord | `2` | Essential | Windows·Linux | DNS prefetch / pre-connect |
| 30 | `SpellcheckEnabled` | DWord | `1` | Essential | Windows·Linux | Spellcheck (local engine) |
| 31 | `AlternateErrorPagesEnabled` | DWord | `0` | Essential | Windows·Linux | DNS failure network requests |
| 32 | `BrowserNetworkTimeQueriesEnabled` | DWord | `0` | Essential | Windows·Linux | Time sync to Google |
| 33 | `DomainReliabilityAllowed` | DWord | `0` | Essential | Windows·Linux | Diagnostic data to Google |
| 34 | `BackgroundModeEnabled` | DWord | `0` | Essential | Windows·Linux | Background process tracking |
| 35 | `SafeBrowsingSurveysEnabled` | DWord | `0` | Essential | Windows·Linux | Post-browsing surveys |
| 36 | `WebRtcEventLogCollectionAllowed` | DWord | `0` | Essential | Windows·Linux | WebRTC event logs to Google |
| 37 | `WebRtcTextLogCollectionAllowed` | DWord | `0` | Essential | Windows·Linux | WebRTC text logs to Google |
| 38 | `AudioCaptureAllowed` | DWord | `0` | Essential | Windows·Linux | Microphone access |
| 39 | `VideoCaptureAllowed` | DWord | `0` | Essential | Windows·Linux | Camera access |
| 40 | `BraveGlobalPrivacyControlEnabled` | DWord | `1` | Essential | Windows·Linux | GPC header |
| 41 | `DefaultWebUsbGuardSetting` | DWord | `2` | Essential | Windows·Linux | USB device access |
| 42 | `DefaultWebBluetoothGuardSetting` | DWord | `2` | Essential | Windows·Linux | Bluetooth device access |
| 43 | `DefaultWebHidGuardSetting` | DWord | `2` | Essential | Windows·Linux | HID device access |
| 44 | `EncryptedClientHelloEnabled` | DWord | `1` | Essential | Windows·Linux | TLS ClientHello encryption |
| 45 | `PaymentMethodQueryEnabled` | DWord | `0` | Essential | Windows·Linux | Payment method fingerprint |
| 46 | `SuppressDifferentOriginSubframeDialogs` | DWord | `1` | Essential | Windows·Linux | Cross-origin dialog abuse |
| 47 | `EnableOnlineRevocationChecks` | DWord | `1` | Essential | Windows·Linux | Certificate revocation checks |
| 48 | `ProxySettings` | String | `{"ProxyMode":"system"}` | Essential | Windows·Linux | Proxy configuration |
| 49 | `ExtensionInstallSources` | MultiString | `@()` | Essential | Windows·Linux | Extension install sources |
| 50 | `ScreenCaptureAllowed` | DWord | `0` | Essential | Windows·Linux | Screen capture API |
| 51 | `DownloadRestrictions` | DWord | `4` | Essential | Windows·Linux | Dangerous download warnings suppressed |
| 52 | `WebRtcIPHandling` | String | `disable_non_proxied_udp` | Balanced | Windows·Linux | WebRTC IP exposure |
| 53 | `WebRtcLocalIpsAllowedUrls` | MultiString | `@()` | Balanced | Windows·Linux | Local IP via ICE |
| 54 | `HttpsOnlyMode` | String | `force_enabled` | Balanced | Windows·Linux | HTTPS enforcement |
| 55 | `DnsOverHttpsMode` | String | `automatic` | Balanced | Windows·Linux | Encrypted DNS |
| 56 | `BlockThirdPartyCookies` | DWord | `1` | Balanced | Windows·Linux | Cross-site tracking |
| 57 | `PasswordManagerEnabled` | DWord | `0` | Balanced | Windows·Linux | Built-in password storage |
| 58 | `PasswordManagerPasskeysEnabled` | DWord | `0` | Balanced | Windows·Linux | Passkey storage |
| 59 | `AutofillSettings` | String | `[{"url_pattern":"*","blocked_types":["all"]}]` | Balanced | Windows·Linux | Blocks all autofill data types |
| 60 | `ShowFullUrlsInAddressBar` | DWord | `1` | Balanced | Windows·Linux | Anti-phishing URL display |
| 61 | `QuicAllowed` | DWord | `0` | Balanced | Windows·Linux | QUIC protocol |
| 62 | `ChromeVariations` | DWord | `1` | Balanced | Windows·Linux | Critical field trials only |
| 63 | `NetworkServiceSandboxEnabled` | DWord | `1` | Balanced | Windows·Linux | Network sandbox |
| 64 | `AudioSandboxEnabled` | DWord | `1` | Balanced | Windows·Linux | Audio sandbox |
| 65 | `DefaultGeolocationSetting` | DWord | `2` | Balanced | Windows·Linux | Device location access |
| 66 | `DefaultNotificationsSetting` | DWord | `2` | Balanced | Windows·Linux | Notification prompts |
| 67 | `DefaultPopupsSetting` | DWord | `2` | Balanced | Windows·Linux | Pop-up windows |
| 68 | `DefaultBraveHttpsUpgradeSetting` | DWord | `2` | Balanced | Windows·Linux | Brave HTTPS upgrade |
| 69 | `DefaultBraveReferrersSetting` | DWord | `2` | Balanced | Windows·Linux | Brave referrer cap |
| 70 | `BraveSyncUrl` | String | `https://sync-v2.brave.com/v2` | Balanced | Windows·Linux | Sync server URL |
| 71 | `DefaultWindowManagementSetting` | DWord | `2` | Balanced | Windows·Linux | Window management permission |
| 72 | `SitePerProcess` | DWord | `1` | Balanced | Windows·Linux | Site isolation |
| 73 | `IntensiveWakeUpThrottlingEnabled` | DWord | `1` | Balanced | Windows·Linux | Background timer throttling |
| 74 | `UserFeedbackAllowed` | DWord | `0` | Balanced | Windows·Linux | User feedback prompts |
| 75 | `ExtensionInstallForcelist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh;…, maafgiompdekodanheihhgilkjchcakm;https://outlook.office.com/owa/SmimeCrxUpdate.ashx` | Balanced | Windows·Linux | Force-installed extension |
| 76 | `DownloadDirectory` | ExpandString | `${env:USERPROFILE}\Downloads\` | Balanced | Windows·Linux | Download path |
| 77 | `PromptForDownloadLocation` | DWord | `0` | Balanced | Windows·Linux | Download location prompt |
| 78 | `RelaunchNotification` | DWord | `2` | Balanced | Windows·Linux | Browser relaunch notification |
| 79 | `RelaunchNotificationPeriod` | DWord | `3600000` | Balanced | Windows·Linux | Relaunch timer (1 hour) |
| 80 | `LocalNetworkAccessPermissionsPolicyDefaultEnabled` | DWord | `0` | Balanced | Windows·Linux | Local network permission default |
| 81 | `GenAILocalFoundationalModelSettings` | DWord | `1` | Balanced | Windows·Linux | On-device AI model |
| 82 | `DisableSafeBrowsingProceedAnyway` | DWord | `1` | Balanced | Windows·Linux | Malware warning bypass |
| 83 | `DefaultSensorsSetting` | DWord | `2` | Advanced | Windows·Linux | Device motion/light sensors |
| 84 | `DefaultLocalFontsSetting` | DWord | `2` | Advanced | Windows·Linux | Font fingerprinting |
| 85 | `DefaultSerialGuardSetting` | DWord | `2` | Advanced | Windows·Linux | Serial API access |
| 86 | `DefaultIdleDetectionSetting` | DWord | `2` | Advanced | Windows·Linux | Idle state detection |
| 87 | `BrowserGuestModeEnabled` | DWord | `0` | Advanced | Windows·Linux | Guest profile |
| 88 | `BrowserAddPersonEnabled` | DWord | `0` | Advanced | Windows·Linux | New profile creation |
| 89 | `ImportAutofillFormData` | DWord | `0` | Advanced | Windows·Linux | Cross-browser autofill |
| 90 | `ImportHistory` | DWord | `0` | Advanced | Windows·Linux | Cross-browser history |
| 91 | `ImportSavedPasswords` | DWord | `0` | Advanced | Windows·Linux | Cross-browser passwords |
| 92 | `ImportSearchEngine` | DWord | `0` | Advanced | Windows·Linux | Cross-browser search engine |
| 93 | `ImportHomepage` | DWord | `0` | Advanced | Windows·Linux | Cross-browser homepage |
| 94 | `ExtensionInstallBlocklist` | MultiString | `*` | Advanced | Windows·Linux | Extension blocklist |
| 95 | `ExtensionInstallAllowlist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh, maafgiompdekodanheihhgilkjchcakm` | Advanced | Windows·Linux | Extension allowlist |
| 96 | `ExtensionAllowedTypes` | MultiString | `extension` | Advanced | Windows·Linux | Allowed extension types |
| 97 | `BlockExternalExtensions` | DWord | `1` | Advanced | Windows·Linux | External extension install |
| 98 | `ExtensionSettings` | String | `{"*":{"installation_mode":"blocked"},…,"maafgiompdekodanheihhgilkjchcakm":{"installation_mode":"allowed","override_update_url":true}}` | Advanced | Windows·Linux | Extension policy matrix |
| 99 | `NativeMessagingAllowlist` | MultiString | `com.microsoft.outlook.smime.chromenativeapp` | Advanced | Windows·Linux | Native messaging host allowlist |
| 100 | `NativeMessagingUserLevelHosts` | DWord | `1` | Advanced | Windows·Linux | User-level native messaging hosts |
| 101 | `BuiltInDnsClientEnabled` | DWord | `0` | Advanced | Windows·Linux | Built-in DNS client |
| 102 | `ShowHomeButton` | DWord | `0` | Advanced | Windows·Linux | Home button visibility |
| 103 | `HideWebStoreIcon` | DWord | `1` | Advanced | Windows·Linux | Web Store icon |
| 104 | `DefaultJavaScriptSetting` | DWord | `0` | Advanced | Windows·Linux | JavaScript execution |
| 105 | `GeminiSettings` | DWord | `1` | Advanced | Windows·Linux | Gemini AI suggestions |
| 106 | `AIModeSettings` | DWord | `1` | Advanced | Windows·Linux | AI Mode in Search |
| 107 | `AutofillPredictionSettings` | DWord | `2` | Advanced | Windows·Linux | Autofill predictions |
| 108 | `ChromeSuggestionsSettings` | DWord | `1` | Advanced | Windows·Linux | Chrome suggestions |
| 109 | `CreateThemesSettings` | DWord | `2` | Advanced | Windows·Linux | Theme creation |
| 110 | `DevToolsGenAiSettings` | DWord | `2` | Advanced | Windows·Linux | DevTools AI assistant |
| 111 | `HelpMeWriteSettings` | DWord | `2` | Advanced | Windows·Linux | Help Me Write |
| 112 | `HistorySearchSettings` | DWord | `2` | Advanced | Windows·Linux | History search |
| 113 | `SearchContentSharingSettings` | DWord | `1` | Advanced | Windows·Linux | Search content sharing |
| 114 | `SmartTabSharingSettings` | DWord | `1` | Advanced | Windows·Linux | Smart tab sharing |
| 115 | `TabCompareSettings` | DWord | `2` | Advanced | Windows·Linux | Tab comparison |
| 116 | `GeminiActOnWebSettings` | DWord | `1` | Advanced | Windows·Linux | Gemini web actions |
| 117 | `GeminiSparkSettings` | DWord | `1` | Advanced | Windows·Linux | Gemini page spark |
| 118 | `RendererAppContainerEnabled` | DWord | `1` | Advanced | Windows·Linux | Renderer sandbox |
| 119 | `LocalNetworkAccessAllowedForUrls` | MultiString | `@()` | Advanced | Windows·Linux | Local network allowlist |
| 120 | `LocalNetworkAccessBlockedForUrls` | MultiString | `@()` | Advanced | Windows·Linux | Local network blocklist |
| 121 | `LocalNetworkAccessIpAddressSpaceOverrides` | MultiString | `@()` | Advanced | Windows·Linux | Local network IP overrides |
| 122 | `LocalNetworkAccessRestrictionsTemporaryOptOut` | DWord | `0` | Advanced | Windows·Linux | Local network opt-out |
| 123 | `TranslateEnabled` | DWord | `0` | Strict | Windows·Linux | Text to Google for translation |
| 124 | `DefaultClipboardSetting` | DWord | `2` | Strict | Windows·Linux | Clipboard read/write |
| 125 | `DefaultFileSystemReadGuardSetting` | DWord | `2` | Strict | Windows·Linux | File system read |
| 126 | `DefaultFileSystemWriteGuardSetting` | DWord | `2` | Strict | Windows·Linux | File system write |
| 127 | `DefaultInsecureContentSetting` | DWord | `2` | Strict | Windows·Linux | Mixed content |
| 128 | `DefaultJavaScriptJitSetting` | DWord | `2` | Strict | Windows·Linux | JIT compilation |
| 129 | `DefaultCookiesSetting` | DWord | `2` | Strict | Windows·Linux | All cookies |
| 130 | `ImportBookmarks` | DWord | `0` | Strict | Windows·Linux | Cross-browser bookmarks |
| 131 | `DefaultBraveRemember1PStorageSetting` | DWord | `2` | Strict | Windows·Linux | First-party storage |
| 132 | `IncognitoModeAvailability` | DWord | `1` | Strict | Windows·Linux | Incognito mode |
| 133 | `TaskManagerEndProcessEnabled` | DWord | `0` | Strict | Windows·Linux | Task Manager |
| 134 | `PrintingEnabled` | DWord | `0` | Strict | Windows·Linux | Print function |
| 135 | `DisablePrintPreview` | DWord | `1` | Strict | Windows·Linux | Print preview |
| 136 | `SafeBrowsingDeepScanningEnabled` | DWord | `0` | Strict | Windows·Linux | Server-side download scan |
| 137 | `DeveloperToolsAvailability` | DWord | `2` | Strict | Windows·Linux | Developer Tools |
| 138 | `BrowsingDataLifetime` | String | `{"data_types"=@(…);"time_to_live…"=24}` | Strict | Windows·Linux | Auto-clear browsing data |
| 139 | `AlwaysOpenPdfExternally` | DWord | `1` | Strict | Windows·Linux | Built-in PDF viewer |
| 140 | `CertificateTransparencyEnforcementDisabledForUrls` | MultiString | `@()` | Strict | Windows·Linux | Certificate Transparency |
| 141 | `PasswordLeakDetectionEnabled` | DWord | `1` | Strict | Windows·Linux | Password leak detection |
| 142 | `SpellCheckServiceEnabled` | DWord | `0` | Strict | Windows·Linux | Spell check network service |
| 143 | `BrowserSignin` | DWord | `0` | Strict | Windows·Linux | Chrome sign-in prompt |
| 144 | `SyncDisabled` | DWord | `1` | Strict | Windows·Linux | Brave Sync |
| 145 | `ScreenCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows·Linux | Screen capture allowlist |
| 146 | `SameOriginTabCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows·Linux | Same-origin tab capture |
| 147 | `TabCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows·Linux | Tab capture allowlist |
| 148 | `WindowCaptureAllowedByOrigins` | MultiString | `@()` | Strict | Windows·Linux | Window capture allowlist |
| 149 | `LocalNetworkAllowedForUrls` | MultiString | `@()` | Strict | Windows·Linux | Local network capture allowlist |
| 150 | `LocalNetworkBlockedForUrls` | MultiString | `@()` | Strict | Windows·Linux | Local network capture blocklist |

---

## Tier Breakdown

### BraveOnly — 25 policies
All Brave-specific features disabled or restricted. Zero usability impact for power users.

### Essential — 26 policies (+26 = 51 cumulative)
Data leak prevention. No usability impact. Stops all Chromium/Brave telemetry, background networking, and media capture. Blocks USB/Bluetooth/HID device access.

### Balanced — 31 policies (+31 = 82 cumulative)
Security & convenience balance. WebRTC hardening, encrypted DNS, cookie blocking, password/autofill disable, permission defaults, site isolation, download controls, Dark Reader extension.

### Advanced — 40 policies (+40 = 122 cumulative)
Extended hardening. Disables sensors, fonts, serial, idle detection, guest mode, cross-browser imports, extension restrictions, JavaScript default off, AI features disabled.

### Strict — 29 policies (+29 = 150 cumulative)
Maximum privacy. Disables translation, clipboard, file system, JIT, cookies, printing, downloads, developer tools, cloud reporting. Auto-clears browsing data every 24 hours.

---

## Type Distribution

| Type | Count | Percentage |
|------|-------|------------|
| DWord | 121 | 80.7% |
| String | 8 | 5.3% |
| MultiString | 20 | 13.3% |
| ExpandString | 1 | 0.7% |
| **Total (unique)** | **150** | **100%** |

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
| Linux | `Install-OmegaLinux.sh` | Brave-only tier via Chromium policy JSON |

All 25 BraveOnly policies are also applied on Linux through the managed JSON installer; macOS support is planned. Windows seals policies in HKLM and anchors them to the Omaha GUID.

---

<!-- ============================================================ -->
<!-- TÜRKÇE / TURKISH                                           -->
<!-- ============================================================ -->

<a id="-türkçe-katalog"></a>

# Brave Omega — Politika Kataloğu

> **Kaynak:** `BraveOmega.ps1` v3.1.0.2 (iki dilli EN/TR)\
> **Tarih:** 2026-10-23\
> **Toplam benzersiz politika:** 150 (çakışma yok)\
> **Tür dağılımı:** 121 DWord · 8 String · 20 MultiString · 1 ExpandString\
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
| 1 | `BraveRewardsDisabled` | DWord | `1` | Brave Yalnız | Windows·Linux | Brave Rewards veri toplama |
| 2 | `BraveWalletDisabled` | DWord | `1` | Brave Yalnız | Windows·Linux | Kripto cüzdan adres ifşası |
| 3 | `BraveVPNDisabled` | DWord | `1` | Brave Yalnız | Windows·Linux | VPN hizmeti meta veri sızıntısı |
| 4 | `BraveAIChatEnabled` | DWord | `0` | Brave Yalnız | Windows·Linux | Leo AI, Brave sunucularına prompt gönderir |
| 5 | `BraveTalkDisabled` | DWord | `1` | Brave Yalnız | Windows·Linux | Video konferans meta verileri |
| 6 | `BraveNewsDisabled` | DWord | `1` | Brave Yalnız | Windows·Linux | Haber akışı ağ istekleri |
| 7 | `BravePlaylistEnabled` | DWord | `0` | Brave Yalnız | Windows·Linux | Çevrimdışı medya içeriği |
| 8 | `BraveSpeedreaderEnabled` | DWord | `0` | Brave Yalnız | Windows·Linux | Okuma modu sayfa analizi |
| 9 | `BraveWaybackMachineEnabled` | DWord | `0` | Brave Yalnız | Windows·Linux | İnternet Arşivi sorguları |
| 10 | `BraveP3AEnabled` | DWord | `0` | Brave Yalnız | Windows·Linux | P3A telemetri verileri |
| 11 | `BraveStatsPingEnabled` | DWord | `0` | Brave Yalnız | Windows·Linux | Kimlik doğrulama / durum pingi |
| 12 | `BraveWebDiscoveryEnabled` | DWord | `0` | Brave Yalnız | Windows·Linux | Arama dizini katkısı |
| 13 | `TorDisabled` | DWord | `1` | Brave Yalnız | Windows·Linux | Tor entegrasyon kod yolu |
| 14 | `BraveDeAmpEnabled` | DWord | `1` | Brave Yalnız | Windows·Linux | AMP atlatma |
| 15 | `BraveDebouncingEnabled` | DWord | `1` | Brave Yalnız | Windows·Linux | Sıçrama izleme |
| 16 | `BraveReduceLanguageEnabled` | DWord | `1` | Brave Yalnız | Windows·Linux | Dil parmak izi |
| 17 | `BraveTrackingQueryParametersFilteringEnabled` | DWord | `1` | Brave Yalnız | Windows·Linux | URL izleme parametreleri |
| 18 | `DefaultBraveAdblockSetting` | DWord | `2` | Brave Yalnız | Windows·Linux | Kalkan reklam engelleme düzeyi |
| 19 | `DefaultBraveFingerprintingV2Setting` | DWord | `3` | Brave Yalnız | Windows·Linux | Kalkan parmak izi düzeyi |
| 20 | `BraveShieldsDisabledForUrls` | MultiString | `@()` | Brave Yalnız | Windows·Linux | Kalkan atlama listesi |
| 21 | `BraveShieldsEnabledForUrls` | MultiString | `@()` | Brave Yalnız | Windows·Linux | Kalkan zorlama listesi |
| 22 | `EmailAliasesEnabled` | DWord | `0` | Brave Yalnız | Windows·Linux | Anonim e-posta takma adları |
| 23 | `SafeBrowsingProtectionLevel` | DWord | `2` | Brave Yalnız | Windows·Linux | Safe Browsing koruma düzeyi |
| 24 | `PasswordProtectionWarningTrigger` | DWord | `3` | Brave Yalnız | Windows·Linux | Parola sızıntısı uyarı tetikleyici |
| 25 | `NotificationsAllowedForUrls` | MultiString | `@("https://web.whatsapp.com")` | Brave Yalnız | Windows·Linux | WhatsApp Web bildirimlerine izin verir, diğer tüm kaynaklar engelli kalır |
| 26 | `MetricsReportingEnabled` | DWord | `0` | Temel | Windows·Linux | Chromium kullanım/çökme metrikleri |
| 27 | `UrlKeyedAnonymizedDataCollectionEnabled` | DWord | `0` | Temel | Windows·Linux | Ziyaret edilen URL'ler Google'a |
| 28 | `SearchSuggestEnabled` | DWord | `0` | Temel | Windows·Linux | Tuş vuruşu veri sızıntısı |
| 29 | `NetworkPredictionOptions` | DWord | `2` | Temel | Windows·Linux | DNS ön getirme / ön bağlantı |
| 30 | `SpellcheckEnabled` | DWord | `1` | Temel | Windows·Linux | Yazım denetimi (yerel motor) |
| 31 | `AlternateErrorPagesEnabled` | DWord | `0` | Temel | Windows·Linux | DNS hatasında ağ istekleri |
| 32 | `BrowserNetworkTimeQueriesEnabled` | DWord | `0` | Temel | Windows·Linux | Google'a zaman senkronizasyonu |
| 33 | `DomainReliabilityAllowed` | DWord | `0` | Temel | Windows·Linux | Google'a tanı verisi |
| 34 | `BackgroundModeEnabled` | DWord | `0` | Temel | Windows·Linux | Arka plan işlem izleme |
| 35 | `SafeBrowsingSurveysEnabled` | DWord | `0` | Temel | Windows·Linux | Gezinti sonrası anketler |
| 36 | `WebRtcEventLogCollectionAllowed` | DWord | `0` | Temel | Windows·Linux | WebRTC olay günlükleri Google'a |
| 37 | `WebRtcTextLogCollectionAllowed` | DWord | `0` | Temel | Windows·Linux | WebRTC metin günlükleri Google'a |
| 38 | `AudioCaptureAllowed` | DWord | `0` | Temel | Windows·Linux | Mikrofon erişimi |
| 39 | `VideoCaptureAllowed` | DWord | `0` | Temel | Windows·Linux | Kamera erişimi |
| 40 | `BraveGlobalPrivacyControlEnabled` | DWord | `1` | Temel | Windows·Linux | GPC başlığı |
| 41 | `DefaultWebUsbGuardSetting` | DWord | `2` | Temel | Windows·Linux | USB cihaz erişimi |
| 42 | `DefaultWebBluetoothGuardSetting` | DWord | `2` | Temel | Windows·Linux | Bluetooth cihaz erişimi |
| 43 | `DefaultWebHidGuardSetting` | DWord | `2` | Temel | Windows·Linux | HID cihaz erişimi |
| 44 | `EncryptedClientHelloEnabled` | DWord | `1` | Temel | Windows·Linux | TLS ClientHello şifreleme |
| 45 | `PaymentMethodQueryEnabled` | DWord | `0` | Temel | Windows·Linux | Ödeme yöntemi parmak izi |
| 46 | `SuppressDifferentOriginSubframeDialogs` | DWord | `1` | Temel | Windows·Linux | Farklı köken alt çerçeve diyalogları |
| 47 | `EnableOnlineRevocationChecks` | DWord | `1` | Temel | Windows·Linux | Sertifika iptal kontrolleri |
| 48 | `ProxySettings` | String | `{"ProxyMode":"system"}` | Temel | Windows·Linux | Vekil sunucu yapılandırması |
| 49 | `ExtensionInstallSources` | MultiString | `@()` | Temel | Windows·Linux | Eklenti yükleme kaynakları |
| 50 | `ScreenCaptureAllowed` | DWord | `0` | Temel | Windows·Linux | Ekran yakalama API'si |
| 51 | `DownloadRestrictions` | DWord | `4` | Temel | Windows·Linux | Tehlikeli indirme uyarıları bastırılır |
| 52 | `WebRtcIPHandling` | String | `disable_non_proxied_udp` | Dengeli | Windows·Linux | WebRTC IP ifşası |
| 53 | `WebRtcLocalIpsAllowedUrls` | MultiString | `@()` | Dengeli | Windows·Linux | ICE yoluyla yerel IP |
| 54 | `HttpsOnlyMode` | String | `force_enabled` | Dengeli | Windows·Linux | HTTPS zorlaması |
| 55 | `DnsOverHttpsMode` | String | `automatic` | Dengeli | Windows·Linux | Şifreli DNS |
| 56 | `BlockThirdPartyCookies` | DWord | `1` | Dengeli | Windows·Linux | Siteler arası izleme |
| 57 | `PasswordManagerEnabled` | DWord | `0` | Dengeli | Windows·Linux | Yerleşik parola depolama |
| 58 | `PasswordManagerPasskeysEnabled` | DWord | `0` | Dengeli | Windows·Linux | Passkey depolama |
| 59 | `AutofillSettings` | String | `[{"url_pattern":"*","blocked_types":["all"]}]` | Dengeli | Windows·Linux | Tüm otomatik doldurma veri türlerini engeller |
| 60 | `ShowFullUrlsInAddressBar` | DWord | `1` | Dengeli | Windows·Linux | Oltalama önleme URL gösterimi |
| 61 | `QuicAllowed` | DWord | `0` | Dengeli | Windows·Linux | QUIC protokolü |
| 62 | `ChromeVariations` | DWord | `1` | Dengeli | Windows·Linux | Yalnızca kritik alan denemeleri |
| 63 | `NetworkServiceSandboxEnabled` | DWord | `1` | Dengeli | Windows·Linux | Ağ kum havuzu |
| 64 | `AudioSandboxEnabled` | DWord | `1` | Dengeli | Windows·Linux | Ses kum havuzu |
| 65 | `DefaultGeolocationSetting` | DWord | `2` | Dengeli | Windows·Linux | Cihaz konumu erişimi |
| 66 | `DefaultNotificationsSetting` | DWord | `2` | Dengeli | Windows·Linux | Bildirim istemleri |
| 67 | `DefaultPopupsSetting` | DWord | `2` | Dengeli | Windows·Linux | Açılır pencereler |
| 68 | `DefaultBraveHttpsUpgradeSetting` | DWord | `2` | Dengeli | Windows·Linux | Brave HTTPS yükseltme |
| 69 | `DefaultBraveReferrersSetting` | DWord | `2` | Dengeli | Windows·Linux | Brave yönlendiren sınırı |
| 70 | `BraveSyncUrl` | String | `https://sync-v2.brave.com/v2` | Dengeli | Windows·Linux | Senkronizasyon sunucu URL'si |
| 71 | `DefaultWindowManagementSetting` | DWord | `2` | Dengeli | Windows·Linux | Pencere yönetimi izni |
| 72 | `SitePerProcess` | DWord | `1` | Dengeli | Windows·Linux | Site izolasyonu |
| 73 | `IntensiveWakeUpThrottlingEnabled` | DWord | `1` | Dengeli | Windows·Linux | Arka plan zamanlayıcı kısıtlaması |
| 74 | `UserFeedbackAllowed` | DWord | `0` | Dengeli | Windows·Linux | Kullanıcı geri bildirim istemleri |
| 75 | `ExtensionInstallForcelist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh;…, maafgiompdekodanheihhgilkjchcakm;https://outlook.office.com/owa/SmimeCrxUpdate.ashx` | Dengeli | Windows·Linux | Zorunlu eklenti |
| 76 | `DownloadDirectory` | ExpandString | `${env:USERPROFILE}\Downloads\` | Dengeli | Windows·Linux | İndirme yolu |
| 77 | `PromptForDownloadLocation` | DWord | `0` | Dengeli | Windows·Linux | İndirme konumu istemi |
| 78 | `RelaunchNotification` | DWord | `2` | Dengeli | Windows·Linux | Tarayıcı yeniden başlatma bildirimi |
| 79 | `RelaunchNotificationPeriod` | DWord | `3600000` | Dengeli | Windows·Linux | Yeniden başlatma zamanlayıcı (1 saat) |
| 80 | `LocalNetworkAccessPermissionsPolicyDefaultEnabled` | DWord | `0` | Dengeli | Windows·Linux | Yerel ağ izin varsayılanı |
| 81 | `GenAILocalFoundationalModelSettings` | DWord | `1` | Dengeli | Windows·Linux | Cihaz içi yapay zeka modeli |
| 82 | `DisableSafeBrowsingProceedAnyway` | DWord | `1` | Dengeli | Windows·Linux | Kötü amaçlı yazılım uyarı atlama |
| 83 | `DefaultSensorsSetting` | DWord | `2` | İleri | Windows·Linux | Hareket/ışık sensörleri |
| 84 | `DefaultLocalFontsSetting` | DWord | `2` | İleri | Windows·Linux | Yazı tipi parmak izi |
| 85 | `DefaultSerialGuardSetting` | DWord | `2` | İleri | Windows·Linux | Serial API erişimi |
| 86 | `DefaultIdleDetectionSetting` | DWord | `2` | İleri | Windows·Linux | Boşta algılama |
| 87 | `BrowserGuestModeEnabled` | DWord | `0` | İleri | Windows·Linux | Misafir profili |
| 88 | `BrowserAddPersonEnabled` | DWord | `0` | İleri | Windows·Linux | Yeni profil oluşturma |
| 89 | `ImportAutofillFormData` | DWord | `0` | İleri | Windows·Linux | Tarayıcılar arası otomatik doldurma |
| 90 | `ImportHistory` | DWord | `0` | İleri | Windows·Linux | Tarayıcılar arası geçmiş |
| 91 | `ImportSavedPasswords` | DWord | `0` | İleri | Windows·Linux | Tarayıcılar arası parolalar |
| 92 | `ImportSearchEngine` | DWord | `0` | İleri | Windows·Linux | Tarayıcılar arası arama motoru |
| 93 | `ImportHomepage` | DWord | `0` | İleri | Windows·Linux | Tarayıcılar arası ana sayfa |
| 94 | `ExtensionInstallBlocklist` | MultiString | `*` | İleri | Windows·Linux | Eklenti engelleme listesi |
| 95 | `ExtensionInstallAllowlist` | MultiString | `eimadpbcbfnmbkopoojfekhnkhdbieeh, maafgiompdekodanheihhgilkjchcakm` | İleri | Windows·Linux | Eklenti izin listesi |
| 96 | `ExtensionAllowedTypes` | MultiString | `extension` | İleri | Windows·Linux | İzin verilen eklenti türleri |
| 97 | `BlockExternalExtensions` | DWord | `1` | İleri | Windows·Linux | Harici eklenti yükleme |
| 98 | `ExtensionSettings` | String | `{"*":{"installation_mode":"blocked"},…,"maafgiompdekodanheihhgilkjchcakm":{"installation_mode":"allowed","override_update_url":true}}` | İleri | Windows·Linux | Eklenti politika matrisi |
| 99 | `NativeMessagingAllowlist` | MultiString | `com.microsoft.outlook.smime.chromenativeapp` | İleri | Windows·Linux | S/MIME yerel mesajlaşma ana bilgisayarı |
| 100 | `NativeMessagingUserLevelHosts` | DWord | `1` | İleri | Windows·Linux | Kullanıcı düzeyi yerel mesajlaşma ana bilgisayarları |
| 101 | `BuiltInDnsClientEnabled` | DWord | `0` | İleri | Windows·Linux | Yerleşik DNS istemcisi |
| 102 | `ShowHomeButton` | DWord | `0` | İleri | Windows·Linux | Ana sayfa düğmesi görünürlüğü |
| 103 | `HideWebStoreIcon` | DWord | `1` | İleri | Windows·Linux | Web Mağazası simgesi |
| 104 | `DefaultJavaScriptSetting` | DWord | `0` | İleri | Windows·Linux | JavaScript çalıştırma |
| 105 | `GeminiSettings` | DWord | `1` | İleri | Windows·Linux | Gemini AI önerileri |
| 106 | `AIModeSettings` | DWord | `1` | İleri | Windows·Linux | Arama'da AI Modu |
| 107 | `AutofillPredictionSettings` | DWord | `2` | İleri | Windows·Linux | Otomatik doldurma tahminleri |
| 108 | `ChromeSuggestionsSettings` | DWord | `1` | İleri | Windows·Linux | Chrome önerileri |
| 109 | `CreateThemesSettings` | DWord | `2` | İleri | Windows·Linux | Tema oluşturma |
| 110 | `DevToolsGenAiSettings` | DWord | `2` | İleri | Windows·Linux | Geliştirici araçları AI asistanı |
| 111 | `HelpMeWriteSettings` | DWord | `2` | İleri | Windows·Linux | Yazmaya Yardım Et |
| 112 | `HistorySearchSettings` | DWord | `2` | İleri | Windows·Linux | Geçmiş arama |
| 113 | `SearchContentSharingSettings` | DWord | `1` | İleri | Windows·Linux | Arama içeriği paylaşma |
| 114 | `SmartTabSharingSettings` | DWord | `1` | İleri | Windows·Linux | Akıllı sekme paylaşma |
| 115 | `TabCompareSettings` | DWord | `2` | İleri | Windows·Linux | Sekme karşılaştırma |
| 116 | `GeminiActOnWebSettings` | DWord | `1` | İleri | Windows·Linux | Gemini web işlemleri |
| 117 | `GeminiSparkSettings` | DWord | `1` | İleri | Windows·Linux | Gemini sayfa kıvılcımı |
| 118 | `RendererAppContainerEnabled` | DWord | `1` | İleri | Windows·Linux | İşleyici kum havuzu |
| 119 | `LocalNetworkAccessAllowedForUrls` | MultiString | `@()` | İleri | Windows·Linux | Yerel ağ izin listesi |
| 120 | `LocalNetworkAccessBlockedForUrls` | MultiString | `@()` | İleri | Windows·Linux | Yerel ağ engelleme listesi |
| 121 | `LocalNetworkAccessIpAddressSpaceOverrides` | MultiString | `@()` | İleri | Windows·Linux | Yerel ağ IP overrides |
| 122 | `LocalNetworkAccessRestrictionsTemporaryOptOut` | DWord | `0` | İleri | Windows·Linux | Yerel ağ çıkış seçeneği |
| 123 | `TranslateEnabled` | DWord | `0` | Katı | Windows·Linux | Google'a çeviri için metin |
| 124 | `DefaultClipboardSetting` | DWord | `2` | Katı | Windows·Linux | Pano okuma/yazma |
| 125 | `DefaultFileSystemReadGuardSetting` | DWord | `2` | Katı | Windows·Linux | Dosya sistemi okuma |
| 126 | `DefaultFileSystemWriteGuardSetting` | DWord | `2` | Katı | Windows·Linux | Dosya sistemi yazma |
| 127 | `DefaultInsecureContentSetting` | DWord | `2` | Katı | Windows·Linux | Karma içerik |
| 128 | `DefaultJavaScriptJitSetting` | DWord | `2` | Katı | Windows·Linux | JIT derleme |
| 129 | `DefaultCookiesSetting` | DWord | `2` | Katı | Windows·Linux | Tüm çerezler |
| 130 | `ImportBookmarks` | DWord | `0` | Katı | Windows·Linux | Tarayıcılar arası yer imleri |
| 131 | `DefaultBraveRemember1PStorageSetting` | DWord | `2` | Katı | Windows·Linux | Birinci taraf depolama |
| 132 | `IncognitoModeAvailability` | DWord | `1` | Katı | Windows·Linux | Gizli mod |
| 133 | `TaskManagerEndProcessEnabled` | DWord | `0` | Katı | Windows·Linux | Görev Yöneticisi |
| 134 | `PrintingEnabled` | DWord | `0` | Katı | Windows·Linux | Yazdırma işlevi |
| 135 | `DisablePrintPreview` | DWord | `1` | Katı | Windows·Linux | Yazdırma önizleme |
| 136 | `SafeBrowsingDeepScanningEnabled` | DWord | `0` | Katı | Windows·Linux | Sunucu tarafı indirme taraması |
| 137 | `DeveloperToolsAvailability` | DWord | `2` | Katı | Windows·Linux | Geliştirici araçları |
| 138 | `BrowsingDataLifetime` | String | `{"data_types"=@(…);"time_to_live…"=24}` | Katı | Windows·Linux | Otomatik gezinti verisi temizleme |
| 139 | `AlwaysOpenPdfExternally` | DWord | `1` | Katı | Windows·Linux | Yerleşik PDF görüntüleyici |
| 140 | `CertificateTransparencyEnforcementDisabledForUrls` | MultiString | `@()` | Katı | Windows·Linux | Sertifika Saydamlığı |
| 141 | `PasswordLeakDetectionEnabled` | DWord | `1` | Katı | Windows·Linux | Parola sızıntısı algılama |
| 142 | `SpellCheckServiceEnabled` | DWord | `0` | Katı | Windows·Linux | Yazım denetimi ağ hizmeti |
| 143 | `BrowserSignin` | DWord | `0` | Katı | Windows·Linux | Chrome giriş istemi |
| 144 | `SyncDisabled` | DWord | `1` | Katı | Windows·Linux | Brave Sync |
| 145 | `ScreenCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows·Linux | Ekran yakalama izin listesi |
| 146 | `SameOriginTabCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows·Linux | Aynı köken sekme yakalama |
| 147 | `TabCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows·Linux | Sekme yakalama izin listesi |
| 148 | `WindowCaptureAllowedByOrigins` | MultiString | `@()` | Katı | Windows·Linux | Pencere yakalama izin listesi |
| 149 | `LocalNetworkAllowedForUrls` | MultiString | `@()` | Katı | Windows·Linux | Yerel ağ yakalama izin listesi |
| 150 | `LocalNetworkBlockedForUrls` | MultiString | `@()` | Katı | Windows·Linux | Yerel ağ yakalama engelleme listesi |

---

## Katman Bazında Dağılım

### Brave Yalnız — 25 politika
Tüm Brave'e özgü özellikler devre dışı bırakıldı veya kısıtlandı. Güç kullanıcıları için sıfır kullanılabilirlik etkisi.

### Temel — 26 politika (+26 = 51 kümülatif)
Veri sızıntısı önleme. Kullanılabilirlik etkisi yok. Tüm Chromium/Brave telemetrisini, arka plan ağ iletişimini ve medya yakalamayı durdurur. USB/Bluetooth/HID cihaz erişimini engeller.

### Dengeli — 31 politika (+31 = 82 kümülatif)
Güvenlik ve kullanım dengesi. WebRTC sıkılaştırması, şifreli DNS, çerez engelleme, parola/otomatik doldurma devre dışı bırakma, izin varsayılanları, site izolasyonu, indirme kontrolleri, Dark Reader eklentisi.

### İleri — 40 politika (+40 = 122 kümülatif)
Genişletilmiş sıkılaştırma. Sensörler, yazı tipleri, seri bağlantı noktası, boşta algılama, misafir modu, tarayıcılar arası içe aktarmalar, eklenti kısıtlamaları, JavaScript varsayılanı kapalı, yapay zeka özellikleri devre dışı.

### Katı — 29 politika (+29 = 150 kümülatif)
Azami gizlilik. Çeviri, pano, dosya sistemi, JIT, çerezler, yazdırma, indirmeler, geliştirici araçları, bulut raporlama devre dışı. Gezinti verilerini her 24 saatte bir otomatik temizler.

---

## Tür Dağılımı

| Tür | Adet | Yüzde |
|-----|------|-------|
| DWord | 121 | %80,7 |
| String | 8 | %5,3 |
| MultiString | 20 | %13,3 |
| ExpandString | 1 | %0,7 |
| **Toplam (benzersiz)** | **150** | **%100** |

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
| Linux | `Install-OmegaLinux.sh` | Yalnızca Brave Yalnız katmanı, Chromium politika JSON'u ile |

25 Brave Yalnız politikasının tamamı yönetilen JSON kurucusu aracılığıyla Linux'ta da uygulanır; macOS desteği planlanmaktadır. Windows, politikaları HKLM'de mühürler ve Omaha GUID'ine bağlar.
