<!-- ================================================================== -->
<!--                  BRAVE OMEGA PROJECT â€” SECURITY.MD              -->
<!--          Community Edition Â· Open Source Â· Privacy First        -->
<!-- ================================================================== -->

<div align="center">

<br>

# ğŸ›¡ï¸ Brave Omega â€” Security Policy

<br>

[![Platform](https://img.shields.io/badge/Platform-Windows%2011%2025H2-0078D4?style=flat-square&logo=windows11&logoColor=white)](https://www.microsoft.com/en-us/windows/windows-11)
[![Brave](https://img.shields.io/badge/Brave-1.91.172%20%7C%20Chromium%20149-FF6000?style=flat-square&logo=brave&logoColor=white)](https://brave.com)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=flat-square&logo=powershell&logoColor=white)](https://learn.microsoft.com/en-us/powershell/)
[![License](https://img.shields.io/badge/License-MIT-22C55E?style=flat-square)](LICENSE)
[![Security](https://img.shields.io/badge/Security-Policy-8B5CF6?style=flat-square)](SECURITY.md)

<br>

> **Language / Dil** &nbsp;
> [EN English](#-english-security-policy) &nbsp;Â·&nbsp; [TR TÃ¼rkÃ§e](#-tÃ¼rkÃ§e-gÃ¼venlik-politikasÄ±)

<br>

</div>

---

<a id="-english-security-policy"></a>

## EN English Security Policy

### Table of Contents

1. [Overview](#en-overview)
2. [Supported Versions](#en-supported-versions)
3. [Vulnerability Disclosure](#en-vulnerability-disclosure)
4. [Security Posture](#en-security-posture)
5. [Policy Verification](#en-policy-verification)
6. [Trust & Supply Chain](#en-trust--supply-chain)
7. [Registry Safety](#en-registry-safety)
8. [Hardening Levels](#en-hardening-levels)
9. [Security FAQ](#en-security-faq)

---

### 1. Overview

Brave Omega is a registry-hardening tool designed to **enhance** browser privacy, not to introduce new attack surfaces. This document outlines the project's security stance, vulnerability handling procedures, and how to verify the integrity of the changes the script makes.

> [!IMPORTANT]
> Brave Omega makes **no network calls** during execution, downloads **no external payloads**, and writes **no browser extensions or binaries**. It operates exclusively through Windows Registry Group Policy mechanisms using Brave's official ADMX template definitions.

---

### 2. Supported Versions

| Branch | Status | Supported |
|--------|--------|-----------|
| **v2.x (current)** | Active development | âœ… Security patches, policy updates, feature improvements |
| v1.2.x | Maintained | âœ… Critical security patches only |
| v1.1.x | End of life | âŒ No longer supported |
| v1.0 | Archived | âŒ No longer supported |

> [!NOTE]
> To receive security updates, always use the latest stable release. Older versions may contain unpatched policy gaps as Chromium's enterprise policy landscape evolves.

---

### 3. Vulnerability Disclosure

#### 3.1 Reporting a Vulnerability

If you discover a security-related issue in Brave Omega â€” whether a policy that has an unintended side effect, a registry path that behaves unexpectedly, or any other concern â€” please report it privately:

- **Email**: Open a [GitHub Security Advisory](https://github.com/bayraktarozcan/Brave-Omega-Project/security/advisories/new)
- **Issue**: For non-critical security concerns, open a standard [GitHub Issue](https://github.com/bayraktarozcan/Brave-Omega-Project/issues) with the `security` label

#### 3.2 Response Timeline

| Timeframe | Action |
|-----------|--------|
| **24â€“48 hours** | Initial acknowledgment |
| **5 business days** | Triage and severity assessment |
| **14 calendar days** | Fix released or mitigation documented |
| **30 calendar days** | Full disclosure if applicable |

#### 3.3 Scope

**In scope:**
- Registry policies that leak data beyond documented behavior
- Policies with incorrect or unsafe default values
- Unintended privilege escalation paths
- Incorrect ADMX-to-registry type mapping

**Out of scope:**
- Vulnerabilities in Brave Browser itself (report to [Brave Security](https://hackerone.com/brave))
- Vulnerabilities in Windows or PowerShell
- Social engineering attacks requiring physical access
- Denial of service through registry modification (inherent to the tool's purpose)

---

### 4. Security Posture

#### 4.1 Defense-in-Depth Architecture

Brave Omega implements browser hardening through **three independent enforcement layers**:

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚  TIER 1 â€” HKCU User Preference                           â”‚
â”‚  â†³ UsageStatsInSample = 0                                 â”‚
â”‚  â†³ ChromeVariations = 1 (HKCU mirror)                     â”‚
â”‚  â†³ User-modifiable, provides fallback protection          â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  TIER 2 â€” HKLM Enterprise Policy (ADMX)                  â”‚
â”‚  â†³ 13â€“68 policies depending on hardening level            â”‚
â”‚  â†³ Locked/gray in browser UI â€” user cannot override       â”‚
â”‚  â†³ Requires Administrator privileges to write             â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  TIER 3 â€” Omaha Updater GUID Layer                       â”‚
â”‚  â†³ usagestats = 0 per application GUID                   â”‚
â”‚  â†³ Independent of browser-level policies                  â”‚
â”‚  â†³ Disables update infrastructure telemetry              â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

#### 4.2 Principle of Least Privilege

- The script **requires Administrator** privileges because it writes to the HKLM registry hive
- No permanent elevation: the script exits, privileges are gone
- No background services, no scheduled tasks, no startup entries

#### 4.3 No Telemetry

Brave Omega itself collects **zero telemetry**. The script:
- Makes no network calls
- Downloads no external content
- Writes no usage logs
- Does not phone home

#### 4.4 Execution Policy Safety

The recommended invocation method uses a **session-scoped bypass**:

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1"
```

This affects only the current PowerShell window. No permanent execution policy change is made. No attack surface is introduced.

---

### 5. Policy Verification

#### 5.1 Verify Applied Policies

After running the script, confirm active policies in Brave:

1. Navigate to `brave://policy`
2. Verify all expected policies appear in the list
3. Check that policy values match the expected settings

#### 5.2 Verify Registry Directly

```powershell
# List all applied Brave enterprise policies
Get-ChildItem -Path "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

# Check a specific policy value
Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Name "MetricsReportingEnabled"
```

#### 5.3 Verify Backup Integrity

Backups are stored in `%TEMP%\BravePolicyBackup\` with timestamps. To inspect:
```powershell
notepad "$env:TEMP\BravePolicyBackup\*"
```

To restore a previous state:
```powershell
reg import "$env:TEMP\BravePolicyBackup\HKLM_BravePolicy_20260607_143022.reg"
```

#### 5.4 Source Verification

Every policy in Brave Omega can be traced to its authoritative source:

| Source | Location | Verification Method |
|--------|----------|-------------------|
| Brave ADMX Templates | `policy_templates.zip` from Brave | Extract and inspect ADMX/ADML XML |
| Chromium Policy Docs | `policy_templates_en-US.json` (1459 policies) | JSON schema validation |
| Chromium Preferences | Brave browser Preferences JSON | Inspect at `brave://version` profile path |
| Omaha Updater Schema | Windows registry `ClientState` keys | `Get-ChildItem` on GUID paths |

---

### 6. Trust & Supply Chain

#### 6.1 Code Integrity

- **Fully open source** â€” every line is public at [github.com/bayraktarozcan/Brave-Omega-Project](https://github.com/bayraktarozcan/Brave-Omega-Project)
- **No obfuscation** â€” the PowerShell source is plain text, human-readable, and reviewable
- **No compiled binaries** â€” no `.exe`, `.dll`, or `.msi` files
- **No external dependencies** â€” requires only PowerShell 5.1+, included with Windows 11

#### 6.2 Commit Signing

Project maintainers sign releases and tags using GPG. Verify signatures:
```powershell
git tag -v v2.0
```

#### 6.3 Supply Chain Recommendations

For enterprise deployments:
1. Fork the repository and audit the code internally
2. Run the script in a test environment before production
3. Pin to a specific release tag, not `main` branch
4. Verify SHA256 checksums of downloaded release artifacts

---

### 7. Registry Safety

#### 7.1 Automatic Backup

Before writing any HKLM policy, the script exports the current state:

```powershell
reg export "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" "backup.reg" /y
```

#### 7.2 Idempotent Design

All registry write operations use the `-Force` flag. Running the script multiple times:
- Does not create duplicate entries
- Does not cause side effects
- Produces identical results each time

#### 7.3 Graceful Error Handling

Each registry write is individually wrapped in a try-catch block:
- Failed policies do not halt the entire script
- Success and failure are tracked with counters
- The final summary report shows exactly what was applied

#### 7.4 Rollback

Full state restoration with a single command:
```powershell
reg import "%TEMP%\BravePolicyBackup\HKLM_BravePolicy_20260607_143022.reg"
```

#### 7.5 Policy Types

The script handles three registry value types:

| Registry Type | PowerShell Type | Examples |
|---------------|----------------|----------|
| `REG_DWORD` | `DWord` | Boolean and integer policies (most common) |
| `REG_SZ` | `String` | Enum string policies (WebRTC, DNS, HTTPS) |
| `REG_MULTI_SZ` | `MultiString` | List policies (URL lists, sync types) |

---

### 8. Hardening Levels

Brave Omega offers four progressive hardening tiers:

| Level | Policies | Description | Usability Impact |
|-------|----------|-------------|-----------------|
| **Brave Only** | 13 Brave-specific | Disables Brave's integrated services only | None |
| **Essential ⭐** | 29 (Brave Only + 16) | Brave + zero-impact data leak prevention | None |
| **Balanced** | 47 (Essential + 18) | Full security baseline with minor changes | Low |
| **Strict** | 67 (Balanced + 20) | Maximum privacy preservation | Medium |

Each level cumulatively includes all policies from previous levels. See [README.md](README.md) for the complete policy reference.

---

### 9. Security FAQ

**Q: Does Brave Omega modify the Brave browser binary?**
A: No. It writes only to the Windows Registry. The browser binary remains untouched.

**Q: Can these policies be reversed without a backup?**
A: Yes. Delete the `HKLM\SOFTWARE\Policies\BraveSoftware\Brave` registry key to remove all policies. A full backup is recommended for audit purposes.

**Q: Does Brave Omega protect against all tracking?**
A: No tool can provide absolute privacy. Brave Omega focuses on **first-party telemetry and data leakage prevention** through enterprise policy channels. Additional protections (VPNs, anti-fingerprinting, etc.) are complementary.

**Q: Can I run this script in a managed enterprise environment?**
A: Yes, but test in a non-production environment first. The script is designed for enterprise deployment with idempotent execution and automated backups. Use the `-Level` parameter for silent deployment.

**Q: What happens when Brave updates?**
A: Registry policies persist across browser updates. However, new Brave/Chromium versions may introduce new policies or deprecate existing ones. Always run the latest Brave Omega version for the corresponding Brave version.

**Q: Does this script work with Chrome instead of Brave?**
A: The policies registry path differs. Brave uses `HKLM\SOFTWARE\Policies\BraveSoftware\Brave` while Chrome uses `HKLM\SOFTWARE\Policies\Google\Chrome`. With path substitution, many policies are compatible, but this project targets Brave specifically.

---

<a id="-tÃ¼rkÃ§e-gÃ¼venlik-politikasÄ±"></a>

## TR TÃ¼rkÃ§e GÃ¼venlik PolitikasÄ±

### Ä°Ã§indekiler

1. [Genel BakÄ±ÅŸ](#tr-genel-bakÄ±ÅŸ)
2. [Desteklenen SÃ¼rÃ¼mler](#tr-desteklenen-sÃ¼rÃ¼mler)
3. [GÃ¼venlik AÃ§Ä±ÄŸÄ± Bildirimi](#tr-gÃ¼venlik-aÃ§Ä±ÄŸÄ±-bildirimi)
4. [GÃ¼venlik DuruÅŸu](#tr-gÃ¼venlik-duruÅŸu)
5. [Politika DoÄŸrulama](#tr-politika-doÄŸrulama)
6. [GÃ¼ven ve Tedarik Zinciri](#tr-gÃ¼ven-ve-tedarik-zinciri)
7. [KayÄ±t Defteri GÃ¼venliÄŸi](#tr-kayÄ±t-defteri-gÃ¼venliÄŸi)
8. [SÄ±kÄ±laÅŸtÄ±rma Seviyeleri](#tr-sÄ±kÄ±laÅŸtÄ±rma-seviyeleri)
9. [GÃ¼venlik SSS](#tr-gÃ¼venlik-sss)

---

### 1. Genel BakÄ±ÅŸ

Brave Omega, tarayÄ±cÄ± gizliliÄŸini artÄ±rmak iÃ§in tasarlanmÄ±ÅŸ bir kayÄ±t defteri sÄ±kÄ±laÅŸtÄ±rma aracÄ±dÄ±r. Yeni saldÄ±rÄ± yÃ¼zeyleri oluÅŸturmaz, mevcut gÃ¼venlik aÃ§Ä±klarÄ±nÄ± kapatÄ±r. Bu belge, projenin gÃ¼venlik duruÅŸunu, gÃ¼venlik aÃ§Ä±ÄŸÄ± bildirim sÃ¼reÃ§lerini ve betiÄŸin yaptÄ±ÄŸÄ± deÄŸiÅŸikliklerin bÃ¼tÃ¼nlÃ¼ÄŸÃ¼nÃ¼ doÄŸrulama yÃ¶ntemlerini aÃ§Ä±klar.

> [!IMPORTANT]
> Brave Omega, Ã§alÄ±ÅŸma sÄ±rasÄ±nda **hiÃ§bir aÄŸ Ã§aÄŸrÄ±sÄ± yapmaz**, **harici yÃ¼k indirmez** ve **tarayÄ±cÄ± uzantÄ±sÄ± veya ikili dosya yazmaz**. YalnÄ±zca Windows KayÄ±t Defteri Grup Ä°lkesi mekanizmalarÄ± ve Brave'in resmÃ® ADMX ÅŸablon tanÄ±mlarÄ± aracÄ±lÄ±ÄŸÄ±yla Ã§alÄ±ÅŸÄ±r.

---

### 2. Desteklenen SÃ¼rÃ¼mler

| Dal | Durum | Destek |
|-----|-------|--------|
| **v2.x (gÃ¼ncel)** | Aktif geliÅŸtirme | âœ… GÃ¼venlik yamalarÄ±, politika gÃ¼ncellemeleri, yeni Ã¶zellikler |
| v1.2.x | BakÄ±mda | âœ… YalnÄ±zca kritik gÃ¼venlik yamalarÄ± |
| v1.1.x | KullanÄ±m Ã¶mrÃ¼ sonu | âŒ ArtÄ±k desteklenmiyor |
| v1.0 | ArÅŸivlendi | âŒ ArtÄ±k desteklenmiyor |

> [!NOTE]
> GÃ¼venlik gÃ¼ncellemelerini almak iÃ§in her zaman en gÃ¼ncel kararlÄ± sÃ¼rÃ¼mÃ¼ kullanÄ±n. Eski sÃ¼rÃ¼mler, Chromium'un kurumsal politika yapÄ±sÄ± geliÅŸtikÃ§e gÃ¼ncelliÄŸini yitirebilir.

---

### 3. GÃ¼venlik AÃ§Ä±ÄŸÄ± Bildirimi

#### 3.1 GÃ¼venlik AÃ§Ä±ÄŸÄ± Bildirme

Brave Omega ile ilgili bir gÃ¼venlik sorunu keÅŸfederseniz â€” istenmeyen yan etkiye sahip bir politika, beklenmedik davranÄ±ÅŸ gÃ¶steren bir kayÄ±t defteri yolu veya baÅŸka bir endiÅŸe â€” lÃ¼tfen Ã¶zel olarak bildirin:

- **E-posta**: [GitHub Security Advisory](https://github.com/bayraktarozcan/Brave-Omega-Project/security/advisories/new) sayfasÄ±nÄ± kullanÄ±n
- **Sorun**: Kritik olmayan gÃ¼venlik endiÅŸeleri iÃ§in `security` etiketiyle standart bir [GitHub Issue](https://github.com/bayraktarozcan/Brave-Omega-Project/issues) aÃ§Ä±n

#### 3.2 YanÄ±t SÃ¼resi

| Zaman AralÄ±ÄŸÄ± | Eylem |
|---------------|-------|
| **24â€“48 saat** | Ä°lk bildirim onayÄ± |
| **5 iÅŸ gÃ¼nÃ¼** | Ã–n deÄŸerlendirme ve ciddiyet belirleme |
| **14 takvim gÃ¼nÃ¼** | DÃ¼zeltme yayÄ±mlanÄ±r veya geÃ§ici Ã§Ã¶zÃ¼m belgelenir |
| **30 takvim gÃ¼nÃ¼** | Gerekirse tam aÃ§Ä±klama |

#### 3.3 Kapsam

**Kapsam dahilinde:**
- Belgelenen davranÄ±ÅŸÄ±n Ã¶tesinde veri sÄ±zdÄ±ran kayÄ±t defteri politikalarÄ±
- YanlÄ±ÅŸ veya gÃ¼vensiz varsayÄ±lan deÄŸerlere sahip politikalar
- Yetkisiz ayrÄ±calÄ±k yÃ¼kseltme yollarÄ±
- HatalÄ± ADMX-kayÄ±t defteri tÃ¼rÃ¼ eÅŸlemesi

**Kapsam dÄ±ÅŸÄ±nda:**
- Brave Browser'Ä±n kendisindeki gÃ¼venlik aÃ§Ä±klarÄ± ([Brave Security](https://hackerone.com/brave) adresine bildirin)
- Windows veya PowerShell'deki gÃ¼venlik aÃ§Ä±klarÄ±
- Fiziksel eriÅŸim gerektiren sosyal mÃ¼hendislik saldÄ±rÄ±larÄ±
- KayÄ±t defteri deÄŸiÅŸikliÄŸi yoluyla hizmet reddi (araÃ§ doÄŸasÄ± gereÄŸi)

---

### 4. GÃ¼venlik DuruÅŸu

#### 4.1 Derinlemesine Savunma Mimarisi

Brave Omega, tarayÄ±cÄ± sÄ±kÄ±laÅŸtÄ±rmasÄ±nÄ± **Ã¼Ã§ baÄŸÄ±msÄ±z zorunlu kÄ±lma katmanÄ±** aracÄ±lÄ±ÄŸÄ±yla uygular:

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚  KATMAN 1 â€” HKCU KullanÄ±cÄ± Tercihi                       â”‚
â”‚  â†³ UsageStatsInSample = 0                                 â”‚
â”‚  â†³ ChromeVariations = 1 (HKCU yansÄ±masÄ±)                  â”‚
â”‚  â†³ KullanÄ±cÄ± tarafÄ±ndan deÄŸiÅŸtirilebilir, yedek koruma    â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  KATMAN 2 â€” HKLM Kurumsal Politika (ADMX)                â”‚
â”‚  â†³ SÄ±kÄ±laÅŸtÄ±rma seviyesine baÄŸlÄ± olarak 13â€“68 politika    â”‚
â”‚  â†³ TarayÄ±cÄ± arayÃ¼zÃ¼nde kilitli/gri â€” kullanÄ±cÄ± deÄŸiÅŸtiremezâ”‚
â”‚  â†³ Yazmak iÃ§in YÃ¶netici ayrÄ±calÄ±klarÄ± gerekir            â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  KATMAN 3 â€” Omaha GÃ¼ncelleyici GUID KatmanÄ±              â”‚
â”‚  â†³ Her uygulama GUID'i iÃ§in usagestats = 0               â”‚
â”‚  â†³ TarayÄ±cÄ± dÃ¼zeyi politikalarÄ±ndan baÄŸÄ±msÄ±z             â”‚
â”‚  â†³ GÃ¼ncelleme altyapÄ±sÄ± veri aktarÄ±mÄ±nÄ± kapatÄ±r          â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

#### 4.2 En Az AyrÄ±calÄ±k Ä°lkesi

- Betik, HKLM kayÄ±t defteri kovanÄ±na yazdÄ±ÄŸÄ± iÃ§in **YÃ¶netici ayrÄ±calÄ±klarÄ±** gerektirir
- KalÄ±cÄ± yetki yÃ¼kseltmesi yok: betik biter, yetkiler kaybolur
- Arka plan hizmeti, zamanlanmÄ±ÅŸ gÃ¶rev veya baÅŸlangÄ±Ã§ kaydÄ± yok

#### 4.3 Veri AktarÄ±mÄ± Yok

Brave Omega'nÄ±n kendisi **sÄ±fÄ±r veri aktarÄ±mÄ±** toplar:
- HiÃ§bir aÄŸ Ã§aÄŸrÄ±sÄ± yapmaz
- Harici iÃ§erik indirmez
- KullanÄ±m gÃ¼nlÃ¼ÄŸÃ¼ yazmaz
- DÄ±ÅŸarÄ±ya bilgi gÃ¶ndermez

#### 4.4 Ã‡alÄ±ÅŸtÄ±rma Ä°lkesi GÃ¼venliÄŸi

Ã–nerilen Ã§alÄ±ÅŸtÄ±rma yÃ¶ntemi **oturum bazlÄ± bypass** kullanÄ±r:

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"
```

Bu ayar yalnÄ±zca geÃ§erli PowerShell penceresini etkiler. KalÄ±cÄ± bir Ã§alÄ±ÅŸtÄ±rma ilkesi deÄŸiÅŸikliÄŸi yapÄ±lmaz. HiÃ§bir saldÄ±rÄ± yÃ¼zeyi oluÅŸturulmaz.

---

### 5. Politika DoÄŸrulama

#### 5.1 Uygulanan PolitikalarÄ± DoÄŸrulama

Betik Ã§alÄ±ÅŸtÄ±ktan sonra Brave'de aktif politikalarÄ± kontrol edin:

1. `brave://policy` adresine gidin
2. Beklenen tÃ¼m politikalarÄ±n listede gÃ¶rÃ¼ndÃ¼ÄŸÃ¼nÃ¼ doÄŸrulayÄ±n
3. Politika deÄŸerlerinin beklenen ayarlarla eÅŸleÅŸtiÄŸini kontrol edin

#### 5.2 KayÄ±t Defterini DoÄŸrudan DoÄŸrulama

```powershell
# Uygulanan tÃ¼m Brave kurumsal politikalarÄ±nÄ± listele
Get-ChildItem -Path "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

# Belirli bir politika deÄŸerini kontrol et
Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Name "MetricsReportingEnabled"
```

#### 5.3 Yedek BÃ¼tÃ¼nlÃ¼ÄŸÃ¼nÃ¼ DoÄŸrulama

Yedekler zaman damgalarÄ±yla `%TEMP%\BravePolicyYedek\` klasÃ¶rÃ¼nde saklanÄ±r:

```powershell
notepad "$env:TEMP\BravePolicyYedek\*"
```

Ã–nceki duruma dÃ¶nmek iÃ§in:
```powershell
reg import "$env:TEMP\BravePolicyYedek\HKLM_BravePolicy_20260607_143022.reg"
```

#### 5.4 Kaynak DoÄŸrulama

Brave Omega'daki her politika yetkili kaynaÄŸÄ±na kadar izlenebilir:

| Kaynak | Konum | DoÄŸrulama YÃ¶ntemi |
|--------|-------|-------------------|
| Brave ADMX ÅablonlarÄ± | `policy_templates.zip` | ADMX/ADML XML'ini Ã§Ä±kar ve incele |
| Chromium Politika DokÃ¼manlarÄ± | `policy_templates_en-US.json` (1459 politika) | JSON ÅŸema doÄŸrulamasÄ± |
| Chromium Tercihleri | Brave Preferences JSON | `brave://version` profil yolunda incele |
| Omaha GÃ¼ncelleyici ÅemasÄ± | Windows kayÄ±t defteri `ClientState` anahtarlarÄ± | GUID yollarÄ±nda `Get-ChildItem` |

---

### 6. GÃ¼ven ve Tedarik Zinciri

#### 6.1 Kod BÃ¼tÃ¼nlÃ¼ÄŸÃ¼

- **Tamamen aÃ§Ä±k kaynak** â€” her satÄ±r [github.com/bayraktarozcan/Brave-Omega-Project](https://github.com/bayraktarozcan/Brave-Omega-Project) adresinde kamuya aÃ§Ä±ktÄ±r
- **Gizleme yok** â€” PowerShell kaynaÄŸÄ± dÃ¼z metin, insan tarafÄ±ndan okunabilir ve incelenebilir
- **DerlenmiÅŸ ikili dosya yok** â€” `.exe`, `.dll` veya `.msi` dosyasÄ± yok
- **Harici baÄŸÄ±mlÄ±lÄ±k yok** â€” yalnÄ±zca Windows 11 ile birlikte gelen PowerShell 5.1+ gerektirir

#### 6.2 Ä°mza DoÄŸrulama

Proje bakÄ±mcÄ±larÄ± sÃ¼rÃ¼mleri ve etiketleri GPG kullanarak imzalar:

```powershell
git tag -v v2.0
```

#### 6.3 Tedarik Zinciri Ã–nerileri

Kurumsal daÄŸÄ±tÄ±mlar iÃ§in:
1. Depoyu forklayÄ±n ve kodu dahili olarak denetleyin
2. Ãœretim ortamÄ±ndan Ã¶nce test ortamÄ±nda Ã§alÄ±ÅŸtÄ±rÄ±n
3. `main` dalÄ± deÄŸil, belirli bir sÃ¼rÃ¼m etiketine sabitleyin
4. Ä°ndirilen sÃ¼rÃ¼m yapÄ±tlarÄ±nÄ±n SHA256 saÄŸlama toplamlarÄ±nÄ± doÄŸrulayÄ±n

---

### 7. KayÄ±t Defteri GÃ¼venliÄŸi

#### 7.1 Otomatik Yedekleme

Her HKLM politikasÄ± yazmadan Ã¶nce, betik mevcut durumu dÄ±ÅŸa aktarÄ±r:

```powershell
reg export "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" "yedek.reg" /y
```

#### 7.2 KararsÄ±z Olmayan TasarÄ±m

TÃ¼m kayÄ±t defteri yazma iÅŸlemleri `-Force` bayraÄŸÄ±nÄ± kullanÄ±r. BetiÄŸi birden fazla kez Ã§alÄ±ÅŸtÄ±rmak:
- Yinelenen kayÄ±t oluÅŸturmaz
- Yan etkiye neden olmaz
- Her seferinde aynÄ± sonucu Ã¼retir

#### 7.3 Hata YÃ¶netimi

Her kayÄ±t defteri yazma iÅŸlemi ayrÄ± ayrÄ± try-catch bloÄŸuyla sarÄ±lÄ±r:
- BaÅŸarÄ±sÄ±z politikalar tÃ¼m betiÄŸi durdurmaz
- BaÅŸarÄ± ve baÅŸarÄ±sÄ±zlÄ±k sayaÃ§larla takip edilir
- Nihai Ã¶zet raporu tam olarak neyin uygulandÄ±ÄŸÄ±nÄ± gÃ¶sterir

#### 7.4 Geri Alma

Tek komutla tam durum geri yÃ¼kleme:
```powershell
reg import "%TEMP%\BravePolicyYedek\HKLM_BravePolicy_20260607_143022.reg"
```

#### 7.5 Politika TÃ¼rleri

Betik Ã¼Ã§ kayÄ±t defteri deÄŸer tÃ¼rÃ¼nÃ¼ iÅŸler:

| KayÄ±t Defteri TÃ¼rÃ¼ | PowerShell TÃ¼rÃ¼ | Ã–rnekler |
|--------------------|----------------|----------|
| `REG_DWORD` | `DWord` | Boolean ve tamsayÄ± politikalarÄ± (en yaygÄ±n) |
| `REG_SZ` | `String` | Enum string politikalarÄ± (WebRTC, DNS, HTTPS) |
| `REG_MULTI_SZ` | `MultiString` | Liste politikalarÄ± (URL listeleri, senkronizasyon tÃ¼rleri) |

---

### 8. SÄ±kÄ±laÅŸtÄ±rma Seviyeleri

Brave Omega dÃ¶rt kademeli sÄ±kÄ±laÅŸtÄ±rma seviyesi sunar:

| Seviye | Politika SayÄ±sÄ± | AÃ§Ä±klama | KullanÄ±m Etkisi |
|--------|----------------|----------|----------------|
| **Brave YalnÄ±z** | 13 Brave'e Ã¶zgÃ¼ | YalnÄ±zca Brave'in tÃ¼mleÅŸik hizmetlerini kapatÄ±r | Yok |
| **Temel â­** | 29 (Brave Yalnız + 16) | Brave + sÄ±fÄ±r etkili veri sÄ±zÄ±ntÄ±sÄ± Ã¶nleme | Yok |
| **Dengeli** | 47 (Temel + 18) | Tam gÃ¼venlik temeli, kÃ¼Ã§Ã¼k deÄŸiÅŸiklikler | DÃ¼ÅŸÃ¼k |
| **KatÄ±** | 67 (Dengeli + 20) | Azami gizlilik korumasÄ± | Orta |

Her seviye, Ã¶nceki seviyelerdeki tÃ¼m politikalarÄ± kÃ¼mÃ¼latif olarak iÃ§erir. Tam politika referansÄ± iÃ§in [README.md](README.md) dosyasÄ±na bakÄ±n.

---

### 9. GÃ¼venlik SSS

**S: Brave Omega, Brave tarayÄ±cÄ± ikili dosyasÄ±nÄ± deÄŸiÅŸtirir mi?**
C: HayÄ±r. YalnÄ±zca Windows KayÄ±t Defteri'ne yazar. TarayÄ±cÄ± ikili dosyasÄ±na dokunulmaz.

**S: Bu politikalar yedek olmadan geri alÄ±nabilir mi?**
C: Evet. TÃ¼m politikalarÄ± kaldÄ±rmak iÃ§in `HKLM\SOFTWARE\Policies\BraveSoftware\Brave` kayÄ±t defteri anahtarÄ±nÄ± silin. Denetim amaÃ§lÄ± tam yedek Ã¶nerilir.

**S: Brave Omega tÃ¼m izlemeye karÅŸÄ± korur mu?**
C: HiÃ§bir araÃ§ mutlak gizlilik saÄŸlayamaz. Brave Omega, kurumsal politika kanallarÄ± aracÄ±lÄ±ÄŸÄ±yla **birinci taraf veri aktarÄ±mÄ± ve veri sÄ±zÄ±ntÄ±sÄ± Ã¶nlemeye** odaklanÄ±r. Ek korumalar (VPN'ler, parmak izine karÅŸÄ± koruma vb.) tamamlayÄ±cÄ±dÄ±r.

**S: Bu betiÄŸi yÃ¶netilen bir kurumsal ortamda Ã§alÄ±ÅŸtÄ±rabilir miyim?**
C: Evet, ancak Ã¶nce Ã¼retim dÄ±ÅŸÄ± bir ortamda test edin. Betik, kararsÄ±z olmayan Ã§alÄ±ÅŸma ve otomatik yedeklemelerle kurumsal daÄŸÄ±tÄ±m iÃ§in tasarlanmÄ±ÅŸtÄ±r. Sessiz daÄŸÄ±tÄ±m iÃ§in `-Level` parametresini kullanÄ±n.

**S: Brave gÃ¼ncellendiÄŸinde ne olur?**
C: KayÄ±t defteri politikalarÄ± tarayÄ±cÄ± gÃ¼ncellemeleri arasÄ±nda kalÄ±cÄ±dÄ±r. Ancak yeni Brave/Chromium sÃ¼rÃ¼mleri yeni politikalar ekleyebilir veya mevcutlarÄ± kullanÄ±mdan kaldÄ±rabilir. Ä°lgili Brave sÃ¼rÃ¼mÃ¼ iÃ§in her zaman en gÃ¼ncel Brave Omega sÃ¼rÃ¼mÃ¼nÃ¼ kullanÄ±n.

**S: Bu betik Chrome ile Ã§alÄ±ÅŸÄ±r mÄ±?**
C: Politika kayÄ±t defteri yollarÄ± farklÄ±dÄ±r. Brave `HKLM\SOFTWARE\Policies\BraveSoftware\Brave` kullanÄ±rken Chrome `HKLM\SOFTWARE\Policies\Google\Chrome` kullanÄ±r. Yol ikamesiyle birÃ§ok politika uyumludur ancak bu proje Ã¶zellikle Brave'i hedefler.

---

<div align="center">

<br>

**ğŸ¦ Brave Omega Project** â€” Community Edition

*Security is not a feature. It is a foundation.*

*GÃ¼venlik bir Ã¶zellik deÄŸildir. Temeldir.*

<br>

</div>






