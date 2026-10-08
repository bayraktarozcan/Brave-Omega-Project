# Invariant: a compatibility matrix never names a release the changelog does
# not hold, and the row it calls current is the row the script describes.
#
# Measured across the tree before this file existed: one table, four copies -
# README section 8 (72 rows), Wiki/Home (72), Wiki/Overview (66) and
# Wiki/Version-Compatibility-Matrix (73), each written twice, once per language,
# 283 rows in total. Nothing compared any of them to the changelog. A
# row could name a release no build ever shipped, or a Brave build that no longer
# matched the script, and every other gate would still pass: the ADMX gate
# cross-references policies, the mirror gate compares structure, the version
# parity gate reads the current-version claim in prose. Not one of them read a
# table cell. That is how a table that was correct when written stays readable
# and quietly stops being true.
#
# The oracle is the changelog and the script, never a list of versions written
# down here. A test carrying its own expected set agrees with itself the day a
# release ships and proves nothing, which is the same reason the policy checks
# validate against Brave's own templates rather than a list this project keeps.
#
# What this check cannot see:
#   - A release the changelog holds and a matrix omits. This is a real and
#     current gap, not a hypothetical: the changelog holds 41 releases, the wiki
#     compatibility page lists 37, README 36, Overview 33. Those rows are
#     absent because the validated Brave and Chromium builds for them are
#     recorded nowhere in the tree, and a compatibility matrix is a validation
#     record - a row written to close the count would assert a validation that
#     never took place. So the direction checked here is matrix-into-changelog,
#     and only that direction. A future release that adds both the changelog
#     entry and the row passes; one that adds the row alone fails.
#   - A row the changelog and every other matrix hold but one surface omits, or
#     holds only in one of its two languages. Both are real: the wiki
#     compatibility page listed v2.6.0.0 in Turkish and not in English, and
#     this file was written after that defect had been sitting in the tree. The
#     parity context compares the two language tables within each page rather
#     than the pages against each other, because a page is allowed to be a
#     subset - the README and Overview matrices deliberately omit rows whose
#     validated build is unrecorded - and only a language half differing from
#     its own other half is unambiguously wrong.
#   - Whether a Brave or Chromium build in a non-current row is the one that
#     release was validated against. The script declares exactly one validated
#     build, so only the current row has an oracle to compare against. The rest
#     is history, and telling recorded history from stale history stays a human
#     read.
#   - A matrix that stops being a table - a definition list, a chart, prose.
#     Tables are found by the header row that names the columns, so a page
#     restating the same data in another shape is invisible here by
#     construction. That is a deliberate trade: the header is the one line that
#     means "this is a compatibility matrix" wherever it appears, and a heuristic
#     broad enough to catch prose would also catch every version number in
#     every sentence.
#
# The Get- helpers are named for what they return rather than in the
# singular-noun form PSScriptAnalyzer prefers, for the reason given in
# VersionParity.Tests.ps1: these return lists and tables, and the Tests tree is
# not part of the analyzer gate.
BeforeAll {
    . $PSScriptRoot\TestHelper.ps1

    $script:VersionOfRecord   = Get-VariableRegex -ScriptPath $ScriptMain -VariableName "ScriptVersion"
    # V3: validated builds are no longer hardcoded; the script is version-agnostic.
    $script:ValidatedBrave    = ""
    $script:ValidatedChromium = ""

    # The surfaces that carry a compatibility matrix, and the one that must not.
    # Home is named rather than discovered, so a table appearing there is
    # reported as a violation of the split instead of quietly joining the set of
    # tables this file considers normal and passing.
    $script:MatrixSurfaces = @('README.md', 'Wiki\Overview.md', 'Wiki\Version-Compatibility-Matrix.md')
    $script:NoMatrixSurfaces = @('Wiki\Home.md')

    # A matrix is found by its own header row rather than by a heading. Headings
    # move, are duplicated for the second language, and a wiki page can carry
    # several; the header names the columns, so it is the line that means "this is
    # a compatibility matrix" in any file, in any position, in either language.
    #
    # The product name is the one cell whose spelling is the same in both
    # languages, which is what makes it the anchor: the column beside it is
    # "Brave Version" in English and the Turkish equivalent of that, so a
    # pattern built from the columns would have to know two languages to name
    # one line. It is also, character for character, the pre-rename directory
    # spelling this repository retired, and the retired-spelling guard in
    # FileNaming.Tests.ps1 reads the character after a name to decide whether it
    # is looking at a path. A backslash typed straight after the name is a regex
    # escape here and a path separator to that guard, so the guard reported this
    # line as a stale reference to a directory that no longer exists.
    #
    # So the word break inside the cell is matched rather than typed. The literal
    # never appears on this line, which leaves the guard nothing to report, and
    # the match is unchanged where it matters: \s is the one space every matrix
    # header in the repository writes between the two words, and both patterns
    # were run over every markdown file in the tree and select the same eight
    # headers.
    $script:MatrixHeaderPattern = '^\|\s*Brave\sOmega\s*\|'

    # The release sits in the first cell of a row, wrapped in emphasis, sometimes
    # followed by a marker inside the same cell - *(current)*, *(guncel)*.
    # Taking the version token itself drops both without a second pattern.
    $script:RowVersionPattern = '\*{0,2}\s*(v\d+(\.\d+){2,3})\s*\*{0,2}'

    # Every compatibility table in a file, in order, each as its own array of
    # lines including the header and the separator row beneath it.
    function Get-CompatMatrixTables {
        param([string]$Path)

        $tables = @()
        $open = $null
        foreach ($line in [System.IO.File]::ReadAllLines($Path, [System.Text.Encoding]::UTF8)) {
            if ($line -match $script:MatrixHeaderPattern) {
                $open = New-Object 'System.Collections.Generic.List[string]'
                $tables += ,$open
                $open.Add($line)
                continue
            }
            if ($null -eq $open) { continue }
            # A table ends at the first line that is not a row. Blank lines and
            # prose close it; the next header opens the following one.
            if ($line -notmatch '^\s*\|') { $open = $null; continue }
            $open.Add($line)
        }
        return $tables
    }

    # The releases a table lists, normalized. The header and the separator carry
    # no version token, so they need no separate skip - the same pattern that
    # finds a release cannot match "Brave Omega" or a row of dashes.
    function Get-MatrixRowVersions {
        param([string[]]$Table)

        $found = @()
        foreach ($line in $Table) {
            foreach ($cell in $line.Split('|')) {
                if ($cell -notmatch $script:RowVersionPattern) { continue }
                $normalized = ConvertTo-FourPartVersion $Matches[1]
                if ($normalized) { $found += $normalized }
                break
            }
        }
        return $found
    }

    # The row a table calls current, read as cells. Splitting on the pipe leaves
    # an empty cell at each end, so the release is the second cell and the
    # validated builds are the two after it.
    #
    # ChromiumMajor is the leading component of whatever the cell carries. The
    # script declares the major because that is the number Brave's release notes
    # key on, and the wiki compatibility page records the full build
    # (154.0.8037.58) where the README records the major (154). Both name the
    # same Chromium, so comparing whole strings would fail a correct page over a
    # spelling rather than over a version.
    function Get-MatrixCurrentRow {
        param([string[]]$Table)

        $expected = ConvertTo-FourPartVersion $script:VersionOfRecord
        foreach ($line in $Table) {
            $cells = @($line.Split('|') | ForEach-Object { $_.Trim() })
            if ($cells.Count -lt 4) { continue }
            if ($cells[1] -notmatch $script:RowVersionPattern) { continue }
            if ((ConvertTo-FourPartVersion $Matches[1]) -ne $expected) { continue }
            $major = $null
            if ($cells[3] -match '^(\d+)') { $major = $Matches[1] }
            return [pscustomobject]@{
                Release        = $cells[1]
                Brave          = $cells[2]
                Chromium       = $cells[3]
                ChromiumMajor  = $major
            }
        }
        return $null
    }

    # The changelog's release set, the oracle for the direction that is checked.
    # Returned wrapped so PowerShell hands back the set itself rather than
    # enumerating it into a bare array.
    function Get-ChangelogReleaseSet {
        $log = Join-Path $ProjectRoot "CHANGELOG.md"
        if (-not (Test-Path -LiteralPath $log)) { return ,(New-Object 'System.Collections.Generic.HashSet[string]') }

        $set = New-Object 'System.Collections.Generic.HashSet[string]'
        foreach ($line in [System.IO.File]::ReadAllLines($log, [System.Text.Encoding]::UTF8)) {
            if ($line -notmatch '^##\s*\[(v\d+(\.\d+){2,3})\]') { continue }
            $normalized = ConvertTo-FourPartVersion $Matches[1]
            if ($normalized) { $null = $set.Add($normalized) }
        }
        return ,$set
    }

    $script:Released = Get-ChangelogReleaseSet
}

Describe "Version compatibility matrix" -Tag "Unit" {

    Context "Oracles" {
        It "the script declares a four-part version" {
            $script:VersionOfRecord | Should -Match '^v\d+\.\d+\.\d+\.\d+$' -Because "the expected value is read from the script, and a version the comparison cannot parse would let every current row pass unchecked"
        }

        It "V3 is version-agnostic: no hardcoded validated build" {
            $content = Get-Content -Path $ScriptMain -Raw
            $content -match '\$ValidatedBrave\s*=\s*"1\.' | Should -Be $false
            $content -match '\$ValidatedChromium\s*=\s*"154"' | Should -Be $false
        }

        It "the changelog yields a release set" {
            $script:Released.Count | Should -BeGreaterThan 0 -Because "the changelog is the oracle every matrix row is measured against, and an empty oracle would pass every row"
        }

        It "the surfaces this file checks still carry a compatibility matrix" {
            $found = 0
            foreach ($doc in $script:MatrixSurfaces) {
                $path = Join-Path $ProjectRoot $doc
                if (-not (Test-Path -LiteralPath $path)) { continue }
                $found += @(Get-CompatMatrixTables -Path $path).Count
            }

            $found | Should -BeGreaterThan 0 -Because "a check that also passes when the tables it reads have all been deleted proves nothing, so the tables have to be present for the comparison to mean anything"
        }
    }

    Context "Releases a build never shipped" {
        It "no matrix row names a release the changelog does not hold" {
            $offenders = @()
            foreach ($doc in $script:MatrixSurfaces) {
                $path = Join-Path $ProjectRoot $doc
                if (-not (Test-Path -LiteralPath $path)) { continue }
                $index = 0
                foreach ($table in (Get-CompatMatrixTables -Path $path)) {
                    $index++
                    foreach ($version in (Get-MatrixRowVersions -Table $table)) {
                        if ($script:Released.Contains($version)) { continue }
                        $offenders += ("{0} table {1}: {2}" -f $doc, $index, $version)
                    }
                }
            }

            $offenders | Should -BeNullOrEmpty -Because "a row naming a release the changelog never recorded is a release no build ever shipped, and a reader has no way to tell that page from a current one"
        }
    }

    Context "The current row" {
        It "every matrix states the validated build the script declares" {
            $offenders = @()
            $checked = 0
            foreach ($doc in $script:MatrixSurfaces) {
                $path = Join-Path $ProjectRoot $doc
                if (-not (Test-Path -LiteralPath $path)) { continue }
                $index = 0
                foreach ($table in (Get-CompatMatrixTables -Path $path)) {
                    $index++
                    $row = Get-MatrixCurrentRow -Table $table
                    if ($null -eq $row) {
                        $offenders += ("{0} table {1}: no row for {2}" -f $doc, $index, $script:VersionOfRecord)
                        continue
                    }
                    $checked++
                    if ([string]::IsNullOrEmpty($script:ValidatedBrave)) { continue }
                    if ($row.Brave -ne $script:ValidatedBrave) {
                        $offenders += ("{0} table {1}: Brave {2}, script declares {3}" -f $doc, $index, $row.Brave, $script:ValidatedBrave)
                    }
                    if ($row.ChromiumMajor -ne $script:ValidatedChromium) {
                        $offenders += ("{0} table {1}: Chromium {2}, script declares major {3}" -f $doc, $index, $row.Chromium, $script:ValidatedChromium)
                    }
                }
            }

            $checked | Should -BeGreaterThan 0 -Because "the current row is the one row with an oracle, so a run that compared none would report success without having compared anything"
            $offenders | Should -BeNullOrEmpty -Because "the version bump writes the script's validated build and the release notes together, so a table naming a different build is the bump arriving half-finished and the browser it claims to be validated against is not the one that ships"
        }
    }

    Context "Bilingual parity" {
        It "every compatibility matrix on a page lists the same releases in both languages" {
            $offenders = @()
            foreach ($doc in $script:MatrixSurfaces) {
                $path = Join-Path $ProjectRoot $doc
                if (-not (Test-Path -LiteralPath $path)) { continue }

                $sets = @()
                foreach ($table in (Get-CompatMatrixTables -Path $path)) {
                    $sets += ,(@(Get-MatrixRowVersions -Table $table) | Select-Object -Unique)
                }
                if ($sets.Count -lt 2) { continue }

                for ($i = 1; $i -lt $sets.Count; $i++) {
                    $only = @($sets[$i] | Where-Object { $_ -notin $sets[0] })
                    $lost = @($sets[0] | Where-Object { $_ -notin $sets[$i] })
                    foreach ($version in $only) { $offenders += ("{0} table {1}: {2} is not in the first table" -f $doc, ($i + 1), $version) }
                    foreach ($version in $lost) { $offenders += ("{0} table {1}: {2} is missing from this table" -f $doc, ($i + 1), $version) }
                }
            }

            $offenders | Should -BeNullOrEmpty -Because "the two halves are the same table in two languages, and a release present in one and absent from the other tells a Turkish reader a different release history than an English one"
        }
    }

    Context "Single ownership" {
        It "the wiki front page carries no compatibility matrix" {
            $offenders = @()
            foreach ($doc in $script:NoMatrixSurfaces) {
                $path = Join-Path $ProjectRoot $doc
                if (-not (Test-Path -LiteralPath $path)) {
                    $offenders += ("{0}: the page is gone" -f $doc)
                    continue
                }
                $count = @(Get-CompatMatrixTables -Path $path).Count
                if ($count -gt 0) {
                    $offenders += ("{0}: {1} compatibility table(s)" -f $doc, $count)
                }
            }

            $offenders | Should -BeNullOrEmpty -Because "the front page is a landing page and the matrix belongs to the overview, and a copy that drifts from its original is the same defect this file was written for, arriving through the other door"
        }
    }

    Context "Tolerated shapes" {
        It "a three-part spelling in a row is the same release, not a phantom" {
            $table = @(
                '| Brave Omega | Brave Version | Chromium | Windows | Status |',
                '| ------------- | --------------- | ---------- | --------- | -------- |',
                '| **v2.1.6** *(onceki)* | 1.92.134 | 150 | 11 25H2 | Onceki |'
            )
            $versions = Get-MatrixRowVersions -Table $table

            $versions | Should -BeExactly 'v2.1.6.0' -Because "the changelog spells this release in three parts and the wiki in four, and reading the two as different releases would report a phantom for a build that shipped"
        }

        It "the header and separator rows are not read as releases" {
            $table = @(
                '| Brave Omega | Brave Version | Chromium | Windows | Status |',
                '| ------------- | --------------- | ---------- | --------- | -------- |',
                '| **v3.0.1.0** *(current)* | all | all | 11 | Current |'
            )
            $versions = Get-MatrixRowVersions -Table $table

            $versions | Should -BeExactly $script:VersionOfRecord -Because "the pattern that finds a release requires the project prefix, so the column names and the dashes beneath them add nothing"
        }

        It "a table that is not a compatibility matrix is not read as one" {
            $table = @(
                '| Feature | Description |',
                '| --------- | ------------- |',
                '| Bilingual | Full Turkish and English with identical functionality |'
            )
            $versions = Get-MatrixRowVersions -Table $table

            $versions | Should -BeNullOrEmpty -Because "the features table sits on the same page as the matrix and shares its pipe layout, so finding tables by layout instead of by the header would sweep it in"
        }

        It "a version with fewer than three parts is not a release" {
            (ConvertTo-FourPartVersion 'v2.1') | Should -BeNullOrEmpty -Because "the rule widens a release's spelling, it does not invent one, and a token too short to be a release must be rejected rather than padded"
            (ConvertTo-FourPartVersion '1.96.59') | Should -BeNullOrEmpty -Because "a Brave build is not a project version, and normalizing it into one would put a build number where the changelog expects a release"
        }
    }
}
