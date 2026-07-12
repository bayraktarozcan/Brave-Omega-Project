> **Language / Dil** &nbsp;
> [EN English](#-english) &nbsp;·&nbsp; [TR Türkçe](#-türkçe)

<a id="-english"></a>

# 📋 Changelog — Version History

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

### v2.4.1.0 — 2026-07-10

**Brave 1.92.139 Validation — ProxySettings Added to Essential**

**Added:**
- **Essential (+1):** ProxySettings (JSON placeholder `{"proxyServer": "http://proxy:8080"}`)

**Changed:**
- Cumulative chain: 24→52→83→104→133 (Essential 18→19)
- Brave validated version updated to 1.92.139 (Chromium 150.0.7871.176)
- Both scripts updated to v2.4.1.0 with `$ScriptVersion = "v2.4.1.0"` / `$BetikSurum = "v2.4.1.0"`
- Documentation updated across README, Wiki, CHANGELOG

---

### v2.3.0.0 — 2026-07-09

**Phase 8: Extension Lockdown, Proxy & Privacy Hardening — 111→133 Policies (+19)**

**Added:**
- 19 new Chromium enterprise policies added:
  - **Brave Only (+2):** SafeBrowsingProtectionLevel, PasswordProtectionWarningTrigger
  - **Essential (+1):** EnableOnlineRevocationChecks
  - **Balanced (+4):** ExtensionInstallForcelist, DownloadRestrictions, DownloadDirectory, PromptForDownloadLocation
  - **Advanced (+17):** ExtensionInstallBlocklist, ExtensionInstallAllowlist, ExtensionAllowedTypes, BlockExternalExtensions, ExtensionSettings, ManifestV2Unsupported, DeveloperToolsDisabled, ProxyMode, BuiltInDnsClientEnabled, BraveUpdateDisabled, IncognitoModeAvailability, TaskManagerEndProcessEnabled, PrintingEnabled, DisablePrintPreview, TranslateEnabled, DefaultJavaScriptSetting, PasswordManagerEnabled
  - **Strict (+1, moved from Advanced):** DeveloperToolsAvailability
  - **Strict overrides:** TranslateEnabled (top priority), DownloadRestrictions (1→3), plus other tier overrides for IncognitoModeAvailability, TaskManagerEndProcessEnabled, PrintingEnabled, DisablePrintPreview, DeveloperToolsDisabled, ProxyMode, BuiltInDnsClientEnabled, BraveUpdateDisabled

**Changed:**
- Cumulative chain restructured: 22→47→72→83→91 → 24→52→83→104→133
- Brave validated version updated to 1.92.138 (Chromium 150.0.7871.101)
- Both scripts updated to v2.3.0.0 with `$ScriptVersion = "v2.3.0.0"` / `$BetikSurum = "v2.3.0.0"`
- `DownloadRestrictions` overridden to `3` in Strict (Balanced uses `1`)
- `BraveUpdateDisabled` set to `0` (enabled) in Advanced; auto-updates no longer blocked
- Documentation updated across README, Wiki, index.html, CHANGELOG

**Removed:**
- `AllowPopupsDuringPageUnload` (deprecated upstream, removed after initial 115-policy build)

---

### v2.2.1.0 - 2026-07-07

**Phase 7: Hardware API & Security Hardening - 80→91 Policies (+11)**

- 12 new Chromium enterprise policies added across Essential (+8) and Balanced (+4) tiers:
  - **Essential:** DefaultWebUsbGuardSetting, DefaultWebBluetoothGuardSetting, DefaultWebHidGuardSetting, DefaultDirectSocketsSetting, DeviceAttributesAllowedForOrigins, EncryptedClientHelloEnabled, PaymentMethodQueryEnabled, SuppressDifferentOriginSubframeDialogs
  - **Balanced:** DefaultWindowManagementSetting, SitePerProcess, IntensiveWakeUpThrottlingEnabled, UserFeedbackAllowed
- Cumulative chain updated: 22→47→72→83→91
- Both scripts updated to v2.2.1.0 with `$ScriptVersion = "v2.2.1.0"` / `$BetikSurum = "v2.2.1.0"`
- Documentation updated across README, Wiki, index.html, CHANGELOG

---

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

### v2.1 — 2026-06-16

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

### v2.1.1 — 2026-06-17

**Dual-Version Detection Fix**

**Fixed:**

- Brave version check parsing both Brave and Chromium versions — correctly extracts both Chromium major and Brave version from FileVersion
- Version mismatch message now shows both detected versions
- Removed Compare-BraveVersion function in favor of direct parsed comparison

**Changed:**

- Both scripts updated to v2.1.1 with $ScriptVersion = "v2.1.1" / $BetikSurum = "v2.1.1"
- CHANGELOG.md: Added v2.1.1 changelog entry

---

### v2.0 — 2026-06-16

**Multi-Tier Hardening System (68 Policies)**

**Added:**

- 4-Tier Hardening Model: Brave Only (13) → Essential (30) → Balanced (49) → Strict (68)
- Cumulative inheritance — each level includes all policies from previous levels
- Interactive level selection menu with Turkish language support (-Level parameter)
- Registry Type Engine: DWord, String, MultiString support
- 3-Layer Enforcement: HKCU + HKLM ADMX + Omaha GUID
- 51 new ADMX-validated policies (total: 68)
- CHANGELOG.md with TR section, SECURITY.md (599-line), lifecycle commitment docs

**Changed:**

- Architecture: flat policy list → 4-tier cumulative model
- Version bump: v1.2.2 → v2.0
- README.md: complete v2.0 rewrite
- index.html: compatibility matrix, terminal animation, tier descriptions

---

### v1.2.2 — 2026-06-13

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

### v1.2.1 — 2026-06-13

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

### v1.2 — 2026-06-12

**Policy Expansion & Documentation — Major Feature Release**

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

### v1.1 — 2026-06-05

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

### v1.0 — 2026-06-04

**Initial Release — Community Edition**

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

> **Note:** All versions are idempotent — safe to re-run. Always backup first if uncertain.

---

## Version Compatibility

| Brave Omega | Brave Version | Chromium | Windows | Status |
| ------------- | --------------- | ---------- | --------- | -------- |
| **v2.4.1.0** *(current)* | 1.92.139 | 150 | 11 25H2 | ✅ Active |
| v2.3.0.0 | 1.92.138 | 150 | 11 25H2 | ✅ Previous |
| v2.2.1.0 | 1.92.134 | 150 | 11 25H2 | ✅ Previous |
| v2.2.0.2 | 1.92.134 | 150 | 11 25H2 | ✅ Previous |
| v2.2.0 | 1.92.134 | 150 | 11 25H2 | ✅ Previous |
| v2.1.6.0 | 1.92.134 | 150 | 11 25H2 | ✅ Previous |
| v2.1.5 | 1.92.134 | 150 | 11 25H2 | ✅ Previous |
| v2.1 | 1.91.172 | 149 | 11 25H2 | ⏹️ Previous |
| v2.0 | 1.91.172 | 149 | 11 25H2 | ⏹️ Previous |
| v1.2.2 | 1.91.172 | 149 | 11 25H2 | ⏹️ Previous |
| v1.2.1 | 1.91.172 | 149 | 11 25H2 | ⏹️ Previous |
| v1.2 | 1.91.172 | 149 | 11 25H2 | ⏹️ Previous |
| v1.1 | 1.91.168 | 149 | 11 25H2 | ⏹️ Previous |
| v1.0 | 1.91.168 | 149 | 11 25H2 | ⏹️ Archived |

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

<a id="-türkçe"></a>

# 📋 Değişiklik Günlüğü — Sürüm Geçmişi

Brave Omega için tam sürüm geçmişi.

---

## Sürüm Biçimi

| Bileşen | Politika |
| --------- | ---------- |
| **Ana (Major)** | Kırıcı mimari değişiklikleri, yeni katman ekleme |
| **Alt (Minor)** | Yeni politikalar eklendi, önemli özellik eklemeleri |
| **Yama (Patch)** | Hata düzeltmeleri, çeviri güncellemeleri, belgelendirme, çalıştırma ilkesi düzeltmeleri |

**Sürüm Sabitleme:** Her sürüm, tam Brave + Chromium sürümüyle açıkça etiketlenir.

---

## Sürüm Geçmişi

### v2.3.0.0 — 2026-07-09

**Aşama 8: Uzantı Kilitleme, Proxy ve Gizlilik Sıkılaştırması — 111→133 Politika (+19)**

**Eklenenler:**
- 11 yeni Chromium kurumsal politikası eklendi:
  - **Brave Yalnız (+2):** SafeBrowsingProtectionLevel, PasswordProtectionWarningTrigger
  - **Temel (+1):** EnableOnlineRevocationChecks
  - **Dengeli (+4):** ExtensionInstallForcelist, DownloadRestrictions, DownloadDirectory, PromptForDownloadLocation
  - **Katı (+5):** IncognitoModeAvailability, TaskManagerEndProcessEnabled, PrintingEnabled, DisablePrintPreview, DeveloperToolsAvailability

**Yeniden Sınıflandırılanlar:**
- 10 politika Katı'dan Gelişmiş'e taşındı (uzantı kilitleme, proxy, DNS, otomatik güncelleme):
  ExtensionInstallBlocklist, ExtensionInstallAllowlist, ExtensionAllowedTypes, BlockExternalExtensions, ExtensionSettings, ManifestV2Unsupported, DeveloperToolsDisabled, ProxyMode, BuiltInDnsClientEnabled, BraveUpdateDisabled

**Değişenler:**
- Kümülatif zincir yeniden yapılandırıldı: 22→47→72→83→91 → 24→52→83→104→133
- Doğrulanmış Brave sürümü 1.92.138'e güncellendi (Chromium 150.0.7871.101)
- Her iki betik v2.3.0.0'a güncellendi, `$ScriptVersion = "v2.3.0.0"` / `$BetikSurum = "v2.3.0.0"`
- `DownloadRestrictions` Katı'da `3` ile geçersiz kılındı (Dengeli `1` kullanır)
- `BraveUpdateDisabled` Gelişmiş'te `0` olarak ayarlandı (etkin); otomatik güncellemeler artık engellenmez
- README, Wiki, index.html, CHANGELOG genelinde dokümantasyon güncellendi

**Kaldırılanlar:**
- `AllowPopupsDuringPageUnload` (kullanım dışı, ilk 115 politikalık yapıdan sonra kaldırıldı)

---

### v2.2.1.0 - 2026-07-07

**Aşama 7: Donanım API & Güvenlik Sıkılaştırması - 80→91 Politika (+11)**

- Temel (+8) ve Dengeli (+4) katmanlarına 12 yeni Chromium kurumsal politikası eklendi
- Kümülatif zincir güncellendi: 22→47→72→83→91
- Her iki betik v2.2.1.0'a güncellendi, `$ScriptVersion = "v2.2.1.0"` / `$BetikSurum = "v2.2.1.0"`
- README, Wiki, index.html, CHANGELOG genelinde dokümantasyon güncellendi

---

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

### v2.1 — 2026-06-16

**Sürüm Algılama, -WhatIf, -Reset ve CI/CD**

**Eklenenler:**

- Otomatik Brave sürüm algılama (binary keşfi, sürüm karşılaştırma, uyumsuzluk uyarısı)
- -WhatIf parametresi ile kuru çalıştırma (macenta [WhatIf] etiketleri, kayıt defteri yazma yok)
- -Reset parametresi ile temiz kaldırma (68 politikanın tümü, boş anahtar temizliği)
- CONTRIBUTING.md (EN + TR) GitHub sorun şablonlarıyla
- GitHub Actions ADMX doğrulama hattı (haftalık + manuel tetikleme)
- SECURITY.md (599 satırlık EN+TR güvenlik politikası)

**Değişenler:**

- Her iki betik v2.1'e güncellendi, $ScriptVersion = "v2.1"
- README.md: güncellenmiş yol haritası, -WhatIf/-Reset ile hızlı başlangıç
- index.html: güncellenmiş değişiklik günlüğü, rozetler, uyumluluk matrisi

---

### v2.1.4 - 2026-06-27

**Brave 1.91.180 / Chromium 149.0.7827.201 Doğrulaması**

**Değişenler:**

- Her iki betik v2.1.4'e güncellendi, `$ScriptVersion = "v2.1.4"` / `$BetikSurum = "v2.1.4"`
- Doğrulanmış Brave sürümü 1.91.178 → 1.91.180 olarak güncellendi
- Doğrulanmış Chromium sürümü 149.0.7827.196 → 149.0.7827.201 olarak güncellendi
- Tüm Wiki sayfalarında kapsamlı belge sürüm güncellemesi
- .github şablonları iyileştirildi: PR şablonu, config.yml düzeltmesi, sorun formu açılır menüleri
- Dal koruma kuralı düzeltildi (durum denetimi adı)

---

### v2.1.3 - 2026-06-26

**Brave 1.91.178 / Chromium 149.0.7827.196 Doğrulaması**

**Değişenler:**

- Her iki betik v2.1.3'e güncellendi, `$ScriptVersion = "v2.1.3"` / `$BetikSurum = "v2.1.3"`
- Doğrulanmış Brave sürümü 1.91.172 → 1.91.178 olarak güncellendi
- Doğrulanmış Chromium sürümü 149.0.7827.115 → 149.0.7827.196 olarak güncellendi
- Tüm Wiki sayfalarında kapsamlı belge sürüm güncellemesi

---

### v2.1.2 - 2026-06-18

**Brave 1.91.175 / Chromium 149.0.7827.155 Doğrulaması**

**Değişenler:**

- Her iki betik v2.1.2'e güncellendi, `$ScriptVersion = "v2.1.2"` / `$BetikSurum = "v2.1.2"`
- Doğrulanmış Brave sürümü 1.91.172 → 1.91.175 olarak güncellendi
- Doğrulanmış Chromium sürümü 149.0.7827.115 → 149.0.7827.155 olarak güncellendi
- Belge sürüm güncellemesi

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

### v2.0 — 2026-06-16

**Çok Seviyeli Sıkılaştırma Sistemi (68 Politika)**

**Eklenenler:**

- 4 Seviyeli Sıkılaştırma Modeli: Brave Yalnız (13) → Temel (30) → Dengeli (49) → Katı (68)
- Kümülatif miras — her seviye bir öncekinin tüm politikalarını kapsar
- Türkçe dil desteğiyle etkileşimli seviye seçim menüsü (-Level parametresi)
- Kayıt Türü Motoru: DWord, String, MultiString desteği
- 3 Katmanlı Zorunlu Kılma: HKCU + HKLM ADMX + Omaha GUID
- 51 yeni ADMX doğrulamalı politika (toplam: 68)
- CHANGELOG.md TR bölümüyle, SECURITY.md, yaşam döngüsü taahhüt belgeleri

**Değişenler:**

- Mimari: düz politika listesi → 4 seviyeli kümülatif model
- Sürüm yükseltmesi: v1.2.2 → v2.0
- README.md: tam v2.0 yeniden yazımı
- index.html: uyumluluk matrisi, terminal animasyonu, seviye açıklamaları

---

### v1.2.2 — 2026-06-13

**Güvenli Çalıştırma İlkesi Düzeltmesi ve Basitleştirilmiş Tek Satırlık İş Akışı**

**Değişenler:**

- Çalıştırma ilkesi: kalıcı `RemoteSigned -Scope CurrentUser` yerine `-ExecutionPolicy Bypass` bayrağı kullanıldı
- Ön gereksinimler: `prereq_pol_desc` tek satırlık eyleme dönüştürüldü
- Hızlı Başlangıç: çalıştırma ilkesi adımı komutla birleştirildi
- README: sabit kodlanmış `D:\REPOS\...` yolları genel `C:\Users\Downloads\Brave-Omega` ile değiştirildi
- Terminal animasyonu: `term_script` bypass komutunu gösterecek şekilde güncellendi
- Hızlı Başlangıç yedek metninde Türkçe karakter düzeltmeleri
- Etiket dengesi düzeltmesi: Lisans bölümü sarmalayıcı div eklendi
- Çeviri anahtarı `cl_v122_summary` eklendi (EN + TR)

**Güvenlik:**

- `Set-ExecutionPolicy` çağrısı gerekmez
- Bypass bayrağı yalnızca alt işlem için geçerlidir
- Kalıcı kayıt defteri değişikliği yok, saldırı yüzeyi yok

---

### v1.2.1 — 2026-06-13

**Brave 1.91.172 Yükseltmesi, Çeviri Eşleme Düzeltmesi, Yapısal Düzeltmeler**

**Değişenler:**

- 22 eksik çeviri anahtarı eklendi (EN + TR): `pol_effect1-17`, `policies_badge/heading/desc`, `policy_col_key/effect`, `sources_badge`
- Kaynaklar bölümü: badge ve data-i18n ile eksik `<h2>` başlığı eklendi
- Lisans bölümü: `license_heading` data-i18n bağlantısı eklendi
- Sahipsiz anahtarlar `sources_heading`, `license_heading` bağlandı
- Sürüm referansları v1.2'den v1.2.1'e güncellendi
- Politika tablosu: boş sürüm-badge hücreleri dolduruldu, sütun başlığı uluslararasılaştırıldı
- Çalıştırma ilkesi açıklaması güvenlik için yeniden yazıldı
- Etiket dengesi doğrulandı: 777/777

---

### v1.2 — 2026-06-12

**Politika Genişletmesi ve Belgelendirme — Büyük Özellik Sürümü**

**Eklenenler:**

- 10 yeni ADMX politikası (+143% kapsam): `BraveP3AEnabled`, `BraveWebDiscoveryEnabled`, `BraveTalkDisabled`, `BraveNewsDisabled`, `BravePlaylistEnabled`, `BraveSpeedreaderEnabled`, `BraveWaybackMachineEnabled`, `TorDisabled`, `BraveVPNDisabled`, `BraveAIChatEnabled`
- Toplam politika: 7'den 17'ye (+143% kapsam)
- Canlı dil değiştirme ile tam iki dilli açılış sayfası (TR/EN)
- Kapsamlı belgelendirme yenilemesi
- Sürüm takibi için CHANGELOG.md

**Değişenler:**

- Sürüm yükseltmesi: v1.1'den v1.2'ye
- Brave 1.91.172 / Chromium 149'a karşı ADMX doğrulaması
- Belgelendirme okunabilirlik için yenilendi

---

### v1.1 — 2026-06-05

**Hata Yönetimi, Yedeklemeler, Süreç Koruyucuları, BraveShieldsDefault Kaldırma**

**Eklenenler:**

- HKLM yazmalarından önce otomatik zaman damgalı `.reg` yedeği
- `reg import` ile tek komutla geri alma
- Brave süreç koruyucusu (çalışan Brave'i tespit eder, devam/iptal istemi)
- İşlem başına try/catch ile başarı/hata sayaçları
- Kararsız olmayan yeniden çalıştırma için `-Force` parametresi

**Kaldırılanlar:**

- `BraveShieldsDefault` (resmî ADMX'te yok; Kalkanlar URL politikalarıyla yönetilir)

**Düzeltilenler:**

- Hata yönetimi ve günlükleme
- Yedekleme/geri alma güvenilirliği

---

### v1.0 — 2026-06-04

**İlk Sürüm — Topluluk Sürümü**

**Özellikler:**

- Üç katmanlı mimari (HKCU + HKLM ADMX + Omaha GUID)
- 7 başlangıç politikası: `UsageStatsInSample`, `BraveRewardsDisabled`, `BraveWalletDisabled`, `BraveVPNDisabled`, `BraveAIChatEnabled`, `BraveStatsPingEnabled`, `MetricsReportingEnabled`
- İki dilli arayüz (EN/TR)
- Otomatik HKLM yedekleme + geri alma
- Brave süreç koruyucusu
- `-Force` ile kararsız olmayan çalıştırma

---

## Geçiş Notları

| Kimden → Kime | Gerekli İşlem |
| ------------- | ---------------- |
| v2.1 → v2.2 | Betiği yeniden çalıştırın; Brave sürümü 1.92'ye yükseltildi, yeni politikalar eklendi |
| v2.0 → v2.1 | Betiği yeniden çalıştırın; sürüm algılama, -WhatIf, -Reset, CI/CD hattı eklendi |
| v1.2.2 → v2.0 | Betiği yeniden çalıştırın; 4 seviyeli sıkılaştırma modeli düz politika listesinin yerini alır; 51 yeni politika eklendi (toplam: 68) |
| v1.2.1 → v1.2.2 | Betiği yeniden çalıştırın; çalıştırma ilkesi artık `-ExecutionPolicy Bypass` bayrağıyla yönetiliyor |
| v1.2 → v1.2.1 | Betiği yeniden çalıştırın; 10 yeni politika otomatik uygulanır |
| v1.1 → v1.2 | Betiği yeniden çalıştırın; 10 yeni politika eklendi, yedekleme/geri alma iyileştirildi |
| v1.0 → v1.1 | Betiği yeniden çalıştırın; yedekleme/geri alma, süreç koruyucusu eklendi |

> **Not:** Tüm sürümler kararsız değildir — yeniden çalıştırmak güvenlidir. Emin değilseniz önce yedekleyin.

---

## Sürüm Uyumluluğu

| Brave Omega | Brave Sürümü | Chromium | Windows | Durum |
| ------------- | -------------- | ---------- | --------- | ------- |
| **v2.4.1.0** *(güncel)* | 1.92.139 | 150 | 11 25H2 | ✅ Etkin |
| v2.3.0.0 | 1.92.138 | 150 | 11 25H2 | ✅ Önceki |
| v2.2.1.0 | 1.92.134 | 150 | 11 25H2 | ✅ Önceki |
| v2.2.0.2 | 1.92.134 | 150 | 11 25H2 | ✅ Önceki |
| v2.2.0 | 1.92.134 | 150 | 11 25H2 | ✅ Önceki |
| v2.1.6.0 | 1.92.134 | 150 | 11 25H2 | ✅ Önceki |
| v2.1.5 | 1.92.134 | 150 | 11 25H2 | ✅ Önceki |
| v2.1 | 1.91.172 | 149 | 11 25H2 | ⏹️ Önceki |
| v2.0 | 1.91.172 | 149 | 11 25H2 | ⏹️ Önceki |
| v1.2.2 | 1.91.172 | 149 | 11 25H2 | ⏹️ Önceki |
| v1.2.1 | 1.91.172 | 149 | 11 25H2 | ⏹️ Önceki |
| v1.2 | 1.91.172 | 149 | 11 25H2 | ⏹️ Önceki |
| v1.1 | 1.91.168 | 149 | 11 25H2 | ⏹️ Önceki |
| v1.0 | 1.91.168 | 149 | 11 25H2 | ⏹️ Arşivlendi |

---

## Sürüm Takvimi

| Tetikleyici | Zaman Çizelgesi |
| ------------- | ----------------- |
| Brave Kararlı Sürümü | 72 saat içinde ADMX farkı; politikalar değiştiyse yama |
| Güvenlik Sorunu | 24 saat içinde acil yama |
| Çeviri Eksiklikleri | 1 hafta içinde yama |
| Özellik Talebi | Sonraki alt sürüm |

---

## Geçiş Kontrol Listesi (v1.2.2 → v2.0)

- [ ] v2.0 betiklerini indirin
- [ ] Şu komutla çalıştırın: `PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"` ve bir sıkılaştırma seviyesi seçin
- [ ] `brave://policy`'nin 68 Etkin politika gösterdiğini doğrulayın
- [ ] 4 seviyeli model kümülatif politikaları otomatik uygular

---

## Geçiş Kontrol Listesi (v2.0 → v2.1)

- [ ] v2.1 betiklerini indirin
- [ ] Kuru çalıştırma için `-WhatIf` ile çalıştırın: `PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -WhatIf`
- [ ] Uygulamak için `-WhatIf` olmadan çalıştırın: `PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"`
- [ ] Sürüm algılamanın kayıt defterini doğru Brave sürümüyle güncellediğini doğrulayın
- [ ] Temiz kaldırma gerekiyorsa `-Reset` kullanın

---

*Tam sürüm notları [GitHub Sürümlerinde](https://github.com/bayraktarozcan/Brave-Omega-Project/releases).*
