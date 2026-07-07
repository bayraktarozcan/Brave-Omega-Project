> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;�&nbsp; [TR T�rk�e](#-t�rk�e)

<a id="-english"></a>

# ?? Changelog � Version History

Complete version history for Brave Omega.

---

## Version Format

| Component | Policy |
|-----------|--------|
| **Major** | Breaking architecture changes, new tier addition |
| **Minor** | New policies added, significant feature additions |
| **Patch** | Bug fixes, translation updates, documentation, execution policy fixes |

**Version Pinning:** Every release explicitly tagged with exact Brave + Chromium version.

---

## Release History

### v2.2.0.2 — 2026-07-07

**Phase 6: WebRTC Policy Alignment — Balanced Upgraded to disable_non_proxied_udp (Same as Strict)**

**Changed:**
- `WebRtcIPHandling` in Balanced (L3): `"default_public_interface_only"` → `"disable_non_proxied_udp"` — same value as Strict (L5). Strict override is now a runtime no-op
- Both scripts updated to v2.2.0.2 with `$ScriptVersion = "v2.2.0.2"` / `$BetikSurum = "v2.2.0.2"`
- Documentation updated across README, Wiki, index.html, policy-catalog.md

**Removed:**
- All references to GitHub Projects/Issues from public documentation

---

### v2.2.0.1 — 2026-07-06

**Phase 6: Policy Refinement — BraveLocalAIEnabled Removed, 81→80 Policies**

**Removed:**
- `BraveLocalAIEnabled` removed from all levels (deprecated upstream; `1` was the default)
- Policy counts adjusted: L4 72→71, L5 81→80

**Changed:**
- Both scripts updated to v2.2.0.1 with `$ScriptVersion = "v2.2.0.1"` / `$BetikSurum = "v2.2.0.1"`
- Wiki version reference bump across all pages
- i18n string corrections for policy counts (13→22)

---

### v2.2.0 — 2026-07-06

**Phase 6: Five-Tier Hardening Model — Advanced Level Added, 81 Policies**

**Added:**
- New **Advanced** hardening level (L4, 11 policies) between Balanced (L3) and Strict (L5)
- 5-tier model: Brave Only (22) → Essential (39) → Balanced (60) → Advanced (71) → Strict (80)
- `DefaultSensorsSetting`, `DefaultLocalFontsSetting`, `DefaultSerialGuardSetting`, `DefaultIdleDetectionSetting`, `BrowserGuestModeEnabled`, `BrowserAddPersonEnabled`, `ImportAutofillFormData`, `ImportHistory`, `ImportSavedPasswords`, `ImportSearchEngine`, `ImportHomepage` migrated from Strict

**Changed:**
- Strict renumbered from L4 to L5; Katı renumbered to Level 5
- Policy counts restructured: Brave Only 23→22, Essential 40→39, Balanced 61→60, Advanced 72→71, Strict 81→80
- ADMX cross-reference table updated

---

### v2.1.6.0 — 2026-07-05

**Phase 3: Quality & Testing — Pester Test Suite, CI Improvements**

**Added:**

- Complete Pester test infrastructure under `Tests/` — 16 test files (~50–60 It blocks)
- Unit tests: Write-PolicyValue, Level-Selection, Version-Check
- Integration tests: Registry-Write, -WhatIf mode, admin detection, policy integrity validation
- PSScriptAnalyzer (`Invoke-PSScriptAnalyzer`) integration in CI quality workflow
- Platform matrix CI: Windows Server 2025, Windows 11 25H2, Windows 10 22H2
- Version checks and policy integrity validation in CI pipeline
- QA report: `docs/reports/phase-3-kalite-test/`
- Quality badges for test pass rate, code coverage, CI status

**Changed:**

- Both scripts updated to v2.1.6.0 with `$ScriptVersion = "v2.1.6.0"` / `$BetikSurum = "v2.1.6.0"`
- Wiki version reference bump across all pages
- CI workflows enhanced with test stage and analysis stage

- All 16 test files validated against EN and TR scripts

---

### v2.1.5 — 2026-07-03

**Brave 1.92.134 / Chromium 150.0.7871.63 Major Chromium Upgrade**

**Changed:**

- Both scripts updated to v2.1.5 with `$ScriptVersion = "v2.1.5"` / `$BetikSurum = "v2.1.5"`
- Brave validated version updated from 1.91.180 to 1.92.134
- Chromium validated version updated from 149.0.7827.201 to 150.0.7871.63 (major upgrade 149→150)
- Comprehensive documentation version bump across all Wiki pages
- index.html: fixed UTF-8 encoding corruption, cleaned duplicate comment headers in CHANGELOG.md
- CI/CD: fixed ADMX validation pipeline for pwsh/.NET Core compatibility

---

### v2.1.4 — 2026-06-27

**Brave 1.91.180 / Chromium 149.0.7827.201 Validation**

**Changed:**

- Both scripts updated to v2.1.4 with `$ScriptVersion = "v2.1.4"` / `$BetikSurum = "v2.1.4"`
- Brave validated version updated from 1.91.178 to 1.91.180
- Chromium validated version updated from 149.0.7827.196 to 149.0.7827.201
- Comprehensive documentation version bump across all Wiki pages
- .github templates enhanced: PR template, config.yml fix, issue form dropdowns
- Branch protection rule corrected (status check name)

---

### v2.1.3 — 2026-06-26

**Brave 1.91.178 / Chromium 149.0.7827.196 Validation**

**Changed:**

- Both scripts updated to v2.1.3 with `$ScriptVersion = "v2.1.3"` / `$BetikSurum = "v2.1.3"`
- Brave validated version updated from 1.91.172 to 1.91.178
- Chromium validated version updated from 149.0.7827.115 to 149.0.7827.196
- Comprehensive documentation version bump across all Wiki pages

---

### v2.1.2 — 2026-06-18

**Brave 1.91.175 / Chromium 149.0.7827.155 Validation**

**Changed:**

- Both scripts updated to v2.1.2 with `$ScriptVersion = "v2.1.2"` / `$BetikSurum = "v2.1.2"`
- Brave validated version updated from 1.91.172 to 1.91.175
- Chromium validated version updated from 149.0.7827.115 to 149.0.7827.155
- Documentation version bump

---

### v2.1 � 2026-06-16

**Version Detection, -WhatIf, -Reset & CI/CD**

**Added:**

- Automated Brave version detection (binary discovery, version compare, mismatch warning)
- -WhatIf parameter for dry-run preview (magenta [WhatIf] tags, no registry writes)
- -Reset parameter for clean uninstall (all 68 policies, empty key cleanup)
- CONTRIBUTING.md (EN + TR) with GitHub issue templates
- GitHub Actions ADMX validation pipeline (weekly + manual dispatch)
- SECURITY.md (599-line EN+TR security policy)

**Changed:**

- Both scripts updated to v2.1 with $ScriptVersion = "v2.1"
- README.md: updated roadmap (all checkboxes checked), quick-start with -WhatIf/-Reset
- index.html: updated changelog, badges, compatibility matrix

---

### v2.1.1 � 2026-06-17

**Dual-Version Detection Fix**

**Fixed:**

- Brave version check parsing both Brave and Chromium versions — correctly extracts both Chromium major and Brave version from FileVersion
- Version mismatch message now shows both detected versions
- Removed Compare-BraveVersion function in favor of direct parsed comparison

**Changed:**

- Both scripts updated to v2.1.1 with $ScriptVersion = "v2.1.1" / $BetikSurum = "v2.1.1"
- CHANGELOG.md: Added v2.1.1 changelog entry

---

### v2.0 � 2026-06-16

**Multi-Tier Hardening System (68 Policies)**

**Added:**

- 4-Tier Hardening Model: Brave Only (13) � Essential (30) � Balanced (49) � Strict (68)
- Cumulative inheritance � each level includes all policies from previous levels
- Interactive level selection menu with Turkish language support (-Level parameter)
- Registry Type Engine: DWord, String, MultiString support
- 3-Layer Enforcement: HKCU + HKLM ADMX + Omaha GUID
- 51 new ADMX-validated policies (total: 68)
- CHANGELOG.md with TR section, SECURITY.md (599-line), lifecycle commitment docs

**Changed:**

- Architecture: flat policy list � 4-tier cumulative model
- Version bump: v1.2.2 � v2.0
- README.md: complete v2.0 rewrite
- index.html: compatibility matrix, terminal animation, tier descriptions

---

### v1.2.2 � 2026-06-13

**Safe Execution Policy Fix & Simplified One-Line Workflow**

**Changed:**

- Execution policy: replaced permanent `RemoteSigned -Scope CurrentUser` with `-ExecutionPolicy Bypass` flag in run command
- Prerequisites: `prereq_pol_desc` simplified to single-line actionable command
- Quick Start: merged execution policy step into run command
- README: hardcoded `D:\REPOS\...` paths replaced with generic `C:\Users\Downloads\Brave-Omega`
- Terminal animation: `term_script` updated to show bypass command
- Turkish character corrections in Quick Start fallback text
- Tag balance fix: License section wrapper div added
- Translation key `cl_v122_summary` added (EN + TR)

**Security:**

- No `Set-ExecutionPolicy` call required
- Bypass flag applies only to child process
- No permanent registry changes, no attack surface

---

### v1.2.1 � 2026-06-13

**Brave 1.91.172 Upgrade, Translation Parity Fix, Structural Corrections**

**Changed:**

- 22 missing translation keys added (EN + TR): `pol_effect1-17`, `policies_badge/heading/desc`, `policy_col_key/effect`, `sources_badge`
- Sources section: added missing `<h2>` heading with badge and data-i18n
- License section: wired up `license_heading` data-i18n
- Orphaned keys `sources_heading`, `license_heading` wired up
- Version references updated v1.2 to v1.2.1
- Policy table: empty version-badge cells filled, column header internationalized
- Execution policy description rewritten for safety
- Tag balance verified: 777/777

---

### v1.2 � 2026-06-12

**Policy Expansion & Documentation � Major Feature Release**

**Added:**

- 10 new ADMX policies (+143% coverage): `BraveP3AEnabled`, `BraveWebDiscoveryEnabled`, `BraveTalkDisabled`, `BraveNewsDisabled`, `BravePlaylistEnabled`, `BraveSpeedreaderEnabled`, `BraveWaybackMachineEnabled`, `TorDisabled`, `BraveVPNDisabled`, `BraveAIChatEnabled`
- Total policies: 7 to 17 (+143% coverage)
- Fully bilingual landing page (TR/EN) with live language toggle
- Comprehensive documentation overhaul
- CHANGELOG.md for version tracking

**Changed:**

- Version bump: v1.1 to v1.2
- ADMX validation against Brave 1.91.172 / Chromium 149
- Documentation overhauled for readability

---

### v1.1 � 2026-06-05

**Error Handling, Backups, Process Guards, BraveShieldsDefault Removal**

**Added:**

- Automatic timestamped `.reg` backup before HKLM writes
- One-command rollback via `reg import`
- Brave process guard (detects running Brave, prompts continue/cancel)
- Per-operation try/catch with success/failure counters
- `-Force` parameter for idempotent re-execution

**Removed:**

- `BraveShieldsDefault` (not in official ADMX; Shields managed via URL policies)

**Fixed:**

- Error handling and logging
- Backup/rollback reliability

---

### v1.0 � 2026-06-04

**Initial Release � Community Edition**

**Features:**

- Three-tier architecture (HKCU + HKLM ADMX + Omaha GUID)
- 7 initial policies: `UsageStatsInSample`, `BraveRewardsDisabled`, `BraveWalletDisabled`, `BraveVPNDisabled`, `BraveAIChatEnabled`, `BraveStatsPingEnabled`, `MetricsReportingEnabled`
- Bilingual interface (EN/TR)
- Automatic HKLM backup + rollback
- Brave process guard
- Idempotent execution via `-Force`

---

## Migration Notes

| From to To | Action Required |
| ------------- | ----------------- |
| v2.0 to v2.1 | Re-run script; version detection, -WhatIf, -Reset, CI/CD pipeline added |
| v1.2.2 to v2.0 | Re-run script; 4-tier hardening model replaces flat policy list; 51 new policies added (total: 68) |
| v1.2.1 to v1.2.2 | Re-run script; execution policy now handled via `-ExecutionPolicy Bypass` flag |
| v1.2 to v1.2.1 | Re-run script; 10 new policies auto-applied |
| v1.1 to v1.2 | Re-run script; 10 new policies added, backup/rollback improved |
| v1.0 to v1.1 | Re-run script; backup/rollback, process guard added |

> **Note:** All versions are idempotent � safe to re-run. Always backup first if uncertain.

---

## Version Compatibility

| Brave Omega | Brave Version | Chromium | Windows | Status |
| ------------- | --------------- | ---------- | --------- | -------- |
| **v2.1** *(current)* | 1.91.172 | 149 | 11 25H2 | ? Active |
| v2.0 | 1.91.172 | 149 | 11 25H2 | ?? Previous |
| v1.2.2 | 1.91.172 | 149 | 11 25H2 | ?? Previous |
| v1.2.1 | 1.91.172 | 149 | 11 25H2 | ?? Previous |
| v1.2 | 1.91.172 | 149 | 11 25H2 | ?? Previous |
| v1.1 | 1.91.168 | 149 | 11 25H2 | ?? Previous |
| v1.0 | 1.91.168 | 149 | 11 25H2 | ?? Archived |

---

## Release Cadence

| Trigger | Timeline |
| --------- | ---------- |
| Brave Stable Release | ADMX diff within 72h; patch if policies changed |
| Security Issue | Emergency patch within 24h |
| Translation Gaps | Patch within 1 week |
| Feature Request | Next minor version |

---

## Migration Checklist (v1.2.2 to v2.0)

- [ ] Download v2.0 scripts
- [ ] Run with: `PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1"` and select a hardening level
- [ ] Verify `brave://policy` shows 68 Active policies
- [ ] 4-tier model automatically applies cumulative policies

---

## Migration Checklist (v2.0 to v2.1)

- [ ] Download v2.1 scripts
- [ ] Run with `-WhatIf` for dry-run preview: `PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1" -WhatIf`
- [ ] Run without `-WhatIf` to apply: `PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1"`
- [ ] Verify version detection updates registry with correct Brave version
- [ ] Use `-Reset` if clean uninstall needed

---

*Full release notes on [GitHub Releases](https://github.com/bayraktarozcan/Brave-Omega-Project/releases).*

---

---

<a id="-t�rk�e"></a>

# ?? De�i�iklik G�nl��� � S�r�m Ge�mi�i

Brave Omega i�in tam s�r�m ge�mi�i.

---

## S�r�m Bi�imi

| Bile�en | Politika |
| --------- | ---------- |
| **Ana (Major)** | K�r�c� mimari de�i�iklikleri, yeni katman ekleme |
| **Alt (Minor)** | Yeni politikalar eklendi, �nemli �zellik eklemeleri |
| **Yama (Patch)** | Hata d�zeltmeleri, �eviri g�ncellemeleri, belgelendirme, �al��t�rma ilkesi d�zeltmeleri |

**S�r�m Sabitleme:** Her s�r�m, tam Brave + Chromium s�r�m�yle a��k�a etiketlenir.

---

## S�r�m Ge�mi�i

### v2.2.0.2 — 2026-07-07

**Aşama 6: WebRTC Politika Hizalaması — Dengeli disable_non_proxied_udp'a Yükseltildi (Katı ile Aynı)**

**Değişenler:**
- Dengeli'de (L3) `WebRtcIPHandling`: `"default_public_interface_only"` → `"disable_non_proxied_udp"` — Katı (L5) ile aynı değer. Katı'daki ezme artık çalışma zamanında etkisiz
- Her iki betik v2.2.0.2'ye güncellendi, `$ScriptVersion = "v2.2.0.2"` / `$BetikSurum = "v2.2.0.2"`
- README, Wiki, index.html, policy-catalog.md genelinde dokümantasyon güncellendi

**Kaldırılanlar:**
- GitHub Projects/Issues ile ilgili tüm atıflar kamuya açık dokümantasyondan kaldırıldı

---

### v2.2.0.1 — 2026-07-06

**Aşama 6: Politika İyileştirmesi — BraveLocalAIEnabled Kaldırıldı, 81→80 Politika**

**Kaldırılanlar:**
- `BraveLocalAIEnabled` tüm seviyelerden kaldırıldı (kullanım dışı; `1` varsayılan değerdi)
- Politika sayıları düzeltildi: L4 72→71, L5 81→80

**Değişenler:**
- Her iki betik v2.2.0.1'e güncellendi, `$ScriptVersion = "v2.2.0.1"` / `$BetikSurum = "v2.2.0.1"`
- Tüm Wiki sayfalarında sürüm referans güncellemesi
- Politika sayıları için i18n düzeltmeleri (13→22)

---

### v2.2.0 — 2026-07-06

**Aşama 6: Beş Katmanlı Sıkılaştırma Modeli — Gelişmiş Seviyesi Eklendi, 81 Politika**

**Eklenenler:**
- Dengeli (L3) ile Katı (L5) arasına yeni **Gelişmiş** sıkılaştırma seviyesi (L4, 11 politika)
- 5 katmanlı model: Brave Yalnız (22) → Temel (39) → Dengeli (60) → Gelişmiş (71) → Katı (80)
- `DefaultSensorsSetting`, `DefaultLocalFontsSetting`, `DefaultSerialGuardSetting`, `DefaultIdleDetectionSetting`, `BrowserGuestModeEnabled`, `BrowserAddPersonEnabled`, `ImportAutofillFormData`, `ImportHistory`, `ImportSavedPasswords`, `ImportSearchEngine`, `ImportHomepage` Katı'dan taşındı

**Değişenler:**
- Katı L4'ten L5'e yeniden numaralandırıldı
- Politika sayıları yeniden yapılandırıldı: Brave Yalnız 23→22, Temel 40→39, Dengeli 61→60, Gelişmiş 72→71, Katı 81→80
- ADMX karşı referans tablosu güncellendi

---

### v2.1.6.0 — 2026-07-05

**Aşama 3: Kalite & Test — Pester Test Takımı, CI İyileştirmeleri**

**Eklenenler:**

- `Tests/` altında tam Pester test altyapısı — 16 test dosyası (~50–60 It bloğu)
- Birim testleri: Write-PolicyValue, Level-Selection, Version-Check
- Entegrasyon testleri: Registry-Write, -WhatIf modu, yönetici algılama, politika bütünlüğü doğrulaması
- CI kalite iş akışında PSScriptAnalyzer (`Invoke-PSScriptAnalyzer`) entegrasyonu
- Platform matrisi CI: Windows Server 2025, Windows 11 25H2, Windows 10 22H2
- CI hattında sürüm kontrolleri ve politika bütünlüğü doğrulaması
- QA raporu: `docs/reports/phase-3-kalite-test/`
- Test geçme oranı, kod kapsamı, CI durumu için kalite rozetleri

**Değişenler:**

- Her iki betik v2.1.6.0'a güncellendi, `$ScriptVersion = "v2.1.6.0"` / `$BetikSurum = "v2.1.6.0"`
- Tüm Wiki sayfalarında sürüm referans güncellemesi
- CI iş akışları test aşaması ve analiz aşaması ile genişletildi

- 16 test dosyası EN ve TR betiklerine karşı doğrulandı

---

### v2.1.5 — 2026-07-03

**Brave 1.92.134 / Chromium 150.0.7871.63 Büyük Chromium Yükseltmesi**

**Değişenler:**

- Her iki betik v2.1.5'e güncellendi, `$ScriptVersion = "v2.1.5"` / `$BetikSurum = "v2.1.5"`
- Doğrulanmış Brave sürümü 1.91.180 → 1.92.134 olarak güncellendi
- Doğrulanmış Chromium sürümü 149.0.7827.201 → 150.0.7871.63 olarak güncellendi (büyük yükseltme 149→150)
- Tüm Wiki sayfalarında kapsamlı belge sürüm güncellemesi
- index.html: UTF-8 kodlama bozulması düzeltildi, CHANGELOG.md'de yinelenen yorum başlıkları temizlendi
- CI/CD: ADMX doğrulama hattı pwsh/.NET Core uyumluluğu için düzeltildi

---

### v2.1 � 2026-06-16

**S�r�m Alg�lama, -WhatIf, -Reset ve CI/CD**

**Eklenenler:**

- Otomatik Brave s�r�m alg�lama (binary ke�fi, s�r�m kar��la�t�rma, uyumsuzluk uyar�s�)
- -WhatIf parametresi ile kuru �al��t�rma (macenta [WhatIf] etiketleri, kay�t defteri yazma yok)
- -Reset parametresi ile temiz kald�rma (68 politikan�n t�m�, bo� anahtar temizli�i)
- CONTRIBUTING.md (EN + TR) GitHub sorun �ablonlar�yla
- GitHub Actions ADMX do�rulama hatt� (haftal�k + manuel tetikleme)
- SECURITY.md (599 sat�rl�k EN+TR g�venlik politikas�)

**De�i�enler:**

- Her iki betik v2.1'e g�ncellendi, $ScriptVersion = "v2.1"
- README.md: g�ncellenmi� yol haritas�, -WhatIf/-Reset ile h�zl� ba�lang��
- index.html: g�ncellenmi� de�i�iklik g�nl���, rozetler, uyumluluk matrisi

---

### v2.1.4 - 2026-06-27

**Brave 1.91.180 / Chromium 149.0.7827.201 DoÄrulamasÄ±**

**DeÄiÅenler:**

- Her iki betik v2.1.4'e gÃ¼ncellendi, `$ScriptVersion = "v2.1.4"` / `$BetikSurum = "v2.1.4"`
- DoÄrulanmÄ±Å Brave sÃ¼rÃ¼mÃ¼ 1.91.178 â 1.91.180 olarak gÃ¼ncellendi
- DoÄrulanmÄ±Å Chromium sÃ¼rÃ¼mÃ¼ 149.0.7827.196 â 149.0.7827.201 olarak gÃ¼ncellendi
- TÃ¼m Wiki sayfalarÄ±nda kapsamlÄ± belge sÃ¼rÃ¼m gÃ¼ncellemesi
- .github ÅablonlarÄ± iyileÅtirildi: PR Åablonu, config.yml dÃ¼zeltmesi, sorun formu aÃ§Ä±lÄ±r menÃ¼leri
- Dal koruma kuralÄ± dÃ¼zeltildi (durum denetimi adÄ±)

---

### v2.1.3 - 2026-06-26

**Brave 1.91.178 / Chromium 149.0.7827.196 DoÄrulamasÄ±**

**DeÄiÅenler:**

- Her iki betik v2.1.3'e gÃ¼ncellendi, `$ScriptVersion = "v2.1.3"` / `$BetikSurum = "v2.1.3"`
- DoÄrulanmÄ±Å Brave sÃ¼rÃ¼mÃ¼ 1.91.172 â 1.91.178 olarak gÃ¼ncellendi
- DoÄrulanmÄ±Å Chromium sÃ¼rÃ¼mÃ¼ 149.0.7827.115 â 149.0.7827.196 olarak gÃ¼ncellendi
- TÃ¼m Wiki sayfalarÄ±nda kapsamlÄ± belge sÃ¼rÃ¼m gÃ¼ncellemesi

---

### v2.1.2 - 2026-06-18

**Brave 1.91.175 / Chromium 149.0.7827.155 DoÄrulamasÄ±**

**DeÄiÅenler:**

- Her iki betik v2.1.2'e gÃ¼ncellendi, `$ScriptVersion = "v2.1.2"` / `$BetikSurum = "v2.1.2"`
- DoÄrulanmÄ±Å Brave sÃ¼rÃ¼mÃ¼ 1.91.172 â 1.91.175 olarak gÃ¼ncellendi
- DoÄrulanmÄ±Å Chromium sÃ¼rÃ¼mÃ¼ 149.0.7827.115 â 149.0.7827.155 olarak gÃ¼ncellendi
- Belge sÃ¼rÃ¼m gÃ¼ncellemesi

---

### v2.1.1 - 2026-06-17

**Çift Sürüm Algılama Düzeltmesi**

**Düzeltilenler:**

- Brave ve Chromium sürümlerini ayrıştıran sürüm denetimi düzeltmesi - FileVersion'dan hem Chromium ana sürümü hem de Brave sürümü doğru şekilde ayrıştırılır
- Sürüm uyuşmazlık mesajı artık her iki sürümü de gösteriyor
- Compare-BraveVersion fonksiyonu kaldırıldı, doğrudan ayrıştırılmış karşılaştırma ile değiştirildi

**Değişenler:**

- Her iki betik v2.1.1'e güncellendi, $ScriptVersion = "v2.1.1" / $BetikSurum = "v2.1.1"
- CHANGELOG.md: v2.1.1 değişiklik günlüğü eklendi

---

### v2.0 � 2026-06-16

**�ok Seviyeli S�k�la�t�rma Sistemi (68 Politika)**

**Eklenenler:**

- 4 Seviyeli S�k�la�t�rma Modeli: Brave Yalniz (13) � Temel (30) � Dengeli (49) � Kat� (68)
- K�m�latif miras � her seviye bir �ncekinin t�m politikalar�n� kapsar
- T�rk�e dil deste�iyle etkile�imli seviye se�im men�s� (-Level parametresi)
- Kay�t T�r� Motoru: DWord, String, MultiString deste�i
- 3 Katmanl� Zorunlu K�lma: HKCU + HKLM ADMX + Omaha GUID
- 51 yeni ADMX do�rulamal� politika (toplam: 68)
- CHANGELOG.md TR b�l�m�yle, SECURITY.md, ya�am d�ng�s� taahh�t belgeleri

**De�i�enler:**

- Mimari: d�z politika listesi � 4 seviyeli k�m�latif model
- S�r�m y�kseltmesi: v1.2.2 � v2.0
- README.md: tam v2.0 yeniden yaz�m�
- index.html: uyumluluk matrisi, terminal animasyonu, seviye a��klamalar�

---

### v1.2.2 � 2026-06-13

**G�venli �al��t�rma �lkesi D�zeltmesi ve Basitle�tirilmi� Tek Sat�rl�k �� Ak���**

**De�i�enler:**

- �al��t�rma ilkesi: kal�c� `RemoteSigned -Scope CurrentUser` yerine `-ExecutionPolicy Bypass` bayra�� kullan�ld�
- �n gereksinimler: `prereq_pol_desc` tek sat�rl�k eyleme d�n��t�r�ld�
- H�zl� Ba�lang��: �al��t�rma ilkesi ad�m� komutla birle�tirildi
- README: sabit kodlanm�� `D:\REPOS\...` yollar� genel `C:\Users\Downloads\Brave-Omega` ile de�i�tirildi
- Terminal animasyonu: `term_script` bypass komutunu g�sterecek �ekilde g�ncellendi
- H�zl� Ba�lang�� yedek metninde T�rk�e karakter d�zeltmeleri
- Etiket dengesi d�zeltmesi: Lisans b�l�m� sarmalay�c� div eklendi
- �eviri anahtar� `cl_v122_summary` eklendi (EN + TR)

**G�venlik:**

- `Set-ExecutionPolicy` �a�r�s� gerekmez
- Bypass bayra�� yaln�zca alt i�lem i�in ge�erlidir
- Kal�c� kay�t defteri de�i�ikli�i yok, sald�r� y�zeyi yok

---

### v1.2.1 � 2026-06-13

**Brave 1.91.172 Y�kseltmesi, �eviri E�leme D�zeltmesi, Yap�sal D�zeltmeler**

**De�i�enler:**

- 22 eksik �eviri anahtar� eklendi (EN + TR): `pol_effect1-17`, `policies_badge/heading/desc`, `policy_col_key/effect`, `sources_badge`
- Kaynaklar b�l�m�: badge ve data-i18n ile eksik `<h2>` ba�l��� eklendi
- Lisans b�l�m�: `license_heading` data-i18n ba�lant�s� eklendi
- Sahipsiz anahtarlar `sources_heading`, `license_heading` ba�land�
- S�r�m referanslar� v1.2'den v1.2.1'e g�ncellendi
- Politika tablosu: bo� s�r�m-badge h�creleri dolduruldu, s�tun ba�l��� uluslararas�la�t�r�ld�
- �al��t�rma ilkesi a��klamas� g�venlik i�in yeniden yaz�ld�
- Etiket dengesi do�ruland�: 777/777

---

### v1.2 � 2026-06-12

**Politika Geni�letmesi ve Belgelendirme � B�y�k �zellik S�r�m�**

**Eklenenler:**

- 10 yeni ADMX politikas� (+143% kapsam): `BraveP3AEnabled`, `BraveWebDiscoveryEnabled`, `BraveTalkDisabled`, `BraveNewsDisabled`, `BravePlaylistEnabled`, `BraveSpeedreaderEnabled`, `BraveWaybackMachineEnabled`, `TorDisabled`, `BraveVPNDisabled`, `BraveAIChatEnabled`
- Toplam politika: 7'den 17'ye (+143% kapsam)
- Canl� dil de�i�tirme ile tam iki dilli a��l�� sayfas� (TR/EN)
- Kapsaml� belgelendirme yenilemesi
- S�r�m takibi i�in CHANGELOG.md

**De�i�enler:**

- S�r�m y�kseltmesi: v1.1'den v1.2'ye
- Brave 1.91.172 / Chromium 149'a kar�� ADMX do�rulamas�
- Belgelendirme okunabilirlik i�in yenilendi

---

### v1.1 � 2026-06-05

**Hata Y�netimi, Yedeklemeler, S�re� Koruyucular�, BraveShieldsDefault Kald�rma**

**Eklenenler:**

- HKLM yazmalar�ndan �nce otomatik zaman damgal� `.reg` yede�i
- `reg import` ile tek komutla geri alma
- Brave s�re� koruyucusu (�al��an Brave'i tespit eder, devam/iptal istemi)
- ��lem ba��na try/catch ile ba�ar�/hata saya�lar�
- Karars�z olmayan yeniden �al��t�rma i�in `-Force` parametresi

**Kald�r�lanlar:**

- `BraveShieldsDefault` (resm� ADMX'te yok; Kalkanlar URL politikalar�yla y�netilir)

**D�zeltilenler:**

- Hata y�netimi ve g�nl�kleme
- Yedekleme/geri alma g�venilirli�i

---

### v1.0 � 2026-06-04

**�lk S�r�m � Topluluk S�r�m�**

**�zellikler:**

- �� katmanl� mimari (HKCU + HKLM ADMX + Omaha GUID)
- 7 ba�lang�� politikas�: `UsageStatsInSample`, `BraveRewardsDisabled`, `BraveWalletDisabled`, `BraveVPNDisabled`, `BraveAIChatEnabled`, `BraveStatsPingEnabled`, `MetricsReportingEnabled`
- �ki dilli aray�z (EN/TR)
- Otomatik HKLM yedekleme + geri alma
- Brave s�re� koruyucusu
- `-Force` ile karars�z olmayan �al��t�rma

---

## Ge�i� Notlar�

| Kimden � Kime | Gerekli ��lem |
| ------------- | ---------------- |
| v2.0 � v2.1 | Beti�i yeniden �al��t�r�n; s�r�m alg�lama, -WhatIf, -Reset, CI/CD hatt� eklendi |
| v1.2.2 � v2.0 | Beti�i yeniden �al��t�r�n; 4 seviyeli s�k�la�t�rma modeli d�z politika listesinin yerini al�r; 51 yeni politika eklendi (toplam: 68) |
| v1.2.1 � v1.2.2 | Beti�i yeniden �al��t�r�n; �al��t�rma ilkesi art�k `-ExecutionPolicy Bypass` bayra��yla y�netiliyor |
| v1.2 � v1.2.1 | Beti�i yeniden �al��t�r�n; 10 yeni politika otomatik uygulan�r |
| v1.1 � v1.2 | Beti�i yeniden �al��t�r�n; 10 yeni politika eklendi, yedekleme/geri alma iyile�tirildi |
| v1.0 � v1.1 | Beti�i yeniden �al��t�r�n; yedekleme/geri alma, s�re� koruyucusu eklendi |

> **Not:** T�m s�r�mler karars�z de�ildir � yeniden �al��t�rmak g�venlidir. Emin de�ilseniz �nce yedekleyin.

---

## S�r�m Uyumlulu�u

| Brave Omega | Brave S�r�m� | Chromium | Windows | Durum |
| ------------- | -------------- | ---------- | --------- | ------- |
| **v2.1** *(g�ncel)* | 1.91.172 | 149 | 11 25H2 | ? Etkin |
| v2.0 | 1.91.172 | 149 | 11 25H2 | ?? �nceki |
| v1.2.2 | 1.91.172 | 149 | 11 25H2 | ?? �nceki |
| v1.2.1 | 1.91.172 | 149 | 11 25H2 | ?? �nceki |
| v1.2 | 1.91.172 | 149 | 11 25H2 | ?? �nceki |
| v1.1 | 1.91.168 | 149 | 11 25H2 | ?? �nceki |
| v1.0 | 1.91.168 | 149 | 11 25H2 | ?? Ar�ivlendi |

---

## S�r�m Takvimi

| Tetikleyici | Zaman �izelgesi |
| ------------- | ----------------- |
| Brave Kararl� S�r�m� | 72 saat i�inde ADMX fark�; politikalar de�i�tiyse yama |
| G�venlik Sorunu | 24 saat i�inde acil yama |
| �eviri Eksiklikleri | 1 hafta i�inde yama |
| �zellik Talebi | Sonraki alt s�r�m |

---

## Ge�i� Kontrol Listesi (v1.2.2 � v2.0)

- [ ] v2.0 betiklerini indirin
- [ ] �u komutla �al��t�r�n: `PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"` ve bir s�k�la�t�rma seviyesi se�in
- [ ] `brave://policy`'nin 68 Etkin politika g�sterdi�ini do�rulay�n
- [ ] 4 seviyeli model k�m�latif politikalar� otomatik uygular

---

## Ge�i� Kontrol Listesi (v2.0 � v2.1)

- [ ] v2.1 betiklerini indirin
- [ ] Kuru �al��t�rma i�in `-WhatIf` ile �al��t�r�n: `PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -WhatIf`
- [ ] Uygulamak i�in `-WhatIf` olmadan �al��t�r�n: `PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"`
- [ ] S�r�m alg�laman�n kay�t defterini do�ru Brave s�r�m�yle g�ncelledi�ini do�rulay�n
- [ ] Temiz kald�rma gerekiyorsa `-Reset` kullan�n

---

*Tam s�r�m notlar� [GitHub S�r�mlerinde](https://github.com/bayraktarozcan/Brave-Omega-Project/releases).*
