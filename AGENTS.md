<!-- ================================================================== -->
<!--          BRAVE OMEGA PROJECT — AGENTS.md                           -->
<!--        Community Edition · Open Source · Privacy First             -->
<!-- ================================================================== -->

<div align="center">

<br>

# 🦁 Brave Omega — Agent Guide

<br>

</div>

---

## Agent Guide

Operational notes for humans and AI agents working in this repository. English is the single source of operational truth; the untracked local file `AGENTS-TR.md` mirrors it in Turkish for human review.

### Repository Layout

| Path | Purpose |
|------|---------|
| `Brave Omega/BraveOmega.ps1` | Unified EN/TR hardening script (single source of policy truth) |
| `Brave Omega/docs/policy-catalog.md` | Full per-policy catalog with metadata |
| `admx/` | ADMX templates + `admx-validate.ps1` cross-reference validator |
| `Tests/` | Pester 5.7.1 test suite |
| `Wiki/` | Source of truth for the GitHub Wiki (auto-synced by `wiki-sync.yml`) |
| `.github/workflows/` | CI/CD: Quality, Pages, Wiki Sync, ADMX, Secret Scan, Link Check, Stale, Version Check, Hygiene |
| `.github/linters/` | Shared markdownlint / yamllint configuration |

### Versions

| Constant | Current | Where |
|----------|---------|-------|
| Script | `v2.8.1.0` | `BraveOmega.ps1` header + `$ScriptVersion` |
| Brave | `1.96.59` | `$ValidatedBrave` |
| Chromium | `154` | `$ValidatedChromium` (major only) |

Policy totals: 151 across 5 tiers; cumulative chain `24 → 51 → 83 → 123 → 151`.

### Validation Commands

Run from the repository root with Windows PowerShell 5.1:

```powershell
# Pester
Invoke-Pester Tests/ -PassThru          # expected: 169/169 passing

# ADMX cross-reference
& "admx/admx-validate.ps1"              # expected: PASS - 151/151

# PSScriptAnalyzer
Invoke-ScriptAnalyzer "Brave Omega/BraveOmega.ps1" -Severity Warning `
  -ExcludeRule PSAvoidUsingWriteHost,PSAvoidUsingEmptyCatchBlock,PSUseSupportsShouldProcess,PSUseShouldProcessForStateChangingFunctions

# Markdown (repo config)
markdownlint -c .github/linters/.markdownlint.json "**/*.md"

# YAML
yamllint .github/ --config-file .github/linters/.yamllint.yml
```

`pwsh` is not installed locally — use `powershell` / Windows PowerShell 5.1.

### Conventions

- **Bilingual docs.** User-facing `.md` files follow the EN-first + TR-mirror
  pattern (see CONTRIBUTING.md). Keep headings, anchors, and badges consistent.
- **Policy edits.** Change policy definitions only in the data layer
  (`Brave Omega/config.json` + `Brave Omega/profiles/*.json`; loaded at runtime
  via `Import-OmegaPolicyData` into `$OmegaState`). Deprecated policies must be
  removed from the profile files — the ADMX validator (`admx-validate.ps1`)
  enforces the cross-reference.
- **Version bumps.** Add a changelog entry (CHANGELOG.md + `Wiki/Changelog.md`),
  bump `$ScriptVersion` / `$ValidatedBrave` / `$ValidatedChromium`, then update
  the hand-maintained "Validated on" header in `docs/policy-catalog.md`, README §8,
  `index.html` (hero, prerequisites, compat rows), and the Wiki pages.
- **Compatibility.** The script targets Windows PowerShell 5.1+; no `pwsh`-only syntax.
- **Git.** `origin` pushes to both GitHub and GitLab (dual pushurl). Keep the two
  remotes in parity — there is no PR/MR workflow for own commits.
- **Wiki.** Edits belong in `Wiki/` here — `wiki-sync.yml` mirrors them to the
  live wiki after every push that touches `Wiki/**`.

### Local Turkish Mirror

- `AGENTS-TR.md` is an untracked, gitignored Turkish mirror of this file — read
  by the human for auditing, never committed or pushed.
- **Rule:** whenever this file changes, refresh `AGENTS-TR.md` so the `sync-sha`
  values in both files are identical.
- `sync-sha` = SHA1 (UTF-8, no BOM) of this file with its own
  `<!-- mirror-sync: ... -->` line removed. A mismatch means drift.

<!-- mirror-sync: sync-sha=7173d05317c881477c011fe73a474de74544b48b -->