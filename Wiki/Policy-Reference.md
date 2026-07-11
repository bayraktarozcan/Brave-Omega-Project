> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 📋 Policy Reference — Complete Registry Table

Complete policy reference for Brave Omega v2.3.1.0.

---

## Level Overview

| Level | Policies | HKCU | HKLM | Cumulative |
| ------- | ---------- | ------ | ------ | ------------ |
| **1. Brave Only** | 24 Brave-specific | — | 24 | Base |
| **2. Essential** ⭐ | 50 (24 + 26) | UsageStatsInSample | 50 | Includes Level 1 |
| **3. Balanced** | 79 (50 + 29) | UsageStatsInSample | 79 | Includes Levels 1-2 |
| **4. Advanced** | 96 (79 + 17) | UsageStatsInSample | 96 | Includes Levels 1-3 |
| **5. Strict** | 110 (96 + 14) | UsageStatsInSample | 110 | Includes Levels 1-4 |

## Policy Reference by Level

> All 110 enterprise policies are listed below — no need to consult the script. Policies are organized by registry hive and hardening level.

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

### Essential Level — Brave Only + Data Leak Prevention (26 additional)

| Registry Key | Value | Type | Effect |
| -------------- | ------- | ------ | -------- |
| `MetricsReportingEnabled` | `0` | DWord | Disables Chromium core metrics collection |
| `SafeBrowsingExtendedReportingEnabled` | `0` | DWord | Stops extended site data to Google |
| `UrlKeyedAnonymizedDataCollectionEnabled` | `0` | DWord | Stops URL data collection to Google |
| `SearchSuggestEnabled` | `0` | DWord | Stops search suggestions data leakage |
| `EnableOnlineRevocationChecks` | `1` | DWord | Enables online OCSP/CRL revocation checks |
| `NetworkPredictionOptions` | `2` | DWord | Stops DNS prefetching and pre-connection |
| `SpellcheckEnabled` | `0` | DWord | Disables spellcheck |
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

### Balanced Level — Essential + Security Baseline (29 additional)

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
| `ExtensionInstallForcelist` | `@("gighmmpiobklfepjocnamgkkbiglidom", "jkfdkjapfhfinccefmehkmnjghbkladp")` | MultiString | Force-installs Dark Reader and Google Docs Offline |
| `DownloadRestrictions` | `1` | DWord | Warns before dangerous downloads |
| `DownloadDirectory` | `"%USERPROFILE%\Downloads\"` | String | Sets default download directory |
| `PromptForDownloadLocation` | `0` | DWord | Uses default download directory without prompting |

### Advanced Level — Balanced + Enhanced Privacy (17 additional)

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
| `ExtensionInstallAllowlist` | `@("jkfdkjapfhfinccefmehkmnjghbkladp", "eimadpbcbfnmbkopoojfekhnkhdbieeh")` | MultiString | Allows only Google Docs Offline + Dark Reader |
| `ExtensionAllowedTypes` | `@("extension", "shared_module")` | MultiString | Restricts extension types |
| `BlockExternalExtensions` | `1` | DWord | Prevents sideloaded extensions |
| `ExtensionSettings` | `{"*":{"installation_mode":"blocked"},"jkfdkjapfhfinccefmehkmnjghbkladp":{"installation_mode":"allowed"},"eimadpbcbfnmbkopoojfekhnkhdbieeh":{"installation_mode":"allowed"}}` | String | JSON backup layer for extension control |
| `BuiltInDnsClientEnabled` | `0` | DWord | Disables built-in DNS client (uses system DNS) |

### Strict Level — Advanced + Maximum Privacy (14 additional)

| Registry Key | Value | Type | Effect |
| -------------- | ------- | ------ | -------- |
| `TranslateEnabled` | `0` | DWord | Disables built-in translation |
| `DeveloperToolsAvailability` | `2` | DWord | Disables developer tools in all contexts (moved from Advanced) |
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

> **Note:** `DownloadRestrictions` is set to `3` in Strict (overrides the Balanced value of `1`), but is counted under Balanced's 29 additions.

---

## Registry Paths

| Hive | Path |
| ------ | ------ |
| **HKCU (Tier 1)** | `HKCU:\Software\BraveSoftware\Brave-Browser` |
| **HKLM (Tier 2)** | `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` |
| **Omaha GUID (Tier 3)** | `HKCU:\Software\BraveSoftware\Update\ClientState\{GUID}` |

---

## Version Added

| Policy | Added In |
| -------- | ---------- |
| `UsageStatsInSample` | v1.0 |
| `BraveRewardsDisabled` | v1.0 |
| `BraveWalletDisabled` | v1.0 |
| `BraveVPNDisabled` | v1.0 |
| `BraveAIChatEnabled` | v1.0 |
| `BraveStatsPingEnabled` | v1.0 |
| `MetricsReportingEnabled` | v1.0 |
| `SafeBrowsingExtendedReportingEnabled` | v1.0 |
| `usagestats` (Omaha) | v1.0 |
| `BraveP3AEnabled` | v1.2 |
| `BraveWebDiscoveryEnabled` | v1.2 |
| `BraveTalkDisabled` | v1.2 |
| `BraveNewsDisabled` | v1.2 |
| `BravePlaylistEnabled` | v1.2 |
| `BraveSpeedreaderEnabled` | v1.2 |
| `BraveWaybackMachineEnabled` | v1.2 |
| `TorDisabled` | v1.2 |
| `SafeBrowsingProtectionLevel` | v2.3.0.0 |
| `PasswordProtectionWarningTrigger` | v2.3.0.0 |
| `EnableOnlineRevocationChecks` | v2.3.0.0 |
| `ExtensionInstallForcelist` | v2.3.0.0 |
| `DownloadRestrictions` | v2.3.0.0 |
| `DownloadDirectory` | v2.3.0.0 |
| `PromptForDownloadLocation` | v2.3.0.0 |
| `ExtensionInstallBlocklist` | v2.3.0.0 |
| `ExtensionInstallAllowlist` | v2.3.0.0 |
| `ExtensionAllowedTypes` | v2.3.0.0 |
| `BlockExternalExtensions` | v2.3.0.0 |
| `ExtensionSettings` | v2.3.0.0 |
| `DeveloperToolsAvailability` | v2.3.0.0 |
| `BuiltInDnsClientEnabled` | v2.3.0.0 |
| `IncognitoModeAvailability` | v2.3.0.0 |
| `TaskManagerEndProcessEnabled` | v2.3.0.0 |
| `PrintingEnabled` | v2.3.0.0 |
| `DisablePrintPreview` | v2.3.0.0 |
| `TranslateEnabled` | v2.3.0.0 |
| `DefaultJavaScriptSetting` | v2.3.0.0 |
| `PasswordManagerEnabled` | v2.3.0.0 |
| `ProxySettings` | v2.3.1.0 |

---

## Verification

After running Brave Omega, verify all policies at:

```
brave://policy
```

All 110 policies should show as **Active** (green checkmark).

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

Brave Omega v2.3.1.0 için tam politika başvurusu.

---

## Seviye Genel Bakış

| Seviye | Politika | HKCU | HKLM | Kümülatif |
| -------- | ---------- | ------ | ------ | ----------- |
| **1. Brave Yalnız** | 24 Brave'e özgü | — | 24 | Temel |
| **2. Temel** ⭐ | 50 (24 + 26) | UsageStatsInSample | 50 | 1. Seviyeyi kapsar |
| **3. Dengeli** | 79 (50 + 29) | UsageStatsInSample | 79 | 1-2. Seviyeleri kapsar |
| **4. Gelişmiş** | 96 (79 + 17) | UsageStatsInSample | 96 | 1-3. Seviyeleri kapsar |
| **5. Katı** | 110 (96 + 14) | UsageStatsInSample | 110 | 1-4. Seviyeleri kapsar |

## Seviyelere Göre Politika Başvurusu

> 110 kurumsal politikanın tamamı aşağıda listelenmiştir — betik kaynağına bakmanıza gerek yok. Politikalar kayıt defteri kovanı ve sıkılaştırma seviyesine göre düzenlenmiştir.

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

### Temel Seviye — Brave Yalnız + Veri Sızıntısı Önleme (26 ek)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
| ------------------------ | ------- | ----- | ------ |
| `MetricsReportingEnabled` | `0` | DWord | Chromium temel ölçüm toplamayı devre dışı bırakır |
| `SafeBrowsingExtendedReportingEnabled` | `0` | DWord | Google'a genişletilmiş site verisi raporlamasını durdurur |
| `UrlKeyedAnonymizedDataCollectionEnabled` | `0` | DWord | Google'a URL verisi toplamayı durdurur |
| `SearchSuggestEnabled` | `0` | DWord | Arama önerileri veri sızıntısını durdurur |
| `EnableOnlineRevocationChecks` | `1` | DWord | Çevrimiçi OCSP/CRL iptal kontrollerini etkinleştirir |
| `NetworkPredictionOptions` | `2` | DWord | DNS ön getirmeyi ve ön bağlantıyı durdurur |
| `SpellcheckEnabled` | `0` | DWord | Yazım denetimini devre dışı bırakır |
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

### Dengeli Seviye — Temel + Güvenlik Taban Çizgisi (29 ek)

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
| `ExtensionInstallForcelist` | `@("gighmmpiobklfepjocnamgkkbiglidom", "jkfdkjapfhfinccefmehkmnjghbkladp")` | MultiString | Dark Reader ve Google Docs Offline'ı zorla yükler |
| `DownloadRestrictions` | `1` | DWord | Tehlikeli indirmelerden önce uyarır |
| `DownloadDirectory` | `"%USERPROFILE%\Downloads\"` | String | Varsayılan indirme dizinini ayarlar |
| `PromptForDownloadLocation` | `0` | DWord | Sormadan varsayılan indirme dizinini kullanır |

### Gelişmiş Seviye — Dengeli + Gelişmiş Gizlilik (17 ek)

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
| `ExtensionInstallAllowlist` | `@("jkfdkjapfhfinccefmehkmnjghbkladp", "eimadpbcbfnmbkopoojfekhnkhdbieeh")` | MultiString | Yalnızca Google Docs Offline + Dark Reader'a izin verir |
| `ExtensionAllowedTypes` | `@("extension", "shared_module")` | MultiString | Uzantı türlerini kısıtlar |
| `BlockExternalExtensions` | `1` | DWord | Kenardan yüklenen uzantıları engeller |
| `ExtensionSettings` | `{"*":{"installation_mode":"blocked"},"jkfdkjapfhfinccefmehkmnjghbkladp":{"installation_mode":"allowed"},"eimadpbcbfnmbkopoojfekhnkhdbieeh":{"installation_mode":"allowed"}}` | String | Uzantı kontrolü için JSON yedek katmanı |
| `BuiltInDnsClientEnabled` | `0` | DWord | Yerleşik DNS istemcisini devre dışı bırakır (sistem DNS kullanır) |

### Katı Seviye — Gelişmiş + Azami Gizlilik (14 ek)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
| ------------------------ | ------- | ----- | ------ |
| `TranslateEnabled` | `0` | DWord | Yerleşik çeviriyi devre dışı bırakır |
| `DeveloperToolsAvailability` | `2` | DWord | Geliştirici araçlarını her bağlamda devre dışı bırakır (Gelişmiş'ten taşındı) |
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

> **Not:** `DownloadRestrictions`, Katı seviyede `3`'e ayarlanmıştır (Dengeli'deki `1` değerinin üzerine yazar), ancak Dengeli'nin 29 ekstra politikası arasında sayılmaktadır.

---

## Kayıt Defteri Yolları

| Kovan | Yol |
| ------- | ----- |
| **HKCU (Katman 1)** | `HKCU:\Software\BraveSoftware\Brave-Browser` |
| **HKLM (Katman 2)** | `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` |
| **Omaha GUID (Katman 3)** | `HKCU:\Software\BraveSoftware\Update\ClientState\{GUID}` |

---

## Eklendiği Sürüm

| Politika | Eklendiği Sürüm |
| ---------- | ----------------- |
| `UsageStatsInSample` | v1.0 |
| `BraveRewardsDisabled` | v1.0 |
| `BraveWalletDisabled` | v1.0 |
| `BraveVPNDisabled` | v1.0 |
| `BraveAIChatEnabled` | v1.0 |
| `BraveStatsPingEnabled` | v1.0 |
| `MetricsReportingEnabled` | v1.0 |
| `SafeBrowsingExtendedReportingEnabled` | v1.0 |
| `usagestats` (Omaha) | v1.0 |
| `BraveP3AEnabled` | v1.2 |
| `BraveWebDiscoveryEnabled` | v1.2 |
| `BraveTalkDisabled` | v1.2 |
| `BraveNewsDisabled` | v1.2 |
| `BravePlaylistEnabled` | v1.2 |
| `BraveSpeedreaderEnabled` | v1.2 |
| `BraveWaybackMachineEnabled` | v1.2 |
| `TorDisabled` | v1.2 |
| `SafeBrowsingProtectionLevel` | v2.3.0.0 |
| `PasswordProtectionWarningTrigger` | v2.3.0.0 |
| `EnableOnlineRevocationChecks` | v2.3.0.0 |
| `ExtensionInstallForcelist` | v2.3.0.0 |
| `DownloadRestrictions` | v2.3.0.0 |
| `DownloadDirectory` | v2.3.0.0 |
| `PromptForDownloadLocation` | v2.3.0.0 |
| `ExtensionInstallBlocklist` | v2.3.0.0 |
| `ExtensionInstallAllowlist` | v2.3.0.0 |
| `ExtensionAllowedTypes` | v2.3.0.0 |
| `BlockExternalExtensions` | v2.3.0.0 |
| `ExtensionSettings` | v2.3.0.0 |
| `DeveloperToolsAvailability` | v2.3.0.0 |
| `BuiltInDnsClientEnabled` | v2.3.0.0 |
| `IncognitoModeAvailability` | v2.3.0.0 |
| `TaskManagerEndProcessEnabled` | v2.3.0.0 |
| `PrintingEnabled` | v2.3.0.0 |
| `DisablePrintPreview` | v2.3.0.0 |
| `TranslateEnabled` | v2.3.0.0 |
| `DefaultJavaScriptSetting` | v2.3.0.0 |
| `PasswordManagerEnabled` | v2.3.0.0 |
| `ProxySettings` | v2.3.1.0 |

---

## Doğrulama

Brave Omega'yı çalıştırdıktan sonra tüm politikaları şu adreste doğrulayın:

```
brave://policy
```

110 politikanın tümü **Etkin** (yeşil onay işareti) olarak görünmelidir.

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
