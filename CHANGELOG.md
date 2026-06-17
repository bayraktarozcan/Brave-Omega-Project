<!-- ================================================================== -->
<!--            BRAVE OMEGA PROJECT — CHANGELOG                         -->
<!--          Community Edition · Open Source · Privacy First           -->
<!-- ================================================================== -->

<div align="center">

<br>

# 🦁 Brave Omega — Changelog

<br>

> **Language / Dil** &nbsp;
> [EN English](#-english-changelog) &nbsp;·&nbsp; [TR Türkçe](#-türkçe-değişiklik-günlüğü)

<br>

</div>

---

<a id="-english-changelog"></a>

## EN English Changelog

### Table of Contents

1.  [Introduction](#en-introduction)
2.  [v2.1 — 2026-06-16](#en-v21)
    *   [Summary](#en-v21-summary)
    *   [Added](#en-v21-added)
    *   [Changed](#en-v21-changed)
    *   [Statistics](#en-v21-statistics)
3.  [v2.0 — 2026-06-16](#en-v20)
    *   [Summary](#en-v20-summary)
    *   [Added](#en-v20-added)
    *   [Changed](#en-v20-changed)
    *   [Statistics](#en-v20-statistics)
4.  [v1.2.2 — 2026-06-13](#en-v122)
    *   [Summary](#en-v122-summary)
    *   [Changed](#en-v122-changed)
5.  [v1.2.1 — 2026-06-13](#en-v121)
    *   [Summary](#en-v121-summary)
    *   [Changed](#en-v121-changed)
6.  [v1.2 — 2026-06-12](#en-v12)
    *   [Summary](#en-v12-summary)
    *   [Added](#en-v12-added)
    *   [Statistics](#en-v12-statistics)
    *   [Changed](#en-v12-changed)
    *   [Security](#en-v12-security)
7.  [v1.1 — 2026-06-05](#en-v11)
    *   [Summary](#en-v11-summary)
    *   [Added](#en-v11-added)
    *   [Changed](#en-v11-changed)
    *   [Removed](#en-v11-removed)
    *   [Details](#en-v11-details)
8.  [v1.0 — 2026-06-04](#en-v10)
    *   [Summary](#en-v10-summary)
    *   [Features](#en-v10-features)
    *   [Initial Policies](#en-v10-initial-policies)
    *   [Documentation](#en-v10-documentation)
9.  [Version History Summary](#en-version-history-summary)
10. [Related Documentation](#en-related-documentation)
11. [Notes](#en-notes)

---

<a id="en-introduction"></a>

All notable changes to this project are documented below, following the [Keep a Changelog](https://keepachangelog.com/) format.

---

<a id="en-v21"></a>

## [v2.1] — 2026-06-16

<a id="en-v21-summary"></a>

### 🎯 Summary

**Feature expansion:** Automated Brave version detection, dry-run preview (`-WhatIf`),
clean uninstall (`-Reset`), structured `CONTRIBUTING.md` with GitHub issue templates,
and a GitHub Actions ADMX validation pipeline that runs weekly and on demand.

<a id="en-v21-added"></a>

### ✨ Added

#### Version Detection
- **Automated Brave binary discovery** — Searches `%ProgramFiles%`, `%ProgramFiles(x86)%`,
  and `%LOCALAPPDATA%` for `brave.exe`.
- **Version comparison** — Compares `major.minor.patch` against validated version `1.91.172`.
- **User prompt on mismatch** — Warns if installed version differs and asks to continue.
- **Silent skip** — If Brave is not found, script proceeds with a gentle reminder to check
  compatibility at `brave://settings/help`.

#### -WhatIf Parameter (Preview Mode)
- **Standard PowerShell semantics** — `-WhatIf` switch on both the script and
  `Write-PolicyValue` / `Yaz-KayitDegeri` functions.
- **No registry writes** — All write operations (HKLM, HKCU, Omaha) are guarded by an
  `if (-not $WhatIf)` check.
- **Skipped steps** — Backup export and directory creation are entirely skipped in WhatIf mode.
- **Magenta [WhatIf] tags** — Every output line that would have written a value is prefixed
  with `[WhatIf]` in magenta for clear visual identification.
- **Summary indication** — Summary report shows `Mode: -WhatIf (preview only)`.

#### -Reset Parameter (Clean Uninstall)
- **Full policy removal** — Removes all 68 Brave Omega policies from HKLM, HKCU (UsageStats,
  ChromeVariations), and all detected Omaha GUIDs.
- **Empty key cleanup** — Removes `HKLM\SOFTWARE\Policies\BraveSoftware\Brave` if no
  policies remain after deletion.
- **Detailed counters** — Reports removed counts per hive: `HKLM: 68 / HKCU: 2 / Omaha: N`.
- **WhatIf-aware** — Respects `-WhatIf` silently (no actual deletion in preview mode).

#### Documentation
- **CONTRIBUTING.md** — Comprehensive contributing guide (EN + TR) covering code of conduct,
  priority areas, version updates, new policy requirements, bug report templates, feature
  requests, translations, PR workflow, development setup, style guide, and security disclosures.
- **Issue Templates** — Structured YAML templates for bug reports and feature requests
  (`.github/ISSUE_TEMPLATE/bug_report.yaml`, `feature_request.yaml`).

#### CI/CD
- **ADMX Validation Pipeline** (`.github/workflows/admx-validate.yml` + `.ps1`):
  - Runs weekly (Monday 06:00 UTC) and on `workflow_dispatch`.
  - Downloads Chromium ADMX templates, parses policy definitions, and compares against
    the script's policy list.
  - Reports type mismatches, new policies available in ADMX, and policies in script not in ADMX.
  - Creates a GitHub issue automatically when mismatches are found.
  - Companion script (`admx-validate.ps1`) also usable standalone.

### 🔧 Changed

- **BraveOmega-EN.ps1** — v2.1 features: version check, -WhatIf, -Reset, `$ScriptVersion = "v2.1"`
- **BraveOmega-TR.ps1** — v2.1 features mirrored in Turkish
- **CHANGELOG.md** — Added v2.1 changelog entry (this section)

### 📊 Statistics

```
Files Modified/Added:
  ✓ BraveOmega-EN.ps1 (v2.1: version check, -WhatIf, -Reset)
  ✓ BraveOmega-TR.ps1 (v2.1: mirrored changes)
  ✓ CONTRIBUTING.md (new — comprehensive contributing guide, EN + TR)
  ✓ .github/ISSUE_TEMPLATE/bug_report.yaml (new)
  ✓ .github/ISSUE_TEMPLATE/feature_request.yaml (new)
  ✓ .github/workflows/admx-validate.yml (new — weekly + manual dispatch)
  ✓ .github/workflows/admx-validate.ps1 (new — standalone validation script)
  ✓ CHANGELOG.md (v2.1 entry)
  ✓ README.md (updated roadmap, contributing reference)
  ✓ index.html (updated changelog, quick-start, badges)
```

---

<a id="en-v20"></a>

## [v2.0] — 2026-06-16

<a id="en-v20-summary"></a>

### 🎯 Summary

**Major architectural overhaul:** Introduction of the **Multi-Tier Hardening System** — four progressive levels (Brave Only, Essential, Balanced, Strict) that give users granular control over their privacy posture. Total enterprise policies expanded from **17 to 68 across all tiers**.

**Validated against Brave 1.91.172 (Chromium 149.0.7827.115).**

<a id="en-v20-added"></a>

### ✨ Added

#### Multi-Tier Architecture
- **4-Tier Hardening Model** — Brave Only → Essential ⭐ → Balanced → Strict
- **Cumulative inheritance** — each level includes all policies from previous levels
- **Interactive level selection** when run without parameters
- **`-Level` parameter** for automated/silent deployment (`-Level Essential`)
- Turkish `-Level` parameter support (`-Level Temel`, `-Level Dengeli`, `-Level Katı`)
- **Recommended level** (Essential) highlighted with star badge in selection menu

#### Registry Type Engine
- **DWord** (REG_DWORD) support for boolean/integer policies
- **String** (REG_SZ) support for string-enum policies (WebRtcIPHandling, HttpsOnlyMode, DnsOverHttpsMode)
- **MultiString** (REG_MULTI_SZ) support for list policies (WebRtcLocalIpsAllowedUrls)
- **Type-aware dispatch** — the script automatically selects the correct registry write method per policy

#### New Policies by Tier

**Essential (17 new — data leak prevention, zero usability impact):**
| Policy | Value | Effect |
|--------|-------|--------|
| `UrlKeyedAnonymizedDataCollectionEnabled` | 0 | Stops sending visited URLs to Google |
| `SearchSuggestEnabled` | 0 | Stops keystroke data from leaving device |
| `NetworkPredictionOptions` | 2 | Stops DNS prefetching and pre-connection |
| `TranslateEnabled` | 0 | Stops sending text to Google for translation |
| `SpellcheckEnabled` | 0 | Stops sending text to Google spellcheck servers |
| `AlternateErrorPagesEnabled` | 0 | Stops network requests on DNS failure |
| `BrowserNetworkTimeQueriesEnabled` | 0 | Stops time sync requests to Google |
| `DomainReliabilityAllowed` | 0 | Stops diagnostic data reporting to Google |
| `BackgroundModeEnabled` | 0 | Prevents Brave from running when all windows closed |
| `SafeBrowsingSurveysEnabled` | 0 | Disables post-browsing surveys |
| `SafeBrowsingDeepScanningEnabled` | 0 | Disables server-side download scanning |
| `WebRtcEventLogCollectionAllowed` | 0 | Stops WebRTC event log upload to Google |
| `WebRtcTextLogCollectionAllowed` | 0 | Stops WebRTC text log upload to Google |
| `AudioCaptureAllowed` | 0 | Blocks microphone access by default |
| `VideoCaptureAllowed` | 0 | Blocks camera access by default |

**Balanced (16 new — security & convenience balance):**
| Policy | Value | Effect |
|--------|-------|--------|
| `WebRtcIPHandling` | `default_public_interface_only` | Hides local IPs from WebRTC |
| `WebRtcLocalIpsAllowedUrls` | `@()` (empty) | Prevents any URL from getting local IP via ICE |
| `HttpsOnlyMode` | `force_enabled` | Forces all navigations to HTTPS |
| `DnsOverHttpsMode` | `automatic` | Upgrades DNS to encrypted queries |
| `BlockThirdPartyCookies` | 1 | Blocks cross-site tracking cookies |
| `PasswordManagerEnabled` | 0 | Disables built-in password saving |
| `PasswordManagerPasskeysEnabled` | 0 | Disables passkey saving |
| `AutofillAddressEnabled` | 0 | Disables address autofill storage |
| `AutofillCreditCardEnabled` | 0 | Disables payment autofill storage |
| `ShowFullUrlsInAddressBar` | 1 | Shows full URLs (anti-phishing) |
| `DisableSafeBrowsingProceedAnyway` | 1 | Prevents bypassing malware warnings |
| `QuicAllowed` | 0 | Disables QUIC, falls back to TCP/TLS |
| `ChromeVariations` | 1 | Restricts to critical field trials only |
| `NetworkServiceSandboxEnabled` | 1 | Sandboxes network service process |
| `AudioSandboxEnabled` | 1 | Sandboxes audio service process |
| `DefaultGeolocationSetting` | 2 | Blocks location access by default |
| `DefaultNotificationsSetting` | 2 | Blocks notifications by default |
| `DefaultPopupsSetting` | 2 | Blocks pop-ups by default |
| `DefaultMediaStreamSetting` | 2 | Blocks camera/mic by default |

**Strict (22 new — maximum privacy):**
| Policy | Value | Effect |
|--------|-------|--------|
| `WebRtcIPHandling` (override) | `disable_non_proxied_udp` | Proxies all WebRTC traffic |
| `DefaultSensorsSetting` | 2 | Blocks motion/light sensor access |
| `DefaultLocalFontsSetting` | 2 | Blocks font enumeration (reduces fingerprinting) |
| `DefaultClipboardSetting` | 2 | Blocks clipboard access |
| `DefaultFileSystemReadGuardSetting` | 2 | Blocks file system read access |
| `DefaultFileSystemWriteGuardSetting` | 2 | Blocks file system write access |
| `DefaultSerialGuardSetting` | 2 | Blocks Serial API access |
| `DefaultIdleDetectionSetting` | 2 | Blocks idle state detection |
| `DefaultInsecureContentSetting` | 2 | Blocks mixed content |
| `DefaultJavaScriptJitSetting` | 2 | Disables JIT (reduces attack surface) |
| `DefaultCookiesSetting` | 2 | Blocks all cookies by default |
| `BrowserGuestModeEnabled` | 0 | Prevents guest profile creation |
| `BrowserAddPersonEnabled` | 0 | Prevents new profile creation |
| `CloudPrintProxyEnabled` | 0 | Disables Cloud Print proxy |
| `ImportAutofillFormData` | 0 | Disables autofill import |
| `ImportBookmarks` | 0 | Disables bookmark import |
| `ImportHistory` | 0 | Disables history import |
| `ImportSavedPasswords` | 0 | Disables password import |
| `ImportSearchEngine` | 0 | Disables search engine import |
| `ImportHomepage` | 0 | Disables homepage import |

#### Documentation
- **SECURITY.md** — Comprehensive security policy (EN + TR)
- Full vulnerability disclosure process documented
- Policy verification guide with registry audit commands
- Hardening level comparison table
- Supply chain trust recommendations

<a id="en-v20-changed"></a>

### 🔄 Changed

- **BraveOmega-EN.ps1** — Complete rewrite: multi-tier system, -Level parameter, type-aware registry engine (565 → 520 lines)
- **BraveOmega-TR.ps1** — Complete rewrite: same architecture in Turkish (567 → 522 lines)
- **README.md** — Updated for multi-tier system (Key Features, Quick Start with -Level, expanded Policy Reference)
- **CHANGELOG.md** — Added v2.0 changelog entry (this file)
- **index.html** — Updated with 4-tier system documentation, version references, new badges

<a id="en-v20-statistics"></a>

### 📊 Statistics

```
Files Modified:
  ✓ BraveOmega-EN.ps1 (565 → 520 lines, full rewrite)
  ✓ BraveOmega-TR.ps1 (567 → 522 lines, full rewrite)
  ✓ README.md (multi-tier documentation)
  ✓ CHANGELOG.md (v2.0 entry)
  ✓ index.html (4-tier system, version references)
  ✓ SECURITY.md (new file, 500+ lines)
  ✓ Knowledge-Intelligence/README.md (source updates)

Policies:
  ✓ Brave Only:  13 Brave-specific policies
  ✓ Essential:   +17 = 30 total policies (Recommended)
  ✓ Balanced:    +16 = 46 total policies
  ✓ Strict:      +22 = 68 total policies
  ✓ Total:      17 → 68 policies across all tiers (+300%)

Registry Types:
  ✓ DWord:      61 policies
  ✓ String:     4 policies
  ✓ MultiString: 3 policies

Documentation:
  ✓ SECURITY.md (new — comprehensive security policy, EN + TR)
  ✓ README.md (multi-tier system documented)
  ✓ CHANGELOG.md (this file)
  ✓ index.html (4-tier architecture, updated badges)
```

<a id="en-v122-summary"></a>

### 🎯 Summary

**Patch release:** Execution policy fix — replaced `RemoteSigned -Scope CurrentUser` with session-scoped `Bypass -Scope Process`. No policy changes from v1.2.1.

**Changes:** Execution policy instruction now uses `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` which affects only the current PowerShell window (no permanent registry change, no attack surface exposure). README Quick Start restructured for clarity. Turkish character corrections applied to visible UI text.

<a id="en-v122-changed"></a>

### 🔧 Changed

- **index.html**: Updated `prereq_pol_desc` (EN + TR) to use session-scoped `-Scope Process Bypass` instead of permanent `RemoteSigned -Scope CurrentUser`
- **index.html**: Fixed Turkish characters in `rm_item3` fallback text
- **index.html**: Updated version references from v1.2.1 to v1.2.2
- **README.md**: Replaced permanent execution policy step with session-scoped bypass in Quick Start (EN + TR)
- **README.md**: Updated version compatibility matrix to include v1.2.2 + v1.2.1
- **CHANGELOG.md**: Added v1.2.2 changelog entry with full documentation

---

<a id="en-v121"></a>

## [v1.2.1] — 2026-06-13

<a id="en-v121-summary"></a>

### 🎯 Summary

**Patch release:** Brave version upgrade to 1.91.172 (Chromium 149.0.7827.115). No policy changes from v1.2.

**Changes:** Translation parity fix (22 missing policy effect keys added for EN/TR), added missing sources section heading, wired up license section translation, corrected orphaned translation keys.

<a id="en-v121-changed"></a>

### 🔧 Changed

- **index.html**: Added 23 missing translation keys for EN and TR (pol_effect1–17, policies_badge/heading/desc, policy_col_key/effect, sources_badge)
- **index.html**: Added missing `<h2>` heading and badge to sources section with data-i18n support
- **index.html**: Wired up license_heading data-i18n to license section heading
- **index.html**: Updated version references from v1.2 to v1.2.1
- **README.md**: Updated version compatibility matrix to include v1.2.1
- **CHANGELOG.md**: Added v1.2.1 changelog entry with full documentation

<a id="en-v12"></a>

## [v1.2] — 2026-06-12

<a id="en-v12-summary"></a>

### 🎯 Summary

**Major expansion:** 10 new enterprise policies added, bringing total from **7 to 17 policies**. This represents a **143% expansion** in privacy hardening coverage. All new policies are ADMX-verified and Chromium 149 compatible.

**Validated against Brave 1.91.172 (Chromium 149.0.7827.115).**

<a id="en-v12-added"></a>

### ✨ Added

#### Telemetry & Analytics (2 policies)
- `BraveP3AEnabled = 0` — Disables Privacy-Preserving Product Analytics (P3A)
- `BraveWebDiscoveryEnabled = 0` — Disables Web Discovery Project data contribution

#### Integrated Services (3 policies)
- `BraveTalkDisabled = 1` — Disables Brave Talk video conferencing
- `BraveNewsDisabled = 1` — Disables Brave News feed
- `BravePlaylistEnabled = 0` — Disables Brave Playlist

#### Reader & Discovery (2 policies)
- `BraveSpeedreaderEnabled = 0` — Disables Speedreader mode
- `BraveWaybackMachineEnabled = 0` — Disables Wayback Machine integration

#### Network & Other (1 policy)
- `TorDisabled = 1` — Disables Tor network integration

#### Documentation
- Updated Version Compatibility Matrix (now showing v1.0, v1.1, v1.2)
- Expanded Policy Reference table with all 17 policies
- Updated architecture diagrams (7 → 17 policies)
- Both English and Turkish versions fully updated

<a id="en-v12-statistics"></a>

### 📊 Statistics

```
Files Modified:
  ✓ BraveOmega-TR.ps1 (497 → 567 lines)
  ✓ BraveOmega-EN.ps1 (496 → 565 lines)
  ✓ README.md (version compatibility, policy table)

Policies:
  ✓ Total: 7 → 17 (+143%)
  ✓ HKLM Enterprise Policies: 7 → 15 (+114%)
  ✓ Categories: 3 → 5 (+67%)

Documentation:
  ✓ UPDATE_REPORT_v1.2.md (bilingual update summary)
  ✓ POLICY_UPDATE_v1.2.md (detailed policy reference)
  ✓ CHANGELOG.md (this file)
```

<a id="en-v12-changed"></a>

### 🔄 Changed

- Script header versions updated with v1.2 changelog
- Version Compatibility Matrix reorganized (v1.0/v1.1/v1.2)
- Policy reference comprehensively expanded
- Architecture diagrams updated (7 → 17 policy count)

<a id="en-v12-security"></a>

### 🛡️ Security

- All new policies verified against Brave's official ADMX templates
- All new policies cross-referenced with Chromium 149 enterprise documentation
- No breaking changes; backward compatible with v1.1 systems

---

<a id="en-v11"></a>

## [v1.1] — 2026-06-05

<a id="en-v11-summary"></a>

### 🎯 Summary

Comprehensive debugging and enhancement release with 7 major improvements. Introduced Brave process guards, registry backups, and try-catch error handling.

<a id="en-v11-added"></a>

### ✨ Added

- **Brave Process Guard** — Detects active Brave instances before execution
- **Registry Backup** — Automatic .reg file backup with timestamp before HKLM modifications
- **Enhanced Error Handling** — Try-catch blocks on all registry operations with success/failure counters
- **Execution Summary** — Per-category reporting with transparent success/failure metrics

<a id="en-v11-changed"></a>

### 🔄 Changed

- Fixed exit codes: `exit 1` on failure (previously returned 0)
- Simplified directory preparation: Single-line `-Force` parameter instead of redundant Test-Path
- Omaha GUID processing: Previously dead variable now writes `usagestats=0` to detected paths

<a id="en-v11-removed"></a>

### ❌ Removed

- **BraveShieldsDefault = 2** — This policy does not exist in Brave's official ADMX. Removed to prevent creating non-functional registry entries.

<a id="en-v11-details"></a>

### 📋 Details

| Change # | Type | Description |
|----------|------|-------------|
| #1 | Fix | Removed non-existent BraveShieldsDefault policy |
| #2 | Add | Added try-catch error handling to registry operations |
| #3 | Fix | Implemented Omaha GUID usagestats=0 writing (was dead code) |
| #4 | Add | Added Brave process detection with user prompt |
| #5 | Fix | Corrected exit codes for automation tool compatibility |
| #6 | Add | Implemented automatic HKLM backup before modifications |
| #7 | Simplify | Removed redundant Test-Path check before New-Item |

---

<a id="en-v10"></a>

## [v1.0] — 2026-06-04

<a id="en-v10-summary"></a>

### 🎯 Summary

Initial community release. Stable, tested hardening automation for Brave Browser with enterprise policy hardening across three registry layers (HKCU, HKLM, Omaha).

<a id="en-v10-features"></a>

### ✨ Features

- **7 Enterprise Policies** — All ADMX-verified policies for core telemetry and service disabling
- **3-Tier Architecture** — HKCU user preference + HKLM enterprise policy + Omaha updater GUID
- **Idempotent Execution** — Safe to run multiple times with consistent results
- **Bilingual Interface** — Full Turkish and English support
- **Defense-in-Depth** — Layered approach across Windows Registry hierarchy
- **Process Guard** — Warns if Brave is open before making changes
- **Automatic Backups** — Time-stamped .reg backups before registry modifications

<a id="en-v10-initial-policies"></a>

### 📋 Initial Policies

```
1. UsageStatsInSample = 0 (HKCU)         — Disable usage stats sampling
2. BraveRewardsDisabled = 1 (HKLM)       — Disable Rewards
3. BraveWalletDisabled = 1 (HKLM)        — Disable Wallet
4. BraveVPNDisabled = 1 (HKLM)           — Disable VPN
5. BraveAIChatEnabled = 0 (HKLM)         — Disable Leo AI Chat
6. BraveStatsPingEnabled = 0 (HKLM)      — Disable stats pings
7. MetricsReportingEnabled = 0 (HKLM)    — Disable metrics
8. SafeBrowsingExtendedReportingEnabled = 0 (HKLM) — Disable extended SB reports
9. usagestats = 0 (Omaha GUID)           — Disable updater telemetry
```

<a id="en-v10-documentation"></a>

### 📚 Documentation

- Comprehensive README.md in English and Turkish
- Policy reference tables with descriptions
- Quick start guide for both languages
- Troubleshooting section
- Security & Safety section
- Project roadmap

---

<a id="en-version-history-summary"></a>

## Version History Summary

| Version | Date       | Policies | Major Changes |
|---------|------------|----------|---------------|
| v2.1   | 2026-06-16 | 68    | Version check, -WhatIf, -Reset, CONTRIBUTING.md, GitHub Actions |
| v2.0   | 2026-06-16 | 13–68 | Multi-Tier System (Brave Only / Essential / Balanced / Strict) |
| v1.2.2 | 2026-06-13 | 17 | Safe execution policy fix, v1.2.2 branding |
| v1.2.1 | 2026-06-13 | 17 | Brave 1.91.172 upgrade, translation & structural fixes |
| v1.2 | 2026-06-12 | 17 | +10 new policies, Brave 1.91.172 validation |
| v1.1 | 2026-06-05 | 7 | Error handling, backups, process guards |
| v1.0 | 2026-06-04 | 7 | Initial release, 3-tier architecture |

---

<a id="en-related-documentation"></a>

## 🔗 Related Documentation

- **README.md** — Complete user documentation (EN + TR)
- **CONTRIBUTING.md** — Contributor guidelines (EN + TR)
- **LICENSE** — MIT License terms
- **Brave Omega/** — PowerShell scripts directory

---

<a id="en-notes"></a>

## 📌 Notes

- All releases maintain backward compatibility
- No breaking changes between versions
- Each version is independently tested against stated Brave and Chromium versions
- Community contributions welcome; follow contributing guidelines in README

---

<div align="center">

**🦁 Brave Omega Project** — Community Edition

*Building privacy-first browser hardening, one policy at a time.*

</div>

---

---

<a id="-türkçe-değişiklik-günlüğü"></a>

## TR Türkçe Değişiklik Günlüğü

### İçindekiler

1.  [Giriş](#tr-introduction)
2.  [v2.1 — 2026-06-16](#tr-v21)
    *   [Özet](#tr-v21-summary)
    *   [Eklendi](#tr-v21-added)
    *   [Değiştirildi](#tr-v21-changed)
    *   [İstatistikler](#tr-v21-statistics)
3.  [v2.0 — 2026-06-16](#tr-v20)
    *   [Özet](#tr-v20-summary)
    *   [Eklendi](#tr-v20-added)
    *   [Değiştirildi](#tr-v20-changed)
    *   [İstatistikler](#tr-v20-statistics)
4.  [v1.2.2 — 2026-06-13](#tr-v122)
    *   [Özet](#tr-v122-summary)
    *   [Değiştirildi](#tr-v122-changed)
5.  [v1.2.1 — 2026-06-13](#tr-v121)
    *   [Özet](#tr-v121-summary)
    *   [Değiştirildi](#tr-v121-changed)
6.  [v1.2 — 2026-06-12](#tr-v12)
    *   [Özet](#tr-v12-summary)
    *   [Eklendi](#tr-v12-added)
    *   [İstatistikler](#tr-v12-statistics)
    *   [Değiştirildi](#tr-v12-changed)
    *   [Güvenlik](#tr-v12-security)
7.  [v1.1 — 2026-06-05](#tr-v11)
    *   [Özet](#tr-v11-summary)
    *   [Eklendi](#tr-v11-added)
    *   [Değiştirildi](#tr-v11-changed)
    *   [Kaldırıldı](#tr-v11-removed)
    *   [Detaylar](#tr-v11-details)
8.  [v1.0 — 2026-06-04](#tr-v10)
    *   [Özet](#tr-v10-summary)
    *   [Özellikler](#tr-v10-features)
    *   [Başlangıç Politikaları](#tr-v10-initial-policies)
    *   [Belgelendirme](#tr-v10-documentation)
9.  [Sürüm Geçmişi Özeti](#tr-version-history-summary)
10. [İlgili Belgelendirme](#tr-related-documentation)
11. [Notlar](#tr-notes)

---

<a id="tr-introduction"></a>

Bu projedeki tüm önemli değişiklikler, [Keep a Changelog](https://keepachangelog.com/) formatına uygun olarak aşağıda belgelenmiştir.

---

<a id="tr-v21"></a>

## [v2.1] — 2026-06-16

<a id="tr-v21-summary"></a>

### 🎯 Özet

**Özellik genişletmesi:** Otomatik Brave sürüm tespiti, kuru çalıştırma önizlemesi
(`-WhatIf`), temiz kaldırma (`-Sıfırla`), yapılandırılmış `CONTRIBUTING.md` ve GitHub
sorun şablonları ile haftalık ve isteğe bağlı çalışan bir GitHub Actions ADMX doğrulama
boru hattı.

<a id="tr-v21-added"></a>

### ✨ Eklendi

#### Sürüm Tespiti
- **Otomatik Brave ikili dosya keşfi** — `%ProgramFiles%`, `%ProgramFiles(x86)%` ve
  `%LOCALAPPDATA%` dizinlerinde `brave.exe` arar.
- **Sürüm karşılaştırması** — `major.minor.patch` değerini doğrulanmış sürüm `1.91.172`
  ile karşılaştırır.
- **Uyuşmazlıkta kullanıcı istemi** — Yüklü sürüm farklıysa uyarır ve devam etmeyi sorar.
- **Sessiz atlama** — Brave bulunamazsa, `brave://settings/help` adresinden uyumluluk
  kontrolü hatırlatması ile devam eder.

#### -WhatIf Parametresi (Önizleme Modu)
- **Standart PowerShell semantiği** — Hem betikte hem de `Write-PolicyValue` /
  `Yaz-KayitDegeri` fonksiyonlarında `-WhatIf` anahtarı.
- **Kayıt defterine yazılmaz** — Tüm yazma işlemleri (HKLM, HKCU, Omaha) bir
  `if (-not $WhatIf)` denetimi ile korunur.
- **Atlanan adımlar** — Yedekleme dışa aktarma ve dizin oluşturma WhatIf modunda tamamen
  atlanır.
- **Magenta [WhatIf] etiketleri** — Değer yazacak her çıktı satırı, net görsel tanımlama
  için macenta renkte `[WhatIf]` ön eki alır.
- **Özet göstergesi** — Özet raporunda `Mod: WhatIf (yalnızca önizleme)` gösterilir.

#### -Sıfırla Parametresi (Temiz Kaldırma)
- **Tam politika kaldırma** — HKLM, HKCU (UsageStats, ChromeVariations) ve tespit edilen
  tüm Omaha GUID'lerinden 68 Brave Omega politikasının tamamını kaldırır.
- **Boş anahtar temizliği** — Kaldırma sonrası hiç politika kalmazsa
  `HKLM\SOFTWARE\Policies\BraveSoftware\Brave` anahtarını siler.
- **Ayrıntılı sayaçlar** — Kovan başına kaldırma sayısını raporlar: `HKLM: 68 / HKCU: 2 / Omaha: N`.
- **WhatIf duyarlılığı** — `-WhatIf` modunda sessizce çalışır (önizlemede gerçek silme yapılmaz).

#### Belgelendirme
- **CONTRIBUTING.md** — Kapsamlı katkı rehberi (EN + TR) — davranış kuralları, öncelikli
  alanlar, sürüm güncellemeleri, yeni politika gereksinimleri, hata raporu şablonları,
  özellik talepleri, çeviriler, PR iş akışı, geliştirme ortamı kurulumu, stil rehberi ve
  güvenlik bildirimleri.
- **Sorun Şablonları** — Hata raporları ve özellik talepleri için yapılandırılmış YAML
  şablonları (`.github/ISSUE_TEMPLATE/bug_report.yaml`, `feature_request.yaml`).

#### CI/CD
- **ADMX Doğrulama Boru Hattı** (`.github/workflows/admx-validate.yml` + `.ps1`):
  - Haftalık (Pazartesi 06:00 UTC) ve `workflow_dispatch` ile çalışır.
  - Chromium ADMX şablonlarını indirir, politika tanımlarını ayrıştırır ve betiğin
    politika listesiyle karşılaştırır.
  - Tür uyuşmazlıklarını, ADMX'te bulunan yeni politikaları ve betikte olup ADMX'te
    olmayan politikaları raporlar.
  - Uyuşmazlık bulunduğunda otomatik olarak bir GitHub sorunu oluşturur.
  - Yardımcı betik (`admx-validate.ps1`) bağımsız olarak da kullanılabilir.

### 🔧 Değiştirildi

- **BraveOmega-EN.ps1** — v2.1 özellikleri: sürüm denetimi, -WhatIf, -Sıfırla,
  `$ScriptVersion = "v2.1"`
- **BraveOmega-TR.ps1** — v2.1 özellikleri Türkçe olarak yansıtıldı
- **CHANGELOG.md** — v2.1 değişiklik günlüğü eklendi (bu bölüm)

### 📊 İstatistikler

```
Eklenen/Değiştirilen Dosyalar:
  ✓ BraveOmega-EN.ps1 (v2.1: sürüm denetimi, -WhatIf, -Sıfırla)
  ✓ BraveOmega-TR.ps1 (v2.1: yansıtılan değişiklikler)
  ✓ CONTRIBUTING.md (yeni — kapsamlı katkı rehberi, EN + TR)
  ✓ .github/ISSUE_TEMPLATE/bug_report.yaml (yeni)
  ✓ .github/ISSUE_TEMPLATE/feature_request.yaml (yeni)
  ✓ .github/workflows/admx-validate.yml (yeni — haftalık + manuel)
  ✓ .github/workflows/admx-validate.ps1 (yeni — bağımsız doğrulama betiği)
  ✓ CHANGELOG.md (v2.1 girdisi)
  ✓ README.md (güncel yol haritası, katkı referansı)
  ✓ index.html (güncel değişiklik günlüğü, hızlı başlangıç, rozetler)
```

---

<a id="tr-v20"></a>

## [v2.0] — 2026-06-16

<a id="tr-v20-summary"></a>

### 🎯 Özet

**Köklü mimarî yenileme:** **Çok Katmanlı Sıkılaştırma Sistemi** — kullanıcılara gizlilik duruşları üzerinde hassas kontrol sağlayan dört kademeli seviye (Brave Yalnız, Temel, Dengeli, Katı). Toplam kurumsal politika sayısı **17'den 68'e** çıkarıldı.

**Brave 1.91.172 (Chromium 149.0.7827.115) ile doğrulandı.**

<a id="tr-v20-added"></a>

### ✨ Eklendi

#### Çok Katmanlı Mimari
- **4 Kademeli Sıkılaştırma Modeli** — Brave Yalnız → Temel ⭐ → Dengeli → Katı
- **Kümülatif miras** — her seviye önceki seviyelerin tüm politikalarını içerir
- **Etkileşimli seviye seçimi** parametresiz çalıştırmada
- **`-Level` parametresi** otomatik/sessiz dağıtım için (`-Level Temel`)
- İngilizce `-Level` parametresi desteği (`-Level Essential`, `-Level Balanced`, `-Level Strict`)
- **Önerilen seviye** (Temel) seçim menüsünde yıldız rozetiyle vurgulandı

#### Kayıt Defteri Türü Motoru
- **DWord** (REG_DWORD) desteği boolean/tamsayı politikalar için
- **String** (REG_SZ) desteği string-enum politikalar için (WebRtcIPHandling, HttpsOnlyMode, DnsOverHttpsMode)
- **MultiString** (REG_MULTI_SZ) desteği liste politikalar için (WebRtcLocalIpsAllowedUrls)
- **Tür bilinçli dağıtım** — betik her politika için doğru kayıt defteri yazma yöntemini otomatik seçer

#### Seviyelere Göre Yeni Politikalar

**Temel (17 yeni — veri sızıntısı önleme, sıfır kullanım etkisi):**
| Politika | Değer | Etki |
|----------|-------|------|
| `UrlKeyedAnonymizedDataCollectionEnabled` | 0 | Ziyaret edilen URL'lerin Google'a gönderimini durdurur |
| `SearchSuggestEnabled` | 0 | Tuş vuruşu verisinin cihazdan çıkmasını durdurur |
| `NetworkPredictionOptions` | 2 | DNS ön getirme ve ön bağlantıyı durdurur |
| `TranslateEnabled` | 0 | Metnin Google'a çeviri için gönderilmesini durdurur |
| `SpellcheckEnabled` | 0 | Metnin Google yazım denetim sunucularına gitmesini durdurur |
| `AlternateErrorPagesEnabled` | 0 | DNS hatasında ağ isteklerini durdurur |
| `BrowserNetworkTimeQueriesEnabled` | 0 | Google'a zaman eşitleme isteklerini durdurur |
| `DomainReliabilityAllowed` | 0 | Google'a tanısal veri raporlamasını durdurur |
| `BackgroundModeEnabled` | 0 | Tüm pencereler kapandığında Brave'in çalışmasını engeller |
| `SafeBrowsingSurveysEnabled` | 0 | Tarama sonrası anketleri kapatır |
| `SafeBrowsingDeepScanningEnabled` | 0 | Sunucu taraflı indirme taramasını kapatır |
| `WebRtcEventLogCollectionAllowed` | 0 | WebRTC olay günlüklerinin Google'a yüklenmesini durdurur |
| `WebRtcTextLogCollectionAllowed` | 0 | WebRTC metin günlüklerinin Google'a yüklenmesini durdurur |
| `AudioCaptureAllowed` | 0 | Mikrofon erişimini varsayılan olarak engeller |
| `VideoCaptureAllowed` | 0 | Kamera erişimini varsayılan olarak engeller |

**Dengeli (16 yeni — güvenlik ve kullanım dengesi):**
| Politika | Değer | Etki |
|----------|-------|------|
| `WebRtcIPHandling` | `default_public_interface_only` | Yerel IP'leri WebRTC'den gizler |
| `WebRtcLocalIpsAllowedUrls` | `@()` (boş) | Hiçbir URL'nin ICE ile yerel IP almasını engeller |
| `HttpsOnlyMode` | `force_enabled` | Tüm gezintileri HTTPS'e zorlar |
| `DnsOverHttpsMode` | `automatic` | DNS sorgularını şifreli olarak yükseltir |
| `BlockThirdPartyCookies` | 1 | Siteler arası izleme çerezlerini engeller |
| `PasswordManagerEnabled` | 0 | Yerleşik parola kaydetmeyi kapatır |
| `PasswordManagerPasskeysEnabled` | 0 | Passkey kaydetmeyi kapatır |
| `AutofillAddressEnabled` | 0 | Adres otomatik doldurma depolamayı kapatır |
| `AutofillCreditCardEnabled` | 0 | Ödeme otomatik doldurma depolamayı kapatır |
| `ShowFullUrlsInAddressBar` | 1 | Tam URL'leri gösterir (oltalamaya karşı) |
| `DisableSafeBrowsingProceedAnyway` | 1 | Kötü amaçlı site uyarılarını atlamayı engeller |
| `QuicAllowed` | 0 | QUIC'i kapatır, TCP/TLS'e düşer |
| `ChromeVariations` | 1 | Yalnızca kritik saha denemelerine izin verir |
| `NetworkServiceSandboxEnabled` | 1 | Ağ hizmetini kum havuzlu süreçte çalıştırır |
| `AudioSandboxEnabled` | 1 | Ses hizmetini kum havuzlu süreçte çalıştırır |
| `DefaultGeolocationSetting` | 2 | Konum erişimini varsayılan olarak engeller |
| `DefaultNotificationsSetting` | 2 | Bildirimleri varsayılan olarak engeller |
| `DefaultPopupsSetting` | 2 | Açılır pencereleri varsayılan olarak engeller |
| `DefaultMediaStreamSetting` | 2 | Kamera/mikrofonu varsayılan olarak engeller |

**Katı (22 yeni — azami gizlilik):**
| Politika | Değer | Etki |
|----------|-------|------|
| `WebRtcIPHandling` (ezme) | `disable_non_proxied_udp` | Tüm WebRTC trafiğini vekil sunucu üzerinden yönlendirir |
| `DefaultSensorsSetting` | 2 | Hareket/ışık sensörü erişimini engeller |
| `DefaultLocalFontsSetting` | 2 | Yazı tipi sayımını engeller (parmak izini azaltır) |
| `DefaultClipboardSetting` | 2 | Pano erişimini engeller |
| `DefaultFileSystemReadGuardSetting` | 2 | Dosya sistemi okuma erişimini engeller |
| `DefaultFileSystemWriteGuardSetting` | 2 | Dosya sistemi yazma erişimini engeller |
| `DefaultSerialGuardSetting` | 2 | Seri API erişimini engeller |
| `DefaultIdleDetectionSetting` | 2 | Boşta durum algılamasını engeller |
| `DefaultInsecureContentSetting` | 2 | Karma içeriği engeller |
| `DefaultJavaScriptJitSetting` | 2 | JIT'i kapatır (saldırı yüzeyini azaltır) |
| `DefaultCookiesSetting` | 2 | Tüm çerezleri varsayılan olarak engeller |
| `BrowserGuestModeEnabled` | 0 | Misafir profili oluşturmayı engeller |
| `BrowserAddPersonEnabled` | 0 | Yeni profil oluşturmayı engeller |
| `CloudPrintProxyEnabled` | 0 | Cloud Print vekil sunucusunu kapatır |
| `ImportAutofillFormData` | 0 | Otomatik doldurma içe aktarmayı kapatır |
| `ImportBookmarks` | 0 | Yer imi içe aktarmayı kapatır |
| `ImportHistory` | 0 | Geçmiş içe aktarmayı kapatır |
| `ImportSavedPasswords` | 0 | Parola içe aktarmayı kapatır |
| `ImportSearchEngine` | 0 | Arama motoru içe aktarmayı kapatır |
| `ImportHomepage` | 0 | Ana sayfa içe aktarmayı kapatır |

#### Belgelendirme
- **SECURITY.md** — Kapsamlı güvenlik politikası (EN + TR)
- Tam güvenlik açığı bildirim süreci belgelendi
- Politika doğrulama kılavuzu ve kayıt defteri denetim komutları
- Sıkılaştırma seviyesi karşılaştırma tablosu
- Tedarik zinciri güven önerileri

<a id="tr-v20-changed"></a>

### 🔄 Değiştirildi

- **BraveOmega-EN.ps1** — Tam yeniden yazım: çok katmanlı sistem, -Level parametresi, tür bilinçli kayıt defteri motoru (565 → 520 satır)
- **BraveOmega-TR.ps1** — Tam yeniden yazım: aynı mimari Türkçe (567 → 522 satır)
- **README.md** — Çok katmanlı sistem için güncellendi (Temel Özellikler, Hızlı Başlangıç -Level ile, genişletilmiş Politika Referansı)
- **CHANGELOG.md** — v2.0 değişiklik günlüğü eklendi (bu dosya)
- **index.html** — 4 kademeli sistem belgelendirmesi, sürüm referansları, yeni rozetler ile güncellendi

<a id="tr-v20-statistics"></a>

### 📊 İstatistikler

```
Değiştirilen Dosyalar:
  ✓ BraveOmega-EN.ps1 (565 → 520 satır, tam yeniden yazım)
  ✓ BraveOmega-TR.ps1 (567 → 522 satır, tam yeniden yazım)
  ✓ README.md (çok katmanlı belgelendirme)
  ✓ CHANGELOG.md (v2.0 girdisi)
  ✓ index.html (4 kademeli sistem, sürüm referansları)
  ✓ SECURITY.md (yeni dosya, 500+ satır)
  ✓ Knowledge-Intelligence/README.md (kaynak güncellemeleri)

Politikalar:
  ✓ Brave Yalnız:  13 Brave'e özgü politika
  ✓ Temel:         +17 = 30 toplam politika (Önerilen)
  ✓ Dengeli:       +16 = 46 toplam politika
  ✓ Katı:          +22 = 68 toplam politika
  ✓ Toplam:        17 → 68 politika (+300%)

Kayıt Defteri Türleri:
  ✓ DWord:      61 politika
  ✓ String:     4 politika
  ✓ MultiString: 3 politika

Belgelendirme:
  ✓ SECURITY.md (yeni — kapsamlı güvenlik politikası, EN + TR)
  ✓ README.md (çok katmanlı sistem belgelendi)
  ✓ CHANGELOG.md (bu dosya)
  ✓ index.html (4 kademeli mimari, güncel rozetler)
``` — kalıcı `RemoteSigned -Scope CurrentUser` yerine oturum bazlı `Bypass -Scope Process` kullanıldı. v1.2.1'den itibaren politika değişikliği yok.

**Değişiklikler:** Çalıştırma ilkesi talimatı artık `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` kullanıyor; bu ayar yalnızca geçerli PowerShell penceresini etkiler (kalıcı kayıt defteri değişikliği yok, saldırı yüzeyi oluşmaz). README Hızlı Başlangıç yeniden yapılandırıldı. Görünür UI metinlerinde Türkçe karakter düzeltmeleri yapıldı.

<a id="tr-v122-changed"></a>

### 🔧 Değiştirildi

- **index.html**: `prereq_pol_desc` (EN + TR) kalıcı `RemoteSigned -Scope CurrentUser` yerine oturum bazlı `-Scope Process Bypass` kullanacak şekilde güncellendi
- **index.html**: `rm_item3` geri dönüş metnindeki Türkçe karakterler düzeltildi
- **index.html**: Sürüm referansları v1.2.1'den v1.2.2'ye güncellendi
- **README.md**: Hızlı Başlangıç'taki kalıcı çalıştırma ilkesi adımı oturum bazlı bypass ile değiştirildi (EN + TR)
- **README.md**: Sürüm uyumluluk matrisi v1.2.2 + v1.2.1'i içerecek şekilde güncellendi
- **CHANGELOG.md**: v1.2.2 değişiklik günlüğü eklendi

---

<a id="tr-v121"></a>

## [v1.2.1] — 2026-06-13

<a id="tr-v121-summary"></a>

### 🎯 Özet

**Yama sürümü:** Brave sürüm yükseltmesi 1.91.172 (Chromium 149.0.7827.115). v1.2'den itibaren politika değişikliği yok.

**Değişiklikler:** Çeviri uyum düzeltmesi (22 eksik politika etkisi anahtarı EN/TR için eklendi), eksik kaynaklar bölüm başlığı eklendi, lisans bölümü çevirisi bağlandı, öksüz çeviri anahtarları düzeltildi.

<a id="tr-v121-changed"></a>

### 🔧 Değiştirildi

- **index.html**: EN ve TR için 23 eksik çeviri anahtarı eklendi (pol_effect1–17, policies_badge/heading/desc, policy_col_key/effect, sources_badge)
- **index.html**: Kaynaklar bölümüne eksik `<h2>` başlık ve rozet eklendi, data-i18n desteği ile
- **index.html**: Lisans bölümü başlığına license_heading data-i18n bağlandı
- **index.html**: Sürüm referansları v1.2'den v1.2.1'e güncellendi
- **README.md**: Sürüm uyumluluk matrisi v1.2.1'i içerecek şekilde güncellendi
- **CHANGELOG.md**: v1.2.1 değişiklik günlüğü eklendi

<a id="tr-v12"></a>

## [v1.2] — 2026-06-12

<a id="tr-v12-summary"></a>

### 🎯 Özet

**Büyük genişleme:** Toplam **7'den 17'ye** çıkarılan 10 yeni kurumsal politika eklendi. Bu, gizlilik sıkılaştırma kapsamının **%143 genişlemesi** anlamına geliyor. Tüm yeni politikalar ADMX doğrulamalı ve Chromium 149 ile uyumludur.

**Brave 1.91.172 (Chromium 149.0.7827.115) ile doğrulandı.**

<a id="tr-v12-added"></a>

### ✨ Eklendi

#### Telemetri ve Analiz (2 politika)
- `BraveP3AEnabled = 0` — Gizliliği Koruyan Ürün Analizlerini (P3A) devre dışı bırakır
- `BraveWebDiscoveryEnabled = 0` — Web Keşif Projesi veri katkısını devre dışı bırakır

#### Entegre Hizmetler (3 politika)
- `BraveTalkDisabled = 1` — Brave Talk video konferansını devre dışı bırakır
- `BraveNewsDisabled = 1` — Brave Haber akışını devre dışı bırakır
- `BravePlaylistEnabled = 0` — Brave Çalma Listesini devre dışı bırakır

#### Okuyucu ve Keşif (2 politika)
- `BraveSpeedreaderEnabled = 0` — Hızlı Okuyucu modunu devre dışı bırakır
- `BraveWaybackMachineEnabled = 0` — Wayback Machine entegrasyonunu devre dışı bırakır

#### Ağ ve Diğer (1 politika)
- `TorDisabled = 1` — Tor ağı entegrasyonunu devre dışı bırakır

#### Belgelendirme
- Sürüm Uyumluluk Matrisi güncellendi (şimdi v1.0, v1.1, v1.2 gösteriyor)
- Tüm 17 politikayı içeren Politika Referans tablosu genişletildi
- Mimari diyagramlar güncellendi (7 → 17 politika)
- Hem İngilizce hem de Türkçe versiyonlar tamamen güncellendi

<a id="tr-v12-statistics"></a>

### 📊 İstatistikler

```
Değiştirilen Dosyalar:
  ✓ BraveOmega-TR.ps1 (497 → 567 satır)
  ✓ BraveOmega-EN.ps1 (496 → 565 satır)
  ✓ README.md (sürüm uyumluluğu, politika tablosu)

Politikalar:
  ✓ Toplam: 7 → 17 (+143%)
  ✓ HKLM Kurumsal Politikalar: 7 → 15 (+114%)
  ✓ Kategoriler: 3 → 5 (+67%)

Belgelendirme:
  ✓ UPDATE_REPORT_v1.2.md (iki dilli güncelleme özeti)
  ✓ POLICY_UPDATE_v1.2.md (detaylı politika referansı)
  ✓ CHANGELOG.md (bu dosya)
```

<a id="tr-v12-changed"></a>

### 🔄 Değiştirildi

- Betik başlık sürümleri v1.2 değişiklik günlüğü ile güncellendi
- Sürüm Uyumluluk Matrisi yeniden düzenlendi (v1.0/v1.1/v1.2)
- Politika referansı kapsamlı bir şekilde genişletildi
- Mimari diyagramlar güncellendi (7 → 17 politika sayısı)

<a id="tr-v12-security"></a>

### 🛡️ Güvenlik

- Tüm yeni politikalar Brave'in resmi ADMX şablonlarına göre doğrulandı
- Tüm yeni politikalar Chromium 149 kurumsal belgelendirmesi ile çapraz referanslandı
- Kırıcı değişiklik yok; v1.1 sistemleriyle geriye dönük uyumlu

---

<a id="tr-v11"></a>

## [v1.1] — 2026-06-05

<a id="tr-v11-summary"></a>

### 🎯 Özet

7 ana iyileştirme içeren kapsamlı hata ayıklama ve geliştirme sürümü. Brave süreç koruyucuları, kayıt defteri yedeklemeleri ve try-catch hata yönetimi tanıtıldı.

<a id="tr-v11-added"></a>

### ✨ Eklendi

- **Brave Süreç Koruyucusu** — Çalıştırmadan önce etkin Brave örneklerini algılar
- **Kayıt Defteri Yedeklemesi** — HKLM değişikliklerinden önce zaman damgalı otomatik .reg dosya yedeklemesi
- **Gelişmiş Hata Yönetimi** — Tüm kayıt defteri işlemleri üzerinde başarı/hata sayaçları ile try-catch blokları
- **Yürütme Özeti** — Şeffaf başarı/hata metrikleri ile kategori bazında raporlama

<a id="tr-v11-changed"></a>

### 🔄 Değiştirildi

- Çıkış kodları düzeltildi: Başarısızlık durumunda `exit 1` (önceden 0 döndürüyordu)
- Dizin hazırlığı basitleştirildi: Gereksiz Test-Path yerine tek satırlık `-Force` parametresi
- Omaha GUID işleme: Önceden ölü değişken, artık algılanan yollara `usagestats=0` yazar

<a id="tr-v11-removed"></a>

### ❌ Kaldırıldı

- **BraveShieldsDefault = 2** — Bu politika Brave'in resmi ADMX'inde mevcut değildir. İşlevsel olmayan kayıt defteri girdileri oluşturmayı önlemek için kaldırıldı.

<a id="tr-v11-details"></a>

### 📋 Detaylar

| Değişiklik # | Tür | Açıklama |
|--------------|-----|----------|
| #1 | Düzeltme | Mevcut olmayan BraveShieldsDefault politikası kaldırıldı |
| #2 | Ekleme | Kayıt defteri işlemlerine try-catch hata yönetimi eklendi |
| #3 | Düzeltme | Omaha GUID usagestats=0 yazma işlemi uygulandı (ölü koddu) |
| #4 | Ekleme | Kullanıcı istemi ile Brave süreç algılama eklendi |
| #5 | Düzeltme | Otomasyon aracı uyumluluğu için çıkış kodları düzeltildi |
| #6 | Ekleme | Otomatik HKLM yedeklemesi uygulandı |
| #7 | Basitleştirme | New-Item öncesi gereksiz Test-Path kontrolü kaldırıldı |

---

<a id="tr-v10"></a>

## [v1.0] — 2026-06-04

<a id="tr-v10-summary"></a>

### 🎯 Özet

İlk topluluk sürümü. Brave Tarayıcı için üç kayıt defteri katmanında (HKCU, HKLM, Omaha) kurumsal politika sıkılaştırması ile kararlı, test edilmiş sıkılaştırma otomasyonu.

<a id="tr-v10-features"></a>

### ✨ Özellikler

- **7 Kurumsal Politika** — Temel telemetri ve hizmet devre dışı bırakma için tüm ADMX doğrulamalı politikalar
- **3 Katmanlı Mimari** — HKCU kullanıcı tercihi + HKLM kurumsal politika + Omaha güncelleyici GUID
- **Kararsız Olmayan Çalışma** — Tutarlı sonuçlarla birden çok kez güvenle çalıştırılabilir
- **İki Dilli Arayüz** — Tam Türkçe ve İngilizce desteği
- **Derinlemesine Savunma** — Windows Kayıt Defteri hiyerarşisi boyunca katmanlı yaklaşım
- **Süreç Koruyucusu** — Değişiklik yapmadan önce Brave'in açık olup olmadığını uyarır
- **Otomatik Yedeklemeler** — Kayıt defteri değişikliklerinden önce zaman damgalı .reg yedeklemeleri

<a id="tr-v10-initial-policies"></a>

### 📋 Başlangıç Politikaları

```
1. UsageStatsInSample = 0 (HKCU)         — Kullanım istatistikleri örneklemesini devre dışı bırak
2. BraveRewardsDisabled = 1 (HKLM)       — Ödülleri devre dışı bırak
3. BraveWalletDisabled = 1 (HKLM)        — Cüzdanı devre dışı bırak
4. BraveVPNDisabled = 1 (HKLM)           — VPN'i devre dışı bırak
5. BraveAIChatEnabled = 0 (HKLM)         — Leo Yapay Zeka Sohbetini devre dışı bırak
6. BraveStatsPingEnabled = 0 (HKLM)      — İstatistik pinglerini devre dışı bırak
7. MetricsReportingEnabled = 0 (HKLM)    — Metrikleri devre dışı bırak
8. SafeBrowsingExtendedReportingEnabled = 0 (HKLM) — Genişletilmiş Güvenli Tarama raporlarını devre dışı bırak
9. usagestats = 0 (Omaha GUID)           — Güncelleyici telemetrisini devre dışı bırak
```

<a id="tr-v10-documentation"></a>

### 📚 Belgelendirme

- İngilizce ve Türkçe kapsamlı README.md
- Açıklamalı politika referans tabloları
- Her iki dil için hızlı başlangıç kılavuzu
- Sorun giderme bölümü
- Güvenlik ve Emniyet bölümü
- Proje yol haritası

---

<a id="tr-version-history-summary"></a>

## Sürüm Geçmişi Özeti

| Sürüm | Tarih      | Politikalar | Ana Değişiklikler |
|-------|------------|-------------|-------------------|
| v2.1   | 2026-06-16 | 68    | Sürüm denetimi, -WhatIf, -Sıfırla, CONTRIBUTING.md, GitHub Actions |
| v2.0   | 2026-06-16 | 13–68 | Çok Katmanlı Sistem (Brave Yalnız / Temel / Dengeli / Katı) |
| v1.2.2 | 2026-06-13 | 17 | Güvenli çalıştırma ilkesi düzeltmesi, v1.2.2 branding |
| v1.2.1 | 2026-06-13 | 17 | Brave 1.91.172 yükseltmesi, çeviri ve yapı düzeltmeleri |
| v1.2 | 2026-06-12 | 17 | +10 yeni politika, Brave 1.91.172 doğrulaması |
| v1.1 | 2026-06-05 | 7 | Hata yönetimi, yedeklemeler, süreç koruyucuları |
| v1.0 | 2026-06-04 | 7 | İlk sürüm, 3 katmanlı mimari |

---

<a id="tr-related-documentation"></a>

## 🔗 İlgili Belgelendirme

- **README.md** — Tam kullanıcı belgelendirmesi (EN + TR)
- **CONTRIBUTING.md** — Katkıda bulunan rehberi (EN + TR)
- **LICENSE** — MIT Lisans koşulları
- **Brave Omega/** — PowerShell betikleri dizini

---

<a id="tr-notes"></a>

## 📌 Notlar

- Tüm sürümler geriye dönük uyumluluğu korur
- Sürümler arasında kırıcı değişiklik yoktur
- Her sürüm belirtilen Brave ve Chromium sürümlerine karşı bağımsız olarak test edilmiştir
- Topluluk katkıları memnuniyetle karşılanır; README'deki katkı yönergelerini takip edin

---

<div align="center">

**🦁 Brave Omega Project** — Topluluk Sürümü

*Gizlilik odaklı tarayıcı sıkılaştırması inşa ediliyor, her seferinde bir politika.*

</div>