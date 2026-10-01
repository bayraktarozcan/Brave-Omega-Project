BeforeAll {
    $script:RepoRoot = Split-Path -Parent $PSScriptRoot
    $script:WorkflowDir = Join-Path $script:RepoRoot ".github/workflows"
    $script:GitLabCi = Join-Path $script:RepoRoot ".gitlab-ci.yml"

    # The rule is derived from what the suite actually reads, not from a list of
    # environments remembered here. If a future change stops reading history,
    # the requirement relaxes on its own instead of being edited by hand in a
    # second place that can then disagree with the first.
    $suiteText = (Get-ChildItem (Join-Path $script:RepoRoot "Tests") -Filter "*.Tests.ps1" |
        ForEach-Object { Get-Content -LiteralPath $_.FullName -Raw }) -join "`n"
    # The probe in the scanner suite hands git an object spelled as
    # "cat-file", "blob" - the quotes and the comma sit between the two words,
    # so the dependency is matched across that gap rather than as one token.
    $script:SuiteNeedsHistory = $suiteText -cmatch 'cat-file.{0,12}blob'

    # Splits a GitHub workflow into its jobs. Job keys sit at exactly two spaces
    # of indentation in every workflow in this repository; a deeper key is a
    # step property and a shallower one belongs to the file itself. Scanning
    # starts after the top-level jobs key, because the triggers block holds keys
    # at the same two-space depth - push, pull_request and workflow_dispatch are
    # not jobs and a gate compared against them would demand a check that no
    # runner ever performs.
    function Get-WorkflowJob {
        param([Parameter(Mandatory)][string]$Text)

        $lines = $Text -split "`r?`n"
        $first = 0
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -cmatch '^jobs:\s*$') { $first = $i + 1; break }
        }

        $starts = @()
        for ($i = $first; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -cmatch '^  ([A-Za-z0-9_.-]+):\s*$') {
                $starts += [pscustomobject]@{ Name = $Matches[1]; Index = $i }
            }
        }
        $jobs = @()
        for ($j = 0; $j -lt $starts.Count; $j++) {
            $end = if ($j + 1 -lt $starts.Count) { $starts[$j + 1].Index - 1 } else { $lines.Count - 1 }
            $jobs += [pscustomobject]@{
                Name = $starts[$j].Name
                Text = ($lines[$starts[$j].Index..$end] -join "`n")
            }
        }
        return $jobs
    }

    $script:WorkflowFiles = @()
    if (Test-Path -LiteralPath $script:WorkflowDir) {
        $script:WorkflowFiles = @(Get-ChildItem -LiteralPath $script:WorkflowDir -File |
            Where-Object { $_.Name -cmatch '[.](yaml|yml)$' })
    }
}

Describe "CI conformance" {
    Context "when the suite reads its oracle out of git history" {
        It "requires every environment that runs the suite to provide that history" {
            # The precondition has to be true for the following checks to be
            # about anything at all. If the suite stopped reading history these
            # checks would still pass, so the fact is asserted rather than assumed.
            $script:SuiteNeedsHistory | Should -BeTrue -Because "the damage these checks guard is only reachable through history, so a silent dependency change must not pass unnoticed"
        }

        It "checks out full history in every GitHub job that runs the suite" {
            $checked = 0
            foreach ($file in $script:WorkflowFiles) {
                $text = Get-Content -LiteralPath $file.FullName -Raw
                foreach ($job in Get-WorkflowJob -Text $text) {
                    if ($job.Text -cnotmatch 'Invoke-Pester') { continue }
                    $checked++
                    $job.Text | Should -Match 'fetch-depth:\s*0' -Because "job '$($job.Name)' in $([System.IO.Path]::GetFileName($file.Name)) runs a suite that reads git history, and a depth-1 checkout leaves those blobs unreachable so the job reports a failure a full local clone cannot reproduce"
                }
            }
            $checked | Should -BeGreaterThan 0 -Because "a check that finds no job is a check that has never been exercised"
        }

        It "keeps full history in the second gate rather than letting the hosts disagree" {
            Test-Path -LiteralPath $script:GitLabCi | Should -BeTrue
            $gitlab = Get-Content -LiteralPath $script:GitLabCi -Raw
            $gitlab | Should -Match 'GIT_DEPTH:\s*0' -Because "the two hosts enforce the same checks, so a requirement satisfied on one and missing on the other is a defect on the one that is missing it"
        }
    }

    Context "the local gate" {
        BeforeAll {
            $script:GatePath = Join-Path $script:RepoRoot "Scripts/Invoke-CI.ps1"
            $qualityPath = Join-Path $script:WorkflowDir "quality.yml"

            # The gate declares which workflow job each of its checks stands in
            # for. That declaration is the link between "green here" and "green
            # there", so it is compared against the workflow instead of trusted:
            # a job added to the workflow without a counterpart in the gate would
            # otherwise leave a check that nobody runs before a push.
            $gateText = Get-Content -LiteralPath $script:GatePath -Raw
            $block = [regex]::Match($gateText, '(?s)\$script:JobIds\s*=\s*@\((.*?)\)')
            $script:DeclaredJobs = @()
            if ($block.Success) {
                $script:DeclaredJobs = @([regex]::Matches($block.Groups[1].Value, "'([^']+)'") |
                    ForEach-Object { $_.Groups[1].Value })
            }
            $script:WorkflowJobs = @((Get-WorkflowJob -Text (Get-Content -LiteralPath $qualityPath -Raw)).Name)
        }

        It "runs a check for every job the Quality workflow declares" {
            $script:DeclaredJobs.Count | Should -BeGreaterThan 0 -Because "an empty declaration would let any new job pass unnoticed"
            $missing = @($script:WorkflowJobs | Where-Object { $script:DeclaredJobs -notcontains $_ })
            $missing | Should -BeNullOrEmpty -Because "a job in the Quality workflow with no counterpart in the gate is a check that no push runs locally: $($missing -join ', ')"
        }

        It "declares no job the Quality workflow does not have" {
            $extra = @($script:DeclaredJobs | Where-Object { $script:WorkflowJobs -notcontains $_ })
            $extra | Should -BeNullOrEmpty -Because "a gate entry pointing at a job that no longer exists is either a stale declaration or a check that is not really running in CI"
        }

        It "reads external exit codes from the scope a native command writes" {
            # $LASTEXITCODE is an automatic variable a native command updates in
            # the global scope. Assigning it without that qualifier inside a
            # function creates a local shadow, and the function then reads back
            # its own assignment forever: the exit code it reports is the zero it
            # wrote, not the one the tool returned. Every check that shells out
            # would have reported PASS without having run anything, which is the
            # one outcome this gate exists to make impossible.
            $gate = Get-Content -LiteralPath $script:GatePath -Raw
            $shadowed = [regex]::Matches($gate, '(?m)^\s*\$(?!global:)(LASTEXITCODE)\s*=')
            $shadowed.Count | Should -Be 0 -Because "an unqualified assignment shadows the automatic variable and makes the exit code unreadable: $($shadowed.Value -join ', ')"
        }

        It "fails rather than passing when a tool it needs is absent" {
            # A gate that reports itself green while skipping half its work is the
            # failure this whole arrangement exists to prevent, so the default
            # has to be the strict one. Counted rather than matched once, because
            # each tool check carries its own branch and one of them could be
            # written the other way without anything noticing.
            $gate = Get-Content -LiteralPath $script:GatePath -Raw
            $branches = [regex]::Matches(
                $gate, "if \(\`$AllowMissingTools\) \{ 'WARN' \} else \{ 'FAIL' \}")
            $branches.Count | Should -BeGreaterOrEqual 3 -Because "every path that resolves an external tool has to default to failing, with the warning reachable only through the switch"
        }
    }

    Context "the checks themselves" {
        It "detects a checkout that is missing the requirement" {
            # A check that has never been seen to fail is not known to work, so
            # the detector is exercised against a job shaped exactly like the one
            # that shipped broken.
            $broken = @'
  pester-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1
      - name: Run Pester tests
        shell: pwsh
        run: |
          Invoke-Pester -Configuration $config
'@
            $job = @(Get-WorkflowJob -Text $broken)
            $job.Count | Should -Be 1
            $job[0].Text | Should -Match 'Invoke-Pester'
            $job[0].Text | Should -Not -Match 'fetch-depth:\s*0' -Because "this is the defect the check exists to report, and a detector that accepted it would have shipped a red build"
        }

        It "accepts a checkout that carries the requirement" {
            $fixed = @'
  pester-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1
        with:
          fetch-depth: 0
      - name: Run Pester tests
        shell: pwsh
        run: |
          Invoke-Pester -Configuration $config
'@
            $job = Get-WorkflowJob -Text $fixed
            $job[0].Text | Should -Match 'fetch-depth:\s*0'
        }

        It "does not confuse a step property for a job" {
            # "with:" and "name:" sit at six spaces, so a scan that matched any
            # indented key would report a fetch-depth belonging to some other job.
            $twoJobs = @'
  first:
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1
        with:
          fetch-depth: 0
  second:
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1
      - name: Run Pester tests
        run: Invoke-Pester
'@
            $jobs = Get-WorkflowJob -Text $twoJobs
            $jobs.Count | Should -Be 2
            $jobs[0].Text | Should -Match 'fetch-depth:\s*0'
            $jobs[1].Text | Should -Not -Match 'fetch-depth:\s*0'
        }
    }
}