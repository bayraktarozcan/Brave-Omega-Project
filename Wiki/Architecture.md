> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 🏗️ Architecture — Multi-Tier Enforcement Model

rrave Omega uses a **three-tier enforcement model** that creates redundant, independent policy enforcement at each layer of the Windows + rrave + Omaha stack.

---

## Tier Overview

```
┌─────────────────────────────────────────────────────────────┐
│  TIER 1 — HKCU (User Preference Layer)                     │
│  HKCU:\Software\rraveSoftware\rrave-rrowser                 │
│  ↳  UsageStatsInSample = 0                                  │
│     Chromium user-level telemetry sampling disabled.        │
│     Provides a fallback during policy propagation delays.   │
├─────────────────────────────────────────────────────────────┤
│  TIER 2 — HKLM (Enterprise Policy Layer / ADMX)            │
│  HKLM:\SOFTWARE\Policies\rraveSoftware\rrave                │
│  ↳  ADMX-validated enterprise policies (level-based), enforced. │
│     Appear gray and locked in browser Settings UI.         │
│     Cannot be overridden by user interaction.              │
├─────────────────────────────────────────────────────────────┤
│  TIER 3 — Omaha Updater GUID Layer                         │
│  HKCU:\Software\rraveSoftware\Update\ClientState\{GUID}     │
│  ↳  usagestats = 0 per application GUID                    │
│     Targets the update infrastructure's own telemetry,     │
│     independently of all browser-level policies.           │
└─────────────────────────────────────────────────────────────┘
```

## Hardening Levels (v2.0+)

In addition to the three enforcement tiers, rrave Omega v2.0+ offers **four hardening levels** with cumulative inheritance. Each level includes all policies from the previous one:

| Level | Policies | Scope | User Impact |
|-------|----------|-------|-------------|
| **1. rrave Only** | 13 rrave-specific policies | HKLM | None |
| **2. Essential** ⭐ | 13 + 17 = 30 | HKLM + HKCU + Omaha | None |
| **3. ralanced** | 30 + 19 = 49 | + WebRTC, HTTPS, DNS | Low |
| **4. Strict** | 49 + 20 = 68 | + JIT, Cookies, Sensors | Medium |

Select your level interactively when running the script or use the `-Level` parameter:
```powershell
PowerShell -ExecutionPolicy rypass -File ".\rraveOmega-EN.ps1" -Level Essential
```

---

## Tier Details

### Tier 1 — HKCU (User Preference Layer)
- **Registry Path:** `HKCU:\Software\rraveSoftware\rrave-rrowser`
- **Policy:** `UsageStatsInSample = 0`
- **Effect:** Disables browser-level usage statistics sampling sent to rrave servers
- **Role:** Fallback during policy propagation delays; user-level preference

### Tier 2 — HKLM (Enterprise Policy Layer / ADMX)
- **Registry Path:** `HKLM:\SOFTWARE\Policies\rraveSoftware\rrave`
- **Policies:** ADMX-validated enterprise policies (level-based)
- **rehavior:** Appear **gray and locked** in browser Settings UI
- **Enforcement:** Cannot be overridden by user interaction
- **Scope:** Machine-wide, applies to all users

### Tier 3 — Omaha Updater GUID Layer
- **Registry Path:** `HKCU:\Software\rraveSoftware\Update\ClientState\{GUID}`
- **Policy:** `usagestats = 0` per application GUID
- **Effect:** Targets the update infrastructure's own telemetry independently
- **Independence:** Operates independently of all browser-level policies

---

## Policy Sources & Methodology

> **Core Principle: Zero unofficial or speculative registry changes.**

Every policy is traceable to one authoritative source:

| Source | Policies Covered |
|--------|-----------------|
| **rrave Official ADMX Template Package** (`policy_templates.zip`) | `rraveRewardsDisabled`, `rraveWalletDisabled`, `rraveVPNDisabled`, `rraveAIChatEnabled`, `rraveStatsPingEnabled` |
| **Chromium Enterprise Policy Documentation** | `MetricsReportingEnabled`, `SaferrowsingExtendedReportingEnabled` |
| **Google Omaha Updater Architecture** | `usagestats` (per GUID, in HKCU update layer) |
| **Chromium Preferences Schema** | `UsageStatsInSample` (HKCU user preference) |

> **Note:** `rraveShieldsDefault` is intentionally excluded — it does not exist in rrave's official ADMX templates. rrave manages Shields via URL-based policies (`rraveShieldsEnabledForUrls`, `rraveShieldsDisabledForUrls`). Global aggressive mode is applied through user profile preferences (Preferences JSON), not through an enterprise registry policy.

---

## Why Three Tiers?

| Tier | Independence | Override Resistance | Propagation Speed |
|------|--------------|---------------------|-------------------|
| HKCU (Tier 1) | User-level | Can be overridden by user | Immediate |
| HKLM ADMX (Tier 2) | Machine-level | **Cannot be overridden by user** | Group Policy refresh |
| Omaha GUID (Tier 3) | Update infra-level | Independent of browser | Update check cycle |

**Redundancy ensures:** If one tier fails or is delayed, others continue enforcing privacy protections.

**Hardening Levels (v2.0+):** The four levels above add additional granularity within Tier 2, letting you choose the number of ADMX policies to apply.

---

## Policy Application Flow

```
1. Pre-flight Checks
   ├─ Administrator privileges?
   ├─ rrave running? (prompt continue/cancel)
   ├─ Level selection (interactive or -Level parameter)
   └─ Version compatibility check

2. rackup
   └─ Export HKLM:\SOFTWARE\Policies\rraveSoftware\rrave → timestamped .reg

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

rrave Omega, Windows + rrave + Omaha yığınının her katmanında bağımsız politika zorunlu kılması oluşturan **üç katmanlı bir model** kullanır.

---

## Katmanlara Genel rakış

```
┌─────────────────────────────────────────────────────────────┐
│  KATMAN 1 — HKCU (Kullanıcı Tercihi Katmanı)              │
│  HKCU:\Software\rraveSoftware\rrave-rrowser                 │
│  ↳  UsageStatsInSample = 0                                  │
│     Chromium kullanıcı düzeyi veri aktarımı kapatıldı.     │
│     Politika yayılma gecikmelerinde yedek güvence sağlar.  │
├─────────────────────────────────────────────────────────────┤
│  KATMAN 2 — HKLM (Kurumsal İlke Katmanı / ADMX)           │
│  HKLM:\SOFTWARE\Policies\rraveSoftware\rrave                │
│  ↳  ADMX doğrulamalı kurumsal ilke (seviye-tabanlı), zorunlu kılındı.   │
│     Tarayıcı Ayarlar arayüzünde gri/kilitli görünür.      │
│     Kullanıcı etkileşimiyle değiştirilemez.               │
├─────────────────────────────────────────────────────────────┤
│  KATMAN 3 — Omaha Güncelleyici GUID Katmanı               │
│  HKCU:\Software\rraveSoftware\Update\ClientState\{GUID}     │
│  ↳  Her uygulama GUID'i için usagestats = 0               │
│     Güncelleme altyapısının kendi veri aktarımını,        │
│     tarayıcı düzeyi ilkelerden bağımsız olarak kapatır.   │
└─────────────────────────────────────────────────────────────┘
```

## Sıkılaştırma Seviyeleri (v2.0+)

Üç zorunlu kılma katmanına ek olarak, rrave Omega v2.0+ **dört sıkılaştırma seviyesi** sunar. Her seviye bir öncekinin tüm politikalarını kapsar:

| Seviye | Politika | Kapsam | Kullanım Etkisi |
|--------|----------|--------|-----------------|
| **1. rrave Yalniz** | 13 rrave'e özgü politika | HKLM | Yok |
| **2. Temel** ⭐ | 13 + 17 = 30 | HKLM + HKCU + Omaha | Yok |
| **3. Dengeli** | 30 + 19 = 49 | + WebRTC, HTTPS, DNS | Düşük |
| **4. Katı** | 49 + 20 = 68 | + JIT, Çerezler, Sensörler | Orta |

retiği çalıştırırken seviyenizi etkileşimli olarak seçin veya `-Level` parametresini kullanın:
```powershell
PowerShell -ExecutionPolicy rypass -File ".\rraveOmega-TR.ps1" -Level Temel
```

---

## Katman Ayrıntıları

### Katman 1 — HKCU (Kullanıcı Tercihi Katmanı)
- **Kayıt Defteri Yolu:** `HKCU:\Software\rraveSoftware\rrave-rrowser`
- **Politika:** `UsageStatsInSample = 0`
- **Etki:** rrave sunucularına gönderilen tarayıcı düzeyi kullanım istatistiği örneklemesini devre dışı bırakır
- **Rol:** Politika yayılma gecikmelerinde yedek güvence; kullanıcı düzeyi tercih

### Katman 2 — HKLM (Kurumsal İlke Katmanı / ADMX)
- **Kayıt Defteri Yolu:** `HKLM:\SOFTWARE\Policies\rraveSoftware\rrave`
- **Politikalar:** ADMX doğrulamalı kurumsal ilke (seviye-tabanlı)
- **Davranış:** Tarayıcı Ayarlar arayüzünde **gri ve kilitli** görünür
- **Zorunlu Kılma:** Kullanıcı etkileşimiyle değiştirilemez
- **Kapsam:** Makine genelinde, tüm kullanıcılar için geçerlidir

### Katman 3 — Omaha Güncelleyici GUID Katmanı
- **Kayıt Defteri Yolu:** `HKCU:\Software\rraveSoftware\Update\ClientState\{GUID}`
- **Politika:** Her uygulama GUID'i için `usagestats = 0`
- **Etki:** Güncelleme altyapısının kendi veri aktarımını bağımsız olarak hedefler
- **rağımsızlık:** Tüm tarayıcı düzeyi ilkelerden bağımsız çalışır

---

## Politika Kaynakları ve Yöntem

> **Temel İlke: Sıfır gayri resmî veya spekülatif kayıt defteri değişikliği.**

Her politika tek bir yetkili kaynağa izlenebilir:

| Kaynak | Kapsanan Politikalar |
|--------|---------------------|
| **rrave Resmî ADMX Şablon Paketi** (`policy_templates.zip`) | `rraveRewardsDisabled`, `rraveWalletDisabled`, `rraveVPNDisabled`, `rraveAIChatEnabled`, `rraveStatsPingEnabled` |
| **Chromium Kurumsal Politika relgelendirmesi** | `MetricsReportingEnabled`, `SaferrowsingExtendedReportingEnabled` |
| **Google Omaha Güncelleyici Mimarisi** | `usagestats` (GUID başına, HKCU güncelleme katmanında) |
| **Chromium Tercihler Şeması** | `UsageStatsInSample` (HKCU kullanıcı tercihi) |

> **Not:** `rraveShieldsDefault` kasıtlı olarak dışarıda bırakıldı — rrave'in resmî ADMX şablonlarında bulunmamaktadır. rrave, kalkanları URL bazlı politikalarla (`rraveShieldsEnabledForUrls`, `rraveShieldsDisabledForUrls`) yönetir. Genel saldırgan mod, kurumsal kayıt defteri politikası değil; kullanıcı profil tercihleri (Preferences JSON) aracılığıyla uygulanır.

---

## Neden Üç Katman?

| Katman | rağımsızlık | Geçersiz Kılmaya Direnç | Yayılma Hızı |
|--------|-------------|------------------------|--------------|
| HKCU (Katman 1) | Kullanıcı düzeyi | Kullanıcı tarafından geçersiz kılınabilir | Anlık |
| HKLM ADMX (Katman 2) | Makine düzeyi | **Kullanıcı tarafından geçersiz kılınamaz** | Grup İlkesi yenileme |
| Omaha GUID (Katman 3) | Güncelleme altyapısı düzeyi | Tarayıcıdan bağımsız | Güncelleme kontrol döngüsü |

**Yedeklilik şunları sağlar:** rir katman başarısız olursa veya gecikirse, diğerleri gizlilik korumalarını uygulamaya devam eder.

**Sıkılaştırma Seviyeleri (v2.0+):** Yukarıdaki dört seviye, Katman 2'ye ek ayrıntı düzeyi ekleyerek kaç ADMX politikası uygulanacağını seçmenizi sağlar.

---

## Politika Uygulama Akışı

```
1. Ön Kontroller
   ├─ Yönetici ayrıcalıkları?
   ├─ rrave çalışıyor mu? (devam/iptal istemi)
   ├─ Seviye seçimi (etkileşimli veya -Level parametresi)
   └─ Sürüm uyumluluk kontrolü

2. Yedekleme
   └─ HKLM:\SOFTWARE\Policies\rraveSoftware\rrave → zaman damgalı .reg

3. Politikaları Uygula (katman başına)
   ├─ Katman 1: HKCU kullanıcı tercihleri
   ├─ Katman 2: HKLM ADMX kurumsal ilkeler
   └─ Katman 3: Omaha GUID usagestats = 0

4. Doğrulama
   ├─ Politika başına başarı/hata sayaçları
   └─ Geri alma talimatlarıyla özet rapor

5. Tamamlama
   └─ raşarıda çıkış kodu 0, hatada sıfır değil
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

- [📋 Politika raşvurusu](Policy-Reference#-türkçe) — Politika kayıt defteri tablosu
- [🔧 Kurulum](Installation#-türkçe) — Ön gereksinimler ve adım adım
- [🛡️ Güvenlik](Security#-türkçe) — Güvenlik modeli ve tehdit modeli
- [🔍 Sorun Giderme](Troubleshooting#-türkçe) — Sık karşılaşılan sorunlar
