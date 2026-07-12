> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 🗺️ Roadmap — Phased Execution Plan

Brave Omega's development roadmap — community-driven, lifecycle-first, organized into 8 execution phases.

---

## Current Version

**v2.3.0.0** — *Extension Lockdown, Proxy & Privacy Hardening* (2026-07-09)

Phase 8 complete: 133 policies across 5 hardening tiers (Brave Only 24 / Essential 52 / Balanced 83 / Advanced 104 / Strict 133).

---

## 8-Phase Execution History

### Phase 1 — Core Framework ✅ **Completed (v2.0)**

| Component | Description | Status |
|-----------|-------------|--------|
| 4-tier hardening model | Brave Only → Essential → Balanced → Strict | ✅ Complete |
| 68 total policies | Multi-string, DWord, String support | ✅ Complete |
| 3-layer enforcement | HKCU + HKLM ADMX + Omaha GUID | ✅ Complete |
| Turkish language support | Interactive level menu with `-Level` parameter | ✅ Complete |

Foundation of the script architecture: cumulative inheritance model where each level includes all policies from previous levels.

---

### Phase 2 — Safety & Rollback ✅ **Completed (v2.1)**

| Component | Description | Status |
|-----------|-------------|--------|
| Version detection | Auto-detect Brave binary version, compare, warn on mismatch | ✅ Complete |
| `-WhatIf` parameter | Dry-run mode with magenta [WhatIf] tags, no registry writes | ✅ Complete |
| `-Reset` parameter | Clean removal of all policies, empty key cleanup | ✅ Complete |
| GitHub Actions CI | ADMX validation workflow (weekly + manual trigger) | ✅ Complete |
| CONTRIBUTING.md | EN + TR contribution guides with issue templates | ✅ Complete |

---

### Phase 3 — Brave 1.92 Migration & Data Leakage ✅ **Completed (v2.1.5 → v2.2.0.2)**

| Component | Version | Status |
|-----------|---------|--------|
| Brave 1.92.134 / Chromium 150 migration | v2.1.5 | ✅ Complete |
| Chromium telemetry & data leakage policies | v2.1.5 | ✅ Complete |
| BraveOnly enrichment (10 new Brave policies) | v2.1.6.0 | ✅ Complete |
| Chromium telemetry blocking (6 new policies) | v2.1.6.0 | ✅ Complete |
| WebRTC alignment — Balanced→Strict upgrade | v2.2.0.2 | ✅ Complete |
| BraveLocalAIEnabled removal (deprecated) | v2.2.0.1 | ✅ Complete |

Cross-version Brave upgrade path: 1.91.172 → 1.92.134, Chromium 149 → 150.

---

### Phase 4 — Quality & Testing ✅ **Completed (v2.1.6.0)**

| Component | Description | Status |
|-----------|-------------|--------|
| Pester test suite | 16 test files under `Tests/` with ~50–60 It blocks | ✅ Complete |
| Unit tests | Write-PolicyValue, Level-Selection, Version-Check | ✅ Complete |
| Integration tests | Registry-Write, -WhatIf mode, admin detection, policy integrity | ✅ Complete |
| PSScriptAnalyzer | Code quality rules in CI workflow | ✅ Complete |
| Platform matrix | Windows Server 2025, Windows 11 25H2, Windows 10 22H2 | ✅ Complete |

---

### Phase 5 — Documentation & Distribution ✅ **Completed (v2.1.6.0)**

| Component | Description | Status |
|-----------|-------------|--------|
| Policy catalog | `docs/policy-catalog.md` with full per-policy metadata | ✅ Complete |
| Wiki consistency | Fix typos, encoding, policy numbers across all Wiki pages | ✅ Complete |
| Version reference standardization | Align CHANGELOG/Wiki, fix stale matrix | ✅ Complete |

---

### Phase 6 — Advanced Tier Addition ✅ **Completed (v2.2.0)**

| Component | Description | Status |
|-----------|-------------|--------|
| Advanced level (L4) | 72 cumulative policies — 11 migrated from Strict (L5) | ✅ Complete |
| Strict renumbered | L4 → L5 with 8 unique policies | ✅ Complete |
| 5-tier model | Brave Only 22 / Essential 47 / Balanced 72 / Advanced 83 / Strict 91 | ✅ Complete |
| `ImportBookmarks` | Deliberately retained in Strict for bookmark portability | ✅ Complete |

---

### Phase 7 — Hardware API & Security Hardening ✅ **Completed (v2.2.1.0)**

| Policy | Category | Level |
|--------|----------|-------|
| WebUakApiBlocked | Hardware API blocking | Brave Only |
| WebBluetoothApiBlocked | Hardware API blocking | Brave Only |
| WebHidApiBlocked | Hardware API blocking | Brave Only |
| WebSerialApiBlocked | Hardware API blocking | Brave Only |
| WebUsbApiBlocked | Hardware API blocking | Brave Only |
| WebXRBlocked | Hardware API blocking | Brave Only |
| EncryptedClientHelloEnabled | Security — ECH enforcement | Essential |
| PaymentRequestDisabled | Privacy | Balanced |
| WindowManagementBlocked | Isolation | Strict |
| SitePerProcess | Security — site isolation | Strict |
| DefaultBrowserSettingEnabled | Security — browser lock | Strict |

Total: 80→91 policies (+11). Phase milestone: 90+ policy barrier broken.

---

### Phase 8 — Extension Lockdown, Proxy & Privacy Hardening ✅ **Completed (v2.3.0.0)**

| Policy | Category | Level |
|--------|----------|-------|
| SafeBrowsingProtectionLevel | Security — safe browsing | Brave Only |
| PasswordProtectionWarningTrigger | Security — password protection | Brave Only |
| EnableOnlineRevocationChecks | Security — certificate checks | Essential |
| ExtensionInstallForcelist | Extension management | Balanced |
| DownloadRestrictions | Download control | Balanced |
| DownloadDirectory | Download control | Balanced |
| PromptForDownloadLocation | Download control | Balanced |
| ExtensionInstallBlocklist | Extension lockdown | Advanced |
| ExtensionInstallAllowlist | Extension lockdown | Advanced |
| ExtensionAllowedTypes | Extension lockdown | Advanced |
| BlockExternalExtensions | Extension lockdown | Advanced |
| ExtensionSettings | Extension lockdown | Advanced |
| ManifestV2Unsupported | Extension lockdown | Advanced |
| IncognitoModeAvailability | Privacy — incognito control | Strict |
| DeveloperToolsDisabled | Developer tools block | Advanced |
| DeveloperToolsAvailability | Developer tools block | Strict (moved from Advanced) |
| TaskManagerEndProcessEnabled | Process management | Strict |
| PrintingEnabled | Printing control | Strict |
| DisablePrintPreview | Printing control | Strict |
| ProxyMode | Network — proxy enforcement | Advanced |
| BuiltInDnsClientEnabled | Network — DNS control | Advanced |
| BraveUpdateDisabled | Update control | Advanced |

Total: 111→133 policies (+22). Cumulative chain: 24→52→83→104→133.

**Removed:** AllowPopupsDuringPageUnload (deprecated upstream, removed after initial 115-policy build).

---

## Versioning Strategy (4-Part)

| Component | Change Type | Example |
|-----------|-------------|--------|
| **Version** | Brave major rewrite, platform target change | v1.0.0.0 → v2.0.0.0 |
| **Major** | Script architecture/breaking change | v1.0.0.0 → v1.1.0.0 |
| **Minor** | Brave/Chromium upgrade or new policy added | v1.0.0.0 → v1.0.1.0 |
| **Revision** | Fix, revision, documentation update | v1.0.0.0 → v1.0.0.1 |

**Version Pinning:** Every release explicitly tagged with exact Brave + Chromium version.

---

## Release Cadence

| Trigger | Action |
|---------|--------|
| **Brave Stable Release** | ADMX diff review within 72h; patch release if policies changed |
| **Security Issue** | Emergency patch within 24h |
| **Translation Gaps** | Patch release within 1 week |
| **Feature Request** | Evaluated for next minor version |

---

## Upcoming

| Area | Description | Priority |
|------|-------------|----------|
| Cross-platform config | Linux JSON + macOS .plist output support | 📋 Medium |
| Intune/MDM guide | Enterprise deployment guide for Intune | 📋 Medium |
| Web-based configurator | Visual policy config on index.html | 💡 Low |
| Modular architecture | modules/*.psm1 + config.json refactor | 💡 Low |

---

## Community-Driven Priorities

| Area | How to Contribute |
|------|-------------------|
| **Version Updates** | Open PR with updated policy values + source reference |
| **New Policies** | Must source from official ADMX/Chromium docs |
| **Translations** | Follow EN/TR template; maintain functional parity |
| **Bug Reports** | Include Brave version, Windows version, full output |
| **Documentation** | Wiki edits, README improvements, examples |

---

## Lifecycle Commitment

> **A privacy hardening tool that falls out of date is not a safeguard — it is a false sense of security.**

| Commitment | Implementation |
|------------|----------------|
| **Version Pinning** | Every release tagged with exact Brave + Chromium version |
| **Policy Review** | ADMX diff on every Brave stable release |
| **Breaking Change Notices** | Changelog migration notes for removed/renamed keys |
| **Community Currency** | Version mismatches & new policies reviewed promptly |
| **Stable Recommendation** | Always recommends latest stable Brave |

---

## How to Influence Roadmap

| Action | Impact |
|--------|--------|
| 👍 **Upvote Issues** | Signals community priority |
| 💬 **Comment on Issues** | Shapes implementation approach |
| 🔀 **Submit PRs** | Direct contribution to codebase |
| 💬 **Discussions** | Long-form design discussions |
| 🌐 **Translations** | Expand language support |

---

## Related Pages

- [🤝 Contributing](Contributing) — How to contribute
- [📜 Changelog](Changelog) — Full version history
- [📋 Policy Reference](Policy-Reference) — Current policy set
- [🔧 Installation](Installation) — Current version install

---

---

<a id="-türkçe"></a>

# 🗺️ Yol Haritası — Aşamalı Uygulama Planı

Brave Omega geliştirme yol haritası — topluluk odaklı, yaşam döngüsü öncelikli, 8 aşamalı uygulama planı.

---

## Güncel Sürüm

**v2.3.0.0** — *Uzantı Kilitleme, Proxy ve Gizlilik Sıkılaştırması* (2026-07-09)

8. Aşama tamam: 5 sıkılaştırma katmanında 133 politika (Brave Yalnız 24 / Temel 52 / Dengeli 83 / Gelişmiş 104 / Katı 133).

---

## 8 Aşamalı Uygulama Geçmişi

### Aşama 1 — Temel Çerçeve ✅ **Tamamlandı (v2.0)**

| Bileşen | Açıklama | Durum |
|---------|----------|-------|
| 4 katmanlı model | Brave Yalnız → Temel → Dengeli → Katı | ✅ Tamam |
| 68 toplam politika | MultiString, DWord, String desteği | ✅ Tamam |
| 3 katmanlı zorlama | HKCU + HKLM ADMX + Omaha GUID | ✅ Tamam |
| Türkçe dil desteği | `-Level` parametresiyle etkileşimli seviye menüsü | ✅ Tamam |

Birikimli miras modeli: her seviye bir öncekinin tüm politikalarını kapsar.

---

### Aşama 2 — Güvenlik & Geri Alma ✅ **Tamamlandı (v2.1)**

| Bileşen | Açıklama | Durum |
|---------|----------|-------|
| Sürüm algılama | Brave binary sürümünü otomatik tespit, karşılaştır, uyar | ✅ Tamam |
| `-WhatIf` parametresi | Kuru çalıştırma, kayıt defteri yazma yok | ✅ Tamam |
| `-Reset` parametresi | Tüm politikaları temiz kaldır | ✅ Tamam |
| GitHub Actions CI | ADMX doğrulama iş akışı | ✅ Tamam |
| CONTRIBUTING.md | EN + TR katkı kılavuzları | ✅ Tamam |

---

### Aşama 3 — Brave 1.92 Geçişi & Veri Sızıntısı ✅ **Tamamlandı (v2.1.5 → v2.2.0.2)**

| Bileşen | Sürüm | Durum |
|---------|-------|-------|
| Brave 1.92.134 / Chromium 150 geçişi | v2.1.5 | ✅ Tamam |
| Chromium telemetri ve veri sızıntısı politikaları | v2.1.5 | ✅ Tamam |
| BraveOnly zenginleştirme (10 yeni Brave politikası) | v2.1.6.0 | ✅ Tamam |
| Chromium telemetri engelleme (6 yeni politika) | v2.1.6.0 | ✅ Tamam |
| WebRTC hizalaması — Dengeli→Katı yükseltmesi | v2.2.0.2 | ✅ Tamam |
| BraveLocalAIEnabled kaldırma (kullanım dışı) | v2.2.0.1 | ✅ Tamam |

---

### Aşama 4 — Kalite & Test ✅ **Tamamlandı (v2.1.6.0)**

| Bileşen | Açıklama | Durum |
|---------|----------|-------|
| Pester test takımı | `Tests/` altında 16 test dosyası, ~50–60 It bloğu | ✅ Tamam |
| Birim testleri | Write-PolicyValue, Level-Selection, Version-Check | ✅ Tamam |
| Entegrasyon testleri | Registry-Write, -WhatIf, yönetici algılama | ✅ Tamam |
| PSScriptAnalyzer | CI'da kod kalite kuralları | ✅ Tamam |
| Platform matrisi | Windows Server 2025, 11 25H2, 10 22H2 | ✅ Tamam |

---

### Aşama 5 — Dokümantasyon & Dağıtım ✅ **Tamamlandı (v2.1.6.0)**

| Bileşen | Açıklama | Durum |
|---------|----------|-------|
| Politika kataloğu | `docs/policy-catalog.md` tam meta verili | ✅ Tamam |
| Wiki tutarlılığı | Tüm Wiki sayfalarında yazım/kodlama düzeltmesi | ✅ Tamam |
| Sürüm referansı | CHANGELOG/Wiki uyumu, güncel matris | ✅ Tamam |

---

### Aşama 6 — Gelişmiş Katman Ekleme ✅ **Tamamlandı (v2.2.0)**

| Bileşen | Açıklama | Durum |
|---------|----------|-------|
| Gelişmiş seviye (L4) | 72 kümülatif politika — 11 politika Katı'dan taşındı | ✅ Tamam |
| Katı yeniden numaralandırma | L4 → L5, 8 benzersiz politika | ✅ Tamam |
| 5 katmanlı model | Brave Yalnız 22 / Temel 47 / Dengeli 72 / Gelişmiş 83 / Katı 91 | ✅ Tamam |
| `ImportBookmarks` | Yer imi taşınabilirliği için Katı'da tutuldu | ✅ Tamam |

---

### Aşama 7 — Donanım API & Güvenlik Sıkılaştırması ✅ **Tamamlandı (v2.2.1.0)**

11 yeni politika: WebUSB, WebBluetooth, WebHID, WebSerial, WebUSB, WebXR engelleme, ECH zorlama, Payment Request devre dışı, WindowManagement izolasyonu, SitePerProcess, DefaultBrowserSetting.

Toplam: 80→91 politika (+11). 90+ politika engeli aşıldı.

---

### Aşama 8 — Uzantı Kilitleme, Proxy & Gizlilik Sıkılaştırması ✅ **Tamamlandı (v2.3.0.0)**

22 yeni politika: SafeBrowsingProtectionLevel, PasswordProtectionWarningTrigger, EnableOnlineRevocationChecks, ExtensionInstallForcelist, DownloadRestrictions, DownloadDirectory, PromptForDownloadLocation, ExtensionInstallBlocklist, ExtensionInstallAllowlist, ExtensionAllowedTypes, BlockExternalExtensions, ExtensionSettings, ManifestV2Unsupported, IncognitoModeAvailability, DeveloperToolsDisabled, DeveloperToolsAvailability, TaskManagerEndProcessEnabled, PrintingEnabled, DisablePrintPreview, ProxyMode, BuiltInDnsClientEnabled, BraveUpdateDisabled.

Toplam: 111→133 politika (+22). Kümülatif zincir: 24→52→83→104→133.

**Kaldırılan:** AllowPopupsDuringPageUnload (kullanım dışı, ilk 115'lik yapıdan sonra çıkarıldı).

---

## Sürümleme Stratejisi (4 Parçalı)

| Bileşen | Değişiklik Türü | Örnek |
|---------|-----------------|-------|
| **Version** | Brave major yeniden yazımı, hedef platform değişikliği | v1.0.0.0 → v2.0.0.0 |
| **Major** | Betik mimarisi/kırılım değişikliği | v1.0.0.0 → v1.1.0.0 |
| **Minor** | Brave/Chromium yükseltmesi veya yeni politika eklendi | v1.0.0.0 → v1.0.1.0 |
| **Revision** | Düzeltme, revizyon, doküman güncellemesi | v1.0.0.0 → v1.0.0.1 |

**Sürüm Sabitleme:** Her sürüm, tam Brave + Chromium sürümüyle açıkça etiketlenir.

---

## Sürüm Takvimi

| Tetikleyici | Eylem |
|-------------|-------|
| **Brave Kararlı Sürümü** | 72 saat içinde ADMX fark incelemesi; politikalar değiştiyse yama sürümü |
| **Güvenlik Sorunu** | 24 saat içinde acil yama |
| **Çeviri Eksiklikleri** | 1 hafta içinde yama sürümü |
| **Özellik Talebi** | Sonraki alt sürüm için değerlendirilir |

---

## Gelecek

| Alan | Açıklama | Öncelik |
|------|----------|---------|
| Platformlar arası yapılandırma | Linux JSON + macOS .plist çıktı desteği | 📋 Orta |
| Intune/MDM kılavuzu | Kurumsal dağıtım kılavuzu | 📋 Orta |
| Web tabanlı yapılandırıcı | index.html üzerinde görsel politika yapılandırma | 💡 Düşük |
| Modüler mimari | modules/*.psm1 + config.json yeniden düzenleme | 💡 Düşük |

---

## Topluluk Odaklı Öncelikler

| Alan | Nasıl Katkıda Bulunulur |
|------|------------------------|
| **Sürüm Güncellemeleri** | Güncellenmiş politika değerleri + kaynak referansıyla PR açın |
| **Yeni Politikalar** | Resmî ADMX/Chromium belgelerinden kaynaklanmış olmalıdır |
| **Çeviriler** | EN/TR şablonunu izleyin; işlevsel eşdeğerliği koruyun |
| **Hata Raporları** | Brave sürümü, Windows sürümü, tam çıktı dahil |
| **Belgelendirme** | Wiki düzenlemeleri, README iyileştirmeleri, örnekler |

---

## Yaşam Döngüsü Taahhüdü

> **Güncelliğini yitiren bir gizlilik sıkılaştırma aracı, güvenlik güvencesi değil — yanlış bir güvenlik duygusudur.**

| Taahhüt | Uygulama |
|---------|----------|
| **Sürüm Sabitleme** | Her sürüm, tam Brave + Chromium sürümüyle etiketlenir |
| **Politika İncelemesi** | Her Brave kararlı sürümünde ADMX farkı |
| **Kırıcı Değişiklik Bildirimleri** | Kaldırılan/yeniden adlandırılan anahtarlar için değişiklik günlüğü geçiş notları |
| **Topluluk Güncelliği** | Sürüm uyuşmazlıkları ve yeni politikalar hızla incelenir |
| **Kararlı Sürüm Önerisi** | Her zaman en güncel kararlı Brave'i önerir |

---

## Yol Haritasını Etkileme

| Eylem | Etki |
|-------|------|
| 👍 **Sorunları Oylama** | Topluluk önceliğini belirtir |
| 💬 **Sorunlara Yorum Yapma** | Uygulama yaklaşımını şekillendirir |
| 🔀 **PR Gönderme** | Kod tabanına doğrudan katkı |
| 💬 **Tartışmalar** | Uzun biçimli tasarım tartışmaları |
| 🌐 **Çeviriler** | Dil desteğini genişletme |

---

## İlgili Sayfalar

- [🤝 Katkıda Bulunma](Contributing#-türkçe) — Nasıl katkıda bulunulur
- [📜 Değişiklik Günlüğü](Changelog#-türkçe) — Tam sürüm geçmişi
- [📋 Politika Başvurusu](Policy-Reference#-türkçe) — Güncel politika seti
- [🔧 Kurulum](Installation#-türkçe) — Güncel sürüm kurulumu
