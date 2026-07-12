> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 🤝 Contributing — How to Contribute

Thank you for your interest in contributing to Brave Omega! This guide covers everything you need to know.

---

## Ways to Contribute

| Area | Description | Difficulty |
| ------ | ------------- | ------------ |
| **Version Updates** | Update policy values when Brave releases new stable | 🟢 Easy |
| **New Policies** | Add new ADMX-validated policies with source references | 🟡 Medium |
| **Bug Reports** | Report issues with reproduction steps | 🟢 Easy |
| **Translations** | Add new language editions (EN/TR template) | 🟡 Medium |
| **Documentation** | Improve wiki, README, code comments | 🟢 Easy |
| **Testing** | Test on different Windows/Brave versions | 🟡 Medium |

---

## Getting Started

### 1. Fork & Clone

```bash
git clone https://github.com/YOUR_USERNAME/Brave-Omega-Project.git
cd Brave-Omega-Project
```

### 2. Create Feature Branch

```bash
git checkout -b feature/your-feature-name
```

### 3. Make Changes

- Follow existing code style
- Maintain EN/TR parity for user-facing text
- Update relevant documentation

### 4. Test

```powershell
# Test both scripts
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1" -Force
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Force
```

### 5. Submit PR

- Clear title: `feat: add X policy` / `fix: resolve Y issue`
- Description: What changed, why, testing done
- Reference related issues

---

## Contribution Guidelines

### Version Updates

When Brave releases a new stable version:

1. Check [Brave ADMX templates](https://github.com/brave/brave-browser/tree/master/policy_templates)
2. Update policy values in both `BraveOmega-EN.ps1` and `BraveOmega-TR.ps1`
3. Update `Version Compatibility Matrix` in wiki & README
4. Update changelog with migration notes if keys changed

### New Policies

**Requirements:**

- Must be in Brave's official ADMX templates (`policy_templates.zip`)
- OR in Chromium enterprise policy documentation
- Source reference required (URL to official docs)
- Both EN/TR descriptions required

**Template:**

```powershell
# Policy Name: NewPolicyName
# Hive: HKLM / HKCU
# Value: 0 / 1
# Source: https://source.url
# Description EN: ...
# Description TR: ...
```

### Bug Reports

**Include:**

- Brave version (`brave://version`)
- Windows version (`winver`)
- Full script output (copy entire PowerShell window)
- `brave://policy` page export (HTML or screenshot)
- Steps to reproduce

### Testing (Phase 3)

**Pester tests** live in `Tests/` (16 files, ~50–60 It blocks).

When adding or modifying policies:

1. Locate the corresponding test file in `Tests/` (e.g., `Tests/01-BraveOnly.Tests.ps1`)
2. Add a new `It` block for each added or changed policy
3. Run the relevant test file:

   ```powershell
   Invoke-Pester -Path .\Tests\01-BraveOnly.Tests.ps1
   ```

4. Run the full suite before submitting:

   ```powershell
   Invoke-Pester -Path .\Tests\
   ```

5. Ensure CI passes (GitHub Actions: PSScriptAnalyzer + policy integrity checks)

Test expectations:

- All `It` blocks must pass (green ✓)
- Tests must run without administrative privileges where possible
- Registry tests should use registry mock paths (not HKLM/HKCU) or `-WhatIf`

### Translations

**Requirements:**

- Follow EN/TR template structure exactly
- Maintain functional parity (same features, same order)
- Use consistent terminology
- Native speaker review preferred

**New Language Template:**

1. Copy `BraveOmega-EN.ps1` to `BraveOmega-XX.ps1`
2. Translate all user-facing strings
3. Update wiki: `Page-TR.md` to `Page-XX.md`
4. Update `_Sidebar.md` with new language section

---

## Code Style

### PowerShell

- Use `PascalCase` for functions, `camelCase` for variables
- Comment complex logic
- Use `Write-Host` for user output, `Write-Verbose` for debug
- Validate all registry writes with try/catch

### Wiki/Markdown

- Use `##` for main sections, `###` for subsections
- Tables for structured data
- Code blocks with language hints (```powershell)
- Cross-reference with `[Link](Page-Name)`

---

## Pull Request Checklist

- [ ] Code follows project style
- [ ] EN/TR parity maintained (if user-facing)
- [ ] Documentation updated (wiki + README if needed)
- [ ] Changelog entry added (for version/policy changes)
- [ ] Tested on Windows 11 + latest stable Brave
- [ ] No `[ERROR]` lines in output
- [ ] `brave://policy` shows all policies active

---

## Code of Conduct

- Be respectful and constructive
- No harassment, discrimination, or offensive language
- Focus on technical merit
- Help newcomers learn

---

## Recognition

Contributors are recognized in:

- Release notes
- Contributors section in README
- GitHub contributor graphs

---

## Questions?

- [GitHub Discussions](https://github.com/bayraktarozcan/Brave-Omega-Project/discussions)
- [Issue Tracker](https://github.com/bayraktarozcan/Brave-Omega-Project/issues)

---

*Thank you for making Brave Omega better!*

---

---

<a id="-türkçe"></a>

# 🤝 Katkıda Bulunma — Nasıl Katkıda Bulunulur

Brave Omega'ya katkıda bulunmakla ilgilendiğiniz için teşekkürler! Bu kılavuz bilmeniz gereken her şeyi kapsar.

---

## Katkıda Bulunma Yolları

| Alan | Açıklama | Zorluk |
| ------ | ---------- | -------- |
| **Sürüm Güncellemeleri** | Brave yeni kararlı sürüm yayımladığında politika değerlerini güncelleme | 🟢 Kolay |
| **Yeni Politikalar** | Kaynak referanslarıyla yeni ADMX doğrulamalı politikalar ekleme | 🟡 Orta |
| **Hata Raporları** | Tekrar üretme adımlarıyla sorun bildirme | 🟢 Kolay |
| **Çeviriler** | Yeni dil sürümleri ekleme (EN/TR şablonu) | 🟡 Orta |
| **Belgelendirme** | Wiki, README, kod yorumlarını iyileştirme | 🟢 Kolay |
| **Test** | Farklı Windows/Brave sürümlerinde test | 🟡 Orta |

---

## Başlarken

### 1. Fork & Clone

```bash
git clone https://github.com/KULLANICI_ADINIZ/Brave-Omega-Project.git
cd Brave-Omega-Project
```

### 2. Özellik Dalı Oluştur

```bash
git checkout -b ozellik/ozellik-adiniz
```

### 3. Değişiklikleri Yap

- Mevcut kod stilini izleyin
- Kullanıcıya yönelik metinlerde EN/TR eşlemesini koruyun
- İlgili belgelendirmeyi güncelleyin

### 4. Test

```powershell
# Her iki betiği de test edin
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1" -Force
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Force
```

### 5. PR Gönder

- Açık başlık: `feat: X politikası eklendi` / `fix: Y sorunu çözüldü`
- Açıklama: Ne değişti, neden, yapılan testler
- İlgili sorunlara referans verin

---

## Katkıda Bulunma Yönergeleri

### Sürüm Güncellemeleri

Brave yeni bir kararlı sürüm yayımladığında:

1. [Brave ADMX şablonlarını](https://github.com/brave/brave-browser/tree/master/policy_templates) kontrol edin
2. `BraveOmega-EN.ps1` ve `BraveOmega-TR.ps1` içindeki politika değerlerini güncelleyin
3. Wiki ve README'deki `Sürüm Uyumluluk Matrisi`ni güncelleyin
4. Anahtarlar değiştiyse geçiş notlarıyla değişiklik günlüğünü güncelleyin

### Yeni Politikalar

**Gereksinimler:**

- Brave'in resmî ADMX şablonlarında (`policy_templates.zip`) bulunmalıdır
- VEYA Chromium kurumsal politika belgelendirmesinde
- Kaynak referansı gerekli (resmî belgelere URL)
- Hem EN hem TR açıklamaları gerekli

**Şablon:**

```powershell
# Politika Adı: YeniPolitikaAdi
# Kovan: HKLM / HKCU
# Değer: 0 / 1
# Kaynak: https://kaynak.url
# Açıklama EN: ...
# Açıklama TR: ...
```

### Hata Raporları

**Şunları ekleyin:**

- Brave sürümü (`brave://version`)
- Windows sürümü (`winver`)
- Tam betik çıktısı (tüm PowerShell penceresini kopyalayın)
- `brave://policy` sayfası dışa aktarımı (HTML veya ekran görüntüsü)
- Tekrar üretme adımları

### Çeviriler

**Gereksinimler:**

- EN/TR şablon yapısını aynen izleyin
- İşlevsel eşdeğerliği koruyun (aynı özellikler, aynı sıra)
- Tutarlı terminoloji kullanın
- Anadil konuşmacısı incelemesi tercih edilir

**Yeni Dil Şablonu:**

1. `BraveOmega-EN.ps1` dosyasını `BraveOmega-XX.ps1` olarak kopyalayın
2. Kullanıcıya yönelik tüm metinleri çevirin
3. Wiki'yi güncelleyin: `Page-TR.md` yerine `Page-XX.md`
4. `_Sidebar.md`'yi yeni dil bölümüyle güncelleyin

---

## Kod Stili

### PowerShell

- Fonksiyonlar için `PascalCase`, değişkenler için `camelCase` kullanın
- Karmaşık mantığı yorumlayın
- Kullanıcı çıktısı için `Write-Host`, hata ayıklama için `Write-Verbose` kullanın
- Tüm kayıt defteri yazmalarını try/catch ile doğrulayın

### Wiki/Markdown

- Ana bölümler için `##`, alt bölümler için `###` kullanın
- Yapılandırılmış veriler için tablolar
- Dil ipucuyla kod blokları (```powershell)
- `[Bağlantı](Sayfa-Adi)` ile çapraz referans

---

## Çekme İsteği Kontrol Listesi

- [ ] Kod proje stilini izliyor
- [ ] EN/TR eşlemesi korundu (kullanıcıya yönelikse)
- [ ] Belgelendirme güncellendi (wiki + README gerekirse)
- [ ] Değişiklik günlüğü girdisi eklendi (sürüm/politika değişiklikleri için)
- [ ] Windows 11 + en güncel kararlı Brave'de test edildi
- [ ] Çıktıda `[HATA]` satırı yok
- [ ] `brave://policy` tüm politikaları etkin gösteriyor

---

## Davranış Kuralları

- Saygılı ve yapıcı olun
- Taciz, ayrımcılık veya saldırgan dil kullanmayın
- Teknik değere odaklanın
- Yeni başlayanların öğrenmesine yardımcı olun

---

## Tanınma

Katkıda bulunanlar şuralarda tanınır:

- Sürüm notları
- README'deki Katkıda Bulunanlar bölümü
- GitHub katkıda bulunan grafikleri

---

## Sorularınız mı Var?

- [GitHub Tartışmaları](https://github.com/bayraktarozcan/Brave-Omega-Project/discussions)
- [Sorun Takipçisi](https://github.com/bayraktarozcan/Brave-Omega-Project/issues)

---

*Brave Omega'yı daha iyi hale getirdiğiniz için teşekkürler!*
