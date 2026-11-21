# Invariant: an action reference must name a ref that exists in the upstream
# repository. The blanket SHA -> @main rewrite failed on lycheeverse/
# lychee-action, whose default branch is master and which has no main ref, so
# link-check could not start. This guard keeps that fact in the tree instead of
# relying on a memory of an API response: the map below was taken from the
# upstream repositories on 2026-11-21, and this test fails when a workflow
# drifts away from it.
#
# What this check cannot see: a future upstream default-branch rename that is
# not reflected in the map, a self-authored map that is itself wrong, or a
# compromise of a tracked branch. It proves that the workflows agree with this
# local declaration, not that the upstream refs are still what we believe.
# The map is deliberately local and deterministic so the gate does not depend
# on network access; refreshing it is a reviewed code change. Branch compromise
# is the accepted risk recorded in SECURITY.md §6.4.

BeforeAll {
    $script:RepoRoot = Split-Path -Parent $PSScriptRoot
    $script:WorkflowDir = Join-Path $script:RepoRoot '.github/workflows'

    $script:DefaultBranch = @{
        'actions/checkout'                  = 'main'
        'actions/configure-pages'           = 'main'
        'actions/deploy-pages'              = 'main'
        'actions/setup-python'              = 'main'
        'actions/stale'                     = 'main'
        'actions/upload-artifact'           = 'main'
        'actions/upload-pages-artifact'     = 'main'
        'DavidAnson/markdownlint-cli2-action' = 'main'
        'lycheeverse/lychee-action'         = 'master'
        'rhysd/actionlint'                  = 'main'
    }

    function Get-ActionReference {
        $references = @()
        foreach ($file in (Get-ChildItem -LiteralPath $script:WorkflowDir -Filter '*.yml')) {
            $text = Get-Content -LiteralPath $file.FullName -Raw
            foreach ($match in [regex]::Matches($text, '(?m)^\s*(?:-\s*)?uses:\s*([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)@([^\s#]+)')) {
                $references += [pscustomobject]@{
                    File = $file.Name
                    Repo = $match.Groups[1].Value
                    Ref  = $match.Groups[2].Value
                }
            }
        }
        return $references
    }

    $script:References = @(Get-ActionReference)
}

Describe 'Action reference invariants' -Tag 'Unit' {
    It 'guards real references and uses a mutable ref instead of a full commit SHA' {
        $script:References.Count | Should -BeGreaterThan 0 -Because 'a check that finds no action reference has never been exercised'
        $shas = @($script:References | Where-Object { $_.Ref -cmatch '^[0-9a-f]{40}$' })
        $shas | Should -BeNullOrEmpty -Because ('the latest-version rule forbids full-commit SHA pins: ' + (($shas | ForEach-Object { "$($_.File): $($_.Repo)@$($_.Ref)" }) -join ', '))

        $pinPattern = '(?m)(?:RequiredVersion\s+\S+|@sha256:[0-9a-f]{64}|pip install [^\s]+==|GITLEAKS_VERSION|PESTER_VERSION|PSSA_VERSION|MARKDOWNLINT_CLI2_VERSION|LYCHEE_VERSION|ACTIONLINT_VERSION)'
        $pins = @()
        $ciFiles = @(Get-ChildItem -LiteralPath $script:WorkflowDir -Filter '*.yml' | ForEach-Object { $_.FullName }) + @(Join-Path $script:RepoRoot '.gitlab-ci.yml')
        foreach ($path in $ciFiles) {
            $text = Get-Content -LiteralPath $path -Raw
            foreach ($match in [regex]::Matches($text, $pinPattern)) {
                $pins += "$(Split-Path -Leaf $path): $($match.Value)"
            }
        }
        $pins | Should -BeNullOrEmpty -Because ('the always-latest rule forbids any pinned tool version or digest: ' + ($pins -join ', '))
    }

    It 'resolves every action against the upstream default branch recorded for it' {
        $unknown = @($script:References | Where-Object { -not $script:DefaultBranch.ContainsKey($_.Repo) })
        $unknown | Should -BeNullOrEmpty -Because ('an action outside the verified map has no evidence that its ref exists: ' + (($unknown | ForEach-Object { "$($_.File): $($_.Repo)" }) -join ', '))

        $wrong = @($script:References | Where-Object {
            $script:DefaultBranch.ContainsKey($_.Repo) -and $_.Ref -cne $script:DefaultBranch[$_.Repo]
        })
        $wrong | Should -BeNullOrEmpty -Because ('a ref that is not the upstream default branch cannot be assumed to exist: ' + (($wrong | ForEach-Object { "$($_.File): $($_.Repo)@$($_.Ref)" }) -join ', '))
    }

    It 'keeps the non-main exception documented next to its use' {
        $linkCheck = Get-Content -LiteralPath (Join-Path $script:WorkflowDir 'link-check.yml') -Raw
        $linkCheck | Should -Match '(?m)^\s*#.*master, not main'
        $linkCheck | Should -Match 'lycheeverse/lychee-action@master'
    }
}
