> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 🔍 Troubleshooting — Common Issues & Solutions

Quick-reference guide for common Brave Omega issues.

---

## Quick Diagnostic

| Symptom | Likely Cause | Quick Fix |
| --------- | -------------- | ----------- |
| Script exits with "CRITICAL ERROR" | Not running as Administrator | Right-click PowerShell → **Run as Administrator** |
| `brave://policy` shows **no policies** | Brave not restarted | Close **all** Brave windows and reopen |
| `[ERROR]` lines in output | HKLM permission issue | Confirm Admin mode; re-run |
| Brave overwrites HKCU prefs | Brave was open during run | Close Brave first; re-run |
| Policy shows "Unknown" in `brave://policy` | Version mismatch | Verify Brave version vs [Compatibility Matrix](Version-Compatibility-Matrix) |
| `reg export` fails at backup | Restricted HKLM ACL | Run `regedit` → inspect path → check ACL |
| Script hangs / no output | Brave process detection | Close Brave manually, re-run with `-Force` |
| `-Reset` doesn't remove all policies | Brave was running | Close Brave completely, re-run `-Reset` |
| `-WhatIf` shows unexpected changes | Wrong level selected | Re-run with correct `-Level` parameter |
| Test fails: "Command not found" | Tests run from wrong directory | `cd` to project root → `Invoke-Pester -Path .\Tests\` |
| Pester test skipped in CI | Missing Pester module | `Install-Module Pester -Force -SkipPublisherCheck` |

---

## Detailed Solutions

### 1. "CRITICAL ERROR: Administrator privileges required"

**Cause:** Script not running with elevated privileges.

**Resolution:**

1. Close PowerShell
2. Press `Win` → type `PowerShell`
3. Right-click **Windows PowerShell** → **Run as Administrator**
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
4. If persists: Run `regedit` → navigate to `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` → check **Permissions** → ensure `Administrators` has **Full Control**

---

### 4. Brave Overwrites HKCU Preferences

**Cause:** Brave was running during script execution.

**Resolution:**

1. Close **all** Brave windows before running script
2. Use script's built-in process guard (prompts continue/cancel if Brave detected)
3. If missed: Close Brave, re-run script with `-Force`

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Force
```

---

### 5. Policy Shows "Unknown" in `brave://policy`

**Cause:** Brave version mismatch — policy key renamed/deprecated in newer Brave.

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
3. Right-click → **Permissions**
4. Ensure **Administrators** group has **Full Control**
5. Check **Replace all child object permission entries**
6. Apply → OK
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
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Force
```

---

### 8. Execution Policy Errors

**Error:** `Running scripts is disabled on this system`

**Resolution:** Use the bypass flag (built into v1.2.2+):

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"
```

> **Do NOT** run `Set-ExecutionPolicy` manually — the bypass flag handles it safely.

---

### 9. Policy Shows "Error" or Red in `brave://policy`

**Cause:** Registry value type mismatch (DWORD vs String) or invalid value.

**Resolution:**

1. Verify registry value types in `regedit`:
   - DWORD policies: `0` or `1` (not `"0"` or `"1"`)
2. Re-run script — it enforces correct types
3. If persistent: Manual cleanup + re-run

```powershell
# Cleanup
Remove-Item "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Recurse -Force
Remove-Item "HKCU:\Software\BraveSoftware\Brave-Browser" -Recurse -Force
# Re-run
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"
```

---

### 10. Pester Test Fails or Is Skipped

**Cause:** Test environment issue — wrong directory, missing module, or admin requirement.

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
2. Re-run script — it enforces correct types
3. If persistent: Manual cleanup + re-run

```powershell
# Cleanup
Remove-Item "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Recurse -Force
Remove-Item "HKCU:\Software\BraveSoftware\Brave-Browser" -Recurse -Force
# Re-run
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"
```

---

## Error Code Reference

| Exit Code | Meaning |
| ----------- | --------- |
| `0` | Success — all policies applied |
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

- [🔧 Installation](Installation) — Step-by-step guide
- [🏗️ Architecture](Architecture) — Understanding the tiers
- [📋 Policy Reference](Policy-Reference) — What each policy does
- [🛡️ Security](Security) — Safety model
- [🗺️ Roadmap](Roadmap) — Planned improvements

---

---

<a id="-türkçe"></a>

# 🔍 Sorun Giderme — Sık Karşılaşılan Sorunlar ve Çözümler

Sık karşılaşılan Brave Omega sorunları için hızlı başvuru kılavuzu.

---

## Hızlı Tanı

| Belirti | Olası Neden | Hızlı Çözüm |
| --------- | ------------- | ------------- |
| Betik "KRİTİK HATA" ile çıkıyor | Yönetici olarak çalışmıyor | PowerShell'e sağ tıkla → **Yönetici olarak çalıştır** |
| `brave://policy` **politika göstermiyor** | Brave yeniden başlatılmadı | **Tüm** Brave pencerelerini kapat ve yeniden aç |
| Çıktıda `[HATA]` satırları | HKLM izin sorunu | Yönetici modunu doğrula; yeniden çalıştır |
| Brave HKCU tercihlerini üzerine yazıyor | Çalışma sırasında Brave açıktı | Önce Brave'i kapat; yeniden çalıştır |
| `brave://policy`'de "Bilinmiyor" politikası | Sürüm uyuşmazlığı | Brave sürümünü [Uyumluluk Matrisi](Version-Compatibility-Matrix#-türkçe) ile karşılaştır |
| Yedeklemede `reg export` başarısız | Kısıtlı HKLM ACL | `regedit` çalıştır → yolu incele → ACL'i kontrol et |
| Betik takılıyor / çıktı yok | Brave süreç tespiti | Brave'i manuel kapat, `-Force` ile yeniden çalıştır |
| `-Reset` tüm politikaları kaldırmıyor | Brave çalışıyordu | Brave'i tamamen kapatın, `-Reset`'i yeniden çalıştırın |
| `-WhatIf` beklenmeyen değişiklikler gösteriyor | Yanlış seviye seçildi | Doğru `-Level` parametresiyle yeniden çalıştırın |

---

## Ayrıntılı Çözümler

### 1. "KRİTİK HATA: Yönetici ayrıcalıkları gerekli"

**Neden:** Betik yükseltilmiş ayrıcalıklarla çalışmıyor.

**Çözüm:**

1. PowerShell'i kapat
2. `Win` tuşuna bas → `PowerShell` yaz
3. **Windows PowerShell**'e sağ tıkla → **Yönetici olarak çalıştır**
4. Proje klasörüne git ve yeniden çalıştır

> **Not:** HKLM yazmaları **Yönetici gerektirir**. HKCU/Omaha katmanları gerektirmez.

---

### 2. `brave://policy`'de Politika Gösterilmiyor

**Neden:** Politikalar uygulanırken Brave çalışıyordu veya Brave yeniden başlatılmadı.

**Çözüm:**

1. **Tüm** Brave pencerelerini kapat (sistem tepsisini kontrol et)
2. 2 saniye bekle
3. Brave'i yeniden aç
4. `brave://policy` adresine git
5. Sayfayı yenile (F5)

> **Neden:** Brave politikaları başlangıçta okur. Değişiklikler bir sonraki açılışta devreye girer.

---

### 3. Betik Çıktısında `[HATA]` Satırları

**Neden:** HKLM kayıt defteri yoluna yazma izni reddedildi.

**Çözüm:**

1. Yönetici olarak çalıştırdığınızı doğrulayın (başlık çubuğunda "Yönetici" yazdığını kontrol edin)
2. Yolu kilitleyebilecek kayıt defteri düzenleyicilerini (`regedit`) kapatın
3. Betiği yeniden çalıştırın
4. Devam ederse: `regedit` çalıştırın → `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` yoluna gidin → **İzinler**'i kontrol edin → **Yöneticiler**'in **Tam Denetim**'e sahip olduğundan emin olun

---

### 4. Brave HKCU Tercihlerini Üzerine Yazıyor

**Neden:** Betik çalıştırma sırasında Brave çalışıyordu.

**Çözüm:**

1. Betiği çalıştırmadan önce **tüm** Brave pencerelerini kapatın
2. Betiğin yerleşik süreç koruyucusunu kullanın (Brave tespit edilirse devam/iptal istemi gösterir)
3. Kaçırıldıysa: Brave'i kapatın, `-Force` ile betiği yeniden çalıştırın

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Force
```

---

### 5. `brave://policy`'de "Bilinmiyor" Politikası

**Neden:** Brave sürüm uyuşmazlığı — politika anahtarı yeniden adlandırılmış/kullanımdan kaldırılmış.

**Çözüm:**

1. Brave sürümünü kontrol edin: `brave://version`
2. Brave Omega sürümünüz için [Uyumluluk Matrisi](Version-Compatibility-Matrix#-türkçe)'ni kontrol edin
3. Brave matristen yeniyse: Güncellenmiş Brave Omega için [Sürümlere](https://github.com/bayraktarozcan/Brave-Omega-Project/releases) bakın
4. Brave eskiyse: Brave'i en güncel kararlı sürüme güncelleyin

> **Kural:** Her zaman yüklü Brave sürümünüzle eşleşen Brave Omega sürümünü çalıştırın.

---

### 6. Yedekleme Adımında `reg export` Başarısız

**Neden:** `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` üzerinde kısıtlı ACL

**Çözüm:**

1. `regedit`'i Yönetici olarak açın
2. `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` yoluna gidin
3. Sağ tıkla → **İzinler**
4. **Yöneticiler** grubunun **Tam Denetim**'e sahip olduğundan emin olun
5. **Alt nesne izin girdilerinin tümünü değiştir** seçeneğini işaretleyin
6. Uygula → Tamam
7. Betiği yeniden çalıştırın

> **Alternatif:** Betiği PowerShell yerine yükseltilmiş CMD'den çalıştırın.

---

### 7. Betik Takılıyor / Çıktı Yok

**Neden:** Brave süreç tespiti kullanıcı girişi bekliyor (gizli istem).

**Çözüm:**

1. PowerShell'in giriş bekleyip beklemediğini kontrol edin (başlık çubuğuna bakın)
2. Tüm Brave pencerelerini manuel kapatın
3. İstem varsa PowerShell'de `Enter` tuşuna basın
4. Veya süreç koruyucusunu atlamak için `-Force` ile yeniden çalıştırın:

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Force
```

---

### 8. Çalıştırma İlkesi Hataları

**Hata:** `Bu sistemde betik çalıştırma devre dışı bırakılmıştır`

**Çözüm:** Bayrak kullanın (v1.2.2+ içinde yerleşik):

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"
```

> **`Set-ExecutionPolicy`'yi manuel olarak ÇALIŞTIRMAYIN** — bypass bayrağı güvenle halleder.

---

### 9. `brave://policy`'de "Hata" veya Kırmızı Politika

**Neden:** Kayıt defteri değer türü uyuşmazlığı (DWORD vs String) veya geçersiz değer.

**Çözüm:**

1. Kayıt defteri değer türlerini `regedit`'te doğrulayın:
   - DWORD politikaları: `0` veya `1` (`"0"` veya `"1"` değil)
2. Betiği yeniden çalıştırın — doğru türleri zorlar
3. Devam ederse: Manuel temizlik + yeniden çalıştırma

```powershell
# Temizlik
Remove-Item "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Recurse -Force
Remove-Item "HKCU:\Software\BraveSoftware\Brave-Browser" -Recurse -Force
# Yeniden çalıştır
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"
```

---

## Hata Kodu Referansı

| Çıkış Kodu | Anlamı |
| ------------ | -------- |
| `0` | Başarılı — tüm politikalar uygulandı |
| `1` | Genel hata (çıktıya bakın) |
| `2` | Yönetici kontrolü başarısız |
| `3` | Brave sürüm uyuşmazlığı |
| `4` | Kayıt defteri yedeklemesi başarısız |
| `5` | HKLM yazma erişimi reddedildi |
| `6` | Politika uygulaması kısmi başarısızlık |

---

## Yardım Alma

Sorun devam ederse:

1. **Topla:**
   - Brave sürümü: `brave://version` (tümünü kopyala)
   - Windows sürümü: `winver`
   - Tam betik çıktısı (tüm PowerShell penceresini kopyala)
   - `brave://policy` sayfası (HTML veya ekran görüntüsü olarak kaydet)

2. **Ara:** [Mevcut Sorunlar](https://github.com/bayraktarozcan/Brave-Omega-Project/issues)

3. **Raporla:** [Yeni Sorun](https://github.com/bayraktarozcan/Brave-Omega-Project/issues/new) şunlarla:
   - Brave sürümü
   - Windows sürümü
   - Tam betik çıktısı
   - `brave://policy` dışa aktarımı (HTML)

---

## İlgili Sayfalar

- [🔧 Kurulum](Installation#-türkçe) — Adım adım kılavuz
- [🏗️ Mimari](Architecture#-türkçe) — Katmanları anlama
- [📋 Politika Başvurusu](Policy-Reference#-türkçe) — Her politikanın ne yaptığı
- [🛡️ Güvenlik](Security#-türkçe) — Güvenlik modeli
- [🗺️ Yol Haritası](Roadmap#-türkçe) — Planlanan iyileştirmeler
