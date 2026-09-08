> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;Â·&nbsp; [TR TÃ¼rkÃ§e](#-tÃ¼rkÃ§e)

<a id="-english"></a>

# ğŸ¤ Contributing â€” How to Contribute

Thank you for your interest in contributing to Brave Omega! This guide covers everything you need to know.

---

## Ways to Contribute

| Area | Description | Difficulty |
| ------ | ------------- | ------------ |
| **Version Updates** | Update policy values when Brave releases new stable | ğŸŸ¢ Easy |
| **New Policies** | Add new ADMX-validated policies with source references | ğŸŸ¡ Medium |
| **Bug Reports** | Report issues with reproduction steps | ğŸŸ¢ Easy |
| **Translations** | Add new language editions (EN/TR template) | ğŸŸ¡ Medium |
| **Documentation** | Improve wiki, README, code comments | ğŸŸ¢ Easy |
| **Testing** | Test on different Windows/Brave versions | ğŸŸ¡ Medium |

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
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Force
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Force
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
2. Update policy values in the unified `BraveOmega.ps1` (single source; both languages follow)
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

**Pester tests** live in `Tests/` (18 files, 116 It blocks).

When adding or modifying policies:

1. Locate the corresponding test file in `Tests/` (e.g., `Tests/PolicyDefinitions.Tests.ps1`)
2. Add a new `It` block for each added or changed policy
3. Run the relevant test file:

   ```powershell
   Invoke-Pester -Path .\Tests\PolicyDefinitions.Tests.ps1
   ```

4. Run the full suite before submitting:

   ```powershell
   Invoke-Pester -Path .\Tests\
   ```

5. Ensure CI passes (GitHub Actions: PSScriptAnalyzer + policy integrity checks)

Test expectations:

- All `It` blocks must pass (green âœ“)
- Tests must run without administrative privileges where possible
- Registry tests should use registry mock paths (not HKLM/HKCU) or `-WhatIf`

### Translations

**Requirements:**

- Add a column to the $Strings table and $LevelDisplayNames map in BraveOmega.ps1`r
- Maintain functional parity (same features, same order)
- Use consistent terminology
- Native speaker review preferred

**New Language Template:**

1. Extend -Language's ValidateSet and the bilingual startup prompt
2. Translate all user-facing strings into the table (code identifiers stay English)
3. Update wiki: Page-TR.md to Page-XX.md`r
4. Update _Sidebar.md with new language section

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

<a id="-tÃ¼rkÃ§e"></a>

# ğŸ¤ KatkÄ±da Bulunma â€” NasÄ±l KatkÄ±da Bulunulur

Brave Omega'ya katkÄ±da bulunmakla ilgilendiÄŸiniz iÃ§in teÅŸekkÃ¼rler! Bu kÄ±lavuz bilmeniz gereken her ÅŸeyi kapsar.

---

## KatkÄ±da Bulunma YollarÄ±

| Alan | AÃ§Ä±klama | Zorluk |
| ------ | ---------- | -------- |
| **SÃ¼rÃ¼m GÃ¼ncellemeleri** | Brave yeni kararlÄ± sÃ¼rÃ¼m yayÄ±mladÄ±ÄŸÄ±nda politika deÄŸerlerini gÃ¼ncelleme | ğŸŸ¢ Kolay |
| **Yeni Politikalar** | Kaynak referanslarÄ±yla yeni ADMX doÄŸrulamalÄ± politikalar ekleme | ğŸŸ¡ Orta |
| **Hata RaporlarÄ±** | Tekrar Ã¼retme adÄ±mlarÄ±yla sorun bildirme | ğŸŸ¢ Kolay |
| **Ã‡eviriler** | Yeni dil sÃ¼rÃ¼mleri ekleme (EN/TR ÅŸablonu) | ğŸŸ¡ Orta |
| **Belgelendirme** | Wiki, README, kod yorumlarÄ±nÄ± iyileÅŸtirme | ğŸŸ¢ Kolay |
| **Test** | FarklÄ± Windows/Brave sÃ¼rÃ¼mlerinde test | ğŸŸ¡ Orta |

---

## BaÅŸlarken

### 1. Fork & Clone

```bash
git clone https://github.com/KULLANICI_ADINIZ/Brave-Omega-Project.git
cd Brave-Omega-Project
```

### 2. Ã–zellik DalÄ± OluÅŸtur

```bash
git checkout -b ozellik/ozellik-adiniz
```

### 3. DeÄŸiÅŸiklikleri Yap

- Mevcut kod stilini izleyin
- KullanÄ±cÄ±ya yÃ¶nelik metinlerde EN/TR eÅŸlemesini koruyun
- Ä°lgili belgelendirmeyi gÃ¼ncelleyin

### 4. Test

```powershell
# Her iki betiÄŸi de test edin
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Force
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Force
```

### 5. PR GÃ¶nder

- AÃ§Ä±k baÅŸlÄ±k: `feat: X politikasÄ± eklendi` / `fix: Y sorunu Ã§Ã¶zÃ¼ldÃ¼`
- AÃ§Ä±klama: Ne deÄŸiÅŸti, neden, yapÄ±lan testler
- Ä°lgili sorunlara referans verin

---

## KatkÄ±da Bulunma YÃ¶nergeleri

### SÃ¼rÃ¼m GÃ¼ncellemeleri

Brave yeni bir kararlÄ± sÃ¼rÃ¼m yayÄ±mladÄ±ÄŸÄ±nda:

1. [Brave ADMX ÅŸablonlarÄ±nÄ±](https://github.com/brave/brave-browser/tree/master/policy_templates) kontrol edin
2. Politika değerlerini birleşik `BraveOmega.ps1` içinde güncelleyin (tek kaynak; iki dil de uyar)
3. Wiki ve README'deki `SÃ¼rÃ¼m Uyumluluk Matrisi`ni gÃ¼ncelleyin
4. Anahtarlar deÄŸiÅŸtiyse geÃ§iÅŸ notlarÄ±yla deÄŸiÅŸiklik gÃ¼nlÃ¼ÄŸÃ¼nÃ¼ gÃ¼ncelleyin

### Yeni Politikalar

**Gereksinimler:**

- Brave'in resmÃ® ADMX ÅŸablonlarÄ±nda (`policy_templates.zip`) bulunmalÄ±dÄ±r
- VEYA Chromium kurumsal politika belgelendirmesinde
- Kaynak referansÄ± gerekli (resmÃ® belgelere URL)
- Hem EN hem TR aÃ§Ä±klamalarÄ± gerekli

**Åablon:**

```powershell
# Politika AdÄ±: YeniPolitikaAdi
# Kovan: HKLM / HKCU
# DeÄŸer: 0 / 1
# Kaynak: https://kaynak.url
# AÃ§Ä±klama EN: ...
# AÃ§Ä±klama TR: ...
```

### Hata RaporlarÄ±

**ÅunlarÄ± ekleyin:**

- Brave sÃ¼rÃ¼mÃ¼ (`brave://version`)
- Windows sÃ¼rÃ¼mÃ¼ (`winver`)
- Tam betik Ã§Ä±ktÄ±sÄ± (tÃ¼m PowerShell penceresini kopyalayÄ±n)
- `brave://policy` sayfasÄ± dÄ±ÅŸa aktarÄ±mÄ± (HTML veya ekran gÃ¶rÃ¼ntÃ¼sÃ¼)
- Tekrar Ã¼retme adÄ±mlarÄ±

### Ã‡eviriler

**Gereksinimler:**

- `BraveOmega.ps1` içindeki `$Strings` tablosuna ve `$LevelDisplayNames` eşlemesine sütun ekleyin
- Ä°ÅŸlevsel eÅŸdeÄŸerliÄŸi koruyun (aynÄ± Ã¶zellikler, aynÄ± sÄ±ra)
- TutarlÄ± terminoloji kullanÄ±n
- Anadil konuÅŸmacÄ±sÄ± incelemesi tercih edilir

**Yeni Dil Åablonu:**

1. `-Language` `ValidateSet` listesini ve iki dilli açılış istemini genişletin
2. Kullanıcıya yönelik tüm metinleri tabloya çevirin (kod tanıtıcıları İngilizce kalır)
3. Wiki'yi gÃ¼ncelleyin: `Page-TR.md` yerine `Page-XX.md`
4. `_Sidebar.md`'yi yeni dil bÃ¶lÃ¼mÃ¼yle gÃ¼ncelleyin

---

## Kod Stili

### PowerShell

- Fonksiyonlar iÃ§in `PascalCase`, deÄŸiÅŸkenler iÃ§in `camelCase` kullanÄ±n
- KarmaÅŸÄ±k mantÄ±ÄŸÄ± yorumlayÄ±n
- KullanÄ±cÄ± Ã§Ä±ktÄ±sÄ± iÃ§in `Write-Host`, hata ayÄ±klama iÃ§in `Write-Verbose` kullanÄ±n
- TÃ¼m kayÄ±t defteri yazmalarÄ±nÄ± try/catch ile doÄŸrulayÄ±n

### Wiki/Markdown

- Ana bÃ¶lÃ¼mler iÃ§in `##`, alt bÃ¶lÃ¼mler iÃ§in `###` kullanÄ±n
- YapÄ±landÄ±rÄ±lmÄ±ÅŸ veriler iÃ§in tablolar
- Dil ipucuyla kod bloklarÄ± (```powershell)
- `[BaÄŸlantÄ±](Sayfa-Adi)` ile Ã§apraz referans

---

## Ã‡ekme Ä°steÄŸi Kontrol Listesi

- [ ] Kod proje stilini izliyor
- [ ] EN/TR eÅŸlemesi korundu (kullanÄ±cÄ±ya yÃ¶nelikse)
- [ ] Belgelendirme gÃ¼ncellendi (wiki + README gerekirse)
- [ ] DeÄŸiÅŸiklik gÃ¼nlÃ¼ÄŸÃ¼ girdisi eklendi (sÃ¼rÃ¼m/politika deÄŸiÅŸiklikleri iÃ§in)
- [ ] Windows 11 + en gÃ¼ncel kararlÄ± Brave'de test edildi
- [ ] Ã‡Ä±ktÄ±da `[HATA]` satÄ±rÄ± yok
- [ ] `brave://policy` tÃ¼m politikalarÄ± etkin gÃ¶steriyor

---

## DavranÄ±ÅŸ KurallarÄ±

- SaygÄ±lÄ± ve yapÄ±cÄ± olun
- Taciz, ayrÄ±mcÄ±lÄ±k veya saldÄ±rgan dil kullanmayÄ±n
- Teknik deÄŸere odaklanÄ±n
- Yeni baÅŸlayanlarÄ±n Ã¶ÄŸrenmesine yardÄ±mcÄ± olun

---

## TanÄ±nma

KatkÄ±da bulunanlar ÅŸuralarda tanÄ±nÄ±r:

- SÃ¼rÃ¼m notlarÄ±
- README'deki KatkÄ±da Bulunanlar bÃ¶lÃ¼mÃ¼
- GitHub katkÄ±da bulunan grafikleri

---

## SorularÄ±nÄ±z mÄ± Var?

- [GitHub TartÄ±ÅŸmalarÄ±](https://github.com/bayraktarozcan/Brave-Omega-Project/discussions)
- [Sorun TakipÃ§isi](https://github.com/bayraktarozcan/Brave-Omega-Project/issues)

---

*Brave Omega'yÄ± daha iyi hale getirdiÄŸiniz iÃ§in teÅŸekkÃ¼rler!*
