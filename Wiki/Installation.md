> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 🔧 Installation — Complete Setup Guide

Complete installation guide for Brave Omega v2.2.0.2 (WebRTC Policy Alignment).

---

## System Requirements

| Requirement | Minimum | Recommended |
| ------------- | --------- | ------------- |
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

> ⚠️ **Critical:** Always run against the **latest stable Brave release**. Beta/Nightly builds may have unstable ADMX behavior.

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

- Press `Win` → type `PowerShell`
- Right-click **Windows PowerShell** → **Run as Administrator**

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

> The `-ExecutionPolicy Bypass` flag applies **only to this single command** — no permanent execution policy change.

### 4. Follow On-Screen Prompts

- Script detects running Brave → prompts continue/cancel
- Creates timestamped `.reg` backup of HKLM policy hive
- Displays level selection menu (1-5) and applies policies based on selected level (22/39/60/71/80)
- Shows per-category success/failure summary

### 5. Restart Brave

- Close **all** Brave windows completely
- Reopen Brave

### 6. Verify

Navigate to `brave://policy` — all Essential level policies (39) should show **Active**.

---

## Execution Policy Explained

| Method | Persistence | Scope | Security |
| -------- | ------------- | ------- | ---------- |
| `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` | Permanent | User-wide | ❌ Creates attack surface |
| `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` | Session only | Current process | ✅ Better |
| **`PowerShell -ExecutionPolicy Bypass -File ...`** *(used)* | **Single command** | **Child process only** | ✅ **Best — no persistence** |

> **Brave Omega v2.2.0.2 uses the safest method:** `-ExecutionPolicy Bypass` as a launch flag — applies only to the child process, no registry changes, no attack surface.

---

## Verification

### 1. Check `brave://policy`

- Open `brave://policy` in Brave
- All Essential level policies (39) should show **Active** (green ✅)

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

> 💡 Tip: Use the `-Reset` parameter for automated clean removal:
>
> ```powershell
> PowerShell -ExecutionPolicy Bypass -File .\BraveOmega-TR.ps1 -Reset
> ```

---

## Common Installation Issues

| Issue | Cause | Resolution |
| ------- | ------- | ------------ |
| "CRITICAL ERROR" on launch | Not running as Admin | Right-click PowerShell → **Run as Administrator** |
| Script fails with `[ERROR]` | HKLM permission issue | Confirm Administrator mode; re-run |
| `brave://policy` shows no policies | Brave not restarted | Close **all** Brave windows and reopen |
| "Unknown" policy in `brave://policy` | Version mismatch | Verify Brave version matches [Compatibility Matrix](Version-Compatibility-Matrix) |
| `reg export` fails | Restricted HKLM ACL | Run `regedit` → inspect path → check ACL entries |

---

## File Structure After Extraction

```
BRAVE OMEGA PROJECT/
│
├── .gitignore                        # Git exclusion rules
├── .gitattributes
├── LICENSE                           MIT
├── README.md                         Documentation (EN + TR)
├── CHANGELOG.md                      Changelog
├── CONTRIBUTING.md                   Contributing guide (EN + TR)
├── SECURITY.md                       Security policy (EN + TR)
├── index.html                        Landing page (GitHub Pages)
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yaml           Bug report template
│   │   └── feature_request.yaml      Feature request template
│   └── workflows/
│       ├── admx-validate.ps1         ADMX validation script
│       └── admx-validate.yml         ADMX validation pipeline
└── Brave Omega/
        BraveOmega-EN.ps1             Main script — English interface
        BraveOmega-TR.ps1             Main script — Turkish interface
└── Tests/                         Pester test suite (16 files)
            BraveOmega.EN.Tests.ps1        Unit + integration tests (EN)
            BraveOmega.TR.Tests.ps1        Unit + integration tests (TR)
            └── *.Tests.ps1                  Phased policy tests (13 files)
```

---

## Related Pages

- [🚀 Quick Start](Quick-Start) — One-line execution
- [🏗️ Architecture](Architecture) — Three-tier model
- [📋 Policy Reference](Policy-Reference) — Complete policy table
- [🛡️ Security](Security) — Safety model
- [🔍 Troubleshooting](Troubleshooting) — Common issues

---

---

<a id="-türkçe"></a>

# 🔧 Kurulum — Tam Kurulum Kılavuzu

Brave Omega v2.2.0.2 için tam kurulum kılavuzu (WebRTC Politika Hizalaması).

---

## Sistem Gereksinimleri

| Gereksinim | Minimum | Önerilen |
| ------------ | --------- | ---------- |
| **İşletim Sistemi** | Windows 11 | Windows 11 25H2 (en güncel kararlı) |
| **Brave Browser** | 1.91.x | En güncel kararlı ([brave.com/download](https://brave.com/download)) |
| **PowerShell** | 5.1 | 5.1+ (Windows 11 ile birlikte gelir) |
| **Ayrıcalık** | Yönetici | Yönetici |
| **Disk Alanı** | 1 MB | 5 MB (yedekler için) |

---

## Kurulum Öncesi Kontrol Listesi

- [ ] Windows 11 yüklü ve güncel
- [ ] Brave Browser **en güncel kararlı** sürümü yüklü ([brave.com/download](https://brave.com/download))
- [ ] Brave sürümü [brave.com/latest](https://brave.com/latest) adresinde doğrulandı
- [ ] Sürüm, [Uyumluluk Matrisi](Version-Compatibility-Matrix#-türkçe) ile eşleşiyor
- [ ] Yönetici hesabı mevcut

> ⚠️ **Kritik:** Her zaman **en güncel kararlı Brave sürümüne** karşı çalıştırın. Beta/Nightly derlemeleri kararsız ADMX davranışına sahip olabilir.

---

## İndirme

1. [Sürümlere](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/latest) gidin
2. En son sürümden `Brave-Omega-Project.zip` dosyasını indirin
3. İstediğiniz konuma çıkarın (ör. `C:\Users\Downloads\Brave-Omega`)

```powershell
# Örnek: İndirilenler klasörüne çıkarma
Expand-Archive -Path ".\Brave-Omega-Project.zip" -DestinationPath "C:\Users\Downloads\Brave-Omega"
```

---

## Kurulum Adımları

### 1. PowerShell'i Yönetici Olarak Aç

- `Win` tuşuna bas → `PowerShell` yaz
- **Windows PowerShell**'e sağ tıkla → **Yönetici olarak çalıştır**

### 2. Proje Klasörüne Git

```powershell
cd "C:\Users\Downloads\Brave-Omega"
```

> Çıkarma konumunuza göre yolu ayarlayın.

### 3. Betiği Çalıştır

```powershell
# Türkçe arayüz
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"

# İngilizce arayüz
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1"
```

> `-ExecutionPolicy Bypass` bayrağı **yalnızca bu tek komut için** geçerlidir — kalıcı çalıştırma ilkesi değişikliği yok.

### 4. Ekran İstemlerini Takip Et

- Betik çalışan Brave'i tespit eder → devam/iptal istemi gösterir
- HKLM politika kovasının zaman damgalı `.reg` yedeğini oluşturur
- Seviye seçim menüsünü gösterir (1-5) ve seçilen seviyeye göre politikaları uygular (22/39/60/71/80)
- Kategori bazında başarı/hata özetini gösterir

### 5. Brave'i Yeniden Başlat

- **Tüm** Brave pencerelerini tamamen kapat
- Brave'i yeniden aç

### 6. Doğrula

`brave://policy` adresine git — 39 Temel seviye politikanın tümü **Etkin** görünmelidir.

---

## Çalıştırma İlkesi Açıklaması

| Yöntem | Kalıcılık | Kapsam | Güvenlik |
| -------- | ----------- | -------- | ---------- |
| `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` | Kalıcı | Kullanıcı genelinde | ❌ Saldırı yüzeyi oluşturur |
| `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` | Yalnızca oturum | Geçerli işlem | ✅ Daha iyi |
| **`PowerShell -ExecutionPolicy Bypass -File ...`** *(kullanılan)* | **Tek komut** | **Yalnızca alt işlem** | ✅ **En iyi — kalıcılık yok** |

> **Brave Omega v2.2.0.2 en güvenli yöntemi kullanır:** `-ExecutionPolicy Bypass` başlatma bayrağı olarak — yalnızca alt işlem için geçerlidir, kayıt defteri değişikliği yok, saldırı yüzeyi yok.

---

## Doğrulama

### 1. `brave://policy` Kontrol Et

- Brave'de `brave://policy` adresini aç
- 39 Temel seviye politikanın tümü **Etkin** (yeşil ✅) görünmeli

### 2. Kayıt Defterini Kontrol Et (İsteğe Bağlı)

```powershell
# Katman 1 (HKCU)
Get-ItemProperty "HKCU:\Software\BraveSoftware\Brave-Browser"

# Katman 2 (HKLM)
Get-ItemProperty "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

# Katman 3 (Omaha GUID)
Get-ItemProperty "HKCU:\Software\BraveSoftware\Update\ClientState\*"
```

### 3. Yedek Dosyasını Kontrol Et

Yedek dosyası oluşturuldu: `BraveOmega_HKLM_YYYYMMDD_HHMMSS.reg` betik dizininde.

---

## Geri Alma / Kaldırma

### Yedek Dosyası ile

```powershell
reg import "BraveOmega_HKLM_20260613_120000.reg"
```

### Manuel Kaldırma

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

> 💡 İpucu: Otomatik temiz kaldırma için `-Reset` parametresini kullanın:
>
> ```powershell
> PowerShell -ExecutionPolicy Bypass -File .\BraveOmega-TR.ps1 -Reset
> ```

---

## Sık Karşılaşılan Kurulum Sorunları

| Sorun | Neden | Çözüm |
| ------- | ------- | ------- |
| Başlatmada "KRİTİK HATA" | Yönetici olarak çalışmıyor | PowerShell'e sağ tıkla → **Yönetici olarak çalıştır** |
| Betik `[HATA]` ile başarısız | HKLM izin sorunu | Yönetici modunu doğrula; yeniden çalıştır |
| `brave://policy` politika göstermiyor | Brave yeniden başlatılmadı | **Tüm** Brave pencerelerini kapat ve yeniden aç |
| `brave://policy`'de "Bilinmiyor" politikası | Sürüm uyuşmazlığı | Brave sürümünün [Uyumluluk Matrisi](Version-Compatibility-Matrix#-türkçe) ile eşleştiğini doğrula |
| `reg export` başarısız | Kısıtlı HKLM ACL | `regedit` çalıştır → yolu incele → ACL girdilerini kontrol et |

---

## Çıkarma Sonrası Dosya Yapısı

```
BRAVE OMEGA PROJECT/
│
├── .gitignore                        # Git dışlama kuralları
├── .gitattributes
├── LICENSE                           MIT
├── README.md                         Belgelendirme (EN + TR)
├── CHANGELOG.md                      Değişiklik günlüğü
├── CONTRIBUTING.md                   Katkı rehberi (EN + TR)
├── SECURITY.md                       Güvenlik politikası (EN + TR)
├── index.html                        Açılış sayfası (GitHub Pages)
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yaml           Hata raporu şablonu
│   │   └── feature_request.yaml      Özellik talebi şablonu
│   └── workflows/
│       ├── admx-validate.ps1         ADMX doğrulama betiği
│       └── admx-validate.yml         ADMX doğrulama hattı
└── Brave Omega/
        BraveOmega-EN.ps1             Ana betik — İngilizce arayüz
        BraveOmega-TR.ps1             Ana betik — Türkçe arayüz
```

---

## İlgili Sayfalar

- [🚀 Hızlı Başlangıç](Quick-Start#-türkçe) — Tek satırda çalıştırma
- [🏗️ Mimari](Architecture#-türkçe) — Üç katmanlı model
- [📋 Politika Başvurusu](Policy-Reference#-türkçe) — Tam politika tablosu
- [🛡️ Güvenlik](Security#-türkçe) — Güvenlik modeli
- [🔍 Sorun Giderme](Troubleshooting#-türkçe) — Sık karşılaşılan sorunlar
