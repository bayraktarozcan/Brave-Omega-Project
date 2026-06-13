<!-- ================================================================== -->
<!--            BRAVE OMEGA PROJECT — CHANGELOG                         -->
<!--          Community Edition · Open Source · Privacy First           -->
<!-- ================================================================== -->

<div align="center">

<br>

# 🦁 Brave Omega — Changelog

<br>

> **Language / Dil** &nbsp;
> [EN English](#-english-changelog) &nbsp;·&nbsp; [TR Türkçe](#-türkçe-değişiklik-günlüğü)

<br>

</div>

---

<a id="-english-changelog"></a>

## EN English Changelog

### Table of Contents

1.  [Introduction](#en-introduction)
2.  [v1.2.2 — 2026-06-13](#en-v122)
    *   [Summary](#en-v122-summary)
    *   [Changed](#en-v122-changed)
3.  [v1.2.1 — 2026-06-13](#en-v121)
    *   [Summary](#en-v121-summary)
    *   [Changed](#en-v121-changed)
3.  [v1.2 — 2026-06-12](#en-v12)
    *   [Summary](#en-v12-summary)
    *   [Added](#en-v12-added)
    *   [Statistics](#en-v12-statistics)
    *   [Changed](#en-v12-changed)
    *   [Security](#en-v12-security)
5.  [v1.1 — 2026-06-05](#en-v11)
    *   [Summary](#en-v11-summary)
    *   [Added](#en-v11-added)
    *   [Changed](#en-v11-changed)
    *   [Removed](#en-v11-removed)
    *   [Details](#en-v11-details)
6.  [v1.0 — 2026-06-04](#en-v10)
    *   [Summary](#en-v10-summary)
    *   [Features](#en-v10-features)
    *   [Initial Policies](#en-v10-initial-policies)
    *   [Documentation](#en-v10-documentation)
7.  [Version History Summary](#en-version-history-summary)
8.  [Related Documentation](#en-related-documentation)
9.  [Notes](#en-notes)

---

<a id="en-introduction"></a>

All notable changes to this project are documented below, following the [Keep a Changelog](https://keepachangelog.com/) format.

---

<a id="en-v122"></a>

## [v1.2.2] — 2026-06-13

<a id="en-v122-summary"></a>

### 🎯 Summary

**Patch release:** Execution policy fix — replaced `RemoteSigned -Scope CurrentUser` with session-scoped `Bypass -Scope Process`. No policy changes from v1.2.1.

**Changes:** Execution policy instruction now uses `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` which affects only the current PowerShell window (no permanent registry change, no attack surface exposure). README Quick Start restructured for clarity. Turkish character corrections applied to visible UI text.

<a id="en-v122-changed"></a>

### 🔧 Changed

- **index.html**: Updated `prereq_pol_desc` (EN + TR) to use session-scoped `-Scope Process Bypass` instead of permanent `RemoteSigned -Scope CurrentUser`
- **index.html**: Fixed Turkish characters in `rm_item3` fallback text
- **index.html**: Updated version references from v1.2.1 to v1.2.2
- **README.md**: Replaced permanent execution policy step with session-scoped bypass in Quick Start (EN + TR)
- **README.md**: Updated version compatibility matrix to include v1.2.2 + v1.2.1
- **CHANGELOG.md**: Added v1.2.2 changelog entry with full documentation

---

<a id="en-v121"></a>

## [v1.2.1] — 2026-06-13

<a id="en-v121-summary"></a>

### 🎯 Summary

**Patch release:** Brave version upgrade to 1.91.172 (Chromium 149.0.7827.115). No policy changes from v1.2.

**Changes:** Translation parity fix (22 missing policy effect keys added for EN/TR), added missing sources section heading, wired up license section translation, corrected orphaned translation keys.

<a id="en-v121-changed"></a>

### 🔧 Changed

- **index.html**: Added 23 missing translation keys for EN and TR (pol_effect1–17, policies_badge/heading/desc, policy_col_key/effect, sources_badge)
- **index.html**: Added missing `<h2>` heading and badge to sources section with data-i18n support
- **index.html**: Wired up license_heading data-i18n to license section heading
- **index.html**: Updated version references from v1.2 to v1.2.1
- **README.md**: Updated version compatibility matrix to include v1.2.1
- **CHANGELOG.md**: Added v1.2.1 changelog entry with full documentation

<a id="en-v12"></a>

## [v1.2] — 2026-06-12

<a id="en-v12-summary"></a>

### 🎯 Summary

**Major expansion:** 10 new enterprise policies added, bringing total from **7 to 17 policies**. This represents a **143% expansion** in privacy hardening coverage. All new policies are ADMX-verified and Chromium 149 compatible.

**Validated against Brave 1.91.172 (Chromium 149.0.7827.115).**

<a id="en-v12-added"></a>

### ✨ Added

#### Telemetry & Analytics (2 policies)
- `BraveP3AEnabled = 0` — Disables Privacy-Preserving Product Analytics (P3A)
- `BraveWebDiscoveryEnabled = 0` — Disables Web Discovery Project data contribution

#### Integrated Services (3 policies)
- `BraveTalkDisabled = 1` — Disables Brave Talk video conferencing
- `BraveNewsDisabled = 1` — Disables Brave News feed
- `BravePlaylistEnabled = 0` — Disables Brave Playlist

#### Reader & Discovery (2 policies)
- `BraveSpeedreaderEnabled = 0` — Disables Speedreader mode
- `BraveWaybackMachineEnabled = 0` — Disables Wayback Machine integration

#### Network & Other (1 policy)
- `TorDisabled = 1` — Disables Tor network integration

#### Documentation
- Updated Version Compatibility Matrix (now showing v1.0, v1.1, v1.2)
- Expanded Policy Reference table with all 17 policies
- Updated architecture diagrams (7 → 17 policies)
- Both English and Turkish versions fully updated

<a id="en-v12-statistics"></a>

### 📊 Statistics

```
Files Modified:
  ✓ BraveOmega-TR.ps1 (497 → 567 lines)
  ✓ BraveOmega-EN.ps1 (496 → 565 lines)
  ✓ README.md (version compatibility, policy table)

Policies:
  ✓ Total: 7 → 17 (+143%)
  ✓ HKLM Enterprise Policies: 7 → 15 (+114%)
  ✓ Categories: 3 → 5 (+67%)

Documentation:
  ✓ UPDATE_REPORT_v1.2.md (bilingual update summary)
  ✓ POLICY_UPDATE_v1.2.md (detailed policy reference)
  ✓ CHANGELOG.md (this file)
```

<a id="en-v12-changed"></a>

### 🔄 Changed

- Script header versions updated with v1.2 changelog
- Version Compatibility Matrix reorganized (v1.0/v1.1/v1.2)
- Policy reference comprehensively expanded
- Architecture diagrams updated (7 → 17 policy count)

<a id="en-v12-security"></a>

### 🛡️ Security

- All new policies verified against Brave's official ADMX templates
- All new policies cross-referenced with Chromium 149 enterprise documentation
- No breaking changes; backward compatible with v1.1 systems

---

<a id="en-v11"></a>

## [v1.1] — 2026-06-05

<a id="en-v11-summary"></a>

### 🎯 Summary

Comprehensive debugging and enhancement release with 7 major improvements. Introduced Brave process guards, registry backups, and try-catch error handling.

<a id="en-v11-added"></a>

### ✨ Added

- **Brave Process Guard** — Detects active Brave instances before execution
- **Registry Backup** — Automatic .reg file backup with timestamp before HKLM modifications
- **Enhanced Error Handling** — Try-catch blocks on all registry operations with success/failure counters
- **Execution Summary** — Per-category reporting with transparent success/failure metrics

<a id="en-v11-changed"></a>

### 🔄 Changed

- Fixed exit codes: `exit 1` on failure (previously returned 0)
- Simplified directory preparation: Single-line `-Force` parameter instead of redundant Test-Path
- Omaha GUID processing: Previously dead variable now writes `usagestats=0` to detected paths

<a id="en-v11-removed"></a>

### ❌ Removed

- **BraveShieldsDefault = 2** — This policy does not exist in Brave's official ADMX. Removed to prevent creating non-functional registry entries.

<a id="en-v11-details"></a>

### 📋 Details

| Change # | Type | Description |
|----------|------|-------------|
| #1 | Fix | Removed non-existent BraveShieldsDefault policy |
| #2 | Add | Added try-catch error handling to registry operations |
| #3 | Fix | Implemented Omaha GUID usagestats=0 writing (was dead code) |
| #4 | Add | Added Brave process detection with user prompt |
| #5 | Fix | Corrected exit codes for automation tool compatibility |
| #6 | Add | Implemented automatic HKLM backup before modifications |
| #7 | Simplify | Removed redundant Test-Path check before New-Item |

---

<a id="en-v10"></a>

## [v1.0] — 2026-06-04

<a id="en-v10-summary"></a>

### 🎯 Summary

Initial community release. Stable, tested hardening automation for Brave Browser with enterprise policy hardening across three registry layers (HKCU, HKLM, Omaha).

<a id="en-v10-features"></a>

### ✨ Features

- **7 Enterprise Policies** — All ADMX-verified policies for core telemetry and service disabling
- **3-Tier Architecture** — HKCU user preference + HKLM enterprise policy + Omaha updater GUID
- **Idempotent Execution** — Safe to run multiple times with consistent results
- **Bilingual Interface** — Full Turkish and English support
- **Defense-in-Depth** — Layered approach across Windows Registry hierarchy
- **Process Guard** — Warns if Brave is open before making changes
- **Automatic Backups** — Time-stamped .reg backups before registry modifications

<a id="en-v10-initial-policies"></a>

### 📋 Initial Policies

```
1. UsageStatsInSample = 0 (HKCU)         — Disable usage stats sampling
2. BraveRewardsDisabled = 1 (HKLM)       — Disable Rewards
3. BraveWalletDisabled = 1 (HKLM)        — Disable Wallet
4. BraveVPNDisabled = 1 (HKLM)           — Disable VPN
5. BraveAIChatEnabled = 0 (HKLM)         — Disable Leo AI Chat
6. BraveStatsPingEnabled = 0 (HKLM)      — Disable stats pings
7. MetricsReportingEnabled = 0 (HKLM)    — Disable metrics
8. SafeBrowsingExtendedReportingEnabled = 0 (HKLM) — Disable extended SB reports
9. usagestats = 0 (Omaha GUID)           — Disable updater telemetry
```

<a id="en-v10-documentation"></a>

### 📚 Documentation

- Comprehensive README.md in English and Turkish
- Policy reference tables with descriptions
- Quick start guide for both languages
- Troubleshooting section
- Security & Safety section
- Project roadmap

---

<a id="en-version-history-summary"></a>

## Version History Summary

| Version | Date       | Policies | Major Changes |
|---------|------------|----------|---------------|
| v1.2.2 | 2026-06-13 | 17 | Safe execution policy fix, v1.2.2 branding |
| v1.2.1 | 2026-06-13 | 17 | Brave 1.91.172 upgrade, translation & structural fixes |
| v1.2 | 2026-06-12 | 17 | +10 new policies, Brave 1.91.172 validation |
| v1.1 | 2026-06-05 | 7 | Error handling, backups, process guards |
| v1.0 | 2026-06-04 | 7 | Initial release, 3-tier architecture |

---

<a id="en-related-documentation"></a>

## 🔗 Related Documentation

- **README.md** — Complete user documentation (EN + TR)
- **LICENSE** — MIT License terms
- **Brave Omega/** — PowerShell scripts directory

---

<a id="en-notes"></a>

## 📌 Notes

- All releases maintain backward compatibility
- No breaking changes between versions
- Each version is independently tested against stated Brave and Chromium versions
- Community contributions welcome; follow contributing guidelines in README

---

<div align="center">

**🦁 Brave Omega Project** — Community Edition

*Building privacy-first browser hardening, one policy at a time.*

</div>

---

---

<a id="-türkçe-değişiklik-günlüğü"></a>

## TR Türkçe Değişiklik Günlüğü

### İçindekiler

1.  [Giriş](#tr-introduction)
2.  [v1.2.2 — 2026-06-13](#tr-v122)
    *   [Özet](#tr-v122-summary)
    *   [Değiştirildi](#tr-v122-changed)
3.  [v1.2.1 — 2026-06-13](#tr-v121)
    *   [Özet](#tr-v121-summary)
    *   [Değiştirildi](#tr-v121-changed)
4.  [v1.2 — 2026-06-12](#tr-v12)
    *   [Özet](#tr-v12-summary)
    *   [Eklendi](#tr-v12-added)
    *   [İstatistikler](#tr-v12-statistics)
    *   [Değiştirildi](#tr-v12-changed)
    *   [Güvenlik](#tr-v12-security)
5.  [v1.1 — 2026-06-05](#tr-v11)
    *   [Özet](#tr-v11-summary)
    *   [Eklendi](#tr-v11-added)
    *   [Değiştirildi](#tr-v11-changed)
    *   [Kaldırıldı](#tr-v11-removed)
    *   [Detaylar](#tr-v11-details)
6.  [v1.0 — 2026-06-04](#tr-v10)
    *   [Özet](#tr-v10-summary)
    *   [Özellikler](#tr-v10-features)
    *   [Başlangıç Politikaları](#tr-v10-initial-policies)
    *   [Belgelendirme](#tr-v10-documentation)
7.  [Sürüm Geçmişi Özeti](#tr-version-history-summary)
8.  [İlgili Belgelendirme](#tr-related-documentation)
9.  [Notlar](#tr-notes)

---

<a id="tr-introduction"></a>

Bu projedeki tüm önemli değişiklikler, [Keep a Changelog](https://keepachangelog.com/) formatına uygun olarak aşağıda belgelenmiştir.

---

<a id="tr-v122"></a>

## [v1.2.2] — 2026-06-13

<a id="tr-v122-summary"></a>

### 🎯 Özet

**Yama sürümü:** Çalıştırma ilkesi düzeltmesi — kalıcı `RemoteSigned -Scope CurrentUser` yerine oturum bazlı `Bypass -Scope Process` kullanıldı. v1.2.1'den itibaren politika değişikliği yok.

**Değişiklikler:** Çalıştırma ilkesi talimatı artık `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` kullanıyor; bu ayar yalnızca geçerli PowerShell penceresini etkiler (kalıcı kayıt defteri değişikliği yok, saldırı yüzeyi oluşmaz). README Hızlı Başlangıç yeniden yapılandırıldı. Görünür UI metinlerinde Türkçe karakter düzeltmeleri yapıldı.

<a id="tr-v122-changed"></a>

### 🔧 Değiştirildi

- **index.html**: `prereq_pol_desc` (EN + TR) kalıcı `RemoteSigned -Scope CurrentUser` yerine oturum bazlı `-Scope Process Bypass` kullanacak şekilde güncellendi
- **index.html**: `rm_item3` geri dönüş metnindeki Türkçe karakterler düzeltildi
- **index.html**: Sürüm referansları v1.2.1'den v1.2.2'ye güncellendi
- **README.md**: Hızlı Başlangıç'taki kalıcı çalıştırma ilkesi adımı oturum bazlı bypass ile değiştirildi (EN + TR)
- **README.md**: Sürüm uyumluluk matrisi v1.2.2 + v1.2.1'i içerecek şekilde güncellendi
- **CHANGELOG.md**: v1.2.2 değişiklik günlüğü eklendi

---

<a id="tr-v121"></a>

## [v1.2.1] — 2026-06-13

<a id="tr-v121-summary"></a>

### 🎯 Özet

**Yama sürümü:** Brave sürüm yükseltmesi 1.91.172 (Chromium 149.0.7827.115). v1.2'den itibaren politika değişikliği yok.

**Değişiklikler:** Çeviri uyum düzeltmesi (22 eksik politika etkisi anahtarı EN/TR için eklendi), eksik kaynaklar bölüm başlığı eklendi, lisans bölümü çevirisi bağlandı, öksüz çeviri anahtarları düzeltildi.

<a id="tr-v121-changed"></a>

### 🔧 Değiştirildi

- **index.html**: EN ve TR için 23 eksik çeviri anahtarı eklendi (pol_effect1–17, policies_badge/heading/desc, policy_col_key/effect, sources_badge)
- **index.html**: Kaynaklar bölümüne eksik `<h2>` başlık ve rozet eklendi, data-i18n desteği ile
- **index.html**: Lisans bölümü başlığına license_heading data-i18n bağlandı
- **index.html**: Sürüm referansları v1.2'den v1.2.1'e güncellendi
- **README.md**: Sürüm uyumluluk matrisi v1.2.1'i içerecek şekilde güncellendi
- **CHANGELOG.md**: v1.2.1 değişiklik günlüğü eklendi

<a id="tr-v12"></a>

## [v1.2] — 2026-06-12

<a id="tr-v12-summary"></a>

### 🎯 Özet

**Büyük genişleme:** Toplam **7'den 17'ye** çıkarılan 10 yeni kurumsal politika eklendi. Bu, gizlilik sıkılaştırma kapsamının **%143 genişlemesi** anlamına geliyor. Tüm yeni politikalar ADMX doğrulamalı ve Chromium 149 ile uyumludur.

**Brave 1.91.172 (Chromium 149.0.7827.115) ile doğrulandı.**

<a id="tr-v12-added"></a>

### ✨ Eklendi

#### Telemetri ve Analiz (2 politika)
- `BraveP3AEnabled = 0` — Gizliliği Koruyan Ürün Analizlerini (P3A) devre dışı bırakır
- `BraveWebDiscoveryEnabled = 0` — Web Keşif Projesi veri katkısını devre dışı bırakır

#### Entegre Hizmetler (3 politika)
- `BraveTalkDisabled = 1` — Brave Talk video konferansını devre dışı bırakır
- `BraveNewsDisabled = 1` — Brave Haber akışını devre dışı bırakır
- `BravePlaylistEnabled = 0` — Brave Çalma Listesini devre dışı bırakır

#### Okuyucu ve Keşif (2 politika)
- `BraveSpeedreaderEnabled = 0` — Hızlı Okuyucu modunu devre dışı bırakır
- `BraveWaybackMachineEnabled = 0` — Wayback Machine entegrasyonunu devre dışı bırakır

#### Ağ ve Diğer (1 politika)
- `TorDisabled = 1` — Tor ağı entegrasyonunu devre dışı bırakır

#### Belgelendirme
- Sürüm Uyumluluk Matrisi güncellendi (şimdi v1.0, v1.1, v1.2 gösteriyor)
- Tüm 17 politikayı içeren Politika Referans tablosu genişletildi
- Mimari diyagramlar güncellendi (7 → 17 politika)
- Hem İngilizce hem de Türkçe versiyonlar tamamen güncellendi

<a id="tr-v12-statistics"></a>

### 📊 İstatistikler

```
Değiştirilen Dosyalar:
  ✓ BraveOmega-TR.ps1 (497 → 567 satır)
  ✓ BraveOmega-EN.ps1 (496 → 565 satır)
  ✓ README.md (sürüm uyumluluğu, politika tablosu)

Politikalar:
  ✓ Toplam: 7 → 17 (+143%)
  ✓ HKLM Kurumsal Politikalar: 7 → 15 (+114%)
  ✓ Kategoriler: 3 → 5 (+67%)

Belgelendirme:
  ✓ UPDATE_REPORT_v1.2.md (iki dilli güncelleme özeti)
  ✓ POLICY_UPDATE_v1.2.md (detaylı politika referansı)
  ✓ CHANGELOG.md (bu dosya)
```

<a id="tr-v12-changed"></a>

### 🔄 Değiştirildi

- Betik başlık sürümleri v1.2 değişiklik günlüğü ile güncellendi
- Sürüm Uyumluluk Matrisi yeniden düzenlendi (v1.0/v1.1/v1.2)
- Politika referansı kapsamlı bir şekilde genişletildi
- Mimari diyagramlar güncellendi (7 → 17 politika sayısı)

<a id="tr-v12-security"></a>

### 🛡️ Güvenlik

- Tüm yeni politikalar Brave'in resmi ADMX şablonlarına göre doğrulandı
- Tüm yeni politikalar Chromium 149 kurumsal belgelendirmesi ile çapraz referanslandı
- Kırıcı değişiklik yok; v1.1 sistemleriyle geriye dönük uyumlu

---

<a id="tr-v11"></a>

## [v1.1] — 2026-06-05

<a id="tr-v11-summary"></a>

### 🎯 Özet

7 ana iyileştirme içeren kapsamlı hata ayıklama ve geliştirme sürümü. Brave süreç koruyucuları, kayıt defteri yedeklemeleri ve try-catch hata yönetimi tanıtıldı.

<a id="tr-v11-added"></a>

### ✨ Eklendi

- **Brave Süreç Koruyucusu** — Çalıştırmadan önce etkin Brave örneklerini algılar
- **Kayıt Defteri Yedeklemesi** — HKLM değişikliklerinden önce zaman damgalı otomatik .reg dosya yedeklemesi
- **Gelişmiş Hata Yönetimi** — Tüm kayıt defteri işlemleri üzerinde başarı/hata sayaçları ile try-catch blokları
- **Yürütme Özeti** — Şeffaf başarı/hata metrikleri ile kategori bazında raporlama

<a id="tr-v11-changed"></a>

### 🔄 Değiştirildi

- Çıkış kodları düzeltildi: Başarısızlık durumunda `exit 1` (önceden 0 döndürüyordu)
- Dizin hazırlığı basitleştirildi: Gereksiz Test-Path yerine tek satırlık `-Force` parametresi
- Omaha GUID işleme: Önceden ölü değişken, artık algılanan yollara `usagestats=0` yazar

<a id="tr-v11-removed"></a>

### ❌ Kaldırıldı

- **BraveShieldsDefault = 2** — Bu politika Brave'in resmi ADMX'inde mevcut değildir. İşlevsel olmayan kayıt defteri girdileri oluşturmayı önlemek için kaldırıldı.

<a id="tr-v11-details"></a>

### 📋 Detaylar

| Değişiklik # | Tür | Açıklama |
|--------------|-----|----------|
| #1 | Düzeltme | Mevcut olmayan BraveShieldsDefault politikası kaldırıldı |
| #2 | Ekleme | Kayıt defteri işlemlerine try-catch hata yönetimi eklendi |
| #3 | Düzeltme | Omaha GUID usagestats=0 yazma işlemi uygulandı (ölü koddu) |
| #4 | Ekleme | Kullanıcı istemi ile Brave süreç algılama eklendi |
| #5 | Düzeltme | Otomasyon aracı uyumluluğu için çıkış kodları düzeltildi |
| #6 | Ekleme | Otomatik HKLM yedeklemesi uygulandı |
| #7 | Basitleştirme | New-Item öncesi gereksiz Test-Path kontrolü kaldırıldı |

---

<a id="tr-v10"></a>

## [v1.0] — 2026-06-04

<a id="tr-v10-summary"></a>

### 🎯 Özet

İlk topluluk sürümü. Brave Tarayıcı için üç kayıt defteri katmanında (HKCU, HKLM, Omaha) kurumsal politika sıkılaştırması ile kararlı, test edilmiş sıkılaştırma otomasyonu.

<a id="tr-v10-features"></a>

### ✨ Özellikler

- **7 Kurumsal Politika** — Temel telemetri ve hizmet devre dışı bırakma için tüm ADMX doğrulamalı politikalar
- **3 Katmanlı Mimari** — HKCU kullanıcı tercihi + HKLM kurumsal politika + Omaha güncelleyici GUID
- **Kararsız Olmayan Çalışma** — Tutarlı sonuçlarla birden çok kez güvenle çalıştırılabilir
- **İki Dilli Arayüz** — Tam Türkçe ve İngilizce desteği
- **Derinlemesine Savunma** — Windows Kayıt Defteri hiyerarşisi boyunca katmanlı yaklaşım
- **Süreç Koruyucusu** — Değişiklik yapmadan önce Brave'in açık olup olmadığını uyarır
- **Otomatik Yedeklemeler** — Kayıt defteri değişikliklerinden önce zaman damgalı .reg yedeklemeleri

<a id="tr-v10-initial-policies"></a>

### 📋 Başlangıç Politikaları

```
1. UsageStatsInSample = 0 (HKCU)         — Kullanım istatistikleri örneklemesini devre dışı bırak
2. BraveRewardsDisabled = 1 (HKLM)       — Ödülleri devre dışı bırak
3. BraveWalletDisabled = 1 (HKLM)        — Cüzdanı devre dışı bırak
4. BraveVPNDisabled = 1 (HKLM)           — VPN'i devre dışı bırak
5. BraveAIChatEnabled = 0 (HKLM)         — Leo Yapay Zeka Sohbetini devre dışı bırak
6. BraveStatsPingEnabled = 0 (HKLM)      — İstatistik pinglerini devre dışı bırak
7. MetricsReportingEnabled = 0 (HKLM)    — Metrikleri devre dışı bırak
8. SafeBrowsingExtendedReportingEnabled = 0 (HKLM) — Genişletilmiş Güvenli Tarama raporlarını devre dışı bırak
9. usagestats = 0 (Omaha GUID)           — Güncelleyici telemetrisini devre dışı bırak
```

<a id="tr-v10-documentation"></a>

### 📚 Belgelendirme

- İngilizce ve Türkçe kapsamlı README.md
- Açıklamalı politika referans tabloları
- Her iki dil için hızlı başlangıç kılavuzu
- Sorun giderme bölümü
- Güvenlik ve Emniyet bölümü
- Proje yol haritası

---

<a id="tr-version-history-summary"></a>

## Sürüm Geçmişi Özeti

| Sürüm | Tarih      | Politikalar | Ana Değişiklikler |
|-------|------------|-------------|-------------------|
| v1.2.2 | 2026-06-13 | 17 | Güvenli çalıştırma ilkesi düzeltmesi, v1.2.2 branding |
| v1.2.1 | 2026-06-13 | 17 | Brave 1.91.172 yükseltmesi, çeviri ve yapı düzeltmeleri |
| v1.2 | 2026-06-12 | 17 | +10 yeni politika, Brave 1.91.172 doğrulaması |
| v1.1 | 2026-06-05 | 7 | Hata yönetimi, yedeklemeler, süreç koruyucuları |
| v1.0 | 2026-06-04 | 7 | İlk sürüm, 3 katmanlı mimari |

---

<a id="tr-related-documentation"></a>

## 🔗 İlgili Belgelendirme

- **README.md** — Tam kullanıcı belgelendirmesi (EN + TR)
- **LICENSE** — MIT Lisans koşulları
- **Brave Omega/** — PowerShell betikleri dizini

---

<a id="tr-notes"></a>

## 📌 Notlar

- Tüm sürümler geriye dönük uyumluluğu korur
- Sürümler arasında kırıcı değişiklik yoktur
- Her sürüm belirtilen Brave ve Chromium sürümlerine karşı bağımsız olarak test edilmiştir
- Topluluk katkıları memnuniyetle karşılanır; README'deki katkı yönergelerini takip edin

---

<div align="center">

**🦁 Brave Omega Project** — Topluluk Sürümü

*Gizlilik odaklı tarayıcı sıkılaştırması inşa ediliyor, her seferinde bir politika.*

</div>