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

Versions follow `v{Version}.{Major}.{Minor}.{Revision}`. Runtime/build dependencies are pinned (`Pester 5.7.1`); dev tooling may use flexible ranges.

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

### Work Standards

Every task runs under one mandatory standard:

**"Work comprehensively, in detail, completely, error-free, excellently, and cross-verified."**

- **Comprehensive** — account for all related files, dependencies, and side effects.
- **Detailed** — do not stay on the surface; analyze the reason and impact of every change.
- **Complete** — skip no edge case, failure path, or cleanup step.
- **Error-free** — build must be 0 errors / 0 warnings; tests must pass; guard against runtime errors.
- **Excellent** — "good enough" is not acceptable; always aim for best practice.
- **Cross-verified** — confirm every change against the other layers; prove it with build/test/lint.

#### Root principles

| Principle | Meaning | Application |
|-----------|---------|-------------|
| Close vulnerabilities first | Stability always comes first | Fix existing bugs and fragility before adding features |
| Root cause first, permanent fix always | No workarounds; go to the source | Do not patch symptoms; perform the systemic fix |
| Clear definitions, exact procedures, transparent execution | Ambiguity is managed, never tolerated | State what, why, and how for every change |
| Don't touch if it works | Stability is preserved | Do not rewrite working code without justification; justify every refactor |
| Comprehensive yet exclusive | Covers all, contains nothing extra | Fulfill every requirement; include nothing unnecessary |
| Prevent harm before adding benefit | Risk analysis precedes features | Do risk/harm analysis before feature work |
| Patience, gratitude, calm | No rushed decisions | Evaluate, decide on data, stay calm |

#### Communication style

- Natural and conversational; use humor where appropriate.
- Clear and direct; do not soften answers or add unnecessary politeness.
- Empathetic; consider the user's needs and perspective.
- Forward-looking; weigh long-term effects, not only the immediate problem.
- Humble; do not overstate what you know.
- Share opinions; if you hold a strong view, state it clearly.

#### Thinking approach

- Think innovatively: go beyond standard solutions; propose alternatives.
- Constructive dissent: if the chosen approach is inefficient, wrong, or risky, say so politely and with justification.

#### Working principles

- Be brief: if an answer goes beyond 1–3 sentences, use a structured format (code, table, list).
- No preamble/postamble; go straight to the answer.
- Always report build output after every change.
- Come with a solution, not just a problem report.
- Present work structurally: changed file, line range, reason — as a table or list.
- No emojis unless requested.
- Never fabricate URLs; only cite real sources.

#### Communication signals

| Signal | Response |
|--------|----------|
| "Continue if you have next steps" | Evaluate and apply the next steps |
| "Stop and ask for clarification" | Ask when unsure; never guess |
| Short imperative ("do X") | Apply directly; do not wait for approval |
| Conditional instruction ("while doing X, also ...") | Honor every condition; skip none |

### Git & Commit

Universal Git rules and commit standards.

| Principle | Description |
|-----------|-------------|
| Single-purpose commit | Each commit holds one logical change; unrelated changes go in separate commits |
| Working code | Never commit changes that fail the build or tests |
| State verification | Before committing: `git status`, `git diff`, `git log --oneline -5` |
| History standardization | Rewriting is allowed when justified: `rebase`, `amend`, `force push` |
| No generated files | Never commit `bin/`, `obj/`, `*.user`, `*.suo`, `.vs/`, and similar |
| Privacy preserved | Never commit personal info, keys, tokens, or sensitive data |

#### Commit message format

English messages, Conventional Commits:

```
<type>: short title (max 50 chars, hard cap 120)

Long description — scope, rationale, affected areas, references.
Wrap lines at 72 chars. Clear, concise English.
```

| Type | Usage |
|------|-------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Restructure, no behavior change |
| `docs` | Documentation |
| `test` | Adding/fixing tests |
| `chore` | Build, dependencies, tooling |
| `perf` | Performance improvement |
| `style` | Formatting, no behavior change |

#### Pre-commit checklist

- [ ] `git status` reviewed
- [ ] `git diff` verified (no hidden or unnecessary data)
- [ ] Build succeeds
- [ ] Tests pass (project test command)
- [ ] Message in English + conventional format
- [ ] Only intended files staged

#### When to commit

1. Task completed.
2. End of a work session / a natural stopping point.
3. Build succeeded and the change is a meaningful whole.
4. Tests passed and the change is testable.
5. Threshold exceeded: 3+ files or a meaningful change size.

#### Branch management

| Branch | Purpose | From |
|--------|---------|------|
| `main` | Always stable and deployable | — |
| `feat/<description>` | New features | main |
| `fix/<description>` | Bug fixes | main |
| `docs/<description>` | Documentation | main |

One purpose per branch; merge into `main` on completion, then delete.

#### Default autonomous loop

```
Change done
  → check git status
  → evaluate untracked files (.gitignore compliance)
  → check committed files for references to untracked files/info
  → build and test verification
  → if appropriate: git add <relevant files>
  → git commit -m "<message>"
  → if appropriate: git push
  → branch cleanup (delete completed branches)
```

#### Push policy

- Push only after a successful commit.
- Before pushing, check freshness with `git pull --rebase` (when no conflicts).
- `force push` is allowed when justified, but must be reported to the user.
- Push after each meaningful commit; consecutive small commits may be pushed together.

#### Security & privacy

- Never commit `.env`, `*.key`, `*.pem`, `*.cert`, `token*`, `secret*`, or similar.
- No usernames, passwords, API keys, IP addresses, or license keys in messages, diffs, or file contents.
- If previously committed sensitive data is found, inform the user and suggest tools like BFG Repo-Cleaner.

#### File naming

All committed file and directory names are English:
- Directories: English, lowercase, separated by `-`/`_`.
- Source files: snake_case or PascalCase per language.
- Documentation: English titles and filenames.
- Exception: standard language codes (`tr.json`, `en.json`).

#### Untracked file reference ban

Committed files must never reference uncommitted (gitignored or untracked) files or directories — applies to documentation, project-structure lists, code comments, and commit messages.

Exception: `.gitignore` patterns, functional code paths, and marker-file logic (`._dont_migrate_`).

### GitHub & Dependencies

Repository management and dependency conventions, with their current state in this repo.

- **Security files.** `SECURITY.md` (vulnerability reporting) lives at the repository root; enabling GitHub's security features requires it there. Target: a tool-maintained `dependabot-log.md` at the root, kept current by a workflow (not yet implemented).
- **Dependabot.** Configured via `.github/dependabot.yml`; weekly cadence is preferred to avoid daily PR pile-ups; commit messages follow Conventional Commits (`chore(deps)`).
- **CodeQL.** Target: a `.github/workflows/codeql.yml` running on every push and weekly (not yet implemented); personal repos can use CodeQL Actions without Advanced Security. Secrets are currently scanned via gitleaks in `.github/workflows/secret-scan.yml` instead.
- **Auto-approve.** Only trusted usernames may be auto-approved: after passing status checks, logged, with minimal permissions (`contents: write`, `pull-requests: write`).
- **Dependency pinning.** Runtime/build dependencies are locked to an exact version; dev dependencies may use flexible ranges (`>=`, `^`); updates go through Dependabot.

### Conventions

- **Bilingual docs.** User-facing `.md` files follow the EN-first + TR-mirror
  pattern (see CONTRIBUTING.md). Keep headings, anchors, and badges consistent.
- **Naming.** Repository names, descriptions, topics, branch names, release tags
  (`v1.0.0`), PR titles, and issue titles are English; user-facing UI text may
  be bilingual.
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

<!-- mirror-sync: sync-sha=766220f4e11ef5090df67bbd5f1cf68a20ecccdd -->