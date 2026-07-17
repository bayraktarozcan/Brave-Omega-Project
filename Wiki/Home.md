> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 🦁 Brave Omega Project — Wiki

> **Enterprise-Grade Browser Privacy Hardening for Brave Browser**
>
> Windows Registry Group Policy automation via PowerShell — Zero dependencies, ADMX-validated, fully bilingual (EN/TR)

---

## 📖 Quick Navigation

| Section | Description |
| --------- | ------------- |
| [🏠 Overview](Overview) | What is Brave Omega, why it exists, key concepts |
| [🚀 Quick Start](Quick-Start) | Get running in 3 minutes |
| [🏗️ Architecture](Architecture) | Multi-layer enforcement model, policy sources |
| [📋 Policy Reference](Policy-Reference) | Complete 133-policy registry reference |
| [🔧 Installation](Installation) | Prerequisites, execution policy, step-by-step |
| [🛡️ Security](Security) | Safety model, backup/rollback, process guard |
| [🔍 Troubleshooting](Troubleshooting) | Common issues and solutions |
| [🗺️ Roadmap](Roadmap) | Planned features and milestones |
| [🤝 Contributing](Contributing) | How to contribute, PR guidelines |
| [📜 Changelog](Changelog) | Version history and migration notes |

---

## 🦁 What is Brave Omega?

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

## ✨ Key Features

| Feature | Description |
| --------- | ------------- |
| 🔒 **Multi-Layer Enforcement** | HKCU + HKLM + Omaha GUID — independent enforcement layers |
| 📋 **ADMX-Validated Policies** | 133 policies (5 tiers, 24→52→83→104→133 chain), every entry sourced from Brave's official `policy_templates.zip` |
| 🔄 **Idempotent Execution** | Run any number of times — same safe, consistent result |
| 💾 **Automatic Backup** | Timestamped `.reg` backup of HKLM policy hive before any modifications |
| 🔁 **One-Command Rollback** | Full restoration: `reg import "<backup_file.reg>"` |
| 🛡️ **Brave Process Guard** | Detects running Brave instances, prompts continue/cancel |
| 📊 **Execution Summary** | Per-category success/failure counters with transparent reporting |
| 🌍 **Bilingual** | Full Turkish & English with identical functionality and parity |

---

## 🎯 Current Version

| Brave Omega | Brave Version | Chromium | Windows | Status |
| ------------- | --------------- | ---------- | --------- | -------- |
| **v2.4.1.0** *(current)* | 1.92.141 | 150 | 11 25H2 | ✅ Current |
| **v2.4.0.0** | 1.92.139 | 150 | 11 25H2 | 📦 Previous |
| **v2.3.1.0** | 1.92.138 | 150 | 11 25H2 | 📦 Previous |
| **v2.3.0.0** | 1.92.138 | 150 | 11 25H2 | 📦 Previous |
| **v2.2.1.0** | 1.92.134 | 150 | 11 25H2 | 📦 Previous |
| **v2.2.0.2** | 1.92.134 | 150 | 11 25H2 | 📦 Previous |
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

> **Latest Release:** [v2.4.1.0 — Brave 1.92.141 Validation](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/tag/v2.4.1.0)

> 🧪 **Pester test suite** (~50–60 It blocks across 16 files), PSScriptAnalyzer + policy integrity CI, and quality badges live since v2.1.6.0. See [Changelog](Changelog#v2160) for details.

---

## 🚀 Quick Links

- [📥 Download Latest Release](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/latest)
- [📖 Full Documentation (README)](https://github.com/bayraktarozcan/Brave-Omega-Project/blob/main/README.md)
- [📋 Policy Reference Table](Policy-Reference)
- [🔧 Installation Guide](Installation)
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

# 🦁 Brave Omega Project — Wiki

> **Brave Browser İçin Kurumsal Düzeyde Tarayıcı Gizlilik Sıkılaştırması**
>
> Windows Kayıt Defteri Grup İlkesi PowerShell otomasyonu — Sıfır bağımlılık, ADMX doğrulamalı, tamamen iki dilli (EN/TR)

---

## 📖 Hızlı Gezinme

| Bölüm | Açıklama |
| ------- | ---------- |
| [🏠 Genel Bakış](Overview#-türkçe) | Brave Omega nedir, neden var, temel kavramlar |
| [🚀 Hızlı Başlangıç](Quick-Start#-türkçe) | 3 dakikada çalıştırma |
| [🏗️ Mimari](Architecture#-türkçe) | Çok katmanlı uygulama modeli, politika kaynakları |
| [📋 Politika Başvurusu](Policy-Reference#-türkçe) | 133 politikalık kayıt defteri başvuru tablosu |
| [🔧 Kurulum](Installation#-türkçe) | Ön gereksinimler, çalıştırma ilkesi, adım adım |
| [🛡️ Güvenlik](Security#-türkçe) | Güvenlik modeli, yedekleme/geri alma, süreç koruyucu |
| [🔍 Sorun Giderme](Troubleshooting#-türkçe) | Sık karşılaşılan sorunlar ve çözümleri |
| [🗺️ Yol Haritası](Roadmap#-türkçe) | Planlanan özellikler ve kilometre taşları |
| [🤝 Katkıda Bulunma](Contributing#-türkçe) | Nasıl katkıda bulunulur, PR yönergeleri |
| [📜 Değişiklik Günlüğü](Changelog#-türkçe) | Sürüm geçmişi ve geçiş notları |

---

## 🦁 Brave Omega Nedir?

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

## ✨ Temel Özellikler

| Özellik | Açıklama |
| --------- | ---------- |
| 🔒 **Çok Katmanlı Uygulama** | HKCU + HKLM + Omaha GUID — bağımsız uygulama katmanları |
| 📋 **ADMX Doğrulamalı Politikalar** | 133 politika (5 kademe, 24→52→83→104→133 zinciri), her giriş Brave'in resmî `policy_templates.zip` dosyasından kaynaklanmıştır |
| 🔄 **Kararsız Olmayan Çalışma** | İstediğiniz kadar çalıştırın — aynı güvenli, tutarlı sonuç |
| 💾 **Otomatik Yedekleme** | Değişikliklerden önce HKLM politika kovası için zaman damgalı `.reg` yedeği |
| 🔁 **Tek Komutla Geri Alma** | Tam eski duruma dönüş: `reg import "<yedek_dosyası.reg>"` |
| 🛡️ **Brave Süreç Koruyucusu** | Çalışan Brave örneklerini tespit eder, devam/iptal istemi gösterir |
| 📊 **Yürütme Özeti** | Kategori bazında başarı/hata sayaçları ile şeffaf raporlama |
| 🌍 **İki Dilli** | Birebir işlevselliğe sahip tam Türkçe ve İngilizce sürümler |

---

## 🎯 Güncel Sürüm

| Brave Omega | Brave Sürümü | Chromium | Windows | Durum |
| ------------- | -------------- | ---------- | --------- | ------- |
| **v2.4.1.0** *(güncel)* | 1.92.141 | 150 | 11 25H2 | ✅ Etkin |
| **v2.4.0.0** | 1.92.139 | 150 | 11 25H2 | 📦 Önceki |
| **v2.3.1.0** | 1.92.138 | 150 | 11 25H2 | 📦 Önceki |
| **v2.3.0.0** | 1.92.138 | 150 | 11 25H2 | 📦 Önceki |
| **v2.2.1.0** | 1.92.134 | 150 | 11 25H2 | 📦 Önceki |
| **v2.2.0.2** | 1.92.134 | 150 | 11 25H2 | 📦 Önceki |
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

> **Son Sürüm:** [v2.4.1.0 — Brave 1.92.141 Doğrulaması](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/tag/v2.4.1.0)

---

## 🚀 Hızlı Bağlantılar

- [📥 Son Sürümü İndir](https://github.com/bayraktarozcan/Brave-Omega-Project/releases/latest)
- [📖 Tam Belgeler (README)](https://github.com/bayraktarozcan/Brave-Omega-Project/blob/main/README.md)
- [📋 Politika Başvuru Tablosu](Policy-Reference#-türkçe)
- [🔧 Kurulum Kılavuzu](Installation#-türkçe)
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
