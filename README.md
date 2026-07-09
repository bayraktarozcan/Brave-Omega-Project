<!-- ================================================================== -->
<!--                  BRAVE OMEGA PROJECT — README.md                   -->
<!--          Community Edition · Open Source · Privacy First           -->
<!-- ================================================================== -->

<div align="center">

<br>

# 🦁 Brave Omega Project

**Community Edition — Enterprise-Grade Browser Privacy Hardening**

<br>

[![Platform](https://img.shields.io/badge/Platform-Windows%2011%2025H2-0078D4?style=flat-square&logo=windows11&logoColor=white)](https://www.microsoft.com/en-us/windows/windows-11)
[![Brave](https://img.shields.io/badge/Brave-1.92.138%20%7C%20Chromium%20150-FF6000?style=flat-square&logo=brave&logoColor=white)](https://brave.com)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=flat-square&logo=powershell&logoColor=white)](https://learn.microsoft.com/en-us/powershell/)
[![License](https://img.shields.io/badge/License-MIT-22C55E?style=flat-square)](LICENSE)
[![Maintained](https://img.shields.io/badge/Maintained-Yes-22C55E?style=flat-square)](https://github.com/bayraktarozcan/Brave-Omega-Project)
[![Community](https://img.shields.io/badge/Community-Open%20Source-8B5CF6?style=flat-square)](https://github.com/bayraktarozcan/Brave-Omega-Project)
[![Tests](https://img.shields.io/github/actions/workflow/status/bayraktarozcan/Brave-Omega-Project/quality.yml?branch=main&label=Tests&style=flat-square&logo=github)](https://github.com/bayraktarozcan/Brave-Omega-Project/actions/workflows/quality.yml)
[![Pester](https://img.shields.io/badge/Pester-5.0%2B-FF60A0?style=flat-square&logo=powershell&logoColor=white)](https://pester.dev)

<br>

> **Language / Dil** &nbsp;
> [EN English](#-english-documentation) &nbsp;·&nbsp; [TR Türkçe](#-türkçe-belgelendirme)

<br>

</div>

---

<a id="-english-documentation"></a>

## EN English Documentation

### Table of Contents

1. [What is Brave Omega?](#1-what-is-brave-omega)
2. [Why Brave Omega Exists](#2-why-brave-omega-exists)
3. [Key Features](#3-key-features)
4. [Prerequisites](#4-prerequisites)
5. [Quick Start](#5-quick-start)
6. [How It Works](#6-how-it-works)
7. [♻️ Lifecycle Commitment](#7-lifecycle-commitment-throughout-lifecycle-always-up-to-date)
8. [Version Compatibility Matrix](#8-version-compatibility-matrix)
9. [Policy Reference](#9-policy-reference)
10. [Project Structure](#10-project-structure)
11. [Security & Safety](#11-security--safety)
12. [Troubleshooting](#12-troubleshooting)
13. [Roadmap](#13-roadmap)
14. [Contributing](#14-contributing)
15. [License](#15-license)
16. [Disclaimer](#16-disclaimer)

---

### 1. What is Brave Omega?

Brave Omega is an open-source PowerShell automation project that hardens the
[Brave Browser](https://brave.com) through **official enterprise policy channels**. Using
Windows Registry Group Policy architecture and Brave's official ADMX policy framework, it
systematically disables telemetry, analytics services, background pings, integrated
monetization features, and other privacy-eroding components — all without touching the
browser's internals or requiring any third-party tools.

Brave Omega v2.3.0.0 introduces a **five-tier hardening model** — Brave Only (24 policies),
Essential ⭐ (50), Balanced (79), Advanced (91), and Strict (115) — giving users precise control over
their privacy posture, from minimal Brave-specific tweaks to comprehensive enterprise-grade
hardening. Levels are cumulative: each tier includes all policies from previous tiers.

> **Two scripts. One goal. Zero cost.**
>
> `BraveOmega-EN.ps1` — Full English interface, for international users
> `BraveOmega-TR.ps1` — Full Turkish interface, for Turkish-speaking users

---

### 2. Why Brave Omega Exists

Enterprise browser hardening typically demands one of two things: deep technical expertise in
ADMX policy frameworks and registry architecture, or an expensive premium product subscription.
Brave Omega rejects both constraints.

**Everything needed to achieve serious, registry-enforced browser privacy hardening is already
present in the free, open-source Brave Browser.** The enforcement architecture lives in Brave's
official ADMX templates. The mechanism is built into Windows Registry Group Policy. The knowledge
exists in the official documentation. The only missing piece was a validated, automated, and
well-documented bridge between these components.

Brave Omega builds that bridge — and keeps it current throughout the browser's lifecycle.

---

### 3. Key Features

| Feature | Description |
|---------|-------------|
| 🔒 **Five-Tier Privacy Model** | Choose your hardening level: **Brave Only** (24 policies), **Essential ⭐** (50 policies), **Balanced** (79), **Advanced** (91), or **Strict** (115) |
| 🌐 **Multi-Type Registry Engine** | Supports DWord, String, and MultiString registry types — MultiString uses .NET API (`[Microsoft.Win32.Registry]`) natively since PowerShell lacks `REG_MULTI_SZ` cmdlets |
| 📋 **ADMX-Validated Policies** | Every policy entry sourced and verified against Brave's official ADMX templates and Chromium's policy documentation |
| 🔄 **Idempotent Execution** | Run the script any number of times — same safe, consistent result every time |
| 💾 **Automatic Backup** | Time-stamped `.reg` backup of the HKLM policy hive before any modifications (stored at `$env:TEMP\BravePolicyBackup\`) |
| 🔁 **One-Command Rollback** | Full restoration with a single command: `reg import "<backup_file.reg>"` |
| 🛡️ **Brave Process Guard** | Detects running Brave instances and presents a continue/cancel decision before applying changes |
| 🔍 **Version Check** | Automatically detects installed Brave version and warns on mismatch with validated target |
| 👁️ **Dry-Run Mode** | `-WhatIf` parameter previews all changes without writing to the registry — cascades through every nested function for full fidelity |
| 🧹 **Clean Uninstall** | `-Reset` parameter removes all applied Brave Omega policies from HKLM, HKCU, and Omaha GUIDs |
| 🎯 **Dynamic Omaha GUID Discovery** | Scans registry recursively with regex to find Omaha updater GUIDs — no hardcoded IDs, resilient to version changes |
| 🔄 **CI/CD Validation** | GitHub Actions pipeline validates policy definitions against official ADMX templates weekly |
| 📊 **Execution Summary** | Per-category success/failure type counts with transparent reporting; exit code 0 (success) / 1 (failure) for CI/CD integration |
| 🌍 **Bilingual** | Full Turkish and English versions with identical functionality and parity |
| 🧹 **Terminal Encoding Hardening** | Sets `[Console]::Input/OutputEncoding` to UTF-8 on launch — prevents Turkish character corruption, ensures clean text throughout execution |

---

### 4. Prerequisites

| Requirement | Detail |
|-------------|--------|
| **Operating System** | Windows 11 (recommended: latest stable build of 25H2) |
| **Browser** | **Brave Browser — latest stable release** (see [brave.com/download](https://brave.com/download)) |
| **PowerShell** | 5.1+ (included with Windows 11 — no additional installation needed) |
| **Privileges** | Run as Administrator (required for HKLM registry writes) |
| **Execution Policy** | `Bypass` (session-scoped only — see Quick Start) |

> [!IMPORTANT]
> **Always use the latest stable Brave release before running this script.**
> Brave's enterprise policy landscape evolves with every Chromium update. Running this script
> against an outdated Brave version may result in unrecognized policy keys, mismatched registry
> types, or missing features. Verify your version at
> [brave.com/latest](https://brave.com/latest) and cross-check with the
> [Version Compatibility Matrix](#8-version-compatibility-matrix) before proceeding.

---

### 5. Quick Start

**Step 1 — Open PowerShell as Administrator**
Right-click the PowerShell icon → **Run as Administrator**

**Step 2 — Navigate to the project folder**
```powershell
cd "C:\Users\Downloads\Brave-Omega"
```

**Step 3 — Run the script with temporary bypass**

*Interactive mode (you choose the hardening level when prompted):*
```powershell
# English interface:
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1"

# Turkish interface:
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"
```

*Silent/automated mode (specify level directly):*
```powershell
# Apply Essential (Recommended):
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1" -Level Essential

# Turkish: apply minimal Brave-only policies:
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Level "Brave Yalnız"
```

*Preview mode (show all changes without writing to registry):*
```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1" -Level Essential -WhatIf
```

*Reset/clean uninstall (remove all applied policies):*
```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1" -Reset
```

| Parameter Value (EN) | Parameter Value (TR) | Level | Policies |
|---------------------|---------------------|-------|----------|
| `-Level BraveOnly` | `-Level "Brave Yalnız"` | Brave Only | 24 |
| `-Level Essential` | `-Level Temel` | Essential ⭐ | 50 |
| `-Level Balanced` | `-Level Dengeli` | Balanced | 79 |
| `-Level Advanced` | `-Level Gelişmiş` | Advanced | 91 |
| `-Level Strict` | `-Level Katı` | Strict | 115 |

> The `-ExecutionPolicy Bypass` flag applies only to this single command. No permanent execution policy change is made — close the window and everything resets.

**Step 4 — Restart Brave**
Close all Brave windows completely and reopen. Changes take effect immediately on next launch.

**Step 5 — Verify**
Navigate to `brave://policy` in Brave to confirm all enterprise policies are active and
applied correctly.

---

### 6. How It Works

#### 6.1 Architecture — Four-Tier Enforcement Model

Brave Omega operates at **two infrastructure layers** (HKLM policies + HKCU fallbacks)
and offers **four hardening levels** that determine how many policies are applied.

##### Infrastructure Layers

```
┌─────────────────────────────────────────────────────────────┐
│  TIER 1 — HKCU (User Preference Layer)                     │
│  HKCU:\Software\BraveSoftware\Brave-Browser                 │
│  ↳  UsageStatsInSample = 0                                  │
│     ChromeVariations = 1 (HKCU)                             │
│     Chromium user-level telemetry sampling disabled.        │
│     Provides a fallback during policy propagation delays.   │
├─────────────────────────────────────────────────────────────┤
│  TIER 2 — HKLM (Enterprise Policy Layer / ADMX)            │
│  HKLM:\SOFTWARE\Policies\BraveSoftware\Brave                │
│  ↳  24–115 ADMX-validated enterprise policies (level-based).     │
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

##### Hardening Levels

| Level | Total Policies | Brave-Specific | Chromium (Data) | Chromium (Security) | Usability Impact |
|-------|---------------|----------------|-----------------|---------------------|-----------------|
| **Brave Only** | 24 | 24 | 0 | 0 | None |
| **Essential ⭐** | 50 | 24 | 26 | 0 | None |
| **Balanced** | 79 | 24 | 26 | 29 | Low |
| **Advanced** | 91 | 24 | 26 | 41 | Low |
| **Strict** | 115 | 24 | 26 | 66 | High |

#### 6.2 Policy Sources & Methodology

> **Core principle: Zero unofficial or speculative registry changes.**

Every policy applied in this project is traceable to one of the following authoritative sources.
Nothing is guesswork. If a policy cannot be verified through official documentation, it is
excluded — along with a documented explanation of why.

| Source | Policies Covered |
|--------|-----------------|
| **Brave Official ADMX Template Package** (`policy_templates.zip`) | `BraveRewardsDisabled`, `BraveWalletDisabled`, `BraveVPNDisabled`, `BraveAIChatEnabled`, `BraveStatsPingEnabled` |
| **Chromium Enterprise Policy Documentation** | `MetricsReportingEnabled`, `SafeBrowsingExtendedReportingEnabled` |
| **Google Omaha Updater Architecture** | `usagestats` (per GUID, in HKCU update layer) |
| **Chromium Preferences Schema** | `UsageStatsInSample` (HKCU user preference) |

> [!NOTE]
> **`BraveShieldsDefault` was intentionally excluded.** Despite appearing in some community guides,
> this policy name does not exist in Brave's official ADMX templates. Brave manages Shields
> via URL-based policies (`BraveShieldsEnabledForUrls`, `BraveShieldsDisabledForUrls`). Global
> aggressive mode is applied through user profile preferences (Preferences JSON), not through an
> enterprise registry policy. Including an unrecognized key would create a registry entry that
> appears to work but has zero actual effect. This project documents why each exclusion was made,
> not only what was included.

---

### 7. ♻️ Lifecycle Commitment: Throughout Lifecycle Always Up-to-Date

> **A privacy hardening tool that falls out of date is not a safeguard — it is a false sense of security.**

Browser policy landscapes change with every major Chromium release. Policy keys get renamed,
deprecated, or superseded. New privacy-relevant controls are introduced. An unmaintained
hardening script drifts into irrelevance — or worse, silently applies stale configurations that
no longer have any effect.

**Brave Omega is built around a lifecycle-first commitment:**

- **Version Pinning** — Every script release is explicitly tagged in its header with the
  exact validated Brave + Chromium version combination. There is no ambiguity about what
  environment the script was tested against.

- **Policy Review on Every Brave Stable Release** — When Brave ships a new stable version,
  the ADMX template package is reviewed against the previous version. New policies are
  evaluated, deprecated ones are removed, and changed behavior is documented.

- **Breaking Change Notices** — Any removed or renamed policy key is documented in the
  changelog with a migration note. Users upgrading Brave versions will know exactly what
  changed and why.

- **Community-Driven Currency** — Version mismatches, newly deprecated keys, and
  newly available policies identified by contributors are reviewed and merged promptly.

- **Always-Stable Recommendation** — The project consistently recommends the **latest stable
  Brave release**. Beta and Nightly builds may not have fully stabilized ADMX behavior and
  are not the primary validation target.

---

### 8. Version Compatibility Matrix

| Brave Omega | Brave Version | Chromium | Windows | Status |
|-------------|---------------|----------|---------|--------|
| **v2.3.0.0** *(current)* | 1.92.138 | 150 | 11 25H2 | ✅ Active |
| **v2.2.1.0** | 1.92.134 | 150 | 11 25H2 | 📦 Previous |
| **v2.2.0.2** | 1.92.134 | 150 | 11 25H2 | 📦 Previous |
| **v2.2.0.1** | 1.92.134 | 150 | 11 25H2 | 📦 Previous |
| **v2.2.0** | 1.92.134 | 150 | 11 25H2 | 📦 Previous |
| **v2.1.6** | 1.92.134 | 150 | 11 25H2 | 📦 Previous |
| **v2.1.5** | 1.92.134 | 150 | 11 25H2 | 📦 Previous |
| **v2.1.4** | 1.91.180 | 149 | 11 25H2 | 📦 Previous |
| **v2.1.3** | 1.91.178 | 149 | 11 25H2 | 📦 Previous |
| v2.1.2 | 1.91.175 | 149 | 11 25H2 | 📦 Previous |
| v2.1.1 | 1.91.172 | 149 | 11 25H2 | 📦 Previous |
| v2.1 | 1.91.172 | 149 | 11 25H2 | 📦 Previous |
| v2.0 | 1.91.172 | 149 | 11 25H2 | 📦 Previous |
| v1.2.2 | 1.91.172 | 149 | 11 25H2 | 📦 Previous |
| v1.2.1 | 1.91.172 | 149 | 11 25H2 | 📦 Previous |
| v1.2 | 1.91.172 | 149 | 11 25H2 | 📦 Previous |
| v1.1 | 1.91.168 | 149 | 11 25H2 | 📦 Previous |
| v1.0 | 1.91.168 | 149 | 11 25H2 | 🔒 Archived |

> [!TIP]
> **Before running:** Verify your installed Brave version against the matrix above.
> If a newer Brave version has been released, check the [Releases](../../releases) page
> for a corresponding updated Brave Omega release before running an older script version.
> When in doubt, always update Brave to the latest stable release first.

---

### 9. Policy Reference

> Brave Omega offers **5 hardening levels** with **115 enterprise policies** total. The policy reference below is organized by registry hive and level.

#### 9.1 HKCU — User-Level Preferences (all levels)

| Registry Key | Hive | Value | Type | Effect |
|--------------|------|-------|------|--------|
| `UsageStatsInSample` | HKCU | `0` | DWord | Disables browser-level usage statistics sampling |
| `ChromeVariations` | HKCU | `1` | DWord | Restricts Chromium to critical field trials only |
| `usagestats` *(per GUID)* | HKCU | `0` | DWord | Disables Omaha updater telemetry per application GUID |

#### 9.2 Brave Only Level — Brave-Specific Policies (24)

| Registry Key | Value | Type | Effect |
|--------------|-------|------|--------|
| `BraveRewardsDisabled` | `1` | DWord | Removes Rewards ad system, BAT token earning |
| `BraveWalletDisabled` | `1` | DWord | Removes integrated crypto wallet, Web3, dDNS |
| `BraveVPNDisabled` | `1` | DWord | Removes VPN button, blocks VPN background service |
| `BraveAIChatEnabled` | `0` | DWord | Disables Leo AI Chat engine |
| `BraveTalkDisabled` | `1` | DWord | Disables Brave Talk video conferencing |
| `BraveNewsDisabled` | `1` | DWord | Disables Brave News feed on New Tab Page |
| `BravePlaylistEnabled` | `0` | DWord | Disables Brave Playlist offline media |
| `BraveSpeedreaderEnabled` | `0` | DWord | Disables Speedreader mode |
| `BraveWaybackMachineEnabled` | `0` | DWord | Disables Wayback Machine integration |
| `BraveP3AEnabled` | `0` | DWord | Disables P3A data transmission |
| `BraveStatsPingEnabled` | `0` | DWord | Stops status/authentication pings to Brave |
| `BraveWebDiscoveryEnabled` | `0` | DWord | Disables Web Discovery Project contribution |
| `TorDisabled` | `1` | DWord | Disables Tor integration |
| `BraveDeAmpEnabled` | `1` | DWord | Bypasses Google AMP pages, redirects to publisher |
| `BraveDebouncingEnabled` | `1` | DWord | Skips known tracking redirect domains |
| `BraveReduceLanguageEnabled` | `1` | DWord | Reduces language fingerprint exposure |
| `BraveTrackingQueryParametersFilteringEnabled` | `1` | DWord | Strips tracking params from URLs |
| `DefaultBraveAdblockSetting` | `2` | DWord | Locks Shields ad blocking to Block |
| `DefaultBraveFingerprintingV2Setting` | `3` | DWord | Locks Shields fingerprinting to Strict |
| `BraveShieldsDisabledForUrls` | `@()` | MultiString | Empty — no Shields whitelist |
| `BraveShieldsEnabledForUrls` | `@()` | MultiString | Empty — no Shields blacklist |
| `BraveLocalAIEnabled` | `0` | DWord | Disables on-device AI features |
| `EmailAliasesEnabled` | `0` | DWord | Disables anonymous email alias feature |

#### 9.3 Essential Level — Brave Only + Data Leak Prevention (17 additional)

| Registry Key | Value | Type | Effect |
|--------------|-------|------|--------|
| `MetricsReportingEnabled` | `0` | DWord | Disables Chromium core metrics collection |
| `SafeBrowsingExtendedReportingEnabled` | `0` | DWord | Stops extended site data to Google |
| `UrlKeyedAnonymizedDataCollectionEnabled` | `0` | DWord | Stops URL data collection to Google |
| `SearchSuggestEnabled` | `0` | DWord | Stops search suggestions data leakage |
| `NetworkPredictionOptions` | `2` | DWord | Stops DNS prefetching and pre-connection |
| `SpellcheckEnabled` | `0` | DWord | Disables spellcheck |
| `AlternateErrorPagesEnabled` | `0` | DWord | Stops error page network requests |
| `BrowserNetworkTimeQueriesEnabled` | `0` | DWord | Stops time sync to Google |
| `DomainReliabilityAllowed` | `0` | DWord | Stops diagnostic data reporting |
| `BackgroundModeEnabled` | `0` | DWord | Prevents Brave running when all windows closed |
| `SafeBrowsingSurveysEnabled` | `0` | DWord | Disables post-browsing surveys |
| `SafeBrowsingDeepScanningEnabled` | `0` | DWord | Disables server-side download scanning |
| `WebRtcEventLogCollectionAllowed` | `0` | DWord | Stops WebRTC event log upload |
| `WebRtcTextLogCollectionAllowed` | `0` | DWord | Stops WebRTC text log upload |
| `AudioCaptureAllowed` | `0` | DWord | Blocks microphone by default |
| `VideoCaptureAllowed` | `0` | DWord | Blocks camera by default |
| `BraveGlobalPrivacyControlEnabled` | `1` | DWord | Sends Global Privacy Control opt-out signal |

#### 9.4 Balanced Level — Essential + Security Baseline (21 additional)

| Registry Key | Value | Type | Effect |
|--------------|-------|------|--------|
| `WebRtcIPHandling` | `"disable_non_proxied_udp"` | String | Proxies all WebRTC traffic |
| `WebRtcLocalIpsAllowedUrls` | `@()` | MultiString | Prevents local IP disclosure via ICE |
| `HttpsOnlyMode` | `"force_enabled"` | String | Forces all navigations to HTTPS |
| `DnsOverHttpsMode` | `"automatic"` | String | Encrypts DNS queries |
| `BlockThirdPartyCookies` | `1` | DWord | Blocks cross-site tracking cookies |
| `PasswordManagerEnabled` | `0` | DWord | Disables built-in password saving |
| `PasswordManagerPasskeysEnabled` | `0` | DWord | Disables passkey saving |
| `AutofillAddressEnabled` | `0` | DWord | Disables address autofill |
| `AutofillCreditCardEnabled` | `0` | DWord | Disables credit card autofill |
| `ShowFullUrlsInAddressBar` | `1` | DWord | Shows full URLs (anti-phishing) |
| `DisableSafeBrowsingProceedAnyway` | `1` | DWord | Prevents bypassing malware warnings |
| `QuicAllowed` | `0` | DWord | Disables QUIC, falls back to TCP/TLS |
| `ChromeVariations` | `1` | DWord | Critical field trials only |
| `NetworkServiceSandboxEnabled` | `1` | DWord | Sandboxes network service |
| `AudioSandboxEnabled` | `1` | DWord | Sandboxes audio service |
| `DefaultGeolocationSetting` | `2` | DWord | Blocks location by default |
| `DefaultNotificationsSetting` | `2` | DWord | Blocks notifications by default |
| `DefaultPopupsSetting` | `2` | DWord | Blocks pop-ups by default |
| `DefaultBraveHttpsUpgradeSetting` | `2` | DWord | Strict HTTPS upgrade with interstitial |
| `DefaultBraveReferrersSetting` | `2` | DWord | Caps referrer to strict-origin-when-cross-origin |
| `BraveSyncUrl` | `"https://sync-v2.brave.com/v2"` | String | Explicit Brave sync server endpoint |

#### 9.5 Advanced Level — Balanced + Enhanced Privacy (11 additional)

| Registry Key | Value | Type | Effect |
|--------------|-------|------|--------|
| `DefaultSensorsSetting` | `2` | DWord | Blocks sensor access by default |
| `DefaultLocalFontsSetting` | `2` | DWord | Blocks font enumeration |
| `DefaultSerialGuardSetting` | `2` | DWord | Blocks Serial API |
| `DefaultIdleDetectionSetting` | `2` | DWord | Blocks idle detection |
| `BrowserGuestModeEnabled` | `0` | DWord | Prevents guest profiles |
| `BrowserAddPersonEnabled` | `0` | DWord | Prevents new profiles |
| `ImportAutofillFormData` | `0` | DWord | Disables autofill import |
| `ImportHistory` | `0` | DWord | Disables history import |
| `ImportSavedPasswords` | `0` | DWord | Disables password import |
| `ImportSearchEngine` | `0` | DWord | Disables search engine import |
| `ImportHomepage` | `0` | DWord | Disables homepage import |

#### 9.6 Strict Level — Advanced + Maximum Privacy (8 additional)

| Registry Key | Value | Type | Effect |
|--------------|-------|------|--------|
| `TranslateEnabled` | `0` | DWord | Disables built-in translation |
| `DefaultClipboardSetting` | `2` | DWord | Blocks clipboard by default |
| `DefaultFileSystemReadGuardSetting` | `2` | DWord | Blocks file system read |
| `DefaultFileSystemWriteGuardSetting` | `2` | DWord | Blocks file system write |
| `DefaultInsecureContentSetting` | `2` | DWord | Blocks mixed content |
| `DefaultJavaScriptJitSetting` | `2` | DWord | Disables JIT compilation |
| `DefaultCookiesSetting` | `2` | DWord | Blocks all cookies by default |
| `ImportBookmarks` | `0` | DWord | Disables bookmark import |
| `DefaultBraveRemember1PStorageSetting` | `2` | DWord | Forgets first-party storage on tab/nav end |

---

### 10. Project Structure

```
BRAVE OMEGA PROJECT/
│
├── .gitignore                          Git exclusion rules
├── .gitattributes
├── LICENSE                             MIT
├── README.md                           Documentation (EN + TR)
├── CHANGELOG.md                        Changelog
├── CONTRIBUTING.md                     Contributing guide (EN + TR)
├── SECURITY.md                         Security policy (EN + TR)
├── index.html                          Landing page (GitHub Pages)
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yaml             Bug report template
│   │   └── feature_request.yaml        Feature request template
│   └── workflows/
│       ├── admx-validate.ps1           ADMX validation script
│       └── admx-validate.yml           ADMX validation pipeline
└── Brave Omega/
        BraveOmega-EN.ps1               Main script — English interface
        BraveOmega-TR.ps1               Main script — Turkish interface
```

---

### 11. Security & Safety

> [!WARNING]
> This script modifies the Windows Registry and **requires Administrator privileges**.
> Always read and understand the source code before executing any PowerShell script as
> Administrator. Never run untrusted scripts with elevated privileges.

| Concern | How Brave Omega Addresses It |
|---------|------------------------------|
| **Unauthorized changes** | Full source is open for review. No obfuscation. No external network calls. No executables. |
| **Unrecoverable state** | Automatic time-stamped `.reg` backup before any HKLM writes. Restore with `reg import`. |
| **Partial application** | Per-operation try-catch with individual success/failure counters. You know exactly what was applied. |
| **Browser data loss** | Brave process detection with explicit continue/cancel prompt before any changes are made. |
| **Repeated execution** | Idempotent design via `-Force` parameter. Running multiple times produces no side effects. |

---

### 12. Troubleshooting

> [!NOTE]
> Brave Omega is validated against the **Stable channel only** (currently Brave 1.92.138 / Chromium 150). ADMX policy behaviors have not been tested on Beta/Nightly builds and may behave differently.

| Symptom | Likely Cause | Resolution |
|---------|-------------|------------|
| Script exits with "CRITICAL ERROR" immediately | Not running as Administrator | Right-click PowerShell → **Run as Administrator** |
| `brave://policy` shows no policies after running | Brave was not restarted | Close all Brave windows and reopen |
| `[ERROR]` lines appear in script output | HKLM path permission issue | Confirm Administrator mode; re-run the script |
| Brave appears to overwrite HKCU preferences | Brave was open during execution | Close Brave first; re-run the script |
| A policy key shows "Unknown" in `brave://policy` | Brave/Chromium version mismatch | Verify installed Brave version matches the compatibility matrix |
| `reg export` fails during backup step | Pre-existing HKLM path has restricted permissions | Run `regedit` to inspect the path; check ACL entries |

---

### 13. Roadmap

- [x] **Multi-tier hardening system** — Brave Only / Essential / Balanced / Strict levels with cumulative inheritance (v2.0)
- [x] **Multi-type registry engine** — DWord, String, MultiString type-aware dispatching (v2.0)
- [x] **`-Level` parameter** — silent/automated deployment without interactive menu (v2.0)
- [x] **SECURITY.md** — comprehensive security policy with vulnerability disclosure process (v2.0)
- [x] **115 total policies** — expanded from 17 to 115 across 5 levels (v2.0–v2.3.0)
- [x] **v2.2.1.0 — Policy Expansion** — 12 new Chromium security/data policies added across Essential and Balanced levels (v2.2.1.0)
- [x] **v2.3.0.0 — Phase 8 Expansion** — 23 new enterprise policies added across all 5 levels: Safe Browsing protection, extension lockdown (block all + forcelist), Incognito disable, developer tools disable, proxy configuration, printing disable, Brave update disable, and more
- [x] **5-tier hardening model** — Advanced level added between Balanced and Strict (v2.2.0)
- [x] **Automated Brave version detection** — warn if installed version differs from validated target (v2.1)
- [x] **Dry-run mode** via `-WhatIf` parameter — preview all changes without writing to registry (v2.1)
- [x] **Reset/uninstall mode** via `-Reset` parameter — remove all applied policies cleanly (v2.1)
- [x] **CONTRIBUTING.md** and GitHub issue templates (v2.1)
- [x] **GitHub Actions ADMX validation pipeline** — weekly automated policy diff validation (v2.1)
- [x] **Quality & Test Infrastructure** — 56 Pester 5 tests (16 test files), PSScriptAnalyzer, policy integrity CI, platform matrix (Ubuntu + Windows), version-check workflow (v2.1.6)
- [ ] Additional language editions (community contributions welcome — see CONTRIBUTING.md)
- [ ] Per-policy override support — explicitly include/exclude individual policies from any level
- [ ] PowerShell help system (`Get-Help BraveOmega-EN.ps1 -Detailed`)
- [ ] Signed releases with SHA-256 checksums

---

### 14. Contributing

Contributions are welcome. See [`CONTRIBUTING.md`](CONTRIBUTING.md) for the full
contributing guide, including:

- Code of conduct
- Priority areas (version bumps, new policies, bug fixes, translations)
- Requirements for new policy submissions (must be ADMX-sourced and verified)
- Bug report and feature request templates
- Pull request workflow
- Style guide for PowerShell scripts, Markdown, and HTML
- Security disclosure process

---

### 15. License

This project is released under the **MIT License**.  
See [LICENSE](LICENSE) for full terms.

---

### 16. Disclaimer

Brave Omega is an independent community project and is **not affiliated with, endorsed by, or
officially connected to Brave Software, Inc.** in any way. The Brave name and logo are
registered trademarks of Brave Software, Inc.

All registry modifications are performed at the user's own risk. The project authors accept no
responsibility for system instability, policy conflicts, data loss, or unintended behavior
resulting from the use of this project. Always verify backups, test in a non-production
environment first, and review the source code before executing in any managed or enterprise setting.



---

<a id="-türkçe-belgelendirme"></a>

## TR Türkçe Belgelendirme

### İçindekiler

1. [Brave Omega Nedir?](#1-brave-omega-nedir)
2. [Brave Omega Neden Var?](#2-brave-omega-neden-var)
3. [Temel Özellikler](#3-temel-özellikler)
4. [Ön Gereksinimler](#4-ön-gereksinimler)
5. [Hızlı Başlangıç](#5-hızlı-başlangıç)
6. [Nasıl Çalışır?](#6-nasıl-çalışır)
7. [♻️ Yaşam Döngüsü Taahhüdü](#7-yaşam-döngüsü-taahhüdü-yaşam-döngüsü-boyunca-her-daim-güncel)
8. [Sürüm Uyumluluk Matrisi](#8-sürüm-uyumluluk-matrisi)
9. [Politika Başvuru Tablosu](#9-politika-başvuru-tablosu)
10. [Proje Yapısı](#10-proje-yapısı)
11. [Güvenlik ve Emniyet](#11-güvenlik-ve-emniyet)
12. [Sorun Giderme](#12-sorun-giderme)
13. [Yol Haritası](#13-yol-haritası)
14. [Katkıda Bulunma](#14-katkıda-bulunma)
15. [Lisans](#15-lisans)
16. [Sorumluluk Reddi](#16-sorumluluk-reddi)

---

### 1. Brave Omega Nedir?

Brave Omega, [Brave Browser](https://brave.com)'ı **resmî kurumsal politika kanalları**
aracılığıyla sıkılaştıran açık kaynaklı bir PowerShell özdevim projesidir. Windows Kayıt
Defteri Grup İlkesi mimarisi ve Brave'in resmî ADMX politika çerçevesi kullanılarak; veri
aktarımı (telemetri), analiz hizmetleri, arka plan pinglari, tümleşik para kazanma bileşenleri
ve gizliliği aşındıran diğer özellikler sistematik biçimde devre dışı bırakılır. Tarayıcının iç
yapısına hiç dokunulmaz; herhangi bir üçüncü taraf araç gerekmez.

Brave Omega **beş katmanlı bir sıkılaştırma modeli** sunar — Brave Yalnız (24 politika),
Temel ⭐ (50), Dengeli (79), Gelişmiş (91) ve Katı (115) — kullanıcılara gizlilik duruşları üzerinde hassas kontrol
sağlar. Seviyeler kümülatiftir: her katman bir öncekinin tüm politikalarını içerir.

> **İki betik. Tek hedef. Sıfır maliyet.**
>
> `BraveOmega-EN.ps1` — Tam İngilizce arayüz, uluslararası kullanıcılar için
> `BraveOmega-TR.ps1` — Tam Türkçe arayüz, Türkçe konuşan kullanıcılar için

---

### 2. Brave Omega Neden Var?

Kurumsal düzeyde tarayıcı gizlilik sıkılaştırması iki şeyden birini gerektirir: ADMX politika
çerçeveleri ve kayıt defteri mimarisine derin teknik hâkimiyet ya da pahalı bir ücretli ürün
aboneliği. Brave Omega her iki kısıtlamayı da ortadan kaldırır.

**Ciddi, kayıt defteri düzeyinde zorunlu kılınan tarayıcı gizlilik sıkılaştırması için
gereken her şey, ücretsiz ve açık kaynaklı Brave Browser içinde zaten mevcuttur.** Zorunlu
kılma mimarisi Brave'in resmî ADMX şablonlarında hazır durumdadır. Düzenek, Windows Kayıt
Defteri Grup İlkesi içine yerleşik şekilde çalışır. Bilgi resmî belgelendirmede açıktır. Tek
eksik olan; bu bileşenler arasında doğrulanmış, otomatize edilmiş ve iyi belgelenmiş bir köprüydü.

Brave Omega o köprüyü inşa eder — ve tarayıcının yaşam döngüsü boyunca güncel tutar.

---

### 3. Temel Özellikler

| Özellik | Açıklama |
|---------|----------|
| 🔒 **Beş Katmanlı Gizlilik Modeli** | Sıkılaştırma seviyenizi seçin: **Brave Yalnız** (24 politika), **Temel ⭐** (50), **Dengeli** (79), **Gelişmiş** (91) veya **Katı** (115) |
| 🌐 **Çoklu Tür Kayıt Defteri Motoru** | DWord, String ve MultiString kayıt türlerini otomatik dağıtır — MultiString için .NET API (`[Microsoft.Win32.Registry]`) kullanılır, PowerShell'de `REG_MULTI_SZ` cmdlet'i bulunmadığından |
| 📋 **ADMX Doğrulamalı İlkeler** | Her politika girişi Brave'in resmî ADMX şablonları ve Chromium politika belgelendirmesi ile doğrulanmıştır |
| 🔄 **Kararsız Olmayan Çalışma** | Betiği istediğiniz kadar çalıştırın — her seferinde aynı güvenli, tutarlı sonuç |
| 💾 **Otomatik Yedekleme** | Değişikliklerden önce HKLM politika kovası için zaman damgalı `.reg` yedeği (`$env:TEMP\BravePolicyBackup\` konumunda saklanır) |
| 🔁 **Tek Komutla Geri Alma** | Tek komutla tam eski duruma dönüş: `reg import "<yedek_dosyası.reg>"` |
| 🛡️ **Brave Süreç Koruyucusu** | Değişiklik uygulanmadan önce çalışan Brave örnekleri tespit edilip kullanıcıya karar sunulur |
| 🔍 **Sürüm Denetimi** | Yüklü Brave sürümünü otomatik algılar ve doğrulanmış hedefle uyuşmazlıkta uyarır |
| 👁️ **Kuru Çalıştırma Kipi** | `-WhatIf` parametresi kayıt defterine yazmadan tüm değişiklikleri önizler — her iç içe fonksiyona yayılarak tam sadakat sağlar |
| 🧹 **Temiz Kaldırma** | `-Sıfırla` parametresi uygulanan tüm Brave Omega politikalarını HKLM, HKCU ve Omaha GUID'lerinden kaldırır |
| 🎯 **Dinamik Omaha GUID Keşfi** | Kayıt defterini regex ile tarayarak Omaha güncelleyici GUID'lerini bulur — sabit kodlanmış ID yok, sürüm değişikliklerine karşı dayanıklı |
| 🔄 **CI/CD Doğrulaması** | GitHub Actions ardışık düzeni, politika tanımlarını haftalık olarak resmî ADMX şablonlarına karşı doğrular |
| 📊 **Yürütme Özeti** | Tür bazında başarı/hata sayaçları ile şeffaf raporlama; çıkış kodu 0 (başarı) / 1 (hata) ile CI/CD entegrasyonu |
| 🌍 **İki Dilli** | Birebir işlevselliğe sahip Türkçe ve İngilizce sürümler |
| 🧹 **Terminal Kodlama Sağlamlaştırması** | `[Console]::Input/OutputEncoding` başlangıçta UTF-8'e ayarlanır — Türkçe karakter bozulmasını önler, temiz metin çıktısı sağlar |

---

### 4. Ön Gereksinimler

| Gereksinim | Ayrıntı |
|------------|---------|
| **İşletim Sistemi** | Windows 11 (önerilen: en güncel kararlı 25H2 derlemesi) |
| **Tarayıcı** | **Brave Browser — en güncel kararlı sürüm** (bkz. [brave.com/download](https://brave.com/download)) |
| **PowerShell** | 5.1+ (Windows 11 ile birlikte gelir — ek kurulum gerekmez) |
| **Ayrıcalık** | Yönetici olarak çalıştır (HKLM kayıt defteri yazma işlemi için zorunlu) |
| **Çalıştırma İlkesi** | `Bypass` (yalnızca oturum bazında — bkz. Hızlı Başlangıç) |

> [!IMPORTANT]
> **Bu betiği çalıştırmadan önce her zaman en güncel kararlı Brave sürümünü kullanın.**
> Brave'in kurumsal politika yapısı her Chromium güncellemesiyle birlikte gelişir. Güncel
> olmayan bir Brave sürümünde bu betiği çalıştırmak; tanınmayan politika anahtarlarına, kayıt
> defteri türü uyuşmazlıklarına veya eksik özelliklere yol açabilir. Devam etmeden önce
> [brave.com/latest](https://brave.com/latest) adresini kontrol edin ve
> [Sürüm Uyumluluk Matrisi](#8-sürüm-uyumluluk-matrisi) ile karşılaştırın.

---

### 5. Hızlı Başlangıç

**Adım 1 — PowerShell'i Yönetici olarak aç**
PowerShell simgesine sağ tıkla → **Yönetici olarak çalıştır**

**Adım 2 — Proje klasörüne geç**
```powershell
cd "C:\Users\Downloads\Brave-Omega"
```

**Adım 3 — Geçici bypass ile betiği çalıştır**

*Etkileşimli mod (seviyeyi çalıştırınca seçersiniz):*
```powershell
# Türkçe arayüz:
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1"

# İngilizce arayüz:
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1"
```

*Sessiz/otomatik mod (seviyeyi doğrudan belirtin):*
```powershell
# Temel (Önerilen) seviyeyi uygula:
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Level Temel

# İngilizce: en katı seviye:
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1" -Level Strict
```

*Önizleme kipi (kayıt defterine yazmadan tüm değişiklikleri göster):*
```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Level Temel -WhatIf
```

*Sıfırlama (uygulanan tüm politikaları kaldır):*
```powershell
PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Sıfırla
```

| Parametre Değeri (TR) | Parametre Değeri (EN) | Seviye | Politika |
|----------------------|----------------------|--------|----------|
| `-Level "Brave Yalnız"` | `-Level BraveOnly` | Brave Yalnız | 24 |
| `-Level Temel` | `-Level Essential` | Temel ⭐ | 50 |
| `-Level Dengeli` | `-Level Balanced` | Dengeli | 79 |
| `-Level Gelişmiş` | `-Level Advanced` | Gelişmiş | 91 |
| `-Level Katı` | `-Level Strict` | Katı | 115 |

> `-ExecutionPolicy Bypass` bayrağı yalnızca bu tek komut için geçerlidir. Kalıcı bir çalıştırma ilkesi değişikliği yapılmaz — pencereyi kapatın, her şey sıfırlanır.

**Adım 4 — Brave'i yeniden başlat**
Tüm Brave pencerelerini tamamen kapat ve yeniden aç. Değişiklikler bir sonraki açılışta hemen devreye girer.

**Adım 5 — Doğrula**
Tüm kurumsal ilkelerin doğru biçimde etkin olduğunu onaylamak için Brave'de `brave://policy` adresine git.

---

### 6. Nasıl Çalışır?

#### 6.1 Mimari — Beş Katmanlı Zorunlu Kılma Modeli

Brave Omega iki **altyapı katmanında** (HKLM ilkeleri + HKCU yedekleri) çalışır ve
kaç politikanın uygulanacağını belirleyen **beş sıkılaştırma seviyesi** sunar.

##### Altyapı Katmanları

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
│  ↳  24–115 ADMX doğrulamalı kurumsal ilke (seviye bazlı).  │
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

##### Sıkılaştırma Seviyeleri

| Seviye | Toplam Politika | Brave'e Özgü | Chromium (Veri) | Chromium (Güvenlik) | Kullanım Etkisi |
|--------|----------------|--------------|-----------------|---------------------|-----------------|
| **Brave Yalnız** | 24 | 24 | 0 | 0 | Yok |
| **Temel ⭐** | 50 | 24 | 26 | 0 | Yok |
| **Dengeli** | 79 | 24 | 26 | 29 | Düşük |
| **Gelişmiş** | 91 | 24 | 26 | 41 | Düşük |
| **Katı** | 115 | 24 | 26 | 66 | Yüksek |

#### 6.2 Politika Kaynakları ve Yöntem

> **Temel ilke: Sıfır gayri resmî veya spekülatif kayıt defteri değişikliği.**

Bu projede uygulanan her politika, aşağıdaki yetkili kaynaklardan birine izlenebilir.
Hiçbir şey tahmine dayalı değildir. Bir politika resmî belgelendirme aracılığıyla
doğrulanamıyorsa dışarıda bırakılır — neden dışarıda bırakıldığına dair belgelenmiş
açıklamasıyla birlikte.

| Kaynak | Kapsanan Politikalar |
|--------|---------------------|
| **Brave Resmî ADMX Şablon Paketi** (`policy_templates.zip`) | `BraveRewardsDisabled`, `BraveWalletDisabled`, `BraveVPNDisabled`, `BraveAIChatEnabled`, `BraveStatsPingEnabled` |
| **Chromium Kurumsal Politika Belgelendirmesi** | `MetricsReportingEnabled`, `SafeBrowsingExtendedReportingEnabled` |
| **Google Omaha Güncelleyici Mimarisi** | `usagestats` (GUID başına, HKCU güncelleme katmanında) |
| **Chromium Tercihler Şeması** | `UsageStatsInSample` (HKCU kullanıcı tercihi) |

> [!NOTE]
> **`BraveShieldsDefault` kasıtlı olarak dışarıda bırakıldı.** Bazı topluluk kılavuzlarında
> yer almasına rağmen bu politika adı Brave'in resmî ADMX şablonlarında bulunmamaktadır.
> Brave, kalkanları URL bazlı politikalarla (`BraveShieldsEnabledForUrls`,
> `BraveShieldsDisabledForUrls`) yönetir. Genel saldırgan mod, kurumsal kayıt defteri
> politikası değil; kullanıcı profil tercihleri (Preferences JSON) aracılığıyla uygulanır.
> Tanınmayan bir anahtar eklemek; gerçekte hiçbir etkisi olmayan ama çalışıyormuş gibi
> görünen bir kayıt defteri kaydı bırakırdı. Bu proje, nelerin dahil edildiğini değil,
> aynı zamanda nelerin ve neden dışarıda bırakıldığını da belgeler.

---

### 7. ♻️ Yaşam Döngüsü Taahhüdü: Yaşam Döngüsü Boyunca Her Daim Güncel

> **Güncelliğini yitiren bir gizlilik sıkılaştırma aracı, güvenlik güvencesi değil — yanlış bir güvenlik duygusudur.**

Tarayıcı politika yapıları her büyük Chromium sürümüyle değişir. Politika anahtarları
yeniden adlandırılır, kullanımdan kaldırılır ya da yenileriyle değiştirilir. Yeni gizlilikle
ilgili denetimler tanıtılır. Bakımsız bir sıkılaştırma betiği zamanla anlamsızlaşır — ya da
daha kötüsü, sessizce artık hiçbir etkisi olmayan eski yapılandırmaları uygulamaya devam eder.

**Brave Omega, yaşam döngüsünü esas alan bir taahhüt üzerine inşa edilmiştir:**

- **Sürüm Sabitleme** — Her betik sürümü, başlığında doğrulanmış Brave + Chromium sürüm
  kombinasyonuyla açıkça etiketlenir. Betiğin hangi ortama karşı sınanıldığı konusunda
  hiçbir belirsizlik yoktur.

- **Her Brave Kararlı Sürümünde Politika Gözden Geçirmesi** — Brave yeni bir kararlı sürüm
  yayımladığında ADMX şablon paketi önceki sürümle karşılaştırılır. Yeni politikalar
  değerlendirilir, kullanımdan kaldırılanlar kaldırılır, değişen davranışlar belgelenir.

- **Kırıcı Değişiklik Bildirimleri** — Kaldırılan veya yeniden adlandırılan her politika
  anahtarı, geçiş notunun eşliğinde değişiklik günlüğünde belgelenir. Brave sürümlerini
  yükseltecek kullanıcılar tam olarak neyin değiştiğini ve neden değiştiğini öğrenir.

- **Topluluk Güdümlü Güncellik** — Katkıda bulunanlar tarafından tespit edilen sürüm
  uyuşmazlıkları, kullanımdan kalkmış anahtarlar ve yeni kullanılabilir politikalar
  hızla gözden geçirilip dahil edilir.

- **Her Zaman Kararlı Sürüm Önerisi** — Proje, tutarlı biçimde **en güncel kararlı Brave
  sürümünü** önerir. Beta ve Nightly derlemeleri ADMX davranışı açısından henüz tam
  kararlı olmayabilir; bu nedenle birincil doğrulama hedefi değildir.

---

### 8. Sürüm Uyumluluk Matrisi

| Brave Omega | Brave Sürümü | Chromium | Windows | Durum |
|-------------|--------------|----------|---------|-------|
| **v2.3.0.0** *(güncel)* | 1.92.138 | 150 | 11 25H2 | ✅ Etkin |
| **v2.2.1.0** | 1.92.134 | 150 | 11 25H2 | 📦 Önceki |
| **v2.2.0.2** | 1.92.134 | 150 | 11 25H2 | 📦 Önceki |
| **v2.2.0.1** | 1.92.134 | 150 | 11 25H2 | 📦 Önceki |
| **v2.2.0** | 1.92.134 | 150 | 11 25H2 | 📦 Önceki |
| **v2.1.6** | 1.92.134 | 150 | 11 25H2 | 📦 Önceki |
| **v2.1.5** | 1.92.134 | 150 | 11 25H2 | 📦 Önceki |
| **v2.1.4** | 1.91.180 | 149 | 11 25H2 | 📦 Önceki |
| **v2.1.3** | 1.91.178 | 149 | 11 25H2 | 📦 Önceki |
| v2.1.2 | 1.91.175 | 149 | 11 25H2 | 📦 Önceki |
| v2.1.1 | 1.91.172 | 149 | 11 25H2 | 📦 Önceki |
| v2.1 | 1.91.172 | 149 | 11 25H2 | 📦 Önceki |
| v2.0 | 1.91.172 | 149 | 11 25H2 | 📦 Önceki |
| v1.2.2 | 1.91.172 | 149 | 11 25H2 | 📦 Önceki |
| v1.2.1 | 1.91.172 | 149 | 11 25H2 | 📦 Önceki |
| v1.2 | 1.91.172 | 149 | 11 25H2 | 📦 Önceki |
| v1.1 | 1.91.168 | 149 | 11 25H2 | 📦 Önceki |
| v1.0 | 1.91.168 | 149 | 11 25H2 | 🔒 Arşivlendi |

> [!TIP]
> **Çalıştırmadan önce:** Yüklü Brave sürümünüzün yukarıdaki matrisle eşleşip eşleşmediğini
> doğrulayın. Daha yeni bir Brave sürümü yayımlandıysa eski bir betik sürümünü çalıştırmadan
> önce [Sürümler](../../releases) sayfasında güncellenmiş bir Brave Omega sürümü olup
> olmadığını kontrol edin. Şüphe durumunda önce Brave'i en güncel kararlı sürüme güncelleyin.

---

### 9. Politika Başvuru Tablosu

> Brave Omega **5 sıkılaştırma seviyesi** ve **115 kurumsal politika** sunmaktadır. Aşağıdaki politika başvuru tablosu kayıt defteri kovanı ve seviyeye göre düzenlenmiştir. 115 politikanın tamamı aşağıda listelenmiştir — betiğe bakmaya gerek yoktur.

#### 9.1 HKCU — Kullanıcı Düzeyi Tercihleri (tüm seviyeler)

| Kayıt Defteri Anahtarı | Kovan | Değer | Tür | Etki |
|------------------------|-------|-------|-----|------|
| `UsageStatsInSample` | HKCU | `0` | DWord | Tarayıcı düzeyi kullanım istatistikleri örneklemesini devre dışı bırakır |
| `ChromeVariations` | HKCU | `1` | DWord | Chromium'u yalnızca kritik alan denemeleriyle sınırlar |
| `usagestats` *(GUID başına)* | HKCU | `0` | DWord | Uygulama GUID tanımlayıcısı başına Omaha güncelleyici veri aktarımını devre dışı bırakır |

#### 9.2 Brave Yalnız Seviyesi — Brave'e Özgü Politikalar (24)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
|------------------------|-------|-----|------|
| `BraveRewardsDisabled` | `1` | DWord | Rewards reklam sistemini, BAT jeton kazancını kaldırır |
| `BraveWalletDisabled` | `1` | DWord | Tümleşik kripto cüzdan, Web3, dDNS'yi kaldırır |
| `BraveVPNDisabled` | `1` | DWord | VPN düğmesini kaldırır, VPN arka plan hizmetini engeller |
| `BraveAIChatEnabled` | `0` | DWord | Leo AI Chat motorunu devre dışı bırakır |
| `BraveTalkDisabled` | `1` | DWord | Brave Talk video konferansını devre dışı bırakır |
| `BraveNewsDisabled` | `1` | DWord | Yeni Sekme Sayfasında Brave News beslemesini devre dışı bırakır |
| `BravePlaylistEnabled` | `0` | DWord | Brave Playlist çevrimdışı ortamını devre dışı bırakır |
| `BraveSpeedreaderEnabled` | `0` | DWord | Speedreader modunu devre dışı bırakır |
| `BraveWaybackMachineEnabled` | `0` | DWord | Wayback Machine entegrasyonunu devre dışı bırakır |
| `BraveP3AEnabled` | `0` | DWord | P3A veri iletimini devre dışı bırakır |
| `BraveStatsPingEnabled` | `0` | DWord | Brave sunucularına durum/kimlik doğrulama pinglerini durdurur |
| `BraveWebDiscoveryEnabled` | `0` | DWord | Web Discovery Project katkısını devre dışı bırakır |
| `TorDisabled` | `1` | DWord | Tor entegrasyonunu devre dışı bırakır |

#### 9.3 Temel Seviye — Brave Yalnız + Veri Sızıntısı Önleme (17 ek)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
|------------------------|-------|-----|------|
| `MetricsReportingEnabled` | `0` | DWord | Chromium temel ölçüm toplamayı devre dışı bırakır |
| `SafeBrowsingExtendedReportingEnabled` | `0` | DWord | Google'a genişletilmiş site verisi raporlamasını durdurur |
| `UrlKeyedAnonymizedDataCollectionEnabled` | `0` | DWord | Google'a URL verisi toplamayı durdurur |
| `SearchSuggestEnabled` | `0` | DWord | Arama önerileri veri sızıntısını durdurur |
| `NetworkPredictionOptions` | `2` | DWord | DNS ön getirmeyi ve ön bağlantıyı durdurur |
| `SpellcheckEnabled` | `0` | DWord | Yazım denetimini devre dışı bırakır |
| `AlternateErrorPagesEnabled` | `0` | DWord | Hata sayfası ağ isteklerini durdurur |
| `BrowserNetworkTimeQueriesEnabled` | `0` | DWord | Google'a saat senkronizasyonunu durdurur |
| `DomainReliabilityAllowed` | `0` | DWord | Tanılama verisi raporlamasını durdurur |
| `BackgroundModeEnabled` | `0` | DWord | Tüm pencereler kapandığında Brave'in çalışmasını engeller |
| `SafeBrowsingSurveysEnabled` | `0` | DWord | Gezinti sonrası anketleri devre dışı bırakır |
| `SafeBrowsingDeepScanningEnabled` | `0` | DWord | Sunucu tarafı indirme taramasını devre dışı bırakır |
| `WebRtcEventLogCollectionAllowed` | `0` | DWord | WebRTC olay günlüğü yüklemeyi durdurur |
| `WebRtcTextLogCollectionAllowed` | `0` | DWord | WebRTC metin günlüğü yüklemeyi durdurur |
| `AudioCaptureAllowed` | `0` | DWord | Varsayılan olarak mikrofona izin vermez |
| `VideoCaptureAllowed` | `0` | DWord | Varsayılan olarak kameraya izin vermez |

#### 9.4 Dengeli Seviye — Temel + Güvenlik Taban Çizgisi (21 ek)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
|------------------------|-------|-----|------|
| `WebRtcIPHandling` | `"disable_non_proxied_udp"` | String | Tüm WebRTC trafiğini proxy üzerinden yönlendirir |
| `WebRtcLocalIpsAllowedUrls` | `@()` | MultiString | ICE yoluyla yerel IP ifşasını engeller |
| `HttpsOnlyMode` | `"force_enabled"` | String | Tüm gezintileri HTTPS'ye zorlar |
| `DnsOverHttpsMode` | `"automatic"` | String | DNS sorgularını şifreler |
| `BlockThirdPartyCookies` | `1` | DWord | Siteler arası izleme çerezlerini engeller |
| `PasswordManagerEnabled` | `0` | DWord | Yerleşik parola kaydetmeyi devre dışı bırakır |
| `PasswordManagerPasskeysEnabled` | `0` | DWord | Passkey kaydetmeyi devre dışı bırakır |
| `AutofillAddressEnabled` | `0` | DWord | Adres otomatik doldurmayı devre dışı bırakır |
| `AutofillCreditCardEnabled` | `0` | DWord | Kredi kartı otomatik doldurmayı devre dışı bırakır |
| `ShowFullUrlsInAddressBar` | `1` | DWord | Tam URL'leri gösterir (oltalamaya karşı) |
| `DisableSafeBrowsingProceedAnyway` | `1` | DWord | Kötü amaçlı yazılım uyarılarını atlamayı engeller |
| `QuicAllowed` | `0` | DWord | QUIC'i devre dışı bırakır, TCP/TLS'ye döner |
| `ChromeVariations` | `1` | DWord | Yalnızca kritik alan denemeleri |
| `NetworkServiceSandboxEnabled` | `1` | DWord | Ağ hizmetini kum havuzuna alır |
| `AudioSandboxEnabled` | `1` | DWord | Ses hizmetini kum havuzuna alır |
| `DefaultGeolocationSetting` | `2` | DWord | Varsayılan olarak konumu engeller |
| `DefaultNotificationsSetting` | `2` | DWord | Varsayılan olarak bildirimleri engeller |
| `DefaultPopupsSetting` | `2` | DWord | Varsayılan olarak açılır pencereleri engeller |

#### 9.5 Gelişmiş Seviye — Dengeli + Gelişmiş Gizlilik (11 ek)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
|------------------------|-------|-----|------|
| `DefaultSensorsSetting` | `2` | DWord | Varsayılan olarak sensör erişimini engeller |
| `DefaultLocalFontsSetting` | `2` | DWord | Yazı tipi numaralandırmayı engeller |
| `DefaultSerialGuardSetting` | `2` | DWord | Serial API'yi engeller |
| `DefaultIdleDetectionSetting` | `2` | DWord | Boşta algılamayı engeller |
| `BrowserGuestModeEnabled` | `0` | DWord | Misafir profillerini engeller |
| `BrowserAddPersonEnabled` | `0` | DWord | Yeni profilleri engeller |
| `ImportAutofillFormData` | `0` | DWord | Otomatik doldurma verisi içe aktarmayı devre dışı bırakır |
| `ImportHistory` | `0` | DWord | Geçmiş içe aktarmayı devre dışı bırakır |
| `ImportSavedPasswords` | `0` | DWord | Parola içe aktarmayı devre dışı bırakır |
| `ImportSearchEngine` | `0` | DWord | Arama motoru içe aktarmayı devre dışı bırakır |
| `ImportHomepage` | `0` | DWord | Ana sayfa içe aktarmayı devre dışı bırakır |

#### 9.6 Katı Seviye — Gelişmiş + Azami Gizlilik (8 ek)

| Kayıt Defteri Anahtarı | Değer | Tür | Etki |
|------------------------|-------|-----|------|
| `TranslateEnabled` | `0` | DWord | Yerleşik çeviriyi devre dışı bırakır |
| `DefaultClipboardSetting` | `2` | DWord | Varsayılan olarak panoyu engeller |
| `DefaultFileSystemReadGuardSetting` | `2` | DWord | Dosya sistemi okumayı engeller |
| `DefaultFileSystemWriteGuardSetting` | `2` | DWord | Dosya sistemi yazmayı engeller |
| `DefaultInsecureContentSetting` | `2` | DWord | Karma içeriği engeller |
| `DefaultJavaScriptJitSetting` | `2` | DWord | JIT derlemeyi devre dışı bırakır |
| `DefaultCookiesSetting` | `2` | DWord | Varsayılan olarak tüm çerezleri engeller |
| `ImportBookmarks` | `0` | DWord | Yer imi içe aktarmayı devre dışı bırakır |
| `DefaultBraveRemember1PStorageSetting` | `2` | DWord | Sekme/gezinti sonunda birinci taraf deposunu unutur |

---

### 10. Proje Yapısı

```
BRAVE OMEGA PROJECT/
│
├── .gitignore                          Git dışlama kuralları
├── .gitattributes
├── LICENSE                             MIT
├── README.md                           Belgelendirme (EN + TR)
├── CHANGELOG.md                        Değişiklik günlüğü
├── CONTRIBUTING.md                     Katkı rehberi (EN + TR)
├── SECURITY.md                         Güvenlik politikası (EN + TR)
├── index.html                          Açılış sayfası (GitHub Pages)
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yaml             Hata raporu şablonu
│   │   └── feature_request.yaml        Özellik talebi şablonu
│   └── workflows/
│       ├── admx-validate.ps1           ADMX doğrulama betiği
│       └── admx-validate.yml           ADMX doğrulama hattı
└── Brave Omega/
        BraveOmega-EN.ps1               Ana betik — İngilizce arayüz
        BraveOmega-TR.ps1               Ana betik — Türkçe arayüz
```

---

### 11. Güvenlik ve Emniyet

> [!WARNING]
> Bu betik Windows Kayıt Defteri'ni değiştirmekte ve **Yönetici ayrıcalıkları**
> gerektirmektedir. Herhangi bir PowerShell betiğini Yönetici olarak çalıştırmadan önce
> kaynak kodu her zaman okuyup anlayın. Güvenilmeyen betikleri asla yükseltilmiş ayrıcalıklarla
> çalıştırmayın.

| Endişe | Brave Omega'nın Yaklaşımı |
|--------|--------------------------|
| **Yetkisiz değişiklikler** | Kaynak tamamen açık incelemeye sunulmuştur. Gizleme yok. Harici ağ çağrısı yok. Çalıştırılabilir dosya yok. |
| **Geri alınamaz durum** | Her HKLM yazma işleminden önce otomatik zaman damgalı `.reg` yedeği. `reg import` ile geri al. |
| **Kısmi uygulama** | Her işlem için bireysel try-catch ve başarı/hata sayaçları. Tam olarak neyin uygulandığını bilirsiniz. |
| **Tarayıcı veri kaybı** | Değişiklik uygulanmadan önce Brave süreç tespiti ve açık devam/iptal istemi. |
| **Yinelenen çalıştırma** | `-Force` parametresiyle kararsız olmayan tasarım. Birden fazla çalıştırmanın yan etkisi yoktur. |

---

### 12. Sorun Giderme

> [!NOTE]
> Brave Omega yalnızca **Kararlı (Stable) kanalda** doğrulanmıştır (güncel Brave 1.92.138 / Chromium 150). ADMX politika davranışları Beta/Nightly yapılarında test edilmemiştir ve farklılık gösterebilir.

| Belirti | Olası Neden | Çözüm |
|---------|------------|-------|
| Betik hemen "KRİTİK HATA" ile çıkıyor | Yönetici olarak çalıştırılmıyor | PowerShell'e sağ tıkla → **Yönetici olarak çalıştır** |
| Çalıştırma sonrası `brave://policy` politika göstermiyor | Brave yeniden başlatılmadı | Tüm Brave pencerelerini kapat ve yeniden aç |
| Betik çıktısında `[HATA]` satırları görünüyor | HKLM yolu izin sorunu | Yönetici modunu doğrula; betiği yeniden çalıştır |
| Brave HKCU tercihlerini üzerine yazıyor | Çalışma sırasında Brave açıktı | Önce Brave'i kapat; betiği yeniden çalıştır |
| `brave://policy`'de bir politika anahtarı "Bilinmiyor" gösteriyor | Chromium sürümü uyuşmazlığı | Yüklü Brave sürümünün uyumluluk matrisiyle eşleştiğini doğrula |
| Yedekleme adımında `reg export` başarısız oluyor | Mevcut HKLM yolunda kısıtlı izin | `regedit` ile yolu incele; ACL girdilerini kontrol et |

---

### 13. Yol Haritası — 6 Aşamalı Uygulama Planı

#### ✅ Tamamlanan (Önceki Sürümler)

- [x] **Çok katmanlı sıkılaştırma sistemi** — Brave Yalnız / Temel / Dengeli / Katı
- [x] **Çoklu tür kayıt defteri motoru** — DWord, String, MultiString
- [x] **`-Level` parametresi** — sessiz/otomatik dağıtım
- [x] **115 toplam politika** — 17'den 115'e genişletildi
- [x] **Otomatik Brave sürüm tespiti** — yüklü sürüm doğrulanmış hedeften farklıysa uyar
- [x] **`-WhatIf` parametresiyle kuru çalıştırma kipi**
- [x] **Sıfırlama/kaldırma kipi** — `-Sıfırla` parametresiyle tüm politikaları temizle
- [x] **CONTRIBUTING.md** ve GitHub sorun şablonları
- [x] **GitHub Actions ADMX doğrulama ardışık düzeni**
- [x] **4 parçalı sürümleme şeması** — version.major.minor.revision
- [x] **GitHub Project #4** — 6 açık issue (#25-#30), 5 kapalı (#10-#14)
- [x] **Kalite hattı temiz** — markdownlint (13/13), yamllint, PowerShell sözdizimi

#### 🔲 Aşama 1 — Denetim

- [ ] **Eksik politika analizi** — 13 eksik Brave politikasını belirle
- [ ] **ADMX değer doğrulama** — politika değer aralıklarını ve varsayılanlarını doğrula
- [ ] **Deprecated temizlik** — 4 kullanımdan kaldırılmış Chromium politikasını kaldır
- [ ] **Referans güncelleme** — referans dokümanı satır numaralarını güncelle

#### 🔲 Aşama 2 — Uygulama

- [ ] **Politika ekleme** — 13 eksik Brave politikasını betiğe ekle

#### ✅ Aşama 3 — Kalite & Test

- [x] **Pester test takımı** — 16 birim + entegrasyon test dosyası ([#30](https://github.com/brave-omega/brave-omega/issues/30))
- [x] **PSScriptAnalyzer** — statik analiz CI entegrasyonu
- [x] **Politika bütünlük CI** — ADMX çapraz referans doğrulama
- [x] **Platform matrisi** — ubuntu + windows CI
- [x] **Sürüm kontrolü** — EN/TR betik sürüm senkronizasyonu

#### 🔲 Aşama 4 — Dokümantasyon/Yaygınlaştırma

- [ ] **Politika kataloğu** — tam meta verili politika listesi

#### 🔲 Aşama 5 — Gelişmiş

- [ ] **Platformlar arası yapılandırma** — Linux JSON + macOS .plist çıktı
- [ ] **Intune/MDM dağıtım kılavuzu** — kurumsal yönetim rehberi
- [ ] **Web tabanlı politika yapılandırıcı** — interaktif arayüz
- [ ] **Modüler mimari** — modüllere ayrılmış PowerShell modülleri

> Tüm aşamalı çalışmalar **GitHub Project #4** ile takip edilir.

---

### 14. Katkıda Bulunma

Katkılar memnuniyetle karşılanır. Tam katkı rehberi için [`CONTRIBUTING.md`](CONTRIBUTING.md)
dosyasına bakın:

- Davranış kuralları
- Öncelikli alanlar (sürüm güncellemeleri, yeni politikalar, hata düzeltmeleri, çeviriler)
- Yeni politika gönderimleri için gereksinimler (ADMX kaynaklı ve doğrulanmış olmalı)
- Hata raporu ve özellik talebi şablonları
- Pull request iş akışı
- PowerShell betikleri, Markdown ve HTML için stil rehberi
- Güvenlik bildirim süreci

---

### 15. Lisans

Bu proje **MIT Lisansı** kapsamında yayımlanmıştır.
Tam koşullar için [LICENSE](LICENSE) dosyasına bakın.

---

### 16. Sorumluluk Reddi

Brave Omega, bağımsız bir topluluk projesidir ve hiçbir şekilde **Brave Software, Inc. ile
bağlantılı, onun tarafından onaylanmış veya resmî olarak ilişkili değildir.** Brave adı ve
logosu, Brave Software, Inc.'in tescilli markalarıdır.

Tüm kayıt defteri değişiklikleri kullanıcının kendi sorumluluğundadır. Proje yazarları, bu
projenin kullanımından kaynaklanan sistem kararsızlığı, politika çakışmaları, veri kaybı veya
istenmeyen davranışlardan dolayı hiçbir sorumluluk kabul etmez. Yönetilen ya da kurumsal bir
ortamda çalıştırmadan önce her zaman üretim dışı bir ortamda sınayın, yedekleri doğrulayın ve
kaynak kodu inceleyin.

---

<div align="center">

<br>

**🦁 Brave Omega Project** — Community Edition

*Built with care. Maintained with purpose.*

*Özenle inşa edildi. Amaçla sürdürülüyor.*

<br>

</div>
