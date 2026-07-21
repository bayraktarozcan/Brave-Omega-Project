> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 📋 Policy Reference — Complete Registry Table

Complete policy reference for Brave Omega v2.5.0.0 — **150 enterprise policies** across 5 progressive restriction levels.

---

## Level Overview

| Level | Own Policies | HKCU | HKLM | Cumulative Total |
| ------- | ---------- | ------ | ------ | ------------ |
| **1. Brave Only** | 24 | — | 24 | Base |
| **2. Essential** ⭐ | 29 | UsageStatsInSample | 53 | Includes Level 1 |
| **3. Balanced** | 33 | UsageStatsInSample | 86 | Includes Levels 1-2 |
| **4. Advanced** | 38 | UsageStatsInSample | 124 | Includes Levels 1-3 |
| **5. Strict** | 27 | UsageStatsInSample | 150 | Includes Levels 1-4 |

## Policy Reference by Level

> All 150 enterprise policies are listed below — no need to consult the script. Policies are organized by registry hive and hardening level.

### HKCU — User-Level Preferences (all levels)

| Registry Key | Hive | Value | Type | Effect |
| -------------- | ------ | ------- | ------ | -------- |
| `UsageStatsInSample` | HKCU | `0` | DWord | Disables browser-level usage statistics sampling |
| `ChromeVariations` | HKCU | `1` | DWord | Restricts Chromium to critical field trials only |
| `usagestats` *(per GUID)* | HKCU | `0` | DWord | Disables Omaha updater telemetry per application GUID |

### Brave Only Level — Brave-Specific Policies (24)

| Registry Key | Value | Type | Effect |
| -------------- | ------- | ------ | -------- |
| `BraveRewardsDisabled` | `1` | DWord | Removes Rewards ad system, BAT token earning |
| `BraveWalletDisabled` | `1` | DWord | Removes integrated crypto wallet, Web3, dDNS |
| `BraveVPNDisabled` | `1` | DWord | Removes VPN button, blocks VPN background service |
| `BraveAIChatEnabled` | `0` | DWord | Disables Leo AI Chat engine |
| `BraveTalkDisabled` | `1` | DWord | Disables Brave Talk video conferencing |
| `BraveNewsDisabled` | `1` | DWord | Disables Brave News feed on New Tab Page |
| `BravePlaylistEnabled` | `0` | DWord | Disables Brave Playlist offline media |
| `BraveSpeedreaderEnabled` | `0` | DWord | Disables Speedreader mode |
| `BraveWaybackMachineEnabled` | `0` | DWord | Disables Wayback Machine integration |
| `BraveP3AEnabled` | `0` | DWord | Disables P3A data transmission |
| `BraveStatsPingEnabled` | `0` | DWord | Stops status/authentication pings to Brave |
| `BraveWebDiscoveryEnabled` | `0` | DWord | Disables Web Discovery Project contribution |
| `TorDisabled` | `1` | DWord | Disables Tor integration |
| `SafeBrowsingProtectionLevel` | `2` | DWord | Enforces standard Safe Browsing protection |
| `PasswordProtectionWarningTrigger` | `3` | DWord | Enables password reuse warning |
| `BraveDeAmpEnabled` | `1` | DWord | Disables Brave De-AMP |
| `BraveDebouncingEnabled` | `1` | DWord | Disables Brave Debouncing |
| `BraveReduceLanguageEnabled` | `1` | DWord | Disables language header reduction |
| `BraveTrackingQueryParametersFilteringEnabled` | `1` | DWord | Disables tracking query parameter filtering |
| `DefaultBraveAdblockSetting` | `2` | DWord | Sets aggressive ad blocking |
| `DefaultBraveFingerprintingV2Setting` | `2` | DWord | Sets aggressive fingerprinting protection |
| `BraveShieldsDisabledForUrls` | `@()` | MultiString | No URLs excluded from Shields |
| `BraveShieldsEnabledForUrls` | `@()` | MultiString | No URLs force-enabled for Shields |
| `EmailAliasesEnabled` | `0` | DWord | Disables Brave email aliases |

### Essential Level — Brave Only + Data Leak Prevention (29 total)

| Registry Key | Value | Type | Effect |
| -------------- | ------- | ------ | -------- |
| `MetricsReportingEnabled` | `0` | DWord | Disables Chromium core metrics collection |
| `SafeBrowsingExtendedReportingEnabled` | `0` | DWord | Stops extended site data to Google |
| `UrlKeyedAnonymizedDataCollectionEnabled` | `0` | DWord | Stops URL data collection to Google |
| `SearchSuggestEnabled` | `0` | DWord | Stops search suggestions data leakage |
| `EnableOnlineRevocationChecks` | `1` | DWord | Enables online OCSP/CRL revocation checks |
| `NetworkPredictionOptions` | `2` | DWord | Stops DNS prefetching and pre-connection |
| `SpellcheckEnabled` | `1` | DWord | Enables local Hunspell spellcheck (offline-only, no data sent) |
| `AlternateErrorPagesEnabled` | `0` | DWord | Stops error page network requests |
| `BrowserNetworkTimeQueriesEnabled` | `0` | DWord | Stops time sync to Google |
| `DomainReliabilityAllowed` | `0` | DWord | Stops diagnostic data reporting |
| `BackgroundModeEnabled` | `0` | DWord | Prevents Brave running when all windows closed |
| `SafeBrowsingSurveysEnabled` | `0` | DWord | Disables post-browsing surveys |
| `SafeBrowsingDeepScanningEnabled` | `0` | DWord | Disables server-side download scanning |
| `WebRtcEventLogCollectionAllowed` | `0` | DWord | Stops WebRTC event log upload |
| `WebRtcTextLogCollectionAllowed` | `0` | DWord | Stops WebRTC text log upload |
| `AudioCaptureAllowed` | `0` | DWord | Blocks microphone by default |
| `VideoCaptureAllowed` | `0` | DWord | Blocks camera by default |
| `BraveGlobalPrivacyControlEnabled` | `1` | DWord | Enables Global Privacy Control |
| `DefaultWebUsbGuardSetting` | `2` | DWord | Blocks WebUSB by default |
| `DefaultWebBluetoothGuardSetting` | `2` | DWord | Blocks WebBluetooth by default |
| `DefaultWebHidGuardSetting` | `2` | DWord | Blocks WebHID by default |
| `DeviceAttributesAllowedForOrigins` | `@()` | MultiString | Blocks device attribute disclosure |
| `EncryptedClientHelloEnabled` | `1` | DWord | Enables Encrypted Client Hello |
| `PaymentMethodQueryEnabled` | `0` | DWord | Blocks payment method queries |
| `SuppressDifferentOriginSubframeDialogs` | `1` | DWord | Suppresses cross-origin subframe dialogs |
| `ProxySettings` | `{"mode":"direct"}` | String | Disables proxy (direct connection) |
| `BrowserSignin` | `0` | DWord | **[Phase 9]** Disables Google browser sign-in |
| `ExtensionInstallSources` | `@()` | MultiString | **[Phase 9]** Blocks all non-store extension sources |
| `ScreenCaptureAllowed` | `0` | DWord | Blocks web capture APIs (getDisplayMedia, etc.); Windows native tools still work |

### Balanced Level — Essential + Security Baseline (33 total)

| Registry Key | Value | Type | Effect |
| -------------- | ------- | ------ | -------- |
| `WebRtcIPHandling` | `"disable_non_proxied_udp"` | String | Proxies all WebRTC traffic |
| `WebRtcLocalIpsAllowedUrls` | `@()` | MultiString | Prevents local IP disclosure via ICE |
| `HttpsOnlyMode` | `"force_enabled"` | String | Forces all navigations to HTTPS |
| `DnsOverHttpsMode` | `"automatic"` | String | Encrypts DNS queries |
| `BlockThirdPartyCookies` | `1` | DWord | Blocks cross-site tracking cookies |
| `PasswordManagerEnabled` | `0` | DWord | Disables built-in password saving |
| `PasswordManagerPasskeysEnabled` | `0` | DWord | Disables passkey saving |
| `AutofillAddressEnabled` | `0` | DWord | Disables address autofill |
| `AutofillCreditCardEnabled` | `0` | DWord | Disables credit card autofill |
| `ShowFullUrlsInAddressBar` | `1` | DWord | Shows full URLs (anti-phishing) |
| `DisableSafeBrowsingProceedAnyway` | `1` | DWord | Prevents bypassing malware warnings |
| `QuicAllowed` | `0` | DWord | Disables QUIC, falls back to TCP/TLS |
| `ChromeVariations` | `1` | DWord | Critical field trials only |
| `NetworkServiceSandboxEnabled` | `1` | DWord | Sandboxes network service |
| `AudioSandboxEnabled` | `1` | DWord | Sandboxes audio service |
| `DefaultGeolocationSetting` | `2` | DWord | Blocks location by default |
| `DefaultNotificationsSetting` | `2` | DWord | Blocks notifications by default |
| `DefaultPopupsSetting` | `2` | DWord | Blocks pop-ups by default |
| `DefaultBraveHttpsUpgradeSetting` | `2` | DWord | Forces HTTPS upgrades |
| `DefaultBraveReferrersSetting` | `2` | DWord | Blocks referrer headers |
| `BraveSyncUrl` | `""` | String | Disables Brave Sync |
| `DefaultWindowManagementSetting` | `2` | DWord | Blocks window management API |
| `SitePerProcess` | `1` | DWord | Forces site-per-process isolation |
| `IntensiveWakeUpThrottlingEnabled` | `1` | DWord | Enables intensive wake-up throttling |
| `UserFeedbackAllowed` | `0` | DWord | Disables user feedback |
| `ExtensionInstallForcelist` | `@("eimadpbcbfnmbkopoojfekhnkhdbieeh")` | MultiString | Force-installs Dark Reader |
| `DownloadRestrictions` | `1` | DWord | Warns before dangerous downloads |
| `DownloadDirectory` | `"%USERPROFILE%\Downloads\"` | String | Sets default download directory |
| `PromptForDownloadLocation` | `0` | DWord | Uses default download directory without prompting |
| `RelaunchNotification` | `2` | DWord | **[Phase 9]** Mandatory relaunch after update |
| `RelaunchNotificationPeriod` | `3600000` | DWord | **[Phase 9]** 1-hour delay before forced relaunch |
| `LocalNetworkAccessPermissionsPolicyDefaultEnabled` | `0` | DWord | Disables auto-approval of local network permission requests in sub-frames |
| `GenAILocalFoundationalModelSettings` | `1` | DWord | Disables local AI model download (moved from Advanced) |

### Advanced Level — Balanced + Enhanced Privacy (38 total)

| Registry Key | Value | Type | Effect |
| -------------- | ------- | ------ | -------- |
| `DefaultSensorsSetting` | `2` | DWord | Blocks sensor access by default |
| `DefaultLocalFontsSetting` | `2` | DWord | Blocks font enumeration |
| `DefaultSerialGuardSetting` | `2` | DWord | Blocks Serial API |
| `DefaultIdleDetectionSetting` | `2` | DWord | Blocks idle detection |
| `BrowserGuestModeEnabled` | `0` | DWord | Prevents guest profiles |
| `BrowserAddPersonEnabled` | `0` | DWord | Prevents new profiles |
| `ImportAutofillFormData` | `0` | DWord | Disables autofill import |
| `ImportHistory` | `0` | DWord | Disables history import |
| `ImportSavedPasswords` | `0` | DWord | Disables password import |
| `ImportSearchEngine` | `0` | DWord | Disables search engine import |
| `ImportHomepage` | `0` | DWord | Disables homepage import |
| `ExtensionInstallBlocklist` | `@("*")` | MultiString | Blocks all extensions except allowlist |
| `ExtensionInstallAllowlist` | `@("eimadpbcbfnmbkopoojfekhnkhdbieeh")` | MultiString | Allows only Dark Reader |
| `ExtensionAllowedTypes` | `@("extension", "shared_module")` | MultiString | Restricts extension types |
| `BlockExternalExtensions` | `1` | DWord | Prevents sideloaded extensions |
| `ExtensionSettings` | `{"*":{"installation_mode":"blocked"},"eimadpbcbfnmbkopoojfekhnkhdbieeh":{"installation_mode":"allowed"}}` | String | JSON backup layer for extension control |
| `BuiltInDnsClientEnabled` | `0` | DWord | Disables built-in DNS client (uses system DNS) |
| `ShowHomeButton` | `0` | DWord | **[Phase 9]** Hides home button from toolbar |
| `HideWebStoreIcon` | `1` | DWord | **[Phase 9]** Hides Chrome Web Store icon |
| `DefaultJavaScriptSetting` | `0` | DWord | **[Phase 9]** Allows JavaScript by default |
| `GeminiSettings` | `1` | DWord | **[Phase 9]** Disables Gemini AI integration |
| `AIModeSettings` | `1` | DWord | Blocks Chrome AI Mode entirely |
| `AutofillPredictionSettings` | `2` | DWord | Disables AI-powered autofill predictions |
| `ChromeSuggestionsSettings` | `1` | DWord | Disables AI-powered suggestions |
| `CreateThemesSettings` | `2` | DWord | Disables AI theme creation |
| `DevToolsGenAiSettings` | `2` | DWord | Disables AI in DevTools |
| `HelpMeWriteSettings` | `2` | DWord | Disables AI writing assistant |
| `HistorySearchSettings` | `2` | DWord | Disables AI-powered history search |
| `SearchContentSharingSettings` | `1` | DWord | Disables AI content sharing |
| `SmartTabSharingSettings` | `1` | DWord | Disables AI tab sharing |
| `TabCompareSettings` | `2` | DWord | Disables AI tab comparison |
| `GeminiActOnWebSettings` | `1` | DWord | Disables Gemini integration on web pages |
| `GeminiSparkSettings` | `1` | DWord | Disables Gemini Spark features |
| `RendererAppContainerEnabled` | `1` | DWord | Enables renderer process sandbox |
| `LocalNetworkAccessAllowedForUrls` | `@()` | MultiString | Exempt certain URLs from LNA checks |
| `LocalNetworkAccessBlockedForUrls` | `@()` | MultiString | Block certain URLs from local network access |
| `LocalNetworkAccessIpAddressSpaceOverrides` | `@()` | MultiString | Empty list uses default IP mappings |
| `LocalNetworkAccessRestrictionsTemporaryOptOut` | `0` | DWord | Disables temporary opt-out from LNA restrictions |

### Strict Level — Advanced + Maximum Privacy (27 total)

| Registry Key | Value | Type | Effect |
| -------------- | ------- | ------ | -------- |
| `TranslateEnabled` | `0` | DWord | Disables built-in translation |
| `DeveloperToolsAvailability` | `2` | DWord | Disables developer tools in all contexts |
| `DefaultClipboardSetting` | `2` | DWord | Blocks clipboard by default |
| `DefaultFileSystemReadGuardSetting` | `2` | DWord | Blocks file system read |
| `DefaultFileSystemWriteGuardSetting` | `2` | DWord | Blocks file system write |
| `DefaultInsecureContentSetting` | `2` | DWord | Blocks mixed content |
| `DefaultJavaScriptJitSetting` | `2` | DWord | Disables JIT compilation |
| `DefaultCookiesSetting` | `2` | DWord | Blocks all cookies by default |
| `ImportBookmarks` | `0` | DWord | Disables bookmark import |
| `DefaultBraveRemember1PStorageSetting` | `2` | DWord | Forgets first-party storage on tab/nav end |
| `IncognitoModeAvailability` | `1` | DWord | Forces incognito mode off |
| `TaskManagerEndProcessEnabled` | `0` | DWord | Disables task manager process ending |
| `PrintingEnabled` | `0` | DWord | Disables printing entirely |
| `DisablePrintPreview` | `1` | DWord | Disables print preview system dialog |
| `DownloadRestrictions` | `3` | DWord | Blocks ALL downloads (overrides Balanced value of 1) |
| `ScreenCaptureAllowedByOrigins` | `@()` | MultiString | Empty list blocks all origins from screen capture |
| `SameOriginTabCaptureAllowedByOrigins` | `@()` | MultiString | Empty list blocks all same-origin tab capture |
| `TabCaptureAllowedByOrigins` | `@()` | MultiString | Empty list blocks all tab capture |
| `WindowCaptureAllowedByOrigins` | `@()` | MultiString | Empty list blocks all window capture |
| `LocalNetworkAllowedForUrls` | `@()` | MultiString | Exempt certain URLs from local network blocking |
| `LocalNetworkBlockedForUrls` | `@()` | MultiString | Block certain URLs from local network access |
| `BrowsingDataLifetime` | `{"data_types":["browsing_history","download_history","cached_images_and_files"],"time_to_live_in_hours":24}` | String | **[Phase 9]** Auto-clears browsing data every 24h |
| `AlwaysOpenPdfExternally` | `1` | DWord | **[Phase 9]** Opens PDFs externally (exploit mitigation) |
| `CertificateTransparencyEnforcementDisabledForUrls` | `@()` | MultiString | **[Phase 9]** Enforces CT for all sites (no exemptions) |
| `PasswordLeakDetectionEnabled` | `1` | DWord | **[Phase 9]** Checks leaked passwords against breach DB |
| `SpellCheckServiceEnabled` | `0` | DWord | **[Phase 9]** Disables online Google spellcheck service |
| `SyncDisabled` | `1` | DWord | **[Phase 9]** Disables Chrome Sync |

---

## Registry Paths

| Hive | Path |
| ------ | ------ |
| **HKCU (Tier 1)** | `HKCU:\Software\BraveSoftware\Brave-Browser` |
| **HKLM (Tier 2)** | `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` |
| **Omaha GUID (Tier 3)** | `HKCU:\Software\BraveSoftware\Update\ClientState\{GUID}` |

---

## Verification

After running Brave Omega, verify all policies at:

```
brave://policy
```

All 150 policies should show as **Active** (green checkmark).

---

## Excluded Policies (Documented)

| Policy | Reason |
|--------|--------|
| `BraveShieldsDefault` | Not in Brave's official ADMX templates. Shields managed via URL-based policies (`BraveShieldsEnabledForUrls`, `BraveShieldsDisabledForUrls`). Global aggressive mode applied via Preferences JSON, not enterprise registry policy. |

---

## Sources

| Source | URL |
| -------- | ----- |
| Brave ADMX Templates | [brave.com/enterprise](https://brave.com/enterprise/) |
| Chromium Enterprise Policies | [chromium.org/administrators/policy-list-3](https://www.chromium.org/administrators/policy-list-3) |
| Google Omaha Architecture | [omaha documentation](https://github.com/google/omaha) |

---

## Related Pages

- [🏗️ Architecture](Architecture) — Three-tier enforcement model
- [🔧 Installation](Installation) — How to apply policies
- [🛡️ Security](Security) — Safety model
- [🔍 Troubleshooting](Troubleshooting) — Policy verification issues

---

---

<a id="-türkçe"></a>

# 📋 Politika Başvurusu — Tam Kayıt Defteri Tablosu

Brave Omega v2.5.0.0 için tam politika başvurusu — 5 kademeli ilerleyici kısıtlama düzeyinde **150 kurumsal politika**.

---

## Seviye Genel Bakış

| Seviye | Kendi Politikaları | HKCU | HKLM | Kümülatif Toplam |
| -------- | ---------- | ------ | ------ | ----------- |
| **1. Brave Yalnız** | 24 Brave'e özgü | — | 24 | Temel |
| **2. Temel** ⭐ | 29 (+24 +2 v2.4.1.0) | UsageStatsInSample | 53 | 1. Seviyeyi kapsar |
| **3. Dengeli** | 33 (+28 +2 v2.4.1.0) | UsageStatsInSample | 86 | 1-2. Seviyeleri kapsar |
| **4. Gelişmiş** | 38 (+17 +4 v2.4.1.0) | UsageStatsInSample | 124 | 1-3. Seviyeleri kapsar |
| **5. Katı** | 27 (+15 +12 Faz 9) | UsageStatsInSample | 150 | 1-4. Seviyeleri kapsar |

## Seviyelere Göre Politika Başvurusu

> 150 kurumsal politikanın tamamı aşağıda listelenmiştir — betik kaynağına bakmanıza gerek yok. Politikalar kayıt defteri kovanı ve sıkılaştırma seviyesine göre düzenlenmiştir.

### HKCU — Kullanıcı Düzeyi Tercihleri (tüm seviyeler)

| Kayıt Defteri Anahtarı | Kovan | Değer | Tür | Etki |
| ------------------------ | ------- | ------- | ----- | ------ |
| `UsageStatsInSample` | HKCU | `0` | DWord | Tarayıcı düzeyi kullanım istatistikleri örneklemesini devre dışı bırakır |
| `ChromeVariations` | HKCU | `1` | DWord | Chromium'u yalnızca kritik alan denemeleriyle sınırlar |
| `usagestats` *(GUID başına)* | HKCU | `0` | DWord | Uygulama GUID tanımlayıcısı başına Omaha güncelleyici veri aktarımını devre dışı bırakır |

### Brave Yalnız Seviyesi — Brave'e Özgü Politikalar (24)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
| ------------------------ | ------- | ----- | ------ |
| `BraveRewardsDisabled` | `1` | DWord | Rewards reklam sistemini, BAT jeton kazancını kaldırır |
| `BraveWalletDisabled` | `1` | DWord | Tümleşik kripto cüzdan, Web3, dDNS'yi kaldırır |
| `BraveVPNDisabled` | `1` | DWord | VPN düğmesini kaldırır, VPN arka plan hizmetini engeller |
| `BraveAIChatEnabled` | `0` | DWord | Leo AI Chat motorunu devre dışı bırakır |
| `BraveTalkDisabled` | `1` | DWord | Brave Talk video konferansını devre dışı bırakır |
| `BraveNewsDisabled` | `1` | DWord | Yeni Sekme Sayfasında Brave News beslemesini devre dışı bırakır |
| `BravePlaylistEnabled` | `0` | DWord | Brave Playlist çevrimdışı ortamını devre dışı bırakır |
| `BraveSpeedreaderEnabled` | `0` | DWord | Speedreader modunu devre dışı bırakır |
| `BraveWaybackMachineEnabled` | `0` | DWord | Wayback Machine entegrasyonunu devre dışı bırakır |
| `BraveP3AEnabled` | `0` | DWord | P3A veri iletimini devre dışı bırakır |
| `BraveStatsPingEnabled` | `0` | DWord | Brave sunucularına durum/kimlik doğrulama pinglerini durdurur |
| `BraveWebDiscoveryEnabled` | `0` | DWord | Web Discovery Project katkısını devre dışı bırakır |
| `TorDisabled` | `1` | DWord | Tor entegrasyonunu devre dışı bırakır |
| `SafeBrowsingProtectionLevel` | `2` | DWord | Standart Güvenli Gezinti korumasını zorunlu kılar |
| `PasswordProtectionWarningTrigger` | `3` | DWord | Parola tekrar kullanım uyarısını etkinleştirir |
| `BraveDeAmpEnabled` | `1` | DWord | Brave De-AMP'yi devre dışı bırakır |
| `BraveDebouncingEnabled` | `1` | DWord | Brave Debouncing'i devre dışı bırakır |
| `BraveReduceLanguageEnabled` | `1` | DWord | Dil başlığı azaltmayı devre dışı bırakır |
| `BraveTrackingQueryParametersFilteringEnabled` | `1` | DWord | İzleme sorgu parametresi filtrelemeyi devre dışı bırakır |
| `DefaultBraveAdblockSetting` | `2` | DWord | Agresif reklam engellemeyi ayarlar |
| `DefaultBraveFingerprintingV2Setting` | `2` | DWord | Agresif parmak izi korumasını ayarlar |
| `BraveShieldsDisabledForUrls` | `@()` | MultiString | Kalkanlardan hariç tutulan URL yok |
| `BraveShieldsEnabledForUrls` | `@()` | MultiString | Kalkanları zorla etkinleştirilen URL yok |
| `EmailAliasesEnabled` | `0` | DWord | Brave e-posta takma adlarını devre dışı bırakır |

### Temel Seviye — Brave Yalnız + Veri Sızıntısı Önleme (29 toplam)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
| ------------------------ | ------- | ----- | ------ |
| `MetricsReportingEnabled` | `0` | DWord | Chromium temel ölçüm toplamayı devre dışı bırakır |
| `SafeBrowsingExtendedReportingEnabled` | `0` | DWord | Google'a genişletilmiş site verisi raporlamasını durdurur |
| `UrlKeyedAnonymizedDataCollectionEnabled` | `0` | DWord | Google'a URL verisi toplamayı durdurur |
| `SearchSuggestEnabled` | `0` | DWord | Arama önerileri veri sızıntısını durdurur |
| `EnableOnlineRevocationChecks` | `1` | DWord | Çevrimiçi OCSP/CRL iptal kontrollerini etkinleştirir |
| `NetworkPredictionOptions` | `2` | DWord | DNS ön getirmeyi ve ön bağlantıyı durdurur |
| `SpellcheckEnabled` | `1` | DWord | Yerel Hunspell yazım denetimini etkinleştirir (çevrimdışı, veri gönderilmez) |
| `AlternateErrorPagesEnabled` | `0` | DWord | Hata sayfası ağ isteklerini durdurur |
| `BrowserNetworkTimeQueriesEnabled` | `0` | DWord | Google'a saat senkronizasyonunu durdurur |
| `DomainReliabilityAllowed` | `0` | DWord | Tanılama verisi raporlamasını durdurur |
| `BackgroundModeEnabled` | `0` | DWord | Tüm pencereler kapandığında Brave'in çalışmasını engeller |
| `SafeBrowsingSurveysEnabled` | `0` | DWord | Gezinti sonrası anketleri devre dışı bırakır |
| `SafeBrowsingDeepScanningEnabled` | `0` | DWord | Sunucu tarafı indirme taramasını devre dışı bırakır |
| `WebRtcEventLogCollectionAllowed` | `0` | DWord | WebRTC olay günlüğü yüklemeyi durdurur |
| `WebRtcTextLogCollectionAllowed` | `0` | DWord | WebRTC metin günlüğü yüklemeyi durdurur |
| `AudioCaptureAllowed` | `0` | DWord | Varsayılan olarak mikrofona izin vermez |
| `VideoCaptureAllowed` | `0` | DWord | Varsayılan olarak kameraya izin vermez |
| `BraveGlobalPrivacyControlEnabled` | `1` | DWord | Global Privacy Control'u etkinleştirir |
| `DefaultWebUsbGuardSetting` | `2` | DWord | Varsayılan olarak WebUSB'yi engeller |
| `DefaultWebBluetoothGuardSetting` | `2` | DWord | Varsayılan olarak WebBluetooth'u engeller |
| `DefaultWebHidGuardSetting` | `2` | DWord | Varsayılan olarak WebHID'i engeller |
| `DeviceAttributesAllowedForOrigins` | `@()` | MultiString | Cihaz niteliklerinin ifşasını engeller |
| `EncryptedClientHelloEnabled` | `1` | DWord | Encrypted Client Hello'yu etkinleştirir |
| `PaymentMethodQueryEnabled` | `0` | DWord | Ödeme yöntemi sorgularını engeller |
| `SuppressDifferentOriginSubframeDialogs` | `1` | DWord | Farklı kaynaklı alt çerçeve iletişim kutularını bastırır |
| `ProxySettings` | `{"mode":"direct"}` | String | Proxy'yi devre dışı bırakır (doğrudan bağlantı) |
| `BrowserSignin` | `0` | DWord | **[Faz 9]** Brave tarayıcı girişini devre dışı bırakır |
| `ExtensionInstallSources` | `@()` | MultiString | **[Faz 9]** Mağaza dışı tüm uzantı kaynaklarını engeller |
| `ScreenCaptureAllowed` | `0` | DWord | Web yakalama API'lerini engeller (getDisplayMedia vb.); Windows yerel araçları hâlâ çalışır |

### Dengeli Seviye — Temel + Güvenlik Taban Çizgisi (33 toplam)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
| ------------------------ | ------- | ----- | ------ |
| `WebRtcIPHandling` | `"disable_non_proxied_udp"` | String | Tüm WebRTC trafiğini proxy üzerinden yönlendirir |
| `WebRtcLocalIpsAllowedUrls` | `@()` | MultiString | ICE yoluyla yerel IP ifşasını engeller |
| `HttpsOnlyMode` | `"force_enabled"` | String | Tüm gezintileri HTTPS'ye zorlar |
| `DnsOverHttpsMode` | `"automatic"` | String | DNS sorgularını şifreler |
| `BlockThirdPartyCookies` | `1` | DWord | Siteler arası izleme çerezlerini engeller |
| `PasswordManagerEnabled` | `0` | DWord | Yerleşik parola kaydetmeyi devre dışı bırakır |
| `PasswordManagerPasskeysEnabled` | `0` | DWord | Passkey kaydetmeyi devre dışı bırakır |
| `AutofillAddressEnabled` | `0` | DWord | Adres otomatik doldurmayı devre dışı bırakır |
| `AutofillCreditCardEnabled` | `0` | DWord | Kredi kartı otomatik doldurmayı devre dışı bırakır |
| `ShowFullUrlsInAddressBar` | `1` | DWord | Tam URL'leri gösterir (oltalamaya karşı) |
| `DisableSafeBrowsingProceedAnyway` | `1` | DWord | Kötü amaçlı yazılım uyarılarını atlamayı engeller |
| `QuicAllowed` | `0` | DWord | QUIC'i devre dışı bırakır, TCP/TLS'ye döner |
| `ChromeVariations` | `1` | DWord | Yalnızca kritik alan denemeleri |
| `NetworkServiceSandboxEnabled` | `1` | DWord | Ağ hizmetini kum havuzuna alır |
| `AudioSandboxEnabled` | `1` | DWord | Ses hizmetini kum havuzuna alır |
| `DefaultGeolocationSetting` | `2` | DWord | Varsayılan olarak konumu engeller |
| `DefaultNotificationsSetting` | `2` | DWord | Varsayılan olarak bildirimleri engeller |
| `DefaultPopupsSetting` | `2` | DWord | Varsayılan olarak açılır pencereleri engeller |
| `DefaultBraveHttpsUpgradeSetting` | `2` | DWord | HTTPS yükseltmelerini zorlar |
| `DefaultBraveReferrersSetting` | `2` | DWord | Referans başlıklarını engeller |
| `BraveSyncUrl` | `""` | String | Brave Sync'i devre dışı bırakır |
| `DefaultWindowManagementSetting` | `2` | DWord | Pencere yönetimini engeller |
| `SitePerProcess` | `1` | DWord | Site başına süreç izolasyonunu zorlar |
| `IntensiveWakeUpThrottlingEnabled` | `1` | DWord | Yoğun uyanma kısıtlamasını etkinleştirir |
| `UserFeedbackAllowed` | `0` | DWord | Kullanıcı geri bildirimini devre dışı bırakır |
| `ExtensionInstallForcelist` | `@("eimadpbcbfnmbkopoojfekhnkhdbieeh")` | MultiString | Dark Reader'ı zorla yükler |
| `DownloadRestrictions` | `1` | DWord | Tehlikeli indirmelerden önce uyarır |
| `DownloadDirectory` | `"%USERPROFILE%\Downloads\"` | String | Varsayılan indirme dizinini ayarlar |
| `PromptForDownloadLocation` | `0` | DWord | Sormadan varsayılan indirme dizinini kullanır |
| `RelaunchNotification` | `2` | DWord | **[Faz 9]** Güncelleme sonrası zorunlu yeniden başlatma |
| `RelaunchNotificationPeriod` | `3600000` | DWord | **[Faz 9]** Zorunlu yeniden başlatma öncesi 1 saat gecikme |
| `LocalNetworkAccessPermissionsPolicyDefaultEnabled` | `0` | DWord | Alt çerçevelerde yerel ağ izin isteklerinin otomatik onayını devre dışı bırakır |
| `GenAILocalFoundationalModelSettings` | `1` | DWord | Yerel yapay zeka modeli indirmeyi devre dışı bırakır (Gelişmiş'ten taşındı) |

### Gelişmiş Seviye — Dengeli + Gelişmiş Gizlilik (38 toplam)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
| ------------------------ | ------- | ----- | ------ |
| `DefaultSensorsSetting` | `2` | DWord | Varsayılan olarak sensör erişimini engeller |
| `DefaultLocalFontsSetting` | `2` | DWord | Yazı tipi numaralandırmayı engeller |
| `DefaultSerialGuardSetting` | `2` | DWord | Serial API'yi engeller |
| `DefaultIdleDetectionSetting` | `2` | DWord | Boşta algılamayı engeller |
| `BrowserGuestModeEnabled` | `0` | DWord | Misafir profillerini engeller |
| `BrowserAddPersonEnabled` | `0` | DWord | Yeni profilleri engeller |
| `ImportAutofillFormData` | `0` | DWord | Otomatik doldurma verisi içe aktarmayı devre dışı bırakır |
| `ImportHistory` | `0` | DWord | Geçmiş içe aktarmayı devre dışı bırakır |
| `ImportSavedPasswords` | `0` | DWord | Parola içe aktarmayı devre dışı bırakır |
| `ImportSearchEngine` | `0` | DWord | Arama motoru içe aktarmayı devre dışı bırakır |
| `ImportHomepage` | `0` | DWord | Ana sayfa içe aktarmayı devre dışı bırakır |
| `ExtensionInstallBlocklist` | `@("*")` | MultiString | Beyaz listedekiler hariç tüm uzantıları engeller |
| `ExtensionInstallAllowlist` | `@("eimadpbcbfnmbkopoojfekhnkhdbieeh")` | MultiString | Yalnızca Dark Reader'a izin verir |
| `ExtensionAllowedTypes` | `@("extension", "shared_module")` | MultiString | Uzantı türlerini kısıtlar |
| `BlockExternalExtensions` | `1` | DWord | Kenardan yüklenen uzantıları engeller |
| `ExtensionSettings` | `{"*":{"installation_mode":"blocked"},"eimadpbcbfnmbkopoojfekhnkhdbieeh":{"installation_mode":"allowed"}}` | String | Uzantı kontrolü için JSON yedek katmanı |
| `BuiltInDnsClientEnabled` | `0` | DWord | Yerleşik DNS istemcisini devre dışı bırakır (sistem DNS kullanır) |
| `ShowHomeButton` | `0` | DWord | **[Faz 9]** Araç çubuğundaki ana sayfa düğmesini gizler |
| `HideWebStoreIcon` | `1` | DWord | **[Faz 9]** Chrome Web Mağazası simgesini gizler |
| `DefaultJavaScriptSetting` | `0` | DWord | **[Faz 9]** Varsayılan olarak JavaScript'e izin verir |
| `GeminiSettings` | `1` | DWord | **[Faz 9]** Gemini AI entegrasyonunu devre dışı bırakır |
| `AIModeSettings` | `1` | DWord | Chrome AI Modunu tamamen engeller |
| `AutofillPredictionSettings` | `2` | DWord | Yapay zeka destekli otomatik doldurma tahminlerini devre dışı bırakır |
| `ChromeSuggestionsSettings` | `1` | DWord | Yapay zeka destekli önerileri devre dışı bırakır |
| `CreateThemesSettings` | `2` | DWord | Yapay zeka tema oluşturmayı devre dışı bırakır |
| `DevToolsGenAiSettings` | `2` | DWord | Geliştirici araçlarındaki yapay zekayı devre dışı bırakır |
| `HelpMeWriteSettings` | `2` | DWord | Yapay zeka yazma asistanını devre dışı bırakır |
| `HistorySearchSettings` | `2` | DWord | Yapay zeka destekli geçmiş aramayı devre dışı bırakır |
| `SearchContentSharingSettings` | `1` | DWord | Yapay zeka içerik paylaşımını devre dışı bırakır |
| `SmartTabSharingSettings` | `1` | DWord | Yapay zeka sekme paylaşımını devre dışı bırakır |
| `TabCompareSettings` | `2` | DWord | Yapay zeka sekme karşılaştırmayı devre dışı bırakır |
| `GeminiActOnWebSettings` | `1` | DWord | Web sayfalarında Gemini entegrasyonunu devre dışı bırakır |
| `GeminiSparkSettings` | `1` | DWord | Gemini Spark özelliklerini devre dışı bırakır |
| `RendererAppContainerEnabled` | `1` | DWord | İşleyici süreci kum havuzunu etkinleştirir |
| `LocalNetworkAccessAllowedForUrls` | `@()` | MultiString | Belirli URL'leri yerel ağ kontrollerinden muaf tutar |
| `LocalNetworkAccessBlockedForUrls` | `@()` | MultiString | Belirli URL'leri yerel ağ erişiminden engeller |
| `LocalNetworkAccessIpAddressSpaceOverrides` | `@()` | MultiString | Boş liste varsayılan IP eşlemelerini kullanır |
| `LocalNetworkAccessRestrictionsTemporaryOptOut` | `0` | DWord | Yerel ağ erişimi kısıtlamalarından geçici çıkış devre dışı |

### Katı Seviye — Gelişmiş + Azami Gizlilik (27 toplam)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
| ------------------------ | ------- | ----- | ------ |
| `TranslateEnabled` | `0` | DWord | Yerleşik çeviyi devre dışı bırakır |
| `DeveloperToolsAvailability` | `2` | DWord | Geliştirici araçlarını her bağlamda devre dışı bırakır |
| `DefaultClipboardSetting` | `2` | DWord | Varsayılan olarak panoyu engeller |
| `DefaultFileSystemReadGuardSetting` | `2` | DWord | Dosya sistemi okumayı engeller |
| `DefaultFileSystemWriteGuardSetting` | `2` | DWord | Dosya sistemi yazmayı engeller |
| `DefaultInsecureContentSetting` | `2` | DWord | Karma içeriği engeller |
| `DefaultJavaScriptJitSetting` | `2` | DWord | JIT derlemeyi devre dışı bırakır |
| `DefaultCookiesSetting` | `2` | DWord | Varsayılan olarak tüm çerezleri engeller |
| `ImportBookmarks` | `0` | DWord | Yer imi içe aktarmayı devre dışı bırakır |
| `DefaultBraveRemember1PStorageSetting` | `2` | DWord | Sekme/gezinti sonunda birinci taraf deposunu unutur |
| `IncognitoModeAvailability` | `1` | DWord | Gizli modu kapatır |
| `TaskManagerEndProcessEnabled` | `0` | DWord | Görev yöneticisi işlem sonlandırmayı devre dışı bırakır |
| `PrintingEnabled` | `0` | DWord | Yazdırmayı tamamen devre dışı bırakır |
| `DisablePrintPreview` | `1` | DWord | Baskı ön izleme sistem iletişim kutusunu devre dışı bırakır |
| `DownloadRestrictions` | `3` | DWord | TÜM indirmeleri engeller (Dengeli'deki 1 değerinin üzerine yazar) |
| `ScreenCaptureAllowedByOrigins` | `@()` | MultiString | Boş liste tüm kaynaklardan ekran yakalamayı engeller |
| `SameOriginTabCaptureAllowedByOrigins` | `@()` | MultiString | Boşliste tüm aynı kaynak sekme yakalamayı engeller |
| `TabCaptureAllowedByOrigins` | `@()` | MultiString | Boş liste tüm sekme yakalamayı engeller |
| `WindowCaptureAllowedByOrigins` | `@()` | MultiString | Boş liste tüm pencere yakalamayı engeller |
| `LocalNetworkAllowedForUrls` | `@()` | MultiString | Belirli URL'leri yerel ağ engellemesinden muaf tutar |
| `LocalNetworkBlockedForUrls` | `@()` | MultiString | Belirli URL'leri yerel ağ erişiminden engeller |
| `BrowsingDataLifetime` | `{"data_types":["browsing_history","download_history","cached_images_and_files"],"time_to_live_in_hours":24}` | String | **[Faz 9]** Tarama verilerini 24 saatte bir otomatik temizler |
| `AlwaysOpenPdfExternally` | `1` | DWord | **[Faz 9]** PDF'leri harici olarak açar (saldırı azaltma) |
| `CertificateTransparencyEnforcementDisabledForUrls` | `@()` | MultiString | **[Faz 9]** Tüm sitelerde CT'yi zorlar (hariç tutma yok) |
| `PasswordLeakDetectionEnabled` | `1` | DWord | **[Faz 9]** Sızdırılmış parolaları ihlal veritabanıyla kontrol eder |
| `SpellCheckServiceEnabled` | `0` | DWord | **[Faz 9]** Çevrimiçi Google yazım denetimi hizmetini devre dışı bırakır |
| `SyncDisabled` | `1` | DWord | **[Faz 9]** Chrome Sync'i devre dışı bırakır |

---

## Kayıt Defteri Yolları

| Kovan | Yol |
| ------- | ----- |
| **HKCU (Katman 1)** | `HKCU:\Software\BraveSoftware\Brave-Browser` |
| **HKLM (Katman 2)** | `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` |
| **Omaha GUID (Katman 3)** | `HKCU:\Software\BraveSoftware\Update\ClientState\{GUID}` |

---

## Doğrulama

Brave Omega'yı çalıştırdıktan sonra tüm politikaları şu adreste doğrulayın:

```
brave://policy
```

150 politikanın tümü **Etkin** (yeşil onay işareti) olarak görünmelidir.

---

## Hariç Tutulan Politikalar (Belgelenmiş)

| Politika | Gerekçe |
|----------|---------|
| `BraveShieldsDefault` | Brave'in resmî ADMX şablonlarında bulunmamaktadır. Kalkanlar URL bazlı politikalarla (`BraveShieldsEnabledForUrls`, `BraveShieldsDisabledForUrls`) yönetilir. Genel saldırgan mod, kurumsal kayıt defteri politikası değil; Preferences JSON aracılığıyla uygulanır. |

---

## Kaynaklar

| Kaynak | URL |
| -------- | ----- |
| Brave ADMX Şablonları | [brave.com/enterprise](https://brave.com/enterprise/) |
| Chromium Kurumsal Politikaları | [chromium.org/administrators/policy-list-3](https://www.chromium.org/administrators/policy-list-3) |
| Google Omaha Mimarisi | [omaha belgelendirmesi](https://github.com/google/omaha) |

---

## İlgili Sayfalar

- [🏗️ Mimari](Architecture#-türkçe) — Üç katmanlı zorunlu kılma modeli
- [🔧 Kurulum](Installation#-türkçe) — Politikalar nasıl uygulanır
- [🛡️ Güvenlik](Security#-türkçe) — Güvenlik modeli
- [🔍 Sorun Giderme](Troubleshooting#-türkçe) — Politika doğrulama sorunları
