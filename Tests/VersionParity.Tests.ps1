# Invariant: every surface that advertises the current release names the release
# the script itself declares. A version bump that moves $ScriptVersion and adds a
# changelog entry, but leaves a page calling the superseded version "current",
# reads as true to a reader and is noticed by nothing else in the tree - the
# ADMX gate checks policy cross-references, the mirror gate checks structure, the
# file naming gate checks paths. This file is the one that notices the version.
#
# The oracle is the script, not a copy of its version written down here. A test
# asserting a literal "v2.8.1.1" would agree with itself the day the version moved
# and prove nothing, so the expected value is read from BraveOmega.ps1 at run
# time and the predecessor is derived from the changelog's own entry order.
#
# What this check cannot see:
#   - A page that advertises the current release in prose with no version token
#     within the claim window and no heading to anchor it. The window is what
#     makes "near" mechanical; past it the check stays silent on purpose.
#   - A claim section that names several versions. Only the first is compared, so
#     a superseded version further down the same section is either history or
#     drift, and telling those two apart stays a human read.
#   - Whether the surfaces agree with each other on anything but the version: a
#     policy count, a Brave build, a date. Those are prose, not versions.
#
# The Get- helpers below are named for what they return rather than in the
# singular-noun form PSScriptAnalyzer prefers, so they read the way the existing
# collection getters in TestHelper.ps1 read. The Tests tree is not part of the
# analyzer gate, and a getter that returns a list is described by a list.
BeforeAll {
    . $PSScriptRoot\TestHelper.ps1

    $script:VersionOfRecord = Get-VariableRegex -ScriptPath $ScriptMain -VariableName "ScriptVersion"

    # Turkish words are assembled from char codes rather than written as
    # literals. This file carries no BOM and Windows PowerShell 5.1 reads a
    # BOM-less .ps1 as ANSI, so a literal would reach the regex as a different
    # pattern than the one the documents use - and a check that fails to
    # recognize the word it hunts for passes a Turkish page by saying nothing.
    # FullPipeline-TR.Tests.ps1 builds its Turkish character the same way.
    $script:Guncel = [string]([char]0x011F) + [char]0x00FC + 'ncel'
    $script:SuAn = [string]([char]0x015F) + 'u an'
    $script:Onceki = [string]([char]0x00D6) + 'nceki'
    $script:Surum = 's' + [char]0x00FC + 'r' + [char]0x00FC + 'm'

    # A word boundary after the noun keeps a plural heading out: "Onceki
    # Surumler" (previous releases) lists history and makes no claim about the
    # release that came before the current one.
    $script:NounPattern = "(?i)(version|release|$($script:Surum))\b"
    $script:CurrentMarker = "(?i)\b(current|latest|en son|$($script:Guncel)|$($script:SuAn))\b"
    $script:PreviousMarker = "(?i)\b(previous|$($script:Onceki))\b"

    # The leading "v" is what separates a project version from a Chromium build
    # (154.0.8037.58) and from a number in a sentence; the project spells its own
    # version with the prefix everywhere it is named as a release.
    $script:VersionToken = 'v\d+\.\d+\.\d+\.\d+'

    # "Adjacent" is what separates a claim from prose that happens to mention a
    # release. Measured across the tree: every real current-version claim puts
    # the marker within 33 characters of the version, while the nearest mention
    # of a superseded release - a changelog row describing an old entry - sits at
    # 51. 40 is the empty gap between the two populations.
    $script:ClaimWindow = 40

    $script:TrackedDocs = @(
        & git -C $ProjectRoot ls-files -- "*.md" "*.html" |
            ForEach-Object { $_.Trim() } |
            Where-Object { $_ }
    )

    function Get-HeadingDepth {
        param([string]$Line)

        if ($Line -match '^(#{1,6})\s') { return $Matches[1].Length }
        if ($Line -match '^<h([1-6])[\s>]') { return [int]$Matches[1] }
        return 0
    }

    # Every version token sitting within the claim window of a marker word. A
    # marker and a version that belong to one claim are written next to each
    # other ("**v2.8.1.1** *(current)*", "Son Surum: [v2.8.1.1 - ...]"), so the
    # window is the claim unit.
    function Get-AdjacentVersionClaims {
        param([string[]]$Lines, [string]$Expected)

        $offenders = @()
        for ($i = 0; $i -lt $Lines.Count; $i++) {
            $line = $Lines[$i]
            $markers = [regex]::Matches($line, $script:CurrentMarker)
            if ($markers.Count -eq 0) { continue }
            $versions = [regex]::Matches($line, $script:VersionToken)
            foreach ($marker in $markers) {
                foreach ($version in $versions) {
                    $distance = [Math]::Abs($version.Index - $marker.Index)
                    if ($distance -gt $script:ClaimWindow) { continue }
                    if ($version.Value -eq $Expected) { continue }
                    $offenders += ("line {0}: '{1}' names {2} where {3} says the release is" -f
                        ($i + 1), $marker.Value, $version.Value, $Expected)
                }
            }
        }
        return $offenders
    }

    # The first version introduced under a claim heading. A heading only counts
    # when it also carries the noun, so "Her Daim Guncel" (always up to date) is
    # a slogan and not a claim about which version is current.
    function Get-HeadingVersionClaims {
        param([string[]]$Lines, [string]$Expected, [string]$Marker)

        $offenders = @()
        for ($i = 0; $i -lt $Lines.Count; $i++) {
            $depth = Get-HeadingDepth $Lines[$i]
            if ($depth -eq 0) { continue }
            if ($Lines[$i] -notmatch $Marker) { continue }
            if ($Lines[$i] -notmatch $script:NounPattern) { continue }

            $last = $Lines.Count - 1
            for ($j = $i + 1; $j -lt $Lines.Count; $j++) {
                $next = Get-HeadingDepth $Lines[$j]
                if ($next -ne 0 -and $next -le $depth) { $last = $j - 1; break }
            }

            $introduced = $null
            $namedAt = $i + 1
            for ($k = $i + 1; $k -le $last; $k++) {
                $match = [regex]::Match($Lines[$k], $script:VersionToken)
                if (-not $match.Success) { continue }
                $introduced = $match.Value
                $namedAt = $k + 1
                break
            }
            if ($null -eq $introduced) { continue }
            if ($introduced -eq $Expected) { continue }
            $offenders += ("line {0}: '{1}' introduces {2} at line {3}, expected {4}" -f
                ($i + 1), $Lines[$i].Trim(), $introduced, $namedAt, $Expected)
        }
        return $offenders
    }

    # The changelog is the release log, ordered newest first, and it names every
    # release it has ever held. Read as a list it yields the version of record
    # and the release before it without a second copy of either.
    function Get-ReleasedVersions {
        $log = Join-Path $ProjectRoot "CHANGELOG.md"
        if (-not (Test-Path -LiteralPath $log)) { return @() }
        $found = @()
        foreach ($line in [System.IO.File]::ReadAllLines($log, [System.Text.Encoding]::UTF8)) {
            if ($line -notmatch '^##\s*\[(v\d+\.\d+\.\d+\.\d+)\]') { continue }
            if ($found -notcontains $Matches[1]) { $found += $Matches[1] }
        }
        return $found
    }

    # The wiki changelog is the root changelog's published projection and holds
    # the same release set. Both are read as version lists and normalized so the
    # one naming variance in the tree - the root's three-part "v2.1.6" against
    # the wiki's four-part "v2.1.6.0" - compares equal instead of reading as a
    # release that went missing. The rule now lives in TestHelper.ps1, which the
    # compatibility matrix check in VersionMatrix.Tests.ps1 uses for the same
    # comparison; one definition, so the two cannot disagree about which spelling
    # is canonical.

    function Get-ExtractedVersions {
        param([string]$Path, [string]$HeadingPattern)

        if (-not (Test-Path -LiteralPath $Path)) { return @() }
        $found = @()
        foreach ($line in [System.IO.File]::ReadAllLines($Path, [System.Text.Encoding]::UTF8)) {
            if ($line -notmatch $HeadingPattern) { continue }
            $normalized = ConvertTo-FourPartVersion $Matches[1]
            if ($normalized -and $found -notcontains $normalized) { $found += $normalized }
        }
        return $found
    }

    function Get-DocLines {
        param([string]$Doc)

        return [System.IO.File]::ReadAllLines((Join-Path $ProjectRoot $Doc), [System.Text.Encoding]::UTF8)
    }
}

Describe "Documentation version parity" -Tag "Unit" {

    Context "Oracles" {
        It "the script declares a four-part version" {
            $script:VersionOfRecord | Should -Match '^v\d+\.\d+\.\d+\.\d+$' -Because "the expected value is read from the script, and a value the comparison cannot parse would let every claim pass unchecked"
        }

        It "the newest changelog entry is the version the script declares" {
            $released = Get-ReleasedVersions
            $released | Should -Not -BeNullOrEmpty -Because "the changelog is the release log and must list the release the script ships"
            $released[0] | Should -BeExactly $script:VersionOfRecord -Because "the version bump writes the changelog entry and the script variable together, so the two naming different releases is the bump arriving half-finished"
        }

        It "the changelog names a release before the version of record" {
            $released = Get-ReleasedVersions
            $released.Count | Should -BeGreaterThan 1 -Because "the previous-release claims in the docs are checked against the changelog's second entry, which requires one"
        }
    }

    Context "Current-version claims" {
        It "no tracked line calls a superseded version the current one" {
            $offenders = foreach ($doc in $script:TrackedDocs) {
                foreach ($claim in (Get-AdjacentVersionClaims -Lines (Get-DocLines $doc) -Expected $script:VersionOfRecord)) {
                    "${doc}: ${claim}"
                }
            }

            $offenders | Should -BeNullOrEmpty -Because "a reader has no way to tell a page that rotted from one that is current, and the version is the one fact every release surface must repeat"
        }

        It "every current-version heading introduces the version of record" {
            $offenders = foreach ($doc in $script:TrackedDocs) {
                foreach ($claim in (Get-HeadingVersionClaims -Lines (Get-DocLines $doc) -Expected $script:VersionOfRecord -Marker $script:CurrentMarker)) {
                    "${doc}: ${claim}"
                }
            }

            $offenders | Should -BeNullOrEmpty -Because "a heading that says which version is current and then names another one is the failure this file exists for"
        }

        It "every previous-version heading introduces the release before the version of record" {
            $released = Get-ReleasedVersions
            $offenders = foreach ($doc in $script:TrackedDocs) {
                foreach ($claim in (Get-HeadingVersionClaims -Lines (Get-DocLines $doc) -Expected $released[1] -Marker $script:PreviousMarker)) {
                    "${doc}: ${claim}"
                }
            }

            $offenders | Should -BeNullOrEmpty -Because "bumping the current version without moving the previous one leaves the page claiming a release never existed"
        }
    }

    Context "Tolerated shapes" {
        It "a version far from any marker word is prose, not a claim" {
            $line = '| v2.4.2.0 | 2026-07-21 | Brave 1.92.141 (Chromium 150.0.7871.128) compatibility validation; the current stable line has since moved on |'
            $claims = Get-AdjacentVersionClaims -Lines @($line) -Expected $script:VersionOfRecord

            $claims | Should -BeNullOrEmpty -Because "a superseded release described inside a changelog row is history, and a window wide enough to reach it would report every release ever shipped as a false claim"
        }

        It "a build number next to a marker is not a release claim" {
            $line = 'Current release: 151 policies across 5 hardening tiers, validated against Brave 1.96.59 (Chromium 154.0.8037.58).'
            $claims = Get-AdjacentVersionClaims -Lines @($line) -Expected $script:VersionOfRecord

            $claims | Should -BeNullOrEmpty -Because "the version token requires the project prefix, so the validated Chromium build the claim legitimately names is not read as the project version"
        }

        It "a heading without the noun makes no claim about a version" {
            $lines = @(
                '<h2 class="text-3xl">Her Daim Guncel</h2>',
                '<p>v2.4.2.0 shipped the last upstream template refresh.</p>'
            )
            $claims = Get-HeadingVersionClaims -Lines $lines -Expected $script:VersionOfRecord -Marker $script:CurrentMarker

            $claims | Should -BeNullOrEmpty -Because "a lifecycle slogan that happens to contain the marker word names no version, and reading it as one would fail every slogan heading in the tree"
        }
    }

    Context "Changelog projection parity" {
        It "the root changelog's release set is covered by the wiki changelog" {
            $root = Get-ExtractedVersions -Path (Join-Path $ProjectRoot "CHANGELOG.md") -HeadingPattern '^##\s*\[(v\d+(\.\d+){2,3})\]'
            $wiki = Get-ExtractedVersions -Path (Join-Path $ProjectRoot "Wiki\Changelog.md") -HeadingPattern '^###\s+(v\d+(\.\d+){2,3})'

            $root | Should -Not -BeNullOrEmpty -Because "the root changelog is the release log and the wiki is its projection, so the source must be readable"
            $missing = @($root | Where-Object { $_ -notin $wiki })
            $missing | Should -BeNullOrEmpty -Because "a release the root names but the wiki omits is a published gap that reads exactly like a release that never happened"
        }

        It "the wiki changelog names no release the root changelog never held" {
            $root = Get-ExtractedVersions -Path (Join-Path $ProjectRoot "CHANGELOG.md") -HeadingPattern '^##\s*\[(v\d+(\.\d+){2,3})\]'
            $wiki = Get-ExtractedVersions -Path (Join-Path $ProjectRoot "Wiki\Changelog.md") -HeadingPattern '^###\s+(v\d+(\.\d+){2,3})'

            $extra = @($wiki | Where-Object { $_ -notin $root })
            $extra | Should -BeNullOrEmpty -Because "the wiki is a projection and never a second source, so an entry only the wiki holds is a phantom release no build ever shipped"
        }

        It "the three-part and four-part spellings of one release compare equal" {
            (ConvertTo-FourPartVersion 'v2.1.6') | Should -BeExactly 'v2.1.6.0' -Because "the root spells this release in three parts and the wiki in four, and reading them as two would report a false gap"
            (ConvertTo-FourPartVersion 'v2.1.6.0') | Should -BeExactly 'v2.1.6.0' -Because "the four-part spelling is canonical and must pass through unchanged"
        }
    }
}
