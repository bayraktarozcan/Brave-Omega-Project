> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;Â·&nbsp; [TR TÃ¼rkÃ§e](#-tÃ¼rkÃ§e)

<a id="-english"></a>

# ğŸ—ï¸ Architecture â€” Multi-Tier Enforcement Model

Brave Omega uses a **three-tier enforcement model** that creates redundant, independent policy enforcement at each layer of the Windows + Brave + Omaha stack.

---

## Tier Overview

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚  TIER 1 â€” HKCU (User Preference Layer)                     â”‚
â”‚  HKCU:\Software\BraveSoftware\Brave-Browser                 â”‚
â”‚  â†³  UsageStatsInSample = 0                                  â”‚
â”‚     Chromium user-level telemetry sampling disabled.        â”‚
â”‚     Provides a fallback during policy propagation delays.   â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  TIER 2 â€” HKLM (Enterprise Policy Layer / ADMX)            â”‚
â”‚  HKLM:\SOFTWARE\Policies\BraveSoftware\Brave                â”‚
â”‚  â†³  ADMX-validated enterprise policies (level-based), enforced. â”‚
â”‚     Appear gray and locked in browser Settings UI.         â”‚
â”‚     Cannot be overridden by user interaction.              â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  TIER 3 â€” Omaha Updater GUID Layer                         â”‚
â”‚  HKCU:\Software\BraveSoftware\Update\ClientState\{GUID}     â”‚
â”‚  â†³  usagestats = 0 per application GUID                    â”‚
â”‚     Targets the update infrastructure's own telemetry,     â”‚
â”‚     independently of all browser-level policies.           â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

## Hardening Levels (v2.0+)

In addition to the three enforcement tiers, Brave Omega v2.0+ offers **five hardening levels** with cumulative inheritance. Each level includes all policies from the previous one:

| Level | Policies | Scope | User Impact |
| ------- | ---------- | ------- | ------------- |
| **1. Brave Only** | 24 Brave-specific policies | HKLM | None |
| **2. Essential** â­ | 24 + 27 = 51 | HKLM + HKCU + Omaha | None |
| **3. Balanced** | 51 + 32 = 83 | + WebRTC, HTTPS, DNS | Low |
| **4. Advanced** | 83 + 40 = 123 | + Sensors, Imports, Extensions, Profiles | Low |
| **5. Strict** | 123 + 28 = 151 | + JIT, Cookies, Clipboard, FS, DevTools | Medium |

Select your level interactively when running the script or use the `-Level` parameter:

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Level Essential
```

---

## Tier Details

### Tier 1 â€” HKCU (User Preference Layer)

- **Registry Path:** `HKCU:\Software\BraveSoftware\Brave-Browser`
- **Policy:** `UsageStatsInSample = 0`
- **Effect:** Disables browser-level usage statistics sampling sent to Brave servers
- **Role:** Fallback during policy propagation delays; user-level preference

### Tier 2 â€” HKLM (Enterprise Policy Layer / ADMX)

- **Registry Path:** `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave`
- **Policies:** ADMX-validated enterprise policies (level-based)
- **Behavior:** Appear **gray and locked** in browser Settings UI
- **Enforcement:** Cannot be overridden by user interaction
- **Scope:** Machine-wide, applies to all users

### Tier 3 â€” Omaha Updater GUID Layer

- **Registry Path:** `HKCU:\Software\BraveSoftware\Update\ClientState\{GUID}`
- **Policy:** `usagestats = 0` per application GUID
- **Effect:** Targets the update infrastructure's own telemetry independently
- **Independence:** Operates independently of all browser-level policies

---

## Policy Sources & Methodology

> **Core Principle: Zero unofficial or speculative registry changes.**

Every policy is traceable to one authoritative source:

| Source | Policies Covered |
| -------- | ----------------- |
| **Brave Official ADMX Template Package** (`policy_templates.zip`) | `BraveRewardsDisabled`, `BraveWalletDisabled`, `BraveVPNDisabled`, `BraveAIChatEnabled`, `BraveStatsPingEnabled` |
| **Chromium Enterprise Policy Documentation** | `MetricsReportingEnabled`, `SafeBrowsingExtendedReportingEnabled` |
| **Google Omaha Updater Architecture** | `usagestats` (per GUID, in HKCU update layer) |
| **Chromium Preferences Schema** | `UsageStatsInSample` (HKCU user preference) |

> **Note:** `BraveShieldsDefault` is intentionally excluded â€” it does not exist in Brave's official ADMX templates. Brave manages Shields via URL-based policies (`BraveShieldsEnabledForUrls`, `BraveShieldsDisabledForUrls`). Global aggressive mode is applied through user profile preferences (Preferences JSON), not through an enterprise registry policy.

---

## Why Three Tiers?

| Tier | Independence | Override Resistance | Propagation Speed |
| ------ | -------------- | --------------------- | ------------------- |
| HKCU (Tier 1) | User-level | Can be overridden by user | Immediate |
| HKLM ADMX (Tier 2) | Machine-level | **Cannot be overridden by user** | Group Policy refresh |
| Omaha GUID (Tier 3) | Update infra-level | Independent of browser | Update check cycle |

**Redundancy ensures:** If one tier fails or is delayed, others continue enforcing privacy protections.

**Hardening Levels (v2.0+):** The five levels above add additional granularity within Tier 2, letting you choose the number of ADMX policies to apply.

---

## Policy Application Flow

```
1. Pre-flight Checks
   â”œâ”€ Administrator privileges?
   â”œâ”€ Brave running? (prompt continue/cancel)
   â”œâ”€ Level selection (interactive or -Level parameter)
   â””â”€ Version compatibility check

2. Backup
   â””â”€ Export HKLM:\SOFTWARE\Policies\BraveSoftware\Brave â†’ timestamped .reg

3. Apply Policies (per tier)
   â”œâ”€ Tier 1: HKCU user preferences
   â”œâ”€ Tier 2: HKLM ADMX enterprise policies
   â””â”€ Tier 3: Omaha GUID usagestats = 0

4. Verification
   â”œâ”€ Per-policy success/failure counters
   â””â”€ Summary report with rollback instructions

5. Completion
   â””â”€ Exit code 0 on success, non-zero on failure
```

---

## Idempotency Guarantee

- **Idempotent writes** (`New-Item* -Force` internally) enable safe re-execution
- **`-WhatIf` parameter** previews changes without applying them
- **`-Reset` parameter** reverts all applied policies
- Running multiple times = **identical result**
- No duplicate registry entries, no conflicts
- Safe for automation / scheduled tasks

---

## Related Pages

- [ğŸ“‹ Policy Reference](Policy-Reference) â€” Complete policy registry table
- [ğŸ”§ Installation](Installation) â€” Prerequisites & step-by-step
- [ğŸ›¡ï¸ Security](Security) â€” Safety model & threat model
- [ğŸ” Troubleshooting](Troubleshooting) â€” Common issues

---

---

<a id="-tÃ¼rkÃ§e"></a>

# ğŸ—ï¸ Mimari â€” Ã‡ok KatmanlÄ± Zorunlu KÄ±lma Modeli

Brave Omega, Windows + Brave + Omaha yÄ±ÄŸÄ±nÄ±nÄ±n her katmanÄ±nda baÄŸÄ±msÄ±z politika zorunlu kÄ±lmasÄ± oluÅŸturan **Ã¼Ã§ katmanlÄ± bir model** kullanÄ±r.

---

## Katmanlara Genel BakÄ±ÅŸ

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚  KATMAN 1 â€” HKCU (KullanÄ±cÄ± Tercihi KatmanÄ±)              â”‚
â”‚  HKCU:\Software\BraveSoftware\Brave-Browser                 â”‚
â”‚  â†³  UsageStatsInSample = 0                                  â”‚
â”‚     Chromium kullanÄ±cÄ± dÃ¼zeyi veri aktarÄ±mÄ± kapatÄ±ldÄ±.     â”‚
â”‚     Politika yayÄ±lma gecikmelerinde yedek gÃ¼vence saÄŸlar.  â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  KATMAN 2 â€” HKLM (Kurumsal Ä°lke KatmanÄ± / ADMX)           â”‚
â”‚  HKLM:\SOFTWARE\Policies\BraveSoftware\Brave                â”‚
â”‚  â†³  ADMX doÄŸrulamalÄ± kurumsal ilke (seviye-tabanlÄ±), zorunlu kÄ±lÄ±ndÄ±.   â”‚
â”‚     TarayÄ±cÄ± Ayarlar arayÃ¼zÃ¼nde gri/kilitli gÃ¶rÃ¼nÃ¼r.      â”‚
â”‚     KullanÄ±cÄ± etkileÅŸimiyle deÄŸiÅŸtirilemez.               â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  KATMAN 3 â€” Omaha GÃ¼ncelleyici GUID KatmanÄ±               â”‚
â”‚  HKCU:\Software\BraveSoftware\Update\ClientState\{GUID}     â”‚
â”‚  â†³  Her uygulama GUID'i iÃ§in usagestats = 0               â”‚
â”‚     GÃ¼ncelleme altyapÄ±sÄ±nÄ±n kendi veri aktarÄ±mÄ±nÄ±,        â”‚
â”‚     tarayÄ±cÄ± dÃ¼zeyi ilkelerden baÄŸÄ±msÄ±z olarak kapatÄ±r.   â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

## SÄ±kÄ±laÅŸtÄ±rma Seviyeleri (v2.0+)

ÃœÃ§ zorunlu kÄ±lma katmanÄ±na ek olarak, Brave Omega v2.0+ **beÅŸ sÄ±kÄ±laÅŸtÄ±rma seviyesi** sunar. Her seviye bir Ã¶ncekinin tÃ¼m politikalarÄ±nÄ± kapsar:

| Seviye | Politika | Kapsam | KullanÄ±m Etkisi |
| -------- | ---------- | -------- | ----------------- |
| **1. Brave YalnÄ±z** | 24 Brave'e Ã¶zgÃ¼ politika | HKLM | Yok |
| **2. Temel** â­ | 24 + 27 = 51 | HKLM + HKCU + Omaha | Yok |
| **3. Dengeli** | 51 + 32 = 83 | + WebRTC, HTTPS, DNS | DÃ¼ÅŸÃ¼k |
| **4. GeliÅŸmiÅŸ** | 83 + 40 = 123 | + SensÃ¶rler, Ä°Ã§e Aktarmalar, UzantÄ±lar, Profiller | DÃ¼ÅŸÃ¼k |
| **5. KatÄ±** | 123 + 28 = 151 | + JIT, Ã‡erezler, Pano, FS, DevTools | Orta |

BetiÄŸi Ã§alÄ±ÅŸtÄ±rÄ±rken seviyenizi etkileÅŸimli olarak seÃ§in veya `-Level` parametresini kullanÄ±n:

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Level Temel
```

---

## Katman AyrÄ±ntÄ±larÄ±

### Katman 1 â€” HKCU (KullanÄ±cÄ± Tercihi KatmanÄ±)

- **KayÄ±t Defteri Yolu:** `HKCU:\Software\BraveSoftware\Brave-Browser`
- **Politika:** `UsageStatsInSample = 0`
- **Etki:** Brave sunucularÄ±na gÃ¶nderilen tarayÄ±cÄ± dÃ¼zeyi kullanÄ±m istatistiÄŸi Ã¶rneklemesini devre dÄ±ÅŸÄ± bÄ±rakÄ±r
- **Rol:** Politika yayÄ±lma gecikmelerinde yedek gÃ¼vence; kullanÄ±cÄ± dÃ¼zeyi tercih

### Katman 2 â€” HKLM (Kurumsal Ä°lke KatmanÄ± / ADMX)

- **KayÄ±t Defteri Yolu:** `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave`
- **Politikalar:** ADMX doÄŸrulamalÄ± kurumsal ilke (seviye-tabanlÄ±)
- **DavranÄ±ÅŸ:** TarayÄ±cÄ± Ayarlar arayÃ¼zÃ¼nde **gri ve kilitli** gÃ¶rÃ¼nÃ¼r
- **Zorunlu KÄ±lma:** KullanÄ±cÄ± etkileÅŸimiyle deÄŸiÅŸtirilemez
- **Kapsam:** Makine genelinde, tÃ¼m kullanÄ±cÄ±lar iÃ§in geÃ§erlidir

### Katman 3 â€” Omaha GÃ¼ncelleyici GUID KatmanÄ±

- **KayÄ±t Defteri Yolu:** `HKCU:\Software\BraveSoftware\Update\ClientState\{GUID}`
- **Politika:** Her uygulama GUID'i iÃ§in `usagestats = 0`
- **Etki:** GÃ¼ncelleme altyapÄ±sÄ±nÄ±n kendi veri aktarÄ±mÄ±nÄ± baÄŸÄ±msÄ±z olarak hedefler
- **BaÄŸÄ±msÄ±zlÄ±k:** TÃ¼m tarayÄ±cÄ± dÃ¼zeyi ilkelerden baÄŸÄ±msÄ±z Ã§alÄ±ÅŸÄ±r

---

## Politika KaynaklarÄ± ve YÃ¶ntem

> **Temel Ä°lke: SÄ±fÄ±r gayri resmÃ® veya spekÃ¼latif kayÄ±t defteri deÄŸiÅŸikliÄŸi.**

Her politika tek bir yetkili kaynaÄŸa izlenebilir:

| Kaynak | Kapsanan Politikalar |
| -------- | --------------------- |
| **Brave ResmÃ® ADMX Åablon Paketi** (`policy_templates.zip`) | `BraveRewardsDisabled`, `BraveWalletDisabled`, `BraveVPNDisabled`, `BraveAIChatEnabled`, `BraveStatsPingEnabled` |
| **Chromium Kurumsal Politika Belgelendirmesi** | `MetricsReportingEnabled`, `SafeBrowsingExtendedReportingEnabled` |
| **Google Omaha GÃ¼ncelleyici Mimarisi** | `usagestats` (GUID baÅŸÄ±na, HKCU gÃ¼ncelleme katmanÄ±nda) |
| **Chromium Tercihler ÅemasÄ±** | `UsageStatsInSample` (HKCU kullanÄ±cÄ± tercihi) |

> **Not:** `BraveShieldsDefault` kasÄ±tlÄ± olarak dÄ±ÅŸarÄ±da bÄ±rakÄ±ldÄ± â€” Brave'in resmÃ® ADMX ÅŸablonlarÄ±nda bulunmamaktadÄ±r. Brave, kalkanlarÄ± URL bazlÄ± politikalarla (`BraveShieldsEnabledForUrls`, `BraveShieldsDisabledForUrls`) yÃ¶netir. Genel saldÄ±rgan mod, kurumsal kayÄ±t defteri politikasÄ± deÄŸil; kullanÄ±cÄ± profil tercihleri (Preferences JSON) aracÄ±lÄ±ÄŸÄ±yla uygulanÄ±r.

---

## Neden ÃœÃ§ Katman?

| Katman | BaÄŸÄ±msÄ±zlÄ±k | GeÃ§ersiz KÄ±lmaya DirenÃ§ | YayÄ±lma HÄ±zÄ± |
| -------- | ------------- | ------------------------ | -------------- |
| HKCU (Katman 1) | KullanÄ±cÄ± dÃ¼zeyi | KullanÄ±cÄ± tarafÄ±ndan geÃ§ersiz kÄ±lÄ±nabilir | AnlÄ±k |
| HKLM ADMX (Katman 2) | Makine dÃ¼zeyi | **KullanÄ±cÄ± tarafÄ±ndan geÃ§ersiz kÄ±lÄ±namaz** | Grup Ä°lkesi yenileme |
| Omaha GUID (Katman 3) | GÃ¼ncelleme altyapÄ±sÄ± dÃ¼zeyi | TarayÄ±cÄ±dan baÄŸÄ±msÄ±z | GÃ¼ncelleme kontrol dÃ¶ngÃ¼sÃ¼ |

**Yedeklilik ÅŸunlarÄ± saÄŸlar:** Bir katman baÅŸarÄ±sÄ±z olursa veya gecikirse, diÄŸerleri gizlilik korumalarÄ±nÄ± uygulamaya devam eder.

**SÄ±kÄ±laÅŸtÄ±rma Seviyeleri (v2.0+):** YukarÄ±daki beÅŸ seviye, Katman 2'ye ek ayrÄ±ntÄ± dÃ¼zeyi ekleyerek kaÃ§ ADMX politikasÄ± uygulanacaÄŸÄ±nÄ± seÃ§menizi saÄŸlar.

---

## Politika Uygulama AkÄ±ÅŸÄ±

```
1. Ã–n Kontroller
   â”œâ”€ YÃ¶netici ayrÄ±calÄ±klarÄ±?
   â”œâ”€ Brave Ã§alÄ±ÅŸÄ±yor mu? (devam/iptal istemi)
   â”œâ”€ Seviye seÃ§imi (etkileÅŸimli veya -Level parametresi)
   â””â”€ SÃ¼rÃ¼m uyumluluk kontrolÃ¼

2. Yedekleme
   â””â”€ HKLM:\SOFTWARE\Policies\BraveSoftware\Brave â†’ zaman damgalÄ± .reg

3. PolitikalarÄ± Uygula (katman baÅŸÄ±na)
   â”œâ”€ Katman 1: HKCU kullanÄ±cÄ± tercihleri
   â”œâ”€ Katman 2: HKLM ADMX kurumsal ilkeler
   â””â”€ Katman 3: Omaha GUID usagestats = 0

4. DoÄŸrulama
   â”œâ”€ Politika baÅŸÄ±na baÅŸarÄ±/hata sayaÃ§larÄ±
   â””â”€ Geri alma talimatlarÄ±yla Ã¶zet rapor

5. Tamamlama
   â””â”€ BaÅŸarÄ±da Ã§Ä±kÄ±ÅŸ kodu 0, hatada sÄ±fÄ±r deÄŸil
```

---

## KararsÄ±z Olmama Garantisi

- **Idempotent yazmalar** (`New-Item* -Force` içeride) güvenli yeniden çalıştırmayı sağlar
- **`-WhatIf` parametresi** deÄŸiÅŸiklikleri uygulamadan Ã¶nizler
- **`-Reset` parametresi** uygulanan tÃ¼m politikalarÄ± geri alÄ±r
- rirden fazla Ã§alÄ±ÅŸtÄ±rma = **Ã¶zdeÅŸ sonuÃ§**
- Yinelenen kayÄ±t defteri giriÅŸi yok, Ã§akÄ±ÅŸma yok
- Otomasyon / zamanlanmÄ±ÅŸ gÃ¶revler iÃ§in gÃ¼venli

---

## Ä°lgili Sayfalar

- [ğŸ“‹ Politika BaÅŸvurusu](Policy-Reference#-tÃ¼rkÃ§e) â€” Politika kayÄ±t defteri tablosu
- [ğŸ”§ Kurulum](Installation#-tÃ¼rkÃ§e) â€” Ã–n gereksinimler ve adÄ±m adÄ±m
- [ğŸ›¡ï¸ GÃ¼venlik](Security#-tÃ¼rkÃ§e) â€” GÃ¼venlik modeli ve tehdit modeli
- [ğŸ” Sorun Giderme](Troubleshooting#-tÃ¼rkÃ§e) â€” SÄ±k karÅŸÄ±laÅŸÄ±lan sorunlar
