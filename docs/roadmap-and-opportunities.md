# Brave Omega Projesi — Yol Haritası ve Fırsatlar

> **Sürüm:** v1.0.0.0 · **Prompt Framework:** Baseline (2026-07-04)  
> **Brave:** 1.92.134 · **Chromium:** 150 · **Windows:** 11 25H2  
> **Politika Sayısı:** 67 (Brave Yalnız: 13 → Temel: 29 → Dengeli: 47 → Katı: 67)  
> **Diller:** İngilizce + Türkçe (çift betik) · **Platform:** Yalnızca Windows  
> **Referans:** [Brave-Group-Policy-Reference.md](./Brave-Group-Policy-Reference.md)  
> **Sürümleme:** 4 parçalı (version.major.minor.revision)

---

## Mevcut Durum

### Kazanımlar

| Başlık | Detay |
|--------|-------|
| **Dört kademeli model** | Brave Yalnız (13) → Temel (29) → Dengeli (47) → Katı (67), kümülatif miras |
| **Çok türlü kayıt defteri motoru** | DWord, String, MultiString — `REG_MULTI_SZ` için .NET API |
| **Üç katmanlı zorunlu kılma** | HKLM kurumsal politikalar + HKCU kullanıcı tercihleri + Omaha GUID telemetrisi |
| **Güvenlik önlemleri** | Zaman damgalı `.reg` yedekleme, `-WhatIf` kuru çalıştırma, `-Reset` temiz kaldırma, Brave süreç denetimi, sürüm uyuşmazlık uyarısı |
| **Çift dilli** | Tam EN + TR arayüz, parametre isimleri, hata mesajları |
| **ADMX doğrulama hattı** | Haftalık GitHub Actions (`admx-validate.yml`) ile Chromium + Brave ADMX şablonlarına karşı tip/uyum denetimi |
| **Quality pipeline** | `quality.yml` ile PR'lerde markdown lint, YAML validate, PowerShell sözdizimi denetimi |
| **Stale management** | `stale.yml` ile 90 gün issues / 60 gün PR otomatik işaretleme ve kapatma |
| **Dependabot** | Haftalık GitHub Actions bağımlılık güncellemeleri (Pazartesi 06:00 TSİ) |
| **GitHub Pages** | `index.html` (1631 satır, Tailwind CSS, çift dilli, i18n data attributes) |
| **Dokümantasyon** | README, CHANGELOG (1446 satır), CONTRIBUTING, SECURITY, CODE_OF_CONDUCT |
| **Versiyon geçmişi** | 11 sürüm (v1.0 → v2.1.5), her biri Brave+Chromium eşleşmesiyle etiketlenmiş |
| **Prompt Framework** | 13 sıralı prompt dosyası (01-13), 4 parçalı sürümleme, hepsi v1.0.0.0 başlangıcında |
| **GitHub Project #4** | 11 öğe (5 kapalı #10-#14 + 6 açık #25-#30), fazlara eşlenmiş |
| **Kalite hattı temiz** | markdownlint (13/13 prompt temiz), yamllint, PowerShell sözdizimi |

### Mimari Katmanlar

```
┌─ KATMAN 1 — HKCU Kullanıcı Tercihleri ─────────────────────┐
│  HKCU:\Software\BraveSoftware\Brave-Browser                 │
│  UsageStatsInSample = 0, ChromeVariations = 1               │
├─ KATMAN 2 — HKLM Kurumsal Politikalar ──────────────────────┤
│  HKLM:\SOFTWARE\Policies\BraveSoftware\Brave                │
│  13–67 ADMX doğrulamalı politika (kilitlemeli)              │
├─ KATMAN 3 — Omaha Güncelleyici GUID ─────────────────────────┤
│  HKCU:\Software\BraveSoftware\Update\ClientState\{GUID}      │
│  usagestats = 0 (dinamik regex keşfi)                       │
└──────────────────────────────────────────────────────────────┘
```

---

## Politika Boşluk Analizi

### Betikte Var Olan Brave Politikaları (13)

BraveRewardsDisabled, BraveWalletDisabled, BraveVPNDisabled, BraveAIChatEnabled,
BraveTalkDisabled, BraveNewsDisabled, BravePlaylistEnabled, BraveSpeedreaderEnabled,
BraveWaybackMachineEnabled, BraveP3AEnabled, BraveStatsPingEnabled,
BraveWebDiscoveryEnabled, TorDisabled

### Referansta Var, Betikte Eksik Brave Politikaları (13)

| Politika | Min. Chromium | Etki |
|----------|--------------|------|
| `BraveDeAmpEnabled` | 140 | AMP sayfalarını normal web sayfalarına yönlendirir |
| `BraveDebouncingEnabled` | 140 | İzleyici yönlendirme zıplamasını engeller |
| `BraveGlobalPrivacyControlEnabled` | 142 | GPC sinyalini zorunlu kılar |
| `BraveReduceLanguageEnabled` | 140 | Dil bilgisini azaltarak parmak izini daraltır |
| `BraveTrackingQueryParametersFilteringEnabled` | 142 | İzleme parametrelerini otomatik temizler |
| `BraveLocalAIEnabled` | 149 | Yerel AI özelliklerini kapatır |
| `EmailAliasesEnabled` | 147 | E-posta takma adlarını kapatır |
| `DefaultBraveAdblockSetting` | 142 | Reklam engelleme varsayılanını belirler |
| `DefaultBraveFingerprintingV2Setting` | 141 | Parmak izi koruma V2 varsayılanı |
| `DefaultBraveHttpsUpgradeSetting` | 142 | HTTPS yükseltme varsayılanı |
| `DefaultBraveReferrersSetting` | 142 | Referrer varsayılanı |
| `DefaultBraveRemember1PStorageSetting` | 142 | Birinci taraf depolama varsayılanı |
| `BraveSyncUrl` | — | Sync sunucusu URL'si (kurumsal kontrol) |

**Çoğu chrome.\*:140+ eşiğinde — Brave 1.75+ gerektirir. Mevcut Brave 1.92.134 ile tam uyumlu.**

---

## Kısa Vadeli (1-2 Hafta)

### 1. Eksik Brave Politikalarını Ekleme

Öncelik sırası:

**Sıra 1 — Sıfır kullanıcı etkisi, maksimum gizlilik:**
- `BraveDeAmpEnabled` → `true`
- `BraveDebouncingEnabled` → `true`
- `BraveGlobalPrivacyControlEnabled` → `true`
- `BraveReduceLanguageEnabled` → `true`
- `BraveTrackingQueryParametersFilteringEnabled` → `true`
- `BraveLocalAIEnabled` → `false`

Bu 6 politika Brave Yalnız seviyesine eklenir: 13 → 19 politika.

**Sıra 2 — Varsayılan koruma seviyeleri (Brave Yalnız veya Temel):**
- `DefaultBraveAdblockSetting` → `2` (Engelle)
- `DefaultBraveFingerprintingV2Setting` → `3` (Standart)
- `DefaultBraveHttpsUpgradeSetting` → `3` (Standart)
- `DefaultBraveReferrersSetting` → `2` (Sınırla)
- `DefaultBraveRemember1PStorageSetting` → `2` (Unut)

**Sıra 3 — Kurumsal/kontrol politikaları (Dengeli veya yeni bir seviye):**
- `EmailAliasesEnabled` → `false`
- `BraveSyncUrl` → (kurumsal sync URL)

### 2. ADMX Doğrulama Hattını Geliştirme

Mevcut ADMX doğrulama yalnızca politika *türünü* denetler. İyileştirme:

- **Değer doğrulama**: Politika *değerlerini* ADMX izin verilen değerlerle karşılaştır
- **Brave ADMX de doğrulama**: Yalnızca Chromium ADMX değil, Brave ADMX paketini de indirip Brave'e özgü politikaları doğrula
- **Politika sürüm kontrolü**: Her politikanın hangi Chromium sürümünde tanıtıldığını meta veri olarak ekle, eski Brave'lerde uyarı

### 3. Pester Test Altyapısı

```
Brave Omega/
  Tests/
    EN/
      unit/
        Write-PolicyValue.tests.ps1
        Level-Selection.tests.ps1
        Version-Check.tests.ps1
      integration/
        Registry-Write.tests.ps1
    TR/
      ... (eşdeğer)
```

Her test için:
- Politikanın doğru kayıt defteri yoluna yazıldığını doğrulama
- `-WhatIf` modunda hiçbir kayıt defterine yazılmadığını doğrulama
- Seviye seçiminin doğru politikaları birleştirdiğini doğrulama
- Admin olmadan hata fırlatıldığını doğrulama

---

## Orta Vadeli (1-3 Ay)

### 1. Sürüm Yükseltme ve Politika Tazeleme

Her yeni Brave kararlı sürümünde:
1. Yeni `policy_templates.zip` indir
2. Yeni Brave politikalarını tara
3. Chromium politikalarındaki değişiklikleri tara
4. Varsa yeni politikaları ilgili seviyeye ekle
5. Kullanımdan kaldırılanları kaldır
6. CHANGELOG'a işle

### 2. Modüler Betik Mimarisi

```
Brave Omega/
  modules/
    core.psm1            # Kayıt defteri yazma, yedekleme, -WhatIf yardımcıları
    privacy-brave.psm1  # Brave'e özgü gizlilik politikaları
    privacy-chromium.psm1 # Chromium veri sızıntısı politikaları
    security.psm1       # Chromium güvenlik politikaları
    permissions.psm1    # İzin/API politikaları
    content.psm1        # İçerik ayarları
    telemetry.psm1      # Telemetri politikaları
    omaha.psm1          # Omaha güncelleyici politikaları
  profiles/
    minimal.json        # Sadece Brave yalnız
    standard.json       # Temel + bazı dengeli
    maximum.json        # Tüm politikalar
  config.json           # Politika -> seviye eşleme tablosu
  BraveOmega-EN.ps1     # Ana giriş (modülleri config.json'a göre çağırır)
  BraveOmega-TR.ps1     # Ana giriş — Türkçe
```

Avantajları:
- Politika eklemek için tek bir `.json` düzenle + `.psm1` güncelle
- Kullanıcı `config.json` düzenleyerek kendi profilini oluşturabilir
- Daha küçük, bakımı kolay dosyalar

### 3. Cross-Platform Desteği

| Platform | Yöntem | Politika Kaynağı | Yeni Betik |
|----------|--------|-----------------|------------|
| **macOS** | `/Library/Managed Preferences/com.brave.Browser.plist` + MDM `.mobileconfig` | Brave ADMX + Chrome plist | `BraveOmega-Mac.sh` veya `BraveOmega-Mac.ps1` (PowerShell Core) |
| **Linux** | `/etc/brave/policies/managed/policies.json` | JSON dosyası | `BraveOmega-Linux.sh` |
| **Android** | Managed Configurations (Android Enterprise) | JSON şema | Dokümantasyon |
| **iOS/iPadOS** | `.mobileconfig` veya MDM | Apple Configurator 2 | Yardımcı betik |

**Önerilen sıra:** Linux (en basit) → macOS → Dokümantasyon (Android/iOS)

### 4. Intune / MDM Entegrasyonu

Kurumsal dağıtım için:
- **ADMX içe aktarma kılavuzu**: Intune Ayarlar Kataloğu'na `Brave.admx` + `BraveSoftware.admx` yükleme adımları
- **`.mobileconfig` oluşturucu**: Tüm Brave politikalarını macOS/iOS `.mobileconfig` formatına çeviren bir yardımcı betik
- **JSON politika şablonları**: Linux için hazır JSON dosyaları
- **Microsoft Configuration Manager (SCCM)**: Uygulama paketi oluşturma kılavuzu

---

## Uzun Vadeli (3+ Ay)

### 1. Politika Kataloğu ve Seviyelendirme Sistemi

```
docs/policy-catalog.md
```

Her politikayı şu kategorilerde sınıflandır:

| Alan | Açıklama |
|------|----------|
| **ID** | Politika adı |
| **Kaynak** | Brave özgü / Chromium veri / Chromium güvenlik / Chromium içerik |
| **Seviye** | Brave Yalnız / Temel / Dengeli / Katı / Kurumsal |
| **Min. Chromium** | Hangi sürümden itibaren geçerli |
| **Tür** | DWord / String / MultiString |
| **Varsayılan** | Brave'in varsayılan değeri |
| **Önerilen** | Brave Omega önerilen değer |
| **Risk** | Kullanıcı etkisi (Yok / Düşük / Orta / Yüksek) |
| **ADMX Doğrulama** | Son ADMX doğrulama tarihi |
| **Notlar** | Varsa uyarılar, bağımlılıklar |

### 2. Web Arayüzü (Politika Yapılandırıcı)

Mevcut `index.html` üzerine inşa edilecek bir politika yapılandırıcı:

- **Seviye seçici**: Brave Yalnız / Temel / Dengeli / Katı / Özel
- **Politika listesi**: Tüm politikalar; her biri için aç/kapa, değer gir
- **Özel profil**: Kullanıcının seçtiği politikaları `config.json` olarak dışa aktar
- **Betik oluşturucu**: Seçilen politikalarla özelleştirilmiş `.ps1` indir
- **Platform seçici**: Windows / macOS / Linux / Intune için farklı çıktı formatları

### 3. CI/CD İyileştirmeleri

| İyileştirme | Açıklama |
|-------------|----------|
| **Politika bütünlük testi** | `docs/Brave-Group-Policy-Reference.md` ile betiklerdeki politika listesini karşılaştır; eksik/fazla varsa uyar |
| **PSScriptAnalyzer** | PowerShell kod kalitesi denetimi |
| **Platform matris testi** | Ubuntu + macOS + Windows'ta betik sözdizimi denetimi |
| **Otomatik sürüm yükseltme** | Brave'in yeni sürümü yayınlandığında CI ile algıla ve issue aç |
| **Güvenlik taraması** | `trivy` veya `pwsh-security` ile güvenlik denetimi |

### 4. Politika Profil Havuzu (Topluluk)

Kullanıcıların kendi profillerini paylaşabileceği bir `profiles/` dizini:

```
profiles/
  minimal.json           # Sadece Brave yalnız
  workstation.json       # Bireysel kullanıcı için önerilen
  enterprise-strict.json # Kurumsal, maksimum kısıtlama
  kiosk.json             # Kiosk modu tarayıcı
  developer.json         # Geliştirici gereksinimleriyle dengelenmiş
```

Her profil için:
- Kaynak kodda `.json` tanımı
- Açıklama: hangi senaryo için uygun, hangi ödünleşimler var
- Platform: Windows / macOS / Linux

### 5. Güvenlik ve Bütünlük

| Özellik | Açıklama |
|---------|----------|
| **İmzalı sürümler** | PowerShell imzalı (`Set-AuthenticodeSignature`) `.ps1` dosyaları |
| **SHA-256 sağlama** | Her sürüm için checksum listesi |
| **SBOM** | SPDX formatında yazılım malzeme listesi |
| **Derecelendirme** | OpenSSF Scorecard, CII Best Practices |

---

## Başlamak İçin Önerilen Sıra (6 Aşamalı)

```
Aşama 0 — Hazırlık:
 0. 01-surum-guncelleme.md — Brave sürüm referanslarını güncelle (mevcut: 1.92.134/150)

Aşama 1 — Denetim (Paralel):
 1. 02-politika-bosluk-analizi.md — 13 eksik Brave politikasını envantere çıkar
 2. 03-politika-deger-dogrulama.md — ADMX değer/aralık doğrulaması
 3. 04-deprecated-temizlik.md — 4 deprecated Chromium politikasını kaldır
 4. 05-referans-guncelleme.md — Referans doküman satır numaralarını güncelle

Aşama 2 — Uygulama:
 5. 06-politika-ekleme-brave.md — 13 eksik Brave politikasını ekle (67→80)

Aşama 3 — Kalite & Test:
 6. 07-pester-test.md — Pester test takımı (birim + entegrasyon)
 7. 08-pssa-ekleme.md — PSScriptAnalyzer CI entegrasyonu

Aşama 4 — Dokümantasyon/Yaygınlaştırma:
 8. 11-politika-katalogu.md — Politika kataloğu dokümanını oluştur

Aşama 5 — Gelişmiş:
 9. 09-cross-platform-config.md — Linux JSON + macOS .plist desteği
10. 10-intune-mdm.md — Intune dağıtım kılavuzu
11. 12-web-arayuzu.md — Web arayüzünü politika yapılandırıcı olarak genişlet
12. 13-moduler-mimari.md — Modüler betik mimarisine geç (modules/*.psm1 + config.json)
```

---

## Ek Notlar

- **Sürümleme**: 4 parçalı (version.major.minor.revision) — tüm promptlar v1.0.0.0 başlangıcında
- **Takip**: GitHub Project #4 — bayraktarozcan/Brave-Omega-Project/projects/4 (6 açık issue #25-#30)
- **Mevcut teknolojiler**: PowerShell 5.1+, .NET Framework, Tailwind CSS, Lucide ikonları
- **Bağımlılıklar**: Harici bağımlılık yok — betik yalnızca Windows yerleşik araçlarını kullanır
- **ADMX doğrulama**: Her Pazartesi 06:00 UTC (`admx-validate.yml`)
- **Quality kontrol**: Her PR'de markdown lint + YAML doğrulama + PowerShell sözdizimi (`quality.yml`)
- **Stale yönetimi**: `stale.yml` ile issues 90/30 gün, PR'ler 60/14 gün
- **Dependabot**: Haftalık GitHub Actions güncellemeleri (`dependabot.yml`)
- **FUNDING**: GitHub Sponsors (`github: bayraktarozcan`)
- **PR template**: `pull_request_template.md` ile standart PR şablonu
- **Issue templates**: `bug_report.yaml` + `feature_request.yaml` + `config.yml`
- **Pages dağıtımı**: `main` branch'ine push sonrası otomatik (`pages.yml`)
