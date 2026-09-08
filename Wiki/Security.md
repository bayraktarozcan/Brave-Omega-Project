> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;Â·&nbsp; [TR TÃ¼rkÃ§e](#-tÃ¼rkÃ§e)

<a id="-english"></a>

# ğŸ›¡ï¸ Security â€” Safety Model & Threat Analysis

Brave Omega is designed with a **security-first** approach. Every design decision prioritizes user safety, transparency, and auditability.

---

## Security Principles

| Principle | Implementation |
| ----------- | ---------------- |
| **Zero Obfuscation** | 100% readable PowerShell source â€” no encoding, no compression, no hidden logic |
| **Zero Network Calls** | Script makes **zero outbound network connections** â€” fully offline operation |
| **Zero Executables** | Pure PowerShell â€” no binaries, no DLLs, no external dependencies |
| **Least Privilege** | Only requests Administrator for HKLM writes; HKCU/Omaha need no elevation |
| **Auditability** | Every registry change traceable to official ADMX/Chromium documentation |

---

## Threat Model

| Threat | Mitigation |
| -------- | ------------ |
| **Malicious script modification** | Full source on GitHub â€” verify checksums before running |
| **Supply chain compromise** | No external dependencies; no package manager; no binary blobs |
| **Registry corruption** | Automatic `.reg` backup before any HKLM writes; one-command rollback |
| **Partial application** | Per-operation try/catch with individual success/failure counters |
| **Brave data loss** | Process guard detects running Brave, prompts continue/cancel |
| **Privilege escalation** | Script only requests Admin for HKLM; HKCU/Omaha need no elevation |
| **Stale policy application** | Version pinning + Brave version check at runtime |

---

## Security Controls

### 1. Pre-Flight Checks

```
â”œâ”€ Administrator privilege verification
â”œâ”€ Brave process detection (with continue/cancel prompt)
â”œâ”€ Brave version validation against Compatibility Matrix
â”œâ”€ Brave version detection (compares against validated version 1.94.121)
â””â”€ Registry path ACL validation
```

### 2. Backup Before Write

- **Automatic** timestamped `.reg` export of `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave`
- Filename: `BraveOmega_HKLM_YYYYMMDD_HHMMSS.reg`
- Stored in script directory for easy rollback

### 3. Idempotent Application

- **`-Force` parameter** enables safe re-execution
- Per-policy try/catch with individual success/failure tracking
- Running multiple times = **identical result**, no duplicate entries

### 4. Rollback Capability

```powershell
# One-command restoration
reg import "BraveOmega_HKLM_20260613_120000.reg"
```

- Backup includes full HKLM policy hive state
- Restore is atomic and complete

### 5. Execution Policy Safety (v1.2.2+)

```powershell
# Single-command bypass â€” no persistence
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1"
```

- **No `Set-ExecutionPolicy` call** â€” no permanent registry changes
- Bypass applies **only to child process** â€” parent shell unaffected
- No attack surface exposure, no residual policy changes

### 6. Preview Mode (-WhatIf)

```powershell
# Preview all changes without writing
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -WhatIf
```

- No registry writes occur in WhatIf mode
- All operations are guarded by if (-not $WhatIf)
- Backup and directory creation are entirely skipped
- Magenta [WhatIf] tags indicate what would change

### 7. Clean Uninstall (-Reset)

```powershell
# Remove all Brave Omega policies
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Reset
```

- Removes all 151 policies from HKLM, HKCU, and Omaha GUIDs
- Cleans up empty registry keys automatically
- Respects -WhatIf silently

---

## Execution Policy Comparison

| Method | Persistence | Scope | Attack Surface | Used? |
| -------- | ------------- | ------- | ---------------- | ------- |
| `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` | Permanent | User-wide | âŒ High | âŒ No |
| `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` | Session | Current process | âš ï¸ Medium | âŒ No |
| **`PowerShell -ExecutionPolicy Bypass -File ...`** | **Single command** | **Child process only** | âœ… **None** | âœ… **Yes** |

---

## Backup & Rollback Details

### Backup File Format

```
Filename: BraveOmega_HKLM_YYYYMMDD_HHMMSS.reg
Location: Script execution directory
Format: Standard Windows REGEDIT4 format
Content: Full HKLM:\SOFTWARE\Policies\BraveSoftware\Brave hive
```

### Rollback Procedure

```powershell
# 1. Close Brave
# 2. Import backup
reg import "BraveOmega_HKLM_20260613_120000.reg"
# 3. Restart Brave
```

### Manual Rollback (if backup lost)

```powershell
# Remove HKLM policies
Remove-Item "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Recurse -Force

# Remove HKCU user preferences
Remove-Item "HKCU:\Software\BraveSoftware\Brave-Browser" -Recurse -Force

# Reset Omaha usagestats
Get-Item "HKCU:\Software\BraveSoftware\Update\ClientState\*" | ForEach-Object {
    Set-ItemProperty $_.PSPath -Name "usagestats" -Value 1
}
```

---

## Verification Checklist

Before running, verify:

- [ ] Script downloaded from official GitHub release
- [ ] SHA256 checksum matches release notes (if provided)
- [ ] Running on Windows 11 with latest updates
- [ ] Brave Browser **latest stable** installed
- [ ] Brave version matches [Compatibility Matrix](Version-Compatibility-Matrix)
- [ ] Running PowerShell as Administrator
- [ ] No critical applications running that might conflict

---

## Post-Execution Verification

| Check | Method |
| ------- | -------- |
| All policies active | `brave://policy` â†’ policies show **Active** (51 for Essential level) |
| Registry written | `Get-ItemProperty HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` |
| Backup created | `BraveOmega_HKLM_*.reg` exists in script directory |
| No errors in output | Script exits with code 0, no `[ERROR]` lines |

---

## Incident Response

If unexpected behavior occurs:

1. **Immediate:** Close Brave, import backup via `reg import`
2. **Investigate:** Review script output for `[ERROR]` lines
3. **Report:** Open GitHub issue with:
   - Brave version (`brave://version`)
   - Windows version (`winver`)
   - Full script output
   - `brave://policy` page export
4. **Rollback:** Use backup or manual removal procedure

---

## Related Pages

- [ğŸ”§ Installation](Installation) â€” Safe execution procedure
- [ğŸ—ï¸ Architecture](Architecture) â€” Three-tier model
- [ğŸ“‹ Policy Reference](Policy-Reference) â€” What policies are applied
- [ğŸ” Troubleshooting](Troubleshooting) â€” Common issues
- [ğŸ—ºï¸ Roadmap](Roadmap) â€” Planned security enhancements

---

## Test Security Notes (Phase 3)

The Pester test suite at `Tests/` follows the same security model:

| Principle | Implementation |
| ----------- | ---------------- |
| **No live registry writes** | Tests use mock paths or `-WhatIf` mode â€” no HKLM/HKCU modification |
| **No network calls** | Tests are fully offline â€” no internet dependency |
| **Isolation** | Each test file is self-contained; no cross-file state |
| **Inspectable** | 100% readable Pester code â€” no hidden test logic |
| **Admin not required** | Unit tests run without elevation; integration tests skip if not admin |

> ğŸ§ª Run `Invoke-Pester -Path .\Tests\` to validate the suite before any PR.

---

---

<a id="-tÃ¼rkÃ§e"></a>

# ğŸ›¡ï¸ GÃ¼venlik â€” GÃ¼venlik Modeli ve Tehdit Analizi

Brave Omega **gÃ¼venlik Ã¶ncelikli** bir yaklaÅŸÄ±mla tasarlanmÄ±ÅŸtÄ±r. Her tasarÄ±m kararÄ± kullanÄ±cÄ± gÃ¼venliÄŸini, ÅŸeffaflÄ±ÄŸÄ± ve denetlenebilirliÄŸi Ã¶nceliklendirir.

---

## GÃ¼venlik Ä°lkeleri

| Ä°lke | Uygulama |
| ------ | ---------- |
| **SÄ±fÄ±r Gizleme** | %100 okunabilir PowerShell kaynaÄŸÄ± â€” kodlama, sÄ±kÄ±ÅŸtÄ±rma veya gizli mantÄ±k yok |
| **SÄ±fÄ±r AÄŸ Ã‡aÄŸrÄ±sÄ±** | Betik **sÄ±fÄ±r giden aÄŸ baÄŸlantÄ±sÄ±** yapar â€” tamamen Ã§evrimdÄ±ÅŸÄ± Ã§alÄ±ÅŸma |
| **SÄ±fÄ±r Ã‡alÄ±ÅŸtÄ±rÄ±labilir** | Saf PowerShell â€” ikili dosya, DLL veya harici baÄŸÄ±mlÄ±lÄ±k yok |
| **En Az AyrÄ±calÄ±k** | YalnÄ±zca HKLM yazmalarÄ± iÃ§in YÃ¶netici ister; HKCU/Omaha yÃ¼kseltme gerektirmez |
| **Denetlenebilirlik** | Her kayÄ±t defteri deÄŸiÅŸikliÄŸi resmÃ® ADMX/Chromium belgelendirmesine izlenebilir |

---

## Tehdit Modeli

| Tehdit | Ã–nlem |
| -------- | ------- |
| **KÃ¶tÃ¼ amaÃ§lÄ± betik deÄŸiÅŸikliÄŸi** | GitHub'da tam kaynak â€” Ã§alÄ±ÅŸtÄ±rmadan Ã¶nce saÄŸlama toplamlarÄ±nÄ± doÄŸrulayÄ±n |
| **Tedarik zinciri ihlali** | Harici baÄŸÄ±mlÄ±lÄ±k yok; paket yÃ¶neticisi yok; ikili dosya yok |
| **KayÄ±t defteri bozulmasÄ±** | HKLM yazmalarÄ±ndan Ã¶nce otomatik `.reg` yedeÄŸi; tek komutla geri alma |
| **KÄ±smi uygulama** | Ä°ÅŸlem baÅŸÄ±na try/catch ile bireysel baÅŸarÄ±/hata sayaÃ§larÄ± |
| **Brave veri kaybÄ±** | SÃ¼reÃ§ koruyucusu Ã§alÄ±ÅŸan Brave'i tespit eder, devam/iptal istemi gÃ¶sterir |
| **AyrÄ±calÄ±k yÃ¼kseltme** | Betik yalnÄ±zca HKLM iÃ§in YÃ¶netici ister; HKCU/Omaha yÃ¼kseltme gerektirmez |
| **GÃ¼ncel olmayan politika uygulamasÄ±** | SÃ¼rÃ¼m sabitleme + Ã§alÄ±ÅŸma zamanÄ±nda Brave sÃ¼rÃ¼mÃ¼ kontrolÃ¼ |

---

## GÃ¼venlik Kontrolleri

### 1. Ã–n UÃ§uÅŸ Kontrolleri

```
â”œâ”€ YÃ¶netici ayrÄ±calÄ±ÄŸÄ± doÄŸrulamasÄ±
â”œâ”€ Brave sÃ¼reÃ§ tespiti (devam/iptal istemiyle)
â”œâ”€ Brave sÃ¼rÃ¼mÃ¼nÃ¼n Uyumluluk Matrisine karÅŸÄ± doÄŸrulamasÄ±
â”œâ”€ Brave sÃ¼rÃ¼m algÄ±lama (doÄŸrulanmÄ±ÅŸ sÃ¼rÃ¼m 1.94.121 ile karÅŸÄ±laÅŸtÄ±rma)
â””â”€ KayÄ±t defteri yolu ACL doÄŸrulamasÄ±
```

### 2. Yazmadan Ã–nce Yedekleme

- **Otomatik** zaman damgalÄ± `.reg` dÄ±ÅŸa aktarÄ±mÄ±: `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave`
- Dosya adÄ±: `BraveOmega_HKLM_YYYYMMDD_HHMMSS.reg`
- Kolay geri alma iÃ§in betik dizininde saklanÄ±r

### 3. KararsÄ±z Olmayan Uygulama

- **`-Force` parametresi** gÃ¼venli yeniden Ã§alÄ±ÅŸtÄ±rmayÄ± saÄŸlar
- Politika baÅŸÄ±na try/catch ile bireysel baÅŸarÄ±/hata takibi
- Birden fazla Ã§alÄ±ÅŸtÄ±rma = **Ã¶zdeÅŸ sonuÃ§**, yinelenen kayÄ±t yok

### 4. Geri Alma YeteneÄŸi

```powershell
# Tek komutla eski duruma dÃ¶nÃ¼ÅŸ
reg import "BraveOmega_HKLM_20260613_120000.reg"
```

- Yedek, tam HKLM politika kovasÄ± durumunu iÃ§erir
- Geri yÃ¼kleme atomik ve eksiksizdir

### 5. Ã‡alÄ±ÅŸtÄ±rma Ä°lkesi GÃ¼venliÄŸi (v1.2.2+)

```powershell
# Tek komutla bypass â€” kalÄ±cÄ±lÄ±k yok
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1"
```

- **`Set-ExecutionPolicy` Ã§aÄŸrÄ±sÄ± yok** â€” kalÄ±cÄ± kayÄ±t defteri deÄŸiÅŸikliÄŸi yok
- Bypass **yalnÄ±zca alt iÅŸlem iÃ§in** geÃ§erlidir â€” Ã¼st kabuk etkilenmez
- SaldÄ±rÄ± yÃ¼zeyi maruziyeti yok, artÄ±k politika deÄŸiÅŸikliÄŸi yok

### 6. Ã–n Ä°zleme Kipi (-WhatIf)

```powershell
# TÃ¼m deÄŸiÅŸiklikleri yazmadan Ã¶nizle
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -WhatIf
```

- WhatIf kipinde kayÄ±t defterine yazma olmaz
- TÃ¼m iÅŸlemler if (-not $WhatIf) ile korunur
- Yedekleme ve dizin oluÅŸturma tamamen atlanÄ±r
- Macenta [WhatIf] etiketleri neyin deÄŸiÅŸeceÄŸini belirtir

### 7. Temiz KaldÄ±rma (-Reset)

```powershell
# TÃ¼m Brave Omega politikalarÄ±nÄ± kaldÄ±r
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Reset
```

- 151 politikanÄ±n tÃ¼mÃ¼nÃ¼ HKLM, HKCU ve Omaha GUID'lerinden kaldÄ±rÄ±r
- BoÅŸ kayÄ±t defteri anahtarlarÄ±nÄ± otomatik temizler
- -WhatIf'e sessizce saygÄ± duyar

---

## Ã‡alÄ±ÅŸtÄ±rma Ä°lkesi KarÅŸÄ±laÅŸtÄ±rmasÄ±

| YÃ¶ntem | KalÄ±cÄ±lÄ±k | Kapsam | SaldÄ±rÄ± YÃ¼zeyi | KullanÄ±ldÄ± mÄ±? |
| -------- | ----------- | -------- | ---------------- | ---------------- |
| `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` | KalÄ±cÄ± | KullanÄ±cÄ± genelinde | âŒ YÃ¼ksek | âŒ HayÄ±r |
| `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` | Oturum | GeÃ§erli iÅŸlem | âš ï¸ Orta | âŒ HayÄ±r |
| **`PowerShell -ExecutionPolicy Bypass -File ...`** | **Tek komut** | **YalnÄ±zca alt iÅŸlem** | âœ… **HiÃ§biri** | âœ… **Evet** |

---

## Yedekleme ve Geri Alma AyrÄ±ntÄ±larÄ±

### Yedek DosyasÄ± BiÃ§imi

```
Dosya adÄ±: BraveOmega_HKLM_YYYYMMDD_HHMMSS.reg
Konum: Betik Ã§alÄ±ÅŸtÄ±rma dizini
BiÃ§im: Standart Windows REGEDIT4 biÃ§imi
Ä°Ã§erik: Tam HKLM:\SOFTWARE\Policies\BraveSoftware\Brave kovasÄ±
```

### Geri Alma ProsedÃ¼rÃ¼

```powershell
# 1. Brave'i kapat
# 2. YedeÄŸi iÃ§e aktar
reg import "BraveOmega_HKLM_20260613_120000.reg"
# 3. Brave'i yeniden baÅŸlat
```

### Manuel Geri Alma (yedek kaybolursa)

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

---

## DoÄŸrulama Kontrol Listesi

Ã‡alÄ±ÅŸtÄ±rmadan Ã¶nce doÄŸrulayÄ±n:

- [ ] Betik resmÃ® GitHub sÃ¼rÃ¼mÃ¼nden indirildi
- [ ] SHA256 saÄŸlama toplamÄ± sÃ¼rÃ¼m notlarÄ±yla eÅŸleÅŸiyor (varsa)
- [ ] Windows 11'de en gÃ¼ncel gÃ¼ncellemelerle Ã§alÄ±ÅŸÄ±yor
- [ ] Brave Browser **en gÃ¼ncel kararlÄ±** sÃ¼rÃ¼mÃ¼ yÃ¼klÃ¼
- [ ] Brave sÃ¼rÃ¼mÃ¼ [Uyumluluk Matrisi](Version-Compatibility-Matrix#-tÃ¼rkÃ§e) ile eÅŸleÅŸiyor
- [ ] PowerShell YÃ¶netici olarak Ã§alÄ±ÅŸÄ±yor
- [ ] Ã‡akÄ±ÅŸabilecek kritik uygulamalar Ã§alÄ±ÅŸmÄ±yor

---

## Ã‡alÄ±ÅŸtÄ±rma SonrasÄ± DoÄŸrulama

| Kontrol | YÃ¶ntem |
| --------- | -------- |
| TÃ¼m politikalar etkin | `brave://policy` â†’ 151 politikanÄ±n tÃ¼mÃ¼ **Etkin** gÃ¶steriyor (KatÄ± seviye; Temel'de 51, Dengeli'de 83) |
| KayÄ±t defteri yazÄ±ldÄ± | `Get-ItemProperty HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` |
| Yedek oluÅŸturuldu | `BraveOmega_HKLM_*.reg` betik dizininde mevcut |
| Ã‡Ä±ktÄ±da hata yok | Betik kod 0 ile Ã§Ä±kÄ±yor, `[ERROR]` satÄ±rÄ± yok |

---

## Olay MÃ¼dahalesi

Beklenmeyen davranÄ±ÅŸ oluÅŸursa:

1. **Acil:** Brave'i kapat, `reg import` ile yedeÄŸi iÃ§e aktar
2. **Ä°ncele:** `[HATA]` satÄ±rlarÄ± iÃ§in betik Ã§Ä±ktÄ±sÄ±nÄ± gÃ¶zden geÃ§ir
3. **Raporla:** GitHub sorunu aÃ§:
   - Brave sÃ¼rÃ¼mÃ¼ (`brave://version`)
   - Windows sÃ¼rÃ¼mÃ¼ (`winver`)
   - Tam betik Ã§Ä±ktÄ±sÄ±
   - `brave://policy` sayfasÄ± dÄ±ÅŸa aktarÄ±mÄ±
4. **Geri al:** Yedek veya manuel kaldÄ±rma prosedÃ¼rÃ¼nÃ¼ kullan

---

## Ä°lgili Sayfalar

- [ğŸ”§ Kurulum](Installation#-tÃ¼rkÃ§e) â€” GÃ¼venli Ã§alÄ±ÅŸtÄ±rma prosedÃ¼rÃ¼
- [ğŸ—ï¸ Mimari](Architecture#-tÃ¼rkÃ§e) â€” ÃœÃ§ katmanlÄ± model
- [ğŸ“‹ Politika BaÅŸvurusu](Policy-Reference#-tÃ¼rkÃ§e) â€” Hangi politikalar uygulanÄ±r
- [ğŸ” Sorun Giderme](Troubleshooting#-tÃ¼rkÃ§e) â€” SÄ±k karÅŸÄ±laÅŸÄ±lan sorunlar
- [ğŸ—ºï¸ Yol HaritasÄ±](Roadmap#-tÃ¼rkÃ§e) â€” Planlanan gÃ¼venlik iyileÅŸtirmeleri
