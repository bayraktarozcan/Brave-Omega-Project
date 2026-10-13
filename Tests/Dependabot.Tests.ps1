# Invariant: the dependency bot speaks the project's commit language.
#
# AGENTS.md declares that dependency updates arrive as Conventional Commits
# (`chore(deps)`), and `.github/dependabot.yml` is where that shape is
# configured (commit-message prefix plus scope). The oracle is the config
# file itself: the prefix and the cadence are read back out of it, so a
# hand-edited value that drifts from the declaration fails by name instead
# of shipping bot commits the log never promised.
#
# What this check cannot see:
#   - What the bot actually writes. This file proves the declaration, not
#     the behavior: the final proof is the title of the next bot PR, read
#     by a human, because no local run can make Dependabot open one.
#   - Whether the schedule stays useful. Weekly is declared, not derived;
#     if the PR pile-up the cadence exists to prevent returns anyway, the
#     cadence is renegotiated, not this check.
BeforeAll {
    . $PSScriptRoot\TestHelper.ps1

    $script:DependabotPath = Join-Path $ProjectRoot '.github/dependabot.yml'
    $script:DependabotText = Get-Content -LiteralPath $script:DependabotPath -Raw
}

Describe 'Dependabot conventions' -Tag 'Unit' {

    It 'uses the chore prefix so bot commits match the declared convention' {
        $script:DependabotText | Should -Match '(?m)^\s*prefix:\s*"chore"\s*$' -Because 'a "ci" prefix ships bot commits the changelog convention never promised, and nothing else reads this value back'
    }

    It 'stays on the weekly cadence instead of piling up daily PRs' {
        $script:DependabotText | Should -Match '(?m)^\s*interval:\s*"weekly"\s*$' -Because 'the weekly cadence is the declared defense against daily PR pile-ups, and a silently quickened schedule is a second bot to triage'
    }
}
