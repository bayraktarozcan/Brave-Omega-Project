<#
.SYNOPSIS
    Runs every check the Quality workflow runs, on this machine, before a push.

.DESCRIPTION
    A green local test run is not proof that the workflow will be green. The
    workflow checks more than the suite: it lints markdown and YAML, parses
    every script, analyses the unified script, validates the policy
    cross-references, and scans the tree for encoding damage. A change can
    pass all of those locally and still fail on a runner for a reason no local
    command reproduces - a runner checks out a different depth of history, a
    tool resolves differently, an encoding is interpreted differently.

    This gate exists so that reason is found here rather than on the remote.
    Every check declares the workflow job it stands in for, and
    Tests/CI-Parity.Tests.ps1 asserts that the declaration covers the workflow
    exactly, so a job added to the workflow without a counterpart here fails by
    name instead of quietly going unchecked.

    A tool that is not installed is reported as MISSING and fails the gate. It
    is a real blind spot, and a gate that reports itself green while skipping
    half its work is the thing this script exists to prevent. -AllowMissingTools
    downgrades that one state to a warning, for a machine that accepts the gap
    deliberately.

.PARAMETER InstallHook
    Writes a pre-push hook that runs this gate, so a push cannot leave the
    machine without the checks. Overwrites an existing pre-push hook only after
    reporting it, and backs the previous one up beside it.

.PARAMETER AllowMissingTools
    Report an absent tool as a warning instead of a failure. Use it only where
    the absence is a decision rather than an oversight.

.EXAMPLE
    & Scripts/Invoke-CI.ps1

.EXAMPLE
    & Scripts/Invoke-CI.ps1 -InstallHook
#>
[CmdletBinding()]
param(
    [switch]$InstallHook,
    [switch]$AllowMissingTools
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:RepoRoot = Split-Path -Parent $PSScriptRoot
$script:Results = New-Object System.Collections.Generic.List[object]

# The workflow job each check stands in for. Order matches the workflow.
$script:JobIds = @(
    'markdown-lint',
    'yaml-validate',
    'powershell-syntax',
    'pester-tests',
    'ps-script-analyzer',
    'policy-integrity',
    'utf8-integrity',
    'json-validity',
    'shellcheck'
)

function Write-Stage {
    param([string]$Text)
    Write-Host "-- $Text" -ForegroundColor DarkGray
}

function Invoke-WithoutGatePolicy {
    <#
        Runs code this script does not own - Pester, the policy validator - with
        the gate's own caller-scope policies released, and restores them after.

        Both strict mode and $ErrorActionPreference are scoped, and a child scope
        inherits them, so leaving them in force while calling another script
        imposes this gate's assumptions on code that was never written for them.
        Pester reported thirty-five failures under strict mode and fourteen more
        under a promoting error preference that do not exist on their own, and
        the policy validator aborted on a property access that is valid outside
        strict mode. The gate holds itself to the stricter rule and stops
        asserting it of its callees.

        Output is returned rather than assigned, because the callee runs in a
        child scope: a variable set inside the block would not reach the caller,
        and a value whose scope was wrong would read as an empty result rather
        than as an error.
    #>
    param([Parameter(Mandatory)][scriptblock]$Action)

    $strict = $ErrorActionPreference
    Set-StrictMode -Off
    $ErrorActionPreference = 'Continue'
    try {
        & $Action
    } finally {
        $ErrorActionPreference = $strict
        Set-StrictMode -Version Latest
    }
}

function Add-GateResult {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$State,
        [string]$Detail = ''
    )
    $script:Results.Add([pscustomobject]@{ Name = $Name; State = $State; Detail = $Detail })
    $color = switch ($State) {
        'PASS' { 'Green' }
        'WARN' { 'Yellow' }
        default { 'Red' }
    }
    if ($Detail) {
        Write-Host ("   {0,-4} {1}  {2}" -f $State, $Name, $Detail) -ForegroundColor $color
    } else {
        Write-Host ("   {0,-4} {1}" -f $State, $Name) -ForegroundColor $color
    }
}

function Get-NativeCommand {
    <#
        Resolves a command by running it, not by finding it: on Windows a Store
        stub named python3.exe resolves through Get-Command and then exits with
        "Python was not found", which would report a tool as present and then
        fail every check that uses it.
    #>
    param([Parameter(Mandatory)][string[]]$Name)

    foreach ($candidate in $Name) {
        $cmd = Get-Command $candidate -ErrorAction SilentlyContinue
        if (-not $cmd) { continue }
        if ($candidate -eq 'python3' -or $candidate -eq 'python') {
            # The Store stub prints "Python was not found" and exits non-zero, so
            # it has to be probed by running it, and the probe has to be allowed
            # to fail: under the gate's promoting error preference the stub's
            # stderr would abort the gate instead of being rejected as a tool.
            $strict = $ErrorActionPreference
            $ErrorActionPreference = 'Continue'
            $global:LASTEXITCODE = 0
            try {
                & $cmd.Source --version 2>$null | Out-Null
                $probe = $global:LASTEXITCODE
            } catch {
                $probe = -1
            } finally {
                $ErrorActionPreference = $strict
            }
            if ($probe -eq 0) { return $cmd.Source }
        } else {
            return $cmd.Source
        }
    }
    return $null
}

function Get-PythonCommand {
    <#
        Resolves a runnable Python 3 as an argv array, because the Windows
        `py` launcher needs a `-3` prefix the bare binaries do not take.
        Every candidate is RUN, not merely found: a broken App-alias stub
        resolves through Get-Command and then fails to start, which would
        report a tool as present and fail every check that uses it.
        Callers split exe from prefix (`$exe = $p[0]`) because splatting
        never supplies the command itself, only its arguments.
    #>
    $direct = Get-NativeCommand -Name @('python3', 'python')
    if ($direct) { return @($direct) }
    $launcher = Get-Command py -ErrorAction SilentlyContinue
    if ($launcher) {
        $strict = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        try {
            & $launcher.Source -3 --version 2>$null | Out-Null
            if ($LASTEXITCODE -eq 0) { return @($launcher.Source, '-3') }
        } catch { }
        finally { $ErrorActionPreference = $strict }
    }
    return $null
}

function Get-TrackedMarkdownFiles {
    <#
        The Markdown files this repository owns, as Git records them.

        Git is the oracle rather than a directory walk because the question is
        ownership, not existence: a file that is present but untracked is not
        this project's to lint, and a directory walk cannot tell the two apart.
        Reading the record instead of the disk also means the answer does not
        depend on which tree the gate happens to run against.
    #>
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $files = @(git -C $script:RepoRoot ls-files '*.md' 2>$null)
    } catch {
        $files = @()
    } finally {
        $ErrorActionPreference = $previous
    }
    # ls-files prints one path per line; a path may hold a space, so the record
    # is taken whole rather than split.
    @($files | Where-Object { $_ -and $_.Trim() })
}

function Invoke-ToolCheck {
    <#
        Runs an external linter. Reports MISSING rather than failing obscurely
        when the tool is absent, so the gap is named instead of guessed at.
    #>
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string[]]$Candidate,
        [Parameter(Mandatory)][string[]]$ArgumentList
    )

    $tool = Get-NativeCommand -Name $Candidate
    if (-not $tool) {
        $state = if ($AllowMissingTools) { 'WARN' } else { 'FAIL' }
        Add-GateResult -Name $Name -State $state -Detail "not installed: $($Candidate -join ', ')"
        return
    }

    Push-Location $script:RepoRoot
    # A native command's stderr becomes error records, and under
    # ErrorActionPreference Stop the first of them aborts the gate before the
    # exit code is ever read - so a lint finding would look like a crash in the
    # gate rather than a finding the gate reports.
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $global:LASTEXITCODE = 0
    try {
        $output = & $tool @ArgumentList 2>&1
        $code = $global:LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previous
        Pop-Location
    }

    if ($code -eq 0) {
        Add-GateResult -Name $Name -State 'PASS'
        return
    }
    $first = @($output | Select-Object -First 5) -join ' / '
    Add-GateResult -Name $Name -State 'FAIL' -Detail "exit $code : $first"
}

function Invoke-MarkdownCheck {
    Write-Stage 'Lint Markdown'
    # The long flag, not -c. markdownlint-cli2 accepts -c without complaint and
    # then lints with its own defaults instead of the repository configuration,
    # which reports the whole tree as broken on a clean checkout; classic
    # markdownlint accepts the long form as well, so one spelling serves both.
    #
    # The file list comes from Git rather than from a "**/*.md" glob. A glob
    # walks the working tree, and this working tree holds content that is not
    # this project's source: OpenCode installs its own plugin dependency under
    # .opencode/node_modules the first time it opens this repository, carrying
    # thousands of third-party Markdown files whose style this repository does
    # not own and cannot fix. Two tools disagree about which file ends the lint,
    # so an ignore file cannot express it: markdownlint-cli2 does not read
    # .markdownlintignore at all. Git is the oracle that already answers the
    # question the gate is asking - "is this file ours?" - and it answers it the
    # same way in CI, where the vendor tree simply is not present.
    $files = @(Get-TrackedMarkdownFiles)
    if (-not $files) {
        Add-GateResult -Name 'markdown-lint' -State 'FAIL' `
            -Detail 'no tracked Markdown file to lint; the file list is empty'
        return
    }
    Invoke-ToolCheck -Name 'markdown-lint' `
        -Candidate @('markdownlint-cli2', 'markdownlint') `
        -ArgumentList (@('--config', '.github/linters/.markdownlint.json') + $files)
}

function Invoke-YamlCheck {
    Write-Stage 'Validate YAML'
    Invoke-ToolCheck -Name 'yaml-validate' `
        -Candidate @('yamllint') `
        -ArgumentList @('.github/', '--config-file', '.github/linters/.yamllint.yml')
}

function Invoke-PowerShellSyntaxCheck {
    Write-Stage 'Check PowerShell syntax'
    # Vendor trees are skipped. OpenCode installs its own plugin dependency under
    # .opencode/node_modules the first time it opens this repository, and a
    # third-party script the Windows PowerShell parser dislikes would then fail a
    # gate on a file this project never wrote. Vendor content is not this
    # project's source, and it is not tracked either.
    $files = @(Get-ChildItem -Path $script:RepoRoot -Recurse -Filter '*.ps1' -File |
        Where-Object { $_.FullName -notmatch '[\\/]node_modules[\\/]' })
    $broken = @()
    foreach ($file in $files) {
        $parseErrors = $null
        $null = [System.Management.Automation.Language.Parser]::ParseFile(
            $file.FullName, [ref]$null, [ref]$parseErrors)
        if ($parseErrors) { $broken += "$($file.Name): $($parseErrors[0].Message)" }
    }
    if ($broken) {
        Add-GateResult -Name 'powershell-syntax' -State 'FAIL' `
            -Detail "$($broken.Count) of $($files.Count) files : $($broken[0])"
    } else {
        Add-GateResult -Name 'powershell-syntax' -State 'PASS' -Detail "$($files.Count) files"
    }
}

function Invoke-PesterCheck {
    Write-Stage 'Run Pester tests'
    Import-Module Pester -MinimumVersion 5.0 -ErrorAction Stop
    $config = New-PesterConfiguration
    $config.Run.Path = (Join-Path $script:RepoRoot 'Tests/')
    $config.Run.PassThru = $true
    $config.Output.Verbosity = 'None'
    $result = Invoke-WithoutGatePolicy { Invoke-Pester -Configuration $config }

    if ($result.FailedCount -gt 0) {
        $names = @($result.Failed | Select-Object -First 3 | ForEach-Object { $_.ExpandedPath }) -join ' ; '
        Add-GateResult -Name 'pester-tests' -State 'FAIL' `
            -Detail "$($result.FailedCount) failed of $($result.TotalCount) : $names"
    } else {
        Add-GateResult -Name 'pester-tests' -State 'PASS' `
            -Detail "$($result.PassedCount) passed, $($result.SkippedCount) skipped"
    }
}

function Invoke-AnalyzerCheck {
    Write-Stage 'PSScriptAnalyzer'
    if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
        $state = if ($AllowMissingTools) { 'WARN' } else { 'FAIL' }
        Add-GateResult -Name 'ps-script-analyzer' -State $state -Detail 'not installed'
        return
    }
    Import-Module PSScriptAnalyzer -ErrorAction Stop

    # ExcludeRule takes an array. A comma-joined string is silently accepted and
    # then ignored, so the run reports every rule the list was meant to drop.
    $excluded = @(
        'PSAvoidUsingWriteHost',
        'PSAvoidUsingEmptyCatchBlock',
        'PSUseSupportsShouldProcess',
        'PSUseShouldProcessForStateChangingFunctions'
    )
    $target = Join-Path $script:RepoRoot 'Brave-Omega/BraveOmega.ps1'
    $findings = @(Invoke-ScriptAnalyzer -Path $target -Severity Warning -ExcludeRule $excluded)

    if ($findings) {
        $first = $findings[0]
        Add-GateResult -Name 'ps-script-analyzer' -State 'FAIL' `
            -Detail "$($findings.Count) findings : L$($first.Line) $($first.RuleName)"
    } else {
        Add-GateResult -Name 'ps-script-analyzer' -State 'PASS'
    }
}

function Invoke-PolicyIntegrityCheck {
    Write-Stage 'Policy Integrity'
    $validator = Join-Path $script:RepoRoot 'ADMX/ADMX-Validate.ps1'
    Push-Location $script:RepoRoot
$previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $global:LASTEXITCODE = 0
    $transcript = ''
    # Write-Host bypasses the pipeline, so every stream is merged and only
    # surfaced when the validator actually fails.
    $code = Invoke-WithoutGatePolicy {
        $transcript = (& $validator *>&1 | Out-String)
        $global:LASTEXITCODE
    }
    if ($code -eq 0) {
        Add-GateResult -Name 'policy-integrity' -State 'PASS'
    } else {
        $tail = ($transcript -split "`r?`n" | Where-Object { $_.Trim() } | Select-Object -Last 3) -join ' | '
        Add-GateResult -Name 'policy-integrity' -State 'FAIL' -Detail "exit $code $tail"
    }
}

function Invoke-Utf8Check {
    Write-Stage 'UTF-8 / Mojibake Integrity'
    $python = Get-PythonCommand
    if (-not $python) {
        $state = if ($AllowMissingTools) { 'WARN' } else { 'FAIL' }
        Add-GateResult -Name 'utf8-integrity' -State $state -Detail 'not installed: python3, python, py'
        return
    }
    Push-Location $script:RepoRoot
    # Same guard as the other native calls: the scanner reports a finding on
    # stderr, and without this a real finding would abort the gate instead of
    # being reported as a failure of utf8-integrity.
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $global:LASTEXITCODE = 0
    try {
        # -B: the scanner imports nothing of its own, but a bytecode cache
        # written beside it would be a build artifact the gate leaves behind.
        $exe = $python[0]
        $pre = @($python | Select-Object -Skip 1)
        $output = & $exe @pre -B 'Scripts/Mojibake-Scan.py' '.' 2>&1
        $code = $global:LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previous
        Pop-Location
    }
    if ($code -eq 0) {
        Add-GateResult -Name 'utf8-integrity' -State 'PASS' -Detail (@($output)[-1])
    } else {
        Add-GateResult -Name 'utf8-integrity' -State 'FAIL' -Detail (@($output | Select-Object -First 3) -join ' / ')
    }
}

function Invoke-JsonValidityCheck {
    Write-Stage 'Linux policy JSON validity'
    $python = Get-PythonCommand
    if (-not $python) {
        $state = if ($AllowMissingTools) { 'WARN' } else { 'FAIL' }
        Add-GateResult -Name 'json-validity' -State $state -Detail 'not installed: python3, python, py'
        return
    }
    Push-Location $script:RepoRoot
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $global:LASTEXITCODE = 0
    $failures = @()
    try {
        $exe = $python[0]
        $pre = @($python | Select-Object -Skip 1)
        $browsers = @('brave', 'chrome')
        $tiers = @('BraveOnly', 'Essential', 'Balanced', 'Advanced', 'Strict')
        foreach ($browser in $browsers) {
            foreach ($tier in $tiers) {
                $output = & $exe @pre -B 'Scripts/Render-PolicyJSON.py' --browser $browser --tier $tier --platform linux 2>&1
                if ($global:LASTEXITCODE -ne 0) {
                    $failures += "$browser/$tier exit $($global:LASTEXITCODE)"
                    continue
                }
                $parsed = $output | ConvertFrom-Json
                if (-not $parsed) { $failures += "$browser/$tier empty" }
            }
        }
    } finally {
        $ErrorActionPreference = $previous
        Pop-Location
    }
    if ($failures) {
        Add-GateResult -Name 'json-validity' -State 'FAIL' -Detail ($failures -join ' / ')
    } else {
        Add-GateResult -Name 'json-validity' -State 'PASS' -Detail '10 renders parse'
    }
}

function Invoke-ShellcheckCheck {
    Write-Stage 'Shell script analysis'
    $shellcheck = Get-NativeCommand -Name @('shellcheck')
    if (-not $shellcheck) {
        $state = if ($AllowMissingTools) { 'WARN' } else { 'FAIL' }
        Add-GateResult -Name 'shellcheck' -State $state -Detail 'not installed: shellcheck'
        return
    }
    Push-Location $script:RepoRoot
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $global:LASTEXITCODE = 0
    try {
        $output = & $shellcheck -S error Brave-Omega/Install-OmegaLinux.sh 2>&1
        $code = $global:LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previous
        Pop-Location
    }
    if ($code -ne 0) {
        Add-GateResult -Name 'shellcheck' -State 'FAIL' -Detail (@($output | Select-Object -First 2) -join ' / ')
    } else {
        Add-GateResult -Name 'shellcheck' -State 'PASS'
    }
}

function Install-PrePushHook {    $hooks = Join-Path (git rev-parse --git-dir) 'hooks'
    $hooks = if ([System.IO.Path]::IsPathRooted($hooks)) { $hooks } else { Join-Path $script:RepoRoot $hooks }
    if (-not (Test-Path -LiteralPath $hooks)) { New-Item -ItemType Directory -Path $hooks | Out-Null }

    $hook = Join-Path $hooks 'pre-push'
    if (Test-Path -LiteralPath $hook) {
        Copy-Item -LiteralPath $hook -Destination "$hook.bak" -Force
        Write-Host "previous hook kept as pre-push.bak" -ForegroundColor Yellow
    }

    # Git runs a hook through sh on every platform, so the hook is a shell
    # script and calls back into the gate by path rather than by relative
    # working directory, which for a hook is not the repository.
    $lines = @(
        '#!/bin/sh',
        '# Installed by Scripts/Invoke-CI.ps1 -InstallHook.',
        '# Refuses a push whose Quality-workflow checks do not pass here first.',
        'root=$(git rev-parse --show-toplevel) || exit 1',
        'powershell -NoProfile -ExecutionPolicy Bypass -File "$root/Scripts/Invoke-CI.ps1"'
    )
    $body = ($lines -join "`n") + "`n"
    [System.IO.File]::WriteAllText(
        $hook, $body.Replace("`n", "`r`n"), (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "pre-push hook installed at $hook" -ForegroundColor Green
}

if ($InstallHook) {
    Install-PrePushHook
    return
}

Write-Host "CI conformance gate - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
Write-Host "repository: $script:RepoRoot" -ForegroundColor DarkGray

Invoke-MarkdownCheck
Invoke-YamlCheck
Invoke-PowerShellSyntaxCheck
Invoke-PesterCheck
Invoke-AnalyzerCheck
Invoke-PolicyIntegrityCheck
Invoke-Utf8Check
Invoke-JsonValidityCheck
Invoke-ShellcheckCheck

$failed = @($script:Results | Where-Object { $_.State -eq 'FAIL' })
$warned = @($script:Results | Where-Object { $_.State -eq 'WARN' })
$uncovered = $script:JobIds | Where-Object { $script:Results.Name -notcontains $_ }
if ($uncovered) {
    Add-GateResult -Name 'gate-coverage' -State 'FAIL' `
        -Detail "declared but never run: $($uncovered -join ', ')"
}

Write-Host ''
if ($failed) {
    Write-Host "GATE FAILED - $($failed.Count) of $($script:Results.Count) checks" -ForegroundColor Red
    exit 1
}
if ($warned) {
    Write-Host "GATE PASSED WITH GAPS - $($warned.Count) check(s) skipped a tool" -ForegroundColor Yellow
    exit 0
}
Write-Host "GATE PASSED - all $($script:Results.Count) checks" -ForegroundColor Green
exit 0