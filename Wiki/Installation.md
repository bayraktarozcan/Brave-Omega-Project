> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 🔧 Installation — Complete Setup Guide

Complete installation guide for Brave Omega v3.0.2.0 (V3 version-agnostic — all Brave + Chromium versions supported).

---

## System Requirements

| Requirement | Minimum | Recommended |
| ------------- | --------- | ------------- |
| **Operating System** | Windows 11 26H2 (build 26300.9550) | Windows 11 26H2 (latest stable) |
| **Brave Browser** | 1.91.x | Latest stable ([brave.com/download](https://brave.com/download)) |
| **PowerShell** | 5.1 | 5.1+ (built into Windows 11) |
| **Privileges** | Administrator | Administrator |
| **Disk Space** | 1 MB | 5 MB (for backups) |

---

## Pre-Installation Checklist

- [ ] Windows 11 installed and updated
- [ ] Brave Browser **latest stable** installed ([brave.com/download](https://brave.com/download))
- [ ] Brave version verified at [brave.com/latest](https://brave.com/latest)
- [ ] Version matches [Compatibility Matrix](Version-Compatibility-Matrix.md)
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

> [!IMPORTANT]
> **Run the script from inside the `Brave-Omega` folder, with its data files
> next to it.** `BraveOmega.ps1` is the entry point, but the 151 policies are
> not written inside the script — they are read at startup from
> `BraveOmega.ps1`'s own folder:
>
> ```text
> Brave-Omega/
> ├── BraveOmega.ps1     ← the script you run
> ├── config.json        ← level order + registry targets
> └── Profiles/          ← the policy definitions, one JSON per tier
>     ├── BraveOnly.json
>     ├── Essential.json
>     ├── Balanced.json
>     ├── Advanced.json
>     └── Strict.json
> ```
>
> The script resolves all three paths relative to itself, so you may run it
> from any working directory as long as these files sit beside it. A copy of
> `BraveOmega.ps1` on its own stops with a "config.json not found" error before
> any policy is applied. Copy the whole folder, not the single file.

### 3. Run the Script

```powershell
# Bilingual entry point — first asks: Press 1 for English / Türkçe için 2'ye basın
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1"

# ...or pin the language up front (skips the question):
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Language TR
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Language EN
```

> The `-ExecutionPolicy Bypass` flag applies **only to this single command** — no permanent execution policy change.

### 4. Follow On-Screen Prompts

- Script detects running Brave → prompts continue/cancel
- Creates timestamped `.reg` backup of HKLM policy hive
- Displays level selection menu (1-5) and applies policies based on selected level (24/51/83/123/151)
- Shows per-category success/failure summary

### 5. Restart Brave

- Close **all** Brave windows completely
- Reopen Brave

### 6. Verify

Navigate to `brave://policy` — all Essential level policies (51) should show **Active**.

---

## Execution Policy Explained

| Method | Persistence | Scope | Security |
| -------- | ------------- | ------- | ---------- |
| `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` | Permanent | User-wide | ❌ Creates attack surface |
| `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` | Session only | Current process | ✅ Better |
| **`PowerShell -ExecutionPolicy Bypass -File ...`** *(used)* | **Single command** | **Child process only** | ✅ **Best — no persistence** |

> **Brave Omega v3.0.2.0 uses the safest method:** `-ExecutionPolicy Bypass` as a launch flag — applies only to the child process, no registry changes, no attack surface.

---

## Verification

### 1. Check `brave://policy`

- Open `brave://policy` in Brave
- All Essential level policies (51) should show **Active** (green ✅)

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

Backup file created: `HKLM_BravePolicy_YYYYMMDD_HHMMSS.reg` in
`%TEMP%\BravePolicyBackup`. A `-Reset` run also leaves
`HKCU_BraveSoftware_YYYYMMDD_HHMMSS.reg` beside it.

---

## Rollback / Uninstall

### Via Backup File

```powershell
reg import "$env:TEMP\BravePolicyBackup\HKLM_BravePolicy_20260613_120000.reg"
```

`-Reset` is the other direction: it backs both hives up first, then removes
every policy — and refuses to remove anything if that backup fails.

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
> PowerShell -ExecutionPolicy Bypass -File .\BraveOmega.ps1 -Reset
> ```

---

## Common Installation Issues

| Issue | Cause | Resolution |
| ------- | ------- | ------------ |
| "CRITICAL ERROR" on launch | Not running as Admin | Right-click PowerShell → **Run as Administrator** |
| Script fails with `[ERROR]` | HKLM permission issue | Confirm Administrator mode; re-run |
| `brave://policy` shows no policies | Brave not restarted | Close **all** Brave windows and reopen |
| "Unknown" policy in `brave://policy` | Version mismatch | Verify Brave version matches [Compatibility Matrix](Version-Compatibility-Matrix.md) |
| `reg export` fails | Restricted HKLM ACL | Run `regedit` → inspect path → check ACL entries |

---

## File Structure After Extraction

Paths marked **required at runtime** are read by `BraveOmega.ps1` on every run.

```text
BRAVE OMEGA PROJECT/
│
├── .editorconfig                          Editor rules
├── .gitattributes                         Line-ending rules
├── .gitignore                             Git exclusion rules
├── .gitlab-ci.yml                         Second CI gate (GitLab)
├── .opencode/                             Agent runtime configuration
├── .github/
│   ├── ISSUE_TEMPLATE/                    Bug and feature request forms
│   ├── dependabot.yml                     Dependency update schedule
│   ├── linters/                           Shared markdownlint / yamllint config
│   └── workflows/                         CI/CD workflows (10 files)
├── ADMX/
│   ├── ADMX-Validate.ps1                  Policy cross-reference validator
│   ├── Brave.admx                         Brave ADMX policy template
│   └── Brave.adml                         ADML language resources
├── Brave-Omega/
│   ├── BraveOmega.ps1                     Unified bilingual script (EN/TR)
│   ├── config.json                        ** required at runtime ** level order + registry targets
│   ├── Profiles/                          ** required at runtime ** policy data layer
│   │   ├── BraveOnly.json                 Tier 1 policies
│   │   ├── Essential.json                 Tier 2 delta
│   │   ├── Balanced.json                  Tier 3 delta
│   │   ├── Advanced.json                  Tier 4 delta
│   │   └── Strict.json                    Tier 5 delta
│   └── Docs/
│       └── Policy-Catalog.md              Generated policy catalog (EN + TR)
├── Enterprise/
│   ├── levels.json                        Tier metadata for deployment
│   ├── BraveOnly.reg … Strict.reg         Per-tier registry packages
├── Scripts/
│   ├── Invoke-CI.ps1                      Local conformance gate (7 checks)
│   ├── Deploy-Brave-Omega.ps1             Deployment entry point
│   ├── Detect-Brave-Omega.ps1             Installed-state detection
│   ├── Export-PolicyCatalog.ps1           Regenerates the policy catalog
│   ├── Verify-Mirror-Sync.ps1             Bilingual mirror structure check
│   ├── Wiki-Sync.ps1                      Wiki projection sync
│   ├── Release.ps1                        Release automation
│   └── Mojibake-Scan.py                   Character-integrity scanner
├── Tests/                                 Pester 5.7.1 suite (32 test files + 2 helpers)
├── Wiki/                                  Wiki source of truth (15 pages)
├── index.html                             Landing page (GitHub Pages)
├── AGENTS.md                              Agent and contributor rules
├── README.md                              Documentation (EN + TR)
├── CHANGELOG.md                           Changelog (EN + TR)
├── CONTRIBUTING.md                        Contributing guide (EN + TR)
├── CODE_OF_CONDUCT.md                     Code of conduct
├── SECURITY.md                            Security policy (EN + TR)
├── PRIVACY.md                             Privacy statement
├── SUPPORT.md                             Support channels
├── RELEASE-NOTE-TEMPLATE.md               Release note skeleton
├── CODEOWNERS                             Code ownership
├── LICENSE                                MIT
└── NOTICE                                 Third-party attribution
```

---

## Related Pages

- [🚀 Quick Start](Quick-Start.md) — One-line execution
- [🏗️ Architecture](Architecture.md) — Three-tier model
- [📋 Policy Reference](Policy-Reference.md) — Complete policy table
- [🛡️ Security](Security.md) — Safety model
- [🔍 Troubleshooting](Troubleshooting.md) — Common issues

---

---

<a id="-türkçe"></a>

# 🔧 Kurulum — Tam Kurulum Kılavuzu

Brave Omega v3.0.2.0 için tam kurulum kılavuzu (V3 sürüm-bağımsız — tüm Brave + Chromium sürümleri desteklenir).

---

## Sistem Gereksinimleri

| Gereksinim | Minimum | Önerilen |
| ------------ | --------- | ---------- |
| **İşletim Sistemi** | Windows 11 26H2 (derleme 26300.9550) | Windows 11 26H2 (en güncel kararlı) |
| **Brave Browser** | 1.91.x | En güncel kararlı ([brave.com/download](https://brave.com/download)) |
| **PowerShell** | 5.1 | 5.1+ (Windows 11 ile birlikte gelir) |
| **Ayrıcalık** | Yönetici | Yönetici |
| **Disk Alanı** | 1 MB | 5 MB (yedekler için) |

---

## Kurulum Öncesi Kontrol Listesi

- [ ] Windows 11 yüklü ve güncel
- [ ] Brave Browser **en güncel kararlı** sürümü yüklü ([brave.com/download](https://brave.com/download))
- [ ] Brave sürümü [brave.com/latest](https://brave.com/latest) adresinde doğrulandı
- [ ] Sürüm, [Uyumluluk Matrisi](Version-Compatibility-Matrix.md#-türkçe) ile eşleşiyor
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

> [!IMPORTANT]
> **Betigi, veri dosyaları yanında olacak şekilde `Brave-Omega` klasörünün
> içinden çalıştırın.** `BraveOmega.ps1` giriş noktasıdır, ancak 151 politika
> betiğin içine gömülü değildir — çalışma anında betiğin kendi klasöründeki
> dosyalardan okunur:
>
> ```text
> Brave-Omega/
> ├── BraveOmega.ps1     ← çalıştırdığınız betik
> ├── config.json        ← kademe sırası + kayıt defteri hedefleri
> └── Profiles/          ← politika tanımları, her kademe için bir JSON
>     ├── BraveOnly.json
>     ├── Essential.json
>     ├── Balanced.json
>     ├── Advanced.json
>     └── Strict.json
> ```
>
> Betik bu üç yolu da kendine göre çözer; bu yüzden çalışma dizininden
> bağımsız olarak, dosyalar yanında durduğu sürece betiği her yerden
> çalıştırabilirsiniz. Tek başına kopyalanmış bir `BraveOmega.ps1`, hiçbir
> politika uygulanmadan önce "config.json bulunamadı" hatasıyla durur.
> Klasörün tamamını kopyalayın, tek dosyayı değil.

### 3. Betiği Çalıştır

```powershell
# İki dilli giriş noktası — önce dil sorar
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1"

# ...veya dili önden sabitleyin (soru sorulmaz):
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Language TR
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega.ps1" -Language EN

> `-ExecutionPolicy Bypass` bayrağı **yalnızca bu tek komut için** geçerlidir — kalıcı çalıştırma ilkesi değişikliği yok.

### 4. Ekran İstemlerini Takip Et

- Betik çalışan Brave'i tespit eder → devam/iptal istemi gösterir
- HKLM politika kovasının zaman damgalı `.reg` yedeğini oluşturur
- Seviye seçim menüsünü gösterir (1-5) ve seçilen seviyeye göre politikaları uygular (24/51/83/123/151)
- Kategori bazında başarı/hata özetini gösterir

### 5. Brave'i Yeniden Başlat

- **Tüm** Brave pencerelerini tamamen kapat
- Brave'i yeniden aç

### 6. Doğrula

`brave://policy` adresine git — 51 Temel seviye politikanın tümü **Etkin** görünmelidir.

---

## Çalıştırma İlkesi Açıklaması

| Yöntem | Kalıcılık | Kapsam | Güvenlik |
| -------- | ----------- | -------- | ---------- |
| `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` | Kalıcı | Kullanıcı genelinde | ❌ Saldırı yüzeyi oluşturur |
| `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` | Yalnızca oturum | Geçerli işlem | ✅ Daha iyi |
| **`PowerShell -ExecutionPolicy Bypass -File ...`** *(kullanılan)* | **Tek komut** | **Yalnızca alt işlem** | ✅ **En iyi — kalıcılık yok** |

> **Brave Omega v3.0.2.0 en güvenli yöntemi kullanır:** `-ExecutionPolicy Bypass` başlatma bayrağı olarak — yalnızca alt işlem için geçerlidir, kayıt defteri değişikliği yok, saldırı yüzeyi yok.

---

## Doğrulama

### 1. `brave://policy` Kontrol Et

- Brave'de `brave://policy` adresini aç
- 51 Temel seviye politikanın tümü **Etkin** (yeşil ✅) görünmeli

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

Yedek dosyası oluşturuldu: `HKLM_BravePolicy_YYYYMMDD_HHMMSS.reg`,
`%TEMP%\BravePolicyBackup` altında. `-Reset` çalıştırması bunun yanına
`HKCU_BraveSoftware_YYYYMMDD_HHMMSS.reg` dosyasını da bırakır.

---

## Geri Alma / Kaldırma

### Yedek Dosyası ile

```powershell
reg import "$env:TEMP\BravePolicyBackup\HKLM_BravePolicy_20260613_120000.reg"
```

`-Reset` bunun ters yönüdür: önce iki kovanın da yedeğini alır, sonra tüm
politikaları kaldırır — yedekleme başarısız olursa hiçbir şeyi kaldırmaz.

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
> PowerShell -ExecutionPolicy Bypass -File .\BraveOmega.ps1 -Reset
> ```

---

## Sık Karşılaşılan Kurulum Sorunları

| Sorun | Neden | Çözüm |
| ------- | ------- | ------- |
| Başlatmada "KRİTİK HATA" | Yönetici olarak çalışmıyor | PowerShell'e sağ tıkla → **Yönetici olarak çalıştır** |
| Betik `[HATA]` ile başarısız | HKLM izin sorunu | Yönetici modunu doğrula; yeniden çalıştır |
| `brave://policy` politika göstermiyor | Brave yeniden başlatılmadı | **Tüm** Brave pencerelerini kapat ve yeniden aç |
| `brave://policy`'de "Bilinmiyor" politikası | Sürüm uyuşmazlığı | Brave sürümünün [Uyumluluk Matrisi](Version-Compatibility-Matrix.md#-türkçe) ile eşleştiğini doğrula |
| `reg export` başarısız | Kısıtlı HKLM ACL | `regedit` çalıştır → yolu incele → ACL girdilerini kontrol et |

---

## Çıkarma Sonrası Dosya Yapısı

`** çalışma anında zorunlu **` ile işaretli yollar, her çalıştırmada
`BraveOmega.ps1` tarafından okunur.

```text
BRAVE OMEGA PROJECT/
│
├── .editorconfig                          Düzenleyici kuralları
├── .gitattributes                         Satır sonu kuralları
├── .gitignore                             Git dışlama kuralları
├── .gitlab-ci.yml                         İkinci kapı (GitLab)
├── .opencode/                             Ajan çalışma zamanı yapılandırması
├── .github/
│   ├── ISSUE_TEMPLATE/                    Hata ve özellik talebi formları
│   ├── dependabot.yml                     Bağımlılık güncelleme takvimi
│   ├── linters/                           Paylaşılan markdownlint / yamllint yapılandırması
│   └── workflows/                         CI/CD iş akışları (10 dosya)
├── ADMX/
│   ├── ADMX-Validate.ps1                  Politika çapraz referans doğrulayıcı
│   ├── Brave.admx                         Brave ADMX politika şablonu
│   └── Brave.adml                         ADML dil kaynakları
├── Brave-Omega/
│   ├── BraveOmega.ps1                     Birleşik iki dilli betik (EN/TR)
│   ├── config.json                        ** çalışma anında zorunlu ** kademe sırası + kayıt defteri hedefleri
│   ├── Profiles/                          ** çalışma anında zorunlu ** politika veri katmanı
│   │   ├── BraveOnly.json                 1. kademe politikaları
│   │   ├── Essential.json                 2. kademe farkı
│   │   ├── Balanced.json                  3. kademe farkı
│   │   ├── Advanced.json                  4. kademe farkı
│   │   └── Strict.json                    5. kademe farkı
│   └── Docs/
│       └── Policy-Catalog.md              Üretilen politika kataloğu (EN + TR)
├── Enterprise/
│   ├── levels.json                        Dağıtım için kademe üstverisi
│   ├── BraveOnly.reg … Strict.reg         Kademe başına kayıt defteri paketleri
├── Scripts/
│   ├── Invoke-CI.ps1                      Yerel uyumluluk kapısı (7 kontrol)
│   ├── Deploy-Brave-Omega.ps1             Dağıtım giriş noktası
│   ├── Detect-Brave-Omega.ps1             Kurulu durum algılama
│   ├── Export-PolicyCatalog.ps1           Politika kataloğunu yeniden üretir
│   ├── Verify-Mirror-Sync.ps1             İki dilli yansıma yapı denetimi
│   ├── Wiki-Sync.ps1                      Wiki projeksiyonu eşitleme
│   ├── Release.ps1                        Sürüm otomasyonu
│   └── Mojibake-Scan.py                   Karakter bütünlüğü tarayıcı
├── Tests/                                 Pester 5.7.1 paketi (32 test dosyası + 2 yardımcı)
├── Wiki/                                  Wiki kaynağı (15 sayfa)
├── index.html                             Açılış sayfası (GitHub Pages)
├── AGENTS.md                              Ajan ve katkıcı kuralları
├── README.md                              Belgelendirme (EN + TR)
├── CHANGELOG.md                           Değişiklik günlüğü (EN + TR)
├── CONTRIBUTING.md                        Katkı rehberi (EN + TR)
├── CODE_OF_CONDUCT.md                     Davranış kodu
├── SECURITY.md                            Güvenlik politikası (EN + TR)
├── PRIVACY.md                             Gizlilik beyanı
├── SUPPORT.md                             Destek kanalları
├── RELEASE-NOTE-TEMPLATE.md               Sürüm notu iskeleti
├── CODEOWNERS                             Kod sahipliği
├── LICENSE                                MIT
└── NOTICE                                 Üçüncü taraf atıfları
```

---

## İlgili Sayfalar

- [🚀 Hızlı Başlangıç](Quick-Start.md#-türkçe) — Tek satırda çalıştırma
- [🏗️ Mimari](Architecture.md#-türkçe) — Üç katmanlı model
- [📋 Politika Başvurusu](Policy-Reference.md#-türkçe) — Tam politika tablosu
- [🛡️ Güvenlik](Security.md#-türkçe) — Güvenlik modeli
- [🔍 Sorun Giderme](Troubleshooting.md#-türkçe) — Sık karşılaşılan sorunlar
