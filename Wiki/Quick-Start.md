> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 🚀 Quick Start — Brave Omega

> Get Brave Omega running in **3 minutes** with a single copy-paste command.

---

## Prerequisites

| Requirement | Detail |
| ------------- | -------- |
| **OS** | Windows 11 (latest stable 25H2 build recommended) |
| **Browser** | **Brave Browser — latest stable** ([brave.com/download](https://brave.com/download)) |
| **PowerShell** | 5.1+ (included with Windows 11) |
| **Privileges** | **Administrator** (required for HKLM registry writes) |
| **Execution Policy** | Handled automatically via `-ExecutionPolicy Bypass` flag |

> ⚠️ **Always use the latest stable Brave release** before running. Verify at [brave.com/latest](https://brave.com/latest).

---

## One-Line Execution

### Turkish Interface

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"
```

### English Interface

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1"
```

> The `-ExecutionPolicy Bypass` flag applies **only to this single command** — no permanent execution policy change, no attack surface exposure. Close the window and everything resets.

---

### Preview Mode (-WhatIf)

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -WhatIf
```

Shows what would change without writing to the registry.

### Clean Uninstall (-Reset)

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Reset
```

Removes all Brave Omega policies from HKLM, HKCU, and Omaha GUIDs.

---

## Selecting a Hardening Level

When you run the script without parameters, it shows an interactive menu:

```
1. Brave Only (13 policies)
2. Essential [Recommended] (30 policies)
3. Balanced (49 policies)
4. Strict (68 policies)
Your selection (2):
```

To skip the menu in automated deployments:

```powershell
# Essential level (recommended)
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Level Essential

# English
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1" -Level Essential
```

Available levels: `BraveOnly`, `Essential`, `Balanced`, `Strict` (EN) or `BraveYalniz`, `Temel`, `Dengeli`, `Kati` (TR).

---

## Step-by-Step (Expanded)

### 1. Open PowerShell as Administrator

- Press `Win` → type `PowerShell`
- Right-click **Windows PowerShell** → **Run as Administrator**

### 2. Navigate to Project Folder

```powershell
cd "C:\Users\Downloads\Brave-Omega"
```

> Adjust path if you extracted elsewhere.

### 3. Run the Script

```powershell
# Turkish
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"

# English
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1"
```

### 4. Restart Brave

- Close **all** Brave windows completely
- Reopen Brave

### 5. Verify

Navigate to `brave://policy` in Brave — all policies (30 for Essential level) should show as **Active**.

---

## What the Script Does

| Phase | Action |
| ------- | -------- |
| **1. Pre-flight** | Detects running Brave, prompts continue/cancel |
| **2. Backup** | Creates timestamped `.reg` backup of HKLM policy hive |
| **3. Apply** | Writes policies across 3 tiers based on selected level (13/30/49/68) |
| **4. Summary** | Per-category success/failure counters + rollback info |
| **5. Cleanup** | Exits cleanly — no residual processes |

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
| "CRITICAL ERROR" on launch | Right-click PowerShell → **Run as Administrator** |
| No policies in `brave://policy` | Close **all** Brave windows and reopen |
| `[ERROR]` in output | Confirm Administrator mode; re-run |
| "Unknown" policy in `brave://policy` | Verify Brave version matches [Compatibility Matrix](Version-Compatibility-Matrix) |

---

## Next Steps

- [📖 Full Installation Guide](Installation)
- [🏗️ Architecture Overview](Architecture)
- [📋 Policy Reference](Policy-Reference)
- [🛡️ Security Model](Security)

---

---

<a id="-türkçe"></a>

# 🚀 Hızlı Başlangıç — Brave Omega

> Brave Omega'yı **3 dakikada** çalıştırın, tek bir kopyala-yapıştır komutuyla.

---

## Ön Gereksinimler

| Gereksinim | Ayrıntı |
| ------------ | --------- |
| **İşletim Sistemi** | Windows 11 (önerilen: en güncel kararlı 25H2 derlemesi) |
| **Tarayıcı** | **Brave Browser — en güncel kararlı** ([brave.com/download](https://brave.com/download)) |
| **PowerShell** | 5.1+ (Windows 11 ile birlikte gelir) |
| **Ayrıcalık** | **Yönetici** (HKLM kayıt defteri yazmaları için gerekli) |
| **Çalıştırma İlkesi** | `-ExecutionPolicy Bypass` bayrağı ile otomatik olarak yönetilir |

> ⚠️ **Çalıştırmadan önce her zaman en güncel kararlı Brave sürümünü kullanın.** [brave.com/latest](https://brave.com/latest) adresinden doğrulayın.

---

## Tek Satırda Çalıştırma

### Türkçe Arayüz

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"
```

### İngilizce Arayüz

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1"
```

> `-ExecutionPolicy Bypass` bayrağı **yalnızca bu tek komut için** geçerlidir — kalıcı çalıştırma ilkesi değişikliği yok, saldırı yüzeyi maruziyeti yok. Pencereyi kapatın, her şey sıfırlanır.

---

### Ön İzleme Kipi (-WhatIf)

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -WhatIf
```

Kayıt defterine yazmadan nelerin değişeceğini gösterir.

### Temiz Kaldırma (-Reset)

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Reset
```

Tüm Brave Omega politikalarını HKLM, HKCU ve Omaha GUID'lerinden kaldırır.

---

## Sıkılaştırma Seviyesi Seçme

Betik parametresiz çalıştırıldığında etkileşimli bir menü gösterir:

```
1. Brave Yalnız (13 politika)
2. Temel [Önerilen] (30 politika)
3. Dengeli (49 politika)
4. Katı (68 politika)
Seçiminiz (2):
```

Otomatik dağıtımlarda menüyü atlamak için:

```powershell
# Temel seviye (önerilen)
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Level Temel

# İngilizce
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1" -Level Essential
```

Kullanılabilir seviyeler: `BraveOnly`/`BraveYalniz`, `Essential`/`Temel`, `Balanced`/`Dengeli`, `Strict`/`Kati`.

---

## Adım Adım (Genişletilmiş)

### 1. PowerShell'i Yönetici Olarak Aç

- `Win` tuşuna bas → `PowerShell` yaz
- **Windows PowerShell**'e sağ tıkla → **Yönetici olarak çalıştır**

### 2. Proje Klasörüne Git

```powershell
cd "C:\Users\Downloads\Brave-Omega"
```

> Farklı bir yere çıkardıysanız yolu buna göre ayarlayın.

### 3. Betiği Çalıştır

```powershell
# Türkçe
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"

# İngilizce
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1"
```

### 4. Brave'i Yeniden Başlat

- **Tüm** Brave pencerelerini tamamen kapat
- Brave'i yeniden aç

### 5. Doğrula

Brave'de `brave://policy` adresine git — tüm politikalar (Temel seviyede 30) **Etkin** olarak görünmelidir.

---

## Betik Ne Yapar?

| Aşama | Eylem |
| ------- | ------- |
| **1. Ön Kontrol** | Çalışan Brave'i tespit eder, devam/iptal istemi gösterir |
| **2. Yedekleme** | HKLM politika kovasının zaman damgalı `.reg` yedeğini oluşturur |
| **3. Uygulama** | Seçilen seviyeye göre 3 katmanda politikaları yazar (13/30/49/68) |
| **4. Özet** | Kategori bazında başarı/hata sayaçları + geri alma bilgisi |
| **5. Temizlik** | Artık süreç bırakmadan temiz çıkış |

---

## Geri Alma (Gerekirse)

```powershell
reg import "BraveOmega_HKLM_YYYYMMDD_HHMMSS.reg"
```

Yedek dosyası zaman damgasıyla adlandırılır (ör. `BraveOmega_HKLM_20260613_120000.reg`).

---

## Sık Karşılaşılan Sorunlar

| Sorun | Çözüm |
| ------- | ------- |
| Başlatmada "KRİTİK HATA" | PowerShell'e sağ tıkla → **Yönetici olarak çalıştır** |
| `brave://policy`'de politika yok | **Tüm** Brave pencerelerini kapat ve yeniden aç |
| Çıktıda `[HATA]` satırları | Yönetici modunu doğrula; yeniden çalıştır |
| `brave://policy`'de "Bilinmiyor" politikası | Brave sürümünün [Uyumluluk Matrisi](Version-Compatibility-Matrix#-türkçe) ile eşleştiğini doğrula |

---

## Sonraki Adımlar

- [📖 Tam Kurulum Kılavuzu](Installation#-türkçe)
- [🏗️ Mimari Genel Bakış](Architecture#-türkçe)
- [📋 Politika Başvurusu](Policy-Reference#-türkçe)
- [🛡️ Güvenlik Modeli](Security#-türkçe)
