> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 🗺️ Roadmap — Phased Execution Plan

Brave Omega's development roadmap — community-driven, lifecycle-first, organized into 6 execution phases.

---

## Current Version

**v1.0.0.0** — *Prompt Framework Baseline* (2026-07-04)

Phase 0 (Hazırlık / Preparation) baseline established:

- 13 sequentially numbered prompt files (`01-surum-guncelleme.md` through `13-moduler-mimari.md`)
- 4-part versioning scheme (version.major.minor.revision)
- All prompts start at `v1.0.0.0`
- GitHub Project #4: "Brave Omega Project" (11 items: 5 closed, 6 open)
- Quality pipeline active: markdownlint (all 13 prompts clean), yamllint, PowerShell syntax check

---

## 6-Phase Execution Plan

### Phase 0 — Hazırlık / Preparation

| Prompt | Description | Status |
|--------|-------------|--------|
| `01-surum-guncelleme.md` | Brave version reference update across all files | 🔲 Pending |

Updates Brave (1.92.134), Chromium (150), Windows (11 25H2) references across:

- `Brave Omega/BraveOmega-EN.ps1` — `$ScriptVersion`, `$ValidatedBrave`, `$ValidatedChromium`
- `Brave Omega/BraveOmega-TR.ps1` — same constants
- `README.md`, `index.html`, `CHANGELOG.md`, `Wiki/` files
- `.github/workflows/admx-validate.yml` — Chromium version pin

---

### Phase 1 — Denetim / Audit (Parallel 4 Prompts)

| Prompt | Description | Status |
| -------- | ------------- | -------- |
| `02-politika-bosluk-analizi.md` | Policy gap analysis — identify 13 missing Brave policies | 🔲 Pending |
| `03-politika-deger-dogrulama.md` | Policy value validation — verify defaults, ranges, ADMX enums | 🔲 Pending |
| `04-deprecated-temizlik.md` | Remove 4 Chromium deprecated policies | 🔲 Pending |
| `05-referans-guncelleme.md` | Update Brave-Group-Policy-Reference.md line numbers | 🔲 Pending |

Key outcomes:

- Complete inventory of all 28 Brave+Chromium reference policies vs. 13 implemented
- Value validation for every policy (DWord ranges, String patterns, MultiString arrays)
- Clean removal of deprecated CloudPrintProxyEnabled, etc.
- Reference doc line numbers match current state

---

### Phase 2 — Uygulama / Implementation

| Prompt | Description | Status |
|--------|-------------|--------|
| `06-politika-ekleme-brave.md` | Add 13 missing Brave policies to both scripts | 🔲 Pending |

Adds in priority order:

1. **Zero user impact, max privacy:** BraveDeAmpEnabled, BraveDebouncingEnabled, BraveGlobalPrivacyControlEnabled, BraveReduceLanguageEnabled, BraveTrackingQueryParametersFilteringEnabled, BraveLocalAIEnabled → Brave Yalnız tier (13→23)
2. **Default protection levels:** DefaultBraveAdblockSetting, DefaultBraveFingerprintingV2Setting, DefaultBraveHttpsUpgradeSetting, DefaultBraveReferrersSetting, DefaultBraveRemember1PStorageSetting → Temel tier
3. **Enterprise/control:** EmailAliasesEnabled, BraveSyncUrl → Dengeli tier

Total: 67→81 policies across 4 tiers.

---

### Phase 3 — Kalite & Test / Quality & Testing ✅ **Completed (v2.1.6.0)**

| Prompt | Description | Status |
|--------|-------------|--------|
| `07-pester-test.md` | Pester test suite for EN script | ✅ Completed |
| `08-pssa-ekleme.md` | PSScriptAnalyzer integration for CI | ✅ Completed |

Deliverables:

- 16 Pester test files under `Tests/` with ~50–60 It blocks
- Unit tests: Write-PolicyValue, Level-Selection, Version-Check
- Integration tests: Registry-Write, -WhatIf mode, admin detection, policy integrity
- PSScriptAnalyzer rules in CI quality workflow (`Invoke-PSScriptAnalyzer`)
- Platform matrix: Windows Server 2025, Windows 11 25H2, Windows 10 22H2
- QA report: `docs/reports/phase-3-kalite-test/`
- Issue #30 tracked on GitHub
- Quality badges: test pass rate, code coverage, CI status

---

### Phase 4 — Dokümantasyon/Yaygınlaştırma / Documentation & Distribution

| Prompt | Description | Status |
|--------|-------------|--------|
| `07-politika-katalogu.md` | Create docs/policy-catalog.md with full metadata | ✅ Completed |

Policy catalog with per-policy: ID, source, tier, min. Chromium, type, default, recommended, risk, ADMX validation date, notes.

---

### Phase 5 — Gelişmiş / Advanced

| Prompt | Description | Status |
| -------- | ------------- | -------- |
| `09-cross-platform-config.md` | Linux JSON + macOS .plist output support | 🔲 Pending |
| `10-intune-mdm.md` | Intune/MDM deployment guide | 🔲 Pending |
| `12-web-arayuzu.md` | Web-based policy configurator on index.html | 🔲 Pending |
| `13-moduler-mimari.md` | Modular architecture (modules/*.psm1 + config.json) | 🔲 Pending |

---

## Versioning Strategy (4-Part)

| Component | Change Type | Example |
| ----------- | ------------- | --------- |
| **Version** | Brave major rewrite, platform target change | v1.0.0.0 → v2.0.0.0 |
| **Major** | Script architecture/breaking change | v1.0.0.0 → v1.1.0.0 |
| **Minor** | Brave/Chromium upgrade or new policy added | v1.0.0.0 → v1.0.1.0 |
| **Revision** | Fix, revision, documentation update | v1.0.0.0 → v1.0.0.1 |

**Version Pinning:** Every release explicitly tagged with exact Brave + Chromium version.

---

## Release Cadence

| Trigger | Action |
| --------- | -------- |
| **Brave Stable Release** | ADMX diff review within 72h; patch release if policies changed |
| **Security Issue** | Emergency patch within 24h |
| **Translation Gaps** | Patch release within 1 week |
| **Feature Request** | Evaluated for next minor version |

---

## Community-Driven Priorities

| Area | How to Contribute |
| ------ | ------------------- |
| **Version Updates** | Open PR with updated policy values + source reference |
| **New Policies** | Must source from official ADMX/Chromium docs |
| **Translations** | Follow EN/TR template; maintain functional parity |
| **Bug Reports** | Include Brave version, Windows version, full output |
| **Documentation** | Wiki edits, README improvements, examples |

---

## Lifecycle Commitment

> **A privacy hardening tool that falls out of date is not a safeguard — it is a false sense of security.**

| Commitment | Implementation |
| ------------ | ---------------- |
| **Version Pinning** | Every release tagged with exact Brave + Chromium version |
| **Policy Review** | ADMX diff on every Brave stable release |
| **Breaking Change Notices** | Changelog migration notes for removed/renamed keys |
| **Community Currency** | Version mismatches & new policies reviewed promptly |
| **Stable Recommendation** | Always recommends latest stable Brave |

---

## How to Influence Roadmap

| Action | Impact |
| -------- | -------- |
| 👍 **Upvote Issues** | Signals community priority |
| 💬 **Comment on Issues** | Shapes implementation approach |
| 🔀 **Submit PRs** | Direct contribution to codebase |
| 💬 **Discussions** | Long-form design discussions |
| 🌐 **Translations** | Expand language support |

---

## Tracking

All phased work tracked in **GitHub Project #4 — "Brave Omega Project"**:

- [Project Board](https://github.com/bayraktarozcan/Brave-Omega-Project/projects/4)
- 6 open issues (#25–#30) mapped to phases
- Phase completion = issue closure

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

Brave Omega geliştirme yol haritası — topluluk odaklı, yaşam döngüsü öncelikli, 6 aşamalı uygulama planı.

---

## Güncel Sürüm

**v1.0.0.0** — *Prompt Framework Temeli* (2026-07-04)

1. Aşama (Hazırlık) temeli oluşturuldu:

- 13 sıralı prompt dosyası (`01-surum-guncelleme.md` - `13-moduler-mimari.md`)
- 4 parçalı sürümleme şeması (version.major.minor.revision)
- Tüm promptlar `v1.0.0.0` başlangıcında
- GitHub Proje #4: "Brave Omega Project" (11 öğe: 5 kapalı, 6 açık)
- Kalite hattı aktif: markdownlint (13 prompt temiz), yamllint, PowerShell sözdizimi

---

## 6 Aşamalı Uygulama Planı

### Aşama 0 — Hazırlık

| Prompt | Açıklama | Durum |
|--------|----------|-------|
| `01-surum-guncelleme.md` | Brave sürüm referanslarını tüm dosyalarda güncelle | 🔲 Bekliyor |

Brave (1.92.134), Chromium (150), Windows (11 25H2) referanslarını şuralarda günceller:

- `Brave Omega/BraveOmega-EN.ps1` — `$ScriptVersion`, `$ValidatedBrave`, `$ValidatedChromium`
- `Brave Omega/BraveOmega-TR.ps1` — aynı sabitler
- `README.md`, `index.html`, `CHANGELOG.md`, `Wiki/` dosyaları
- `.github/workflows/admx-validate.yml` — Chromium sürüm sabiti

---

### Aşama 1 — Denetim (Paralel 4 Prompt)

| Prompt | Açıklama | Durum |
| -------- | ---------- | ------- |
| `02-politika-bosluk-analizi.md` | Politika boşluk analizi — 13 eksik Brave politikasını belirle | 🔲 Bekliyor |
| `03-politika-deger-dogrulama.md` | Politika değer doğrulama — varsayılanları, aralıkları, ADMX enumlarını doğrula | 🔲 Bekliyor |
| `04-deprecated-temizlik.md` | 4 kullanımdan kaldırılmış Chromium politikasını kaldır | 🔲 Bekliyor |
| `05-referans-guncelleme.md` | Brave-Group-Policy-Reference.md satır numaralarını güncelle | 🔲 Bekliyor |

Ana çıktılar:

- 28 Brave+Chromium referans politikasının 13 uygulanana karşı tam envanteri
- Her politika için değer doğrulaması (DWord aralıkları, String kalıpları, MultiString dizileri)
- CloudPrintProxyEnabled vb. kullanımdan kaldırılmış politikaların temizlenmesi
- Referans doküman satır numaralarının güncel durumla eşleşmesi

---

### Aşama 2 — Uygulama

| Prompt | Açıklama | Durum |
|--------|----------|-------|
| `06-politika-ekleme-brave.md` | 13 eksik Brave politikasını her iki betiğe ekle | 🔲 Bekliyor |

Öncelik sırasına göre ekleme:

1. **Sıfır kullanıcı etkisi, maksimum gizlilik:** BraveDeAmpEnabled, BraveDebouncingEnabled, BraveGlobalPrivacyControlEnabled, BraveReduceLanguageEnabled, BraveTrackingQueryParametersFilteringEnabled, BraveLocalAIEnabled → Brave Yalnız katmanı (13→23)
2. **Varsayılan koruma seviyeleri:** DefaultBraveAdblockSetting, DefaultBraveFingerprintingV2Setting, DefaultBraveHttpsUpgradeSetting, DefaultBraveReferrersSetting, DefaultBraveRemember1PStorageSetting → Temel katmanı
3. **Kurumsal/kontrol:** EmailAliasesEnabled, BraveSyncUrl → Dengeli katmanı

Toplam: 67→81 politika, 4 katmanda.

---

### Aşama 3 — Kalite & Test ✅ **Tamamlandı (v2.1.6.0)**

| Prompt | Açıklama | Durum |
|--------|----------|-------|
| `07-pester-test.md` | EN betiği için Pester test takımı | ✅ Tamamlandı |
| `08-pssa-ekleme.md` | CI'a PSScriptAnalyzer entegrasyonu | ✅ Tamamlandı |

Teslimatlar:

- `Tests/` altında 16 Pester test dosyası, ~50–60 It bloğu
- Birim testleri: Write-PolicyValue, Level-Selection, Version-Check
- Entegrasyon testleri: Registry-Write, -WhatIf modu, yönetici algılama, politika bütünlüğü
- CI kalite iş akışında PSScriptAnalyzer kuralları (`Invoke-PSScriptAnalyzer`)
- Platform matrisi: Windows Server 2025, Windows 11 25H2, Windows 10 22H2
- QA raporu: `docs/reports/phase-3-kalite-test/`
- GitHub'da Issue #30 ile takip
- Kalite rozetleri: test geçme oranı, kod kapsamı, CI durumu

---

### Aşama 4 — Dokümantasyon/Yaygınlaştırma

| Prompt | Açıklama | Durum |
|--------|----------|-------|
| `07-politika-katalogu.md` | docs/policy-catalog.md oluştur — tam meta veriyle | ✅ Tamamlandı |

Politika başına: ID, kaynak, katman, min. Chromium, tür, varsayılan, önerilen, risk, ADMX doğrulama tarihi, notlar.

---

### Aşama 5 — Gelişmiş

| Prompt | Açıklama | Durum |
| -------- | ---------- | ------- |
| `09-cross-platform-config.md` | Linux JSON + macOS .plist çıktı desteği | 🔲 Bekliyor |
| `10-intune-mdm.md` | Intune/MDM dağıtım kılavuzu | 🔲 Bekliyor |
| `12-web-arayuzu.md` | Web tabanlı politika yapılandırıcı (index.html üzerinde) | 🔲 Bekliyor |
| `13-moduler-mimari.md` | Modüler mimari (modules/*.psm1 + config.json) | 🔲 Bekliyor |

---

## Sürümleme Stratejisi (4 Parçalı)

| Bileşen | Değişiklik Türü | Örnek |
| --------- | ----------------- | ------- |
| **Version** | Brave major yeniden yazımı, hedef platform değişikliği | v1.0.0.0 → v2.0.0.0 |
| **Major** | Betik mimarisi/kırılım değişikliği | v1.0.0.0 → v1.1.0.0 |
| **Minor** | Brave/Chromium yükseltmesi veya yeni politika eklendi | v1.0.0.0 → v1.0.1.0 |
| **Revision** | Düzeltme, revizyon, doküman güncellemesi | v1.0.0.0 → v1.0.0.1 |

**Sürüm Sabitleme:** Her sürüm, tam Brave + Chromium sürümüyle açıkça etiketlenir.

---

## Sürüm Takvimi

| Tetikleyici | Eylem |
| ------------- | ------- |
| **Brave Kararlı Sürümü** | 72 saat içinde ADMX fark incelemesi; politikalar değiştiyse yama sürümü |
| **Güvenlik Sorunu** | 24 saat içinde acil yama |
| **Çeviri Eksiklikleri** | 1 hafta içinde yama sürümü |
| **Özellik Talebi** | Sonraki alt sürüm için değerlendirilir |

---

## Topluluk Odaklı Öncelikler

| Alan | Nasıl Katkıda Bulunulur |
| ------ | ------------------------ |
| **Sürüm Güncellemeleri** | Güncellenmiş politika değerleri + kaynak referansıyla PR açın |
| **Yeni Politikalar** | Resmî ADMX/Chromium belgelerinden kaynaklanmış olmalıdır |
| **Çeviriler** | EN/TR şablonunu izleyin; işlevsel eşdeğerliği koruyun |
| **Hata Raporları** | Brave sürümü, Windows sürümü, tam çıktı dahil |
| **Belgelendirme** | Wiki düzenlemeleri, README iyileştirmeleri, örnekler |

---

## Yaşam Döngüsü Taahhüdü

> **Güncelliğini yitiren bir gizlilik sıkılaştırma aracı, güvenlik güvencesi değil — yanlış bir güvenlik duygusudur.**

| Taahhüt | Uygulama |
| --------- | ---------- |
| **Sürüm Sabitleme** | Her sürüm, tam Brave + Chromium sürümüyle etiketlenir |
| **Politika İncelemesi** | Her Brave kararlı sürümünde ADMX farkı |
| **Kırıcı Değişiklik Bildirimleri** | Kaldırılan/yeniden adlandırılan anahtarlar için değişiklik günlüğü geçiş notları |
| **Topluluk Güncelliği** | Sürüm uyuşmazlıkları ve yeni politikalar hızla incelenir |
| **Kararlı Sürüm Önerisi** | Her zaman en güncel kararlı Brave'i önerir |

---

## Yol Haritasını Etkileme

| Eylem | Etki |
| ------- | ------ |
| 👍 **Sorunları Oylama** | Topluluk önceliğini belirtir |
| 💬 **Sorunlara Yorum Yapma** | Uygulama yaklaşımını şekillendirir |
| 🔀 **PR Gönderme** | Kod tabanına doğrudan katkı |
| 💬 **Tartışmalar** | Uzun biçimli tasarım tartışmaları |
| 🌐 **Çeviriler** | Dil desteğini genişletme |

---

## Takip

Tüm aşamalı çalışmalar **GitHub Proje #4 — "Brave Omega Project"** ile takip edilir:

- [Proje Panosu](https://github.com/bayraktarozcan/Brave-Omega-Project/projects/4)
- 6 açık issue (#25–#30) aşamalara eşlenmiş
- Aşama tamamlanması = issue kapanışı

---

## İlgili Sayfalar

- [🤝 Katkıda Bulunma](Contributing#-türkçe) — Nasıl katkıda bulunulur
- [📜 Değişiklik Günlüğü](Changelog#-türkçe) — Tam sürüm geçmişi
- [📋 Politika Başvurusu](Policy-Reference#-türkçe) — Güncel politika seti
- [🔧 Kurulum](Installation#-türkçe) — Güncel sürüm kurulumu
