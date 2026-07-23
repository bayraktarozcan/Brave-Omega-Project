# Rejected & Removed Policies Database

> **Brave Omega Project** — Community Edition
> Comprehensive record of all policies that were removed, rejected, or never shipped in production across all versions.

> 🇹🇷 **Türkçe:** Tüm sürümlerde üretimden kaldırılan, reddedilen veya hiç üretime geçmeyen politikaların kapsamlı kaydı.

---

## Summary

| Metric | Count |
|--------|-------|
| Total policies ever removed/rejected | 33 |
| Deprecated by Chromium/Chrome | 9 |
| Blocked by Brave | 3 |
| Unrecognized by Brave | 11 |
| Redundant (superseded) | 2 |
| Origin-only / not in stable | 1 |
| Future/unreleased | 1 |
| Cloud-only (not local) | 3 |
| Deprecated function (not a policy) | 1 |
| Never shipped (planned only) | 2 |

> 🇹🇷 **Türkçe:**
>
> | Metrik | Sayı |
> |--------|------|
> | Toplam kaldırılan/reddedilen politika | 33 |
> | Chromium/Chrome tarafından kademeli olarak kaldırılan | 9 |
> | Brave tarafından engellenen | 3 |
> | Brave tarafından tanınmayan | 11 |
> | Gereksiz (yerine geçen) | 2 |
> | Yalnızca origin / stabilde olmayan | 1 |
> | Gelecek/yayınlanmamış | 1 |
> | Yalnızca bulut tabanlı (yerel olmayan) | 3 |
> | Kaldırılmış işlev (politika değil) | 1 |
> | Hiç üretime geçmeyen (yalnızca planlanan) | 2 |

---

## Policies Removed from Production Code
## Üretim Kodundan Kaldırılan Politikalar

### 1. BraveShieldsDefault

| Field | Value |
|-------|-------|
| **Policy Name** | `BraveShieldsDefault` |
| **Version Removed** | v1.1 (2026-06-05) |
| **Tier at Removal** | Brave Only (all tiers) |
| **Reason** | Not in Brave's official ADMX — does not exist as a Chromium enterprise policy |
| **Category** | Brave-specific |
| **Was in Production** | Yes (v1.0 only) |
| **Notes** | Removed to prevent creating non-functional registry entries. The policy was included in the initial v1.0 release but was discovered to not exist in Brave's ADMX templates during validation. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `BraveShieldsDefault` |
> | **Kaldırıldığı Sürüm** | v1.1 (2026-06-05) |
> | **Kaldırıldığı Katman** | Brave Only (tüm katmanlar) |
> | **Neden** | Brave'in resmi ADMX'sinde yok — Chromium kurumsal politikası olarak mevcut değil |
> | **Kategori** | Brave'e özgü |
> | **Üretimde Oldu mu** | Evet (yalnızca v1.0) |
> | **Notlar** | Çalışmayan kayıt defteri girdileri oluşturmasını önlemek için kaldırıldı. Politika, ilk v1.0 sürümüne dahil edilmişti ancak doğrulama sırasında Brave'in ADMX şablonlarında bulunmadığı keşfedildi. |

---

### 2. CloudPrintProxyEnabled

| Field | Value |
|-------|-------|
| **Policy Name** | `CloudPrintProxyEnabled` |
| **Version Removed** | v2.1.6 (2026-07-04) |
| **Tier at Removal** | Strict (L4 at the time) |
| **Reason** | Deprecated by Chromium — Google Cloud Print service fully shut down |
| **Category** | Legacy services |
| **Was in Production** | Yes (v2.0 → v2.1.5) |
| **Notes** | Originally added in v2.0 as part of the Strict tier. Google Cloud Print was discontinued in December 2020, making this policy a no-op. Removed during the v2.1.6 policy expansion. Still present in the reset list for cleanup of legacy registry entries. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `CloudPrintProxyEnabled` |
> | **Kaldırıldığı Sürüm** | v2.1.6 (2026-07-04) |
> | **Kaldırıldığı Katman** | Strict (dönemin L4'ü) |
> | **Neden** | Chromium tarafından kademeli olarak kaldırıldı — Google Cloud Print hizmeti tamamen kapatıldı |
> | **Kategori** | Eski hizmetler |
> | **Üretimde Oldu mu** | Evet (v2.0 → v2.1.5) |
> | **Notlar** | Başlangıçta v2.0'da Strict katmanının parçası olarak eklendi. Google Cloud Print, Aralık 2020'de durduruldu, bu politikayı etkisiz hale getirdi. v2.1.6 politika genişlemesi sırasında kaldırıldı. Eski kayıt defteri girdilerini temizlemek için sıfırlama listesinde hâlâ mevcut. |

---

### 3. BraveLocalAIEnabled

| Field | Value |
|-------|-------|
| **Policy Name** | `BraveLocalAIEnabled` |
| **Version Removed** | v2.2.0.1 (2026-07-06) |
| **Tier at Removal** | Brave Only |
| **Reason** | Origin-only policy — not recognized by Brave 1.92.134 stable |
| **Category** | Brave-specific |
| **Was in Production** | Yes (v2.1.6 → v2.2.0.0) |
| **Notes** | Was an Origin-only policy (Brave PR #37357) that had not yet been promoted to the stable channel. Caused "Hata: Bilinmeyen politika" (Error: Unknown policy) errors in brave://policy/. Removed in the v2.2.0.1 refinement release along with duplicate cleanup. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `BraveLocalAIEnabled` |
> | **Kaldırıldığı Sürüm** | v2.2.0.1 (2026-07-06) |
> | **Kaldırıldığı Katman** | Brave Only |
> | **Neden** | Yalnızca origin politikası — Brave 1.92.134 stabil tarafından tanınmıyor |
> | **Kategori** | Brave'e özgü |
> | **Üretimde Oldu mu** | Evet (v2.1.6 → v2.2.0.0) |
> | **Notlar** | Henüz stabil kanala geçirilmemiş bir Yalnızca origin politikasıydı (Brave PR #37357). brave://policy/ bölümünde "Hata: Bilinmeyen politika" hatalarına neden oldu. v2.2.0.1 iyileştirme sürümünde yinelenen temizlikle birlikte kaldırıldı. |

---

### 4. DefaultMediaStreamSetting

| Field | Value |
|-------|-------|
| **Policy Name** | `DefaultMediaStreamSetting` |
| **Version Removed (1st)** | v2.1.1 (2026-06-18) |
| **Tier at Removal (1st)** | Balanced |
| **Version Re-added** | v2.4.0.0 (2026-07-11) |
| **Tier Re-added** | Advanced |
| **Version Removed (2nd)** | v2.4.1.0 (2026-07-12) |
| **Tier at Removal (2nd)** | Advanced |
| **Reason** | Deprecated in Chromium 104+ — replaced by `DefaultCameraSetting` and `DefaultMicrophoneSetting` for granular camera/microphone control |
| **Category** | Hardware access / Privacy |
| **Was in Production** | Yes (v2.0 → v2.1.0, then v2.4.0.0 only) |
| **Notes** | First removed in v2.1.1 as deprecated, with camera/mic blocking already covered by `AudioCaptureAllowed` and `VideoCaptureAllowed` in Essential tier. Re-added in v2.4.0.0 (Phase 9) in the new Advanced tier, then immediately removed again in v2.4.1.0 after runtime verification confirmed deprecation on Brave 150. A cautionary tale about re-adding deprecated policies. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `DefaultMediaStreamSetting` |
> | **Kaldırıldığı Sürüm (1.)** | v2.1.1 (2026-06-18) |
> | **Kaldırıldığı Katman (1.)** | Balanced |
> | **Yeniden Eklendiği Sürüm** | v2.4.0.0 (2026-07-11) |
> | **Yeniden Eklendiği Katman** | Advanced |
> | **Kaldırıldığı Sürüm (2.)** | v2.4.1.0 (2026-07-12) |
> | **Kaldırıldığı Katman (2.)** | Advanced |
> | **Neden** | Chromium 104+'da kademeli olarak kaldırıldı — ayrıntılı kamera/mikrofon kontrolü için `DefaultCameraSetting` ve `DefaultMicrophoneSetting` ile değiştirildi |
> | **Kategori** | Donanım erişimi / Gizlilik |
> | **Üretimde Oldu mu** | Evet (v2.0 → v2.1.0, ardından yalnızca v2.4.0.0) |
> | **Notlar** | İlk olarak v2.1.1'de kademeli olarak kaldırıldı, kamera/mikrofon engelleme zaten Essential katmanındaki `AudioCaptureAllowed` ve `VideoCaptureAllowed` tarafından sağlanıyordu. v2.4.0.0'da (Faz 9) yeni Advanced katmanına yeniden eklendi, ardından Brave 150'de doğrulama doğrulaması kademeli olarak kaldırıldığını onayladıktan hemen sonra v2.4.1.0'da tekrar kaldırıldı. Kaldırılmış politikaları yeniden ekleme konusunda uyarıcı bir hikaye. |

---

### 5. AllowPopupsDuringPageUnload

| Field | Value |
|-------|-------|
| **Policy Name** | `AllowPopupsDuringPageUnload` |
| **Version Removed** | v2.3.0.0 (fix commit, 2026-07-09) |
| **Tier at Removal** | Advanced |
| **Reason** | Deprecated by Chromium v104 — shows "Hata" (Error) in brave://policy/ on Brave 1.92.x |
| **Category** | UI behavior |
| **Was in Production** | Briefly (within v2.3.0.0 development, removed before release) |
| **Notes** | Was added as part of the Phase 8 policy expansion but removed in a fix commit (`d1bf197`) before the final v2.3.0.0 release. Policy counts adjusted from 115→114. The Chromium policy was deprecated since v104 and Brave's implementation showed runtime errors. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `AllowPopupsDuringPageUnload` |
> | **Kaldırıldığı Sürüm** | v2.3.0.0 (düzeltme commit'i, 2026-07-09) |
> | **Kaldırıldığı Katman** | Advanced |
> | **Neden** | Chromium v104 tarafından kademeli olarak kaldırıldı — Brave 1.92.x'te brave://policy/ bölümünde "Hata" gösteriyor |
> | **Kategori** | Arayüz davranışı |
> | **Üretimde Oldu mu** | Kısa süreli (v2.3.0.0 geliştirme sürecinde, yayınlanmadan kaldırıldı) |
> | **Notlar** | Faz 8 politika genişlemesinin parçası olarak eklendi ancak son v2.3.0.0 yayınlanmadan önce bir düzeltme commit'inde (`d1bf197`) kaldırıldı. Politika sayıları 115→114 olarak ayarlandı. Chromium politikası v104'ten beri kademeli olarak kaldırılmıştı ve Brave'in uygulaması çalışma zamanı hataları gösteriyordu. |

---

### 6. ManifestV2ExtensionUnsupported

| Field | Value |
|-------|-------|
| **Policy Name** | `ManifestV2ExtensionUnsupported` |
| **Version Added** | v2.3.0.0 (2026-07-09) |
| **Version Removed** | v2.3.1.0 (2026-07-10) |
| **Tier at Removal** | Advanced |
| **Reason** | Unknown policy in Brave 1.92 — not recognized by the browser |
| **Category** | Extension management |
| **Was in Production** | Yes (v2.3.0.0 only) |
| **Notes** | Was intended to deprecate Manifest V2 extensions in preparation for the MV2 sunset. However, Brave 1.92 does not recognize this policy. Removed in the v2.3.1.0 fix commit (`ea83abd`). The related `ExtensionManifestV2Availability` policy (see below) was also rejected. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `ManifestV2ExtensionUnsupported` |
> | **Eklendiği Sürüm** | v2.3.0.0 (2026-07-09) |
> | **Kaldırıldığı Sürüm** | v2.3.1.0 (2026-07-10) |
> | **Kaldırıldığı Katman** | Advanced |
> | **Neden** | Brave 1.92'de bilinmeyen politika — tarayıcı tarafından tanınmıyor |
> | **Kategori** | Eklenti yönetimi |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.3.0.0) |
> | **Notlar** | MV2 gün batımına hazırlık olarak Manifest V2 eklentilerini kademeli olarak kaldırmak amaçlanmıştı. Ancak Brave 1.92 bu politikayı tanımıyor. v2.3.1.0 düzeltme commit'inde (`ea83abd`) kaldırıldı. İlgili `ExtensionManifestV2Availability` politikası da (aşağıya bakın) reddedildi. |

---

### 7. DeveloperToolsDisabled

| Field | Value |
|-------|-------|
| **Policy Name** | `DeveloperToolsDisabled` |
| **Version Added** | v2.3.0.0 (2026-07-09) |
| **Version Removed** | v2.3.1.0 (2026-07-10) |
| **Tier at Removal** | Advanced |
| **Reason** | Deprecated — superseded by `DeveloperToolsAvailability=2` |
| **Category** | Developer tools / Security |
| **Was in Production** | Yes (v2.3.0.0 only) |
| **Notes** | Was a legacy policy that was deprecated in favor of `DeveloperToolsAvailability`. The v2.3.0.0 release included both policies (redundantly), and v2.3.1.0 removed the deprecated one. `DeveloperToolsAvailability=2` (admin-managed ban) provides stronger enforcement. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `DeveloperToolsDisabled` |
> | **Eklendiği Sürüm** | v2.3.0.0 (2026-07-09) |
> | **Kaldırıldığı Sürüm** | v2.3.1.0 (2026-07-10) |
> | **Kaldırıldığı Katman** | Advanced |
> | **Neden** | Kademeli olarak kaldırıldı — `DeveloperToolsAvailability=2` ile değiştirildi |
> | **Kategori** | Geliştirici araçları / Güvenlik |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.3.0.0) |
> | **Notlar** | `DeveloperToolsAvailability` lehine kademeli olarak kaldırılmış eski bir politikaydı. v2.3.0.0 sürümü her iki politikayı da (gereksiz yere) içeriyordu ve v2.3.1.0 kademeli olarak kaldırılmış olanı kaldırdı. `DeveloperToolsAvailability=2` (yönetici tarafından yönetilen yasak) daha güçlü uygulama sağlar. |

---

### 8. BraveUpdateDisabled

| Field | Value |
|-------|-------|
| **Policy Name** | `BraveUpdateDisabled` |
| **Version Added** | v2.3.0.0 (2026-07-09) |
| **Version Removed** | v2.3.1.0 (2026-07-10) |
| **Tier at Removal** | Advanced |
| **Reason** | Unknown policy in Brave 1.92 — not recognized by the browser |
| **Category** | Update management |
| **Was in Production** | Yes (v2.3.0.0 only) |
| **Notes** | Was intended to disable automatic Brave browser updates for maximum lockdown scenarios. Brave 1.92 does not recognize this Chromium policy. Removed in the v2.3.1.0 fix commit. Deployments requiring update control must use alternative methods (e.g., Group Policy software restriction). |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `BraveUpdateDisabled` |
> | **Eklendiği Sürüm** | v2.3.0.0 (2026-07-09) |
> | **Kaldırıldığı Sürüm** | v2.3.1.0 (2026-07-10) |
> | **Kaldırıldığı Katman** | Advanced |
> | **Neden** | Brave 1.92'de bilinmeyen politika — tarayıcı tarafından tanınmıyor |
> | **Kategori** | Güncelleme yönetimi |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.3.0.0) |
> | **Notlar** | Maksimum kilitlenme senaryoları için Brave tarayıcı otomatik güncellemelerini devre dışı bırakmak amaçlanmıştı. Brave 1.92 bu Chromium politikasını tanımıyor. v2.3.1.0 düzeltme commit'inde kaldırıldı. Güncelleme kontrolü gerektiren dağıtımlar alternatif yöntemler kullanmalıdır (ör. Grup Politikası yazılım kısıtlaması). |

---

### 9. DefaultDirectSocketsSetting

| Field | Value |
|-------|-------|
| **Policy Name** | `DefaultDirectSocketsSetting` |
| **Version Added** | v2.3.0.0 (2026-07-09) |
| **Version Removed** | v2.3.1.0 (2026-07-10) |
| **Tier at Removal** | Essential |
| **Reason** | Future/unreleased policy — not yet available in Brave stable |
| **Category** | Network API / Hardware access |
| **Was in Production** | Yes (v2.3.0.0 only) |
| **Notes** | Was included to block the Direct Sockets API, which allows websites to open raw TCP/UDP sockets. The policy exists in Chromium's ADMX templates but is not yet active in Brave 1.92 stable. Removed as it had no effect. May be re-added when Brave ships support for this policy. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `DefaultDirectSocketsSetting` |
> | **Eklendiği Sürüm** | v2.3.0.0 (2026-07-09) |
> | **Kaldırıldığı Sürüm** | v2.3.1.0 (2026-07-10) |
> | **Kaldırıldığı Katman** | Essential |
> | **Neden** | Gelecek/yayınlanmamış politika — Brave stabilde henüz mevcut değil |
> | **Kategori** | Ağ API'si / Donanım erişimi |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.3.0.0) |
> | **Notlar** | Web sitelerinin ham TCP/UDP soketleri açmasına olanak tanıyan Direct Sockets API'sini engellemek için dahil edildi. Politika Chromium'un ADMX şablonlarında mevcut ancak Brave 1.92 stabilde henüz aktif değil. Etkisi olmadığı için kaldırıldı. Brave bu politika için destek gönderdiğinde yeniden eklenebilir. |

---

### 10. AutoFillEnabled

| Field | Value |
|-------|-------|
| **Policy Name** | `AutoFillEnabled` |
| **Version Added** | v2.4.0.0 (2026-07-11) |
| **Version Removed** | v2.4.1.0 (2026-07-12) |
| **Tier at Removal** | Balanced |
| **Reason** | Deprecated in recent Chromium — master autofill toggle now controlled by `AutofillAddressEnabled` and `AutofillCreditCardEnabled` |
| **Category** | Form data / Privacy |
| **Was in Production** | Yes (v2.4.0.0 only) |
| **Notes** | Was added in Phase 9 to disable the master autofill toggle. Redundant because `AutofillAddressEnabled=0` and `AutofillCreditCardEnabled=0` (already in Balanced tier since v2.0) provide the same coverage. Removed in the v2.4.1.0 cleanup after runtime verification. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `AutoFillEnabled` |
> | **Eklendiği Sürüm** | v2.4.0.0 (2026-07-11) |
> | **Kaldırıldığı Sürüm** | v2.4.1.0 (2026-07-12) |
> | **Kaldırıldığı Katman** | Balanced |
> | **Neden** | Son Chromium sürümlerinde kademeli olarak kaldırıldı — ana otomatik doldurma anahtarı artık `AutofillAddressEnabled` ve `AutofillCreditCardEnabled` tarafından kontrol ediliyor |
> | **Kategori** | Form verisi / Gizlilik |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.4.0.0) |
> | **Notlar** | Ana otomatik doldurma anahtarını devre dışı bırakmak için Faz 9'da eklendi. `AutofillAddressEnabled=0` ve `AutofillCreditCardEnabled=0` (v2.0'dan beri Balanced katmanında) aynı kapsamı sağladığı için gereksiz. Çalışma zamanı doğrulamasından sonra v2.4.1.0 temizliğinde kaldırıldı. |

---

### 11. SigninAllowed

| Field | Value |
|-------|-------|
| **Policy Name** | `SigninAllowed` |
| **Version Added** | v2.4.0.0 (2026-07-11) |
| **Version Removed** | v2.4.1.0 (2026-07-12) |
| **Tier at Removal** | Balanced (moved from Essential where it was added in v2.4.0.0) |
| **Reason** | Deprecated in Chrome 137+ — redundant with `BrowserSignin=0` |
| **Category** | Account sync / Privacy |
| **Was in Production** | Yes (v2.4.0.0 only) |
| **Notes** | Was added in Phase 9 at Essential tier to block Google account sign-in. `BrowserSignin=0` (also at Essential tier, added same version) already blocks the sign-in flow entirely. Deprecated in Chrome 137+. Removed in v2.4.1.0 as redundant. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `SigninAllowed` |
> | **Eklendiği Sürüm** | v2.4.0.0 (2026-07-11) |
> | **Kaldırıldığı Sürüm** | v2.4.1.0 (2026-07-12) |
> | **Kaldırıldığı Katman** | Balanced (v2.4.0.0'da eklendiği Essential'tan taşındı) |
> | **Neden** | Chrome 137+'da kademeli olarak kaldırıldı — `BrowserSignin=0` ile gereksiz |
> | **Kategori** | Hesap senkronizasyonu / Gizlilik |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.4.0.0) |
> | **Notlar** | Google hesap girişini engellemek için Faz 9'da Essential katmanında eklendi. `BrowserSignin=0` (aynı sürümde eklenen Essential katmanında) zaten giriş akışını tamamen engelliyor. Chrome 137+'da kademeli olarak kaldırıldı. Gereksiz olduğu için v2.4.1.0'da kaldırıldı. |

---

### 12. HomepageLocation

| Field | Value |
|-------|-------|
| **Policy Name** | `HomepageLocation` |
| **Version Added** | v2.4.0.0 (2026-07-11) |
| **Version Removed** | v2.4.1.0 (2026-07-12) |
| **Tier at Removal** | Advanced |
| **Reason** | Blocked by Brave — "Bu politika engellendiği için politikanın değeri yoksayılacak" (This policy is blocked, value will be ignored) |
| **Category** | Startup / UI |
| **Was in Production** | Yes (v2.4.0.0 only) |
| **Notes** | Was intended to set homepage to `about:blank`. Brave explicitly blocks this policy via its own policy enforcement layer. The registry value is written but Brave ignores it at runtime. Removed in v2.4.1.0 after runtime verification on Brave 150. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `HomepageLocation` |
> | **Eklendiği Sürüm** | v2.4.0.0 (2026-07-11) |
> | **Kaldırıldığı Sürüm** | v2.4.1.0 (2026-07-12) |
> | **Kaldırıldığı Katman** | Advanced |
> | **Neden** | Brave tarafından engellendi — "Bu politika engellendiği için politikanın değeri yoksayılacak" |
> | **Kategori** | Başlangıç / Arayüz |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.4.0.0) |
> | **Notlar** | Ana sayfayı `about:blank` olarak ayarlamak amaçlanmıştı. Brave, kendi politika uygulama katmanı aracılığıyla bu politikayı açıkça engelliyor. Kayıt defteri değeri yazılır ancak Brave çalışma zamanında yok sayar. Brave 150'de çalışma zamanı doğrulamasından sonra v2.4.1.0'da kaldırıldı. |

---

### 13. NewTabPageLocation

| Field | Value |
|-------|-------|
| **Policy Name** | `NewTabPageLocation` |
| **Version Added** | v2.4.0.0 (2026-07-11) |
| **Version Removed** | v2.4.1.0 (2026-07-12) |
| **Tier at Removal** | Advanced |
| **Reason** | Blocked by Brave — same as `HomepageLocation` |
| **Category** | Startup / UI |
| **Was in Production** | Yes (v2.4.0.0 only) |
| **Notes** | Was intended to set new tab page to `about:blank`. Brave blocks this policy value. Removed in v2.4.1.0. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `NewTabPageLocation` |
> | **Eklendiği Sürüm** | v2.4.0.0 (2026-07-11) |
> | **Kaldırıldığı Sürüm** | v2.4.1.0 (2026-07-12) |
> | **Kaldırıldığı Katman** | Advanced |
> | **Neden** | Brave tarafından engellendi — `HomepageLocation` ile aynı |
> | **Kategori** | Başlangıç / Arayüz |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.4.0.0) |
> | **Notlar** | Yeni sekme sayfasını `about:blank` olarak ayarlamak amaçlanmıştı. Brave bu politika değerini engelliyor. v2.4.1.0'da kaldırıldı. |

---

### 14. RestoreOnStartup

| Field | Value |
|-------|-------|
| **Policy Name** | `RestoreOnStartup` |
| **Version Added** | v2.4.0.0 (2026-07-11) |
| **Version Removed** | v2.4.1.0 (2026-07-12) |
| **Tier at Removal** | Advanced |
| **Reason** | Blocked by Brave — Brave controls startup behavior through its own settings |
| **Category** | Startup / Session |
| **Was in Production** | Yes (v2.4.0.0 only) |
| **Notes** | Was intended to restore last session on browser launch (DWord: 2). Brave does not honor this Chromium enterprise policy. Removed in v2.4.1.0. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `RestoreOnStartup` |
> | **Eklendiği Sürüm** | v2.4.0.0 (2026-07-11) |
> | **Kaldırıldığı Sürüm** | v2.4.1.0 (2026-07-12) |
> | **Kaldırıldığı Katman** | Advanced |
> | **Neden** | Brave tarafından engellendi — Brave başlangıç davranışını kendi ayarları aracılığıyla kontrol ediyor |
> | **Kategori** | Başlangıç / Oturum |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.4.0.0) |
> | **Notlar** | Tarayıcı başlatıldığında son oturumu geri yüklemek amaçlanmıştı (DWord: 2). Brave bu Chromium kurumsal politikasını onaylamıyor. v2.4.1.0'da kaldırıldı. |

---

### 15. TabFreezingEnabled

| Field | Value |
|-------|-------|
| **Policy Name** | `TabFreezingEnabled` |
| **Version Added** | v2.4.0.0 (2026-07-11) |
| **Version Removed** | v2.4.1.0 (2026-07-12) |
| **Tier at Removal** | Advanced |
| **Reason** | Unrecognized by Brave — "Bilinmeyen politika" (Unknown policy) |
| **Category** | Tab management / Performance |
| **Was in Production** | Yes (v2.4.0.0 only) |
| **Notes** | Was intended to disable tab freezing (DWord: 0) so background tabs stay active. Not a valid Chromium enterprise policy in Brave 150. Shows as "Unknown policy" in brave://policy/. Removed in v2.4.1.0. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `TabFreezingEnabled` |
> | **Eklendiği Sürüm** | v2.4.0.0 (2026-07-11) |
> | **Kaldırıldığı Sürüm** | v2.4.1.0 (2026-07-12) |
> | **Kaldırıldığı Katman** | Advanced |
> | **Neden** | Brave tarafından tanınmıyor — "Bilinmeyen politika" |
> | **Kategori** | Sekme yönetimi / Performans |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.4.0.0) |
> | **Notlar** | Arka plan sekmelerinin aktif kalması için sekme donmasını devre dışı bırakmak amaçlanmıştı (DWord: 0). Brave 150'de geçerli bir Chromium kurumsal politikası değil. brave://policy/ bölümünde "Bilinmeyen politika" olarak gösterilir. v2.4.1.0'da kaldırıldı. |

---

### 16. GenAiDefaultSettings

| Field | Value |
|-------|-------|
| **Policy Name** | `GenAiDefaultSettings` |
| **Version Added** | v2.4.0.0 (2026-07-11) |
| **Version Removed** | v2.4.1.0 (2026-07-12) |
| **Tier at Removal** | Strict |
| **Reason** | Requires cloud source configuration — ignored at local policy deployment |
| **Category** | AI integration / Privacy |
| **Was in Production** | Yes (v2.4.0.0 only) |
| **Notes** | Was intended to disable GenAI defaults. At runtime, Brave reports: "Politika bir bulut kaynağı tarafından belirlenmediği için yok sayıldı" (Policy was ignored because it was not set by a cloud source). This policy requires enterprise cloud management infrastructure (e.g., Google Admin Console) to function. Local REGISTRY deployment is insufficient. Removed in v2.4.1.0. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `GenAiDefaultSettings` |
> | **Eklendiği Sürüm** | v2.4.0.0 (2026-07-11) |
> | **Kaldırıldığı Sürüm** | v2.4.1.0 (2026-07-12) |
> | **Kaldırıldığı Katman** | Strict |
> | **Neden** | Bulut kaynağı yapılandırması gerektiriyor — yerel politika dağıtımında yok sayılır |
> | **Kategori** | Yapay zeka entegrasyonu / Gizlilik |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.4.0.0) |
> | **Notlar** | GenAi varsayılanlarını devre dışı bırakmak amaçlanmıştı. Çalışma zamanında Brave şunu raporlar: "Politika bir bulut kaynağı tarafından belirlenmediği için yok sayıldı." Bu politikanın çalışması için kurumsal bulut yönetim altyapısı (ör. Google Admin Console) gerekir. Yerel KAYIT DEFTERİ dağıtımı yetersizdir. v2.4.1.0'da kaldırıldı. |

---

## Policies Rejected Before Production (Never in PS1 Scripts)
## Üretime Geçmeden Reddedilen Politikalar (PS1 Betiklerinde Hiç Olmayan)

### 17. ExtensionManifestV2Availability

| Field | Value |
|-------|-------|
| **Policy Name** | `ExtensionManifestV2Availability` |
| **Planned Version** | v2.4.0.0 (Phase 9) |
| **Reason** | Deprecated in Chrome 139 — MV2 sunset policy no longer functional |
| **Category** | Extension management |
| **Was in Production** | No — mentioned in CHANGELOG as "removed" but never committed to PS1 scripts |
| **Notes** | Was planned as part of the Phase 9 policy expansion to prepare for the Manifest V2 sunset. Deprecated in Chrome 139 before implementation could be completed. The CHANGELOG notes its removal, but git history shows it was never present in the PowerShell script policy definitions. Likely existed in a development branch that was not merged. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `ExtensionManifestV2Availability` |
> | **Planlanan Sürüm** | v2.4.0.0 (Faz 9) |
> | **Neden** | Chrome 139'da kademeli olarak kaldırıldı — MV2 gün batımı politikası artık çalışmıyor |
> | **Kategori** | Eklenti yönetimi |
> | **Üretimde Oldu mu** | Hayır — CHANGELOG'da "kaldırıldı" olarak bahsedildi ancak PS1 betiklerine hiç commit edilmedi |
> | **Notlar** | Manifest V2 gün batımına hazırlık için Faz 9 politika genişlemesinin parçası olarak planlanmıştı. Uygulama tamamlanmadan Chrome 139'da kademeli olarak kaldırıldı. CHANGELOG kaldırılmasını not eder ancak git geçmişi, PowerShell betiği politika tanımlarında hiç bulunmadığını gösteriyor. Muhtemelen birleştirilmemiş bir geliştirme dalında mevcuttu. |

---

### 18. DefaultThirdPartyStoragePartitioningSetting

| Field | Value |
|-------|-------|
| **Policy Name** | `DefaultThirdPartyStoragePartitioningSetting` |
| **Planned Version** | v2.4.0.0 (Phase 9) |
| **Reason** | Deprecated in Chrome 145 — third-party storage partitioning became mandatory |
| **Category** | Privacy / Storage |
| **Was in Production** | No — mentioned in CHANGELOG as "removed" but never committed to PS1 scripts |
| **Notes** | Was planned to control third-party storage partitioning behavior. Deprecated in Chrome 145 when storage partitioning became the default and mandatory behavior. Like `ExtensionManifestV2Availability`, mentioned in the CHANGELOG as removed but never actually present in the committed PS1 script code. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `DefaultThirdPartyStoragePartitioningSetting` |
> | **Planlanan Sürüm** | v2.4.0.0 (Faz 9) |
> | **Neden** | Chrome 145'te kademeli olarak kaldırıldı — üçüncü taraf depolama bölümlendirmesi zorunlu hale geldi |
> | **Kategori** | Gizlilik / Depolama |
> | **Üretimde Oldu mu** | Hayır — CHANGELOG'da "kaldırıldı" olarak bahsedildi ancak PS1 betiklerine hiç commit edilmedi |
> | **Notlar** | Üçüncü taraf depolama bölümlendirme davranışını kontrol etmek için planlanmıştı. Depolama bölümlendirmesi Chrome 145'te varsayılan ve zorunlu davranış haline geldiğinde kademeli olarak kaldırıldı. `ExtensionManifestV2Availability` gibi CHANGELOG'da kaldırıldı olarak bahsedildi ancak birleştirilmiş PS1 betik kodunda hiç bulunmadı. |

---

### 19. StartupUrls

| Field | Value |
|-------|-------|
| **Policy Name** | `StartupUrls` |
| **Planned Version** | Unknown (likely v2.4.0.0 planning) |
| **Reason** | Never implemented — likely blocked by Brave like `HomepageLocation` and `NewTabPageLocation` |
| **Category** | Startup |
| **Was in Production** | No — discussed in planning context only |
| **Notes** | Was considered as a companion to `HomepageLocation` and `NewTabPageLocation` for controlling startup URLs. Never made it to implementation, likely because Brave blocks similar startup/homepage policies. No git history found for this policy in any PS1 file. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `StartupUrls` |
> | **Planlanan Sürüm** | Bilinmiyor (muhtemelen v2.4.0.0 planlaması) |
> | **Neden** | Hiç uygulanmadı — muhtemelen `HomepageLocation` ve `NewTabPageLocation` gibi Brave tarafından engellendi |
> | **Kategori** | Başlangıç |
> | **Üretimde Oldu mu** | Hayır — yalnızca planlama bağlamında tartışıldı |
> | **Notlar** | Başlangıç URL'lerini kontrol etmek için `HomepageLocation` ve `NewTabPageLocation`'ın tamamlayıcısı olarak düşünüldü. Muhtemelen Brave benzer başlangıç/ana sayfa politikalarını engellediği için uygulamaya geçmedi. Herhangi bir PS1 dosyasında bu politika için git geçmişi bulunamadı. |

---

### 20. SSLVersionMin

| Field | Value |
|-------|-------|
| **Policy Name** | `SSLVersionMin` |
| **Planned Version** | Unknown |
| **Reason** | Never implemented — likely superseded by `EncryptedClientHelloEnabled` and TLS hardening |
| **Category** | Network security / TLS |
| **Was in Production** | No — discussed in planning context only |
| **Notes** | Was considered for forcing minimum SSL/TLS version. Never made it to implementation. Modern Chromium already defaults to TLS 1.2+, and `EncryptedClientHelloEnabled` (added in v2.2.1.0) provides stronger TLS hardening. No git history found for this policy. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `SSLVersionMin` |
> | **Planlanan Sürüm** | Bilinmiyor |
> | **Neden** | Hiç uygulanmadı — muhtemelen `EncryptedClientHelloEnabled` ve TLS sıkılaştırma ile değiştirildi |
> | **Kategori** | Ağ güvenliği / TLS |
> | **Üretimde Oldu mu** | Hayır — yalnızca planlama bağlamında tartışıldı |
> | **Notlar** | Minimum SSL/TLS sürümünü zorlamak için düşünüldü. Uygulamaya geçmedi. Modern Chromium zaten TLS 1.2+'yı varsayılan olarak kullanıyor ve `EncryptedClientHelloEnabled` (v2.2.1.0'da eklendi) daha güçlü TLS sıkılaştırma sağlıyor. Bu politika için git geçmişi bulunamadı. |

---

### 21. InstantMessageSendingEnabled

| Field | Value |
|-------|-------|
| **Policy Name** | `InstantMessageSendingEnabled` |
| **Version Added** | v2.4.1.0 (2026-07-12) |
| **Version Removed** | v2.4.1.0 (2026-07-12) |
| **Tier at Removal** | Essential |
| **Reason** | Unrecognized by Brave — "Bilinmeyen politika" (Unknown policy) |
| **Category** | Data collection / Privacy |
| **Was in Production** | No — removed same version |
| **Notes** | Was intended to block Google IM service data collection (DWord: 0) with zero usability impact. Chromium ADMX policy exists, but Brave 1.92 (Chromium 150) does not recognize it. Shows as "Bilinmeyen politika" in brave://policy/. Removed immediately in v2.4.1.0. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `InstantMessageSendingEnabled` |
> | **Eklendiği Sürüm** | v2.4.1.0 (2026-07-12) |
> | **Kaldırıldığı Sürüm** | v2.4.1.0 (2026-07-12) |
> | **Kaldırıldığı Katman** | Essential |
> | **Neden** | Brave tarafından tanınmıyor — "Bilinmeyen politika" |
> | **Kategori** | Veri toplama / Gizlilik |
> | **Üretimde Oldu mu** | Hayır — aynı sürümde kaldırıldı |
> | **Notlar** | Google IM hizmeti veri toplamasını engellemek amaçlanmıştı (DWord: 0), sıfır kullanım etkisi ile. Chromium ADMX politikası mevcut, ancak Brave 1.92 (Chromium 150) onu tanımıyor. brave://policy/ bölümünde "Bilinmeyen politika" olarak gösterilir. v2.4.1.0'da hemen kaldırıldı. |

---

### 22. DoNotTrackEnabled

| Field | Value |
|-------|-------|
| **Policy Name** | `DoNotTrackEnabled` |
| **Version Added** | v2.4.1.0 (2026-07-12) |
| **Version Removed** | v2.4.1.0 (2026-07-12) |
| **Tier at Removal** | Balanced |
| **Reason** | Unrecognized by Brave — "Bilinmeyen politika" (Unknown policy) |
| **Category** | Privacy signal |
| **Was in Production** | No — removed same version |
| **Notes** | Was intended to send DNT header with browsing traffic (DWord: 1) as a semiotic signal. Chromium ADMX policy exists, but Brave 1.92 (Chromium 150) does not recognize it. Shows as "Bilinmeyen politika" in brave://policy/. DNT is a voluntary signal that most sites ignore; Brave Shields provides real tracking protection. Removed immediately in v2.4.1.0. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `DoNotTrackEnabled` |
> | **Eklendiği Sürüm** | v2.4.1.0 (2026-07-12) |
> | **Kaldırıldığı Sürüm** | v2.4.1.0 (2026-07-12) |
> | **Kaldırıldığı Katman** | Balanced |
> | **Neden** | Brave tarafından tanınmıyor — "Bilinmeyen politika" |
> | **Kategori** | Gizlilik sinyali |
> | **Üretimde Oldu mu** | Hayır — aynı sürümde kaldırıldı |
> | **Notlar** | Gezinti trafiğiyle birlikte DNT başlığı göndermek amaçlanmıştı (DWord: 1) sembolik bir sinyal olarak. Chromium ADMX politikası mevcut, ancak Brave 1.92 (Chromium 150) onu tanımıyor. brave://policy/ bölümünde "Bilinmeyen politika" olarak gösterilir. DNT isteğe bağlı bir sinyaldir ve çoğu site tarafından yok sayılır; Brave Shields gerçek izleme koruması sağlar. v2.4.1.0'da hemen kaldırıldı. |

---

### 23. CrossOriginOpPolicyHeader

| Field | Value |
|-------|-------|
| **Policy Name** | `CrossOriginOpPolicyHeader` |
| **Version Added** | v2.4.2.0 (2026-07-14) |
| **Version Removed** | v2.4.2.0 (2026-07-21, post-release cleanup) |
| **Tier at Removal** | Strict |
| **Reason** | Unrecognized by Brave — "Unknown policy" in brave://policy/ |
| **Category** | Cross-origin security |
| **Was in Production** | Yes (v2.4.2.0 only) |
| **Notes** | Was intended to enforce COOP header (Spectre mitigation) with value `require-corp`. Chromium ADMX exists but Brave's policy engine does not recognize it. Shows "Unknown policy" in brave://policy/. Removed in v2.4.2.0. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `CrossOriginOpPolicyHeader` |
> | **Eklendiği Sürüm** | v2.4.2.0 (2026-07-14) |
> | **Kaldırıldığı Sürüm** | v2.4.2.0 (2026-07-21, yayın sonrası temizlik) |
> | **Kaldırıldığı Katman** | Strict |
> | **Neden** | Brave tarafından tanınmıyor — brave://policy/ bölümünde "Bilinmeyen politika" |
> | **Kategori** | Çapraz köken güvenliği |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.4.2.0) |
> | **Notlar** | COOP başlığını zorlamak amaçlanmıştı (`require-corp` değeri ile, Spectre azaltma). Chromium ADMX mevcut ancak Brave'in politika motoru onu tanımıyor. brave://policy/ bölümünde "Bilinmeyen politika" olarak gösterilir. v2.4.2.0'da kaldırıldı. |

---

### 24. CrossOriginEmbedderPolicy

| Field | Value |
|-------|-------|
| **Policy Name** | `CrossOriginEmbedderPolicy` |
| **Version Added** | v2.4.2.0 (2026-07-14) |
| **Version Removed** | v2.4.2.0 (2026-07-21, post-release cleanup) |
| **Tier at Removal** | Strict |
| **Reason** | Unrecognized by Brave — "Unknown policy" in brave://policy/ |
| **Category** | Cross-origin security |
| **Was in Production** | Yes (v2.4.2.0 only) |
| **Notes** | Was intended to enforce COEP header (Spectre mitigation) with value `require-corp`. Same issue as CrossOriginOpPolicyHeader — Brave does not recognize this policy. Removed in v2.4.2.0. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `CrossOriginEmbedderPolicy` |
> | **Eklendiği Sürüm** | v2.4.2.0 (2026-07-14) |
> | **Kaldırıldığı Sürüm** | v2.4.2.0 (2026-07-21, yayın sonrası temizlik) |
> | **Kaldırıldığı Katman** | Strict |
> | **Neden** | Brave tarafından tanınmıyor — brave://policy/ bölümünde "Bilinmeyen politika" |
> | **Kategori** | Çapraz köken güvenliği |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.4.2.0) |
> | **Notlar** | COEP başlığını zorlamak amaçlanmıştı (`require-corp` değeri ile, Spectre azaltma). CrossOriginOpPolicyHeader ile aynı sorun — Brave bu politikayı tanımıyor. v2.4.2.0'da kaldırıldı. |

---

### 25. DanglingOriginCheckEnforcement

| Field | Value |
|-------|-------|
| **Policy Name** | `DanglingOriginCheckEnforcement` |
| **Version Added** | v2.4.2.0 (2026-07-14) |
| **Version Removed** | v2.4.2.0 (2026-07-21, post-release cleanup) |
| **Tier at Removal** | Strict |
| **Reason** | Unrecognized by Brave — "Unknown policy" in brave://policy/ |
| **Category** | Navigation security |
| **Was in Production** | Yes (v2.4.2.0 only) |
| **Notes** | Was intended to block dangling origin navigations (DWord: 1). Brave does not recognize this Chromium policy. Removed in v2.4.2.0. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `DanglingOriginCheckEnforcement` |
> | **Eklendiği Sürüm** | v2.4.2.0 (2026-07-14) |
> | **Kaldırıldığı Sürüm** | v2.4.2.0 (2026-07-21, yayın sonrası temizlik) |
> | **Kaldırıldığı Katman** | Strict |
> | **Neden** | Brave tarafından tanınmıyor — brave://policy/ bölümünde "Bilinmeyen politika" |
> | **Kategori** | Gezinti güvenliği |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.4.2.0) |
> | **Notlar** | Asılı köken gezintilerini engellemek amaçlanmıştı (DWord: 1). Brave bu Chromium politikasını tanımıyor. v2.4.2.0'da kaldırıldı. |

---

### 26. PasswordReuseDetectionEnabled

| Field | Value |
|-------|-------|
| **Policy Name** | `PasswordReuseDetectionEnabled` |
| **Version Added** | v2.4.2.0 (2026-07-14) |
| **Version Removed** | v2.4.2.0 (2026-07-21, post-release cleanup) |
| **Tier at Removal** | Strict |
| **Reason** | Unrecognized by Brave — "Unknown policy" in brave://policy/ |
| **Category** | Password security |
| **Was in Production** | Yes (v2.4.2.0 only) |
| **Notes** | Was intended to warn on password reuse (DWord: 1). Brave does not recognize this Chromium policy. Note: `PasswordLeakDetectionEnabled` (also Strict) IS recognized and remains active. Removed in v2.4.2.0. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `PasswordReuseDetectionEnabled` |
> | **Eklendiği Sürüm** | v2.4.2.0 (2026-07-14) |
> | **Kaldırıldığı Sürüm** | v2.4.2.0 (2026-07-21, yayın sonrası temizlik) |
> | **Kaldırıldığı Katman** | Strict |
> | **Neden** | Brave tarafından tanınmıyor — brave://policy/ bölümünde "Bilinmeyen politika" |
> | **Kategori** | Parola güvenliği |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.4.2.0) |
> | **Notlar** | Parola tekrarında uyarı vermek amaçlanmıştı (DWord: 1). Brave bu Chromium politikasını tanımıyor. Not: `PasswordLeakDetectionEnabled` (Strict'te) TANINIYOR ve aktif kalıyor. v2.4.2.0'da kaldırıldı. |

---

### 27. TabDiscardingEnabled

| Field | Value |
|-------|-------|
| **Policy Name** | `TabDiscardingEnabled` |
| **Version Added** | v2.4.2.0 (2026-07-14) |
| **Version Removed** | v2.4.2.0 (2026-07-21, post-release cleanup) |
| **Tier at Removal** | Strict |
| **Reason** | Unrecognized by Brave — "Unknown policy" in brave://policy/ |
| **Category** | Tab management / Memory |
| **Was in Production** | Yes (v2.4.2.0 only) |
| **Notes** | Was intended to enable tab discarding under memory pressure (DWord: 1). Brave does not recognize this Chromium policy. Removed in v2.4.2.0. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `TabDiscardingEnabled` |
> | **Eklendiği Sürüm** | v2.4.2.0 (2026-07-14) |
> | **Kaldırıldığı Sürüm** | v2.4.2.0 (2026-07-21, yayın sonrası temizlik) |
> | **Kaldırıldığı Katman** | Strict |
> | **Neden** | Brave tarafından tanınmıyor — brave://policy/ bölümünde "Bilinmeyen politika" |
> | **Kategori** | Sekme yönetimi / Bellek |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.4.2.0) |
> | **Notlar** | Bellek basıncında sekme atmayı etkinleştirmek amaçlanmıştı (DWord: 1). Brave bu Chromium politikasını tanımıyor. v2.4.2.0'da kaldırıldı. |

---

### 28. ContextualSearchEnabled

| Field | Value |
|-------|-------|
| **Policy Name** | `ContextualSearchEnabled` |
| **Version Added** | v2.4.2.0 (2026-07-14) |
| **Version Removed** | v2.4.2.0 (2026-07-21, post-release cleanup) |
| **Tier at Removal** | Strict |
| **Reason** | Unrecognized by Brave — "Unknown policy" in brave://policy/ |
| **Category** | Search / Privacy |
| **Was in Production** | Yes (v2.4.2.0 only) |
| **Notes** | Was intended to disable touch-to-search contextual search (DWord: 0). Brave does not recognize this Chromium policy. Removed in v2.4.2.0. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `ContextualSearchEnabled` |
> | **Eklendiği Sürüm** | v2.4.2.0 (2026-07-14) |
> | **Kaldırıldığı Sürüm** | v2.4.2.0 (2026-07-21, yayın sonrası temizlik) |
> | **Kaldırıldığı Katman** | Strict |
> | **Neden** | Brave tarafından tanınmıyor — brave://policy/ bölümünde "Bilinmeyen politika" |
> | **Kategori** | Arama / Gizlilik |
> | **Üretimde Oldu mu** | Evet (yalnızca v2.4.2.0) |
> | **Notlar** | Dokunarak arama bağlam aramasını devre dışı bırakmak amaçlanmıştı (DWord: 0). Brave bu Chromium politikasını tanımıyor. v2.4.2.0'da kaldırıldı. |

---

## Policies Moved (Not Removed)
## Taşınan Politikalar (Kaldırılmayan)

These policies were relocated between tiers but remain in the codebase. Included for completeness.
Bu politikalar katmanlar arasında taşındı ancak kod tabanında kaldı. Eksiksizlik için dahil edildi.

### TranslateEnabled

| Field | Value |
|-------|-------|
| **Policy Name** | `TranslateEnabled` |
| **Version Moved** | v2.1.1 (2026-06-18) |
| **From Tier** | Essential (disable translation) |
| **To Tier** | Strict (disable translation) |
| **Reason** | Right-click translate feature is useful at lower tiers; only disabled at Strict for maximum privacy |
| **Notes** | Not a removal — relocated from Essential (L2) to Strict (L5). Users at Essential and Balanced levels can now use the translate feature. Only at Strict is translation disabled. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `TranslateEnabled` |
> | **Taşındığı Sürüm** | v2.1.1 (2026-06-18) |
> | **Aldığı Katman** | Essential (çevirmeyi devre dışı bırak) |
> | **Gittiği Katman** | Strict (çevirmeyi devre dışı bırak) |
> | **Neden** | Sağ tıklama çeviri özelliği alt katmanlarda faydalıdır; yalnızca maksimum gizlilik için Strict'te devre dışı bırakılır |
> | **Notlar** | Kaldırma değil — Essential'tan (L2) Strict'e (L5) taşındı. Essential ve Balanced düzeyindeki kullanıcılar artık çeviri özelliğini kullanabilir. Çeviri yalnızca Strict'te devre dışıdır. |

---

### WebRtcIPHandling (Duplicate Removal)

| Field | Value |
|-------|-------|
| **Policy Name** | `WebRtcIPHandling` |
| **Version Changed** | v2.2.0.2 (2026-07-07) / v2.2.1.0 (2026-07-07) |
| **Change** | Balanced upgraded to `disable_non_proxied_udp` (matching Strict); duplicate removed from Strict |
| **Reason** | Runtime no-op — Balanced and Strict had identical values |
| **Notes** | Not a policy rejection — an alignment/cleanup. The Balanced tier was upgraded to maximum WebRTC protection, making the Strict override redundant. The duplicate was removed to keep the policy count accurate. |

> 🇹🇷 **Türkçe:**
>
> | Alan | Değer |
> |------|-------|
> | **Politika Adı** | `WebRtcIPHandling` |
> | **Değiştiği Sürüm** | v2.2.0.2 (2026-07-07) / v2.2.1.0 (2026-07-07) |
> | **Değişiklik** | Balanced, Strict ile eşleşecek şekilde `disable_non_proxied_udp`'ye yükseltildi; Strict'ten kopya kaldırıldı |
> | **Neden** | Çalışma zamanı etkisiz — Balanced ve Strict aynı değerleri içeriyordu |
> | **Notlar** | Politika reddetme değil — hizalama/temizlik. Balanced katmanı maksimum WebRTC korumasına yükseltildi, bu da Strict geçersiz kılmayı gereksiz hale getirdi. Politika sayısını doğru tutmak için kopya kaldırıldı. |

---

## Removal Timeline
## Kaldırma Zaman Çizelgesi

```
v1.0   (2026-06-04)  — 7 policies (initial release)
                        7 politika (ilk sürüm)
  ↓
v1.1   (2026-06-05)  — BraveShieldsDefault removed (not in ADMX)
                        BraveShieldsDefault kaldırıldı (ADMX'de yok)
  ↓
v2.0   (2026-06-16)  — 68 policies (multi-tier rewrite)
                        68 politika (çok katmanlı yeniden yazım)
  ↓
v2.1.1 (2026-06-18)  — DefaultMediaStreamSetting removed from Balanced (deprecated)
                        TranslateEnabled moved Essential → Strict
                        DefaultMediaStreamSetting Balanced'tan kaldırıldı (kademeli)
                        TranslateEnabled taşındı Essential → Strict
  ↓
v2.1.6 (2026-07-04)  — CloudPrintProxyEnabled removed (deprecated)
                        CloudPrintProxyEnabled kaldırıldı (kademeli)
  ↓
v2.2.0.1 (2026-07-06) — BraveLocalAIEnabled removed (Origin-only)
                         BraveLocalAIEnabled kaldırıldı (Yalnızca origin)
  ↓
v2.2.1.0 (2026-07-07) — WebRtcIPHandling duplicate removed from Strict
                         WebRtcIPHandling kopyası Strict'ten kaldırıldı
  ↓
v2.3.0.0 (2026-07-09) — AllowPopupsDuringPageUnload removed (deprecated)
                         AllowPopupsDuringPageUnload kaldırıldı (kademeli)
  ↓
v2.3.1.0 (2026-07-10) — ManifestV2ExtensionUnsupported removed (unknown)
                          DeveloperToolsDisabled removed (deprecated)
                          BraveUpdateDisabled removed (unknown)
                          DefaultDirectSocketsSetting removed (future/unreleased)
                          ManifestV2ExtensionUnsupported kaldırıldı (bilinmeyen)
                          DeveloperToolsDisabled kaldırıldı (kademeli)
                          BraveUpdateDisabled kaldırıldı (bilinmeyen)
                          DefaultDirectSocketsSetting kaldırıldı (gelecek/yayınlanmamış)
  ↓
v2.4.0.0 (2026-07-11) — ExtensionManifestV2Availability removed (deprecated, planned only)
                          DefaultThirdPartyStoragePartitioningSetting removed (deprecated, planned only)
                          DefaultMediaStreamSetting re-added then immediately problematic
                          ExtensionManifestV2Availability kaldırıldı (kademeli, yalnızca planlanan)
                          DefaultThirdPartyStoragePartitioningSetting kaldırıldı (kademeli, yalnızca planlanan)
                          DefaultMediaStreamSetting yeniden eklendi ancak hemen sorunlu oldu
  ↓
v2.4.1.0 (2026-07-12) — AutoFillEnabled removed (deprecated, redundant)
                          SigninAllowed removed (deprecated, redundant)
                          DefaultMediaStreamSetting removed again (deprecated)
                          TabFreezingEnabled removed (unrecognized)
                          HomepageLocation removed (blocked by Brave)
                          NewTabPageLocation removed (blocked by Brave)
                          RestoreOnStartup removed (blocked by Brave)
                          GenAiDefaultSettings removed (cloud-only)
                          AutoFillEnabled kaldırıldı (kademeli, gereksiz)
                          SigninAllowed kaldırıldı (kademeli, gereksiz)
                          DefaultMediaStreamSetting tekrar kaldırıldı (kademeli)
                          TabFreezingEnabled kaldırıldı (tanınmayan)
                          HomepageLocation kaldırıldı (Brave tarafından engellendi)
                          NewTabPageLocation kaldırıldı (Brave tarafından engellendi)
                          RestoreOnStartup kaldırıldı (Brave tarafından engellendi)
                          GenAiDefaultSettings kaldırıldı (yalnızca bulut)
  ↓
v2.4.2.0 (2026-07-21) — CrossOriginOpPolicyHeader removed (unrecognized)
                          CrossOriginEmbedderPolicy removed (unrecognized)
                          DanglingOriginCheckEnforcement removed (unrecognized)
                          PasswordReuseDetectionEnabled removed (unrecognized)
                          TabDiscardingEnabled removed (unrecognized)
                          ContextualSearchEnabled removed (unrecognized)
                          CrossOriginOpPolicyHeader kaldırıldı (tanınmayan)
                          CrossOriginEmbedderPolicy kaldırıldı (tanınmayan)
                          DanglingOriginCheckEnforcement kaldırıldı (tanınmayan)
                          PasswordReuseDetectionEnabled kaldırıldı (tanınmayan)
                          TabDiscardingEnabled kaldırıldı (tanınmayan)
                          ContextualSearchEnabled kaldırıldı (tanınmayan)
```

---

## Categories of Rejection
## Reddetme Kategorileri

### Deprecated by Chromium/Chrome (9 policies)
### Chromium/Chrome Tarafından Kademeli Olarak Kaldırılan (9 politika)
Policies removed because Chromium/Chrome deprecated the underlying feature or replaced it with a more granular control.
Chromium/Chrome temel özelliği kademeli olarak kaldırdığı veya daha ayrıntılı bir kontrol ile değiştirdiği için kaldırılan politikalar.

| Policy | Replaced By |
|--------|-------------|
| `DefaultMediaStreamSetting` | `DefaultCameraSetting` + `DefaultMicrophoneSetting` |
| `AutoFillEnabled` | `AutofillAddressEnabled` + `AutofillCreditCardEnabled` |
| `SigninAllowed` | `BrowserSignin=0` |
| `DeveloperToolsDisabled` | `DeveloperToolsAvailability=2` |
| `CloudPrintProxyEnabled` | N/A (Google Cloud Print shut down) |
| `AllowPopupsDuringPageUnload` | N/A (policy deprecated) |
| `ExtensionManifestV2Availability` | N/A (MV2 sunset handled differently) |
| `DefaultThirdPartyStoragePartitioningSetting` | N/A (partitioning now mandatory) |
| `InsecureFormsWarningsEnabled` | N/A (deprecated in Brave 1.92) |

> 🇹🇷 **Türkçe:**
>
> | Politika | Yerine Geçen |
> |----------|--------------|
> | `DefaultMediaStreamSetting` | `DefaultCameraSetting` + `DefaultMicrophoneSetting` |
> | `AutoFillEnabled` | `AutofillAddressEnabled` + `AutofillCreditCardEnabled` |
> | `SigninAllowed` | `BrowserSignin=0` |
> | `DeveloperToolsDisabled` | `DeveloperToolsAvailability=2` |
> | `CloudPrintProxyEnabled` | Yok (Google Cloud Print kapatıldı) |
> | `AllowPopupsDuringPageUnload` | Yok (politika kademeli olarak kaldırıldı) |
> | `ExtensionManifestV2Availability` | Yok (MV2 gün batımı farklı şekilde ele alınıyor) |
> | `DefaultThirdPartyStoragePartitioningSetting` | Yok (bölümleme artık zorunlu) |
> | `InsecureFormsWarningsEnabled` | Yok (Brave 1.92'de kademeli olarak kaldırıldı) |

### Blocked by Brave (3 policies)
### Brave Tarafından Engellenen (3 politika)
Policies where Brave's browser explicitly blocks the Chromium enterprise policy.
Brave tarayıcısının Chromium kurumsal politikasını açıkça engellediği politikalar.

| Policy | Brave Error Message |
|--------|-------------------|
| `HomepageLocation` | "Bu politika engellendiği için politikanın değeri yoksayılacak" |
| `NewTabPageLocation` | Same as HomepageLocation |
| `RestoreOnStartup` | Brave controls startup through its own settings |

> 🇹🇷 **Türkçe:**
>
> | Politika | Brave Hata Mesajı |
> |----------|-------------------|
> | `HomepageLocation` | "Bu politika engellendiği için politikanın değeri yoksayılacak" |
> | `NewTabPageLocation` | HomepageLocation ile aynı |
> | `RestoreOnStartup` | Brave başlangıcı kendi ayarları aracılığıyla kontrol eder |

### Unrecognized by Brave (11 policies)
### Brave Tarafından Tanınmayan (11 politika)
Policies not present in Brave's policy engine.
Brave'in politika motorunda bulunmayan politikalar.

| Policy | Brave Error |
|--------|-------------|
| `BraveShieldsDefault` | Not in Brave ADMX |
| `TabFreezingEnabled` | "Bilinmeyen politika" |
| `ManifestV2ExtensionUnsupported` | Unknown in Brave 1.92 |
| `InstantMessageSendingEnabled` | "Bilinmeyen politika" |
| `DoNotTrackEnabled` | "Bilinmeyen politika" |
| `CrossOriginOpPolicyHeader` | "Unknown policy" |
| `CrossOriginEmbedderPolicy` | "Unknown policy" |
| `DanglingOriginCheckEnforcement` | "Unknown policy" |
| `PasswordReuseDetectionEnabled` | "Unknown policy" |
| `TabDiscardingEnabled` | "Unknown policy" |
| `ContextualSearchEnabled` | "Unknown policy" |

> 🇹🇷 **Türkçe:**
>
> | Politika | Brave Hatası |
> |----------|--------------|
> | `BraveShieldsDefault` | Brave ADMX'sinde yok |
> | `TabFreezingEnabled` | "Bilinmeyen politika" |
> | `ManifestV2ExtensionUnsupported` | Brave 1.92'de bilinmiyor |
> | `InstantMessageSendingEnabled` | "Bilinmeyen politika" |
> | `DoNotTrackEnabled` | "Bilinmeyen politika" |
> | `CrossOriginOpPolicyHeader` | "Bilinmeyen politika" |
> | `CrossOriginEmbedderPolicy` | "Bilinmeyen politika" |
> | `DanglingOriginCheckEnforcement` | "Bilinmeyen politika" |
> | `PasswordReuseDetectionEnabled` | "Bilinmeyen politika" |
> | `TabDiscardingEnabled` | "Bilinmeyen politika" |
> | `ContextualSearchEnabled` | "Bilinmeyen politika" |

### Cloud-only (not local) (3 policies)
### Yalnızca bulut tabanlı (yerel olmayan) (3 politika)
Policies that require Brave Browser Cloud Management infrastructure; local HKLM registry deployment is ignored.
Brave Tarayıcı Bulut Yönetimi altyapısı gerektiren politikalar; yerel HKLM kayıt defteri dağıtımı yoksayılır.

| Policy | Brave Error Message |
|--------|-------------------|
| `GenAiDefaultSettings` | Requires cloud source, not local registry |
| `CacheEncryptionEnabled` | "Yalnızca bulut kullanıcı politikası olarak ayarlanabileceği için politika yoksayıldı" |
| `CloudReportingEnabled` | "Makine, Brave Tarayıcı Bulut Yönetimi'ne kayıtlı olmadığı için yok sayıldı" |

> 🇹🇷 **Türkçe:**
>
> | Politika | Brave Hata Mesajı |
> |----------|-------------------|
> | `GenAiDefaultSettings` | Bulut kaynağı gerektiriyor, yerel kayıt defteri değil |
> | `CacheEncryptionEnabled` | "Yalnızca bulut kullanıcı politikası olarak ayarlanabileceği için politika yoksayıldı" |
> | `CloudReportingEnabled` | "Makine, Brave Tarayıcı Bulut Yönetimi'ne kayıtlı olmadığı için yok sayıldı" |

### Other (4 policies)
### Diğer (4 politika)

| Policy | Reason |
|--------|--------|
| `BraveLocalAIEnabled` | Origin-only, not in stable channel |
| `DefaultDirectSocketsSetting` | Future/unreleased in Brave |
| `BraveUpdateDisabled` | Unknown in Brave 1.92 |
| `StartupUrls` / `SSLVersionMin` | Never implemented (planned only) |

> 🇹🇷 **Türkçe:**
>
> | Politika | Neden |
> |----------|-------|
> | `BraveLocalAIEnabled` | Yalnızca origin, stabil kanalda yok |
> | `DefaultDirectSocketsSetting` | Brave'de gelecek/yayınlanmamış |
> | `BraveUpdateDisabled` | Brave 1.92'de bilinmiyor |
> | `StartupUrls` / `SSLVersionMin` | Hiç uygulanmadı (yalnızca planlanan) |

---

## Lessons Learned
## Öğrenilen Dersler

1. **Always validate against brave://policy/** — Policies that exist in Chromium's ADMX may be blocked, ignored, or unrecognized by Brave.
2. **Check deprecation status before adding** — Several policies were added and immediately removed because they were deprecated in the target Chromium version.
3. **Redundancy detection** — `AutoFillEnabled` ve `SigninAllowed` were redundant with existing policies at the same tier.
4. **Cloud vs. local** — `GenAiDefaultSettings` requires enterprise cloud management infrastructure; local registry deployment is insufficient.
5. **Brave-specific overrides** — Brave blocks certain Chromium policies (homepage, new tab, startup) through its own enforcement layer.
6. **Don't re-add deprecated policies** — `DefaultMediaStreamSetting` was removed in v2.1.1, re-added in v2.4.0.0, and removed again in v2.4.1.0.
7. **Origin-only policies** — `BraveLocalAIEnabled` was an Origin-only policy that hadn't reached stable. Check policy promotion status.
8. **Document removals** — This file exists because removals were tracked. Future contributors can learn from past mistakes.
9. **Always test on brave://policy/** — Two policies (`InstantMessageSendingEnabled`, `DoNotTrackEnabled`) existed in Chromium ADMX but showed "Bilinmeyen politika" in Brave 1.92. Always verify before shipping.

> 🇹🇷 **Türkçe:**
>
> 1. **Her zaman brave://policy/Against doğrulayın** — Chromium'un ADMX'sinde bulunan politikalar Brave tarafından engellenebilir, yok sayılabilir veya tanınmayabilir.
> 2. **Eklemeden önce kademeli kaldırma durumunu kontrol edin** — Birkaç politika, hedef Chromium sürümünde kademeli olarak kaldırıldığı için eklendi ve hemen kaldırıldı.
> 3. **Gereksiz algılama** — `AutoFillEnabled` ve `SigninAllowed`, aynı katmandaki mevcut politikalarla gereksizdi.
> 4. **Bulut vs. yerel** — `GenAiDefaultSettings` kurumsal bulut yönetim altyapısı gerektirir; yerel kayıt defteri dağıtımı yetersizdir.
> 5. **Brave'e özgü geçersiz kılmalar** — Brave, kendi uygulama katmanı aracılığıyla belirli Chromium politikalarını (ana sayfa, yeni sekme, başlangıç) engeller.
> 6. **Kaldırılmış politikaları yeniden eklemeyin** — `DefaultMediaStreamSetting` v2.1.1'de kaldırıldı, v2.4.0.0'da yeniden eklendi ve v2.4.1.0'da tekrar kaldırıldı.
> 7. **Yalnızca origin politikaları** — `BraveLocalAIEnabled` stabilde ulaşmamış bir Yalnızca origin politikasıydı. Politika geçirme durumunu kontrol edin.
> 8. **Kaldırmaları belgeleyin** — Bu dosya kaldırma kayıtları takip edildiği için mevcuttur. Gelecekteki katılımcılar geçmiş hatalardan öğrenebilir.
> 9. **Her zaman brave://policy/'de test edin** — İki politika (`InstantMessageSendingEnabled`, `DoNotTrackEnabled`) Chromium ADMX'sinde mevcuttu ancak Brave 150'de "Bilinmeyen politika" olarak göründü. Üretime geçirmeden önce her zaman doğrulayın.

---

*Last updated: v2.5.1.0 (2026-07-23)*
*Total policies ever rejected/removed: 33*
*Current active policies: 150 (v2.5.1.0)*

*Son güncelleme: v2.5.1.0 (2026-07-23)*
*Toplam reddedilen/kaldırılan politika: 33*
*Mevcut aktif politikalar: 150 (v2.5.1.0)*
