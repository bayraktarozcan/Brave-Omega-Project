<!-- ================================================================== -->
<!--          BRAVE OMEGA PROJECT — AGENTS.md                           -->
<!--        Community Edition · Open Source · Privacy First             -->
<!-- ================================================================== -->

> ## ⛔ The One Rule Above All
> **Every change is applied directly and immediately to the live project files in this repository — the production working tree. Never do work "in the cloud", in a temp/scratch directory, in a hidden layer, or inside a detached script. If the user cannot see the change live in this tree right now, it does not exist.**
> **No atomic operations. Work piece by piece, brick by brick — one change, one file, visible at every second.**
> **The user watches the live working tree the whole time. Stop after each piece and report; never run silent marathon sessions, and never build verification before touching the tree — touch the tree first, then verify.**

<div align="center">

<br>

# 🦁 Brave Omega — Agent Guide

<br>

</div>

---

## Agent Guide

Operational notes for humans and AI agents working in this repository. English is the single source of operational truth; a Turkish mirror of this file is maintained locally for human review.

### Repository Layout

| Path | Purpose |
|------|---------|
| `Brave-Omega/BraveOmega.ps1` | Unified EN/TR hardening script (single source of policy truth) |
| `Brave-Omega/Docs/Policy-Catalog.md` | Full per-policy catalog with metadata |
| `Brave-Omega/config.json` + `Brave-Omega/Profiles/*.json` | Policy data layer - the only place policy definitions change |
| `Enterprise/` | Per-tier `.reg` templates + `levels.json` registry export |
| `ADMX/` | ADMX templates + `ADMX-Validate.ps1` cross-reference validator |
| `Scripts/` | Release, wiki sync, deploy/detect, catalog export, mojibake scan |
| `Tests/` | Pester 5.7.1 test suite - one file per invariant |
| `Tests/MirrorSync.Tests.ps1` | Fixtures pinning the bilingual mirror contract (clean pair, CRLF mirror, each drift class, ordered checklist, absent mirror) |
| `Tests/OpenCodeConfig.Tests.ps1` | Contract of the runtime control surface: parseable, vendor-schema-pinned, catch-all ordering, no blanket deny, no duplicated procedure |
| `.opencode/opencode.json` | Runtime permissions, `/verify`, and the read-only audit agent - the machine half of the rules in this file |
| `Wiki/` | Source of truth for the GitHub Wiki (auto-synced by `wiki-sync.yml`) |
| `Brave-Omega/Docs/` | Project-level references: group policy reference, roadmap and opportunities |
| `index.html` | Single-page landing page (true black, dark theme, no external JS, < 10 KB gzipped) |
| Root governance set | `README.md`, `SECURITY.md`, `PRIVACY.md`, `SUPPORT.md`, `CODE_OF_CONDUCT.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, `RELEASE-NOTE-TEMPLATE.md`, `CODEOWNERS`, `LICENSE`, `NOTICE` |
| `.github/workflows/` | CI/CD: Quality, Pages, Wiki Sync, ADMX, Secret Scan, Link Check, Stale, Version Check, Hygiene |
| `.gitlab-ci.yml` | Second gate - the same checks enforced on the GitLab remote |
| `.github/linters/` | Shared markdownlint / yamllint configuration |

### Versions

| Constant | Current | Where |
|----------|---------|-------|
| Script | `v3.0.1.0` | `BraveOmega.ps1` header + `$ScriptVersion` |
| Brave | _(unpinned — detected at runtime)_ | `$ValidatedBrave` (populated from install; V3 never blocks) |
| Chromium | _(unpinned — detected at runtime)_ | `$ValidatedChromium` (populated from install; V3 never blocks) |

Policy totals: 151 across 5 tiers; cumulative chain `24 → 51 → 83 → 123 → 151`.

Versions follow `v{Version}.{Major}.{Minor}.{Revision}`. Bump scope: Revision = bug fixes, Minor = security patches/improvements, Major = features, Version = major additions. Runtime/build dependencies are pinned (`Pester 5.7.1`); dev tooling may use flexible ranges.

### Validation Commands

Run from the repository root with Windows PowerShell 5.1:

```powershell
# CI conformance gate - runs every check the Quality workflow declares.
# This is the gate that runs before every commit and every push.
& "Scripts/Invoke-CI.ps1"

# Install the pre-push hook that runs the gate for you
& "Scripts/Invoke-CI.ps1" -InstallHook

# Pester
Invoke-Pester Tests/ -PassThru          # expected: 338/338 passing

# ADMX cross-reference
& "ADMX/ADMX-Validate.ps1"              # expected: PASS - 151/151

# PSScriptAnalyzer
# -ExcludeRule takes an array. A comma-joined string is silently accepted and
# then ignored, so the run reports every rule the list was meant to drop.
$excluded = @(
  'PSAvoidUsingWriteHost',
  'PSAvoidUsingEmptyCatchBlock',
  'PSUseSupportsShouldProcess',
  'PSUseShouldProcessForStateChangingFunctions'
)
Invoke-ScriptAnalyzer "Brave-Omega/BraveOmega.ps1" -Severity Warning -ExcludeRule $excluded

# Markdown (repo config)
markdownlint -c .github/linters/.markdownlint.json "**/*.md"

# Mirror sync (local only; the operator supplies the mirror path)
& "Scripts/Verify-Mirror-Sync.ps1" -Canonical AGENTS.md -Mirror <mirror-path>

# YAML
yamllint .github/ --config-file .github/linters/.yamllint.yml
```

#### Runtime Control Surface (`.opencode/opencode.json`)

Prose can state a rule; only a machine can hold it. `.opencode/opencode.json`
carries the three controls this repository cannot enforce by asking, and holds
nothing else:

| Control | What it enforces that this file cannot |
|---------|---------------------------------------|
| `permission.bash` | `git clean -f*` asks, because a force-clean deletes the untracked local-only layers this repository refuses to track and would miss; `git push -f*` / `--force*` ask, which is the report this file requires; `reg add*` / `reg delete*` ask, because a hand-written registry edit bypasses the policy data layer that the ADMX validator reads |
| `permission.external_directory` | Credential and config stores under the home directory are denied. The default is `ask`, and an approval made once holds for the rest of the session - which is the wrong default for a private key |
| `command.verify` + `agent.policy-auditor` | `/verify` runs the gate above and the audit agent cannot edit, so the Evaluate stage cannot quietly turn into a rewrite |

Three rules govern the file, and `Tests/OpenCodeConfig.Tests.ps1` holds each of
them: this file states **no rule that belongs here** - it names the gate and
points at this file rather than restating the procedure; every exception is
specific, ordered after its catch-all because the last matching rule wins, and
never a blanket deny; and the `$schema` is the vendor URL, so the vendor's
schema is the oracle rather than a list kept beside it.

`.opencode/` also holds state OpenCode owns: on first open it writes its own
`.gitignore` and installs `@opencode-ai/plugin` into `.opencode/node_modules`,
ignoring both. That is why the PowerShell syntax check skips `node_modules` -
a third-party script the Windows PowerShell parser dislikes would otherwise
fail a gate on a file this project never wrote.

`pwsh` (PowerShell 7.6.6) is the shell whenever the system has it — every shell invocation uses it. When the system does not have it, the agent never installs it and uses `powershell` / Windows PowerShell 5.1 instead.

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
| A machine check proves only what it measures | Every automated check has a blind spot, and a green run is a statement about the measured axis alone | The bilingual mirror passed every structural gate while one side had silently lost two checklist items, so structure parity is never reported as semantic parity; each check names what it cannot see and that gap stays a human read |
| A rule that can rot silently gets its own named test | Coverage of code is not coverage of rules; the invariant gets the test, and the test fails when the rule breaks rather than when the code moves | The test tree is one file per invariant — ignore rules, mirror sync, script version, policy integrity, stale cleanup, updater GUID, type distribution, version parity, version matrix — so a rule that stops holding fails by name instead of passing unnoticed |
| A gate that reads the whole tree reads its own fixtures | An integrity check over every file will also read the test that proves it works, so a fixture spelled out in full becomes a finding in the file whose job is to find findings | `Tests/MojibakeScan.Tests.ps1` assembles its damage samples from the code point at run time rather than writing them out, so the sample reaching the scanner is real while the file on disk stays clean; the rule caught that file flagging itself before the samples were assembled, and the declaration was fixed rather than exempted |
| Pin against the upstream artifact, not against your own copy | A check whose oracle was written by the same hand as the subject agrees with itself and detects nothing | Policy conformance is verified against the vendor's own schema, so a drift the project could not have anticipated still fails the build instead of passing on a hand-kept list |
| The gate that runs before CI runs the checks CI runs | A local approximation of a workflow is a run that can disagree with it, and the disagreement is only discovered after the push | `Scripts/Invoke-CI.ps1` executes the seven checks `.github/workflows/quality.yml` declares and `Tests/CI-Parity.Tests.ps1` fails when the two lists diverge in either direction, so a job added to the workflow and a check dropped from the gate both fail the build by name rather than one of them quietly disappearing |
| Work inside the project, on a cadence you own | An assistant's scratch files belong to the project's own working tree, which version control does not track, and not to a system directory that something else empties on a timer | A file created for one task is removed when the task ends and the working tree as a whole is cleared on a defined cadence, because a scratch path emptied on a schedule you do not control can disappear between two steps of the same task, and because a scratch file left where a reviewer will find it has to be recognised as disposable before anyone can trust the tree |
| A local-only layer announces itself to tooling, not only to Git | An ignore rule is read by exactly one program; a migration, sync, backup or publish tool walks the filesystem instead, so an ignore rule alone leaves the layer visible to every tool that has never heard of this repository's rules | The root of every directory Git ignores as a whole carries a `._dont_migrate_` file, so a tool that walks the tree skips the layer without having to understand the ignore rules; the marker is placed only in ignored directories, because a tracked directory carrying one would tell the same tooling to skip the product, and the check reads both directions so a misplaced marker cannot pass as either present or absent |

A quiet total is good news: a well-ordered system runs without complaints — but silence never justifies skipping scheduled maintenance; it only means the defined cadence is working.

#### Communication style

- Natural and conversational; use humor where appropriate.
- Clear and direct; do not soften answers or add unnecessary politeness.
- Empathetic; consider the user's needs and perspective.
- Forward-looking; weigh long-term effects, not only the immediate problem.
- Humble; do not overstate what you know.
- Share opinions; if you hold a strong view, state it clearly.
- Follow the human's primary language in conversation and keep language integrity — no needless mid-reply switching; prefer common native terms over imported jargon.
- Mentor, don't belittle: never hold a person down for an experience they had no opportunity to have — expertise must not become an instrument of arrogance. Draw the line between inexperience and neglect with objective preconditions rather than opinion: if the required knowledge, training, written procedures, and tools were all supplied and the shortfall is still there, it is neglect and accountability applies; if the structure withheld that opportunity, it is not a defect but a learning process, and it is resolved by guidance rather than by blame.

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
- Self-review closes the chain: the Evaluate stage is also an individual self-check whose result is what institutional memory banks, so a cycle cannot be declared finished on delivery alone.
- Institutional memory: lessons from completed cycles (fixes, decisions, outcomes) are banked as documentation and fed back into the next Define/Design stage — the system keeps optimizing itself.
- Estimates are hypotheses, not commitments: a plan records what it predicted alongside what actually happened, because a forecast that misses in both directions teaches more than one that lands. A rejected proposal must not reappear silently in the next plan, and the next estimate is recomputed from the canonical data source rather than from the previous estimate.
- Knowledge cycle: identify the need, acquire the information, process it into value, distribute it, then act as one.

#### Communication signals

| Signal | Response |
|--------|----------|
| "Continue if you have next steps" | Evaluate and apply the next steps |
| "Stop and ask for clarification" | Ask when unsure; never guess |
| Short imperative ("do X") | Apply directly; do not wait for approval |
| Conditional instruction ("while doing X, also ...") | Honor every condition; skip none |
| "Don't hesitate" — create/read files freely | Permission-free proactivity — Create and read files as needed without waiting for approval |
| "Don't hesitate to create a document" | Documentation is proactive work, not overstepping — Create and extend documents without asking, following the structure, naming, and numbering already in use |
| "What did you do?" / "I told you before" | Recall check for a prior instruction — Recheck history, notice the omission, and correct it immediately — apologize by fixing, not by wording |
| "Write it so I can understand it while reading" / "use a better wording" | Raw phrasing must be stored in processed form — Record and present the user's words analyzed and structured, not verbatim |

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

```text
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

```text
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
- No usernames, passwords, API keys, IP addresses, or license keys in messages, diffs, or file contents. The one carve-out is a file whose entire purpose is to name an identity — a `CODEOWNERS` handle, a maintainer contact — because such a file cannot do its job anonymously; it is narrowed to that single value, never widened into commit messages, logs, or prose.
- If previously committed sensitive data is found, inform the user and suggest tools like BFG Repo-Cleaner.

#### File naming

All committed file and directory names are English:
- Directories: English, initial capital, separated by `-`/`_`; abbreviations in full capitals.
- Source files: snake_case or PascalCase per language.
- Documentation: file names are HyphenatedPascalCase (`Policy-Catalog.md`); titles are English sentences.
- Root files: UPPER, with `_` or `-` joining compounds (`CODE_OF_CONDUCT.md`, `RELEASE-NOTE-TEMPLATE.md`). Both separators are allowed because the platform fixes these names and does not agree on one; the casing is the part this repository owns.
- No committed path contains whitespace. A space has to be quoted in every reference, and a path that needs quoting is a path that will eventually be referenced unquoted. This is not a style preference: a space in a directory name has already broken a CI path in this repository, and the fix was recorded in the changelog as a bug.
- Exception: standard language codes (`tr.json`, `en.json`).

A directory name is PascalCase, and so is a file name. A name that departs
from this is a defect until its exemption is recorded here, and it applies to
everything the project creates - tracked or untracked, in a scratch directory
as much as in a shipped one - because a name that is correct only where a
human is watching is not a convention. A directory name stays lowercase only
when a tool, platform, or ecosystem convention fixes it there, and the
exemption is recorded here rather than left implicit. There are two:
`.github/` and everything under it
(`.github/workflows`, `.github/ISSUE_TEMPLATE`, `.github/linters`), because
GitHub resolves those paths case-sensitively, and `.opencode/`, because OpenCode
reads its project configuration from that exact path and nowhere else. Both are
paths a tool looks up, so neither is a style choice available to this
repository. The template and automation
directories were lowercase for a while, on the argument that the vendor and the
mainstream toolchains spell them that way, and both are now capitalised. A
vendor's _format_ name and an ecosystem's _habit_ are not a platform
constraint: GitHub does not resolve its template directory lowercase, npm
does not put that directory in lowercase, and a capitalised `ADMX/` opens
in exactly the same tools.

An abbreviation is written in capitals, and a capitalised word that follows
one is separated from it with a hyphen: `JS-Check`, not `JsCheck` and not
`Js-Check`. A trailing abbreviation takes no hyphen, so `CheckJS.py` is
already right. The file extension is outside the rule, because an extension
is the vendor's spelling rather than this repository's to change - the same
reason `index.html` keeps its name - and `Tests/FileNaming.Tests.ps1`
enforces the rule against a declared list of spellings, reading the stem
only.

The untracked root reference folder is `Docs/`, which `.gitignore` anchors to
the repository root as `/Docs/`. The anchor is scoped to that one path on
purpose: a bare `Docs/` pattern matches at every depth and would swallow the
committed product documentation that ships as `Brave-Omega/Docs/`. A tracking
exemption is granted to one named path, not to a spelling wherever it happens
to appear, and the committed documentation is held to the
capitalised-directory rule like any other tracked path.

File names are the same principle. A directory carries one convention, and the
exceptions are named rather than implied:

| Directory | Convention | Named exceptions |
|-----------|------------|------------------|
| `Brave-Omega/Docs/` | HyphenatedPascalCase (`Policy-Catalog.md`) | none |
| `Wiki/` | HyphenatedPascalCase (`Release-Notes.md`) | `_Footer.md`, `_Sidebar.md` - GitHub's wiki renderer looks for exactly these names |
| `Scripts/` | PascalCase (`Release.ps1`) | none - the four kebab-case files were renamed with the directory they lived in |
| `Tests/` | PascalCase (`MirrorSync.Tests.ps1`) | none |
| `ADMX/` | tracks the vendor's file extension (`Brave.admx`, `Brave.adml`) | `ADMX-Validate.ps1` is this repository's own script, not a vendor file |
| `.github/` | platform-fixed | file names are chosen by GitHub, not by this repository |

Two kinds of name sit outside every convention above, because something outside
this repository reads them. A data contract is a name its readers depend on, and
a vendor or platform name is a name its tool looks up. `index.html` is the
first kind: the landing page's filename is read by the deployment that serves
it, so a copy of that page inside a working directory keeps the same name
instead of becoming a second spelling to rename. Neither is free to follow
a house style, so both are declared in the naming test together with the reason
they are exempt. They are checked against the name Git records, not against the
working tree: a case-folding filesystem will happily resolve `Config.json` when
asked for `config.json`, so a lookup made through the filesystem cannot enforce
this rule and a contract that a check cannot see is a contract that quietly rots.
The check asserts the count of matching tracked paths before it asserts the
spelling, because a case-only duplicate is a duplicate whether the disk is able
to show it or not.

A rename is finished when only one spelling is left. The retired spelling is
recorded as a mapping from the old name to the new one, and a guard reports any
live file that still names the old one: a stale reference keeps reading
perfectly well and simply stops resolving, which is exactly why it survives
review and breaks later. The mapping stores the old name without its separator
and assembles the pattern from it, so the file that declares the rule does not
report itself as its first offence. A guard that also passes when every
reference has been deleted proves nothing, so the current spelling is asserted
to be present too.

A name that is merely _conventional_ is not enough on its own to justify a
lowercase directory, and a rename is a single logical change: the directory
moves, every path that names it moves with it in the same commit, and a
reference left behind is a defect rather than a follow-up. Historical records -
the changelog, the version-compatibility tables, per-version release notes - are
excluded: they describe the repository as it stood at that version, so rewriting
a path inside them would falsify the record instead of updating it. The
exemption is scoped rather than blanket - granted per file, or per line region
carrying a recognisable marker - because a file that mixes live content with a
changelog is the normal case, not the awkward one, and a whole-file exemption
would silence the live half along with the historical half. A guard checks that
each declared marker is still present: an exemption nobody can check is an
exemption nobody will notice has rotted.

`Tests/FileNaming.Tests.ps1` enforces this section, so a new file that arrives
in a second style fails by name instead of drifting quietly. Every guard in it
was checked by planting the violation it exists to catch and confirming that the
named test fails, because a check which has never been seen to fail is not known
to work - it is only known not to have been tried. It is written
against a Turkish-locale Windows host, and that shapes how it tests: a case
range such as `[A-Z]` is matched with `-cmatch`, never `-match`, because
PowerShell folds the range through the current culture and a Turkish locale puts
`I` outside `[A-Z]`. The same case-sensitivity applies to every path
comparison in the test, and existence is checked against the name Git records
rather than with `Test-Path`, which is case-insensitive on Windows and would
report a lowercase spelling as present when only the capitalised directory
exists.
A rule that reads tracked names has the mirror-image limit: it cannot see a file
the working tree holds but version control has not been told about, so a suite
run over a newly written file passes on that file by default and the same file
can fail once it is committed. The rule is blind to a file in precisely the state
where its content is still being changed, so a pass is read as evidence about
that file only after it has been staged and the suite re-run.

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
- **Hidden/guidance layers.** Local guidance and customization layers that must not mix into the live codebase are protected four ways: excluded in `.gitignore`, marked with a `._dont_migrate_` file so build/deploy tooling skips them, never referenced from committed output beyond `.gitignore` patterns, and never named or quoted in any other output — their existence and content stay inside the layer, the single exception being work the user explicitly directs inside that layer. This last protection is absolute: a private layer that leaks through a code comment, a doc, a commit message, or a chat reply is broken, however well-intentioned the mention.
- **Layer marker placement.** The marker is mandatory at the root of every directory Git ignores as a whole, and forbidden everywhere else. A layer root is the ignored directory whose parent is not ignored, because that is the point at which a tool walking the tree decides to stop; a directory nested inside one is already covered by the marker above it, and a marker at every depth would only repeat what its parent already says. A layer is recognised mechanically rather than by a hand-kept list: `.gitignore` states it by anchoring the pattern to the repository root (`/Docs/`) or by prefixing it with `**/` (`**/Intelligence/`), so those two shapes name the layers the project deliberately created and the generic build-output patterns beside them — `node_modules/`, `coverage/`, `Backup/` — do not carry the obligation. `.idea/` is excluded by reason rather than by shape: it holds editor state the IDE rewrites on its own, not content this project routes there. The marker is deliberately re-included by a `!._dont_migrate_` rule rather than ignored, because `._*` already matches the name at every depth and would otherwise make a misplaced copy invisible to `git status` — the one place where the rule forbidding it has to be noticed. Inside a layer the directory rule keeps it ignored regardless, so the re-inclusion costs nothing there. `Tests/LayerMarkers.Tests.ps1` reads the filesystem in both directions to keep the placement honest. The agent's own working directory is named here once and nowhere else: `Agent-Scratch/`, root-anchored in `.gitignore` with the marker at its root; scratch is removed when the task ends and the tree is cleared on a defined cadence. The single mechanical exception to the no-naming rule is `Scripts/Release.ps1`, which stages the release package it uploads inside this directory and names the directory only, never a file within it.
- **Layered references.** Reference material is layered by stability: universal/standard references update only when the authoritative standard behind them changes; project-specific guidance gets a project layer of its own — project overrides never rewrite the universal reference. Updates flow top-down only on a real change in the underlying standard.
- **Layer dependency direction.** Hidden guidance layers are not a flat folder: dependencies run one way, from the most personal and least stable layer toward the most universal and most stable one. A universal reference never depends on personal context, and content is never copied back down. Content abstracted out of a personal layer is generalised into the universal layer and the original is then removed rather than kept in step, so the universal layer stays publishable while the personal layer stays private. That universal layer is `AGENTS.md` itself, so a separate general-reference layer is not kept alongside it.
- **Layer onboarding order.** An assistant entering a project reads the hidden layers in a fixed order before it changes anything: personal context first, so the person and the working environment are understood; then working method and behaviour rules; then the project layer, which is the only layer the work itself writes into. Reading completes before scaffolding starts, and the project's own structure is read alongside the universal standard, never in place of it.
- **Single ownership.** Every rule has exactly one canonical owner document. Everywhere else it appears as a pointer, never as a copy: a duplicated rule drifts from its source and then contradicts it. When the canonical text changes, the pointers are refreshed, not the copies that were never meant to hold it.
- **One ignore pattern per hidden layer tree.** A single root `.gitignore` pattern covering the whole hidden-layer directory is preferred over one pattern per layer, because the per-layer list is a checklist that can silently forget a new layer; per-layer ignore files are therefore not created. The pattern is never deleted or commented out, and it is the first thing written when such a project is set up.
- **New-repository checklist.** The bootstrap order is the rule, not a suggestion: the ignore file comes first so nothing private can be swept into the first commit, then the root documents, then the landing page, then the hidden layers, and only then version control. Concretely:
  - [ ] `.gitignore` written first, with the hidden layers already named in it?
  - [ ] Root documents added: `README.md`, `SECURITY.md`, `CHANGELOG.md`, `LICENSE`, `NOTICE`, `CODE_OF_CONDUCT.md`, `SUPPORT.md`?
  - [ ] Landing page added?
  - [ ] Hidden layers created from the universal layer downward, never the reverse, each one covered by the single root ignore pattern?
  - [ ] `.github/dependabot.yml` configured?
  - [ ] `.github/workflows/codeql.yml` added?
  - [ ] Auto-approve workflow added?
  - [ ] Workflows for recurring git operations written?
  - [ ] `.github/pull_request_template.md`, `RELEASE-NOTE-TEMPLATE.md` and `CODEOWNERS` added?
  - [ ] Repository housekeeping added: `.editorconfig`, `.gitattributes`, and a second CI config when the origin is a dual pushurl?
  - [ ] A log file the workflow itself keeps current created?
  - [ ] Repository initialised last, with a first commit that names what the skeleton created?
- **Standard workflow triggers.** Test on `push` / `pull_request` (unit tests, lint, type check); Build on `push` to `main`; Release on tag `v*`; CodeQL on push and weekly; Dependabot on a weekly cadence.
- **Machine-maintained logs.** Recurring git and audit events (dependency updates, PR journals, version checks) are logged by the workflow itself via API — never by hand; human intervention is not required.

### Conventions

- **Bilingual docs.** User-facing `.md` files follow the EN-first + TR-mirror
  pattern (see CONTRIBUTING.md). Keep headings, anchors, and badges consistent.
- **Documentation structure.** Every project keeps a `Docs/` folder whose
  chapters cover overview/setup, architecture, API (when applicable),
  troubleshooting, and a changelog only when the project keeps no changelog at
  its root; a `PLANNING/` subfolder under it holds work plans and task
  tracking, managed by the AI assistant as it goes. The changelog is a single
  file in a single place: once a root `CHANGELOG.md` exists, the folder gains no
  changelog chapter and a second independent log is never created.
- **A document nobody links to is a document that does not exist.** A root file
  with no inbound link from the landing page is unreachable, whatever its
  content quality, so the landing page links every root document: license,
  notice, code of conduct, support, privacy, security, contributing, changelog
  and the release-note template. Reachability is checked, not assumed.
- **Derived documentation output.** Anything that republishes canonical content
  for a separate surface (a synced wiki page, a site page, a release body) is a
  published projection, not a second source. It is generated or workflow-synced
  from its owner, never maintained by hand in parallel, and it never outranks the
  source it was derived from.
- **Documentation mirrors code.** Any meaningful change (component, dependency,
  configuration, architecture decision, test setup) updates the affected
  documentation in the same commit. The update is reported, not approved; a
  document that contradicts the code is a defect, not a backlog item.
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
  (`Brave-Omega/config.json` + `Brave-Omega/Profiles/*.json`; loaded at runtime
  via `Import-OmegaPolicyData` into `$OmegaState`). Deprecated policies must be
  removed from the profile files — the ADMX validator (`ADMX-Validate.ps1`)
  enforces the cross-reference.
- **Version bumps.** Add an entry to the single canonical changelog (root
  `CHANGELOG.md` in this repo, with `Wiki/Changelog.md` as its workflow-synced
  projection),
  bump `$ScriptVersion` / `$ValidatedBrave` / `$ValidatedChromium`, then update
  the hand-maintained "Validated on" header in
  `Brave-Omega/Docs/Policy-Catalog.md`, README §8,
  `index.html` (hero, prerequisites, compat rows), and the Wiki pages. The
  changelog follows the Keep a Changelog format (Added / Changed / Deprecated /
  Removed / Fixed / Security) under SemVer headings, newest first.
- **Release parity.** GitHub and GitLab releases mirror each other exactly —
  same tag, title, description, and notes. Release notes are bilingual:
  EN paragraph first, TR paragraph after, at equal scope, detail, and quality.
- **Compatibility.** The script targets Windows PowerShell 5.1+; no `pwsh`-only syntax.
- **Git.** `origin` pushes to both GitHub and GitLab (dual pushurl). Keep the two
  remotes in parity — there is no PR/MR workflow for own commits. A dual remote
  is also a dual gate: the second host carries its own CI enforcing the same
  checks, because a rule enforced on one host only is enforced nowhere the
  project actually lives.
- **GitHub ruleset (`Protect main`).** The `main` branch ruleset nominally
  requires a pull request, and that requirement is deliberately bypassed rather
  than satisfied. A repository owner is listed as a bypass actor with
  `bypass_mode: always`, so a direct push to `main` is admitted and the ruleset
  is not enforced on it; the seven required status checks therefore run
  _after_ the push rather than gating it. This is the accepted cost of the
  no-PR workflow above, not an oversight: the checks still run, and a failure is
  detected and fixed forward on the same branch instead of being caught before
  merge. The second host's CI is the independent gate, so a bypass on one remote
  is not an unenforced rule on the project. Removing the bypass is a decision to
  adopt a PR workflow, and it is deliberately not taken here.
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

- An untracked, gitignored Turkish mirror of this file is read by the human for
  auditing. It is never committed or pushed, and it is not named anywhere in
  committed output.
- **Rule:** whenever this file changes, refresh the mirror content, then re-run
  `Scripts/Verify-Mirror-Sync.ps1` and write the value it reports into the
  `sync-sha` marker of both files. The check is mechanical on purpose — a
  hand-remembered hash drifts silently the moment this file is edited twice
  without the mirror being revisited.
- `sync-sha` = SHA1 of this file, computed as: read the bytes, drop a UTF-8
  BOM if present, decode as UTF-8, normalize every CRLF and lone CR to LF,
  remove the whole `<!-- mirror-sync: ... -->` line including its terminator,
  then hash the UTF-8 encoding of what remains. Normalizing to LF is what makes
  a single value valid for a CRLF checkout, an LF checkout, and the committed
  blob alike, so the number never depends on how the file happened to be saved.
- The verifier also compares structure, not only the marker: the same number of
  sections, the same heading depth sequence, the same number of top-level rules
  under every section, the same number of code fences, the same number of
  table blocks, and the same action-checklist order.
- Heading detection skips fenced code, so a `#` comment or a list inside a
  sample is counted as neither a section nor a rule.
- Nested sub-items are reported but not compared. A translation is allowed to
  expand one rule into sub-bullets, so a difference there is information to
  read, not drift to fix.
- An ordered action checklist is the one nested list that tolerance does not
  cover, because a checklist is a sequence of steps rather than prose: a lost
  step is a lost instruction, not a rendering choice. Each item is reduced to
  the first backticked token it carries, and that sequence is compared in
  order. Both files therefore name a checklist item's target the same way — a
  backticked path — and dropping the token on one side is a contract violation
  the check reports rather than a translation it tolerates. Rewording, or
  reordering tokens inside a single item, is still tolerated.
- Tables are compared as blocks, not row by row. Splitting one English rule
  across two Turkish rows is a granularity difference, not a lost rule.
- Structure cannot prove meaning. A passing run proves the two files are the
  same shape and declare the same value; the wording still needs a human read.
- `Tests/MirrorSync.Tests.ps1` pins this behavior down with fixtures: a clean
  pair, a CRLF mirror, each class of drift, the tolerated granularity, an
  ordered checklist that keeps, loses, reorders and drops an anchor, and a
  mirror that is absent.
- The verifier takes both paths as parameters and names neither, so nothing
  about this layer's location is recorded in committed output. Pass
  `-AllowMissingMirror` where the mirror is intentionally absent, such as CI.
- A mismatch means drift. Fix it by refreshing the mirror, then setting the
  reported value in both markers; never by editing one marker to match the
  other.

<!-- mirror-sync: sync-sha=510ca38a4f37d62b64ac8453bad9ea81d5fcda00 -->
### Project Root Files and Dotfiles Reference

**Core principle:** A file starting with `.` is not automatically "private"; some are recognized by tools, others are only conventions. The meaning of a "special" file is determined by the software that reads it.

#### Terms

| Term | Definition |
|------|------------|
| Dotfile | A file whose name begins with `.` |
| Config file | A project/tool configuration file |
| Metadata file | A file carrying information about the project or a tool |
| Marker file | A file whose presence signals a specific behavior |
| Sentinel file | A marker file that indicates a special state/operation |
| Lock file | A file that pins dependencies or the resolution of versions |

#### Git

| File/Directory | Purpose |
|---------------|---------|
| `.git/` | The internal structure of the Git repository |
| `.gitignore` | Specifies files/directories that Git must not track |
| `.gitattributes` | Defines how Git treats specific files (line endings, diff, merge) |
| `.gitmodules` | Defines Git submodules |
| `.gitmailmap` | Maps author/contributor names/emails |
| `.gitkeep` | Convention used to keep an otherwise empty directory tracked |
| `.git/info/exclude` | Local-only (non-committed) exclusion rules |

#### GitHub / Project Governance

| File/Directory | Purpose |
|---------------|---------|
| `.github/` | GitHub configuration |
| `.github/workflows/` | GitHub Actions workflows |
| `.github/ISSUE_TEMPLATE/` | Issue and feature forms presented when a user opens a new issue |
| `.github/dependabot.yml` | Automated dependency update schedule |
| `.github/pull_request_template.md` | Checklist rendered when a contributor opens a pull request |
| `.github/linters/` | Shared linter configuration consumed by CI jobs |
| `.github/FUNDING.yml` | Sponsors/funding links shown by GitHub |
| `.opencode/` | Project configuration OpenCode reads at startup; the runtime half of this repository's rules |
| `CODEOWNERS` | Defines code owners |
| `AGENTS.md` | Operating rules and conventions for humans and coding agents |
| `README.md` | Introduces the project |
| `LICENSE`, `LICENCE` | License terms |
| `NOTICE` | Third-party attribution and trademark notices |
| `CONTRIBUTING.md` | Contribution guidelines |
| `CODE_OF_CONDUCT.md` | Code of conduct |
| `SECURITY.md` | Security reporting process |
| `SUPPORT.md` | Where to ask questions and how to report an issue |
| `PRIVACY.md` | What the project collects, stores, and transmits |
| `CHANGELOG.md` | Version history / changes |
| `RELEASE-NOTE-TEMPLATE.md` | Skeleton that release notes follow |

#### General Configuration / Development

| File/Directory | Purpose |
|---------------|---------|
| `.editorconfig` | Editor formatting/behavior rules |
| `index.html` | Single-page landing page (project site root, deployed by GitHub Pages) |
| `.vscode/` | VS Code project settings |
| `.idea/` | JetBrains IDE settings |
| `.devcontainer/` | Dev Container configuration |
| `.env` | Environment variables (never committed) |
| `.env.example` | Example environment configuration (placeholders only) |

#### Containers

| File/Directory | Purpose |
|---------------|---------|
| `Dockerfile` | Docker image definition |
| `.dockerignore` | Exclusions for Docker build context |
| `compose.yml` | Docker Compose definition |

#### CI/CD

| File/Directory | Purpose |
|---------------|---------|
| `.gitlab-ci.yml` | GitLab CI/CD |
| `Jenkinsfile` | Jenkins pipeline |
| `azure-pipelines.yml` | Azure DevOps pipelines |
| `.circleci/config.yml` | CircleCI configuration |
| `.buildkite/` | Buildkite configuration |

#### Node.js / JavaScript

| File/Directory | Purpose |
|---------------|---------|
| `package.json` | Project metadata and dependencies |
| `package-lock.json` | Pins npm dependencies |
| `.npmrc` | npm configuration |
| `.npmignore` | Exclusions for npm publishing |
| `yarn.lock` | Yarn dependency lock |
| `pnpm-lock.yaml` | pnpm dependency lock |
| `bun.lock` | Bun dependency lock |
| `.nvmrc` | Node.js version pin |
| `.eslintrc*` | ESLint configuration |
| `.prettierrc*` | Prettier configuration |

#### Python

| File/Directory | Purpose |
|---------------|---------|
| `pyproject.toml` | Project/tool configuration (PEP 621 and tooling) |
| `requirements.txt` | Dependency list |
| `requirements-dev.txt` | Development dependencies |
| `Pipfile`, `Pipfile.lock` | Pipenv configuration/lock |
| `poetry.lock` | Poetry lock |
| `uv.lock` | uv lock |
| `.python-version` | Python version pin |
| `.flake8` | Flake8 configuration |
| `.mypy.ini` | mypy configuration |
| `pytest.ini` | pytest configuration |

#### Java / JVM

| File/Directory | Purpose |
|---------------|---------|
| `pom.xml` | Maven project configuration |
| `build.gradle` | Gradle build script |
| `build.gradle.kts` | Gradle Kotlin DSL build script |
| `settings.gradle*` | Gradle project settings |
| `gradlew`, `gradlew.bat` | Gradle Wrapper |
| `.mvn/` | Maven configuration |
| `.gradle/` | Gradle local/cache data |

#### .NET

| File/Directory | Purpose |
|---------------|---------|
| `*.sln` | Visual Studio solution |
| `*.csproj` | C# project |
| `*.fsproj` | F# project |
| `*.vbproj` | VB.NET project |
| `global.json` | .NET SDK version pin |
| `NuGet.config` | NuGet configuration |
| `Directory.Build.props` | Shared MSBuild properties |
| `Directory.Build.targets` | Shared MSBuild targets |

#### Rust

| File/Directory | Purpose |
|---------------|---------|
| `Cargo.toml` | Project and dependency definition |
| `Cargo.lock` | Dependency lock |
| `rust-toolchain*` | Rust toolchain specification |
| `.rustfmt.toml` | rustfmt configuration |
| `.cargo/` | Cargo configuration |

#### Go

| File/Directory | Purpose |
|---------------|---------|
| `go.mod` | Go module definition |
| `go.sum` | Dependency checksums/lock |
| `go.work` | Go workspace (multi-module) |
| `.golangci.yml` | golangci-lint configuration |
| `.go-version` | Go version pin |

#### Version / Tool Version Managers

| File/Directory | Purpose |
|---------------|---------|
| `.nvmrc`, `.node-version` | Node.js version |
| `.python-version` | Python version |
| `.ruby-version` | Ruby version |
| `.go-version` | Go version |
| `.java-version` | Java version |
| `.tool-versions` | Multi-tool version specification (asdf) |

#### Code Quality / Formatting

| File/Directory | Purpose |
|---------------|---------|
| `.prettierrc*` | Prettier configuration |
| `.eslintrc*` | ESLint configuration |
| `.stylelintrc*` | Stylelint configuration |
| `.clang-format` | C/C++ formatting |
| `.clang-tidy` | C/C++ static analysis |
| `.editorconfig` | Shared editor rules |

#### Build / Cache / Local Output

| File/Directory | Purpose |
|---------------|---------|
| `build/` | Build outputs |
| `dist/` | Distribution outputs |
| `target/` | Build outputs (Rust/Maven/other) |
| `out/` | Build outputs |
| `node_modules/` | Node.js dependencies |
| `__pycache__/` | Python bytecode cache |
| `.pytest_cache/` | pytest cache |
| `.mypy_cache/` | mypy cache |
| `coverage/` | Test coverage output |

#### OS / Temporary Files

| File/Directory | Purpose |
|---------------|---------|
| `.DS_Store` | macOS Finder metadata |
| `Thumbs.db` | Windows thumbnail cache |
| `desktop.ini` | Windows folder customization |
| `*.swp`, `*.swo` | Vim swap files |
| `*~` | Common editor backup files |

#### Marker / Sentinel Files

| File/Directory | Purpose |
|---------------|---------|
| `.gitkeep` | Convention to keep an empty directory tracked (not a Git standard) |
| `.keep` | Directory/object preservation marker |
| `.nomigrate`, `.no-migrate` | Prevent migration/tool processing |
| `._dont_migrate_` | This repository's marker for a local-only layer; tooling that reads it skips the directory |
| `.skip` | Tool-specific skip marker |
| `.disabled` | Tool-specific disable marker |
| `.lock` | Tool-specific lock/process marker |

#### Key Distinctions

- `.gitignore` — tells Git **what to ignore** (tracking).
- `.gitattributes` — tells Git **how to treat files** (line endings, diff, merge).
- `.gitkeep` — **not a Git standard**; it is a **convention** to keep empty directories tracked.
- `._dont_migrate_` — **not a Git standard and not read by Git at all**; it is the signal a tool receives from walking the tree, and it carries meaning **only if the reader interprets it**.
- `.git/` — the **internal Git repository structure**, not a project config file.

**Guiding rule:** "It looks special" ≠ "It is a standard special file." The meaning of any file is determined by the software that reads and interprets it.
