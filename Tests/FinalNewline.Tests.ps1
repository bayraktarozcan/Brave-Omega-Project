# Invariant: every tracked text file ends with LF. Vendor artifacts and
# runtime-owned state are declared exceptions, not silent omissions.
BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $script:RepoRoot = Split-Path -Parent $PSScriptRoot
    $script:Exceptions = @('ADMX/Brave.admx', 'ADMX/Brave.adml', '.opencode/opencode.json')

    function Test-MissingFinalNewline {
        param([string]$Path)
        if (-not (Test-Path -LiteralPath $Path)) { return $false }
        $bytes = [System.IO.File]::ReadAllBytes($Path)
        return ($bytes.Length -gt 0 -and $bytes[-1] -ne 10)
    }
}

Describe 'Final newline' -Tag 'Unit' {
    It 'detects a missing final LF and accepts a clean file' {
        $dir = Join-Path ([System.IO.Path]::GetTempPath()) ('lf-' + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $dir | Out-Null
        try {
            $bad = Join-Path $dir 'bad.md'
            $good = Join-Path $dir 'good.md'
            [System.IO.File]::WriteAllBytes($bad, [System.Text.Encoding]::UTF8.GetBytes('body'))
            [System.IO.File]::WriteAllBytes($good, [System.Text.Encoding]::UTF8.GetBytes("body`n"))
            Test-MissingFinalNewline -Path $bad | Should -BeTrue
            Test-MissingFinalNewline -Path $good | Should -BeFalse
        } finally {
            Remove-Item -LiteralPath $dir -Recurse -Force
        }
    }

    It 'finds no undeclared tracked file without a final LF' {
        $bad = @()
        foreach ($path in (git -C $script:RepoRoot ls-files)) {
            if ($script:Exceptions -ccontains $path) { continue }
            $full = Join-Path $script:RepoRoot $path
            if (-not (Test-Path -LiteralPath $full)) { continue }
            if (Test-MissingFinalNewline -Path $full) { $bad += $path }
        }
        $bad | Should -BeNullOrEmpty -Because ('these tracked files lost their final LF: ' + ($bad -join ', '))
    }

    It 'keeps every declared exception pointing at a real tracked file' {
        $tracked = @(git -C $script:RepoRoot ls-files)
        $stale = @($script:Exceptions | Where-Object { $tracked -cnotcontains $_ })
        $stale | Should -BeNullOrEmpty -Because 'an exception for a file that no longer exists cannot be reviewed'
    }
}
