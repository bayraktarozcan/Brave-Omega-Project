> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 📋 Policy Reference — Complete Registry Table

Complete policy reference for Brave Omega v2.2.0.0.

---

## Level Overview

| Level | Policies | HKCU | HKLM | Cumulative |
| ------- | ---------- | ------ | ------ | ------------ |
| **1. Brave Only** | 23 Brave-specific | — | 23 | Base |
| **2. Essential** ⭐ | 40 (23 + 17) | UsageStatsInSample | 40 | Includes Level 1 |
| **3. Balanced** | 61 (40 + 21) | UsageStatsInSample | 61 | Includes Levels 1-2 |
| **4. Gelişmiş (Advanced)** | 72 (61 + 11) | UsageStatsInSample | 72 | Includes Levels 1-3 |
| **5. Strict** | 81 (72 + 9) | UsageStatsInSample | 81 | Includes Levels 1-4 |

## Policy Reference by Level

> All 81 enterprise policies are listed below — no need to consult the script. Policies are organized by registry hive and hardening level.

### HKCU — User-Level Preferences (all levels)

| Registry Key | Hive | Value | Type | Effect |
| -------------- | ------ | ------- | ------ | -------- |
| `UsageStatsInSample` | HKCU | `0` | DWord | Disables browser-level usage statistics sampling |
| `ChromeVariations` | HKCU | `1` | DWord | Restricts Chromium to critical field trials only |
| `usagestats` *(per GUID)* | HKCU | `0` | DWord | Disables Omaha updater telemetry per application GUID |

### Brave Only Level — Brave-Specific Policies (23)

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

### Essential Level — Brave Only + Data Leak Prevention (17 additional)

| Registry Key | Value | Type | Effect |
| -------------- | ------- | ------ | -------- |
| `MetricsReportingEnabled` | `0` | DWord | Disables Chromium core metrics collection |
| `SafeBrowsingExtendedReportingEnabled` | `0` | DWord | Stops extended site data to Google |
| `UrlKeyedAnonymizedDataCollectionEnabled` | `0` | DWord | Stops URL data collection to Google |
| `SearchSuggestEnabled` | `0` | DWord | Stops search suggestions data leakage |
| `NetworkPredictionOptions` | `2` | DWord | Stops DNS prefetching and pre-connection |
| `TranslateEnabled` | `0` | DWord | Disables built-in translation |
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

### Balanced Level — Essential + Security Baseline (21 additional)

| Registry Key | Value | Type | Effect |
| -------------- | ------- | ------ | -------- |
| `WebRtcIPHandling` | `"default_public_interface_only"` | String | Hides local IPs from WebRTC |
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

### Gelişmiş (Advanced) Level — Balanced + Enhanced Privacy (11 additional)

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

### Strict Level — Gelişmiş (Advanced) + Maximum Privacy (9 additional)

| Registry Key | Value | Type | Effect |
| -------------- | ------- | ------ | -------- |
| `TranslateEnabled` | `0` | DWord | Disables built-in translation |
| `WebRtcIPHandling` *(override)* | `"disable_non_proxied_udp"` | String | Proxies all WebRTC traffic |
| `DefaultClipboardSetting` | `2` | DWord | Blocks clipboard by default |
| `DefaultFileSystemReadGuardSetting` | `2` | DWord | Blocks file system read |
| `DefaultFileSystemWriteGuardSetting` | `2` | DWord | Blocks file system write |
| `DefaultInsecureContentSetting` | `2` | DWord | Blocks mixed content |
| `DefaultJavaScriptJitSetting` | `2` | DWord | Disables JIT compilation |
| `DefaultCookiesSetting` | `2` | DWord | Blocks all cookies by default |
| `ImportBookmarks` | `0` | DWord | Disables bookmark import |
| `DefaultBraveRemember1PStorageSetting` | `2` | DWord | Forgets first-party storage on tab/nav end |

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

---

## Verification

After running Brave Omega, verify all policies at:

```
brave://policy
```

All 81 policies should show as **Active** (green checkmark).

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

Brave Omega v2.2.0.0 için tam politika başvurusu.

---

## Seviye Genel Bakış

| Seviye | Politika | HKCU | HKLM | Kümülatif |
| -------- | ---------- | ------ | ------ | ----------- |
| **1. Brave Yalnız** | 23 Brave'e özgü | — | 23 | Temel |
| **2. Temel** ⭐ | 40 (23 + 17) | UsageStatsInSample | 40 | 1. Seviyeyi kapsar |
| **3. Dengeli** | 61 (40 + 21) | UsageStatsInSample | 61 | 1-2. Seviyeleri kapsar |
| **4. Gelişmiş** | 72 (61 + 11) | UsageStatsInSample | 72 | 1-3. Seviyeleri kapsar |
| **5. Katı** | 81 (72 + 9) | UsageStatsInSample | 81 | 1-4. Seviyeleri kapsar |

## Seviyelere Göre Politika Başvurusu

> 81 kurumsal politikanın tamamı aşağıda listelenmiştir — betik kaynağına bakmanıza gerek yok. Politikalar kayıt defteri kovanı ve sıkılaştırma seviyesine göre düzenlenmiştir.

### HKCU — Kullanıcı Düzeyi Tercihleri (tüm seviyeler)

| Kayıt Defteri Anahtarı | Kovan | Değer | Tür | Etki |
| ------------------------ | ------- | ------- | ----- | ------ |
| `UsageStatsInSample` | HKCU | `0` | DWord | Tarayıcı düzeyi kullanım istatistikleri örneklemesini devre dışı bırakır |
| `ChromeVariations` | HKCU | `1` | DWord | Chromium'u yalnızca kritik alan denemeleriyle sınırlar |
| `usagestats` *(GUID başına)* | HKCU | `0` | DWord | Uygulama GUID tanımlayıcısı başına Omaha güncelleyici veri aktarımını devre dışı bırakır |

### Brave Yalnız Seviyesi — Brave'e Özgü Politikalar (23)

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

### Temel Seviye — Brave Yalnız + Veri Sızıntısı Önleme (17 ek)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
| ------------------------ | ------- | ----- | ------ |
| `MetricsReportingEnabled` | `0` | DWord | Chromium temel ölçüm toplamayı devre dışı bırakır |
| `SafeBrowsingExtendedReportingEnabled` | `0` | DWord | Google'a genişletilmiş site verisi raporlamasını durdurur |
| `UrlKeyedAnonymizedDataCollectionEnabled` | `0` | DWord | Google'a URL verisi toplamayı durdurur |
| `SearchSuggestEnabled` | `0` | DWord | Arama önerileri veri sızıntısını durdurur |
| `NetworkPredictionOptions` | `2` | DWord | DNS ön getirmeyi ve ön bağlantıyı durdurur |
| `TranslateEnabled` | `0` | DWord | Yerleşik çeviriyi devre dışı bırakır |
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

### Dengeli Seviye — Temel + Güvenlik Taban Çizgisi (21 ek)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
| ------------------------ | ------- | ----- | ------ |
| `WebRtcIPHandling` | `"default_public_interface_only"` | String | Yerel IP'leri WebRTC'den gizler |
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

### Gelişmiş Seviye — Dengeli + Gelişmiş Gizlilik (11 ek)

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

### Katı Seviye — Gelişmiş + Azami Gizlilik (9 ek)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
| ------------------------ | ------- | ----- | ------ |
| `TranslateEnabled` | `0` | DWord | Yerleşik çeviriyi devre dışı bırakır |
| `WebRtcIPHandling` *(üzerine yaz)* | `"disable_non_proxied_udp"` | String | Tüm WebRTC trafiğini proxy üzerinden yönlendirir |
| `DefaultClipboardSetting` | `2` | DWord | Varsayılan olarak panoyu engeller |
| `DefaultFileSystemReadGuardSetting` | `2` | DWord | Dosya sistemi okumayı engeller |
| `DefaultFileSystemWriteGuardSetting` | `2` | DWord | Dosya sistemi yazmayı engeller |
| `DefaultInsecureContentSetting` | `2` | DWord | Karma içeriği engeller |
| `DefaultJavaScriptJitSetting` | `2` | DWord | JIT derlemeyi devre dışı bırakır |
| `DefaultCookiesSetting` | `2` | DWord | Varsayılan olarak tüm çerezleri engeller |
| `ImportBookmarks` | `0` | DWord | Yer imi içe aktarmayı devre dışı bırakır |
| `DefaultBraveRemember1PStorageSetting` | `2` | DWord | Sekme/gezinti sonunda birinci taraf deposunu unutur |

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

---

## Doğrulama

Brave Omega'yı çalıştırdıktan sonra tüm politikaları şu adreste doğrulayın:

```
brave://policy
```

81 politikanın tümü **Etkin** (yeşil onay işareti) olarak görünmelidir.

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
