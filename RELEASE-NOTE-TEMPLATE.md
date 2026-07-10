# Release Note Template

Use this template when creating new releases. Copy and fill in the placeholders.

---

## v{VERSION} — {TITLE}

**{ONE_LINE_SUMMARY}**

### Summary

{BRIEF_DESCRIPTION}

| Metric | Before | After |
|--------|--------|-------|
| Hardening levels | 5 | 5 |
| Total policies | {BEFORE_TOTAL} | **{AFTER_TOTAL}** ({DIFF}) |
| Brave Only | {BEFORE_BO} | {AFTER_BO} |
| Essential | {BEFORE_ES} | {AFTER_ES} |
| Balanced | {BEFORE_BA} | {AFTER_BA} |
| Advanced | {BEFORE_AD} | {AFTER_AD} |
| Strict | {BEFORE_ST} | {AFTER_ST} |
| Cumulative chain | {BEFORE_CHAIN} | **{AFTER_CHAIN}** |

### Added

{LIST_OF_NEW_POLICIES_WITH_TIER_AND_DESCRIPTION}

### Changed

{LIST_OF_CHANGES}

### Removed

{LIST_OF_REMOVED_POLICIES_OR_FEATURES}

### Files

- `BraveOmega-EN.ps1` — English script
- `BraveOmega-TR.ps1` — Turkish script
- `index.html` — Interactive policy configurator

### Documentation

- [Wiki](https://github.com/bayraktarozcan/Brave-Omega-Project/wiki)
- [Changelog](https://github.com/bayraktarozcan/Brave-Omega-Project/blob/main/CHANGELOG.md)

---

## Example (v2.3.1.0)

## v2.3.1.0 — Brave 1.92.139 Compatibility & ProxyMode Deprecation Fix

**Lightweight validation release — ProxySettings added to Essential tier.**

### Summary

Validates full compatibility with Brave **1.92.139** (Chromium 150.0.7871.176). Adds `ProxySettings` to Essential tier for proxy configuration placeholder support.

| Metric | Before (v2.3.0.0) | After (v2.3.1.0) |
|--------|-------------------|------------------|
| Hardening levels | 5 | 5 |
| Total policies | 110 | 110 |
| Brave Only | 24 | 24 |
| Essential | 18 | **19** (+1) |
| Balanced | 29 | 29 |
| Advanced | 18 | 18 |
| Strict | 13 | 13 |
| Cumulative chain | 24→50→79→97→110 | 24→50→79→97→110 |

### Added

- **`ProxySettings`** (Essential) — Configures proxy server address via JSON. Placeholder — customize per deployment.

### Changed

- Script version → `v2.3.1.0`
- Validated Brave → `1.92.139` (Chromium 150.0.7871.176)
- Documentation updated (README, Wiki, CHANGELOG)

### Files

- `BraveOmega-EN.ps1` — English script
- `BraveOmega-TR.ps1` — Turkish script
- `index.html` — Interactive policy configurator

### Documentation

- [Wiki](https://github.com/bayraktarozcan/Brave-Omega-Project/wiki)
- [Changelog](https://github.com/bayraktarozcan/Brave-Omega-Project/blob/main/CHANGELOG.md)
