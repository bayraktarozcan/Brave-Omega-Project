> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;Â·&nbsp; [TR TÃ¼rkÃ§e](#-tÃ¼rkÃ§e)

<a id="-english"></a>

# ğŸ”§ Installation â€” Complete Setup Guide

Complete installation guide for Brave Omega v2.1.6.0 (Phase 3: Quality & Testing).

---

## System Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| **Operating System** | Windows 11 | Windows 11 25H2 (latest stable) |
| **Brave Browser** | 1.91.x | Latest stable ([brave.com/download](https://brave.com/download)) |
| **PowerShell** | 5.1 | 5.1+ (built into Windows 11) |
| **Privileges** | Administrator | Administrator |
| **Disk Space** | 1 MB | 5 MB (for backups) |

---

## Pre-Installation Checklist

- [ ] Windows 11 installed and updated
- [ ] Brave Browser **latest stable** installed ([brave.com/download](https://brave.com/download))
- [ ] Brave version verified at [brave.com/latest](https://brave.com/latest)
- [ ] Version matches [Compatibility Matrix](Version-Compatibility-Matrix)
- [ ] Administrator account available

> âš ï¸ **Critical:** Always run against the **latest stable Brave release**. Beta/Nightly builds may have unstable ADMX behavior.

---

## Download

1. Go to [Releases](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/latest)
2. Download `Brave-Omega-Project.zip` from latest release
3. Extract to desired location (e.g., `C:\Users\Downloads\Brave-Omega`)

```powershell
# Example: Extract to Downloads
Expand-Archive -Path ".\Brave-Omega-Project.zip" -DestinationPath "C:\Users\Downloads\Brave-Omega"
```

---

## Installation Steps

### 1. Open PowerShell as Administrator
- Press `Win` â†’ type `PowerShell`
- Right-click **Windows PowerShell** â†’ **Run as Administrator**

### 2. Navigate to Project Folder
```powershell
cd "C:\Users\Downloads\Brave-Omega"
```
> Adjust path to your extraction location.

### 3. Run the Script
```powershell
# Turkish interface
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"

# English interface
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1"
```

> The `-ExecutionPolicy Bypass` flag applies **only to this single command** â€” no permanent execution policy change.

### 4. Follow On-Screen Prompts
- Script detects running Brave â†’ prompts continue/cancel
- Creates timestamped `.reg` backup of HKLM policy hive
- Displays level selection menu (1-4) and applies policies based on selected level (13/30/49/68)
- Shows per-category success/failure summary

### 5. Restart Brave
- Close **all** Brave windows completely
- Reopen Brave

### 6. Verify
Navigate to `brave://policy` â€” all Essential level policies (30) should show **Active**.

---

## Execution Policy Explained

| Method | Persistence | Scope | Security |
|--------|-------------|-------|----------|
| `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` | Permanent | User-wide | âŒ Creates attack surface |
| `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` | Session only | Current process | âœ… Better |
| **`PowerShell -ExecutionPolicy Bypass -File ...`** *(used)* | **Single command** | **Child process only** | âœ… **Best â€” no persistence** |

> **Brave Omega v2.1.6.0 uses the safest method:** `-ExecutionPolicy Bypass` as a launch flag â€” applies only to the child process, no registry changes, no attack surface.

---

## Verification

### 1. Check `brave://policy`
- Open `brave://policy` in Brave
- All Essential level policies (30) should show **Active** (green âœ…)

### 2. Check Registry (Optional)
```powershell
# Tier 1 (HKCU)
Get-ItemProperty "HKCU:\Software\BraveSoftware\Brave-Browser"

# Tier 2 (HKLM)
Get-ItemProperty "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

# Tier 3 (Omaha GUID)
Get-ItemProperty "HKCU:\Software\BraveSoftware\Update\ClientState\*"
```

### 3. Check Backup File
Backup file created: `BraveOmega_HKLM_YYYYMMDD_HHMMSS.reg` in script directory.

---

## Rollback / Uninstall

### Via Backup File
```powershell
reg import "BraveOmega_HKLM_20260613_120000.reg"
```

### Manual Removal
```powershell
# Remove HKLM policies
Remove-Item "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Recurse -Force

# Remove HKCU user preferences
Remove-Item "HKCU:\Software\BraveSoftware\Brave-Browser" -Recurse -Force

# Remove Omaha usagestats
Get-Item "HKCU:\Software\BraveSoftware\Update\ClientState\*" | ForEach-Object {
    Set-ItemProperty $_.PSPath -Name "usagestats" -Value 1
}
```

> ğŸ’¡ Tip: Use the `-Reset` parameter for automated clean removal:
> ```powershell
> PowerShell -ExecutionPolicy Bypass -File .\BraveOmega-TR.ps1 -Reset
> ```

---

## Common Installation Issues

| Issue | Cause | Resolution |
|-------|-------|------------|
| "CRITICAL ERROR" on launch | Not running as Admin | Right-click PowerShell â†’ **Run as Administrator** |
| Script fails with `[ERROR]` | HKLM permission issue | Confirm Administrator mode; re-run |
| `brave://policy` shows no policies | Brave not restarted | Close **all** Brave windows and reopen |
| "Unknown" policy in `brave://policy` | Version mismatch | Verify Brave version matches [Compatibility Matrix](Version-Compatibility-Matrix) |
| `reg export` fails | Restricted HKLM ACL | Run `regedit` â†’ inspect path â†’ check ACL entries |

---

## File Structure After Extraction

```
BRAVE OMEGA PROJECT/
â”‚
â”œâ”€â”€ .gitignore                        # Git exclusion rules
â”œâ”€â”€ .gitattributes
â”œâ”€â”€ LICENSE                           MIT
â”œâ”€â”€ README.md                         Documentation (EN + TR)
â”œâ”€â”€ CHANGELOG.md                      Changelog
â”œâ”€â”€ CONTRIBUTING.md                   Contributing guide (EN + TR)
â”œâ”€â”€ SECURITY.md                       Security policy (EN + TR)
â”œâ”€â”€ index.html                        Landing page (GitHub Pages)
â”œâ”€â”€ .github/
â”‚   â”œâ”€â”€ ISSUE_TEMPLATE/
â”‚   â”‚   â”œâ”€â”€ bug_report.yaml           Bug report template
â”‚   â”‚   â””â”€â”€ feature_request.yaml      Feature request template
â”‚   â””â”€â”€ workflows/
â”‚       â”œâ”€â”€ admx-validate.ps1         ADMX validation script
â”‚       â””â”€â”€ admx-validate.yml         ADMX validation pipeline
â””â”€â”€ Brave Omega/
        BraveOmega-EN.ps1             Main script â€” English interface
        BraveOmega-TR.ps1             Main script â€” Turkish interface
â””â”€â”€ Tests/                         Pester test suite (16 files)
            BraveOmega.EN.Tests.ps1        Unit + integration tests (EN)
            BraveOmega.TR.Tests.ps1        Unit + integration tests (TR)
            â””â”€â”€ *.Tests.ps1                  Phased policy tests (13 files)
```

---

## Related Pages

- [ğŸš€ Quick Start](Quick-Start) â€” One-line execution
- [ğŸ—ï¸ Architecture](Architecture) â€” Three-tier model
- [ğŸ“‹ Policy Reference](Policy-Reference) â€” Complete policy table
- [ğŸ›¡ï¸ Security](Security) â€” Safety model
- [ğŸ” Troubleshooting](Troubleshooting) â€” Common issues

---

---

<a id="-tÃ¼rkÃ§e"></a>

# ğŸ”§ Kurulum â€” Tam Kurulum KÄ±lavuzu

Brave Omega v2.1.6.0 iÃ§in tam kurulum kÄ±lavuzu (AÅŸama 3: Kalite & Test).

---

## Sistem Gereksinimleri

| Gereksinim | Minimum | Ã–nerilen |
|------------|---------|----------|
| **Ä°ÅŸletim Sistemi** | Windows 11 | Windows 11 25H2 (en gÃ¼ncel kararlÄ±) |
| **Brave Browser** | 1.91.x | En gÃ¼ncel kararlÄ± ([brave.com/download](https://brave.com/download)) |
| **PowerShell** | 5.1 | 5.1+ (Windows 11 ile birlikte gelir) |
| **AyrÄ±calÄ±k** | YÃ¶netici | YÃ¶netici |
| **Disk AlanÄ±** | 1 MB | 5 MB (yedekler iÃ§in) |

---

## Kurulum Ã–ncesi Kontrol Listesi

- [ ] Windows 11 yÃ¼klÃ¼ ve gÃ¼ncel
- [ ] Brave Browser **en gÃ¼ncel kararlÄ±** sÃ¼rÃ¼mÃ¼ yÃ¼klÃ¼ ([brave.com/download](https://brave.com/download))
- [ ] Brave sÃ¼rÃ¼mÃ¼ [brave.com/latest](https://brave.com/latest) adresinde doÄŸrulandÄ±
- [ ] SÃ¼rÃ¼m, [Uyumluluk Matrisi](Version-Compatibility-Matrix#-tÃ¼rkÃ§e) ile eÅŸleÅŸiyor
- [ ] YÃ¶netici hesabÄ± mevcut

> âš ï¸ **Kritik:** Her zaman **en gÃ¼ncel kararlÄ± Brave sÃ¼rÃ¼mÃ¼ne** karÅŸÄ± Ã§alÄ±ÅŸtÄ±rÄ±n. Beta/Nightly derlemeleri kararsÄ±z ADMX davranÄ±ÅŸÄ±na sahip olabilir.

---

## Ä°ndirme

1. [SÃ¼rÃ¼mlere](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/latest) gidin
2. En son sÃ¼rÃ¼mden `Brave-Omega-Project.zip` dosyasÄ±nÄ± indirin
3. Ä°stediÄŸiniz konuma Ã§Ä±karÄ±n (Ã¶r. `C:\Users\Downloads\Brave-Omega`)

```powershell
# Ã–rnek: Ä°ndirilenler klasÃ¶rÃ¼ne Ã§Ä±karma
Expand-Archive -Path ".\Brave-Omega-Project.zip" -DestinationPath "C:\Users\Downloads\Brave-Omega"
```

---

## Kurulum AdÄ±mlarÄ±

### 1. PowerShell'i YÃ¶netici Olarak AÃ§
- `Win` tuÅŸuna bas â†’ `PowerShell` yaz
- **Windows PowerShell**'e saÄŸ tÄ±kla â†’ **YÃ¶netici olarak Ã§alÄ±ÅŸtÄ±r**

### 2. Proje KlasÃ¶rÃ¼ne Git
```powershell
cd "C:\Users\Downloads\Brave-Omega"
```
> Ã‡Ä±karma konumunuza gÃ¶re yolu ayarlayÄ±n.

### 3. BetiÄŸi Ã‡alÄ±ÅŸtÄ±r
```powershell
# TÃ¼rkÃ§e arayÃ¼z
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"

# Ä°ngilizce arayÃ¼z
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1"
```

> `-ExecutionPolicy Bypass` bayraÄŸÄ± **yalnÄ±zca bu tek komut iÃ§in** geÃ§erlidir â€” kalÄ±cÄ± Ã§alÄ±ÅŸtÄ±rma ilkesi deÄŸiÅŸikliÄŸi yok.

### 4. Ekran Ä°stemlerini Takip Et
- Betik Ã§alÄ±ÅŸan Brave'i tespit eder â†’ devam/iptal istemi gÃ¶sterir
- HKLM politika kovasÄ±nÄ±n zaman damgalÄ± `.reg` yedeÄŸini oluÅŸturur
- Seviye seÃ§im menÃ¼sÃ¼nÃ¼ gÃ¶sterir (1-4) ve seÃ§ilen seviyeye gÃ¶re politikalarÄ± uygular (13/30/49/68)
- Kategori bazÄ±nda baÅŸarÄ±/hata Ã¶zetini gÃ¶sterir

### 5. Brave'i Yeniden BaÅŸlat
- **TÃ¼m** Brave pencerelerini tamamen kapat
- Brave'i yeniden aÃ§

### 6. DoÄŸrula
`brave://policy` adresine git â€” 30 Temel seviye politikanÄ±n tÃ¼mÃ¼ **Etkin** gÃ¶rÃ¼nmelidir.

---

## Ã‡alÄ±ÅŸtÄ±rma Ä°lkesi AÃ§Ä±klamasÄ±

| YÃ¶ntem | KalÄ±cÄ±lÄ±k | Kapsam | GÃ¼venlik |
|--------|-----------|--------|----------|
| `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` | KalÄ±cÄ± | KullanÄ±cÄ± genelinde | âŒ SaldÄ±rÄ± yÃ¼zeyi oluÅŸturur |
| `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` | YalnÄ±zca oturum | GeÃ§erli iÅŸlem | âœ… Daha iyi |
| **`PowerShell -ExecutionPolicy Bypass -File ...`** *(kullanÄ±lan)* | **Tek komut** | **YalnÄ±zca alt iÅŸlem** | âœ… **En iyi â€” kalÄ±cÄ±lÄ±k yok** |

> **Brave Omega v2.1.6.0 en gÃ¼venli yÃ¶ntemi kullanÄ±r:** `-ExecutionPolicy Bypass` baÅŸlatma bayraÄŸÄ± olarak â€” yalnÄ±zca alt iÅŸlem iÃ§in geÃ§erlidir, kayÄ±t defteri deÄŸiÅŸikliÄŸi yok, saldÄ±rÄ± yÃ¼zeyi yok.

---

## DoÄŸrulama

### 1. `brave://policy` Kontrol Et
- Brave'de `brave://policy` adresini aÃ§
- 30 Temel seviye politikanÄ±n tÃ¼mÃ¼ **Etkin** (yeÅŸil âœ…) gÃ¶rÃ¼nmeli

### 2. KayÄ±t Defterini Kontrol Et (Ä°steÄŸe BaÄŸlÄ±)
```powershell
# Katman 1 (HKCU)
Get-ItemProperty "HKCU:\Software\BraveSoftware\Brave-Browser"

# Katman 2 (HKLM)
Get-ItemProperty "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

# Katman 3 (Omaha GUID)
Get-ItemProperty "HKCU:\Software\BraveSoftware\Update\ClientState\*"
```

### 3. Yedek DosyasÄ±nÄ± Kontrol Et
Yedek dosyasÄ± oluÅŸturuldu: `BraveOmega_HKLM_YYYYMMDD_HHMMSS.reg` betik dizininde.

---

## Geri Alma / KaldÄ±rma

### Yedek DosyasÄ± ile
```powershell
reg import "BraveOmega_HKLM_20260613_120000.reg"
```

### Manuel KaldÄ±rma
```powershell
# HKLM politikalarÄ±nÄ± kaldÄ±r
Remove-Item "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Recurse -Force

# HKCU kullanÄ±cÄ± tercihlerini kaldÄ±r
Remove-Item "HKCU:\Software\BraveSoftware\Brave-Browser" -Recurse -Force

# Omaha usagestats'i sÄ±fÄ±rla
Get-Item "HKCU:\Software\BraveSoftware\Update\ClientState\*" | ForEach-Object {
    Set-ItemProperty $_.PSPath -Name "usagestats" -Value 1
}
```

> ğŸ’¡ Ä°pucu: Otomatik temiz kaldÄ±rma iÃ§in `-Reset` parametresini kullanÄ±n:
> ```powershell
> PowerShell -ExecutionPolicy Bypass -File .\BraveOmega-TR.ps1 -Reset
> ```

---

## SÄ±k KarÅŸÄ±laÅŸÄ±lan Kurulum SorunlarÄ±

| Sorun | Neden | Ã‡Ã¶zÃ¼m |
|-------|-------|-------|
| BaÅŸlatmada "KRÄ°TÄ°K HATA" | YÃ¶netici olarak Ã§alÄ±ÅŸmÄ±yor | PowerShell'e saÄŸ tÄ±kla â†’ **YÃ¶netici olarak Ã§alÄ±ÅŸtÄ±r** |
| Betik `[HATA]` ile baÅŸarÄ±sÄ±z | HKLM izin sorunu | YÃ¶netici modunu doÄŸrula; yeniden Ã§alÄ±ÅŸtÄ±r |
| `brave://policy` politika gÃ¶stermiyor | Brave yeniden baÅŸlatÄ±lmadÄ± | **TÃ¼m** Brave pencerelerini kapat ve yeniden aÃ§ |
| `brave://policy`'de "Bilinmiyor" politikasÄ± | SÃ¼rÃ¼m uyuÅŸmazlÄ±ÄŸÄ± | Brave sÃ¼rÃ¼mÃ¼nÃ¼n [Uyumluluk Matrisi](Version-Compatibility-Matrix#-tÃ¼rkÃ§e) ile eÅŸleÅŸtiÄŸini doÄŸrula |
| `reg export` baÅŸarÄ±sÄ±z | KÄ±sÄ±tlÄ± HKLM ACL | `regedit` Ã§alÄ±ÅŸtÄ±r â†’ yolu incele â†’ ACL girdilerini kontrol et |

---

## Ã‡Ä±karma SonrasÄ± Dosya YapÄ±sÄ±

```
BRAVE OMEGA PROJECT/
â”‚
â”œâ”€â”€ .gitignore                        # Git dÄ±ÅŸlama kurallarÄ±
â”œâ”€â”€ .gitattributes
â”œâ”€â”€ LICENSE                           MIT
â”œâ”€â”€ README.md                         Belgelendirme (EN + TR)
â”œâ”€â”€ CHANGELOG.md                      DeÄŸiÅŸiklik gÃ¼nlÃ¼ÄŸÃ¼
â”œâ”€â”€ CONTRIBUTING.md                   KatkÄ± rehberi (EN + TR)
â”œâ”€â”€ SECURITY.md                       GÃ¼venlik politikasÄ± (EN + TR)
â”œâ”€â”€ index.html                        AÃ§Ä±lÄ±ÅŸ sayfasÄ± (GitHub Pages)
â”œâ”€â”€ .github/
â”‚   â”œâ”€â”€ ISSUE_TEMPLATE/
â”‚   â”‚   â”œâ”€â”€ bug_report.yaml           Hata raporu ÅŸablonu
â”‚   â”‚   â””â”€â”€ feature_request.yaml      Ã–zellik talebi ÅŸablonu
â”‚   â””â”€â”€ workflows/
â”‚       â”œâ”€â”€ admx-validate.ps1         ADMX doÄŸrulama betiÄŸi
â”‚       â””â”€â”€ admx-validate.yml         ADMX doÄŸrulama hattÄ±
â””â”€â”€ Brave Omega/
        BraveOmega-EN.ps1             Ana betik â€” Ä°ngilizce arayÃ¼z
        BraveOmega-TR.ps1             Ana betik â€” TÃ¼rkÃ§e arayÃ¼z
```

---

## Ä°lgili Sayfalar

- [ğŸš€ HÄ±zlÄ± BaÅŸlangÄ±Ã§](Quick-Start#-tÃ¼rkÃ§e) â€” Tek satÄ±rda Ã§alÄ±ÅŸtÄ±rma
- [ğŸ—ï¸ Mimari](Architecture#-tÃ¼rkÃ§e) â€” ÃœÃ§ katmanlÄ± model
- [ğŸ“‹ Politika BaÅŸvurusu](Policy-Reference#-tÃ¼rkÃ§e) â€” Tam politika tablosu
- [ğŸ›¡ï¸ GÃ¼venlik](Security#-tÃ¼rkÃ§e) â€” GÃ¼venlik modeli
- [ğŸ” Sorun Giderme](Troubleshooting#-tÃ¼rkÃ§e) â€” SÄ±k karÅŸÄ±laÅŸÄ±lan sorunlar
