> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 🦁 Brave Omega — Overview

## What is Brave Omega?

**Brave Omega** is an open-source PowerShell automation project that hardens **Brave Browser** through **official enterprise policy channels**.

Using **Windows Registry Group Policy architecture** and **Brave's official ADMX policy framework**, it systematically disables:

- Telemetry & analytics services
- Background pings & network calls
- Integrated monetization features (Rewards, Wallet, VPN)
- AI chat engines (Leo)
- Web discovery & data contribution services
- Attack surface components (Tor, Speedreader, Wayback Machine)

**All without touching browser internals or requiring third-party tools.**

> **Two scripts. One goal. Zero cost.**
>
> - `BraveOmega-EN.ps1` — Full English interface
> - `BraveOmega-TR.ps1` — Full Turkish interface

---

## Why Brave Omega Exists

Enterprise browser hardening typically demands one of two things:

1. Deep technical expertise in ADMX policy frameworks and registry architecture
2. An expensive premium product subscription

**Brave Omega rejects both constraints.**

**Everything needed to achieve serious, registry-enforced browser privacy hardening is already present in the free, open-source Brave Browser.**

- The enforcement architecture lives in Brave's official ADMX templates
- The mechanism is built into Windows Registry Group Policy
- The knowledge exists in the official documentation

**The only missing piece was a validated, automated, and well-documented bridge between these components.**

Brave Omega builds that bridge — and keeps it current throughout the browser's lifecycle.

---

## Key Features

| Feature | Description |
| --------- | ------------- |
| 🔒 **Multi-Layer Enforcement (HKCU + HKLM + Omaha)** | HKCU (user) + HKLM (enterprise/ADMX) + Omaha GUID — three independent enforcement layers |
| 📋 **ADMX-Validated Policies** | 111 ADMX-Validated Policies (5 tiers, 24→49→78→97→110 chain), every entry sourced from Brave's official `policy_templates.zip` |
| 🔄 **Idempotent Execution** | Run any number of times — same safe, consistent result |
| 💾 **Automatic Backup** | Timestamped `.reg` backup of HKLM policy hive before any modifications |
| 🔁 **One-Command Rollback** | Full restoration: `reg import "<backup_file.reg>"` |
| 🛡️ **Brave Process Guard** | Detects running Brave instances, prompts continue/cancel |
| 📊 **Execution Summary** | Per-category success/failure counters with transparent reporting |
| 🌍 **Bilingual** | Full Turkish & English with identical functionality and parity |

---

## Current Version

| Brave Omega | Brave Version | Chromium | Windows | Status |
| ------------- | --------------- | ---------- | --------- | -------- |
| **v2.3.0.0** *(current)* | 1.92.138 | 150 | 11 25H2 | ✅ Current |
| **v2.2.1.0** | 1.92.134 | 150 | 11 25H2 | 📦 Previous |
| **v2.2.0.1** | 1.92.134 | 150 | 11 25H2 | 📦 Previous |
| **v2.2.0** | 1.92.134 | 150 | 11 25H2 | 📦 Previous |
| **v2.1.6.0** | 1.92.134 | 150 | 11 25H2 | 📦 Previous |
| **v2.1.5** | 1.92.134 | 150 | 11 25H2 | 📦 Previous |
| **v2.1.4** | 1.91.180 | 149 | 11 25H2 | 📦 Previous |
| **v2.1.3** | 1.91.178 | 149 | 11 25H2 | 📦 Previous |
| v2.1.2 | 1.91.175 | 149 | 11 25H2 | 📦 Previous |
| v2.1 | 1.91.172 | 149 | 11 25H2 | 📦 Previous |
| v2.0 | 1.91.172 | 149 | 11 25H2 | 📦 Previous |
| v1.2.2 | 1.91.172 | 149 | 11 25H2 | 📦 Previous |
| v1.2.1 | 1.91.172 | 149 | 11 25H2 | 📦 Previous |
| v1.2 | 1.91.172 | 149 | 11 25H2 | 📦 Previous |
| v1.1 | 1.91.168 | 149 | 11 25H2 | 📦 Previous |
| v1.0 | 1.91.168 | 149 | 11 25H2 | 🔒 Archived |

> **Latest Release:** [v2.3.0.0 — Enterprise Policy Expansion (Phase 8)](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/tag/v2.3.0.0)

---

## Quick Links

- [📥 Latest Release](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/latest)
- [📖 Main README](https://github.com/bayraktarozcan/Brave-Omega-Project/blob/main/README.md)
- [📋 Policy Reference](Policy-Reference)
- [🔧 Installation](Installation)
- [🔍 Troubleshooting](Troubleshooting)
- [🗺️ Roadmap](Roadmap)
- [🤝 Contributing](Contributing)
- [📜 Changelog](Changelog)

---

## ⚠️ Important Disclaimer

> **Brave Omega is an independent community project** and is **not affiliated with, endorsed by, or officially connected to Brave Software, Inc.** in any way.
>
> The Brave name and logo are registered trademarks of Brave Software, Inc.
>
> All registry modifications are performed at the user's own risk. Always verify backups, test in a non-production environment first, and review the source code before executing in any managed or enterprise setting.

---

*Built with care. Maintained with purpose.* 🦁

---

---

<a id="-türkçe"></a>

# 🦁 Brave Omega — Genel Bakış

## Brave Omega Nedir?

**Brave Omega**, **Brave Browser**'ı **resmî kurumsal politika kanalları** aracılığıyla sıkılaştıran açık kaynaklı bir PowerShell özdevim projesidir.

**Windows Kayıt Defteri Grup İlkesi mimarisi** ve **Brave'in resmî ADMX politika çerçevesi** kullanılarak sistematik biçimde devre dışı bırakılanlar:

- Veri aktarımı (telemetri) ve analiz hizmetleri
- Arka plan pingleri ve ağ çağrıları
- Tümleşik para kazanma özellikleri (Rewards, Cüzdan, VPN)
- Yapay zekâ sohbet motorları (Leo)
- Web keşfi ve veri katkı hizmetleri
- Saldırı yüzeyi bileşenleri (Tor, Speedreader, Wayback Machine)

**Tümü, tarayıcının iç yapısına dokunmadan veya üçüncü taraf araç gerektirmeden.**

> **İki betik. Tek hedef. Sıfır maliyet.**
>
> - `BraveOmega-EN.ps1` — Tam İngilizce arayüz
> - `BraveOmega-TR.ps1` — Tam Türkçe arayüz

---

## Brave Omega Neden Var?

Kurumsal düzeyde tarayıcı gizlilik sıkılaştırması iki şeyden birini gerektirir:

1. ADMX politika çerçeveleri ve kayıt defteri mimarisine derin teknik hâkimiyet
2. Pahalı bir ücretli ürün aboneliği

**Brave Omega her iki kısıtlamayı da ortadan kaldırır.**

**Ciddi, kayıt defteri düzeyinde zorunlu kılınan tarayıcı gizlilik sıkılaştırması için gereken her şey, ücretsiz ve açık kaynaklı Brave Browser içinde zaten mevcuttur.**

- Zorunlu kılma mimarisi Brave'in resmî ADMX şablonlarında hazır durumdadır
- Düzenek, Windows Kayıt Defteri Grup İlkesi içine yerleşik şekilde çalışır
- Bilgi resmî belgelendirmede açıktır

**Tek eksik olan; bu bileşenler arasında doğrulanmış, otomatize edilmiş ve iyi belgelenmiş bir köprüydü.**

Brave Omega o köprüyü inşa eder — ve tarayıcının yaşam döngüsü boyunca güncel tutar.

---

## Temel Özellikler

| Özellik | Açıklama |
| --------- | ---------- |
| 🔒 **Çok Katmanlı Zorunlu Kılma (HKCU + HKLM + Omaha)** | HKCU (kullanıcı) + HKLM (kurumsal/ADMX) + Omaha GUID — üç bağımsız zorunlu kılma katmanı |
| 📋 **ADMX Doğrulamalı Politikalar** | 110 ADMX Doğrulamalı Politika (5 kademe, 24→49→78→97→110 zinciri), her giriş Brave'in resmî `policy_templates.zip` dosyasından kaynaklanmıştır |
| 🔄 **Kararsız Olmayan Çalışma** | İstediğiniz kadar çalıştırın — aynı güvenli, tutarlı sonuç |
| 💾 **Otomatik Yedekleme** | Değişikliklerden önce HKLM politika kovası için zaman damgalı `.reg` yedeği |
| 🔁 **Tek Komutla Geri Alma** | Tam eski duruma dönüş: `reg import "<yedek_dosyası.reg>"` |
| 🛡️ **Brave Süreç Koruyucusu** | Çalışan Brave örneklerini tespit eder, devam/iptal istemi gösterir |
| 📊 **Yürütme Özeti** | Kategori bazında başarı/hata sayaçları ile şeffaf raporlama |
| 🌍 **İki Dilli** | Birebir işlevselliğe sahip tam Türkçe ve İngilizce sürümler |

---

## Güncel Sürüm

| Brave Omega | Brave Sürümü | Chromium | Windows | Durum |
| ------------- | -------------- | ---------- | --------- | ------- |
| **v2.3.0.0** *(güncel)* | 1.92.138 | 150 | 11 25H2 | ✅ Etkin |
| **v2.2.1.0** | 1.92.134 | 150 | 11 25H2 | 📦 Önceki |
| **v2.2.0.1** | 1.92.134 | 150 | 11 25H2 | 📦 Önceki |
| **v2.2.0** | 1.92.134 | 150 | 11 25H2 | 📦 Önceki |
| **v2.1.6.0** | 1.92.134 | 150 | 11 25H2 | 📦 Önceki |
| **v2.1.5** | 1.92.134 | 150 | 11 25H2 | 📦 Önceki |
| **v2.1.4** | 1.91.180 | 149 | 11 25H2 | 📦 Önceki |
| **v2.1.3** | 1.91.178 | 149 | 11 25H2 | 📦 Önceki |
| v2.1.2 | 1.91.175 | 149 | 11 25H2 | 📦 Önceki |
| v2.1 | 1.91.172 | 149 | 11 25H2 | 📦 Önceki |
| v2.0 | 1.91.172 | 149 | 11 25H2 | 📦 Önceki |
| v1.2.2 | 1.91.172 | 149 | 11 25H2 | 📦 Önceki |
| v1.2.1 | 1.91.172 | 149 | 11 25H2 | 📦 Önceki |
| v1.2 | 1.91.172 | 149 | 11 25H2 | 📦 Önceki |
| v1.1 | 1.91.168 | 149 | 11 25H2 | 📦 Önceki |
| v1.0 | 1.91.168 | 149 | 11 25H2 | 🔒 Arşivlendi |

> **Son Sürüm:** [v2.3.0.0 — Kurumsal Politika Genişletmesi (Aşama 8)](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/tag/v2.3.0.0)

---

## Hızlı Bağlantılar

- [📥 Son Sürüm](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/latest)
- [📖 Ana README](https://github.com/bayraktarozcan/Brave-Omega-Project/blob/main/README.md)
- [📋 Politika Başvurusu](Policy-Reference#-türkçe)
- [🔧 Kurulum](Installation#-türkçe)
- [🔍 Sorun Giderme](Troubleshooting#-türkçe)
- [🗺️ Yol Haritası](Roadmap#-türkçe)
- [🤝 Katkıda Bulunma](Contributing#-türkçe)
- [📜 Değişiklik Günlüğü](Changelog#-türkçe)

---

## ⚠️ Önemli Sorumluluk Reddi

> **Brave Omega, bağımsız bir topluluk projesidir** ve hiçbir şekilde **Brave Software, Inc. ile bağlantılı, onun tarafından onaylanmış veya resmî olarak ilişkili değildir.**
>
> Brave adı ve logosu, Brave Software, Inc.'in tescilli markalarıdır.
>
> Tüm kayıt defteri değişiklikleri kullanıcının kendi sorumluluğundadır. Yönetilen ya da kurumsal bir ortamda çalıştırmadan önce her zaman yedekleri doğrulayın, üretim dışı bir ortamda sınayın ve kaynak kodu inceleyin.

---

*Özenle inşa edildi. Amaçla sürdürülüyor.* 🦁
