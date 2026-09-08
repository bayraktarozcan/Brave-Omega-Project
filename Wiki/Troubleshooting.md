> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;Â·&nbsp; [TR TÃ¼rkÃ§e](#-tÃ¼rkÃ§e)

<a id="-english"></a>

# ğŸ” Troubleshooting â€” Common Issues & Solutions

Quick-reference guide for common Brave Omega issues.

---

## Quick Diagnostic

| Symptom | Likely Cause | Quick Fix |
| --------- | -------------- | ----------- |
| Script exits with "CRITICAL ERROR" | Not running as Administrator | Right-click PowerShell â†’ **Run as Administrator** |
| `brave://policy` shows **no policies** | Brave not restarted | Close **all** Brave windows and reopen |
| `[ERROR]` lines in output | HKLM permission issue | Confirm Admin mode; re-run |
| Brave overwrites HKCU prefs | Brave was open during run | Close Brave first; re-run |
| Policy shows "Unknown" in `brave://policy` | Version mismatch | Verify Brave version vs [Compatibility Matrix](Version-Compatibility-Matrix) |
| `reg export` fails at backup | Restricted HKLM ACL | Run `regedit` â†’ inspect path â†’ check ACL |
| Script hangs / no output | Brave process detection | Close Brave manually, re-run with `-Force` |
| `-Reset` doesn't remove all policies | Brave was running | Close Brave completely, re-run `-Reset` |
| `-WhatIf` shows unexpected changes | Wrong level selected | Re-run with correct `-Level` parameter |
| Test fails: "Command not found" | Tests run from wrong directory | `cd` to project root â†’ `Invoke-Pester -Path .\Tests\` |
| Pester test skipped in CI | Missing Pester module | `Install-Module Pester -Force -SkipPublisherCheck` |

---

## Detailed Solutions

### 1. "CRITICAL ERROR: Administrator privileges required"

**Cause:** Script not running with elevated privileges.

**Resolution:**

1. Close PowerShell
2. Press `Win` â†’ type `PowerShell`
3. Right-click **Windows PowerShell** â†’ **Run as Administrator**
4. Navigate to project folder and re-run

> **Note:** HKLM writes **require** Administrator. HKCU/Omaha layers do not.

---

### 2. No Policies Showing in `brave://policy`

**Cause:** Brave was running when policies were applied, or Brave not restarted.

**Resolution:**

1. Close **all** Brave windows (check system tray)
2. Wait 2 seconds
3. Reopen Brave
4. Navigate to `brave://policy`
5. Refresh page (F5)

> **Why:** Brave reads policies at startup. Changes apply on next launch.

---

### 3. `[ERROR]` Lines in Script Output

**Cause:** Permission denied writing to HKLM registry path.

**Resolution:**

1. Verify running as Administrator (check title bar says "Administrator")
2. Close any registry editors (`regedit`) that might lock the path
3. Re-run script
4. If persists: Run `regedit` â†’ navigate to `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` â†’ check **Permissions** â†’ ensure `Administrators` has **Full Control**

---

### 4. Brave Overwrites HKCU Preferences

**Cause:** Brave was running during script execution.

**Resolution:**

1. Close **all** Brave windows before running script
2. Use script's built-in process guard (prompts continue/cancel if Brave detected)
3. If missed: Close Brave, re-run script with `-Force`

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Force
```

---

### 5. Policy Shows "Unknown" in `brave://policy`

**Cause:** Brave version mismatch â€” policy key renamed/deprecated in newer Brave.

**Resolution:**

1. Check Brave version: `brave://version`
2. Check [Compatibility Matrix](Version-Compatibility-Matrix) for your Brave Omega version
3. If Brave newer than matrix: Check [Releases](https://github.com/bayraktarozcan/Brave-Omega-Project/releases) for updated Brave Omega
4. If Brave older: Update Brave to latest stable

> **Rule:** Always run Brave Omega version matching your installed Brave version.

---

### 6. `reg export` Fails During Backup Step

**Cause:** Restricted ACL on `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave`

**Resolution:**

1. Open `regedit` as Administrator
2. Navigate to `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave`
3. Right-click â†’ **Permissions**
4. Ensure **Administrators** group has **Full Control**
5. Check **Replace all child object permission entries**
6. Apply â†’ OK
7. Re-run script

> **Alternative:** Run script from elevated CMD instead of PowerShell.

---

### 7. Script Hangs / No Output

**Cause:** Brave process detection waiting for user input (hidden prompt).

**Resolution:**

1. Check if PowerShell is waiting for input (look at title bar)
2. Close all Brave windows manually
3. Press `Enter` in PowerShell if prompted
4. Or re-run with `-Force` to skip process guard:

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Force
```

---

### 8. Execution Policy Errors

**Error:** `Running scripts is disabled on this system`

**Resolution:** Use the bypass flag (built into v1.2.2+):

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1"
```

> **Do NOT** run `Set-ExecutionPolicy` manually â€” the bypass flag handles it safely.

---

### 9. Policy Shows "Error" or Red in `brave://policy`

**Cause:** Registry value type mismatch (DWORD vs String) or invalid value.

**Resolution:**

1. Verify registry value types in `regedit`:
   - DWORD policies: `0` or `1` (not `"0"` or `"1"`)
2. Re-run script â€” it enforces correct types
3. If persistent: Manual cleanup + re-run

```powershell
# Cleanup
Remove-Item "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Recurse -Force
Remove-Item "HKCU:\Software\BraveSoftware\Brave-Browser" -Recurse -Force
# Re-run
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1"
```

---

### 10. Pester Test Fails or Is Skipped

**Cause:** Test environment issue â€” wrong directory, missing module, or admin requirement.

**Resolution:**

1. Ensure you are in the project root (where `Tests/` folder exists):

   ```powershell
   cd "C:\path\to\Brave-Omega-Project"
   ```

2. Verify Pester is installed:

   ```powershell
   Install-Module Pester -Force -SkipPublisherCheck
   ```

3. Run a single test file to isolate failures:

   ```powershell
   Invoke-Pester -Path .\Tests\01-BraveOnly.Tests.ps1
   ```

4. Check CI status badges on the repo README.

**Common failures:**

| Symptom | Cause |
| --------- | ------- |
| All tests skipped | Not running from project root |
| Registry test fails | Running without `-WhatIf` mock |
| CI test not triggered | Branch not pushed / PR not open |

**Cause:** Registry value type mismatch (DWORD vs String) or invalid value.

**Resolution:**

1. Verify registry value types in `regedit`:
   - DWORD policies: `0` or `1` (not `"0"` or `"1"`)
2. Re-run script â€” it enforces correct types
3. If persistent: Manual cleanup + re-run

```powershell
# Cleanup
Remove-Item "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Recurse -Force
Remove-Item "HKCU:\Software\BraveSoftware\Brave-Browser" -Recurse -Force
# Re-run
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1"
```

---

## Error Code Reference

| Exit Code | Meaning |
| ----------- | --------- |
| `0` | Success â€” all policies applied |
| `1` | General failure (see output) |
| `2` | Administrator check failed |
| `3` | Brave version mismatch |
| `4` | Registry backup failed |
| `5` | HKLM write access denied |
| `6` | Policy application partial failure |

---

## Getting Help

If issue persists:

1. **Collect:**
   - Brave version: `brave://version` (copy all)
   - Windows version: `winver`
   - Full script output (copy entire PowerShell window)
   - `brave://policy` page (save as HTML or screenshot)

2. **Search:** [Existing Issues](https://github.com/bayraktarozcan/Brave-Omega-Project/issues)

3. **Report:** [New Issue](https://github.com/bayraktarozcan/Brave-Omega-Project/issues/new) with:
   - Brave version
   - Windows version
   - Full script output
   - `brave://policy` export (HTML)

---

## Related Pages

- [ğŸ”§ Installation](Installation) â€” Step-by-step guide
- [ğŸ—ï¸ Architecture](Architecture) â€” Understanding the tiers
- [ğŸ“‹ Policy Reference](Policy-Reference) â€” What each policy does
- [ğŸ›¡ï¸ Security](Security) â€” Safety model
- [ğŸ—ºï¸ Roadmap](Roadmap) â€” Planned improvements

---

---

<a id="-tÃ¼rkÃ§e"></a>

# ğŸ” Sorun Giderme â€” SÄ±k KarÅŸÄ±laÅŸÄ±lan Sorunlar ve Ã‡Ã¶zÃ¼mler

SÄ±k karÅŸÄ±laÅŸÄ±lan Brave Omega sorunlarÄ± iÃ§in hÄ±zlÄ± baÅŸvuru kÄ±lavuzu.

---

## HÄ±zlÄ± TanÄ±

| Belirti | OlasÄ± Neden | HÄ±zlÄ± Ã‡Ã¶zÃ¼m |
| --------- | ------------- | ------------- |
| Betik "KRÄ°TÄ°K HATA" ile Ã§Ä±kÄ±yor | YÃ¶netici olarak Ã§alÄ±ÅŸmÄ±yor | PowerShell'e saÄŸ tÄ±kla â†’ **YÃ¶netici olarak Ã§alÄ±ÅŸtÄ±r** |
| `brave://policy` **politika gÃ¶stermiyor** | Brave yeniden baÅŸlatÄ±lmadÄ± | **TÃ¼m** Brave pencerelerini kapat ve yeniden aÃ§ |
| Ã‡Ä±ktÄ±da `[HATA]` satÄ±rlarÄ± | HKLM izin sorunu | YÃ¶netici modunu doÄŸrula; yeniden Ã§alÄ±ÅŸtÄ±r |
| Brave HKCU tercihlerini Ã¼zerine yazÄ±yor | Ã‡alÄ±ÅŸma sÄ±rasÄ±nda Brave aÃ§Ä±ktÄ± | Ã–nce Brave'i kapat; yeniden Ã§alÄ±ÅŸtÄ±r |
| `brave://policy`'de "Bilinmiyor" politikasÄ± | SÃ¼rÃ¼m uyuÅŸmazlÄ±ÄŸÄ± | Brave sÃ¼rÃ¼mÃ¼nÃ¼ [Uyumluluk Matrisi](Version-Compatibility-Matrix#-tÃ¼rkÃ§e) ile karÅŸÄ±laÅŸtÄ±r |
| Yedeklemede `reg export` baÅŸarÄ±sÄ±z | KÄ±sÄ±tlÄ± HKLM ACL | `regedit` Ã§alÄ±ÅŸtÄ±r â†’ yolu incele â†’ ACL'i kontrol et |
| Betik takÄ±lÄ±yor / Ã§Ä±ktÄ± yok | Brave sÃ¼reÃ§ tespiti | Brave'i manuel kapat, `-Force` ile yeniden Ã§alÄ±ÅŸtÄ±r |
| `-Reset` tÃ¼m politikalarÄ± kaldÄ±rmÄ±yor | Brave Ã§alÄ±ÅŸÄ±yordu | Brave'i tamamen kapatÄ±n, `-Reset`'i yeniden Ã§alÄ±ÅŸtÄ±rÄ±n |
| `-WhatIf` beklenmeyen deÄŸiÅŸiklikler gÃ¶steriyor | YanlÄ±ÅŸ seviye seÃ§ildi | DoÄŸru `-Level` parametresiyle yeniden Ã§alÄ±ÅŸtÄ±rÄ±n |

---

## AyrÄ±ntÄ±lÄ± Ã‡Ã¶zÃ¼mler

### 1. "KRÄ°TÄ°K HATA: YÃ¶netici ayrÄ±calÄ±klarÄ± gerekli"

**Neden:** Betik yÃ¼kseltilmiÅŸ ayrÄ±calÄ±klarla Ã§alÄ±ÅŸmÄ±yor.

**Ã‡Ã¶zÃ¼m:**

1. PowerShell'i kapat
2. `Win` tuÅŸuna bas â†’ `PowerShell` yaz
3. **Windows PowerShell**'e saÄŸ tÄ±kla â†’ **YÃ¶netici olarak Ã§alÄ±ÅŸtÄ±r**
4. Proje klasÃ¶rÃ¼ne git ve yeniden Ã§alÄ±ÅŸtÄ±r

> **Not:** HKLM yazmalarÄ± **YÃ¶netici gerektirir**. HKCU/Omaha katmanlarÄ± gerektirmez.

---

### 2. `brave://policy`'de Politika GÃ¶sterilmiyor

**Neden:** Politikalar uygulanÄ±rken Brave Ã§alÄ±ÅŸÄ±yordu veya Brave yeniden baÅŸlatÄ±lmadÄ±.

**Ã‡Ã¶zÃ¼m:**

1. **TÃ¼m** Brave pencerelerini kapat (sistem tepsisini kontrol et)
2. 2 saniye bekle
3. Brave'i yeniden aÃ§
4. `brave://policy` adresine git
5. SayfayÄ± yenile (F5)

> **Neden:** Brave politikalarÄ± baÅŸlangÄ±Ã§ta okur. DeÄŸiÅŸiklikler bir sonraki aÃ§Ä±lÄ±ÅŸta devreye girer.

---

### 3. Betik Ã‡Ä±ktÄ±sÄ±nda `[HATA]` SatÄ±rlarÄ±

**Neden:** HKLM kayÄ±t defteri yoluna yazma izni reddedildi.

**Ã‡Ã¶zÃ¼m:**

1. YÃ¶netici olarak Ã§alÄ±ÅŸtÄ±rdÄ±ÄŸÄ±nÄ±zÄ± doÄŸrulayÄ±n (baÅŸlÄ±k Ã§ubuÄŸunda "YÃ¶netici" yazdÄ±ÄŸÄ±nÄ± kontrol edin)
2. Yolu kilitleyebilecek kayÄ±t defteri dÃ¼zenleyicilerini (`regedit`) kapatÄ±n
3. BetiÄŸi yeniden Ã§alÄ±ÅŸtÄ±rÄ±n
4. Devam ederse: `regedit` Ã§alÄ±ÅŸtÄ±rÄ±n â†’ `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` yoluna gidin â†’ **Ä°zinler**'i kontrol edin â†’ **YÃ¶neticiler**'in **Tam Denetim**'e sahip olduÄŸundan emin olun

---

### 4. Brave HKCU Tercihlerini Ãœzerine YazÄ±yor

**Neden:** Betik Ã§alÄ±ÅŸtÄ±rma sÄ±rasÄ±nda Brave Ã§alÄ±ÅŸÄ±yordu.

**Ã‡Ã¶zÃ¼m:**

1. BetiÄŸi Ã§alÄ±ÅŸtÄ±rmadan Ã¶nce **tÃ¼m** Brave pencerelerini kapatÄ±n
2. BetiÄŸin yerleÅŸik sÃ¼reÃ§ koruyucusunu kullanÄ±n (Brave tespit edilirse devam/iptal istemi gÃ¶sterir)
3. KaÃ§Ä±rÄ±ldÄ±ysa: Brave'i kapatÄ±n, `-Force` ile betiÄŸi yeniden Ã§alÄ±ÅŸtÄ±rÄ±n

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Force
```

---

### 5. `brave://policy`'de "Bilinmiyor" PolitikasÄ±

**Neden:** Brave sÃ¼rÃ¼m uyuÅŸmazlÄ±ÄŸÄ± â€” politika anahtarÄ± yeniden adlandÄ±rÄ±lmÄ±ÅŸ/kullanÄ±mdan kaldÄ±rÄ±lmÄ±ÅŸ.

**Ã‡Ã¶zÃ¼m:**

1. Brave sÃ¼rÃ¼mÃ¼nÃ¼ kontrol edin: `brave://version`
2. Brave Omega sÃ¼rÃ¼mÃ¼nÃ¼z iÃ§in [Uyumluluk Matrisi](Version-Compatibility-Matrix#-tÃ¼rkÃ§e)'ni kontrol edin
3. Brave matristen yeniyse: GÃ¼ncellenmiÅŸ Brave Omega iÃ§in [SÃ¼rÃ¼mlere](https://github.com/bayraktarozcan/Brave-Omega-Project/releases) bakÄ±n
4. Brave eskiyse: Brave'i en gÃ¼ncel kararlÄ± sÃ¼rÃ¼me gÃ¼ncelleyin

> **Kural:** Her zaman yÃ¼klÃ¼ Brave sÃ¼rÃ¼mÃ¼nÃ¼zle eÅŸleÅŸen Brave Omega sÃ¼rÃ¼mÃ¼nÃ¼ Ã§alÄ±ÅŸtÄ±rÄ±n.

---

### 6. Yedekleme AdÄ±mÄ±nda `reg export` BaÅŸarÄ±sÄ±z

**Neden:** `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` Ã¼zerinde kÄ±sÄ±tlÄ± ACL

**Ã‡Ã¶zÃ¼m:**

1. `regedit`'i YÃ¶netici olarak aÃ§Ä±n
2. `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` yoluna gidin
3. SaÄŸ tÄ±kla â†’ **Ä°zinler**
4. **YÃ¶neticiler** grubunun **Tam Denetim**'e sahip olduÄŸundan emin olun
5. **Alt nesne izin girdilerinin tÃ¼mÃ¼nÃ¼ deÄŸiÅŸtir** seÃ§eneÄŸini iÅŸaretleyin
6. Uygula â†’ Tamam
7. BetiÄŸi yeniden Ã§alÄ±ÅŸtÄ±rÄ±n

> **Alternatif:** BetiÄŸi PowerShell yerine yÃ¼kseltilmiÅŸ CMD'den Ã§alÄ±ÅŸtÄ±rÄ±n.

---

### 7. Betik TakÄ±lÄ±yor / Ã‡Ä±ktÄ± Yok

**Neden:** Brave sÃ¼reÃ§ tespiti kullanÄ±cÄ± giriÅŸi bekliyor (gizli istem).

**Ã‡Ã¶zÃ¼m:**

1. PowerShell'in giriÅŸ bekleyip beklemediÄŸini kontrol edin (baÅŸlÄ±k Ã§ubuÄŸuna bakÄ±n)
2. TÃ¼m Brave pencerelerini manuel kapatÄ±n
3. Ä°stem varsa PowerShell'de `Enter` tuÅŸuna basÄ±n
4. Veya sÃ¼reÃ§ koruyucusunu atlamak iÃ§in `-Force` ile yeniden Ã§alÄ±ÅŸtÄ±rÄ±n:

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Force
```

---

### 8. Ã‡alÄ±ÅŸtÄ±rma Ä°lkesi HatalarÄ±

**Hata:** `Bu sistemde betik Ã§alÄ±ÅŸtÄ±rma devre dÄ±ÅŸÄ± bÄ±rakÄ±lmÄ±ÅŸtÄ±r`

**Ã‡Ã¶zÃ¼m:** Bayrak kullanÄ±n (v1.2.2+ iÃ§inde yerleÅŸik):

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1"
```

> **`Set-ExecutionPolicy`'yi manuel olarak Ã‡ALIÅTIRMAYIN** â€” bypass bayraÄŸÄ± gÃ¼venle halleder.

---

### 9. `brave://policy`'de "Hata" veya KÄ±rmÄ±zÄ± Politika

**Neden:** KayÄ±t defteri deÄŸer tÃ¼rÃ¼ uyuÅŸmazlÄ±ÄŸÄ± (DWORD vs String) veya geÃ§ersiz deÄŸer.

**Ã‡Ã¶zÃ¼m:**

1. KayÄ±t defteri deÄŸer tÃ¼rlerini `regedit`'te doÄŸrulayÄ±n:
   - DWORD politikalarÄ±: `0` veya `1` (`"0"` veya `"1"` deÄŸil)
2. BetiÄŸi yeniden Ã§alÄ±ÅŸtÄ±rÄ±n â€” doÄŸru tÃ¼rleri zorlar
3. Devam ederse: Manuel temizlik + yeniden Ã§alÄ±ÅŸtÄ±rma

```powershell
# Temizlik
Remove-Item "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Recurse -Force
Remove-Item "HKCU:\Software\BraveSoftware\Brave-Browser" -Recurse -Force
# Yeniden Ã§alÄ±ÅŸtÄ±r
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1"
```

---

## Hata Kodu ReferansÄ±

| Ã‡Ä±kÄ±ÅŸ Kodu | AnlamÄ± |
| ------------ | -------- |
| `0` | BaÅŸarÄ±lÄ± â€” tÃ¼m politikalar uygulandÄ± |
| `1` | Genel hata (Ã§Ä±ktÄ±ya bakÄ±n) |
| `2` | YÃ¶netici kontrolÃ¼ baÅŸarÄ±sÄ±z |
| `3` | Brave sÃ¼rÃ¼m uyuÅŸmazlÄ±ÄŸÄ± |
| `4` | KayÄ±t defteri yedeklemesi baÅŸarÄ±sÄ±z |
| `5` | HKLM yazma eriÅŸimi reddedildi |
| `6` | Politika uygulamasÄ± kÄ±smi baÅŸarÄ±sÄ±zlÄ±k |

---

## YardÄ±m Alma

Sorun devam ederse:

1. **Topla:**
   - Brave sÃ¼rÃ¼mÃ¼: `brave://version` (tÃ¼mÃ¼nÃ¼ kopyala)
   - Windows sÃ¼rÃ¼mÃ¼: `winver`
   - Tam betik Ã§Ä±ktÄ±sÄ± (tÃ¼m PowerShell penceresini kopyala)
   - `brave://policy` sayfasÄ± (HTML veya ekran gÃ¶rÃ¼ntÃ¼sÃ¼ olarak kaydet)

2. **Ara:** [Mevcut Sorunlar](https://github.com/bayraktarozcan/Brave-Omega-Project/issues)

3. **Raporla:** [Yeni Sorun](https://github.com/bayraktarozcan/Brave-Omega-Project/issues/new) ÅŸunlarla:
   - Brave sÃ¼rÃ¼mÃ¼
   - Windows sÃ¼rÃ¼mÃ¼
   - Tam betik Ã§Ä±ktÄ±sÄ±
   - `brave://policy` dÄ±ÅŸa aktarÄ±mÄ± (HTML)

---

## Ä°lgili Sayfalar

- [ğŸ”§ Kurulum](Installation#-tÃ¼rkÃ§e) â€” AdÄ±m adÄ±m kÄ±lavuz
- [ğŸ—ï¸ Mimari](Architecture#-tÃ¼rkÃ§e) â€” KatmanlarÄ± anlama
- [ğŸ“‹ Politika BaÅŸvurusu](Policy-Reference#-tÃ¼rkÃ§e) â€” Her politikanÄ±n ne yaptÄ±ÄŸÄ±
- [ğŸ›¡ï¸ GÃ¼venlik](Security#-tÃ¼rkÃ§e) â€” GÃ¼venlik modeli
- [ğŸ—ºï¸ Yol HaritasÄ±](Roadmap#-tÃ¼rkÃ§e) â€” Planlanan iyileÅŸtirmeler
