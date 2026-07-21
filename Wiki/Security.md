> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 🛡️ Security — Safety Model & Threat Analysis

Brave Omega is designed with a **security-first** approach. Every design decision prioritizes user safety, transparency, and auditability.

---

## Security Principles

| Principle | Implementation |
| ----------- | ---------------- |
| **Zero Obfuscation** | 100% readable PowerShell source — no encoding, no compression, no hidden logic |
| **Zero Network Calls** | Script makes **zero outbound network connections** — fully offline operation |
| **Zero Executables** | Pure PowerShell — no binaries, no DLLs, no external dependencies |
| **Least Privilege** | Only requests Administrator for HKLM writes; HKCU/Omaha need no elevation |
| **Auditability** | Every registry change traceable to official ADMX/Chromium documentation |

---

## Threat Model

| Threat | Mitigation |
| -------- | ------------ |
| **Malicious script modification** | Full source on GitHub — verify checksums before running |
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
├─ Administrator privilege verification
├─ Brave process detection (with continue/cancel prompt)
├─ Brave version validation against Compatibility Matrix
├─ Brave version detection (compares against validated version 1.92.141)
└─ Registry path ACL validation
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
# Single-command bypass — no persistence
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"
```

- **No `Set-ExecutionPolicy` call** — no permanent registry changes
- Bypass applies **only to child process** — parent shell unaffected
- No attack surface exposure, no residual policy changes

### 6. Preview Mode (-WhatIf)

```powershell
# Preview all changes without writing
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -WhatIf
```

- No registry writes occur in WhatIf mode
- All operations are guarded by if (-not $WhatIf)
- Backup and directory creation are entirely skipped
- Magenta [WhatIf] tags indicate what would change

### 7. Clean Uninstall (-Reset)

```powershell
# Remove all Brave Omega policies
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Reset
```

- Removes all 150 policies from HKLM, HKCU, and Omaha GUIDs
- Cleans up empty registry keys automatically
- Respects -WhatIf silently

---

## Execution Policy Comparison

| Method | Persistence | Scope | Attack Surface | Used? |
| -------- | ------------- | ------- | ---------------- | ------- |
| `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` | Permanent | User-wide | ❌ High | ❌ No |
| `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` | Session | Current process | ⚠️ Medium | ❌ No |
| **`PowerShell -ExecutionPolicy Bypass -File ...`** | **Single command** | **Child process only** | ✅ **None** | ✅ **Yes** |

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
| All policies active | `brave://policy` → policies show **Active** (52 for Essential level) |
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

- [🔧 Installation](Installation) — Safe execution procedure
- [🏗️ Architecture](Architecture) — Three-tier model
- [📋 Policy Reference](Policy-Reference) — What policies are applied
- [🔍 Troubleshooting](Troubleshooting) — Common issues
- [🗺️ Roadmap](Roadmap) — Planned security enhancements

---

## Test Security Notes (Phase 3)

The Pester test suite at `Tests/` follows the same security model:

| Principle | Implementation |
| ----------- | ---------------- |
| **No live registry writes** | Tests use mock paths or `-WhatIf` mode — no HKLM/HKCU modification |
| **No network calls** | Tests are fully offline — no internet dependency |
| **Isolation** | Each test file is self-contained; no cross-file state |
| **Inspectable** | 100% readable Pester code — no hidden test logic |
| **Admin not required** | Unit tests run without elevation; integration tests skip if not admin |

> 🧪 Run `Invoke-Pester -Path .\Tests\` to validate the suite before any PR.

---

---

<a id="-türkçe"></a>

# 🛡️ Güvenlik — Güvenlik Modeli ve Tehdit Analizi

Brave Omega **güvenlik öncelikli** bir yaklaşımla tasarlanmıştır. Her tasarım kararı kullanıcı güvenliğini, şeffaflığı ve denetlenebilirliği önceliklendirir.

---

## Güvenlik İlkeleri

| İlke | Uygulama |
| ------ | ---------- |
| **Sıfır Gizleme** | %100 okunabilir PowerShell kaynağı — kodlama, sıkıştırma veya gizli mantık yok |
| **Sıfır Ağ Çağrısı** | Betik **sıfır giden ağ bağlantısı** yapar — tamamen çevrimdışı çalışma |
| **Sıfır Çalıştırılabilir** | Saf PowerShell — ikili dosya, DLL veya harici bağımlılık yok |
| **En Az Ayrıcalık** | Yalnızca HKLM yazmaları için Yönetici ister; HKCU/Omaha yükseltme gerektirmez |
| **Denetlenebilirlik** | Her kayıt defteri değişikliği resmî ADMX/Chromium belgelendirmesine izlenebilir |

---

## Tehdit Modeli

| Tehdit | Önlem |
| -------- | ------- |
| **Kötü amaçlı betik değişikliği** | GitHub'da tam kaynak — çalıştırmadan önce sağlama toplamlarını doğrulayın |
| **Tedarik zinciri ihlali** | Harici bağımlılık yok; paket yöneticisi yok; ikili dosya yok |
| **Kayıt defteri bozulması** | HKLM yazmalarından önce otomatik `.reg` yedeği; tek komutla geri alma |
| **Kısmi uygulama** | İşlem başına try/catch ile bireysel başarı/hata sayaçları |
| **Brave veri kaybı** | Süreç koruyucusu çalışan Brave'i tespit eder, devam/iptal istemi gösterir |
| **Ayrıcalık yükseltme** | Betik yalnızca HKLM için Yönetici ister; HKCU/Omaha yükseltme gerektirmez |
| **Güncel olmayan politika uygulaması** | Sürüm sabitleme + çalışma zamanında Brave sürümü kontrolü |

---

## Güvenlik Kontrolleri

### 1. Ön Uçuş Kontrolleri

```
├─ Yönetici ayrıcalığı doğrulaması
├─ Brave süreç tespiti (devam/iptal istemiyle)
├─ Brave sürümünün Uyumluluk Matrisine karşı doğrulaması
├─ Brave sürüm algılama (doğrulanmış sürüm 1.92.141 ile karşılaştırma)
└─ Kayıt defteri yolu ACL doğrulaması
```

### 2. Yazmadan Önce Yedekleme

- **Otomatik** zaman damgalı `.reg` dışa aktarımı: `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave`
- Dosya adı: `BraveOmega_HKLM_YYYYMMDD_HHMMSS.reg`
- Kolay geri alma için betik dizininde saklanır

### 3. Kararsız Olmayan Uygulama

- **`-Force` parametresi** güvenli yeniden çalıştırmayı sağlar
- Politika başına try/catch ile bireysel başarı/hata takibi
- Birden fazla çalıştırma = **özdeş sonuç**, yinelenen kayıt yok

### 4. Geri Alma Yeteneği

```powershell
# Tek komutla eski duruma dönüş
reg import "BraveOmega_HKLM_20260613_120000.reg"
```

- Yedek, tam HKLM politika kovası durumunu içerir
- Geri yükleme atomik ve eksiksizdir

### 5. Çalıştırma İlkesi Güvenliği (v1.2.2+)

```powershell
# Tek komutla bypass — kalıcılık yok
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"
```

- **`Set-ExecutionPolicy` çağrısı yok** — kalıcı kayıt defteri değişikliği yok
- Bypass **yalnızca alt işlem için** geçerlidir — üst kabuk etkilenmez
- Saldırı yüzeyi maruziyeti yok, artık politika değişikliği yok

### 6. Ön İzleme Kipi (-WhatIf)

```powershell
# Tüm değişiklikleri yazmadan önizle
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -WhatIf
```

- WhatIf kipinde kayıt defterine yazma olmaz
- Tüm işlemler if (-not $WhatIf) ile korunur
- Yedekleme ve dizin oluşturma tamamen atlanır
- Macenta [WhatIf] etiketleri neyin değişeceğini belirtir

### 7. Temiz Kaldırma (-Reset)

```powershell
# Tüm Brave Omega politikalarını kaldır
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Reset
```

- 150 politikanın tümünü HKLM, HKCU ve Omaha GUID'lerinden kaldırır
- Boş kayıt defteri anahtarlarını otomatik temizler
- -WhatIf'e sessizce saygı duyar

---

## Çalıştırma İlkesi Karşılaştırması

| Yöntem | Kalıcılık | Kapsam | Saldırı Yüzeyi | Kullanıldı mı? |
| -------- | ----------- | -------- | ---------------- | ---------------- |
| `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` | Kalıcı | Kullanıcı genelinde | ❌ Yüksek | ❌ Hayır |
| `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` | Oturum | Geçerli işlem | ⚠️ Orta | ❌ Hayır |
| **`PowerShell -ExecutionPolicy Bypass -File ...`** | **Tek komut** | **Yalnızca alt işlem** | ✅ **Hiçbiri** | ✅ **Evet** |

---

## Yedekleme ve Geri Alma Ayrıntıları

### Yedek Dosyası Biçimi

```
Dosya adı: BraveOmega_HKLM_YYYYMMDD_HHMMSS.reg
Konum: Betik çalıştırma dizini
Biçim: Standart Windows REGEDIT4 biçimi
İçerik: Tam HKLM:\SOFTWARE\Policies\BraveSoftware\Brave kovası
```

### Geri Alma Prosedürü

```powershell
# 1. Brave'i kapat
# 2. Yedeği içe aktar
reg import "BraveOmega_HKLM_20260613_120000.reg"
# 3. Brave'i yeniden başlat
```

### Manuel Geri Alma (yedek kaybolursa)

```powershell
# HKLM politikalarını kaldır
Remove-Item "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Recurse -Force

# HKCU kullanıcı tercihlerini kaldır
Remove-Item "HKCU:\Software\BraveSoftware\Brave-Browser" -Recurse -Force

# Omaha usagestats'i sıfırla
Get-Item "HKCU:\Software\BraveSoftware\Update\ClientState\*" | ForEach-Object {
    Set-ItemProperty $_.PSPath -Name "usagestats" -Value 1
}
```

---

## Doğrulama Kontrol Listesi

Çalıştırmadan önce doğrulayın:

- [ ] Betik resmî GitHub sürümünden indirildi
- [ ] SHA256 sağlama toplamı sürüm notlarıyla eşleşiyor (varsa)
- [ ] Windows 11'de en güncel güncellemelerle çalışıyor
- [ ] Brave Browser **en güncel kararlı** sürümü yüklü
- [ ] Brave sürümü [Uyumluluk Matrisi](Version-Compatibility-Matrix#-türkçe) ile eşleşiyor
- [ ] PowerShell Yönetici olarak çalışıyor
- [ ] Çakışabilecek kritik uygulamalar çalışmıyor

---

## Çalıştırma Sonrası Doğrulama

| Kontrol | Yöntem |
| --------- | -------- |
| Tüm politikalar etkin | `brave://policy` → 150 politikanın tümü **Etkin** gösteriyor (Katı seviye; Temel'de 53, Dengeli'de 86) |
| Kayıt defteri yazıldı | `Get-ItemProperty HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` |
| Yedek oluşturuldu | `BraveOmega_HKLM_*.reg` betik dizininde mevcut |
| Çıktıda hata yok | Betik kod 0 ile çıkıyor, `[ERROR]` satırı yok |

---

## Olay Müdahalesi

Beklenmeyen davranış oluşursa:

1. **Acil:** Brave'i kapat, `reg import` ile yedeği içe aktar
2. **İncele:** `[HATA]` satırları için betik çıktısını gözden geçir
3. **Raporla:** GitHub sorunu aç:
   - Brave sürümü (`brave://version`)
   - Windows sürümü (`winver`)
   - Tam betik çıktısı
   - `brave://policy` sayfası dışa aktarımı
4. **Geri al:** Yedek veya manuel kaldırma prosedürünü kullan

---

## İlgili Sayfalar

- [🔧 Kurulum](Installation#-türkçe) — Güvenli çalıştırma prosedürü
- [🏗️ Mimari](Architecture#-türkçe) — Üç katmanlı model
- [📋 Politika Başvurusu](Policy-Reference#-türkçe) — Hangi politikalar uygulanır
- [🔍 Sorun Giderme](Troubleshooting#-türkçe) — Sık karşılaşılan sorunlar
- [🗺️ Yol Haritası](Roadmap#-türkçe) — Planlanan güvenlik iyileştirmeleri
