<!-- ================================================================== -->
<!--                  BRAVE OMEGA PROJECT — README.md                   -->
<!--          Community Edition · Open Source · Privacy First           -->
<!-- ================================================================== -->

<div align="center">

<br>

# 🦁 Brave Omega Project

**Community Edition — Enterprise-Grade Browser Privacy Hardening**

<br>

[![Platform](https://img.shields.io/badge/Platform-Windows%2011%2025H2-0078D4?style=flat-square&logo=windows11&logoColor=white)](https://www.microsoft.com/en-us/windows/windows-11)
[![Brave](https://img.shields.io/badge/Brave-1.91.171%20%7C%20Chromium%20149-FF6000?style=flat-square&logo=brave&logoColor=white)](https://brave.com)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=flat-square&logo=powershell&logoColor=white)](https://learn.microsoft.com/en-us/powershell/)
[![License](https://img.shields.io/badge/License-MIT-22C55E?style=flat-square)](LICENSE)
[![Maintained](https://img.shields.io/badge/Maintained-Yes-22C55E?style=flat-square)](https://github.com/bayraktarozcan/Brave-Omega-Project)
[![Community](https://img.shields.io/badge/Community-Open%20Source-8B5CF6?style=flat-square)](https://github.com/bayraktarozcan/Brave-Omega-Project)

<br>

> **Language / Dil** &nbsp;
> [EN English](#-english-documentation) &nbsp;·&nbsp; [TR Türkçe](#-türkçe-belgelendirme)

<br>

</div>

---

<a id="-english-documentation"></a>

## EN English Documentation

### Table of Contents

1. [What is Brave Omega?](#1-what-is-brave-omega)
2. [Why Brave Omega Exists](#2-why-brave-omega-exists)
3. [Key Features](#3-key-features)
4. [Prerequisites](#4-prerequisites)
5. [Quick Start](#5-quick-start)
6. [How It Works](#6-how-it-works)
7. [♻️ Lifecycle Commitment](#7-️-lifecycle-commitment-throughout-lifecycle-always-up-to-date)
8. [Version Compatibility Matrix](#8-version-compatibility-matrix)
9. [Policy Reference](#9-policy-reference)
10. [Project Structure](#10-project-structure)
11. [Security & Safety](#11-security--safety)
12. [Troubleshooting](#12-troubleshooting)
13. [Roadmap](#13-roadmap)
14. [Contributing](#14-contributing)
15. [License](#15-license)
16. [Disclaimer](#16-disclaimer)

---

### 1. What is Brave Omega?

Brave Omega is an open-source PowerShell automation project that hardens the
[Brave Browser](https://brave.com) through **official enterprise policy channels**. Using
Windows Registry Group Policy architecture and Brave's official ADMX policy framework, it
systematically disables telemetry, analytics services, background pings, integrated
monetization features, and other privacy-eroding components — all without touching the
browser's internals or requiring any third-party tools.

> **Two scripts. One goal. Zero cost.**
>
> `BraveOmega-EN.ps1` — Full English interface, for international users
> `BraveOmega-TR.ps1` — Full Turkish interface, for Turkish-speaking users

---

### 2. Why Brave Omega Exists

Enterprise browser hardening typically demands one of two things: deep technical expertise in
ADMX policy frameworks and registry architecture, or an expensive premium product subscription.
Brave Omega rejects both constraints.

**Everything needed to achieve serious, registry-enforced browser privacy hardening is already
present in the free, open-source Brave Browser.** The enforcement architecture lives in Brave's
official ADMX templates. The mechanism is built into Windows Registry Group Policy. The knowledge
exists in the official documentation. The only missing piece was a validated, automated, and
well-documented bridge between these components.

Brave Omega builds that bridge — and keeps it current throughout the browser's lifecycle.

---

### 3. Key Features

| Feature | Description |
|---------|-------------|
| 🔒 **Three-Tier Privacy Model** | HKCU user preference + HKLM enterprise policy + Omaha updater GUID level — three independent enforcement layers |
| 📋 **ADMX-Validated Policies** | Every policy entry sourced and verified against Brave's official enterprise template package (`policy_templates.zip`) |
| 🔄 **Idempotent Execution** | Run the script any number of times — same safe, consistent result every time |
| 💾 **Automatic Backup** | Time-stamped `.reg` backup of the HKLM policy hive before any modifications |
| 🔁 **One-Command Rollback** | Full restoration with a single command: `reg import "<backup_file.reg>"` |
| 🛡️ **Brave Process Guard** | Detects running Brave instances and presents a continue/cancel decision before applying changes |
| 📊 **Execution Summary** | Per-category success/failure counters with transparent reporting |
| 🌍 **Bilingual** | Full Turkish and English versions with identical functionality and parity |

---

### 4. Prerequisites

| Requirement | Detail |
|-------------|--------|
| **Operating System** | Windows 11 (recommended: latest stable build of 25H2) |
| **Browser** | **Brave Browser — latest stable release** (see [brave.com/download](https://brave.com/download)) |
| **PowerShell** | 5.1+ (included with Windows 11 — no additional installation needed) |
| **Privileges** | Run as Administrator (required for HKLM registry writes) |
| **Execution Policy** | `RemoteSigned` or `Bypass` |

> [!IMPORTANT]
> **Always use the latest stable Brave release before running this script.**
> Brave's enterprise policy landscape evolves with every Chromium update. Running this script
> against an outdated Brave version may result in unrecognized policy keys, mismatched registry
> types, or missing features. Verify your version at
> [brave.com/latest](https://brave.com/latest) and cross-check with the
> [Version Compatibility Matrix](#8-version-compatibility-matrix) before proceeding.

---

### 5. Quick Start

**Step 1 — Allow script execution** *(run once, only if needed)*
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Step 2 — Open PowerShell as Administrator**
Right-click the PowerShell icon → **Run as Administrator**

**Step 3 — Navigate to the project folder**
```powershell
cd "D:\REPOS\BRAVE OMEGA PROJECT\Brave Omega"
```

**Step 4 — Run the script**
```powershell
# English interface:
.\BraveOmega-EN.ps1

# Turkish interface:
.\BraveOmega-TR.ps1
```

**Step 5 — Restart Brave**
Close all Brave windows completely and reopen. Changes take effect immediately on next launch.

**Step 6 — Verify**
Navigate to `brave://policy` in Brave to confirm all enterprise policies are active and
applied correctly.

---

### 6. How It Works

#### 6.1 Architecture — Three-Tier Enforcement Model

Most browser privacy configurations operate at a single level and can be overridden by the user
or by the browser itself during updates. Brave Omega uses a three-tier approach that creates
redundant, independent enforcement at each layer of the Windows + Brave + Omaha stack.

```
┌─────────────────────────────────────────────────────────────┐
│  TIER 1 — HKCU (User Preference Layer)                     │
│  HKCU:\Software\BraveSoftware\Brave-Browser                 │
│  ↳  UsageStatsInSample = 0                                  │
│     Chromium user-level telemetry sampling disabled.        │
│     Provides a fallback during policy propagation delays.   │
├─────────────────────────────────────────────────────────────┤
│  TIER 2 — HKLM (Enterprise Policy Layer / ADMX)            │
│  HKLM:\SOFTWARE\Policies\BraveSoftware\Brave                │
│  ↳  17 ADMX-validated enterprise policies, enforced.       │
│     Appear gray and locked in browser Settings UI.         │
│     Cannot be overridden by user interaction.              │
├─────────────────────────────────────────────────────────────┤
│  TIER 3 — Omaha Updater GUID Layer                         │
│  HKCU:\Software\BraveSoftware\Update\ClientState\{GUID}     │
│  ↳  usagestats = 0 per application GUID                    │
│     Targets the update infrastructure's own telemetry,     │
│     independently of all browser-level policies.           │
└─────────────────────────────────────────────────────────────┘
```

#### 6.2 Policy Sources & Methodology

> **Core principle: Zero unofficial or speculative registry changes.**

Every policy applied in this project is traceable to one of the following authoritative sources.
Nothing is guesswork. If a policy cannot be verified through official documentation, it is
excluded — along with a documented explanation of why.

| Source | Policies Covered |
|--------|-----------------|
| **Brave Official ADMX Template Package** (`policy_templates.zip`) | `BraveRewardsDisabled`, `BraveWalletDisabled`, `BraveVPNDisabled`, `BraveAIChatEnabled`, `BraveStatsPingEnabled` |
| **Chromium Enterprise Policy Documentation** | `MetricsReportingEnabled`, `SafeBrowsingExtendedReportingEnabled` |
| **Google Omaha Updater Architecture** | `usagestats` (per GUID, in HKCU update layer) |
| **Chromium Preferences Schema** | `UsageStatsInSample` (HKCU user preference) |

> [!NOTE]
> **`BraveShieldsDefault` was intentionally excluded.** Despite appearing in some community guides,
> this policy name does not exist in Brave's official ADMX templates. Brave manages Shields
> via URL-based policies (`BraveShieldsEnabledForUrls`, `BraveShieldsDisabledForUrls`). Global
> aggressive mode is applied through user profile preferences (Preferences JSON), not through an
> enterprise registry policy. Including an unrecognized key would create a registry entry that
> appears to work but has zero actual effect. This project documents why each exclusion was made,
> not only what was included.

---

### 7. ♻️ Lifecycle Commitment: Throughout Lifecycle Always Up-to-Date

> **A privacy hardening tool that falls out of date is not a safeguard — it is a false sense of security.**

Browser policy landscapes change with every major Chromium release. Policy keys get renamed,
deprecated, or superseded. New privacy-relevant controls are introduced. An unmaintained
hardening script drifts into irrelevance — or worse, silently applies stale configurations that
no longer have any effect.

**Brave Omega is built around a lifecycle-first commitment:**

- **Version Pinning** — Every script release is explicitly tagged in its header with the
  exact validated Brave + Chromium version combination. There is no ambiguity about what
  environment the script was tested against.

- **Policy Review on Every Brave Stable Release** — When Brave ships a new stable version,
  the ADMX template package is reviewed against the previous version. New policies are
  evaluated, deprecated ones are removed, and changed behavior is documented.

- **Breaking Change Notices** — Any removed or renamed policy key is documented in the
  changelog with a migration note. Users upgrading Brave versions will know exactly what
  changed and why.

- **Community-Driven Currency** — Version mismatches, newly deprecated keys, and
  newly available policies identified by contributors are reviewed and merged promptly.

- **Always-Stable Recommendation** — The project consistently recommends the **latest stable
  Brave release**. Beta and Nightly builds may not have fully stabilized ADMX behavior and
  are not the primary validation target.

---

### 8. Version Compatibility Matrix

| Brave Omega | Brave Version | Chromium | Windows | Status |
|-------------|---------------|----------|---------|--------|
| **v1.2** *(current)* | 1.91.171 | 149 | 11 25H2 | ✅ Active |
| v1.1 | 1.91.168 | 149 | 11 25H2 | 📦 Previous |
| v1.0 | 1.91.168 | 149 | 11 25H2 | 🔒 Archived |

> [!TIP]
> **Before running:** Verify your installed Brave version against the matrix above.
> If a newer Brave version has been released, check the [Releases](../../releases) page
> for a corresponding updated Brave Omega release before running an older script version.
> When in doubt, always update Brave to the latest stable release first.

---

### 9. Policy Reference

| Registry Key | Hive | Value | Effect |
|--------------|------|-------|--------|
| `UsageStatsInSample` | HKCU | `0` | Disables browser-level usage statistics sampling sent to Brave servers |
| `BraveRewardsDisabled` | HKLM | `1` | Removes Rewards ad system, BAT token earning engine, and push notifications |
| `BraveWalletDisabled` | HKLM | `1` | Removes integrated crypto wallet module, toolbar button, and background services |
| `BraveVPNDisabled` | HKLM | `1` | Removes VPN toolbar button and blocks the Brave VPN background service network |
| `BraveAIChatEnabled` | HKLM | `0` | Disables Leo AI Chat engine, conversation history, and all API connections |
| `BraveStatsPingEnabled` | HKLM | `0` | Stops periodic status and authentication pings to Brave servers |
| `MetricsReportingEnabled` | HKLM | `0` | Disables Chromium core metrics collection and external telemetry reporting |
| `SafeBrowsingExtendedReportingEnabled` | HKLM | `0` | Stops extended site data reports during Safe Browsing checks (core SB unaffected) |
| `usagestats` *(per GUID)* | HKCU | `0` | Disables Omaha updater telemetry per application GUID identifier |
| `BraveP3AEnabled` *(v1.2+)* | HKLM | `0` | Disables Privacy-Preserving Product Analytics (P3A) data transmission |
| `BraveWebDiscoveryEnabled` *(v1.2+)* | HKLM | `0` | Disables Web Discovery Project data contribution to Brave Search index |
| `BraveTalkDisabled` *(v1.2+)* | HKLM | `1` | Disables Brave Talk video conferencing widget and call options |
| `BraveNewsDisabled` *(v1.2+)* | HKLM | `1` | Disables Brave News feed on New Tab Page |
| `BravePlaylistEnabled` *(v1.2+)* | HKLM | `0` | Disables Brave Playlist feature for offline media playback |
| `BraveSpeedreaderEnabled` *(v1.2+)* | HKLM | `0` | Disables Speedreader mode and article cleaning suggestions |
| `BraveWaybackMachineEnabled` *(v1.2+)* | HKLM | `0` | Disables Internet Archive Wayback Machine integration on 404 errors |
| `TorDisabled` *(v1.2+)* | HKLM | `1` | Disables Tor network integration and "New Private Window with Tor" |

---

### 10. Project Structure

```
BRAVE OMEGA PROJECT/
│
├── .gitignore                   Git exclusion rules
└── Brave Omega/
        BraveOmega-EN.ps1        Main script — English interface
        BraveOmega-TR.ps1        Main script — Turkish interface
```

---

### 11. Security & Safety

> [!WARNING]
> This script modifies the Windows Registry and **requires Administrator privileges**.
> Always read and understand the source code before executing any PowerShell script as
> Administrator. Never run untrusted scripts with elevated privileges.

| Concern | How Brave Omega Addresses It |
|---------|------------------------------|
| **Unauthorized changes** | Full source is open for review. No obfuscation. No external network calls. No executables. |
| **Unrecoverable state** | Automatic time-stamped `.reg` backup before any HKLM writes. Restore with `reg import`. |
| **Partial application** | Per-operation try-catch with individual success/failure counters. You know exactly what was applied. |
| **Browser data loss** | Brave process detection with explicit continue/cancel prompt before any changes are made. |
| **Repeated execution** | Idempotent design via `-Force` parameter. Running multiple times produces no side effects. |

---

### 12. Troubleshooting

| Symptom | Likely Cause | Resolution |
|---------|-------------|------------|
| Script exits with "CRITICAL ERROR" immediately | Not running as Administrator | Right-click PowerShell → **Run as Administrator** |
| `brave://policy` shows no policies after running | Brave was not restarted | Close all Brave windows and reopen |
| `[ERROR]` lines appear in script output | HKLM path permission issue | Confirm Administrator mode; re-run the script |
| Brave appears to overwrite HKCU preferences | Brave was open during execution | Close Brave first; re-run the script |
| A policy key shows "Unknown" in `brave://policy` | Brave/Chromium version mismatch | Verify installed Brave version matches the compatibility matrix |
| `reg export` fails during backup step | Pre-existing HKLM path has restricted permissions | Run `regedit` to inspect the path; check ACL entries |

---

### 13. Roadmap

- [ ] Automated Brave version detection — warn if installed version differs from validated target
- [ ] `BraveShieldsEnabledForUrls` / `BraveShieldsDisabledForUrls` URL list management
- [ ] Dry-run mode via `-WhatIf` parameter — preview all changes without writing to registry
- [ ] Reset/uninstall mode — remove all applied Brave Omega policies cleanly
- [ ] Additional language editions (community contributions welcome)
- [ ] GitHub Actions pipeline for automated ADMX policy diff validation on each Brave stable release
- [ ] Structured `CONTRIBUTING.md` and issue templates

---

### 14. Contributing

Contributions are welcome. Priority areas:

**Version Updates** — When a new Brave stable is released and a policy has changed, open a
pull request with the updated value, source reference, and changelog entry.

**New Policies** — Must be sourced from Brave's official ADMX templates or Chromium's
enterprise policy documentation. Undocumented or community-speculated registry keys will
not be merged.

**Bug Reports** — If a policy causes unexpected behavior on a specific Brave version, open
an issue including your Brave version, Windows version, the full `brave://policy` page output,
and a description of the unexpected behavior.

**Translations** — Additional language editions following the EN/TR template structure are
welcome. Maintain functional parity with the English version.

Please open an issue for discussion before submitting large pull requests.

---

### 15. License

This project is released under the **MIT License**.  
See [LICENSE](LICENSE) for full terms.

---

### 16. Disclaimer

Brave Omega is an independent community project and is **not affiliated with, endorsed by, or
officially connected to Brave Software, Inc.** in any way. The Brave name and logo are
registered trademarks of Brave Software, Inc.

All registry modifications are performed at the user's own risk. The project authors accept no
responsibility for system instability, policy conflicts, data loss, or unintended behavior
resulting from the use of this project. Always verify backups, test in a non-production
environment first, and review the source code before executing in any managed or enterprise setting.

---

---

<a id="-türkçe-belgelendirme"></a>

## TR Türkçe Belgelendirme

### İçindekiler

1. [Brave Omega Nedir?](#1-brave-omega-nedir)
2. [Brave Omega Neden Var?](#2-brave-omega-neden-var)
3. [Temel Özellikler](#3-temel-özellikler)
4. [Ön Gereksinimler](#4-ön-gereksinimler)
5. [Hızlı Başlangıç](#5-hızlı-başlangıç)
6. [Nasıl Çalışır?](#6-nasıl-çalışır)
7. [♻️ Yaşam Döngüsü Taahhüdü](#7-️-yaşam-döngüsü-taahhüdü-yaşam-döngüsü-boyunca-her-daim-güncel)
8. [Sürüm Uyumluluk Matrisi](#8-sürüm-uyumluluk-matrisi)
9. [Politika Başvuru Tablosu](#9-politika-başvuru-tablosu)
10. [Proje Yapısı](#10-proje-yapısı)
11. [Güvenlik ve Emniyet](#11-güvenlik-ve-emniyet)
12. [Sorun Giderme](#12-sorun-giderme)
13. [Yol Haritası](#13-yol-haritası)
14. [Katkıda Bulunma](#14-katkıda-bulunma)
15. [Lisans](#15-lisans)
16. [Sorumluluk Reddi](#16-sorumluluk-reddi)

---

### 1. Brave Omega Nedir?

Brave Omega, [Brave Browser](https://brave.com)'ı **resmî kurumsal politika kanalları**
aracılığıyla sıkılaştıran açık kaynaklı bir PowerShell özdevim projesidir. Windows Kayıt
Defteri Grup İlkesi mimarisi ve Brave'in resmî ADMX politika çerçevesi kullanılarak; veri
aktarımı (telemetri), analiz hizmetleri, arka plan pinglari, tümleşik para kazanma bileşenleri
ve gizliliği aşındıran diğer özellikler sistematik biçimde devre dışı bırakılır. Tarayıcının iç
yapısına hiç dokunulmaz; herhangi bir üçüncü taraf araç gerekmez.

> **İki betik. Tek hedef. Sıfır maliyet.**
>
> `BraveOmega-EN.ps1` — Tam İngilizce arayüz, uluslararası kullanıcılar için
> `BraveOmega-TR.ps1` — Tam Türkçe arayüz, Türkçe konuşan kullanıcılar için

---

### 2. Brave Omega Neden Var?

Kurumsal düzeyde tarayıcı gizlilik sıkılaştırması iki şeyden birini gerektirir: ADMX politika
çerçeveleri ve kayıt defteri mimarisine derin teknik hâkimiyet ya da pahalı bir ücretli ürün
aboneliği. Brave Omega her iki kısıtlamayı da ortadan kaldırır.

**Ciddi, kayıt defteri düzeyinde zorunlu kılınan tarayıcı gizlilik sıkılaştırması için
gereken her şey, ücretsiz ve açık kaynaklı Brave Browser içinde zaten mevcuttur.** Zorunlu
kılma mimarisi Brave'in resmî ADMX şablonlarında hazır durumdadır. Düzenek, Windows Kayıt
Defteri Grup İlkesi içine yerleşik şekilde çalışır. Bilgi resmî belgelendirmede açıktır. Tek
eksik olan; bu bileşenler arasında doğrulanmış, otomatize edilmiş ve iyi belgelenmiş bir köprüydü.

Brave Omega o köprüyü inşa eder — ve tarayıcının yaşam döngüsü boyunca güncel tutar.

---

### 3. Temel Özellikler

| Özellik | Açıklama |
|---------|----------|
| 🔒 **Üç Katmanlı Gizlilik Modeli** | HKCU kullanıcı tercihi + HKLM kurumsal ilke + Omaha güncelleyici GUID düzeyi — bağımsız üç zorunlu kılma katmanı |
| 📋 **ADMX Doğrulamalı İlkeler** | Her politika girişi Brave'in resmî kurumsal şablon paketi (`policy_templates.zip`) ile kaynaklanmış ve doğrulanmıştır |
| 🔄 **Kararsız Olmayan Çalışma** | Betiği istediğiniz kadar çalıştırın — her seferinde aynı güvenli, tutarlı sonuç |
| 💾 **Otomatik Yedekleme** | Değişikliklerden önce HKLM politika kovası için zaman damgalı `.reg` yedeği |
| 🔁 **Tek Komutla Geri Alma** | Tek komutla tam eski duruma dönüş: `reg import "<yedek_dosyası.reg>"` |
| 🛡️ **Brave Süreç Koruyucusu** | Değişiklik uygulanmadan önce çalışan Brave örnekleri tespit edilip kullanıcıya karar sunulur |
| 📊 **Yürütme Özeti** | Kategori bazında başarı/hata sayaçları ile şeffaf raporlama |
| 🌍 **İki Dilli** | Birebir işlevselliğe sahip Türkçe ve İngilizce sürümler |

---

### 4. Ön Gereksinimler

| Gereksinim | Ayrıntı |
|------------|---------|
| **İşletim Sistemi** | Windows 11 (önerilen: en güncel kararlı 25H2 derlemesi) |
| **Tarayıcı** | **Brave Browser — en güncel kararlı sürüm** (bkz. [brave.com/download](https://brave.com/download)) |
| **PowerShell** | 5.1+ (Windows 11 ile birlikte gelir — ek kurulum gerekmez) |
| **Ayrıcalık** | Yönetici olarak çalıştır (HKLM kayıt defteri yazma işlemi için zorunlu) |
| **Çalıştırma İlkesi** | `RemoteSigned` veya `Bypass` |

> [!IMPORTANT]
> **Bu betiği çalıştırmadan önce her zaman en güncel kararlı Brave sürümünü kullanın.**
> Brave'in kurumsal politika yapısı her Chromium güncellemesiyle birlikte gelişir. Güncel
> olmayan bir Brave sürümünde bu betiği çalıştırmak; tanınmayan politika anahtarlarına, kayıt
> defteri türü uyuşmazlıklarına veya eksik özelliklere yol açabilir. Devam etmeden önce
> [brave.com/latest](https://brave.com/latest) adresini kontrol edin ve
> [Sürüm Uyumluluk Matrisi](#8-sürüm-uyumluluk-matrisi) ile karşılaştırın.

---

### 5. Hızlı Başlangıç

**Adım 1 — Betik çalıştırma iznini ver** *(yalnızca gerekirse, bir kez)*
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Adım 2 — PowerShell'i Yönetici olarak aç**
PowerShell simgesine sağ tıkla → **Yönetici olarak çalıştır**

**Adım 3 — Proje klasörüne geç**
```powershell
cd "D:\REPOS\BRAVE OMEGA PROJECT\Brave Omega"
```

**Adım 4 — Betiği çalıştır**
```powershell
# Türkçe arayüz:
.\BraveOmega-TR.ps1

# İngilizce arayüz:
.\BraveOmega-EN.ps1
```

**Adım 5 — Brave'i yeniden başlat**
Tüm Brave pencerelerini tamamen kapat ve yeniden aç. Değişiklikler bir sonraki açılışta hemen devreye girer.

**Adım 6 — Doğrula**
Tüm kurumsal ilkelerin doğru biçimde etkin olduğunu onaylamak için Brave'de `brave://policy` adresine git.

---

### 6. Nasıl Çalışır?

#### 6.1 Mimari — Üç Katmanlı Zorunlu Kılma Modeli

Tarayıcı gizlilik yapılandırmalarının büyük çoğunluğu tek bir düzeyde çalışır ve kullanıcı
ya da güncelleme sırasında tarayıcının kendisi tarafından üzerine yazılabilir. Brave Omega,
Windows + Brave + Omaha yığınının her katmanında bağımsız zorunlu kılma oluşturan üç katmanlı
bir yaklaşım kullanır.

```
┌─────────────────────────────────────────────────────────────┐
│  KATMAN 1 — HKCU (Kullanıcı Tercihi Katmanı)              │
│  HKCU:\Software\BraveSoftware\Brave-Browser                 │
│  ↳  UsageStatsInSample = 0                                  │
│     Chromium kullanıcı düzeyi veri aktarımı kapatıldı.     │
│     Politika yayılma gecikmelerinde yedek güvence sağlar.  │
├─────────────────────────────────────────────────────────────┤
│  KATMAN 2 — HKLM (Kurumsal İlke Katmanı / ADMX)           │
│  HKLM:\SOFTWARE\Policies\BraveSoftware\Brave                │
│  ↳  17 ADMX doğrulamalı kurumsal ilke, zorunlu kılındı.   │
│     Tarayıcı Ayarlar arayüzünde gri/kilitli görünür.      │
│     Kullanıcı etkileşimiyle değiştirilemez.               │
├─────────────────────────────────────────────────────────────┤
│  KATMAN 3 — Omaha Güncelleyici GUID Katmanı               │
│  HKCU:\Software\BraveSoftware\Update\ClientState\{GUID}     │
│  ↳  Her uygulama GUID'i için usagestats = 0               │
│     Güncelleme altyapısının kendi veri aktarımını,        │
│     tarayıcı düzeyi ilkelerden bağımsız olarak kapatır.   │
└─────────────────────────────────────────────────────────────┘
```

#### 6.2 Politika Kaynakları ve Yöntem

> **Temel ilke: Sıfır gayri resmî veya spekülatif kayıt defteri değişikliği.**

Bu projede uygulanan her politika, aşağıdaki yetkili kaynaklardan birine izlenebilir.
Hiçbir şey tahmine dayalı değildir. Bir politika resmî belgelendirme aracılığıyla
doğrulanamıyorsa dışarıda bırakılır — neden dışarıda bırakıldığına dair belgelenmiş
açıklamasıyla birlikte.

| Kaynak | Kapsanan Politikalar |
|--------|---------------------|
| **Brave Resmî ADMX Şablon Paketi** (`policy_templates.zip`) | `BraveRewardsDisabled`, `BraveWalletDisabled`, `BraveVPNDisabled`, `BraveAIChatEnabled`, `BraveStatsPingEnabled` |
| **Chromium Kurumsal Politika Belgelendirmesi** | `MetricsReportingEnabled`, `SafeBrowsingExtendedReportingEnabled` |
| **Google Omaha Güncelleyici Mimarisi** | `usagestats` (GUID başına, HKCU güncelleme katmanında) |
| **Chromium Tercihler Şeması** | `UsageStatsInSample` (HKCU kullanıcı tercihi) |

> [!NOTE]
> **`BraveShieldsDefault` kasıtlı olarak dışarıda bırakıldı.** Bazı topluluk kılavuzlarında
> yer almasına rağmen bu politika adı Brave'in resmî ADMX şablonlarında bulunmamaktadır.
> Brave, kalkanları URL bazlı politikalarla (`BraveShieldsEnabledForUrls`,
> `BraveShieldsDisabledForUrls`) yönetir. Genel saldırgan mod, kurumsal kayıt defteri
> politikası değil; kullanıcı profil tercihleri (Preferences JSON) aracılığıyla uygulanır.
> Tanınmayan bir anahtar eklemek; gerçekte hiçbir etkisi olmayan ama çalışıyormuş gibi
> görünen bir kayıt defteri kaydı bırakırdı. Bu proje, nelerin dahil edildiğini değil,
> aynı zamanda nelerin ve neden dışarıda bırakıldığını da belgeler.

---

### 7. ♻️ Yaşam Döngüsü Taahhüdü: Yaşam Döngüsü Boyunca Her Daim Güncel

> **Güncelliğini yitiren bir gizlilik sıkılaştırma aracı, güvenlik güvencesi değil — yanlış bir güvenlik duygusudur.**

Tarayıcı politika yapıları her büyük Chromium sürümüyle değişir. Politika anahtarları
yeniden adlandırılır, kullanımdan kaldırılır ya da yenileriyle değiştirilir. Yeni gizlilikle
ilgili denetimler tanıtılır. Bakımsız bir sıkılaştırma betiği zamanla anlamsızlaşır — ya da
daha kötüsü, sessizce artık hiçbir etkisi olmayan eski yapılandırmaları uygulamaya devam eder.

**Brave Omega, yaşam döngüsünü esas alan bir taahhüt üzerine inşa edilmiştir:**

- **Sürüm Sabitleme** — Her betik sürümü, başlığında doğrulanmış Brave + Chromium sürüm
  kombinasyonuyla açıkça etiketlenir. Betiğin hangi ortama karşı sınanıldığı konusunda
  hiçbir belirsizlik yoktur.

- **Her Brave Kararlı Sürümünde Politika Gözden Geçirmesi** — Brave yeni bir kararlı sürüm
  yayımladığında ADMX şablon paketi önceki sürümle karşılaştırılır. Yeni politikalar
  değerlendirilir, kullanımdan kaldırılanlar kaldırılır, değişen davranışlar belgelenir.

- **Kırıcı Değişiklik Bildirimleri** — Kaldırılan veya yeniden adlandırılan her politika
  anahtarı, geçiş notunun eşliğinde değişiklik günlüğünde belgelenir. Brave sürümlerini
  yükseltecek kullanıcılar tam olarak neyin değiştiğini ve neden değiştiğini öğrenir.

- **Topluluk Güdümlü Güncellik** — Katkıda bulunanlar tarafından tespit edilen sürüm
  uyuşmazlıkları, kullanımdan kalkmış anahtarlar ve yeni kullanılabilir politikalar
  hızla gözden geçirilip dahil edilir.

- **Her Zaman Kararlı Sürüm Önerisi** — Proje, tutarlı biçimde **en güncel kararlı Brave
  sürümünü** önerir. Beta ve Nightly derlemeleri ADMX davranışı açısından henüz tam
  kararlı olmayabilir; bu nedenle birincil doğrulama hedefi değildir.

---

### 8. Sürüm Uyumluluk Matrisi

| Brave Omega | Brave Sürümü | Chromium | Windows | Durum |
|-------------|--------------|----------|---------|-------|
| **v1.2** *(güncel)* | 1.91.171 | 149 | 11 25H2 | ✅ Etkin |
| v1.1 | 1.91.168 | 149 | 11 25H2 | 📦 Önceki |
| v1.0 | 1.91.168 | 149 | 11 25H2 | 🔒 Arşivlendi |

> [!TIP]
> **Çalıştırmadan önce:** Yüklü Brave sürümünüzün yukarıdaki matrisle eşleşip eşleşmediğini
> doğrulayın. Daha yeni bir Brave sürümü yayımlandıysa eski bir betik sürümünü çalıştırmadan
> önce [Sürümler](../../releases) sayfasında güncellenmiş bir Brave Omega sürümü olup
> olmadığını kontrol edin. Şüphe durumunda önce Brave'i en güncel kararlı sürüme güncelleyin.

---

### 9. Politika Başvuru Tablosu

| Kayıt Defteri Anahtarı | Kovan | Değer | Etki |
|------------------------|-------|-------|------|
| `UsageStatsInSample` | HKCU | `0` | Brave sunucularına gönderilen tarayıcı düzeyi kullanım istatistikleri örneklemesini devre dışı bırakır |
| `BraveRewardsDisabled` | HKLM | `1` | Rewards reklam sistemini, BAT jeton kazanç motorunu ve bildirim altyapısını kaldırır |
| `BraveWalletDisabled` | HKLM | `1` | Tümleşik kripto cüzdan modülünü, araç çubuğu düğmesini ve arka plan hizmetlerini kaldırır |
| `BraveVPNDisabled` | HKLM | `1` | VPN araç çubuğu düğmesini kaldırır ve Brave VPN arka plan hizmet ağını engeller |
| `BraveAIChatEnabled` | HKLM | `0` | Leo Yapay Zekâ Chat motorunu, konuşma geçmişini ve tüm API bağlantılarını devre dışı bırakır |
| `BraveStatsPingEnabled` | HKLM | `0` | Brave sunucularına gönderilen periyodik durum ve kimlik doğrulama pinglerini durdurur |
| `MetricsReportingEnabled` | HKLM | `0` | Chromium ana ölçüm toplamayı ve harici veri aktarımı raporlamasını devre dışı bırakır |
| `SafeBrowsingExtendedReportingEnabled` | HKLM | `0` | Güvenli Tarama sırasında genişletilmiş site veri raporlarını durdurur (temel SB işlevi etkilenmez) |
| `usagestats` *(GUID başına)* | HKCU | `0` | Uygulama GUID tanımlayıcısı başına Omaha güncelleyici veri aktarımını devre dışı bırakır |
| `BraveP3AEnabled` *(v1.2+)* | HKLM | `0` | Gizlilik Korumalı Ürün Analitiği (P3A) veri transmisyonunu devre dışı bırakır |
| `BraveWebDiscoveryEnabled` *(v1.2+)* | HKLM | `0` | Web Discovery Project'in Brave Search indeksine veri katkısını devre dışı bırakır |
| `BraveTalkDisabled` *(v1.2+)* | HKLM | `1` | Brave Talk video konferans widget'ını ve çağrı seçeneklerini kapatır |
| `BraveNewsDisabled` *(v1.2+)* | HKLM | `1` | Yeni Sekme Sayfasındaki Brave News haber beslemesini devre dışı bırakır |
| `BravePlaylistEnabled` *(v1.2+)* | HKLM | `0` | Çevrimdışı ortam oynatması için Brave Playlist özelliğini kapatır |
| `BraveSpeedreaderEnabled` *(v1.2+)* | HKLM | `0` | Speedreader modunu ve makale temizliği önerilerini devre dışı bırakır |
| `BraveWaybackMachineEnabled` *(v1.2+)* | HKLM | `0` | 404 hatalarında İnternet Archive Wayback Machine entegrasyonunu kapatır |
| `TorDisabled` *(v1.2+)* | HKLM | `1` | Tor ağı entegrasyonunu ve "Tor İle Yeni Gizli Pencere" seçeneğini kapatır |

---

### 10. Proje Yapısı

```
BRAVE OMEGA PROJECT/
│
├── .gitignore                  Git dışlama kuralları
└── Brave Omega/
        BraveOmega-EN.ps1       Ana betik — İngilizce arayüz
        BraveOmega-TR.ps1       Ana betik — Türkçe arayüz
```

---

### 11. Güvenlik ve Emniyet

> [!WARNING]
> Bu betik Windows Kayıt Defteri'ni değiştirmekte ve **Yönetici ayrıcalıkları**
> gerektirmektedir. Herhangi bir PowerShell betiğini Yönetici olarak çalıştırmadan önce
> kaynak kodu her zaman okuyup anlayın. Güvenilmeyen betikleri asla yükseltilmiş ayrıcalıklarla
> çalıştırmayın.

| Endişe | Brave Omega'nın Yaklaşımı |
|--------|--------------------------|
| **Yetkisiz değişiklikler** | Kaynak tamamen açık incelemeye sunulmuştur. Gizleme yok. Harici ağ çağrısı yok. Çalıştırılabilir dosya yok. |
| **Geri alınamaz durum** | Her HKLM yazma işleminden önce otomatik zaman damgalı `.reg` yedeği. `reg import` ile geri al. |
| **Kısmi uygulama** | Her işlem için bireysel try-catch ve başarı/hata sayaçları. Tam olarak neyin uygulandığını bilirsiniz. |
| **Tarayıcı veri kaybı** | Değişiklik uygulanmadan önce Brave süreç tespiti ve açık devam/iptal istemi. |
| **Yinelenen çalıştırma** | `-Force` parametresiyle kararsız olmayan tasarım. Birden fazla çalıştırmanın yan etkisi yoktur. |

---

### 12. Sorun Giderme

| Belirti | Olası Neden | Çözüm |
|---------|------------|-------|
| Betik hemen "KRİTİK HATA" ile çıkıyor | Yönetici olarak çalıştırılmıyor | PowerShell'e sağ tıkla → **Yönetici olarak çalıştır** |
| Çalıştırma sonrası `brave://policy` politika göstermiyor | Brave yeniden başlatılmadı | Tüm Brave pencerelerini kapat ve yeniden aç |
| Betik çıktısında `[HATA]` satırları görünüyor | HKLM yolu izin sorunu | Yönetici modunu doğrula; betiği yeniden çalıştır |
| Brave HKCU tercihlerini üzerine yazıyor | Çalışma sırasında Brave açıktı | Önce Brave'i kapat; betiği yeniden çalıştır |
| `brave://policy`'de bir politika anahtarı "Bilinmiyor" gösteriyor | Chromium sürümü uyuşmazlığı | Yüklü Brave sürümünün uyumluluk matrisiyle eşleştiğini doğrula |
| Yedekleme adımında `reg export` başarısız oluyor | Mevcut HKLM yolunda kısıtlı izin | `regedit` ile yolu incele; ACL girdilerini kontrol et |

---

### 13. Yol Haritası

- [ ] Otomatik Brave sürüm tespiti — yüklü sürüm doğrulanmış hedeften farklıysa uyar
- [ ] `BraveShieldsEnabledForUrls` / `BraveShieldsDisabledForUrls` URL listesi yönetimi
- [ ] `-WhatIf` parametresiyle kuru çalıştırma kipi — kayıt defterine yazmadan tüm değişiklikleri önizle
- [ ] Sıfırlama/kaldırma kipi — uygulanan tüm Brave Omega politikalarını temiz biçimde sil
- [ ] Ek dil sürümleri (topluluk katkıları memnuniyetle karşılanır)
- [ ] Her Brave kararlı sürümünde otomatik ADMX politika farkı doğrulaması için GitHub Actions ardışık düzeni
- [ ] Yapılandırılmış `CONTRIBUTING.md` ve sorun şablonları

---

### 14. Katkıda Bulunma

Katkılar memnuniyetle karşılanır. Öncelikli alanlar:

**Sürüm Güncellemeleri** — Yeni bir Brave kararlı sürümü yayımlandıysa ve bir politika
değiştiyse, güncellenmiş değer, kaynak referansı ve değişiklik günlüğü girdisiyle birlikte
bir çekme isteği (PR) açın.

**Yeni Politikalar** — Brave'in resmî ADMX şablonlarından veya Chromium'un kurumsal
politika belgelendirmesinden kaynaklanmış olmalıdır. Belgelenmemiş veya topluluk kaynaklı
spekülatif kayıt defteri anahtarları birleştirilmeyecektir.

**Hata Raporları** — Belirli bir Brave sürümünde beklenmedik davranış oluşursa; Brave
sürümünüzü, Windows sürümünüzü, tam `brave://policy` sayfası çıktısını ve beklenmedik
davranışın açıklamasını ekleyerek bir sorun bildirin.

**Çeviriler** — EN/TR şablon yapısını izleyen ek dil sürümleri memnuniyetle karşılanır.
İngilizce sürümle işlevsel eşdeğerlik korunmalıdır.

Büyük çekme istekleri göndermeden önce tartışma için bir sorun açın.

---

### 15. Lisans

Bu proje **MIT Lisansı** kapsamında yayımlanmıştır.
Tam koşullar için [LICENSE](LICENSE) dosyasına bakın.

---

### 16. Sorumluluk Reddi

Brave Omega, bağımsız bir topluluk projesidir ve hiçbir şekilde **Brave Software, Inc. ile
bağlantılı, onun tarafından onaylanmış veya resmî olarak ilişkili değildir.** Brave adı ve
logosu, Brave Software, Inc.'in tescilli markalarıdır.

Tüm kayıt defteri değişiklikleri kullanıcının kendi sorumluluğundadır. Proje yazarları, bu
projenin kullanımından kaynaklanan sistem kararsızlığı, politika çakışmaları, veri kaybı veya
istenmeyen davranışlardan dolayı hiçbir sorumluluk kabul etmez. Yönetilen ya da kurumsal bir
ortamda çalıştırmadan önce her zaman üretim dışı bir ortamda sınayın, yedekleri doğrulayın ve
kaynak kodu inceleyin.

---

<div align="center">

<br>

**🦁 Brave Omega Project** — Community Edition

*Built with care. Maintained with purpose.*

*Özenle inşa edildi. Amaçla sürdürülüyor.*

<br>

</div>
