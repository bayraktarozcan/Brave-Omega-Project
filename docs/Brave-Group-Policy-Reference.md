# Brave Group Policy Reference

> General-purpose knowledge base for Brave browser Group Policy administration.
> Not tied to any specific machine or live system export.
> Brave is built on Chromium and supports **all Chromium policies** plus its own product-specific policies.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Platform Deployment](#platform-deployment)
3. [Brave-Specific Policies](#brave-specific-policies)
   - [Web3, Crypto & Rewards](#web3-crypto--rewards)
   - [Privacy & Security (Shields)](#privacy--security-shields)
   - [Network & Connectivity](#network--connectivity)
   - [AI & Content Features](#ai--content-features)
   - [Telemetry, Analytics & Sync](#telemetry-analytics--sync)
   - [Other Features](#other-features)
   - [Deprecated Policies](#deprecated-policies)
4. [Chromium-Inherited Policy Categories](#chromium-inherited-policy-categories)
5. [Policy Type Reference](#policy-type-reference)
6. [Appendix: Brave vs Chrome Path Mapping](#appendix-brave-vs-chrome-path-mapping)

---

## Architecture Overview

### Policy Sources (by precedence)

| Order | Source | Scope |
|-------|--------|-------|
| 1 | Platform policies (GPO/plist/JSON) | Machine-wide |
| 2 | Machine cloud policies (enrolled browsers) | Enrolled browsers |
| 3 | OS-user policies | Per OS user |
| 4 | Cloud-user policies (Chrome profile) | Per signed-in profile |

### Policy Storage

Brave uses **two policy providers**:

- **BraveBrowserPolicyProvider** — Global policies stored in local state (one per browser instance)
- **BraveProfilePolicyProvider** — Per-profile policies stored in profile prefs

Which provider a policy uses is determined by the `per_profile` attribute in its YAML definition.

### Checking Policy Status

- `brave://policy` — List all active policies
- `brave://management` — Shows whether device is managed

---

## Platform Deployment

### Windows

**Registry path (Machine):**
```
HKLM\SOFTWARE\Policies\BraveSoftware\Brave
```

**Registry path (User):**
```
HKCU\SOFTWARE\Policies\BraveSoftware\Brave
```

**ADMX templates:** Download from Brave's official policy templates:
`https://brave-browser-downloads.s3.brave.com/latest/policy_templates.zip`

**Installation:**
- ADMX → `%systemroot%\PolicyDefinitions\`
- ADML → `%systemroot%\PolicyDefinitions\<locale>\`
- Legacy ADM → Import via `gpedit.msc` (Classic Administrative Templates)
- Registry → Home editions: set values directly in registry

**Updater (Omaha) settings:** Templates not yet provided; follow Chrome's updater docs, replacing `Software\Policies\Google\Chrome` with `Software\Policies\BraveSoftware\Brave`.

### macOS

**Managed preferences path:**
```
/Library/Managed Preferences/com.brave.Browser.plist
```

**Unmanaged preferences path:**
```
~/Library/Preferences/com.brave.browser.plist
```

**Bundle identifiers:**
| Channel | Bundle ID |
|---------|-----------|
| Release | `com.brave.browser` |
| Beta | `com.brave.Browser.beta` |
| Nightly | `com.brave.Browser.nightly` |
| Development | `com.brave.Browser.development` |

**CLI examples:**
```bash
# Boolean
defaults write com.brave.Browser BraveWalletDisabled -bool true

# Integer
defaults write com.brave.Browser IncognitoModeAvailability -integer 1

# Array of strings
defaults write com.brave.Browser BraveShieldsDisabledForUrls -array "https://example.com" "https://test.com"

# Managed preference (requires PlistBuddy)
sudo /usr/libexec/PlistBuddy -c "Add :BraveWalletDisabled bool true" /Library/Managed\ Preferences/com.brave.Browser.plist
```

### Linux

**Policy directory:**
```
/etc/brave/policies/managed/
```

**Format:** JSON files in that directory:
```json
{
  "BraveWalletDisabled": true,
  "IncognitoModeAvailability": 1,
  "BraveShieldsDisabledForUrls": [
    "https://example.com",
    "https://test.com"
  ]
}
```

### Android

Managed via MDM (Android Enterprise). All Chromium-supported policies apply to Brave. Brave-specific policies also supported via MDM app configuration. Templates not yet provided.

### iOS

Managed via MDM with `.mobileconfig` files. Supported Brave-specific policies on iOS:
- `BravePlaylistEnabled`
- `BraveVPNDisabled`
- `BraveNewsDisabled`
- `BraveTalkDisabled`
- `BraveRewardsDisabled`
- `BraveAIChatEnabled`

---

## Brave-Specific Policies

> Source of truth: [brave-core policy_definitions YAML files](https://github.com/brave/brave-core/tree/master/components/policy/resources/templates/policy_definitions/BraveSoftware)

### Web3, Crypto & Rewards

| Policy | Type | Default | Since | Description |
|--------|------|---------|-------|-------------|
| `BraveRewardsDisabled` | Boolean | 0 (Enabled) | — | Controls Brave Rewards (BAT tokens for privacy-preserving ads). If true, Rewards icon hidden, users cannot opt into ads or earn crypto. |
| `BraveWalletDisabled` | Boolean | 0 (Enabled) | — | Controls Brave Crypto Wallet. If true, wallet functionality removed from UI; disables Wallet, Web3, and decentralized DNS settings. |

### Privacy & Security (Shields)

| Policy | Type | Default | Since | Description |
|--------|------|---------|-------|-------------|
| `BraveShieldsDisabledForUrls` | Array of strings | — | — | Whitelist of URLs where Shields (ad/tracker blocking) is automatically turned off. User cannot override. Wildcards not supported. |
| `BraveShieldsEnabledForUrls` | Array of strings | — | — | Blacklist enforcement: Shields always on for listed URLs. User cannot disable. Wildcards not supported. |
| `DefaultBraveAdblockSetting` | Integer (enum) | null (user choice) | chrome.*:142+ | `1` = Allow ads, `2` = Block ads. If unset, blocked by default but user can override via Shields. |
| `DefaultBraveFingerprintingV2Setting` | Integer (enum) | null (user choice) | chrome.*:141+ | `1` = Disable fingerprinting protection, `3` = Enable standard mode. |
| `DefaultBraveHttpsUpgradeSetting` | Integer (enum) | null (user choice) | chrome.*:142+ | `1` = Allow HTTP, `2` = Strict (require HTTPS, interstitial on failure), `3` = Standard (upgrade when available). |
| `DefaultBraveReferrersSetting` | Integer (enum) | null (user choice) | chrome.*:142+ | `1` = Allow permissive referrer policy (`unsafe-url`), `2` = Cap to `strict-origin-when-cross-origin`. |
| `DefaultBraveRemember1PStorageSetting` | Integer (enum) | null (user choice) | chrome.*:142+ | `1` = Remember first-party storage, `2` = Forget first-party storage when tabs/navigation end. |
| `BraveDeAmpEnabled` | Boolean (tri-state) | null (enabled by default) | chrome.*:140+ | Controls De-AMP: bypasses Google-hosted AMP pages, redirects to publisher's content directly. |
| `BraveDebouncingEnabled` | Boolean (tri-state) | null (enabled by default) | chrome.*:140+ | Controls bounce tracking protection. Skips known tracking domains, navigates directly to intended destination. |
| `BraveGlobalPrivacyControlEnabled` | Boolean (tri-state) | null (enabled by default) | chrome.*:142+ | Controls Global Privacy Control. Sends `Sec-GPC` header and exposes `navigator.globalPrivacyControl` JS API. |
| `BraveReduceLanguageEnabled` | Boolean (tri-state) | null (enabled by default) | chrome.*:140+ | Reduces fingerprinting surface via language preferences. Prevents sites from learning exact language settings. |
| `BraveTrackingQueryParametersFilteringEnabled` | Boolean (tri-state) | null (enabled by default) | chrome.*:142+ | Strips known tracking query parameters from URLs when Shields is enabled. |

**Boolean tri-state note:** `true` = enable, `false` = disable, `null` (unset) = let user decide (feature enabled by default).

### Network & Connectivity

| Policy | Type | Default | Since | Description |
|--------|------|---------|-------|-------------|
| `BraveVPNDisabled` | Boolean | 0 (Enabled) | — | Controls paid Brave VPN integration. If true, VPN button and subscription options removed from UI. |
| `TorDisabled` | Boolean | null (enabled on user choice) | chrome.win:78+, mac:93+, linux:93+ | Controls Tor connectivity in Private Windows. If true, Tor always disabled. Dynamic refresh: false (requires restart). Per_profile: false (browser-wide). |

### AI & Content Features

| Policy | Type | Default | Since | Description |
|--------|------|---------|-------|-------------|
| `BraveAIChatEnabled` | Boolean | 1 (Enabled) | — | Controls Leo AI assistant. If false, AI chat button in sidebar and address bar integration disabled. |
| `BraveLocalAIEnabled` | Boolean (tri-state) | null (enabled by default) | chrome.*:149+ | Master switch for local AI features (history embeddings, on-device surfaces). Dynamic refresh: false. Per_profile: false. |
| `BraveNewsDisabled` | Boolean | 0 (Enabled) | chrome.*:140+ | Controls Brave News feed on New Tab Page. If true, news feed completely removed. |
| `BravePlaylistEnabled` | Boolean (tri-state) | null (enabled by default) | chrome.*:139+, ios:140+, android:148+ | Controls Brave Playlist (save video/audio for offline playback). Dynamic refresh: false. |
| `BraveSpeedreaderEnabled` | Boolean | 1 (Enabled) | chrome.*:140+ | Controls Speedreader mode (strips clutter/CSS from articles). If false, reader mode suggestion disabled. |
| `BraveTalkDisabled` | Boolean | Disabled | chrome.*:140+ | Controls Brave Talk video conferencing. If true, widget and call option removed. |
| `BraveWaybackMachineEnabled` | Boolean | 1 (Enabled) | chrome.*:140+ | Controls Internet Archive/Wayback Machine integration. When enabled, prompts to view saved version on 404 errors. |

### Telemetry, Analytics & Sync

| Policy | Type | Default | Since | Description |
|--------|------|---------|-------|-------------|
| `BraveP3AEnabled` | Boolean | Disabled | chrome.*:140+ | Controls Privacy-Preserving Product Analytics. If enabled, sends anonymous usage data to Brave. |
| `BraveStatsPingEnabled` | Boolean | 1 (Enabled) | chrome.*:140+ | Controls heartbeat ping for daily/monthly active user counting. If false, stops announcing presence to update servers. |
| `BraveWebDiscoveryEnabled` | Boolean | 0 (Disabled) | chrome.*:140+ | Controls Web Discovery Project. If enabled, anonymously contributes data to help build Brave Search index. |
| `BraveSyncUrl` | String | `https://sync-v2.brave.com/v2` | — | Custom Sync server URL. Allows enterprise to redirect sync traffic to a self-hosted server within private network. |

### Other Features

| Policy | Type | Default | Since | Description |
|--------|------|---------|-------|-------------|
| `EmailAliasesEnabled` | Boolean (tri-state) | null (enabled by default) | chrome.*:147+ | Controls Email Aliases feature for anonymous sign-ups. Dynamic refresh: false. |

### Deprecated Policies

| Policy | Deprecated Since | Notes |
|--------|------------------|-------|
| `IPFSEnabled` | chrome.*:87+ | IPFS feature removed from Brave 1.69.153 (Aug 2024). Do not re-add. |

---

## Chromium-Inherited Policy Categories

Brave inherits all Chromium policies (~1,400+ individual policies). The complete list is maintained at:
- [Chrome Enterprise Policy List](https://chromeenterprise.google/policies/)
- [Chromium Policy Templates](https://chromium.googlesource.com/chromium/src/+/master/chrome/app/policy/policy_templates.json)

Key category groups:

### Startup, Homepage & New Tab
- `HomepageLocation`, `HomepageIsNewTabPage`, `RestoreOnStartup`, `RestoreOnStartupURLs`
- `ShowHomeButton`, `NewTabPageLocation`

### Privacy & Security
- `SafeBrowsingEnabled`, `SafeBrowsingProtectionLevel`
- `IncognitoModeAvailability`, `IncognitoEnabled`
- `DnsOverHttpsMode`, `DnsOverHttpsTemplates`
- `ContextualSearchEnabled`, `SearchSuggestEnabled`
- `ThirdPartyBlockingEnabled`, `BlockThirdPartyCookies`
- `CertificateTransparencyEnforcementDisabledForUrls`

### Content Settings
- `DefaultCookiesSetting`, `DefaultImagesSetting`, `DefaultJavaScriptSetting`
- `DefaultPopupsSetting`, `DefaultNotificationsSetting`, `DefaultGeolocationSetting`
- `DefaultMediaStreamSetting`, `DefaultWebUsbGuardSetting`, `DefaultFileSystemReadGuardSetting`
- Per-URL overrides: `CookiesAllowedForUrls`, `CookiesBlockedForUrls`, `ImagesAllowedForUrls`, etc.

### Password Manager
- `PasswordManagerEnabled`, `PasswordManagerAllowShowPasswords`
- `PasswordLeakDetectionEnabled`, `PasswordProtectionWarningTrigger`

### Extensions
- `ExtensionInstallForcelist`, `ExtensionInstallBlacklist`, `ExtensionInstallWhitelist`
- `ExtensionAllowedTypes`, `ExtensionInstallSources`, `ExtensionSettings`

### Proxy
- `ProxyMode`, `ProxyServer`, `ProxyPacUrl`, `ProxyBypassList`, `ProxySettings`

### HTTP Authentication
- `AuthSchemes`, `AuthServerWhitelist`, `AuthNegotiateDelegateWhitelist`
- `EnableAuthNegotiatePort`, `DisableAuthNegotiateCnameLookup`, `GSSAPILibraryName`

### Printing
- `PrintingEnabled`, `PrintingAllowedBackgroundGraphicsModes`
- `PrintingPaperSizeDefault`, `CloudPrintProxyEnabled`

### Downloads
- `DownloadDirectory`, `DownloadRestrictions`, `PromptForDownloadLocation`
- `AllowFileSelectionDialogs`

### Sync
- `SyncDisabled`, `SyncTypesListDisabled`

### Developer Tools
- `DeveloperToolsDisabled`, `DeveloperToolsAvailability`

### Reporting & Metrics
- `MetricsReportingEnabled`, `CloudReportingEnabled`
- `ChromeReportingExtension`, `ReportVersionData`, `ReportPolicyData`

### Remote Access
- `RemoteAccessHostAllowRelayedConnection`, `RemoteAccessHostRequireTwoFactor`
- `RemoteAccessHostDomainList`, `RemoteAccessHostUdpPortRange`

### Native Messaging
- `NativeMessagingUserLevelHosts`, `NativeMessagingBlocklist`, `NativeMessagingAllowlist`

### Browser Switcher (Legacy Browser Support)
- `BrowserSwitcherEnabled`, `BrowserSwitcherUrlList`, `BrowserSwitcherChromePath`
- `BrowserSwitcherDelay`, `BrowserSwitcherUseIeSitelist`

### Machine-Level (Cloud Management)
- `CloudManagementEnrollmentToken`, `CloudPolicyOverridesPlatformPolicy`
- `DevicePolicyRefreshRate`, `UserDataDir`, `PolicyRefreshRate`

### Certificate Management
- `CACertificateManagementAllowed`, `CertificateTransparencyEnforcementDisabledForUrls`
- `RequiredClientCertificateForUrls`, `SelectCertificateForUrls`

### Accessibility
- `AccessibilityImageLabelsEnabled`, `ShowAccessibilityOptionsInToolbar`

---

## Policy Type Reference

| Type | Description | JSON Example | Registry Example |
|------|-------------|-------------|------------------|
| `Boolean` | true / false | `true` | `dword:00000001` |
| `Boolean (tri-state)` | true / false / null | `true` | `dword:00000001` or absent |
| `Integer` | Whole number | `1` | `dword:00000001` |
| `Integer (enum)` | Integer from fixed set | `2` | `dword:00000002` |
| `String` | Text value | `"https://example.com"` | `REG_SZ` |
| `Array of strings` | List of URLs/paths | `["url1","url2"]` | Multi-REG_SZ or numbered values under subkey |
| `Dictionary` | Key-value map | `{"key":"val"}` | Registry subkey with values |

### Boolean Tri-State Semantics

Several Brave policies use a **tri-state** pattern (YAML `type: main` with three `items`):
- `true` — Feature explicitly enabled, user cannot override
- `false` — Feature explicitly disabled, user cannot override
- `null` (unset) — Feature uses default behavior, user can change via UI

---

## Appendix: Brave vs Chrome Path Mapping

### Windows Registry

| Purpose | Chrome/Chromium Path | Brave Path |
|---------|---------------------|------------|
| Machine-wide policies | `HKLM\...\Google\Chrome` | `HKLM\...\BraveSoftware\Brave` |
| User policies | `HKCU\...\Google\Chrome` | `HKCU\...\BraveSoftware\Brave` |

Where `...` = `SOFTWARE\Policies`.

### macOS

| Purpose | Chrome | Brave |
|---------|--------|-------|
| Bundle ID | `com.google.Chrome` | `com.brave.browser` |
| Managed preferences | `com.google.Chrome.plist` | `com.brave.Browser.plist` |

### Linux

| Purpose | Chrome/Chromium Path | Brave Path |
|---------|---------------------|------------|
| Policy directory | `/etc/chromium/policies/managed/` | `/etc/brave/policies/managed/` |
| Policy directory | `/etc/opt/chrome/policies/managed/` | `/etc/brave/policies/managed/` |

### ADMX Namespace

Chrome uses `Google.Policies.Chrome`; Brave uses `BraveSoftware.Policies.Brave`.

---

## References

- [Brave Group Policy Help Article](https://support.brave.app/hc/en-us/articles/360039248271-Group-Policy)
- [Brave Policy Templates Download](https://brave-browser-downloads.s3.brave.com/latest/policy_templates.zip)
- [Brave-Core Policy Definitions (Source of Truth)](https://github.com/brave/brave-core/tree/master/components/policy/resources/templates/policy_definitions/BraveSoftware)
- [Chrome Enterprise Policy List](https://chromeenterprise.google/policies/)
- [Chromium Policy Templates](https://chromium.googlesource.com/chromium/chromium/+/master/chrome/app/policy/policy_templates.json)
- [Chromium Administrators Documentation](https://www.chromium.org/administrators/)
