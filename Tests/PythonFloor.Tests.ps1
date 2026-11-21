# Invariant: the Python compatibility floor is resolved from the upstream
# release calendar and every CI declaration agrees with one source.
# The calendar is injected as data, so these tests never touch the network.
BeforeAll {
    $script:RepoRoot = Split-Path -Parent $PSScriptRoot
    $script:Helper = Join-Path $script:RepoRoot 'Scripts\Update-PythonFloor.ps1'
    . $script:Helper -Library

    $script:Cycles = @{
        '3.12' = @{ status = 'security'; end_of_life = '2028-10' }
        '3.11' = @{ status = 'security'; end_of_life = '2027-10' }
        '3.10' = @{ status = 'end-of-life'; end_of_life = '2026-10' }
    }

    function New-FloorFixture {
        param([switch]$WithoutGitLab)
        $root = Join-Path ([System.IO.Path]::GetTempPath()) ("python-floor-" + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $root | Out-Null
        New-Item -ItemType Directory -Path (Join-Path $root '.github\workflows') | Out-Null
        $names = @('.github\workflows\quality.yml')
        if (-not $WithoutGitLab) { $names += '.gitlab-ci.yml' }
        foreach ($name in $names) {
            Copy-Item -LiteralPath (Join-Path $script:RepoRoot $name) -Destination (Join-Path $root $name) -Force
        }
        return $root
    }
}

Describe 'Python floor invariants' -Tag 'Unit' {
    AfterEach {
        if ($script:Fixture -and (Test-Path -LiteralPath $script:Fixture)) {
            Remove-Item -LiteralPath $script:Fixture -Recurse -Force
            $script:Fixture = $null
        }
    }

    It 'resolves the oldest version that is not end of life' {
        Resolve-Floor -Cycles $script:Cycles -Today ([datetime]'2026-11-21') | Should -Be '3.11'
    }

    It 'treats a passed EOL date as unsupported even when the status lags' {
        $cycles = @{
            '3.12' = @{ status = 'security'; end_of_life = '2028-10' }
            '3.11' = @{ status = 'security'; end_of_life = '2026-01' }
        }
        Resolve-Floor -Cycles $cycles -Today ([datetime]'2026-11-21') | Should -Be '3.12'
    }

    It 'refuses an empty calendar instead of silently declaring no floor' {
        { Resolve-Floor -Cycles @{} -Today ([datetime]'2026-11-21') } | Should -Throw '*no supported Python version*'
    }

    It 'reads the floor from the single declared source' {
        $script:Fixture = New-FloorFixture
        Get-DeclaredFloor -RepoRoot $script:Fixture | Should -Be '3.11'
    }

    It 'detects a planted drift in a declaration' {
        $script:Fixture = New-FloorFixture
        $path = Join-Path $script:Fixture '.gitlab-ci.yml'
        $text = [System.IO.File]::ReadAllText($path)
        [System.IO.File]::WriteAllText($path, $text.Replace('PYTHON_VERSION: ["3.11", "latest"]', 'PYTHON_VERSION: ["3.12", "latest"]'))
        $problems = @(Find-Drift -RepoRoot $script:Fixture -Floor '3.11')
        $problems.Count | Should -BeGreaterThan 0
        ($problems -join ' ') | Should -Match '\.gitlab-ci\.yml'
    }

    It 'reports a missing required CI declaration' {
        $script:Fixture = New-FloorFixture -WithoutGitLab
        $problems = @(Find-Drift -RepoRoot $script:Fixture -Floor '3.11')
        ($problems -join ' ') | Should -Match '\.gitlab-ci\.yml: missing file'
    }

    It 'applies the floor to every CI declaration and preserves BOM' {
        $script:Fixture = New-FloorFixture
        $source = Join-Path $script:Fixture '.gitlab-ci.yml'
        $file = Read-RepoFile -Path $source
        Write-RepoFile -Path $source -Text $file.Text -Bom $true
        $before = [System.IO.File]::ReadAllBytes($source)
        ($before[0] -eq 0xEF -and $before[1] -eq 0xBB -and $before[2] -eq 0xBF) | Should -BeTrue

        $changed = @(Apply-Floor -RepoRoot $script:Fixture -Old '3.11' -New '3.12')
        $changed.Count | Should -Be 2
        Get-DeclaredFloor -RepoRoot $script:Fixture | Should -Be '3.12'
        @(Find-Drift -RepoRoot $script:Fixture -Floor '3.12').Count | Should -Be 0

        $after = [System.IO.File]::ReadAllBytes($source)
        ($after[0] -eq 0xEF -and $after[1] -eq 0xBB -and $after[2] -eq 0xBF) | Should -BeTrue
    }

    It 'refuses to downgrade the floor' {
        $script:Fixture = New-FloorFixture
        { & $script:Helper -Command apply -Version '3.10' -Root $script:Fixture } | Should -Throw '*refusing to downgrade*'
    }

    It 'finds no drift in the live repository' {
        @(Find-Drift -RepoRoot $script:RepoRoot -Floor (Get-DeclaredFloor -RepoRoot $script:RepoRoot)).Count | Should -Be 0
    }
}
