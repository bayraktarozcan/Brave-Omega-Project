# Invariant: host tools are compared numerically, probed before they are
# changed, and updated only at per-user scope so no elevation is needed.
BeforeAll {
    $script:RepoRoot = Split-Path -Parent $PSScriptRoot
    $script:Helper = Join-Path $script:RepoRoot 'Scripts\Update-HostTools.ps1'
    . $script:Helper -Library
}

Describe 'Host tool currency' -Tag 'Unit' {
    It 'compares tool versions numerically rather than as strings' {
        Compare-ToolVersion -Current '1.9.0' -Available '1.10.0' | Should -Be 'Update available'
        Compare-ToolVersion -Current '2.0.0' -Available '1.10.0' | Should -Be 'Current above source'
    }

    It 'reports an identical version as current' {
        Compare-ToolVersion -Current '1.10.0' -Available '1.10.0' | Should -Be 'Up to date'
    }

    It 'does not act on an unparseable source version' {
        Compare-ToolVersion -Current '1.10.0' -Available 'latest' | Should -Be 'Unknown'
    }

    It 'offers an install when nothing is installed yet' {
        Compare-ToolVersion -Current 'not installed' -Available '1.10.0' | Should -Be 'Install available'
    }

    It 'probes by default and never requests elevation' {
        $text = Get-Content -LiteralPath $script:Helper -Raw
        $text | Should -Match 'if \(-not \$Apply\)'
        $text | Should -Match '--scope user'
        $text | Should -Match '-Scope CurrentUser'
        $text | Should -Not -Match '--system|\bAllUsers\b|sudo'
    }

    It 'declares verified sources and probes pip tools through the real interpreter' {
        # Verified live on 2026-11-21: an ID that cannot be resolved would
        # make the probe report "not installed" forever and never offer an
        # update, which is a silently dead guard.
        @($script:WingetTools | ForEach-Object Id) | Should -Be @(
            'Gitleaks.Gitleaks', 'rhysd.actionlint', 'lycheeverse.lychee',
            'koalaman.shellcheck', 'Microsoft.PowerShell'
        )
        @($script:PackageTools | ForEach-Object Manager) | Should -Be @('pip', 'npm')

        # A resolved interpreter is an executable plus a prefix argument;
        # passing the whole array as one command name silently breaks the
        # probe, so exercise the real call path here.
        $interpreter = @(Get-PythonCommand | Where-Object { $_ })
        $interpreter.Count | Should -BeGreaterOrEqual 1
        $interpreter[0].Length | Should -BeGreaterThan 1

        $version = Get-PackageVersion -Id 'yamllint' -Manager pip
        $version | Should -Not -BeNullOrEmpty
        $version | Should -Not -Match 'not recognized|cmdlet|terim'
    }
}
