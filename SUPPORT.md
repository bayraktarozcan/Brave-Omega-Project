<!-- ================================================================== -->
<!--            BRAVE OMEGA PROJECT — SUPPORT.md                        -->
<!--        Community Edition · Open Source · Privacy First             -->
<!-- ================================================================== -->

<div align="center">

<br>

# 🛟 Brave Omega — Support

<br>

[![Platform](https://img.shields.io/badge/Platform-Windows%2011%2025H2-0078D4?style=flat-square&logo=windows11&logoColor=white)](https://www.microsoft.com/en-us/windows/windows-11)
[![Brave](https://img.shields.io/badge/Brave-1.95.101%20%7C%20Chromium%20153-FF6000?style=flat-square&logo=brave&logoColor=white)](https://brave.com)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=flat-square&logo=powershell&logoColor=white)](https://learn.microsoft.com/en-us/powershell/)
[![License](https://img.shields.io/badge/License-MIT-22C55E?style=flat-square)](LICENSE)

<br>

> **Language / Dil** &nbsp;
> [EN English](#-english-support-guide) &nbsp;·&nbsp; [TR Türkçe](#-türkçe-destek-rehberi)

<br>

</div>

---

<a id="-english-support-guide"></a>

## EN English Support Guide

### Where to Get Help

1. **Read the docs first.** The [README](README.md), the [Wiki](https://github.com/bayraktarozcan/Brave-Omega-Project/wiki), and [CHANGELOG.md](CHANGELOG.md) answer most questions.
2. **Run a dry run.** Use `-WhatIf` to preview every registry change without writing anything.
3. **Open an issue.** For bugs and feature requests, use the templates described in [CONTRIBUTING.md](CONTRIBUTING.md).
4. **Report vulnerabilities privately.** Follow [SECURITY.md](SECURITY.md) — never file security issues publicly.

### Supported Environments

| Component | Requirement |
|-----------|-------------|
| Windows | 11 25H2 (validated build) |
| PowerShell | 5.1 or newer (Windows PowerShell; `pwsh` is not required) |
| Brave | Stable 1.95.101 (Chromium 153) — latest stable recommended |
| Privileges | Elevated (Administrator) session required for policy writes |

See the [Version Compatibility Matrix](Wiki/Version-Compatibility-Matrix.md) for the full version history.

### Before Filing a Bug

- Confirm that you run the latest stable Brave and the current Brave Omega release.
- Reproduce with `-WhatIf` first and capture the output.
- Include: Windows build, PowerShell version, Brave version (from `brave://version`),
  the exact command, and the full output (no personal data).
- Error text is essential; screenshots are welcome.

### Out of Scope

- Validation for Beta / Nightly / Chromium-only builds — the README documents the stable-first recommendation.
- Running on Linux or macOS.
- Semi-automated tweaks outside the five published tiers (Brave Only / Essential / Balanced / Advanced / Strict).

---

<a id="-türkçe-destek-rehberi"></a>

## TR Türkçe Destek Rehberi

### Nereden Yardım Alınır

1. **Önce belgeleri okuyun.** [README](README.md), [Wiki](https://github.com/bayraktarozcan/Brave-Omega-Project/wiki) ve [CHANGELOG.md](CHANGELOG.md) çoğu soruyu yanıtlar.
2. **Kuru çalıştırma yapın.** Hiçbir şey yazmadan yapılacak tüm kayıt defteri değişikliklerini önizlemek için `-WhatIf` kullanın.
3. **Bir sorun açın.** Hata ve özellik istekleri için [CONTRIBUTING.md](CONTRIBUTING.md) içinde anlatılan şablonları kullanın.
4. **Güvenlik açıklarını özel bildirin.** [SECURITY.md](SECURITY.md) yolunu izleyin — güvenlik sorunlarını asla herkese açık paylaşmayın.

### Desteklenen Ortamlar

| Bileşen | Gereksinim |
|---------|------------|
| Windows | 11 25H2 (doğrulanmış derleme) |
| PowerShell | 5.1 veya üzeri (Windows PowerShell; `pwsh` gerekmez) |
| Brave | Kararlı 1.95.101 (Chromium 153) — güncel kararlı sürüm önerilir |
| Ayrıcalıklar | Politika yazımı için yükseltilmiş (Yönetici) oturum gerekir |

Tam sürüm geçmişi için [Sürüm Uyumluluk Matrisi'ne](Wiki/Version-Compatibility-Matrix.md) bakın.

### Hata Bildirmeden Önce

- Güncel kararlı Brave ve mevcut Brave Omega sürümünü çalıştırdığınızdan emin olun.
- Önce `-WhatIf` ile yeniden üretin ve çıktıyı alın.
- Belirtin: Windows derlemesi, PowerShell sürümü, Brave sürümü (`brave://version`),
  tam komut ve çıktı (kişisel veri olmadan).
- Hata metni gereklidir; ekran görüntüleri memnuniyetle karşılanır.

### Kapsam Dışı

- Beta / Nightly / yalnız Chromium derlemeleri için doğrulama — README, kararlı-önce yaklaşımını belgeler.
- Linux veya macOS üzerinde çalıştırma.
- Beş yayınlanmış seviyenin (Brave Yalnız / Temel / Dengeli / Gelişmiş / Katı) dışında yarı otomatik ayarlar.