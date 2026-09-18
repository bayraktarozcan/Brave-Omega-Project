<!-- ================================================================== -->
<!--          BRAVE OMEGA PROJECT — AGENTS.md                           -->
<!--        Community Edition · Open Source · Privacy First             -->
<!-- ================================================================== -->

<div align="center">

<br>

# 🦁 Brave Omega — Agent Guide

<br>

> **Language / Dil** &nbsp;
> [EN English](#-english-agent-guide) &nbsp;·&nbsp; [TR Türkçe](#-türkçe-agent-rehberi)

<br>

</div>

---

<a id="-english-agent-guide"></a>

## EN English Agent Guide

Operational notes for humans and AI agents working in this repository.

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
| Script | `v2.7.1.0` | `BraveOmega.ps1` header + `$ScriptVersion` |
| Brave | `1.95.101` | `$ValidatedBrave` |
| Chromium | `153` | `$ValidatedChromium` (major only) |

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
- **Policy edits.** Change policy definitions only in `BraveOmega.ps1`
  (`$allPolicyNames` and friends). Deprecated policies must be removed from that
  list — the ADMX validator (`admx-validate.ps1`) enforces the cross-reference.
- **Version bumps.** Add a changelog entry (CHANGELOG.md + `Wiki/Changelog.md`),
  bump `$ScriptVersion` / `$ValidatedBrave` / `$ValidatedChromium`, then update
  the hand-maintained "Validated on" header in `docs/policy-catalog.md`, README §8,
  `index.html` (hero, prerequisites, compat rows), and the Wiki pages.
- **Compatibility.** The script targets Windows PowerShell 5.1+; no `pwsh`-only syntax.
- **Git.** `origin` pushes to both GitHub and GitLab (dual pushurl). Keep the two
  remotes in parity — there is no PR/MR workflow for own commits.
- **Wiki.** Edits belong in `Wiki/` here — `wiki-sync.yml` mirrors them to the
  live wiki after every push that touches `Wiki/**`.

---

<a id="-türkçe-agent-rehberi"></a>

## TR Türkçe Agent Rehberi

Bu depoda çalışan insan ve yapay zekâ ajanları için operasyonel notlar.

### Depo Düzeni

| Yol | Amaç |
|-----|------|
| `Brave Omega/BraveOmega.ps1` | Birleşik EN/TR sıkılaştırma betiği (politikaların tek kaynağı) |
| `Brave Omega/docs/policy-catalog.md` | Meta verili tam politika kataloğu |
| `admx/` | ADMX şablonları + `admx-validate.ps1` çapraz referans doğrulayıcısı |
| `Tests/` | Pester 5.7.1 test paketi |
| `Wiki/` | GitHub Wiki'nin gerçek kaynağı (`wiki-sync.yml` ile otomatik eşitlenir) |
| `.github/workflows/` | CI/CD: Quality, Pages, Wiki Sync, ADMX, Secret Scan, Link Check, Stale, Version Check, Hygiene |
| `.github/linters/` | Ortak markdownlint / yamllint yapılandırması |

### Sürümler

| Sabit | Güncel | Nerede |
|-------|--------|--------|
| Betik | `v2.7.1.0` | `BraveOmega.ps1` başlığı + `$ScriptVersion` |
| Brave | `1.95.101` | `$ValidatedBrave` |
| Chromium | `153` | `$ValidatedChromium` (yalnızca ana sürüm) |

Politika toplamı: 5 seviyede 151; kümülatif zincir `24 → 51 → 83 → 123 → 151`.

### Doğrulama Komutları

Depo kökünden Windows PowerShell 5.1 ile çalıştırın:

```powershell
# Pester
Invoke-Pester Tests/ -PassThru          # beklenen: 169/169 geçti

# ADMX çapraz referans
& "admx/admx-validate.ps1"              # beklenen: PASS - 151/151

# PSScriptAnalyzer
Invoke-ScriptAnalyzer "Brave Omega/BraveOmega.ps1" -Severity Warning `
  -ExcludeRule PSAvoidUsingWriteHost,PSAvoidUsingEmptyCatchBlock,PSUseSupportsShouldProcess,PSUseShouldProcessForStateChangingFunctions

# Markdown (depo yapılandırması)
markdownlint -c .github/linters/.markdownlint.json "**/*.md"

# YAML
yamllint .github/ --config-file .github/linters/.yamllint.yml
```

Yerelde `pwsh` kurulu değildir — `powershell` / Windows PowerShell 5.1 kullanın.

### Kurallar

- **İki dilli belgeler.** Kullanıcıya dönük `.md` dosyaları EN-önce + TR-yansıma
  düzenini izler (bkz. CONTRIBUTING.md). Başlıkları, çapaları ve rozetleri tutarlı tutun.
- **Politika düzenlemeleri.** Politika tanımlarını yalnızca `BraveOmega.ps1` içinde
  değiştirin (`$allPolicyNames` ve benzerleri). Kullanımdan kaldırılan politikalar o
  listeden çıkarılmalıdır — ADMX doğrulayıcı (`admx-validate.ps1`) çapraz referansı zorlar.
- **Sürüm güncellemeleri.** Değişiklik günlüğü satırı ekleyin (CHANGELOG.md +
  `Wiki/Changelog.md`), `$ScriptVersion` / `$ValidatedBrave` / `$ValidatedChromium`
  sürümlerini yükseltin, ardından elle bakılan `docs/policy-catalog.md` "Validated on"
  başlığını, README §8'i, `index.html`'i (hero, ön koşullar, uyumluluk satırları) ve
  Wiki sayfalarını güncelleyin.
- **Uyumluluk.** Betik Windows PowerShell 5.1+ hedeflidir; `pwsh`-yalnız sözdizimi kullanmayın.
- **Git.** `origin` hem GitHub hem GitLab'e gönderir (çift pushurl). İki uzak depo
  arasında eşitlik sağlayın — kendi commit'leriniz için PR/MR akışı yoktur.
- **Wiki.** Düzenlemeler buradaki `Wiki/` klasörüne yapılır — `wiki-sync.yml`,
  `Wiki/**` dokunulan her push sonrası değişiklikleri canlı wiki'ye yansıtır.