# Invariant: the weekly text audit reaches both release hosts and feeds their
# published text through the same scanner that checks the repository tree.
BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $script:RepoRoot = Split-Path -Parent $PSScriptRoot
    $script:Workflow = Join-Path $script:RepoRoot '.github\workflows\text-audit.yml'
    $script:Scanner = Join-Path $script:RepoRoot 'Scripts\Mojibake-Scan.py'
    $script:Python = Get-OmegaPythonCommand
    if (-not $script:Python) { throw 'a working python interpreter is required to exercise the scanner' }
}

Describe 'Published text audit' -Tag 'Unit' {
    It 'schedules a weekly sweep of both hosts through the repository scanner' {
        Test-Path -LiteralPath $script:Workflow | Should -BeTrue
        $text = Get-Content -LiteralPath $script:Workflow -Raw
        $text | Should -Match '(?m)^\s*-\s*cron:\s*"15 7 \* \* 1"'
        $text | Should -Match 'workflow_dispatch:'
        $text | Should -Match 'gh api "repos/\$REPO/releases\?per_page=100" --paginate'
        $text | Should -Match 'gitlab\.com/api/v4/projects/.*/releases'
        $text | Should -Match 'Mojibake-Scan\.py'
    }

    It 'scans JSON payloads and fails on planted mojibake' {
        $dir = Join-Path ([System.IO.Path]::GetTempPath()) ('text-audit-' + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $dir | Out-Null
        try {
            $clean = '{"body":"Türkçe karakterler: ç ş ğ ü ö ı İ"}'
            [System.IO.File]::WriteAllText((Join-Path $dir 'clean.json'), $clean, [System.Text.UTF8Encoding]::new($false))
            & $script:Python $script:Scanner $dir 2>&1 | Out-Null
            $LASTEXITCODE | Should -Be 0

            # Assembled from code points so this test file stays clean.
            $damaged = '{"body":"' + [string][char]0x00C3 + [string][char]0x00A7 + '"}'
            [System.IO.File]::WriteAllText((Join-Path $dir 'damaged.json'), $damaged, [System.Text.UTF8Encoding]::new($false))
            & $script:Python $script:Scanner $dir 2>&1 | Out-Null
            $LASTEXITCODE | Should -Be 1
        } finally {
            Remove-Item -LiteralPath $dir -Recurse -Force
        }
    }
}
