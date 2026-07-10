# Release Note Template

Copy the template below and fill in placeholders when creating new releases.

---

```markdown
## v{VERSION} — {TITLE}

**{ONE_LINE_SUMMARY}**

### Summary

{BRIEF_DESCRIPTION}

| Metric | Before | After |
|--------|--------|-------|
| Hardening levels | 5 | 5 |
| Total policies | {BEFORE} | **{AFTER}** ({DIFF}) |
| Brave Only | {BO_BEFORE} | {BO_AFTER} |
| Essential | {ES_BEFORE} | {ES_AFTER} |
| Balanced | {BA_BEFORE} | {BA_AFTER} |
| Advanced | {AD_BEFORE} | {AD_AFTER} |
| Strict | {ST_BEFORE} | {ST_AFTER} |
| Cumulative chain | {CHAIN_BEFORE} | **{CHAIN_AFTER}** |

### Added

{POLICY_NAME} ({TIER}) — {DESCRIPTION}

### Changed

- {CHANGE_DESCRIPTION}

### Removed

{POLICY_NAME} — {REASON}

### Files

- `BraveOmega-EN.ps1` — English script
- `BraveOmega-TR.ps1` — Turkish script
- `index.html` — Interactive policy configurator

### Documentation

- [Wiki](https://github.com/bayraktarozcan/Brave-Omega-Project/wiki)
- [Changelog](https://github.com/bayraktarozcan/Brave-Omega-Project/blob/main/CHANGELOG.md)
```

---

## Example: v2.3.1.0

```markdown
## v2.3.1.0 — Brave 1.92.139 Compatibility & ProxyMode Deprecation Fix

**Lightweight validation release — ProxySettings added to Essential tier.**

### Summary

Validates full compatibility with Brave **1.92.139** (Chromium 150.0.7871.176).
Adds `ProxySettings` to Essential tier for proxy configuration placeholder support.

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

- **`ProxySettings`** (Essential) — Configures proxy server address via JSON.
  Placeholder — customize per deployment.

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
```
