<!-- ================================================================== -->
<!--                  BRAVE OMEGA PROJECT — SECURITY.MD              -->
<!--          Community Edition · Open Source · Privacy First        -->
<!-- ================================================================== -->

<div align="center">

<br>

# 🛡️ Brave Omega — Security Policy

<br>

[![Platform](https://img.shields.io/badge/Platform-Windows%2011%2025H2-0078D4?style=flat-square&logo=windows11&logoColor=white)](https://www.microsoft.com/en-us/windows/windows-11)
[![Brave](https://img.shields.io/badge/Brave-1.92.134%20%7C%20Chromium%20150-FF6000?style=flat-square&logo=brave&logoColor=white)](https://brave.com)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=flat-square&logo=powershell&logoColor=white)](https://learn.microsoft.com/en-us/powershell/)
[![License](https://img.shields.io/badge/License-MIT-22C55E?style=flat-square)](LICENSE)
[![Security](https://img.shields.io/badge/Security-Policy-8B5CF6?style=flat-square)](SECURITY.md)

<br>

> **Language / Dil** &nbsp;
> [EN English](#-english-security-policy) &nbsp;·&nbsp; [TR Türkçe](#-türkçe-güvenlik-politikası)

<br>

</div>

---

<a id="-english-security-policy"></a>

## EN English Security Policy

### Table of Contents

1. [Overview](#en-overview)
2. [Supported Versions](#en-supported-versions)
3. [Vulnerability Disclosure](#en-vulnerability-disclosure)
4. [Security Posture](#en-security-posture)
5. [Policy Verification](#en-policy-verification)
6. [Trust & Supply Chain](#en-trust--supply-chain)
7. [Registry Safety](#en-registry-safety)
8. [Hardening Levels](#en-hardening-levels)
9. [Security FAQ](#en-security-faq)

---

### 1. Overview

Brave Omega is a registry-hardening tool designed to **enhance** browser privacy, not to introduce new attack surfaces. This document outlines the project's security stance, vulnerability handling procedures, and how to verify the integrity of the changes the script makes.

> [!IMPORTANT]
> Brave Omega makes **no network calls** during execution, downloads **no external payloads**, and writes **no browser extensions or binaries**. It operates exclusively through Windows Registry Group Policy mechanisms using Brave's official ADMX template definitions.

---

### 2. Supported Versions

| Branch | Status | Supported |
|--------|--------|-----------|
| **v2.x (current)** | Active development | ✅ Security patches, policy updates, feature improvements |
| v1.2.x | Maintained | ✅ Critical security patches only |
| v1.1.x | End of life | ❌ No longer supported |
| v1.0 | Archived | ❌ No longer supported |

> [!NOTE]
> To receive security updates, always use the latest stable release. Older versions may contain unpatched policy gaps as Chromium's enterprise policy landscape evolves.

---

### 3. Vulnerability Disclosure

#### 3.1 Reporting a Vulnerability

If you discover a security-related issue in Brave Omega — whether a policy that has an unintended side effect, a registry path that behaves unexpectedly, or any other concern — please report it privately:

- **Email**: Open a [GitHub Security Advisory](https://github.com/bayraktarozcan/Brave-Omega-Project/security/advisories/new)
- **Issue**: For non-critical security concerns, open a standard [GitHub Issue](https://github.com/bayraktarozcan/Brave-Omega-Project/issues) with the `security` label

#### 3.2 Response Timeline

| Timeframe | Action |
|-----------|--------|
| **24–48 hours** | Initial acknowledgment |
| **5 business days** | Triage and severity assessment |
| **14 calendar days** | Fix released or mitigation documented |
| **30 calendar days** | Full disclosure if applicable |

#### 3.3 Scope

**In scope:**
- Registry policies that leak data beyond documented behavior
- Policies with incorrect or unsafe default values
- Unintended privilege escalation paths
- Incorrect ADMX-to-registry type mapping

**Out of scope:**
- Vulnerabilities in Brave Browser itself (report to [Brave Security](https://hackerone.com/brave))
- Vulnerabilities in Windows or PowerShell
- Social engineering attacks requiring physical access
- Denial of service through registry modification (inherent to the tool's purpose)

---

### 4. Security Posture

#### 4.1 Defense-in-Depth Architecture

Brave Omega implements browser hardening through **three independent enforcement layers**:

```
┌──────────────────────────────────────────────────────────┐
│  TIER 1 — HKCU User Preference                           │
│  ↳ UsageStatsInSample = 0                                 │
│  ↳ ChromeVariations = 1 (HKCU mirror)                     │
│  ↳ User-modifiable, provides fallback protection          │
├──────────────────────────────────────────────────────────┤
│  TIER 2 — HKLM Enterprise Policy (ADMX)                  │
│  ↳ 23–81 policies depending on hardening level            │
│  ↳ Locked/gray in browser UI — user cannot override       │
│  ↳ Requires Administrator privileges to write             │
├──────────────────────────────────────────────────────────┤
│  TIER 3 — Omaha Updater GUID Layer                       │
│  ↳ usagestats = 0 per application GUID                   │
│  ↳ Independent of browser-level policies                  │
│  ↳ Disables update infrastructure telemetry              │
└──────────────────────────────────────────────────────────┘
```

#### 4.2 Principle of Least Privilege

- The script **requires Administrator** privileges because it writes to the HKLM registry hive
- No permanent elevation: the script exits, privileges are gone
- No background services, no scheduled tasks, no startup entries

#### 4.3 No Telemetry

Brave Omega itself collects **zero telemetry**. The script:
- Makes no network calls
- Downloads no external content
- Writes no usage logs
- Does not phone home

#### 4.4 Execution Policy Safety

The recommended invocation method uses a **session-scoped bypass**:

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1"
```

This affects only the current PowerShell window. No permanent execution policy change is made. No attack surface is introduced.

---

### 5. Policy Verification

#### 5.1 Verify Applied Policies

After running the script, confirm active policies in Brave:

1. Navigate to `brave://policy`
2. Verify all expected policies appear in the list
3. Check that policy values match the expected settings

#### 5.2 Verify Registry Directly

```powershell
# List all applied Brave enterprise policies
Get-ChildItem -Path "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

# Check a specific policy value
Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Name "MetricsReportingEnabled"
```

#### 5.3 Verify Backup Integrity

Backups are stored in `%TEMP%\BravePolicyBackup\` with timestamps. To inspect:
```powershell
notepad "$env:TEMP\BravePolicyBackup\*"
```

To restore a previous state:
```powershell
reg import "$env:TEMP\BravePolicyBackup\HKLM_BravePolicy_20260607_143022.reg"
```

#### 5.4 Source Verification

Every policy in Brave Omega can be traced to its authoritative source:

| Source | Location | Verification Method |
|--------|----------|-------------------|
| Brave ADMX Templates | `policy_templates.zip` from Brave | Extract and inspect ADMX/ADML XML |
| Chromium Policy Docs | `policy_templates_en-US.json` (1459 policies) | JSON schema validation |
| Chromium Preferences | Brave browser Preferences JSON | Inspect at `brave://version` profile path |
| Omaha Updater Schema | Windows registry `ClientState` keys | `Get-ChildItem` on GUID paths |

---

### 6. Trust & Supply Chain

#### 6.1 Code Integrity

- **Fully open source** — every line is public at [github.com/bayraktarozcan/Brave-Omega-Project](https://github.com/bayraktarozcan/Brave-Omega-Project)
- **No obfuscation** — the PowerShell source is plain text, human-readable, and reviewable
- **No compiled binaries** — no `.exe`, `.dll`, or `.msi` files
- **No external dependencies** — requires only PowerShell 5.1+, included with Windows 11

#### 6.2 Commit Signing

Project maintainers sign releases and tags using GPG. Verify signatures:
```powershell
git tag -v v2.0
```

#### 6.3 Supply Chain Recommendations

For enterprise deployments:
1. Fork the repository and audit the code internally
2. Run the script in a test environment before production
3. Pin to a specific release tag, not `main` branch
4. Verify SHA256 checksums of downloaded release artifacts

---

### 7. Registry Safety

#### 7.1 Automatic Backup

Before writing any HKLM policy, the script exports the current state:

```powershell
reg export "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" "backup.reg" /y
```

#### 7.2 Idempotent Design

All registry write operations use the `-Force` flag. Running the script multiple times:
- Does not create duplicate entries
- Does not cause side effects
- Produces identical results each time

#### 7.3 Graceful Error Handling

Each registry write is individually wrapped in a try-catch block:
- Failed policies do not halt the entire script
- Success and failure are tracked with counters
- The final summary report shows exactly what was applied

#### 7.4 Rollback

Full state restoration with a single command:
```powershell
reg import "%TEMP%\BravePolicyBackup\HKLM_BravePolicy_20260607_143022.reg"
```

#### 7.5 Policy Types

The script handles three registry value types:

| Registry Type | PowerShell Type | Examples |
|---------------|----------------|----------|
| `REG_DWORD` | `DWord` | Boolean and integer policies (most common) |
| `REG_SZ` | `String` | Enum string policies (WebRTC, DNS, HTTPS) |
| `REG_MULTI_SZ` | `MultiString` | List policies (URL lists, sync types) |

---

### 8. Hardening Levels

Brave Omega offers four progressive hardening tiers:

| Level | Policies | Description | Usability Impact |
|-------|----------|-------------|-----------------|
| **Brave Only** | 23 Brave-specific | Disables Brave's integrated services only | None |
| **Essential ⭐** | 40 (Brave Only + 17) | Brave + zero-impact data leak prevention | None |
| **Balanced** | 61 (Essential + 21) | Full security baseline with minor changes | Low |
| **Strict** | 81 (Balanced + 20) | Maximum privacy preservation | Medium |

Each level cumulatively includes all policies from previous levels. See [README.md](README.md) for the complete policy reference.

---

### 9. Security FAQ

**Q: Does Brave Omega modify the Brave browser binary?**
A: No. It writes only to the Windows Registry. The browser binary remains untouched.

**Q: Can these policies be reversed without a backup?**
A: Yes. Delete the `HKLM\SOFTWARE\Policies\BraveSoftware\Brave` registry key to remove all policies. A full backup is recommended for audit purposes.

**Q: Does Brave Omega protect against all tracking?**
A: No tool can provide absolute privacy. Brave Omega focuses on **first-party telemetry and data leakage prevention** through enterprise policy channels. Additional protections (VPNs, anti-fingerprinting, etc.) are complementary.

**Q: Can I run this script in a managed enterprise environment?**
A: Yes, but test in a non-production environment first. The script is designed for enterprise deployment with idempotent execution and automated backups. Use the `-Level` parameter for silent deployment.

**Q: What happens when Brave updates?**
A: Registry policies persist across browser updates. However, new Brave/Chromium versions may introduce new policies or deprecate existing ones. Always run the latest Brave Omega version for the corresponding Brave version.

**Q: Does this script work with Chrome instead of Brave?**
A: The policies registry path differs. Brave uses `HKLM\SOFTWARE\Policies\BraveSoftware\Brave` while Chrome uses `HKLM\SOFTWARE\Policies\Google\Chrome`. With path substitution, many policies are compatible, but this project targets Brave specifically.

---

<a id="-türkçe-güvenlik-politikası"></a>

## TR Türkçe Güvenlik Politikası

### İçindekiler

1. [Genel Bakış](#tr-genel-bakış)
2. [Desteklenen Sürümler](#tr-desteklenen-sürümler)
3. [Güvenlik Açığı Bildirimi](#tr-güvenlik-açığı-bildirimi)
4. [Güvenlik Duruşu](#tr-güvenlik-duruşu)
5. [Politika Doğrulama](#tr-politika-doğrulama)
6. [Güven ve Tedarik Zinciri](#tr-güven-ve-tedarik-zinciri)
7. [Kayıt Defteri Güvenliği](#tr-kayıt-defteri-güvenliği)
8. [Sıkılaştırma Seviyeleri](#tr-sıkılaştırma-seviyeleri)
9. [Güvenlik SSS](#tr-güvenlik-sss)

---

### 1. Genel Bakış

Brave Omega, tarayıcı gizliliğini artırmak için tasarlanmış bir kayıt defteri sıkılaştırma aracıdır. Yeni saldırı yüzeyleri oluşturmaz, mevcut güvenlik açıklarını kapatır. Bu belge, projenin güvenlik duruşunu, güvenlik açığı bildirim süreçlerini ve betiğin yaptığı değişikliklerin bütünlüğünü doğrulama yöntemlerini açıklar.

> [!IMPORTANT]
> Brave Omega, çalışma sırasında **hiçbir ağ çağrısı yapmaz**, **harici yük indirmez** ve **tarayıcı uzantısı veya ikili dosya yazmaz**. Yalnızca Windows Kayıt Defteri Grup İlkesi mekanizmaları ve Brave'in resmî ADMX şablon tanımları aracılığıyla çalışır.

---

### 2. Desteklenen Sürümler

| Dal | Durum | Destek |
|-----|-------|--------|
| **v2.x (güncel)** | Aktif geliştirme | ✅ Güvenlik yamaları, politika güncellemeleri, yeni özellikler |
| v1.2.x | Bakımda | ✅ Yalnızca kritik güvenlik yamaları |
| v1.1.x | Kullanım ömrü sonu | ❌ Artık desteklenmiyor |
| v1.0 | Arşivlendi | ❌ Artık desteklenmiyor |

> [!NOTE]
> Güvenlik güncellemelerini almak için her zaman en güncel kararlı sürümü kullanın. Eski sürümler, Chromium'un kurumsal politika yapısı geliştikçe güncelliğini yitirebilir.

---

### 3. Güvenlik Açığı Bildirimi

#### 3.1 Güvenlik Açığı Bildirme

Brave Omega ile ilgili bir güvenlik sorunu keşfederseniz — istenmeyen yan etkiye sahip bir politika, beklenmedik davranış gösteren bir kayıt defteri yolu veya başka bir endişe — lütfen özel olarak bildirin:

- **E-posta**: [GitHub Security Advisory](https://github.com/bayraktarozcan/Brave-Omega-Project/security/advisories/new) sayfasını kullanın
- **Sorun**: Kritik olmayan güvenlik endişeleri için `security` etiketiyle standart bir [GitHub Issue](https://github.com/bayraktarozcan/Brave-Omega-Project/issues) açın

#### 3.2 Yanıt Süresi

| Zaman Aralığı | Eylem |
|---------------|-------|
| **24–48 saat** | İlk bildirim onayı |
| **5 iş günü** | Ön değerlendirme ve ciddiyet belirleme |
| **14 takvim günü** | Düzeltme yayımlanır veya geçici çözüm belgelenir |
| **30 takvim günü** | Gerekirse tam açıklama |

#### 3.3 Kapsam

**Kapsam dahilinde:**
- Belgelenen davranışın ötesinde veri sızdıran kayıt defteri politikaları
- Yanlış veya güvensiz varsayılan değerlere sahip politikalar
- Yetkisiz ayrıcalık yükseltme yolları
- Hatalı ADMX-kayıt defteri türü eşlemesi

**Kapsam dışında:**
- Brave Browser'ın kendisindeki güvenlik açıkları ([Brave Security](https://hackerone.com/brave) adresine bildirin)
- Windows veya PowerShell'deki güvenlik açıkları
- Fiziksel erişim gerektiren sosyal mühendislik saldırıları
- Kayıt defteri değişikliği yoluyla hizmet reddi (araç doğası gereği)

---

### 4. Güvenlik Duruşu

#### 4.1 Derinlemesine Savunma Mimarisi

Brave Omega, tarayıcı sıkılaştırmasını **üç bağımsız zorunlu kılma katmanı** aracılığıyla uygular:

```
┌──────────────────────────────────────────────────────────┐
│  KATMAN 1 — HKCU Kullanıcı Tercihi                       │
│  ↳ UsageStatsInSample = 0                                 │
│  ↳ ChromeVariations = 1 (HKCU yansıması)                  │
│  ↳ Kullanıcı tarafından değiştirilebilir, yedek koruma    │
├──────────────────────────────────────────────────────────┤
│  KATMAN 2 — HKLM Kurumsal Politika (ADMX)                │
│  ↳ Sıkılaştırma seviyesine bağlı olarak 23–81 politika    │
│  ↳ Tarayıcı arayüzünde kilitli/gri — kullanıcı değiştiremez│
│  ↳ Yazmak için Yönetici ayrıcalıkları gerekir            │
├──────────────────────────────────────────────────────────┤
│  KATMAN 3 — Omaha Güncelleyici GUID Katmanı              │
│  ↳ Her uygulama GUID'i için usagestats = 0               │
│  ↳ Tarayıcı düzeyi politikalarından bağımsız             │
│  ↳ Güncelleme altyapısı veri aktarımını kapatır          │
└──────────────────────────────────────────────────────────┘
```

#### 4.2 En Az Ayrıcalık İlkesi

- Betik, HKLM kayıt defteri kovanına yazdığı için **Yönetici ayrıcalıkları** gerektirir
- Kalıcı yetki yükseltmesi yok: betik biter, yetkiler kaybolur
- Arka plan hizmeti, zamanlanmış görev veya başlangıç kaydı yok

#### 4.3 Veri Aktarımı Yok

Brave Omega'nın kendisi **sıfır veri aktarımı** toplar:
- Hiçbir ağ çağrısı yapmaz
- Harici içerik indirmez
- Kullanım günlüğü yazmaz
- Dışarıya bilgi göndermez

#### 4.4 Çalıştırma İlkesi Güvenliği

Önerilen çalıştırma yöntemi **oturum bazlı bypass** kullanır:

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"
```

Bu ayar yalnızca geçerli PowerShell penceresini etkiler. Kalıcı bir çalıştırma ilkesi değişikliği yapılmaz. Hiçbir saldırı yüzeyi oluşturulmaz.

---

### 5. Politika Doğrulama

#### 5.1 Uygulanan Politikaları Doğrulama

Betik çalıştıktan sonra Brave'de aktif politikaları kontrol edin:

1. `brave://policy` adresine gidin
2. Beklenen tüm politikaların listede göründüğünü doğrulayın
3. Politika değerlerinin beklenen ayarlarla eşleştiğini kontrol edin

#### 5.2 Kayıt Defterini Doğrudan Doğrulama

```powershell
# Uygulanan tüm Brave kurumsal politikalarını listele
Get-ChildItem -Path "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

# Belirli bir politika değerini kontrol et
Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Name "MetricsReportingEnabled"
```

#### 5.3 Yedek Bütünlüğünü Doğrulama

Yedekler zaman damgalarıyla `%TEMP%\BravePolicyYedek\` klasöründe saklanır:

```powershell
notepad "$env:TEMP\BravePolicyYedek\*"
```

Önceki duruma dönmek için:
```powershell
reg import "$env:TEMP\BravePolicyYedek\HKLM_BravePolicy_20260607_143022.reg"
```

#### 5.4 Kaynak Doğrulama

Brave Omega'daki her politika yetkili kaynağına kadar izlenebilir:

| Kaynak | Konum | Doğrulama Yöntemi |
|--------|-------|-------------------|
| Brave ADMX Şablonları | `policy_templates.zip` | ADMX/ADML XML'ini çıkar ve incele |
| Chromium Politika Dokümanları | `policy_templates_en-US.json` (1459 politika) | JSON şema doğrulaması |
| Chromium Tercihleri | Brave Preferences JSON | `brave://version` profil yolunda incele |
| Omaha Güncelleyici Şeması | Windows kayıt defteri `ClientState` anahtarları | GUID yollarında `Get-ChildItem` |

---

### 6. Güven ve Tedarik Zinciri

#### 6.1 Kod Bütünlüğü

- **Tamamen açık kaynak** — her satır [github.com/bayraktarozcan/Brave-Omega-Project](https://github.com/bayraktarozcan/Brave-Omega-Project) adresinde kamuya açıktır
- **Gizleme yok** — PowerShell kaynağı düz metin, insan tarafından okunabilir ve incelenebilir
- **Derlenmiş ikili dosya yok** — `.exe`, `.dll` veya `.msi` dosyası yok
- **Harici bağımlılık yok** — yalnızca Windows 11 ile birlikte gelen PowerShell 5.1+ gerektirir

#### 6.2 İmza Doğrulama

Proje bakımcıları sürümleri ve etiketleri GPG kullanarak imzalar:

```powershell
git tag -v v2.0
```

#### 6.3 Tedarik Zinciri Önerileri

Kurumsal dağıtımlar için:
1. Depoyu forklayın ve kodu dahili olarak denetleyin
2. Üretim ortamından önce test ortamında çalıştırın
3. `main` dalı değil, belirli bir sürüm etiketine sabitleyin
4. İndirilen sürüm yapıtlarının SHA256 sağlama toplamlarını doğrulayın

---

### 7. Kayıt Defteri Güvenliği

#### 7.1 Otomatik Yedekleme

Her HKLM politikası yazmadan önce, betik mevcut durumu dışa aktarır:

```powershell
reg export "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" "yedek.reg" /y
```

#### 7.2 Kararsız Olmayan Tasarım

Tüm kayıt defteri yazma işlemleri `-Force` bayrağını kullanır. Betiği birden fazla kez çalıştırmak:
- Yinelenen kayıt oluşturmaz
- Yan etkiye neden olmaz
- Her seferinde aynı sonucu üretir

#### 7.3 Hata Yönetimi

Her kayıt defteri yazma işlemi ayrı ayrı try-catch bloğuyla sarılır:
- Başarısız politikalar tüm betiği durdurmaz
- Başarı ve başarısızlık sayaçlarla takip edilir
- Nihai özet raporu tam olarak neyin uygulandığını gösterir

#### 7.4 Geri Alma

Tek komutla tam durum geri yükleme:
```powershell
reg import "%TEMP%\BravePolicyYedek\HKLM_BravePolicy_20260607_143022.reg"
```

#### 7.5 Politika Türleri

Betik üç kayıt defteri değer türünü işler:

| Kayıt Defteri Türü | PowerShell Türü | Örnekler |
|--------------------|----------------|----------|
| `REG_DWORD` | `DWord` | Boolean ve tamsayı politikaları (en yaygın) |
| `REG_SZ` | `String` | Enum string politikaları (WebRTC, DNS, HTTPS) |
| `REG_MULTI_SZ` | `MultiString` | Liste politikaları (URL listeleri, senkronizasyon türleri) |

---

### 8. Sıkılaştırma Seviyeleri

Brave Omega dört kademeli sıkılaştırma seviyesi sunar:

| Seviye | Politika Sayısı | Açıklama | Kullanım Etkisi |
|--------|----------------|----------|----------------|
| **Brave Yalnız** | 23 Brave'e özgü | Yalnızca Brave'in tümleşik hizmetlerini kapatır | Yok |
| **Temel ⭐** | 40 (Brave Yalnız + 17) | Brave + sıfır etkili veri sızıntısı önleme | Yok |
| **Dengeli** | 61 (Temel + 21) | Tam güvenlik temeli, küçük değişiklikler | Düşük |
| **Katı** | 81 (Dengeli + 20) | Azami gizlilik koruması | Orta |

Her seviye, önceki seviyelerdeki tüm politikaları kümülatif olarak içerir. Tam politika referansı için [README.md](README.md) dosyasına bakın.

---

### 9. Güvenlik SSS

**S: Brave Omega, Brave tarayıcı ikili dosyasını değiştirir mi?**
C: Hayır. Yalnızca Windows Kayıt Defteri'ne yazar. Tarayıcı ikili dosyasına dokunulmaz.

**S: Bu politikalar yedek olmadan geri alınabilir mi?**
C: Evet. Tüm politikaları kaldırmak için `HKLM\SOFTWARE\Policies\BraveSoftware\Brave` kayıt defteri anahtarını silin. Denetim amaçlı tam yedek önerilir.

**S: Brave Omega tüm izlemeye karşı korur mu?**
C: Hiçbir araç mutlak gizlilik sağlayamaz. Brave Omega, kurumsal politika kanalları aracılığıyla **birinci taraf veri aktarımı ve veri sızıntısı önlemeye** odaklanır. Ek korumalar (VPN'ler, parmak izine karşı koruma vb.) tamamlayıcıdır.

**S: Bu betiği yönetilen bir kurumsal ortamda çalıştırabilir miyim?**
C: Evet, ancak önce üretim dışı bir ortamda test edin. Betik, kararsız olmayan çalışma ve otomatik yedeklemelerle kurumsal dağıtım için tasarlanmıştır. Sessiz dağıtım için `-Level` parametresini kullanın.

**S: Brave güncellendiğinde ne olur?**
C: Kayıt defteri politikaları tarayıcı güncellemeleri arasında kalıcıdır. Ancak yeni Brave/Chromium sürümleri yeni politikalar ekleyebilir veya mevcutları kullanımdan kaldırabilir. İlgili Brave sürümü için her zaman en güncel Brave Omega sürümünü kullanın.

**S: Bu betik Chrome ile çalışır mı?**
C: Politika kayıt defteri yolları farklıdır. Brave `HKLM\SOFTWARE\Policies\BraveSoftware\Brave` kullanırken Chrome `HKLM\SOFTWARE\Policies\Google\Chrome` kullanır. Yol ikamesiyle birçok politika uyumludur ancak bu proje özellikle Brave'i hedefler.

---

<div align="center">

<br>

**🦁 Brave Omega Project** — Community Edition

*Security is not a feature. It is a foundation.*

*Güvenlik bir özellik değildir. Temeldir.*

<br>

</div>
