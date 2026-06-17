<!-- ================================================================== -->
<!--         BRAVE OMEGA PROJECT — CONTRIBUTING.md                     -->
<!--       Community Edition · Open Source · Privacy First             -->
<!-- ================================================================== -->

<div align="center">

<br>

# 🦁 Brave Omega — Contributing Guide

<br>

> **Language / Dil** &nbsp;
> [EN English](#-english-contributing-guide) &nbsp;·&nbsp; [TR Türkçe](#-türkçe-katkı-rehberi)

<br>

</div>

---

<a id="-english-contributing-guide"></a>

## EN English Contributing Guide

Thank you for considering contributing to Brave Omega. This document outlines the preferred
workflow for policy updates, bug reports, translations, and feature requests.

### Table of Contents

1. [Code of Conduct](#1-code-of-conduct)
2. [Priority Areas](#2-priority-areas)
3. [Version Updates](#3-version-updates)
4. [New Policies](#4-new-policies)
5. [Bug Reports](#5-bug-reports)
6. [Feature Requests](#6-feature-requests)
7. [Translations](#7-translations)
8. [Pull Request Workflow](#8-pull-request-workflow)
9. [Development Setup](#9-development-setup)
10. [Style Guide](#10-style-guide)
11. [Security Disclosures](#11-security-disclosures)

---

### 1. Code of Conduct

Please be respectful, constructive, and inclusive. This is a community-driven open source
project — every contributor matters. Harassment, trolling, and personal attacks will not
be tolerated.

### 2. Priority Areas

| Area | Description |
|------|-------------|
| **Version bumps** | Updating policies when Brave or Chromium ships a new stable release |
| **Policy verification** | Checking that existing policies still apply in newer versions |
| **New Chromium policies** | Adding official enterprise policies from Chromium's documentation |
| **Bug fixes** | Correcting registry paths, types, or values that cause unexpected behavior |
| **Documentation** | Improving README, CHANGELOG, index.html, or this file |
| **Translations** | Porting the English scripts and docs to additional languages |

### 3. Version Updates

When a new Brave stable version is released:

1. Check `brave://policy` for any deprecated or changed policies.
2. Compare against Brave's official ADMX templates (downloaded via Group Policy
   Administrative Templates or the Chromium policy list).
3. Update the version constants in `BraveOmega-EN.ps1` and `BraveOmega-TR.ps1`
   (`$DogrulananBrave`, `$DogrulananChromium`).
4. Add a changelog entry.

### 4. New Policies

New policies **must** satisfy all of the following:

- **Sourced** from Brave's official ADMX templates or Chromium's enterprise policy
   documentation at `https://chromeenterprise.google/policies/`.
- **ADMX-verified** — the policy name and type must match the official `<string>` and
  `<element>` definitions.
- **Functionally tested** — the policy must produce the expected behavior when set.
- **Backward compatible** — no breaking changes; existing policies must not be removed
  or have their values silently changed.
- **Documented** — added to the tier table, changelog, README, and index.html.

Policies that are undocumented, community-speculated, or not present in official
templates will not be merged.

### 5. Bug Reports

Open a GitHub issue with the following information:

- **Brave version** — output of `brave://version`
- **Windows version** — output of `winver`
- **Script version** — header of the script you ran
- **Full policy page** — `brave://policy` output (screenshot or text export)
- **Expected behavior** — what should happen
- **Actual behavior** — what actually happens
- **Reproduction steps** — exact command and parameters used

### 6. Feature Requests

Before opening a feature request, search existing issues and discussions to see if
the idea has already been proposed. If not, open an issue with:

- A clear description of the problem you want to solve.
- Why this project is the right place for the solution.
- Any relevant links (ADMX documentation, GitHub discussions, etc.).

Large feature requests should be discussed in an issue **before** any code is written.

### 7. Translations

Additional language editions following the EN/TR template structure are welcome:

- Maintain **functional parity** with the English version — same parameters, same
  policy list, same tier system.
- Keep the same `$ScriptVersion` and version-check logic.
- User-facing text (menus, prompts, output messages) should be in the target language.
- File name convention: `BraveOmega-XX.ps1` where `XX` is the language code (e.g.,
  `DE` for German, `FR` for French).
- Update the language switch links in README.md and index.html.

### 8. Pull Request Workflow

1. **Fork** the repository and create a feature branch from `main`.
2. **Commit** changes with a descriptive message (see existing commits for style).
3. **Test** your changes by running the script(s) with `-WhatIf` to verify output.
4. **Update** documentation (README, CHANGELOG, index.html) if applicable.
5. **Open** a pull request against `main` with a clear title and description.

> If your PR addresses an existing issue, reference it (e.g., `Closes #42`).

### 9. Development Setup

```powershell
# Clone the repository
git clone https://github.com/your-username/Brave-Omega-Project.git
cd Brave-Omega-Project

# (Optional) Create a branch for your changes
git checkout -b my-feature-branch
```

All scripts are pure PowerShell 5.1 — no external dependencies, no NuGet packages,
no module installation required.

### 10. Style Guide

**PowerShell scripts** (`BraveOmega-*.ps1`):
- Target **PowerShell 5.1** (no ternary operator `$a ? $b : $c`; use `if/else`).
- Use **4-space indentation**.
- **No comments** in code body (changelog headers and section comments are exempt).
- Follow the existing pattern for registry writes, error handling, and audit trails.
- Parameter names in **PascalCase** (`-Level`, `-WhatIf`, `-Reset`).

**Markdown documentation** (`*.md`):
- Use ATX headings (`##`, `###`), not alternative syntax.
- Tables should be pipe-formatted with alignment dashes.
- Code blocks should specify the language (`powershell`, `bash`, `text`).

**HTML** (`index.html`):
- Tailwind CSS utility classes preferred over custom styles.
- All user-visible text must use `data-i18n` keys for bilingual support.
- Follow the existing translation object structure.

### 11. Security Disclosures

See [SECURITY.md](SECURITY.md) for the full vulnerability disclosure process.

Do **not** open a public issue for security vulnerabilities. Instead, follow the
embargo process documented in SECURITY.md.

---

---

<a id="-türkçe-katkı-rehberi"></a>

## TR Türkçe Katkı Rehberi

Brave Omega'ya katkıda bulunmayı düşündüğünüz için teşekkürler. Bu belge, politika
güncellemeleri, hata raporları, çeviriler ve özellik talepleri için tercih edilen iş
akışını açıklamaktadır.

### İçindekiler

1. [Davranış Kuralları](#1-davranış-kuralları)
2. [Öncelikli Alanlar](#2-öncelikli-alanlar)
3. [Sürüm Güncellemeleri](#3-sürüm-güncellemeleri)
4. [Yeni Politikalar](#4-yeni-politikalar)
5. [Hata Raporları](#5-hata-raporları)
6. [Özellik Talepleri](#6-özellik-talepleri)
7. [Çeviriler](#7-çeviriler)
8. [Pull Request İş Akışı](#8-pull-request-i̇ş-akışı)
9. [Geliştirme Ortamı Kurulumu](#9-geliştirme-ortamı-kurulumu)
10. [Stil Rehberi](#10-stil-rehberi)
11. [Güvenlik Bildirimleri](#11-güvenlik-bildirimleri)

---

### 1. Davranış Kuralları

Lütfen saygılı, yapıcı ve kapsayıcı olun. Bu topluluk odaklı bir açık kaynak projesidir —
her katkıda bulunan değerlidir. Taciz, trolleme ve kişisel saldırılar hoş görülmez.

### 2. Öncelikli Alanlar

| Alan | Açıklama |
|------|----------|
| **Sürüm güncellemeleri** | Brave veya Chromium yeni bir kararlı sürüm yayınladığında politikaları güncelleme |
| **Politika doğrulama** | Mevcut politikaların yeni sürümlerde hâlâ geçerli olduğunu kontrol etme |
| **Yeni Chromium politikaları** | Chromium belgelerinden resmî kurumsal politikalar ekleme |
| **Hata düzeltmeleri** | Beklenmeyen davranışa neden olan kayıt defteri yollarını, türlerini veya değerlerini düzeltme |
| **Belgelendirme** | README, CHANGELOG, index.html veya bu dosyayı iyileştirme |
| **Çeviriler** | İngilizce betikleri ve belgeleri ek dillere taşıma |

### 3. Sürüm Güncellemeleri

Yeni bir Brave kararlı sürümü yayınlandığında:

1. Kullanımdan kaldırılmış veya değişmiş politikalar için `brave://policy` sayfasını
   kontrol edin.
2. Brave'in resmî ADMX şablonları (Grup Yönetim İlkeleri Yönetim Şablonları veya Chromium
   politika listesi üzerinden indirilir) ile karşılaştırın.
3. `BraveOmega-EN.ps1` ve `BraveOmega-TR.ps1` dosyalarındaki sürüm sabitlerini
   (`$DogrulananBrave`, `$DogrulananChromium`) güncelleyin.
4. Değişiklik günlüğüne bir girdi ekleyin.

### 4. Yeni Politikalar

Yeni politikalar aşağıdakilerin **tümünü** sağlamalıdır:

- **Kaynak** — Brave'in resmî ADMX şablonları veya Chromium'un kurumsal politika
   belgeleri (`https://chromeenterprise.google/policies/`).
- **ADMX doğrulaması** — politika adı ve türü, resmî `<string>` ve `<element>`
  tanımlarıyla eşleşmelidir.
- **İşlevsel test** — politika ayarlandığında beklenen davranışı üretmelidir.
- **Geriye dönük uyumluluk** — kırıcı değişiklik olmamalıdır; mevcut politikalar
  kaldırılmamalı veya değerleri sessizce değiştirilmemelidir.
- **Belgelendirme** — katman tablosuna, değişiklik günlüğüne, README'ye ve
  index.html'e eklenmelidir.

Belgelenmemiş, topluluk spekülasyonuna dayalı veya resmî şablonlarda bulunmayan
politikalar birleştirilmeyecektir.

### 5. Hata Raporları

Aşağıdaki bilgilerle bir GitHub sorunu (issue) açın:

- **Brave sürümü** — `brave://version` çıktısı
- **Windows sürümü** — `winver` çıktısı
- **Betik sürümü** — çalıştırdığınız betiğin başlığı
- **Tam politika sayfası** — `brave://policy` çıktısı (ekran görüntüsü veya metin dışa aktarımı)
- **Beklenen davranış** — ne olması gerektiği
- **Gerçek davranış** — gerçekte ne olduğu
- **Tekrarlama adımları** — kullanılan tam komut ve parametreler

### 6. Özellik Talepleri

Bir özellik talebi açmadan önce, fikrin daha önce önerilip önerilmediğini görmek için
mevcut sorunları ve tartışmaları arayın. Eğer daha önce önerilmemişse, aşağıdakilerle
bir sorun açın:

- Çözmek istediğiniz sorunun net bir açıklaması.
- Bu projenin çözüm için neden doğru yer olduğu.
- İlgili bağlantılar (ADMX belgeleri, GitHub tartışmaları, vb.).

Büyük özellik talepleri, herhangi bir kod yazılmadan **önce** bir sorunda
tartışılmalıdır.

### 7. Çeviriler

EN/TR şablon yapısını takip eden ek dil sürümleri memnuniyetle karşılanır:

- İngilizce sürümle **işlevsel denklik** sağlayın — aynı parametreler, aynı politika
  listesi, aynı katman sistemi.
- Aynı `$ScriptVersion` ve sürüm denetimi mantığını koruyun.
- Kullanıcıya dönük metinler (menüler, istemler, çıktı mesajları) hedef dilde olmalıdır.
- Dosya adı kuralı: `BraveOmega-XX.ps1` burada `XX` dil kodudur (örn. `DE` Almanca,
  `FR` Fransızca için).
- Dil değiştirme bağlantılarını README.md ve index.html'de güncelleyin.

### 8. Pull Request İş Akışı

1. Depoyu **fork** edin ve `main` dalından bir özellik dalı oluşturun.
2. Değişiklikleri açıklayıcı bir mesajla **commit** edin (stil için mevcut commit'lere bakın).
3. Betik(ler)i `-WhatIf` ile çalıştırarak çıktıyı **test edin**.
4. Varsa belgelendirmeyi (README, CHANGELOG, index.html) **güncelleyin**.
5. `main` dalına karşı net bir başlık ve açıklama ile bir **pull request** açın.

> PR'niz mevcut bir sorunu ele alıyorsa, referans verin (örn. `Closes #42`).

### 9. Geliştirme Ortamı Kurulumu

```powershell
# Depoyu klonlayın
git clone https://github.com/kullanici-adi/Brave-Omega-Project.git
cd Brave-Omega-Project

# (İsteğe bağlı) Değişiklikleriniz için bir dal oluşturun
git checkout -b ozellik-dalim
```

Tüm betikler saf PowerShell 5.1'dir — harici bağımlılık, NuGet paketi veya modül
kurulumu gerekmez.

### 10. Stil Rehberi

**PowerShell betikleri** (`BraveOmega-*.ps1`):
- **PowerShell 5.1** hedefleyin (üçlü operatör `$a ? $b : $c` kullanmayın; `if/else`
  kullanın).
- **4 boşluk** girinti kullanın.
- Kod gövdesinde **yorum yok** (değişiklik günlüğü başlıkları ve bölüm yorumları hariç).
- Kayıt defteri yazma, hata yönetimi ve denetim izi için mevcut deseni takip edin.
- Parametre adlarında **PascalCase** (`-Level`, `-WhatIf`, `-Sifirla`).

**Markdown belgelendirme** (`*.md`):
- Alternatif sözdizimi değil, ATX başlıkları (`##`, `###`) kullanın.
- Tablolar boru biçimlendirmeli ve hizalama çizgileriyle olmalıdır.
- Kod blokları dil belirtmelidir (`powershell`, `bash`, `text`).

**HTML** (`index.html`):
- Özel stiller yerine Tailwind CSS yardımcı sınıfları tercih edilir.
- Tüm kullanıcı tarafından görülebilen metinler, çift dilli destek için `data-i18n`
  anahtarları kullanmalıdır.
- Mevcut çeviri nesnesi yapısını takip edin.

### 11. Güvenlik Bildirimleri

Tam güvenlik açığı bildirim süreci için [SECURITY.md](SECURITY.md) dosyasına bakın.

Güvenlik açıkları için **halka açık** bir sorun açmayın. Bunun yerine, SECURITY.md'de
belgelenen ambargo sürecini takip edin.

---

<div align="center">

**🦁 Brave Omega Project** — Community Edition

*Building privacy-first browser hardening, one policy at a time.*

</div>
