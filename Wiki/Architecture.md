> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 🏗️ Architecture — Multi-Tier Enforcement Model

Brave Omega uses a **three-tier enforcement model** that creates redundant, independent policy enforcement at each layer of the Windows + Brave + Omaha stack.

---

## Tier Overview

```
┌─────────────────────────────────────────────────────────────┐
│  TIER 1 — HKCU (User Preference Layer)                     │
│  HKCU:\Software\BraveSoftware\Brave-Browser                 │
│  ↳  UsageStatsInSample = 0                                  │
│     Chromium user-level telemetry sampling disabled.        │
│     Provides a fallback during policy propagation delays.   │
├─────────────────────────────────────────────────────────────┤
│  TIER 2 — HKLM (Enterprise Policy Layer / ADMX)            │
│  HKLM:\SOFTWARE\Policies\BraveSoftware\Brave                │
│  ↳  ADMX-validated enterprise policies (level-based), enforced. │
│     Appear gray and locked in browser Settings UI.         │
│     Cannot be overridden by user interaction.              │
├─────────────────────────────────────────────────────────────┤
│  TIER 3 — Omaha Updater GUID Layer                         │
│  HKCU:\Software\BraveSoftware\Update\ClientState\{GUID}     │
│  ↳  usagestats = 0 per application GUID                    │
│     Targets the update infrastructure's own telemetry,     │
│     independently of all browser-level policies.           │
└─────────────────────────────────────────────────────────────┘
```

## Hardening Levels (v2.0+)

In addition to the three enforcement tiers, Brave Omega v2.0+ offers **five hardening levels** with cumulative inheritance. Each level includes all policies from the previous one:

| Level | Policies | Scope | User Impact |
| ------- | ---------- | ------- | ------------- |
| **1. Brave Only** | 23 Brave-specific policies | HKLM | None |
| **2. Essential** ⭐ | 23 + 17 = 40 | HKLM + HKCU + Omaha | None |
| **3. Balanced** | 40 + 21 = 61 | + WebRTC, HTTPS, DNS | Low |
| **4. Gelişmiş (Advanced)** | 61 + 11 = 72 | + Sensors, Imports, Profiles | Low |
| **5. Strict** | 72 + 9 = 81 | + JIT, Cookies, Clipboard, FS | Medium |

Select your level interactively when running the script or use the `-Level` parameter:

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1" -Level Essential
```

---

## Tier Details

### Tier 1 — HKCU (User Preference Layer)

- **Registry Path:** `HKCU:\Software\BraveSoftware\Brave-Browser`
- **Policy:** `UsageStatsInSample = 0`
- **Effect:** Disables browser-level usage statistics sampling sent to Brave servers
- **Role:** Fallback during policy propagation delays; user-level preference

### Tier 2 — HKLM (Enterprise Policy Layer / ADMX)

- **Registry Path:** `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave`
- **Policies:** ADMX-validated enterprise policies (level-based)
- **Behavior:** Appear **gray and locked** in browser Settings UI
- **Enforcement:** Cannot be overridden by user interaction
- **Scope:** Machine-wide, applies to all users

### Tier 3 — Omaha Updater GUID Layer

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

> **Note:** `BraveShieldsDefault` is intentionally excluded — it does not exist in Brave's official ADMX templates. Brave manages Shields via URL-based policies (`BraveShieldsEnabledForUrls`, `BraveShieldsDisabledForUrls`). Global aggressive mode is applied through user profile preferences (Preferences JSON), not through an enterprise registry policy.

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
   ├─ Administrator privileges?
   ├─ Brave running? (prompt continue/cancel)
   ├─ Level selection (interactive or -Level parameter)
   └─ Version compatibility check

2. Backup
   └─ Export HKLM:\SOFTWARE\Policies\BraveSoftware\Brave → timestamped .reg

3. Apply Policies (per tier)
   ├─ Tier 1: HKCU user preferences
   ├─ Tier 2: HKLM ADMX enterprise policies
   └─ Tier 3: Omaha GUID usagestats = 0

4. Verification
   ├─ Per-policy success/failure counters
   └─ Summary report with rollback instructions

5. Completion
   └─ Exit code 0 on success, non-zero on failure
```

---

## Idempotency Guarantee

- **`-Force` parameter** enables safe re-execution
- **`-WhatIf` parameter** previews changes without applying them
- **`-Reset` parameter** reverts all applied policies
- Running multiple times = **identical result**
- No duplicate registry entries, no conflicts
- Safe for automation / scheduled tasks

---

## Related Pages

- [📋 Policy Reference](Policy-Reference) — Complete policy registry table
- [🔧 Installation](Installation) — Prerequisites & step-by-step
- [🛡️ Security](Security) — Safety model & threat model
- [🔍 Troubleshooting](Troubleshooting) — Common issues

---

---

<a id="-türkçe"></a>

# 🏗️ Mimari — Çok Katmanlı Zorunlu Kılma Modeli

Brave Omega, Windows + Brave + Omaha yığınının her katmanında bağımsız politika zorunlu kılması oluşturan **üç katmanlı bir model** kullanır.

---

## Katmanlara Genel Bakış

```
┌─────────────────────────────────────────────────────────────┐
│  KATMAN 1 — HKCU (Kullanıcı Tercihi Katmanı)              │
│  HKCU:\Software\BraveSoftware\Brave-Browser                 │
│  ↳  UsageStatsInSample = 0                                  │
│     Chromium kullanıcı düzeyi veri aktarımı kapatıldı.     │
│     Politika yayılma gecikmelerinde yedek güvence sağlar.  │
├─────────────────────────────────────────────────────────────┤
│  KATMAN 2 — HKLM (Kurumsal İlke Katmanı / ADMX)           │
│  HKLM:\SOFTWARE\Policies\BraveSoftware\Brave                │
│  ↳  ADMX doğrulamalı kurumsal ilke (seviye-tabanlı), zorunlu kılındı.   │
│     Tarayıcı Ayarlar arayüzünde gri/kilitli görünür.      │
│     Kullanıcı etkileşimiyle değiştirilemez.               │
├─────────────────────────────────────────────────────────────┤
│  KATMAN 3 — Omaha Güncelleyici GUID Katmanı               │
│  HKCU:\Software\BraveSoftware\Update\ClientState\{GUID}     │
│  ↳  Her uygulama GUID'i için usagestats = 0               │
│     Güncelleme altyapısının kendi veri aktarımını,        │
│     tarayıcı düzeyi ilkelerden bağımsız olarak kapatır.   │
└─────────────────────────────────────────────────────────────┘
```

## Sıkılaştırma Seviyeleri (v2.0+)

Üç zorunlu kılma katmanına ek olarak, Brave Omega v2.0+ **beş sıkılaştırma seviyesi** sunar. Her seviye bir öncekinin tüm politikalarını kapsar:

| Seviye | Politika | Kapsam | Kullanım Etkisi |
| -------- | ---------- | -------- | ----------------- |
| **1. Brave Yalnız** | 23 Brave'e özgü politika | HKLM | Yok |
| **2. Temel** ⭐ | 23 + 17 = 40 | HKLM + HKCU + Omaha | Yok |
| **3. Dengeli** | 40 + 21 = 61 | + WebRTC, HTTPS, DNS | Düşük |
| **4. Gelişmiş** | 61 + 11 = 72 | + Sensörler, İçe Aktarmalar, Profiller | Düşük |
| **5. Katı** | 72 + 9 = 81 | + JIT, Çerezler, Pano, FS | Orta |

retiği çalıştırırken seviyenizi etkileşimli olarak seçin veya `-Level` parametresini kullanın:

```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Level Temel
```

---

## Katman Ayrıntıları

### Katman 1 — HKCU (Kullanıcı Tercihi Katmanı)

- **Kayıt Defteri Yolu:** `HKCU:\Software\BraveSoftware\Brave-Browser`
- **Politika:** `UsageStatsInSample = 0`
- **Etki:** Brave sunucularına gönderilen tarayıcı düzeyi kullanım istatistiği örneklemesini devre dışı bırakır
- **Rol:** Politika yayılma gecikmelerinde yedek güvence; kullanıcı düzeyi tercih

### Katman 2 — HKLM (Kurumsal İlke Katmanı / ADMX)

- **Kayıt Defteri Yolu:** `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave`
- **Politikalar:** ADMX doğrulamalı kurumsal ilke (seviye-tabanlı)
- **Davranış:** Tarayıcı Ayarlar arayüzünde **gri ve kilitli** görünür
- **Zorunlu Kılma:** Kullanıcı etkileşimiyle değiştirilemez
- **Kapsam:** Makine genelinde, tüm kullanıcılar için geçerlidir

### Katman 3 — Omaha Güncelleyici GUID Katmanı

- **Kayıt Defteri Yolu:** `HKCU:\Software\BraveSoftware\Update\ClientState\{GUID}`
- **Politika:** Her uygulama GUID'i için `usagestats = 0`
- **Etki:** Güncelleme altyapısının kendi veri aktarımını bağımsız olarak hedefler
- **Bağımsızlık:** Tüm tarayıcı düzeyi ilkelerden bağımsız çalışır

---

## Politika Kaynakları ve Yöntem

> **Temel İlke: Sıfır gayri resmî veya spekülatif kayıt defteri değişikliği.**

Her politika tek bir yetkili kaynağa izlenebilir:

| Kaynak | Kapsanan Politikalar |
| -------- | --------------------- |
| **Brave Resmî ADMX Şablon Paketi** (`policy_templates.zip`) | `BraveRewardsDisabled`, `BraveWalletDisabled`, `BraveVPNDisabled`, `BraveAIChatEnabled`, `BraveStatsPingEnabled` |
| **Chromium Kurumsal Politika Belgelendirmesi** | `MetricsReportingEnabled`, `SafeBrowsingExtendedReportingEnabled` |
| **Google Omaha Güncelleyici Mimarisi** | `usagestats` (GUID başına, HKCU güncelleme katmanında) |
| **Chromium Tercihler Şeması** | `UsageStatsInSample` (HKCU kullanıcı tercihi) |

> **Not:** `BraveShieldsDefault` kasıtlı olarak dışarıda bırakıldı — Brave'in resmî ADMX şablonlarında bulunmamaktadır. Brave, kalkanları URL bazlı politikalarla (`BraveShieldsEnabledForUrls`, `BraveShieldsDisabledForUrls`) yönetir. Genel saldırgan mod, kurumsal kayıt defteri politikası değil; kullanıcı profil tercihleri (Preferences JSON) aracılığıyla uygulanır.

---

## Neden Üç Katman?

| Katman | Bağımsızlık | Geçersiz Kılmaya Direnç | Yayılma Hızı |
| -------- | ------------- | ------------------------ | -------------- |
| HKCU (Katman 1) | Kullanıcı düzeyi | Kullanıcı tarafından geçersiz kılınabilir | Anlık |
| HKLM ADMX (Katman 2) | Makine düzeyi | **Kullanıcı tarafından geçersiz kılınamaz** | Grup İlkesi yenileme |
| Omaha GUID (Katman 3) | Güncelleme altyapısı düzeyi | Tarayıcıdan bağımsız | Güncelleme kontrol döngüsü |

**Yedeklilik şunları sağlar:** Bir katman başarısız olursa veya gecikirse, diğerleri gizlilik korumalarını uygulamaya devam eder.

**Sıkılaştırma Seviyeleri (v2.0+):** Yukarıdaki beş seviye, Katman 2'ye ek ayrıntı düzeyi ekleyerek kaç ADMX politikası uygulanacağını seçmenizi sağlar.

---

## Politika Uygulama Akışı

```
1. Ön Kontroller
   ├─ Yönetici ayrıcalıkları?
   ├─ Brave çalışıyor mu? (devam/iptal istemi)
   ├─ Seviye seçimi (etkileşimli veya -Level parametresi)
   └─ Sürüm uyumluluk kontrolü

2. Yedekleme
   └─ HKLM:\SOFTWARE\Policies\BraveSoftware\Brave → zaman damgalı .reg

3. Politikaları Uygula (katman başına)
   ├─ Katman 1: HKCU kullanıcı tercihleri
   ├─ Katman 2: HKLM ADMX kurumsal ilkeler
   └─ Katman 3: Omaha GUID usagestats = 0

4. Doğrulama
   ├─ Politika başına başarı/hata sayaçları
   └─ Geri alma talimatlarıyla özet rapor

5. Tamamlama
   └─ Başarıda çıkış kodu 0, hatada sıfır değil
```

---

## Kararsız Olmama Garantisi

- **`-Force` parametresi** güvenli yeniden çalıştırmayı sağlar
- **`-WhatIf` parametresi** değişiklikleri uygulamadan önizler
- **`-Reset` parametresi** uygulanan tüm politikaları geri alır
- rirden fazla çalıştırma = **özdeş sonuç**
- Yinelenen kayıt defteri girişi yok, çakışma yok
- Otomasyon / zamanlanmış görevler için güvenli

---

## İlgili Sayfalar

- [📋 Politika Başvurusu](Policy-Reference#-türkçe) — Politika kayıt defteri tablosu
- [🔧 Kurulum](Installation#-türkçe) — Ön gereksinimler ve adım adım
- [🛡️ Güvenlik](Security#-türkçe) — Güvenlik modeli ve tehdit modeli
- [🔍 Sorun Giderme](Troubleshooting#-türkçe) — Sık karşılaşılan sorunlar
