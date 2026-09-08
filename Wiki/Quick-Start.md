> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;Â·&nbsp; [TR TÃ¼rkÃ§e](#-tÃ¼rkÃ§e)

<a id="-english"></a>

# ğŸš€ Quick Start â€” Brave Omega

> Get Brave Omega running in **3 minutes** with a single copy-paste command.

---

## Prerequisites

| Requirement | Detail |
| ------------- | -------- |
| **OS** | Windows 11 (latest stable 25H2 build recommended) |
| **Browser** | **Brave Browser â€” latest stable** ([brave.com/download](https://brave.com/download)) |
| **PowerShell** | 5.1+ (included with Windows 11) |
| **Privileges** | **Administrator** (required for HKLM registry writes) |
| **Execution Policy** | Handled automatically via `-ExecutionPolicy Bypass` flag |

> âš ï¸ **Always use the latest stable Brave release** before running. Verify at [brave.com/latest](https://brave.com/latest).

---

## One-Line Execution

The unified script asks for your language on first launch (`Press 1 for English / Türkçe için 2'ye basın`), or pin it up front:

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Language TR

PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Language EN
```

> The `-ExecutionPolicy Bypass` flag applies **only to this single command** â€” no permanent execution policy change, no attack surface exposure. Close the window and everything resets.

---

### Preview Mode (-WhatIf)

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -WhatIf
```

Shows what would change without writing to the registry.

### Clean Uninstall (-Reset)

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Reset
```

Removes all Brave Omega policies from HKLM, HKCU, and Omaha GUIDs.

---

## Selecting a Hardening Level

When you run the script without parameters, it shows an interactive menu:

```
1. Brave Only
2. Essential [Recommended]
3. Balanced
4. Advanced
5. Strict
Your selection (2):
```

To skip the menu in automated deployments:

```powershell
# Essential level (recommended)
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Level Essential

# (add -Language EN or -Language TR to skip the language question)
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Level Essential
```

Available levels: `BraveOnly`, `Essential`, `Balanced`, `Advanced`, `Strict` (EN) or `BraveYalniz`, `Temel`, `Dengeli`, `Gelismis`, `Kati` (TR).

---

## Step-by-Step (Expanded)

### 1. Open PowerShell as Administrator

- Press `Win` â†’ type `PowerShell`
- Right-click **Windows PowerShell** â†’ **Run as Administrator**

### 2. Navigate to Project Folder

```powershell
cd "C:\Users\Downloads\Brave-Omega"
```

> Adjust path if you extracted elsewhere.

### 3. Run the Script

```powershell
# Turkish
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1"

# (add -Language EN or -Language TR to skip the language question)
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1"
```

### 4. Restart Brave

- Close **all** Brave windows completely
- Reopen Brave

### 5. Verify

Navigate to `brave://policy` in Brave â€” all policies (51 for Essential level) should show as **Active**.

---

## What the Script Does

| Phase | Action |
| ------- | -------- |
| **1. Pre-flight** | Detects running Brave, prompts continue/cancel |
| **2. Backup** | Creates timestamped `.reg` backup of HKLM policy hive |
| **3. Apply** | Writes policies across 3 tiers based on selected level (24/51/83/123/151) |
| **4. Summary** | Per-category success/failure counters + rollback info |
| **5. Cleanup** | Exits cleanly â€” no residual processes |

---

## Rollback (If Needed)

```powershell
reg import "BraveOmega_HKLM_YYYYMMDD_HHMMSS.reg"
```

The backup file is named with timestamp (e.g., `BraveOmega_HKLM_20260613_120000.reg`).

---

## Common Issues

| Issue | Resolution |
| ------- | ------------ |
| "CRITICAL ERROR" on launch | Right-click PowerShell â†’ **Run as Administrator** |
| No policies in `brave://policy` | Close **all** Brave windows and reopen |
| `[ERROR]` in output | Confirm Administrator mode; re-run |
| "Unknown" policy in `brave://policy` | Verify Brave version matches [Compatibility Matrix](Version-Compatibility-Matrix) |

---

## Next Steps

- [ğŸ“– Full Installation Guide](Installation)
- [ğŸ—ï¸ Architecture Overview](Architecture)
- [ğŸ“‹ Policy Reference](Policy-Reference)
- [ğŸ›¡ï¸ Security Model](Security)

---

---

<a id="-tÃ¼rkÃ§e"></a>

# ğŸš€ HÄ±zlÄ± BaÅŸlangÄ±Ã§ â€” Brave Omega

> Brave Omega'yÄ± **3 dakikada** Ã§alÄ±ÅŸtÄ±rÄ±n, tek bir kopyala-yapÄ±ÅŸtÄ±r komutuyla.

---

## Ã–n Gereksinimler

| Gereksinim | AyrÄ±ntÄ± |
| ------------ | --------- |
| **Ä°ÅŸletim Sistemi** | Windows 11 (Ã¶nerilen: en gÃ¼ncel kararlÄ± 25H2 derlemesi) |
| **TarayÄ±cÄ±** | **Brave Browser â€” en gÃ¼ncel kararlÄ±** ([brave.com/download](https://brave.com/download)) |
| **PowerShell** | 5.1+ (Windows 11 ile birlikte gelir) |
| **AyrÄ±calÄ±k** | **YÃ¶netici** (HKLM kayÄ±t defteri yazmalarÄ± iÃ§in gerekli) |
| **Ã‡alÄ±ÅŸtÄ±rma Ä°lkesi** | `-ExecutionPolicy Bypass` bayraÄŸÄ± ile otomatik olarak yÃ¶netilir |

> âš ï¸ **Ã‡alÄ±ÅŸtÄ±rmadan Ã¶nce her zaman en gÃ¼ncel kararlÄ± Brave sÃ¼rÃ¼mÃ¼nÃ¼ kullanÄ±n.** [brave.com/latest](https://brave.com/latest) adresinden doÄŸrulayÄ±n.

---

## Tek SatÄ±rda Ã‡alÄ±ÅŸtÄ±rma

Birleşik betik ilk açılışta dilinizi sorar (`Press 1 for English / Türkçe için 2'ye basın`) veya önden sabitleyin:

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Language TR

PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Language EN
```

> `-ExecutionPolicy Bypass` bayraÄŸÄ± **yalnÄ±zca bu tek komut iÃ§in** geÃ§erlidir â€” kalÄ±cÄ± Ã§alÄ±ÅŸtÄ±rma ilkesi deÄŸiÅŸikliÄŸi yok, saldÄ±rÄ± yÃ¼zeyi maruziyeti yok. Pencereyi kapatÄ±n, her ÅŸey sÄ±fÄ±rlanÄ±r.

---

### Ã–n Ä°zleme Kipi (-WhatIf)

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -WhatIf
```

KayÄ±t defterine yazmadan nelerin deÄŸiÅŸeceÄŸini gÃ¶sterir.

### Temiz KaldÄ±rma (-Reset)

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Reset
```

TÃ¼m Brave Omega politikalarÄ±nÄ± HKLM, HKCU ve Omaha GUID'lerinden kaldÄ±rÄ±r.

---

## SÄ±kÄ±laÅŸtÄ±rma Seviyesi SeÃ§me

Betik parametresiz Ã§alÄ±ÅŸtÄ±rÄ±ldÄ±ÄŸÄ±nda etkileÅŸimli bir menÃ¼ gÃ¶sterir:

```
1. Brave YalnÄ±z
2. Temel [Ã–nerilen]
3. Dengeli
4. GeliÅŸmiÅŸ
5. KatÄ±
SeÃ§iminiz (2):
```

Otomatik daÄŸÄ±tÄ±mlarda menÃ¼yÃ¼ atlamak iÃ§in:

```powershell
# Temel seviye (Ã¶nerilen)
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Level Temel

# (dil sorusunu atlamak için -Language TR veya -Language EN ekleyin)
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Level Essential
```

KullanÄ±labilir seviyeler: `BraveOnly`/`BraveYalniz`, `Essential`/`Temel`, `Balanced`/`Dengeli`, `Advanced`/`Gelismis`, `Strict`/`Kati`.

---

## AdÄ±m AdÄ±m (GeniÅŸletilmiÅŸ)

### 1. PowerShell'i YÃ¶netici Olarak AÃ§

- `Win` tuÅŸuna bas â†’ `PowerShell` yaz
- **Windows PowerShell**'e saÄŸ tÄ±kla â†’ **YÃ¶netici olarak Ã§alÄ±ÅŸtÄ±r**

### 2. Proje KlasÃ¶rÃ¼ne Git

```powershell
cd "C:\Users\Downloads\Brave-Omega"
```

> FarklÄ± bir yere Ã§Ä±kardÄ±ysanÄ±z yolu buna gÃ¶re ayarlayÄ±n.

### 3. BetiÄŸi Ã‡alÄ±ÅŸtÄ±r

```powershell
# TÃ¼rkÃ§e
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1"

# (dil sorusunu atlamak için -Language TR veya -Language EN ekleyin)
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1"
```

### 4. Brave'i Yeniden BaÅŸlat

- **TÃ¼m** Brave pencerelerini tamamen kapat
- Brave'i yeniden aÃ§

### 5. DoÄŸrula

Brave'de `brave://policy` adresine git â€” tÃ¼m politikalar (Temel seviyede 51) **Etkin** olarak gÃ¶rÃ¼nmelidir.

---

## Betik Ne Yapar?

| AÅŸama | Eylem |
| ------- | ------- |
| **1. Ã–n Kontrol** | Ã‡alÄ±ÅŸan Brave'i tespit eder, devam/iptal istemi gÃ¶sterir |
| **2. Yedekleme** | HKLM politika kovasÄ±nÄ±n zaman damgalÄ± `.reg` yedeÄŸini oluÅŸturur |
| **3. Uygulama** | SeÃ§ilen seviyeye gÃ¶re 3 katmanda politikalarÄ± yazar (24/51/83/123/151) |
| **4. Ã–zet** | Kategori bazÄ±nda baÅŸarÄ±/hata sayaÃ§larÄ± + geri alma bilgisi |
| **5. Temizlik** | ArtÄ±k sÃ¼reÃ§ bÄ±rakmadan temiz Ã§Ä±kÄ±ÅŸ |

---

## Geri Alma (Gerekirse)

```powershell
reg import "BraveOmega_HKLM_YYYYMMDD_HHMMSS.reg"
```

Yedek dosyasÄ± zaman damgasÄ±yla adlandÄ±rÄ±lÄ±r (Ã¶r. `BraveOmega_HKLM_20260613_120000.reg`).

---

## SÄ±k KarÅŸÄ±laÅŸÄ±lan Sorunlar

| Sorun | Ã‡Ã¶zÃ¼m |
| ------- | ------- |
| BaÅŸlatmada "KRÄ°TÄ°K HATA" | PowerShell'e saÄŸ tÄ±kla â†’ **YÃ¶netici olarak Ã§alÄ±ÅŸtÄ±r** |
| `brave://policy`'de politika yok | **TÃ¼m** Brave pencerelerini kapat ve yeniden aÃ§ |
| Ã‡Ä±ktÄ±da `[HATA]` satÄ±rlarÄ± | YÃ¶netici modunu doÄŸrula; yeniden Ã§alÄ±ÅŸtÄ±r |
| `brave://policy`'de "Bilinmiyor" politikasÄ± | Brave sÃ¼rÃ¼mÃ¼nÃ¼n [Uyumluluk Matrisi](Version-Compatibility-Matrix#-tÃ¼rkÃ§e) ile eÅŸleÅŸtiÄŸini doÄŸrula |

---

## Sonraki AdÄ±mlar

- [ğŸ“– Tam Kurulum KÄ±lavuzu](Installation#-tÃ¼rkÃ§e)
- [ğŸ—ï¸ Mimari Genel BakÄ±ÅŸ](Architecture#-tÃ¼rkÃ§e)
- [ğŸ“‹ Politika BaÅŸvurusu](Policy-Reference#-tÃ¼rkÃ§e)
- [ğŸ›¡ï¸ GÃ¼venlik Modeli](Security#-tÃ¼rkÃ§e)
