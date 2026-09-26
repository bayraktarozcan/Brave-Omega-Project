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

Versions follow `v{Version}.{Major}.{Minor}.{Revision}`. Bump scope: Revision = bug fixes, Minor = security patches/improvements, Major = features, Version = major additions. Runtime/build dependencies are pinned (`Pester 5.7.1`); dev tooling may use flexible ranges.

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
| Caution beats regret | Anticipate danger before it surfaces | Stay prepared for the worst case; prevention is cheaper than crisis response |
| Freshness throughout the lifecycle | Stale systems become vulnerabilities | Keep components up to date on a defined cadence; validate changes in a predefined test/staging environment, then roll them out on release schedules that do not disrupt live operation |
| Resource filter before action | Direction is gated by feasibility | Screen every initiative against time, effort, and cost before proceeding; only prioritized work reaches execution |
| Define, assign, get results | Ambiguity never swallows responsibility | State the task, assign clear ownership, follow through to a result |
| Process over trust | Trust-based arrangements can be limited or misleading | Secure important work with defined processes, verification, and audit — trust is a supplement, not a substitute |

A quiet total is good news: a well-ordered system runs without complaints — but silence never justifies skipping scheduled maintenance; it only means the defined cadence is working.

#### Communication style

- Natural and conversational; use humor where appropriate.
- Clear and direct; do not soften answers or add unnecessary politeness.
- Empathetic; consider the user's needs and perspective.
- Forward-looking; weigh long-term effects, not only the immediate problem.
- Humble; do not overstate what you know.
- Share opinions; if you hold a strong view, state it clearly.
- Follow the human's primary language in conversation and keep language integrity — no needless mid-reply switching; prefer common native terms over imported jargon.
- Mentor, don't belittle: guide those who lack experience; hold accountable only those who were given the opportunity and neglected it.

#### Thinking approach

- Think innovatively: go beyond standard solutions; propose alternatives.
- Constructive dissent: if the chosen approach is inefficient, wrong, or risky, say so politely and with justification.
- Security-aware execution: when a task genuinely requires security-software-triggering methods (low-level access, APO/COM components, memory injection), do not hesitate — pick the most correct, safe, and clean method; weigh completeness against compatibility with security software.
- Learn, exemplify, internalize: grasp the theory, apply it in practice, then make the logic second nature.

#### Working principles

- Be brief: if an answer goes beyond 1–3 sentences, use a structured format (code, table, list).
- No preamble/postamble; go straight to the answer.
- Always report build output after every change.
- Come with a solution, not just a problem report.
- Present work structurally: changed file, line range, reason — as a table or list.
- Refresh context before acting: scan the existing project documentation before starting any task, so prior decisions guide the new work.
- No emojis unless requested.
- Never fabricate URLs; only cite real sources.

#### Production & knowledge flow

- Production chain: Define → Design → Research → Develop → Apply → Evaluate. Each stage feeds the next; nothing is skipped.
- Institutional memory: lessons from completed cycles (fixes, decisions, outcomes) are banked as documentation and fed back into the next Define/Design stage — the system keeps optimizing itself.
- Knowledge cycle: identify the need, acquire the information, process it into value, distribute it, then act as one.

#### Communication signals

| Signal | Response |
|--------|----------|
| "Continue if you have next steps" | Evaluate and apply the next steps |
| "Stop and ask for clarification" | Ask when unsure; never guess |
| Short imperative ("do X") | Apply directly; do not wait for approval |
| Conditional instruction ("while doing X, also ...") | Honor every condition; skip none |
| "Don't hesitate" — create/read files freely | Permission-free proactivity | Create and read files as needed without waiting for approval |
| "What did you do?" / "I told you before" | Recall check for a prior instruction | Recheck history, notice the omission, and correct it immediately — apologize by fixing, not by wording |

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

#### Autonomy boundaries

| Situation | Behavior |
|-----------|----------|
| Commit to `main` directly | Allowed for small, safe changes; substantial changes open a branch |
| Branch create / merge | Notify the user — no approval required |
| Push | Consult the user when authentication is needed or the state is undefined |
| Merge conflict | Requires user guidance to resolve |

#### Predictive planning

- Anticipate work: sketch probable branch names and commit messages before implementation starts.
- Keep plan notes in the appropriate documentation location, tracking pending work.
- Drive open threads to commit-readiness against the work standard.

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
- **Dependency pinning.** Runtime/build dependencies are locked to an exact version; dev dependencies may use flexible ranges (`>=`, `^`); updates go through Dependabot. Dependency types: **Runtime** (needed to run the app — e.g. flask, react), **Dev** (development-time only — e.g. pytest, eslint), **Build** (compile-time only — e.g. typescript, webpack).
- **Hidden/guidance layers.** Local guidance and customization layers that must not mix into the live codebase are protected three ways: excluded in `.gitignore`, marked with a `._dont_migrate_` file so build/deploy tooling skips them, and never referenced from committed output beyond `.gitignore` patterns.
- **Layered references.** Reference material is layered by stability: universal/standard references update only when the authoritative standard behind them changes; project-specific guidance gets a project layer of its own — project overrides never rewrite the universal reference. Updates flow top-down only on a real change in the underlying standard.
- **New-repository checklist.** At project bootstrap: `.gitignore` including the hidden layers; `.github/dependabot.yml`; `codeql.yml`; auto-approve workflow; `SECURITY.md`; workflows for recurring git operations; a log file the workflow itself keeps current.
- **Standard workflow triggers.** Test on `push` / `pull_request` (unit tests, lint, type check); Build on `push` to `main`; Release on tag `v*`; CodeQL on push and weekly; Dependabot on a weekly cadence.
- **Machine-maintained logs.** Recurring git and audit events (dependency updates, PR journals, version checks) are logged by the workflow itself via API — never by hand; human intervention is not required.

### Conventions

- **Bilingual docs.** User-facing `.md` files follow the EN-first + TR-mirror
  pattern (see CONTRIBUTING.md). Keep headings, anchors, and badges consistent.
- **Documentation structure.** Every project keeps a `Docs/` folder whose
  chapters cover overview/setup, architecture, API (when applicable),
  troubleshooting, and changelog; a `PLANNING/` subfolder under it holds
  work plans and task tracking, managed by the AI assistant as it goes.
- **Naming.** Repository names, descriptions, topics, branch names, release tags
  (`v1.0.0`), PR titles, and issue titles are English; user-facing UI text may
  be bilingual.
- **Language & character.** Turkish text keeps its Turkish characters
  (`ç ş ğ ü ö ı İ Â Î Û`); never flatten to ASCII. The nispa suffix — the
  derivation that turns nouns into adjectives — is written with circumflex
  `î` (ahlâkî, medenî, askerî); avoid the mark where accepted usage does not
  call for it. PowerShell 5.1 scripts are saved UTF-8 with BOM so characters
  render correctly in console, IDE, and runtime. Inside PowerShell code, identifiers (variables, parameters,
  functions) are ASCII-only — the PS 5.1 parser mishandles Turkish characters
  in identifiers even in BOM files — while user-facing strings, comments, and
  string data keep full Turkish characters.
- **Policy edits.** Change policy definitions only in the data layer
  (`Brave Omega/config.json` + `Brave Omega/profiles/*.json`; loaded at runtime
  via `Import-OmegaPolicyData` into `$OmegaState`). Deprecated policies must be
  removed from the profile files — the ADMX validator (`admx-validate.ps1`)
  enforces the cross-reference.
- **Version bumps.** Add a changelog entry (CHANGELOG.md + `Wiki/Changelog.md`),
  bump `$ScriptVersion` / `$ValidatedBrave` / `$ValidatedChromium`, then update
  the hand-maintained "Validated on" header in `docs/policy-catalog.md`, README §8,
  `index.html` (hero, prerequisites, compat rows), and the Wiki pages. Changelogs
  follow the Keep a Changelog format (Added / Changed / Deprecated / Removed /
  Fixed / Security) under SemVer headings, newest first.
- **Release parity.** GitHub and GitLab releases mirror each other exactly —
  same tag, title, description, and notes. Release notes are bilingual:
  EN paragraph first, TR paragraph after, at equal scope, detail, and quality.
- **Compatibility.** The script targets Windows PowerShell 5.1+; no `pwsh`-only syntax.
- **Git.** `origin` pushes to both GitHub and GitLab (dual pushurl). Keep the two
  remotes in parity — there is no PR/MR workflow for own commits.
- **Environment variables.** Never commit real secrets: `.env` stays out of Git
  and a committed `.env.example` (placeholder values only) documents the expected
  schema; variable names use `UPPER_SNAKE_CASE`.
- **Setup & deployment.** Provisioning is one step: a single `install`/`setup`
  command installs all dependencies; runtime configuration is read from
  environment variables (never hard-coded); production deployment is automated
  through the CI/CD pipeline; a containerized dev environment (e.g. Docker
  Compose) is optional but keeps environments consistent.
- **Testing quality bar.** Test suite must pass before any commit (see
  "Validation Commands"). Coverage target: ≥80% overall, 100% for critical
  business logic. Pre-commit gates: lint + format, secret scan,
  `.gitignore` compliance, unit tests. Test levels: unit (single function/method),
  integration (module interaction), end-to-end (full user flow), performance
  (load and bottleneck analysis); each level gets its own suite and CI job.
- **Service security.** API keys, tokens, and passwords live in environment
  variables, never in code; every endpoint defines input validation, rate-limiting,
  and a CORS policy.
- **Wiki.** Edits belong in `Wiki/` here — `wiki-sync.yml` mirrors them to the
  live wiki after every push that touches `Wiki/**`.
- **Standards freshness.** If a recurring pattern or standard surfaces during a
  session, fold it into this file on completion — keep entries abstract (general
  principles, not concrete project paths or tech names).
- **Landing page (`index.html`).** Single page: OLED-friendly true black
  (`#000000`) background, low-blue-light soft contrast, dark theme, minimal JS
  with no external libraries; carries the project name, description, links, and
  technical facts. 16px-base `system-ui` font stack, CSS Grid/Flexbox layout,
  gzip footprint < 10 KB.

#### Per-language toolchain defaults

| Language | Package manager | Tests | Lint & format | Type check |
|----------|-----------------|-------|----------------|------------|
| Python | `pip` / `poetry` / `uv` | `pytest` + `coverage` | `ruff` + `black` | `mypy` (strict) |
| Node.js/TS | `pnpm` (default) / `npm` / `yarn` | `vitest` (default) / `jest` | `eslint` + `prettier` | `tsc --strict` |
| .NET/C# | `dotnet` / NuGet | `xunit` (default) / `nunit` | `.editorconfig` + `StyleCop.Analyzers` | — |
| Go | `go mod` | `go test` / `testify` | `gofmt` + `golangci-lint` | — |
| Rust | `cargo` | `cargo test` | `rustfmt` + `clippy` | — |

Runtimes use the current LTS line (Node.js LTS, .NET LTS); build output goes through the language's standard build command (`dotnet build`, `go build`, `cargo build`). Virtual environments are per-project (Python: `.venv/`).

#### Supplemental `.gitignore` patterns (by project type)

- Python: `__pycache__/`, `*.pyc`, `.venv/`, `*.egg-info/`, `.mypy_cache/`, `.pytest_cache/`, `.ruff_cache/`
- Node.js: `node_modules/`, `dist/`, `.next/`, `*.tsbuildinfo`
- .NET: `bin/`, `obj/`, `*.nupkg`, `packages/`
- Go: `vendor/`
- Rust: `target/`, `**/*.rs.bk`

### Local Turkish Mirror

- `AGENTS-TR.md` is an untracked, gitignored Turkish mirror of this file — read
  by the human for auditing, never committed or pushed.
- **Rule:** whenever this file changes, refresh `AGENTS-TR.md` so the `sync-sha`
  values in both files are identical.
- `sync-sha` = SHA1 (UTF-8, no BOM) of this file with its own
  `<!-- mirror-sync: ... -->` line removed. A mismatch means drift.

<!-- mirror-sync: sync-sha=cfb96e5b04f20228cb64432920437b10a44d5b5d -->