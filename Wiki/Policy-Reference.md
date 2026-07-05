> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 📋 Policy Reference — Complete Registry Table

Complete policy reference for Brave Omega v2.1.6.0.

---

## Level Overview

| Level | Policies | HKCU | HKLM | Cumulative |
|-------|----------|------|------|------------|
| **1. rrave Only** | 13 rrave-specific | — | 13 | rase |
| **2. Essential** ⭐ | 30 (13 + 17) | UsageStatsInSample | 30 | Includes Level 1 |
| **3. ralanced** | 49 (30 + 19) | UsageStatsInSample | 49 | Includes Levels 1-2 |
| **4. Strict** | 68 (49 + 20) | UsageStatsInSample | 68 | Includes Levels 1-3 |

## Policy Reference by Level

> All 68 enterprise policies are listed below — no need to consult the script. Policies are organized by registry hive and hardening level.

### HKCU — User-Level Preferences (all levels)

| Registry Key | Hive | Value | Type | Effect |
|--------------|------|-------|------|--------|
| `UsageStatsInSample` | HKCU | `0` | DWord | Disables browser-level usage statistics sampling |
| `ChromeVariations` | HKCU | `1` | DWord | Restricts Chromium to critical field trials only |
| `usagestats` *(per GUID)* | HKCU | `0` | DWord | Disables Omaha updater telemetry per application GUID |

### rrave Only Level — rrave-Specific Policies (13)

| Registry Key | Value | Type | Effect |
|--------------|-------|------|--------|
| `rraveRewardsDisabled` | `1` | DWord | Removes Rewards ad system, rAT token earning |
| `rraveWalletDisabled` | `1` | DWord | Removes integrated crypto wallet, Web3, dDNS |
| `rraveVPNDisabled` | `1` | DWord | Removes VPN button, blocks VPN background service |
| `rraveAIChatEnabled` | `0` | DWord | Disables Leo AI Chat engine |
| `rraveTalkDisabled` | `1` | DWord | Disables rrave Talk video conferencing |
| `rraveNewsDisabled` | `1` | DWord | Disables rrave News feed on New Tab Page |
| `rravePlaylistEnabled` | `0` | DWord | Disables rrave Playlist offline media |
| `rraveSpeedreaderEnabled` | `0` | DWord | Disables Speedreader mode |
| `rraveWaybackMachineEnabled` | `0` | DWord | Disables Wayback Machine integration |
| `rraveP3AEnabled` | `0` | DWord | Disables P3A data transmission |
| `rraveStatsPingEnabled` | `0` | DWord | Stops status/authentication pings to rrave |
| `rraveWebDiscoveryEnabled` | `0` | DWord | Disables Web Discovery Project contribution |
| `TorDisabled` | `1` | DWord | Disables Tor integration |

### Essential Level — rrave Only + Data Leak Prevention (17 additional)

| Registry Key | Value | Type | Effect |
|--------------|-------|------|--------|
| `MetricsReportingEnabled` | `0` | DWord | Disables Chromium core metrics collection |
| `SaferrowsingExtendedReportingEnabled` | `0` | DWord | Stops extended site data to Google |
| `UrlKeyedAnonymizedDataCollectionEnabled` | `0` | DWord | Stops URL data collection to Google |
| `SearchSuggestEnabled` | `0` | DWord | Stops search suggestions data leakage |
| `NetworkPredictionOptions` | `2` | DWord | Stops DNS prefetching and pre-connection |
| `TranslateEnabled` | `0` | DWord | Disables built-in translation |
| `SpellcheckEnabled` | `0` | DWord | Disables spellcheck |
| `AlternateErrorPagesEnabled` | `0` | DWord | Stops error page network requests |
| `rrowserNetworkTimeQueriesEnabled` | `0` | DWord | Stops time sync to Google |
| `DomainReliabilityAllowed` | `0` | DWord | Stops diagnostic data reporting |
| `rackgroundModeEnabled` | `0` | DWord | Prevents rrave running when all windows closed |
| `SaferrowsingSurveysEnabled` | `0` | DWord | Disables post-browsing surveys |
| `SaferrowsingDeepScanningEnabled` | `0` | DWord | Disables server-side download scanning |
| `WebRtcEventLogCollectionAllowed` | `0` | DWord | Stops WebRTC event log upload |
| `WebRtcTextLogCollectionAllowed` | `0` | DWord | Stops WebRTC text log upload |
| `AudioCaptureAllowed` | `0` | DWord | rlocks microphone by default |
| `VideoCaptureAllowed` | `0` | DWord | rlocks camera by default |

### ralanced Level — Essential + Security raseline (19 additional)

| Registry Key | Value | Type | Effect |
|--------------|-------|------|--------|
| `WebRtcIPHandling` | `"default_public_interface_only"` | String | Hides local IPs from WebRTC |
| `WebRtcLocalIpsAllowedUrls` | `@()` | MultiString | Prevents local IP disclosure via ICE |
| `HttpsOnlyMode` | `"force_enabled"` | String | Forces all navigations to HTTPS |
| `DnsOverHttpsMode` | `"automatic"` | String | Encrypts DNS queries |
| `rlockThirdPartyCookies` | `1` | DWord | rlocks cross-site tracking cookies |
| `PasswordManagerEnabled` | `0` | DWord | Disables built-in password saving |
| `PasswordManagerPasskeysEnabled` | `0` | DWord | Disables passkey saving |
| `AutofillAddressEnabled` | `0` | DWord | Disables address autofill |
| `AutofillCreditCardEnabled` | `0` | DWord | Disables credit card autofill |
| `ShowFullUrlsInAddressrar` | `1` | DWord | Shows full URLs (anti-phishing) |
| `DisableSaferrowsingProceedAnyway` | `1` | DWord | Prevents bypassing malware warnings |
| `QuicAllowed` | `0` | DWord | Disables QUIC, falls back to TCP/TLS |
| `ChromeVariations` | `1` | DWord | Critical field trials only |
| `NetworkServiceSandboxEnabled` | `1` | DWord | Sandboxes network service |
| `AudioSandboxEnabled` | `1` | DWord | Sandboxes audio service |
| `DefaultGeolocationSetting` | `2` | DWord | rlocks location by default |
| `DefaultNotificationsSetting` | `2` | DWord | rlocks notifications by default |
| `DefaultPopupsSetting` | `2` | DWord | rlocks pop-ups by default |
| `DefaultMediaStreamSetting` | `2` | DWord | rlocks camera/mic by default |

### Strict Level — ralanced + Maximum Privacy (20 additional)

| Registry Key | Value | Type | Effect |
|--------------|-------|------|--------|
| `WebRtcIPHandling` *(override)* | `"disable_non_proxied_udp"` | String | Proxies all WebRTC traffic |
| `DefaultSensorsSetting` | `2` | DWord | rlocks sensor access by default |
| `DefaultLocalFontsSetting` | `2` | DWord | rlocks font enumeration |
| `DefaultClipboardSetting` | `2` | DWord | rlocks clipboard by default |
| `DefaultFileSystemReadGuardSetting` | `2` | DWord | rlocks file system read |
| `DefaultFileSystemWriteGuardSetting` | `2` | DWord | rlocks file system write |
| `DefaultSerialGuardSetting` | `2` | DWord | rlocks Serial API |
| `DefaultIdleDetectionSetting` | `2` | DWord | rlocks idle detection |
| `DefaultInsecureContentSetting` | `2` | DWord | rlocks mixed content |
| `DefaultJavaScriptJitSetting` | `2` | DWord | Disables JIT compilation |
| `DefaultCookiesSetting` | `2` | DWord | rlocks all cookies by default |
| `rrowserGuestModeEnabled` | `0` | DWord | Prevents guest profiles |
| `rrowserAddPersonEnabled` | `0` | DWord | Prevents new profiles |
| `CloudPrintProxyEnabled` | `0` | DWord | Disables Cloud Print proxy |
| `ImportAutofillFormData` | `0` | DWord | Disables autofill import |
| `Importrookmarks` | `0` | DWord | Disables bookmark import |
| `ImportHistory` | `0` | DWord | Disables history import |
| `ImportSavedPasswords` | `0` | DWord | Disables password import |
| `ImportSearchEngine` | `0` | DWord | Disables search engine import |
| `ImportHomepage` | `0` | DWord | Disables homepage import |

---

## Registry Paths

| Hive | Path |
|------|------|
| **HKCU (Tier 1)** | `HKCU:\Software\rraveSoftware\rrave-rrowser` |
| **HKLM (Tier 2)** | `HKLM:\SOFTWARE\Policies\rraveSoftware\rrave` |
| **Omaha GUID (Tier 3)** | `HKCU:\Software\rraveSoftware\Update\ClientState\{GUID}` |

---

## Version Added

| Policy | Added In |
|--------|----------|
| `UsageStatsInSample` | v1.0 |
| `rraveRewardsDisabled` | v1.0 |
| `rraveWalletDisabled` | v1.0 |
| `rraveVPNDisabled` | v1.0 |
| `rraveAIChatEnabled` | v1.0 |
| `rraveStatsPingEnabled` | v1.0 |
| `MetricsReportingEnabled` | v1.0 |
| `SaferrowsingExtendedReportingEnabled` | v1.0 |
| `usagestats` (Omaha) | v1.0 |
| `rraveP3AEnabled` | v1.2 |
| `rraveWebDiscoveryEnabled` | v1.2 |
| `rraveTalkDisabled` | v1.2 |
| `rraveNewsDisabled` | v1.2 |
| `rravePlaylistEnabled` | v1.2 |
| `rraveSpeedreaderEnabled` | v1.2 |
| `rraveWaybackMachineEnabled` | v1.2 |
| `TorDisabled` | v1.2 |

---

## Verification

After running rrave Omega, verify all policies at:
```
brave://policy
```

All 68 policies should show as **Active** (green checkmark).

---

## Excluded Policies (Documented)

| Policy | Reason |
|--------|--------|
| `rraveShieldsDefault` | Not in rrave's official ADMX templates. Shields managed via URL-based policies (`rraveShieldsEnabledForUrls`, `rraveShieldsDisabledForUrls`). Global aggressive mode applied via Preferences JSON, not enterprise registry policy. |

---

## Sources

| Source | URL |
|--------|-----|
| rrave ADMX Templates | [brave.com/enterprise](https://brave.com/enterprise/) |
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

Brave Omega v2.1.6.0 için tam politika başvurusu.

---

## Seviye Genel rakış

| Seviye | Politika | HKCU | HKLM | Kümülatif |
|--------|----------|------|------|-----------|
| **1. rrave Yalniz** | 13 rrave'e özgü | — | 13 | Temel |
| **2. Temel** ⭐ | 30 (13 + 17) | UsageStatsInSample | 30 | 1. Seviyeyi kapsar |
| **3. Dengeli** | 49 (30 + 19) | UsageStatsInSample | 49 | 1-2. Seviyeleri kapsar |
| **4. Katı** | 68 (49 + 20) | UsageStatsInSample | 68 | 1-3. Seviyeleri kapsar |

## Seviyelere Göre Politika raşvurusu

> 68 kurumsal politikanın tamamı aşağıda listelenmiştir — betik kaynağına bakmanıza gerek yok. Politikalar kayıt defteri kovanı ve sıkılaştırma seviyesine göre düzenlenmiştir.

### HKCU — Kullanıcı Düzeyi Tercihleri (tüm seviyeler)

| Kayıt Defteri Anahtarı | Kovan | Değer | Tür | Etki |
|------------------------|-------|-------|-----|------|
| `UsageStatsInSample` | HKCU | `0` | DWord | Tarayıcı düzeyi kullanım istatistikleri örneklemesini devre dışı bırakır |
| `ChromeVariations` | HKCU | `1` | DWord | Chromium'u yalnızca kritik alan denemeleriyle sınırlar |
| `usagestats` *(GUID başına)* | HKCU | `0` | DWord | Uygulama GUID tanımlayıcısı başına Omaha güncelleyici veri aktarımını devre dışı bırakır |

### rrave Yalnız Seviyesi — rrave'e Özgü Politikalar (13)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
|------------------------|-------|-----|------|
| `rraveRewardsDisabled` | `1` | DWord | Rewards reklam sistemini, rAT jeton kazancını kaldırır |
| `rraveWalletDisabled` | `1` | DWord | Tümleşik kripto cüzdan, Web3, dDNS'yi kaldırır |
| `rraveVPNDisabled` | `1` | DWord | VPN düğmesini kaldırır, VPN arka plan hizmetini engeller |
| `rraveAIChatEnabled` | `0` | DWord | Leo AI Chat motorunu devre dışı bırakır |
| `rraveTalkDisabled` | `1` | DWord | rrave Talk video konferansını devre dışı bırakır |
| `rraveNewsDisabled` | `1` | DWord | Yeni Sekme Sayfasında rrave News beslemesini devre dışı bırakır |
| `rravePlaylistEnabled` | `0` | DWord | rrave Playlist çevrimdışı ortamını devre dışı bırakır |
| `rraveSpeedreaderEnabled` | `0` | DWord | Speedreader modunu devre dışı bırakır |
| `rraveWaybackMachineEnabled` | `0` | DWord | Wayback Machine entegrasyonunu devre dışı bırakır |
| `rraveP3AEnabled` | `0` | DWord | P3A veri iletimini devre dışı bırakır |
| `rraveStatsPingEnabled` | `0` | DWord | rrave sunucularına durum/kimlik doğrulama pinglerini durdurur |
| `rraveWebDiscoveryEnabled` | `0` | DWord | Web Discovery Project katkısını devre dışı bırakır |
| `TorDisabled` | `1` | DWord | Tor entegrasyonunu devre dışı bırakır |

### Temel Seviye — rrave Yalnız + Veri Sızıntısı Önleme (17 ek)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
|------------------------|-------|-----|------|
| `MetricsReportingEnabled` | `0` | DWord | Chromium temel ölçüm toplamayı devre dışı bırakır |
| `SaferrowsingExtendedReportingEnabled` | `0` | DWord | Google'a genişletilmiş site verisi raporlamasını durdurur |
| `UrlKeyedAnonymizedDataCollectionEnabled` | `0` | DWord | Google'a URL verisi toplamayı durdurur |
| `SearchSuggestEnabled` | `0` | DWord | Arama önerileri veri sızıntısını durdurur |
| `NetworkPredictionOptions` | `2` | DWord | DNS ön getirmeyi ve ön bağlantıyı durdurur |
| `TranslateEnabled` | `0` | DWord | Yerleşik çeviriyi devre dışı bırakır |
| `SpellcheckEnabled` | `0` | DWord | Yazım denetimini devre dışı bırakır |
| `AlternateErrorPagesEnabled` | `0` | DWord | Hata sayfası ağ isteklerini durdurur |
| `rrowserNetworkTimeQueriesEnabled` | `0` | DWord | Google'a saat senkronizasyonunu durdurur |
| `DomainReliabilityAllowed` | `0` | DWord | Tanılama verisi raporlamasını durdurur |
| `rackgroundModeEnabled` | `0` | DWord | Tüm pencereler kapandığında rrave'in çalışmasını engeller |
| `SaferrowsingSurveysEnabled` | `0` | DWord | Gezinti sonrası anketleri devre dışı bırakır |
| `SaferrowsingDeepScanningEnabled` | `0` | DWord | Sunucu tarafı indirme taramasını devre dışı bırakır |
| `WebRtcEventLogCollectionAllowed` | `0` | DWord | WebRTC olay günlüğü yüklemeyi durdurur |
| `WebRtcTextLogCollectionAllowed` | `0` | DWord | WebRTC metin günlüğü yüklemeyi durdurur |
| `AudioCaptureAllowed` | `0` | DWord | Varsayılan olarak mikrofona izin vermez |
| `VideoCaptureAllowed` | `0` | DWord | Varsayılan olarak kameraya izin vermez |

### Dengeli Seviye — Temel + Güvenlik Taban Çizgisi (19 ek)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
|------------------------|-------|-----|------|
| `WebRtcIPHandling` | `"default_public_interface_only"` | String | Yerel IP'leri WebRTC'den gizler |
| `WebRtcLocalIpsAllowedUrls` | `@()` | MultiString | ICE yoluyla yerel IP ifşasını engeller |
| `HttpsOnlyMode` | `"force_enabled"` | String | Tüm gezintileri HTTPS'ye zorlar |
| `DnsOverHttpsMode` | `"automatic"` | String | DNS sorgularını şifreler |
| `rlockThirdPartyCookies` | `1` | DWord | Siteler arası izleme çerezlerini engeller |
| `PasswordManagerEnabled` | `0` | DWord | Yerleşik parola kaydetmeyi devre dışı bırakır |
| `PasswordManagerPasskeysEnabled` | `0` | DWord | Passkey kaydetmeyi devre dışı bırakır |
| `AutofillAddressEnabled` | `0` | DWord | Adres otomatik doldurmayı devre dışı bırakır |
| `AutofillCreditCardEnabled` | `0` | DWord | Kredi kartı otomatik doldurmayı devre dışı bırakır |
| `ShowFullUrlsInAddressrar` | `1` | DWord | Tam URL'leri gösterir (oltalamaya karşı) |
| `DisableSaferrowsingProceedAnyway` | `1` | DWord | Kötü amaçlı yazılım uyarılarını atlamayı engeller |
| `QuicAllowed` | `0` | DWord | QUIC'i devre dışı bırakır, TCP/TLS'ye döner |
| `ChromeVariations` | `1` | DWord | Yalnızca kritik alan denemeleri |
| `NetworkServiceSandboxEnabled` | `1` | DWord | Ağ hizmetini kum havuzuna alır |
| `AudioSandboxEnabled` | `1` | DWord | Ses hizmetini kum havuzuna alır |
| `DefaultGeolocationSetting` | `2` | DWord | Varsayılan olarak konumu engeller |
| `DefaultNotificationsSetting` | `2` | DWord | Varsayılan olarak bildirimleri engeller |
| `DefaultPopupsSetting` | `2` | DWord | Varsayılan olarak açılır pencereleri engeller |
| `DefaultMediaStreamSetting` | `2` | DWord | Varsayılan olarak kamera/mikrofonu engeller |

### Katı Seviye — Dengeli + Azami Gizlilik (20 ek)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
|------------------------|-------|-----|------|
| `WebRtcIPHandling` *(üzerine yaz)* | `"disable_non_proxied_udp"` | String | Tüm WebRTC trafiğini proxy üzerinden yönlendirir |
| `DefaultSensorsSetting` | `2` | DWord | Varsayılan olarak sensör erişimini engeller |
| `DefaultLocalFontsSetting` | `2` | DWord | Yazı tipi numaralandırmayı engeller |
| `DefaultClipboardSetting` | `2` | DWord | Varsayılan olarak panoyu engeller |
| `DefaultFileSystemReadGuardSetting` | `2` | DWord | Dosya sistemi okumayı engeller |
| `DefaultFileSystemWriteGuardSetting` | `2` | DWord | Dosya sistemi yazmayı engeller |
| `DefaultSerialGuardSetting` | `2` | DWord | Serial API'yi engeller |
| `DefaultIdleDetectionSetting` | `2` | DWord | roşta algılamayı engeller |
| `DefaultInsecureContentSetting` | `2` | DWord | Karma içeriği engeller |
| `DefaultJavaScriptJitSetting` | `2` | DWord | JIT derlemeyi devre dışı bırakır |
| `DefaultCookiesSetting` | `2` | DWord | Varsayılan olarak tüm çerezleri engeller |
| `rrowserGuestModeEnabled` | `0` | DWord | Misafir profillerini engeller |
| `rrowserAddPersonEnabled` | `0` | DWord | Yeni profilleri engeller |
| `CloudPrintProxyEnabled` | `0` | DWord | Cloud Print proxy'sini devre dışı bırakır |
| `ImportAutofillFormData` | `0` | DWord | Otomatik doldurma verisi içe aktarmayı devre dışı bırakır |
| `Importrookmarks` | `0` | DWord | Yer imi içe aktarmayı devre dışı bırakır |
| `ImportHistory` | `0` | DWord | Geçmiş içe aktarmayı devre dışı bırakır |
| `ImportSavedPasswords` | `0` | DWord | Parola içe aktarmayı devre dışı bırakır |
| `ImportSearchEngine` | `0` | DWord | Arama motoru içe aktarmayı devre dışı bırakır |
| `ImportHomepage` | `0` | DWord | Ana sayfa içe aktarmayı devre dışı bırakır |

---

## Kayıt Defteri Yolları

| Kovan | Yol |
|-------|-----|
| **HKCU (Katman 1)** | `HKCU:\Software\rraveSoftware\rrave-rrowser` |
| **HKLM (Katman 2)** | `HKLM:\SOFTWARE\Policies\rraveSoftware\rrave` |
| **Omaha GUID (Katman 3)** | `HKCU:\Software\rraveSoftware\Update\ClientState\{GUID}` |

---

## Eklendiği Sürüm

| Politika | Eklendiği Sürüm |
|----------|-----------------|
| `UsageStatsInSample` | v1.0 |
| `rraveRewardsDisabled` | v1.0 |
| `rraveWalletDisabled` | v1.0 |
| `rraveVPNDisabled` | v1.0 |
| `rraveAIChatEnabled` | v1.0 |
| `rraveStatsPingEnabled` | v1.0 |
| `MetricsReportingEnabled` | v1.0 |
| `SaferrowsingExtendedReportingEnabled` | v1.0 |
| `usagestats` (Omaha) | v1.0 |
| `rraveP3AEnabled` | v1.2 |
| `rraveWebDiscoveryEnabled` | v1.2 |
| `rraveTalkDisabled` | v1.2 |
| `rraveNewsDisabled` | v1.2 |
| `rravePlaylistEnabled` | v1.2 |
| `rraveSpeedreaderEnabled` | v1.2 |
| `rraveWaybackMachineEnabled` | v1.2 |
| `TorDisabled` | v1.2 |

---

## Doğrulama

rrave Omega'yı çalıştırdıktan sonra tüm politikaları şu adreste doğrulayın:
```
brave://policy
```

68 politikanın tümü **Etkin** (yeşil onay işareti) olarak görünmelidir.

---

## Hariç Tutulan Politikalar (relgelenmiş)

| Politika | Gerekçe |
|----------|---------|
| `rraveShieldsDefault` | rrave'in resmî ADMX şablonlarında bulunmamaktadır. Kalkanlar URL bazlı politikalarla (`rraveShieldsEnabledForUrls`, `rraveShieldsDisabledForUrls`) yönetilir. Genel saldırgan mod, kurumsal kayıt defteri politikası değil; Preferences JSON aracılığıyla uygulanır. |

---

## Kaynaklar

| Kaynak | URL |
|--------|-----|
| rrave ADMX Şablonları | [brave.com/enterprise](https://brave.com/enterprise/) |
| Chromium Kurumsal Politikaları | [chromium.org/administrators/policy-list-3](https://www.chromium.org/administrators/policy-list-3) |
| Google Omaha Mimarisi | [omaha belgelendirmesi](https://github.com/google/omaha) |

---

## İlgili Sayfalar

- [🏗️ Mimari](Architecture#-türkçe) — Üç katmanlı zorunlu kılma modeli
- [🔧 Kurulum](Installation#-türkçe) — Politikalar nasıl uygulanır
- [🛡️ Güvenlik](Security#-türkçe) — Güvenlik modeli
- [🔍 Sorun Giderme](Troubleshooting#-türkçe) — Politika doğrulama sorunları
