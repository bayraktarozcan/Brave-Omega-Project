> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 📊 Version Compatibility Matrix

Complete compatibility reference for Brave Omega versions.

---

## Current Compatibility Matrix

| Brave Omega | Brave Version | Chromium | Windows | Status | Release Date |
| ------------- | --------------- | ---------- | --------- | -------- | -------------- |
| **v2.4.1.0** ⭐ | 1.92.139 | 150.0.7871.176 | Windows 11 25H2 | ✅ Current | 2026-07-10 |
| **v2.3.0.0** | 1.92.138 | 150.0.7871.101 | Windows 11 25H2 | 📦 Previous | 2026-07-09 |
| **v2.2.1.0** | 1.92.134 | 150.0.7871.63 | Windows 11 25H2 | 📦 Previous | 2026-07-07 |
| **v2.2.0.1** | 1.92.134 | 150.0.7871.63 | Windows 11 25H2 | 📦 Previous | 2026-07-06 |
| **v2.2.0** | 1.92.134 | 150.0.7871.63 | Windows 11 25H2 | 📦 Previous | 2026-07-06 |
| **v2.1.6.0** | 1.92.134 | 150.0.7871.63 | Windows 11 25H2 | 📦 Previous | 2026-07-05 |
| **v2.1.5** | 1.92.134 | 150.0.7871.63 | Windows 11 25H2 | 📦 Previous | 2026-07-03 |
| **v2.1.4** | 1.91.180 | 149.0.7827.201 | Windows 11 25H2 | 📦 Previous | 2026-06-27 |
| **v2.1.3** | 1.91.178 | 149.0.7827.196 | Windows 11 25H2 | 📦 Previous | 2026-06-26 |
| v2.1.2 | 1.91.175 | 149.0.7827.155 | Windows 11 25H2 | 📦 Previous | 2026-06-18 |
| v2.1.1 | 1.91.172 | 149.0.7827.115 | Windows 11 25H2 | 📦 Previous | 2026-06-17 |
| v2.1 | 1.91.172 | 149 | Windows 11 25H2 | 📦 Previous | 2026-06-16 |
| v2.0 | 1.91.172 | 149 | Windows 11 25H2 | 📦 Previous | |
| v1.2.2 | 1.91.172 | 149.0.7827.115 | 11 25H2 | 📦 Previous | 2026-06-13 |
| v1.2.1 | 1.91.172 | 149.0.7827.115 | 11 25H2 | 📦 Previous | 2026-06-13 |
| v1.2 | 1.91.172 | 149.0.7827.115 | 11 25H2 | 📦 Previous | 2026-06-12 |
| v1.1 | 1.91.168 | 149.0.7827.115 | 11 25H2 | 📦 Previous | 2026-06-05 |
| v1.0 | 1.91.168 | 149.0.7827.115 | 11 25H2 | 🔒 Archived | 2026-06-04 |

---

## Legend

| Status | Meaning |
| -------- | --------- |
| ✅ **Active** | Current recommended version; fully tested and supported |
| 📦 **Previous** | Functional but superseded; upgrade recommended |
| 🔒 **Archived** | Legacy version; no longer supported or tested |

---

## Version Pinning Policy

Every Brave Omega release is **explicitly pinned** to:

- Exact Brave Browser version
- Exact Chromium version
- Validated Windows build

> **No ambiguity:** You always know exactly what environment the script was tested against.

---

## Version Selection Guide

### Use Current (v2.4.1.0) If

- Running Brave 1.92.139 (latest stable)
- Want the latest 5-tier hardening model (Brave Only/Essential/Balanced/Advanced/Strict)
- Need full extension lockdown, proxy enforcement, and 133 total policies

### Use Previous (v2.3.0.0) If

- Cannot update to v2.4.1.0 immediately
- Running Brave 1.92.138

### Use Legacy (v2.2.1.0) If

- Cannot update to v2.3.x immediately
- Running Brave 1.92.134
- Need hardware API blocking and ECH enforcement

### Avoid Archived (v1.0) If

- Policies outdated (only 7 vs 133 current)
- No backup/rollback, no process guard
- No lifecycle commitment features

---

## Brave Version Verification

### Check Your Brave Version

1. Open Brave
2. Navigate to `brave://version`
3. Compare **Version** and **Chromium** fields with matrix above

### Quick Check (PowerShell)

```powershell
# Get installed Brave version
$bravePath = "${env:ProgramFiles}\BraveSoftware\Brave-Browser\Application\brave.exe"
if (Test-Path $bravePath) {
    (Get-Item $bravePath).VersionInfo.FileVersion
}
```

---

## Compatibility Rules

| Scenario | Recommendation |
| ---------- | ---------------- |
| Brave newer than matrix | Check [Releases](https://github.com/bayraktarozcan/Brave-Omega-Project/releases) for updated Brave Omega |
| Brave older than matrix | Update Brave to latest stable first |
| Brave matches matrix | Use corresponding Brave Omega version |
| Windows build differs | Windows 11 25H2 recommended; other 25H2 builds likely compatible |

---

## Policy Coverage by Version

| Version | Policies | Coverage | New Policies |
| --------- | ---------- | ---------- | -------------- |
| v2.4.1.0 | 110 | 100% | ProxySettings added to Essential tier (1 new policy) |
| v2.3.0.0 | 110 | 100% | Safe Browsing protection level, password warning trigger, extension lockdown + forcelist, Incognito disable, developer tools disable, proxy, printing disable, Brave update disable (19 new) |
| v2.2.1.0 | 91 | 100% | WebUSB/Bluetooth/HID/Direct Sockets API blocking, ECH enforcement, Payment Request disable, window management isolation, site-per-process (12 new) |
| v2.2.0.2 | 80 | 100% | WebRTC alignment — Balanced upgraded to disable_non_proxied_udp (same as Strict), GitHub references removed |
| v2.2.0.1 | 80 | 100% | BraveLocalAIEnabled removed (deprecated), policy counts adjusted |
| v2.2.0 | 81 | 100% | 5-tier architecture (Brave Only/Essential/Balanced/Advanced/Strict), 11 policies migrated from Strict |
| v2.1.6.0 | 82 | 100% | BraveOnly enrichment (10), Chromium telemetry (6) |
| v2.1.5 | 68 | 100% | Chromium telemetry & data leakage policies |
| v2.1.4 | 68 | 100% | --- (Phase 3 prep) |
| v2.1.3 | 68 | 100% | --- |
| v2.1.2 | 68 | 100% | --- |
| v2.1.1 | 68 | 100% | --- |
| v2.1 | 68 | 100% | +61 (v2.1+) |
| v2.0 | 68 | 100% | --- |
| v1.2.2 | 17 | 100% | --- |
| v1.2.1 | 17 | 100% | --- |
| v1.2 | 17 | 100% | +10 (v1.2+) |
| v1.1 | 7 | 41% | --- |
| v1.0 | 7 | 41% | Base 7 |

---

## Windows Compatibility

| Windows Version | Support |
| ----------------- | --------- |
| Windows 11 25H2 | ✅ Fully Tested |
| Windows 11 24H2 | ✅ Likely Compatible |
| Windows 11 23H2 | ⚠️ Untested |
| Windows 10 | ❌ Not Supported |

> **Note:** ADMX policies require Windows 11 Enterprise/Pro for HKLM enforcement. Home edition may have limitations.

---

## Verification Checklist

Before running, verify:

- [ ] Brave version matches matrix for your Brave Omega version
- [ ] Chromium version matches
- [ ] Windows 11 25H2 (recommended)
- [ ] Administrator account available
- [ ] Brave Browser is **latest stable** (not Beta/Nightly)

---

## Related Pages

- [🚀 Quick Start](Quick-Start) — Get running
- [🔧 Installation](Installation) — Full setup guide
- [📜 Changelog](Changelog) — Full version history
- [📋 Policy Reference](Policy-Reference) — What policies each version includes

---

---

<a id="-türkçe"></a>

# 📊 Sürüm Uyumluluk Matrisi

Brave Omega sürümleri için tam uyumluluk referansı.

---

## Güncel Uyumluluk Matrisi

| Brave Omega | Brave Sürümü | Chromium | Windows | Durum | Yayın Tarihi |
| ------------- | -------------- | ---------- | --------- | ------- | -------------- |
| **v2.4.1.0** ⭐ | 1.92.139 | 150.0.7871.176 | Windows 11 25H2 | ✅ Güncel | 2026-07-10 |
| **v2.3.0.0** | 1.92.138 | 150.0.7871.101 | Windows 11 25H2 | 📦 Önceki | 2026-07-09 |
| **v2.2.1.0** | 1.92.134 | 150.0.7871.63 | Windows 11 25H2 | 📦 Önceki | 2026-07-07 |
| **v2.2.0.1** | 1.92.134 | 150.0.7871.63 | Windows 11 25H2 | 📦 Önceki | 2026-07-06 |
| **v2.2.0** | 1.92.134 | 150.0.7871.63 | Windows 11 25H2 | 📦 Önceki | 2026-07-06 |
| **v2.1.6.0** | 1.92.134 | 150.0.7871.63 | Windows 11 25H2 | 📦 Önceki | 2026-07-05 |
| **v2.1.5** | 1.92.134 | 150.0.7871.63 | Windows 11 25H2 | 📦 Önceki | 2026-07-03 |
| **v2.1.4** | 1.91.180 | 149.0.7827.201 | Windows 11 25H2 | 📦 Önceki | 2026-06-27 |
| **v2.1.3** | 1.91.178 | 149.0.7827.196 | Windows 11 25H2 | 📦 Önceki | 2026-06-26 |
| v2.1.2 | 1.91.175 | 149.0.7827.155 | Windows 11 25H2 | 📦 Önceki | 2026-06-18 |
| v2.1.1 | 1.91.172 | 149.0.7827.115 | Windows 11 25H2 | 📦 Önceki | 2026-06-17 |
| v2.1 | 1.91.172 | 149 | Windows 11 25H2 | 📦 Önceki | 2026-06-16 |
| v2.0 | 1.91.172 | 149 | Windows 11 25H2 | 📦 Önceki | |
| v1.2.2 | 1.91.172 | 149.0.7827.115 | 11 25H2 | 📦 Önceki | 2026-06-13 |
| v1.2.1 | 1.91.172 | 149.0.7827.115 | 11 25H2 | 📦 Önceki | 2026-06-13 |
| v1.2 | 1.91.172 | 149.0.7827.115 | 11 25H2 | 📦 Önceki | 2026-06-12 |
| v1.1 | 1.91.168 | 149.0.7827.115 | 11 25H2 | 📦 Önceki | 2026-06-05 |
| v1.0 | 1.91.168 | 149.0.7827.115 | 11 25H2 | 🔒 Arşivlendi | 2026-06-04 |

---

## Gösterge

| Durum | Anlamı |
| ------- | -------- |
| ✅ **Etkin** | Geçerli önerilen sürüm; tam test edilmiş ve destekleniyor |
| 📦 **Önceki** | İşlevsel ancak yerine yenisi geldi; yükseltme önerilir |
| 🔒 **Arşivlendi** | Eski sürüm; artık desteklenmiyor veya test edilmiyor |

---

## Sürüm Sabitleme Politikası

Her Brave Omega sürümü **açıkça şunlara sabitlenmiştir**:

- Tam Brave Browser sürümü
- Tam Chromium sürümü
- Doğrulanmış Windows derlemesi

> **Belirsizlik yok:** Betiğin hangi ortama karşı test edildiğini her zaman tam olarak bilirsiniz.

---

## Sürüm Seçim Kılavuzu

### Güncel (v2.4.1.0) Kullan Eğer

- Brave 1.92.139 (en güncel kararlı) çalışıyorsa
- En son 5 katmanlı sıkılaştırma modelini istiyorsanız (Brave Yalnız/Temel/Dengeli/Gelişmiş/Katı)
- Tam uzantı kilitleme, proxy zorunlu kılma ve 133 toplam politika

### Önceki (v2.3.0.0) Kullan Eğer

- Hemen v2.4.1.0'a güncelleyemiyorsanız
- Brave 1.92.138 çalışıyorsa

### Eski (v2.2.1.0) Kullan Eğer

- Hemen v2.3.x güncelleyemiyorsanız
- Brave 1.92.134 çalışıyorsa
- Donanım API engelleme ve ECH zorlamaya ihtiyacınız varsa

### Arşivlenmiş (v1.0) Kullanma Eğer

- Politikalar güncel değil (7'ye karşı 133)
- Yedekleme/geri alma, süreç koruyucusu yok
- Yaşam döngüsü taahhüdü özellikleri yok

---

## Brave Sürümü Doğrulama

### Brave Sürümünüzü Kontrol Edin

1. Brave'i açın
2. `brave://version` adresine gidin
3. **Sürüm** ve **Chromium** alanlarını yukarıdaki matrisle karşılaştırın

### Hızlı Kontrol (PowerShell)

```powershell
# Yüklü Brave sürümünü al
$bravePath = "${env:ProgramFiles}\BraveSoftware\Brave-Browser\Application\brave.exe"
if (Test-Path $bravePath) {
    (Get-Item $bravePath).VersionInfo.FileVersion
}
```

---

## Uyumluluk Kuralları

| Senaryo | Öneri |
| --------- | ------- |
| Brave matristen daha yeni | Güncellenmiş Brave Omega için [Sürümlere](https://github.com/bayraktarozcan/Brave-Omega-Project/releases) bakın |
| Brave matristen daha eski | Önce Brave'i en güncel kararlı sürüme güncelleyin |
| Brave matrisle eşleşiyor | İlgili Brave Omega sürümünü kullanın |
| Windows derlemesi farklı | Windows 11 25H2 önerilir; diğer 25H2 derlemeleri muhtemelen uyumludur |

---

## Sürüme Göre Politika Kapsamı

| Sürüm | Politika | Kapsam | Yeni Politikalar |
| ------- | ---------- | -------- | ------------------ |
| v2.4.1.0 | 110 | 100% | Temel kademesine ProxySettings eklendi (1 yeni politika) |
| v2.3.0.0 | 110 | 100% | Güvenli Gezinti koruma seviyesi, parola uyarı tetikleyicisi, uzantı kilitleme + zorunlu yükleme, gizli mod devre dışı, geliştirici araçları kapatma, proxy, yazdırma devre dışı, Brave güncellemesini durdurma (19 yeni) |
| v2.2.1.0 | 91 | 100% | WebUSB/Bluetooth/HID/Direct Sockets API engelleme, ECH zorlama, Payment Request devre dışı, pencere yönetimi yalıtımı, site başına süreç (12 yeni) |
| v2.2.0.2 | 80 | 100% | WebRTC hizalaması — Dengeli disable_non_proxied_udp'a yükseltildi (Katı ile aynı), GitHub atıfları kaldırıldı |
| v2.2.0.1 | 80 | 100% | BraveLocalAIEnabled kaldırıldı (kullanım dışı), politika sayıları düzeltildi |
| v2.2.0 | 81 | 100% | 5 katmanlı mimari (Brave Yalnız/Temel/Dengeli/Gelişmiş/Katı), Katı'dan 11 politika taşındı |
| v2.1.6.0 | 82 | 100% | BraveOnly zenginleştirme (10), Chromium telemetri (6) |
| v2.1.5 | 68 | 100% | Chromium telemetri ve veri sızıntısı politikaları |
| v2.1.4 | 68 | 100% | --- (3. Aşama hazırlık) |
| v2.1.3 | 68 | 100% | --- |
| v2.1.2 | 68 | 100% | --- |
| v2.1.1 | 68 | 100% | --- |
| v2.1 | 68 | 100% | +61 (v2.1+) |
| v2.0 | 68 | 100% | --- |
| v1.2.2 | 17 | 100% | --- |
| v1.2.1 | 17 | 100% | --- |
| v1.2 | 17 | 100% | +10 (v1.2+) |
| v1.1 | 7 | 41% | --- |
| v1.0 | 7 | 41% | Temel 7 |

---

## Windows Uyumluluğu

| Windows Sürümü | Destek |
| ---------------- | -------- |
| Windows 11 25H2 | ✅ Tam Test Edildi |
| Windows 11 24H2 | ✅ Muhtemelen Uyumlu |
| Windows 11 23H2 | ⚠️ Test Edilmedi |
| Windows 10 | ❌ Desteklenmiyor |

> **Not:** ADMX politikaları HKLM zorunlu kılması için Windows 11 Enterprise/Pro gerektirir. Home sürümünde sınırlamalar olabilir.

---

## Doğrulama Kontrol Listesi

Çalıştırmadan önce doğrulayın:

- [ ] Brave sürümü, Brave Omega sürümünüz için matrisle eşleşiyor
- [ ] Chromium sürümü eşleşiyor
- [ ] Windows 11 25H2 (önerilen)
- [ ] Yönetici hesabı mevcut
- [ ] Brave Browser **en güncel kararlı** sürüm (Beta/Nightly değil)

---

## İlgili Sayfalar

- [🚀 Hızlı Başlangıç](Quick-Start#-türkçe) — Çalıştırmaya başlayın
- [🔧 Kurulum](Installation#-türkçe) — Tam kurulum kılavuzu
- [📜 Değişiklik Günlüğü](Changelog#-türkçe) — Tam sürüm geçmişi
- [📋 Politika Başvurusu](Policy-Reference#-türkçe) — Her sürümün hangi politikaları içerdiği
