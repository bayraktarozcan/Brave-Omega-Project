# Invariant: every surface that states the supported Windows names the Windows
# the compatibility matrix calls current. A doc fix that moves the README
# prerequisite to 26H2 but leaves the SECURITY badge and the SUPPORT
# environment table on 25H2 reads as true to a reader and is noticed by
# nothing else in the tree - VersionParity watches release tokens, the ADMX
# gate watches policies, the mirror gate watches structure. This file is the
# one that notices the operating system.
#
# The oracle is the matrix, not a literal written here: the Windows value is
# read from the README compatibility matrix row marked current at run time,
# so the check follows the next Windows bump instead of blessing 26H2
# forever. History is exempt by shape, not by address: CHANGELOG.md and
# Wiki/Changelog.md are pure history, and a matrix row about a superseded
# release carries its own status, never a requirement marker.
#
# What this check cannot see:
#   - A current claim phrased without a requirement marker or a version
#     token. The marker plus the token is what makes "near" mechanical;
#     prose that states support some other way stays a human read.
#   - Whether the matrix itself is right. If the current row names the wrong
#     Windows, every surface agrees on the wrong answer together. The matrix
#     is the validation record; its correctness is established where the
#     validation happens, not here.
BeforeAll {
    . $PSScriptRoot\TestHelper.ps1

    # Non-ASCII markers are assembled from char codes rather than written as
    # literals. This file carries no BOM and Windows PowerShell 5.1 reads a
    # BOM-less .ps1 as ANSI, so a literal would reach the regex as a different
    # pattern than the one the documents use - and a check that fails to
    # recognize the word it hunts for passes a Turkish page by saying nothing.
    # VersionParity.Tests.ps1 builds its Turkish words the same way.
    $script:Dogru = 'do' + [string]([char]0x011F) + 'rulanm' + [string]([char]0x0131) + [string]([char]0x015F)
    $script:Markers = @('requir', 'prereq', 'validat', 'gerek', $script:Dogru)
    $script:OsToken = '(?:11\s+|11%20)(\d+H\d+)'

    $script:TrackedDocs = @(
        & git -C $ProjectRoot ls-files -- "*.md" "*.html" |
            ForEach-Object { $_.Trim() } |
            Where-Object { $_ -and $_ -notmatch '(^|/)CHANGELOG\.md$' -and $_ -ne 'Wiki/Changelog.md' }
    )

    function Get-OsTokenOnLine {
        param([string]$Line)
        $found = @()
        foreach ($m in [regex]::Matches($Line, $script:OsToken)) {
            $found += $m.Groups[1].Value
        }
        return $found
    }

    function Test-HasMarker {
        param([string]$Line)
        foreach ($marker in $script:Markers) {
            if ($Line -match [regex]::Escape($marker)) { return $true }
        }
        return $false
    }

    # The matrix row the project itself marks current. Every current-row hit
    # must name the same Windows; that single value is the oracle.
    $script:CurrentWindows = @()
    foreach ($file in @($script:TrackedDocs | Where-Object { $_ -like 'README.md' })) {
        $path = Join-Path $ProjectRoot $file
        foreach ($line in (Get-Content -LiteralPath $path)) {
            if ($line -cmatch '\*\(current\)\*') {
                $script:CurrentWindows += @(Get-OsTokenOnLine -Line $line)
            }
        }
    }
    $script:CurrentWindows = @($script:CurrentWindows | Select-Object -Unique)
    $script:Oracle = $script:CurrentWindows | Select-Object -First 1
}

Describe 'OS parity' -Tag 'Unit' {

    It 'reads one Windows from the matrix rows marked current' {
        $script:CurrentWindows.Count | Should -Be 1 -Because 'the oracle is a single value: zero current rows means the matrix lost its marker and several means the tree no longer agrees with itself'
    }

    It 'names that Windows on every badge that advertises the platform' {
        $bad = @()
        foreach ($file in $script:TrackedDocs) {
            $path = Join-Path $ProjectRoot $file
            $lineNo = 0
            foreach ($line in (Get-Content -LiteralPath $path)) {
                $lineNo++
                if ($line -cnotmatch 'Platform-Windows%2011%20') { continue }
                foreach ($token in @(Get-OsTokenOnLine -Line $line)) {
                    if ($token -cne $script:Oracle) {
                        $bad += "$file`:$lineNo -> $token (matrix says $($script:Oracle))"
                    }
                }
            }
        }
        $bad | Should -BeNullOrEmpty -Because 'a badge is a live image, never history: a stale platform badge tells every new reader the wrong floor'
    }

    It 'names that Windows wherever a requirement states it' {
        $bad = @()
        foreach ($file in $script:TrackedDocs) {
            $path = Join-Path $ProjectRoot $file
            $lineNo = 0
            foreach ($line in (Get-Content -LiteralPath $path)) {
                $lineNo++
                if (-not (Test-HasMarker -Line $line)) { continue }
                foreach ($token in @(Get-OsTokenOnLine -Line $line)) {
                    if ($token -cne $script:Oracle) {
                        $bad += "$file`:$lineNo -> $token (matrix says $($script:Oracle))"
                    }
                }
            }
        }
        $bad | Should -BeNullOrEmpty -Because 'a prerequisite that names a superseded Windows sends the reader to prepare the wrong machine'
    }
}
