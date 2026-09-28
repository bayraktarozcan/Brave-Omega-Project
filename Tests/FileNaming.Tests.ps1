BeforeAll {
    $ProjectRoot = Split-Path -Parent $PSScriptRoot

    # Directories whose name a tool or platform fixes in lowercase. One entry
    # remains, and it is a platform path rather than a style choice: GitHub
    # resolves .github case-sensitively. The three that used to sit here were
    # removed with the rename, because an exemption outlives its reason and an
    # allow list is the easiest way for a rule to stop being enforced without
    # anybody deciding to stop enforcing it.
    $script:LowercaseDirAllowList = @(
        ".github"
    )

    # Directories whose name may contain whitespace, and so exempt from the rule
    # that forbids it. The list is empty on purpose: a space in a tracked path
    # is not a style preference, it is a defect that has already cost this
    # repository one broken CI path, and an empty list is what makes the next
    # one fail by name instead of passing unnoticed.
    $script:WhitespaceDirAllowList = @()

    # Trees a tool or platform names for us, so no convention of ours applies
    # to anything inside them. Checked for existence below: a list that names a
    # tree which no longer exists is an exemption nobody can notice has rotted.
    $script:PlatformFixedTrees = @(
        ".github"
    )

    # Root files whose name a tool, a platform, or a legal convention fixes.
    $script:PlatformFixedRootFiles = @(
        ".editorconfig"
        ".gitattributes"
        ".gitignore"
        ".gitlab-ci.yml"
        "CODEOWNERS"
        "LICENSE"
        "NOTICE"
        "index.html"
    )

    # Directories we own, so their name must start with a capital.
    #
    # Docs is the one entry Git does not hold. It is the repository's local
    # reference folder, ignored on purpose and never committed, so it cannot be
    # reached through the tracked-path list above - but it is still a name this
    # project decided on, and the two directory tests below read it off the
    # filesystem, so it is policed rather than merely intended. A rule that only
    # covers what Git can see is a rule with a hole exactly where the files are
    # least likely to be reviewed.
    $script:OwnedDirectories = @(
        "ADMX"
        "Brave-Omega"
        "Brave-Omega\Profiles"
        "Brave-Omega\Docs"
        "Docs"
        "Enterprise"
        "Scripts"
        "Tests"
        "Wiki"
    )

    # The convention in force for files in a directory we own, and the files
    # already in the directory that predate it. A new file that does not match
    # is a defect; an existing exception is a known, named debt.
    #
    # Scripts carries no exception any more. Its four kebab-case files were the
    # whole of the declared debt, they were renamed together with the directory
    # they lived in, and leaving the list populated would have turned a paid debt
    # back into a standing permission.
    #
    # Extensions is optional and defaults to SourceExtensions. ADMX has to
    # declare its own because the two files Group Policy itself consumes are not
    # source, and without this the convention would be declared over a directory
    # it never actually looked at.
    $script:SourceFileConventions = @{
        "ADMX" = @{
            Convention   = "HyphenatedPascalCase"
            Extensions   = @(".ps1", ".admx", ".adml")
            Exceptions   = @()
            ExceptionWhy = ""
        }
        "Scripts" = @{
            Convention   = "HyphenatedPascalCase"
            Exceptions   = @()
            ExceptionWhy = ""
        }
        "Tests" = @{
            Convention   = "PascalCase"
            Exceptions   = @()
            ExceptionWhy = ""
        }
    }

    # Prose in a directory we own. PascalCase alone is not enough here: a
    # document name is a title, and the hyphen is what separates the words of
    # that title. Underscore-separated and lowercase drift are both defects,
    # so this convention is checked separately from the source convention.
    $script:DocumentFileConventions = @{
        "Brave-Omega/Docs" = @{
            Convention   = "HyphenatedPascalCase"
            Exceptions   = @()
            ExceptionWhy = ""
        }
        "Docs" = @{
            Convention   = "HyphenatedPascalCase"
            Exceptions   = @()
            ExceptionWhy = ""
        }
        "Wiki" = @{
            Convention   = "HyphenatedPascalCase"
            Exceptions   = @(
                "_Footer.md"
                "_Sidebar.md"
            )
            ExceptionWhy = "GitHub renders these two by the leading underscore; the wiki chrome names them, not us"
        }
    }

    # Data files whose lowercase name is a contract rather than a default.
    # Renaming either one would break every reader at once, so the name is
    # held deliberately and named here instead of being left to look like an
    # oversight.
    $script:DataContractNames = @(
        @{
            Path = "Brave-Omega/config.json"
            Why  = "loaded by name at runtime; the name is the contract between the script and the policy data layer"
        }
        @{
            Path = "Enterprise/levels.json"
            Why  = "read by the catalog generator, the tests, and the deploy scripts, all by name"
        }
    )

    $script:SourceExtensions = @(".ps1", ".psm1", ".py")

    # Extensions whose content is read as text by a check below. Anything else
    # is skipped rather than decoded, so a future binary asset cannot make a
    # naming check fail on the bytes instead of the name.
    $script:TextExtensions = @(
        ".md", ".ps1", ".psm1", ".py", ".json", ".yml", ".yaml"
        ".html", ".reg", ".admx", ".adml", ".xml", ".txt", ".gitignore"
        ".gitattributes", ".editorconfig"
    )

    # PascalCase: every dash- and underscore-separated segment starts with a
    # capital. That one test separates it from kebab-case and snake_case without
    # guessing at the letters that follow the capital.
    #
    # -cmatch, not -match, and that is load-bearing. PowerShell's case-insensitive
    # -match folds the range [A-Z] through the current culture, and under a
    # Turkish locale 'I' falls outside it, so 'I' -match '^[A-Z]' is False. A
    # case-insensitive check here would reject IgnoreRules.Tests.ps1 on a Turkish
    # machine and accept it on an English one. A gate that changes verdict with
    # the machine locale is not a gate.
    $script:IsPascalCase = {
        param([string]$Name)
        if ($Name -match '\s') { return $false }
        foreach ($segment in ($Name -split '[-_]')) {
            if ([string]::IsNullOrEmpty($segment)) { continue }
            if ($segment -cnotmatch '^[A-Z]') { return $false }
        }
        return $true
    }

    # snake_case: lowercase words joined by single underscores, no dashes.
    $script:IsSnakeCase = {
        param([string]$Name)
        if ($Name -match '\s') { return $false }
        return $Name -cmatch '^[a-z0-9]+(_[a-z0-9]+)*$'
    }

    # kebab-case: lowercase words joined by single dashes, no underscores.
    $script:IsKebabCase = {
        param([string]$Name)
        if ($Name -match '\s') { return $false }
        return $Name -cmatch '^[a-z0-9]+(-[a-z0-9]+)*$'
    }

    # HyphenatedPascalCase: the document convention. PascalCase, with hyphens
    # as the only separator, so a title reads as a title. The underscore is
    # excluded on purpose, which is what makes the two GitHub wiki chrome files
    # a named exception rather than a silent pass.
    $script:IsHyphenatedPascalCase = {
        param([string]$Name)
        if ($Name -match '[\s_]') { return $false }
        foreach ($segment in ($Name -split '-')) {
            if ([string]::IsNullOrEmpty($segment)) { continue }
            if ($segment -cnotmatch '^[A-Z0-9]') { return $false }
        }
        return $true
    }

    # UPPER with _ or - joining compounds: the root document convention. Both
    # separators are accepted because the platform fixes these names and does
    # not agree on one: GitHub's canonical spelling is CODE_OF_CONDUCT.md while
    # this repository's own release template is RELEASE-NOTE-TEMPLATE.md. The
    # rule that survives the platform is the casing, not the separator.
    $script:IsUpperCompound = {
        param([string]$Name)
        if ($Name -match '\s') { return $false }
        return $Name -cmatch '^[A-Z0-9]+([-_][A-Z0-9]+)*$'
    }

    $script:Testers = @{
        "PascalCase"           = $script:IsPascalCase
        "snake_case"           = $script:IsSnakeCase
        "kebab-case"           = $script:IsKebabCase
        "HyphenatedPascalCase" = $script:IsHyphenatedPascalCase
        "UPPER-COMPOUND"       = $script:IsUpperCompound
    }

    # A path that was renamed, the spelling that replaced it, and the tail that
    # completes the retired form. The spelling is stored without its separator
    # and the pattern is assembled from it, which is deliberate: written out in
    # full, this table would contain the very literals it is looking for, and
    # the file that declares the rule would be the first thing the rule
    # reported. Assembling the pattern keeps the table scannable, so a stale
    # reference typed into a comment here is still caught.
    #
    # The lookahead is not decoration either: index.html carries UTF-8 text as
    # literal \uXXXX escapes, so the product name in Turkish prose is followed
    # by a backslash that looks exactly like a path separator and is not one.
    # Without the guard, the check would either flag correct prose or be
    # loosened until it flagged nothing.
    #
    # A directory is not always written with a separator after it. Passed to
    # Join-Path as its own segment, it ends at the closing quote instead, and
    # that second shape was invisible to the rule below: this suite reported
    # green while two live references written that way were broken. Widening
    # the tail to accept a quote is not the answer, because an apostrophe is
    # also the Turkish possessive and a double quote also closes a JSON or
    # YAML value whose text ends with the product name - neither is a path, and
    # flagging them is how a guard gets loosened until it flags nothing. So the
    # whole-segment form is matched separately, and only on a line that is
    # building a path. The blind spot that leaves is named rather than hidden:
    # a bare segment written on a line carrying no path marker is not examined.
    $script:RetiredBareSegments = @(
        @{
            Retired = "Brave Omega"
            Current = "Brave-Omega"
            # Not a separator, so this form neither duplicates the prefix rule
            # nor reaches the escaped UTF-8 that the prefix tail has to look
            # past. Not a letter, and not an apostrophe followed by one, so the
            # Turkish possessive - where the suffix starts just past the mark -
            # does not end the segment either. Not a dot or a dash either, which
            # is what keeps a longer name from being cut in half: the retired
            # "admx" is a prefix of "admx-validate" and the retired "brave" is
            # the stem of "brave.admx", so a tail that stopped at the first dot
            # or hyphen would report the current spelling's own filenames and
            # the guard would be loosened until it meant nothing.
            Tail    = '(?![\\/])(?![A-Za-z0-9._-])(?!''\p{L})'
            Label   = "the pre-rename directory name"
        }
        @{
            Retired = "admx"
            Current = "ADMX"
            Tail    = '(?![\\/])(?![A-Za-z0-9._-])(?!''\p{L})'
            Label   = "the pre-rename policy-template directory name"
        }
        @{
            Retired = "scripts"
            Current = "Scripts"
            Tail    = '(?![\\/])(?![A-Za-z0-9._-])(?!''\p{L})'
            Label   = "the pre-rename automation directory name"
        }
        @{
            Retired = "docs"
            Current = "Docs"
            Tail    = '(?![\\/])(?![A-Za-z0-9._-])(?!''\p{L})'
            Label   = "the pre-rename local reference directory name"
        }
    )

    # A retired name has to begin a segment, not merely appear inside one.
    # Without this left edge the "brave" filename rules match the "admx" and
    # "adml" extensions of the current Brave.admx and Brave.adml, so the file
    # that was renamed into place would be reported as still carrying the old
    # name - and the honest response to that would have been to delete the
    # rules, which is how a guard dies quietly.
    $script:RetiredNameBoundary = '(?<![A-Za-z0-9._-])'

    # What counts as a line building a path. Cmdlet names and the script-root
    # variable, not the English word "path": prose that happens to mention a
    # path must not pull the product name back into scope.
    $script:PathConstructionPattern = 'Join-Path|Split-Path|Test-Path|Resolve-Path|PSScriptRoot|\.\.\\'

    $script:RetiredPathSpellings = @(
        @{
            Retired = "Brave Omega"
            Current = "Brave-Omega"
            Tail    = '[\\/](?![uU][0-9a-fA-F]{4})'
            Label   = "the pre-rename directory name"
        }
        @{
            Retired = "policy-catalog"
            Current = "Policy-Catalog"
            Tail    = '\.md'
            Label   = "the pre-rename catalog filename"
        }
        @{
            Retired = "admx"
            Current = "ADMX"
            Tail    = '[\\/]'
            Label   = "the pre-rename policy-template directory name"
        }
        @{
            Retired = "scripts"
            Current = "Scripts"
            Tail    = '[\\/]'
            Label   = "the pre-rename automation directory name"
        }
        # The local reference folder has no prefix entry, and that is a decision
        # rather than an oversight. docs/ is also a branch prefix - the branch
        # table in AGENTS.md reads docs/<description>, next to feat/ and fix/,
        # and a namespace this repository owns is not made to match a folder this
        # repository happens to keep outside it. A rule here would either demand
        # a branch namespace change that the conventions section did not ask for,
        # or be widened until it stopped firing. The whole-segment form below
        # still covers the directory wherever a path is actually built, and the
        # directory-name tests cover the folder itself, so nothing about the
        # rename goes unchecked; what is declined is a rule that could not be
        # satisfied honestly.
        #
        # The tails below carry a right-hand boundary so a match ends with the
        # filename rather than merely containing it. Two of the retired names are
        # prefixes of others - the archive stem and the one the validator script
        # was called - and a shorter stem with an open right edge would report
        # the very files that carry the new spelling.
        @{
            Retired = "admx-validate"
            Current = "ADMX-Validate.ps1"
            Tail    = '\.ps1(?![A-Za-z0-9._-])'
            Label   = "the pre-rename validator filename"
        }
        @{
            Retired = "brave"
            Current = "Brave.admx"
            Tail    = '\.admx(?![A-Za-z0-9._-])'
            Label   = "the pre-rename ADMX template filename"
        }
        @{
            Retired = "brave"
            Current = "Brave.adml"
            Tail    = '\.adml(?![A-Za-z0-9._-])'
            Label   = "the pre-rename ADML template filename"
        }
        @{
            Retired = "deploy-brave-omega"
            Current = "Deploy-Brave-Omega.ps1"
            Tail    = '\.ps1(?![A-Za-z0-9._-])'
            Label   = "the pre-rename deploy script filename"
        }
        @{
            Retired = "detect-brave-omega"
            Current = "Detect-Brave-Omega.ps1"
            Tail    = '\.ps1(?![A-Za-z0-9._-])'
            Label   = "the pre-rename detect script filename"
        }
        @{
            Retired = "mojibake-scan"
            Current = "Mojibake-Scan.py"
            Tail    = '\.py(?![A-Za-z0-9._-])'
            Label   = "the pre-rename mojibake scanner filename"
        }
        @{
            Retired = "verify-mirror-sync"
            Current = "Verify-Mirror-Sync.ps1"
            Tail    = '\.ps1(?![A-Za-z0-9._-])'
            Label   = "the pre-rename mirror verifier filename"
        }
    )

    # Files whose whole purpose is to record what was true at an earlier
    # version. A path inside one of these is history rather than a reference,
    # and rewriting it would falsify the record instead of fixing anything.
    $script:HistoricalRecordFiles = @(
        "CHANGELOG.md"
        "Wiki/Changelog.md"
    )

    # Regions inside a current file that also project a past release. Keyed on
    # the marker that identifies them, so a region that stops being historical
    # has to be re-declared rather than quietly kept.
    $script:HistoricalLineRegions = @(
        @{
            File        = "Brave-Omega/BraveOmega.ps1"
            Why         = "the per-version release notes in the script header record the repository as it stood at each version"
            StartMarker = '^\s*#\s*CHANGELOG \('
            EndsAt      = "firstNonComment"
        }
        @{
            File        = "index.html"
            Why         = "a changelog row and its translation strings are a published projection of the changelog"
            LinePattern = 'cl_v\d'
        }
    )

    # Lines that keep a retired name because the name belongs to something this
    # repository does not own. The published archive is named by the vendor, so
    # its template keeps the vendor's spelling; rewriting it here would break
    # the exact comparison the step exists to perform, which is the opposite of
    # what a retired-spelling rule is for.
    #
    # This cannot be solved by pattern, and saying why is the point. The rule
    # asks whether a file names a path in this repository that no longer exists,
    # and nothing in the text of the line distinguishes `-Filter "brave.admx"`
    # over an extracted remote directory from a filter over a local file of the
    # same name. A context pattern wide enough to tell them apart - anything
    # mentioning the archive - would go on exempting whatever is written on that
    # line later, including a stale local path added by a later edit, and an
    # exemption that grows is worse than no exemption at all.
    #
    # So the exemption is declared one line at a time, with the reason, and each
    # declared line is asserted to still be present exactly once. A line that is
    # deleted or rewritten fails the check rather than leaving the exemption
    # silently covering a line that no longer means what it did.
    $script:ExternalNameLines = @(
        @{
            File   = ".github/workflows/admx-validate.yml"
            Anchor = '-Recurse -Filter "brave.admx"'
            Why    = "the filter runs over the directory extracted from the vendor's published archive, where the file carries the vendor's own lowercase name"
        }
        @{
            File   = ".github/workflows/admx-validate.yml"
            Anchor = 'Remote package contains no brave.admx'
            Why    = "a warning reporting the vendor's archive contents, which names the vendor's file so the reader can tell which file was not found"
        }
        @{
            File   = ".github/workflows/admx-validate.yml"
            Anchor = 'Remote brave.admx carries no version comment'
            Why    = "the same vendor-side filename, reported because the version it should carry could not be read"
        }
    )

    # Lines inside this file that have to name a retired spelling in order to
    # exist. A rule that cannot name what it forbids cannot be written: the
    # retired and current spellings are the rule's own data, the fixture that
    # proves the rule still fires is a live path written the retired way, and
    # the prose that explains why the rule is shaped this way quotes it.
    #
    # The scan above used to leave these unreported on the argument that the
    # two matcher forms were gated so a declaration could not match - the
    # prefix form needs a trailing separator, the bare form needs a path being
    # built, and a declaration is neither. That argument held for a token set
    # of bare words and stopped holding the moment a rule's Retired value is
    # itself a path, because the data of a rename is a spelling. A file that
    # cannot mention the old name also cannot state what it retired, so the
    # gate was tightened until it reported the rule's own source.
    #
    # So the file is not exempt and nothing here is exempt by category. Each
    # line is declared on its own, with the reason it has to carry the name, and
    # a stale reference written anywhere else in this file is still reported, so
    # what is exempt here is a list of known lines rather than a hole.
    #
    # The anchors are not required to occur once. Writing an anchor into this
    # declaration is what puts a second copy of it in the file, so a count of
    # one is not reachable and is not asserted. What is asserted instead is that
    # the line the anchor names still carries a retired spelling - a rewording
    # that quietly made a declaration unnecessary fails there - and that the
    # guard's own report over the repository comes back empty.
    $script:RuleDeclarationLines = @(
        @{
            File   = "Tests/FileNaming.Tests.ps1"
            Anchor = 'the stem of "brave.admx"'
            Why    = "prose explaining that the vendor extension is matched whole, which has to quote the extension it is describing"
        }
        @{
            File   = "Tests/FileNaming.Tests.ps1"
            Anchor = 'nothing in the text of the line distinguishes'
            Why    = "prose explaining why the external-name exemption cannot be written as a pattern, which quotes the anchor it is arguing about"
        }
        @{
            File   = "Tests/FileNaming.Tests.ps1"
            Anchor = '-Recurse -Filter "brave.admx"'
            Why    = "the declared text this file matches against the workflow, and the workflow spells the vendor's file in lower case on purpose"
        }
        @{
            File   = "Tests/FileNaming.Tests.ps1"
            Anchor = 'Remote package contains no brave.admx'
            Why    = "the second vendor-side anchor, which is also a lower-case vendor filename in the workflow it is matched against"
        }
        @{
            File   = "Tests/FileNaming.Tests.ps1"
            Anchor = 'Remote brave.admx carries no version comment'
            Why    = "the third vendor-side anchor, the same lower-case vendor filename in its third reported message"
        }
        @{
            File   = "Tests/FileNaming.Tests.ps1"
            Anchor = 'retired "brave" followed by an extension'
            Why    = "prose listing the retired stems the new filenames are built from, which cannot name them without naming them"
        }
        @{
            File   = "Tests/FileNaming.Tests.ps1"
            Anchor = 'run: ./admx/admx-validate.ps1'
            Why    = "a local path in this repository's own workflow, held as the counter-example proving the vendor exemption does not widen to cover it"
        }
    )

    $script:GetTrackedFiles = {
        & git -C $ProjectRoot ls-files | Sort-Object
    }

    # Which rules report this line. One definition, because the guard that
    # reports a retired name and the tests that assert which lines the guard is
    # allowed to skip have to agree on what "carries a retired name" means.
    # Two copies of the matcher would drift, and the drift would stay invisible
    # until the two disagreed about a real file - at which point the disagreement
    # looks like either a false alarm or a missed reference, and neither is
    # cheap to tell apart from the other.
    $script:GetRetiredNameHit = {
        param([string] $Line)

        $hits = @()
        foreach ($rule in $script:RetiredPathSpellings) {
            $pattern = $script:RetiredNameBoundary + [regex]::Escape($rule.Retired) + $rule.Tail
            if ($Line -cmatch $pattern) { $hits += @{ Rule = $rule; Form = "prefix" } }
        }
        if ($Line -cmatch $script:PathConstructionPattern) {
            foreach ($rule in $script:RetiredBareSegments) {
                $pattern = $script:RetiredNameBoundary + [regex]::Escape($rule.Retired) + $rule.Tail
                if ($Line -cmatch $pattern) { $hits += @{ Rule = $rule; Form = "segment" } }
            }
        }
        $hits
    }

    # The declaration list's own line range, located so the checks below can
    # tell a declaration from a use. A declared anchor is always written into
    # the entry that names it, so searching for the anchor finds that entry as
    # well as the line it exempts - and a check that stops at "some line
    # carrying this anchor carries a retired name" is satisfied by the entry
    # alone, which is the shape of a test that cannot fail. Both ends are found
    # by marker and the markers are asserted by a test below, so a block that
    # moved or changed shape fails here rather than quietly narrowing the
    # search until the check reports nothing and passes.
    $script:GetRuleDeclarationBlock = {
        $lines = [System.IO.File]::ReadAllLines((Join-Path $ProjectRoot "Tests/FileNaming.Tests.ps1"))
        $start = -1
        for ($i = 0; $i -lt $lines.Length; $i++) {
            if ($lines[$i] -cmatch '^\s*\$script:RuleDeclarationLines\s*=\s*@\(\s*$') { $start = $i; break }
        }
        if ($start -lt 0) { return @() }
        $end = -1
        for ($i = $start + 1; $i -lt $lines.Length; $i++) {
            if ($lines[$i] -cmatch '^\s{4}\)\s*$') { $end = $i; break }
        }
        if ($end -lt 0) { return @() }
        return @(($start + 1), ($end + 1))
    }

    # Every line of a tracked file that carries a retired name, with its number
    # and the rules that fire on it. Regions and exemptions are deliberately not
    # applied here: the tests need to see the lines the guard skips in order to
    # assert that each skip is declared, and that is the one thing the guard
    # cannot report about itself. Pass an inclusive two-number range to leave a
    # span out, which is how a use is told apart from the declaration naming it.
    $script:GetLinesCarryingRetiredNames = {
        param([string] $Path, [int[]] $Exclude)

        $lines = [System.IO.File]::ReadAllLines((Join-Path $ProjectRoot $Path))
        for ($i = 0; $i -lt $lines.Length; $i++) {
            $number = $i + 1
            if ($Exclude -and $Exclude.Count -eq 2 -and $number -ge $Exclude[0] -and $number -le $Exclude[1]) { continue }
            $hits = @(& $script:GetRetiredNameHit $lines[$i])
            if ($hits.Count -gt 0) {
                [pscustomobject]@{ Line = $number; Text = $lines[$i]; Hits = $hits }
            }
        }
    }

    # Every retired spelling still present in a file that describes the present
    # rather than the past, as "path line N: retired-spelling". The historical
    # exemptions are applied here so the rule itself stays a plain question:
    # does a live file name a path that no longer exists?
    $script:GetRetiredSpellingOffenders = {
        $offenders = @()

        foreach ($path in (& $script:GetTrackedFiles)) {
            $extension = [System.IO.Path]::GetExtension($path)
            if ($extension -and ($script:TextExtensions -cnotcontains $extension)) { continue }

            $region = $null
            foreach ($entry in $script:HistoricalLineRegions) {
                if ($entry.File -ceq $path) { $region = $entry }
            }

            $lines = [System.IO.File]::ReadAllLines((Join-Path $ProjectRoot $path))

            if ($script:HistoricalRecordFiles -ccontains $path) { continue }

            $inRegion = $false
            $regionSeen = $false

            for ($i = 0; $i -lt $lines.Length; $i++) {
                $line = $lines[$i]

                if ($null -ne $region) {
                    if ($region.ContainsKey("LinePattern")) {
                        if ($line -cmatch $region.LinePattern) { continue }
                    }
                    else {
                        if (-not $regionSeen -and $line -cmatch $region.StartMarker) {
                            $regionSeen = $true
                            $inRegion = $true
                            continue
                        }
                        if ($inRegion) {
                            $trimmed = $line.Trim()
                            if ($trimmed -eq "" -or $trimmed -cmatch '^#') { continue }
                            $inRegion = $false
                        }
                    }
                }

                # The line declares a name this repository does not own. Skipped
                # as a whole line rather than by rule, because the retired spelling
                # on it belongs to the vendor's archive and is not ours to change.
                $isExternal = $false
                foreach ($entry in $script:ExternalNameLines) {
                    if ($entry.File -ceq $path -and $line.Contains($entry.Anchor)) { $isExternal = $true }
                }
                if ($isExternal) { continue }

                # The same question, asked of this file's own rule text. A rule
                # names what it retired, so its declarations, the fixture that
                # proves it still fires, and the prose describing its shape all
                # carry the old spelling by construction rather than by
                # oversight. Declared per line above, and only per line: a stale
                # reference written anywhere else in this file is still
                # reported, so what is exempt here is a list of known lines and
                # not this file.
                $isRuleDeclaration = $false
                foreach ($entry in $script:RuleDeclarationLines) {
                    if ($entry.File -ceq $path -and $line.Contains($entry.Anchor)) { $isRuleDeclaration = $true }
                }
                if ($isRuleDeclaration) { continue }

                # The report is the same for either form, so a stale reference
                # reads the same whether it was written as a prefix or as a
                # segment, and the line itself is shown rather than the matcher:
                # a report that hands the reader the pattern tells them what to
                # fix by naming the matcher, and showing the text is what they
                # actually have to edit. Trimmed inside the subexpression,
                # because "$line.Trim()" interpolates the method name and points
                # the reader at a line that ends in a call to it.
                foreach ($hit in @(& $script:GetRetiredNameHit $line)) {
                    $offenders += "$path line $($i + 1): $($hit.Rule.Label) is retired, now '$($hit.Rule.Current)' -- $($line.Trim())"
                }
            }
        }

        $offenders
    }

    $script:GetTrackedDirectories = {
        & git -C $ProjectRoot ls-files |
            ForEach-Object { Split-Path -Parent $_ } |
            Where-Object { $_ } |
            Sort-Object -Unique
    }
}

Describe "Repository file and directory naming" -Tag "Unit" {
    Context "Directory names" {
        It "no tracked directory starts with a lowercase letter outside the allow list" {
            $offenders = foreach ($dir in (& $script:GetTrackedDirectories)) {
                $leaf = Split-Path -Leaf $dir
                if ($leaf -cnotmatch '^[a-z]') { continue }
                $allowed = $false
                foreach ($entry in $script:LowercaseDirAllowList) {
                    # Ordinal, not the culture-sensitive default. A Turkish
                    # locale folds I and i together under the default comparer,
                    # so a case-folding comparison here would quietly widen the
                    # exemption to directories it was never granted for.
                    if ($dir -ceq $entry -or $dir.StartsWith("$entry\", [System.StringComparison]::Ordinal)) {
                        $allowed = $true
                        break
                    }
                }
                if (-not $allowed) { $dir }
            }

            $offenders | Should -BeNullOrEmpty -Because "a lowercase directory name is a defect, and any exemption must be declared in the allow list above"
        }

        It "every allow-listed lowercase directory still exists" {
            foreach ($entry in $script:LowercaseDirAllowList) {
                Test-Path -LiteralPath (Join-Path $ProjectRoot $entry) |
                    Should -BeTrue -Because "$entry is exempt from the capitalisation rule, so its removal must be noticed"
            }
        }

        It "no tracked directory name contains whitespace" {
            $offenders = foreach ($dir in (& $script:GetTrackedDirectories)) {
                foreach ($segment in ($dir -split '[\\/]')) {
                    if ($segment -notmatch '\s') { continue }
                    if ($script:WhitespaceDirAllowList -ccontains $dir) { continue }
                    $dir
                }
            }

            $offenders | Sort-Object -Unique | Should -BeNullOrEmpty -Because "a space in a tracked path is a defect, not a style choice: it has to be quoted in every reference and it has already broken one CI path in this repository"
        }

        It "every allow-listed whitespace directory still exists" {
            foreach ($entry in $script:WhitespaceDirAllowList) {
                Test-Path -LiteralPath (Join-Path $ProjectRoot $entry) |
                    Should -BeTrue -Because "$entry is exempt from the whitespace rule, so its removal must be noticed"
            }
        }

        It "owned directories exist under their capitalised name" {
            foreach ($dir in $script:OwnedDirectories) {
                Test-Path -LiteralPath (Join-Path $ProjectRoot $dir) |
                    Should -BeTrue -Because "$dir is the agreed name for this directory"
            }
        }

        It "no owned directory also exists under a lowercase spelling" {
            # Test-Path cannot be used here. Windows resolves paths
            # case-insensitively, so it reports the lowercase spelling as present
            # even when the only directory on disk is the capitalised one, and
            # the test would then fail on the very rename it is meant to police.
            # The directory name is read from the filesystem instead, which keeps
            # the real casing, and compared case-sensitively.
            $onDisk = @()
            foreach ($parent in @("", "Brave-Omega")) {
                $full = if ($parent) { Join-Path $ProjectRoot $parent } else { $ProjectRoot }
                if (-not (Test-Path -LiteralPath $full)) { continue }
                $onDisk += Get-ChildItem -LiteralPath $full -Directory | ForEach-Object { $_.Name }
            }

            foreach ($dir in $script:OwnedDirectories) {
                $leaf = Split-Path -Leaf $dir
                $clash = $onDisk | Where-Object { $_ -ceq $leaf -and $_ -cne $leaf }
                $clash | Should -BeNullOrEmpty -Because "the capitalised $leaf is what Git records, so a second lowercase directory of the same name would be a silent duplicate"
            }
        }
    }

    Context "Source file names follow the convention declared for their directory" {
        It "every source file in an owned directory matches that directory's convention or a named exception" {
            $offenders = @()
            foreach ($dir in $script:SourceFileConventions.Keys) {
                $rule = $script:SourceFileConventions[$dir]
                $full = Join-Path $ProjectRoot $dir
                if (-not (Test-Path -LiteralPath $full)) { continue }
                # A directory may widen or narrow the extension set, and the one
                # it declares is the one that counts. Defaulting to the global set
                # instead would make an override decorative: a convention that
                # names files it never reads is a rule that reports green without
                # having looked at anything.
                $extensions = if ($rule.ContainsKey("Extensions")) { $rule.Extensions } else { $script:SourceExtensions }
                $files = Get-ChildItem -LiteralPath $full -File |
                    Where-Object { $_.Extension -in $extensions }
                $tester = $script:Testers[$rule.Convention]
                foreach ($file in $files) {
                    if ($file.Name -in $rule.Exceptions) { continue }
                    $stem = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                    if (& $tester $stem) { continue }
                    $offenders += "$dir/$($file.Name) (convention: $($rule.Convention))"
                }
            }

            $offenders | Should -BeNullOrEmpty -Because "a directory has one naming convention; a new file in a second style is the drift this test exists to catch"
        }

        It "every declared exception still exists, so the debt list cannot rot" {
            foreach ($dir in $script:SourceFileConventions.Keys) {
                foreach ($name in $script:SourceFileConventions[$dir].Exceptions) {
                    Test-Path -LiteralPath (Join-Path (Join-Path $ProjectRoot $dir) $name) |
                        Should -BeTrue -Because "$dir/$name is a named exception; once it is renamed the exception must be deleted, not left behind"
                }
            }
        }

        It "no exception is claimed in a directory that does not exist" {
            foreach ($dir in $script:SourceFileConventions.Keys) {
                Test-Path -LiteralPath (Join-Path $ProjectRoot $dir) |
                    Should -BeTrue -Because "$dir carries a naming convention, so a rename that removed it must be noticed"
            }
        }

        It "every owned directory Git holds is recorded under exactly one spelling" {
            # Neither Test-Path nor a case-folding comparison can do this. A
            # working tree that folds case resolves admx to ADMX without
            # complaint, so a lookup through the filesystem cannot tell that only
            # one of the two spellings was ever recorded - which is exactly the
            # state a half-finished rename leaves behind, and exactly the state in
            # which a second checkout on a case-sensitive filesystem would find
            # two directories. Git is the record, so Git is what is asked.
            $tracked = @(& $script:GetTrackedDirectories)
            $untracked = @()

            foreach ($dir in $script:OwnedDirectories) {
                # Not $matches: that is the automatic variable -match fills in,
                # and a name that reads like a match while holding directory
                # paths is a name the next reader has to check before trusting.
                $recorded = @($tracked | Where-Object { $_ -ieq $dir })
                if ($recorded.Count -eq 0) { $untracked += $dir; continue }
                $recorded.Count |
                    Should -Be 1 -Because "Git must record exactly one spelling of $dir; two entries differing only in case are two directories to every filesystem that does not fold case"
                $recorded[0] | Should -BeExactly $dir -Because "Git records this name, and it is the name every reference in this repository uses"
            }

            # The one owned directory Git cannot hold, named so that a change in
            # which directory that is has to be a decision rather than a side
            # effect. It is covered by the filesystem test above instead, and the
            # two together are what make the folder policed rather than intended.
            $untracked.Count | Should -Be 1 -Because "exactly one owned directory is expected to live outside Git; a second one means a directory is untracked by accident"
            $untracked[0] | Should -BeExactly "Docs" -Because "the local reference folder is ignored deliberately, and it is the reason the exact-case check above has a hole to declare"
        }

        It "every platform-fixed tree still exists" {
            foreach ($tree in $script:PlatformFixedTrees) {
                Test-Path -LiteralPath (Join-Path $ProjectRoot $tree) |
                    Should -BeTrue -Because "$tree is exempt from the naming convention, so its removal must be noticed - an exemption that names nothing is an exemption nobody can check"
            }
        }
    }

    Context "Document names" {
        It "every document in an owned directory matches that directory's convention or a named exception" {
            $offenders = @()
            foreach ($dir in $script:DocumentFileConventions.Keys) {
                $rule = $script:DocumentFileConventions[$dir]
                $full = Join-Path $ProjectRoot $dir
                if (-not (Test-Path -LiteralPath $full)) { continue }
                $tester = $script:Testers[$rule.Convention]
                foreach ($file in (Get-ChildItem -LiteralPath $full -File -Filter "*.md")) {
                    if ($file.Name -in $rule.Exceptions) { continue }
                    $stem = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                    if (& $tester $stem) { continue }
                    $offenders += "$dir/$($file.Name) (convention: $($rule.Convention))"
                }
            }

            $offenders | Should -BeNullOrEmpty -Because "a document name is a title; PascalCase with hyphens is the one style, and underscore or lowercase drift is the defect this catches"
        }

        It "every declared document exception still exists, so the debt list cannot rot" {
            foreach ($dir in $script:DocumentFileConventions.Keys) {
                foreach ($name in $script:DocumentFileConventions[$dir].Exceptions) {
                    Test-Path -LiteralPath (Join-Path (Join-Path $ProjectRoot $dir) $name) |
                        Should -BeTrue -Because "$dir/$name is a named exception; once it is renamed the exception must be deleted, not left behind"
                }
            }
        }
    }

    Context "Root file names" {
        It "every root document is UPPER with _ or - joining compounds" {
            $offenders = foreach ($file in (Get-ChildItem -LiteralPath $ProjectRoot -File -Filter "*.md")) {
                $stem = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                if (& $script:IsUpperCompound $stem) { continue }
                $file.Name
            }

            $offenders | Should -BeNullOrEmpty -Because "a root document is read by people and named for the platform; the casing is the part this repository owns"
        }

        It "every other root file is UPPER or a named platform-fixed name" {
            $offenders = foreach ($file in (Get-ChildItem -LiteralPath $ProjectRoot -File)) {
                if ($file.Extension -ceq ".md") { continue }
                if ($script:PlatformFixedRootFiles -ccontains $file.Name) { continue }
                $stem = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                if (& $script:IsUpperCompound $stem) { continue }
                $file.Name
            }

            ($offenders -join [Environment]::NewLine) | Should -BeNullOrEmpty -Because "a root file outside the UPPER convention has to be named by the tool that reads it, and that exemption belongs in the list above"
        }

        It "every named platform-fixed root file still exists" {
            foreach ($name in $script:PlatformFixedRootFiles) {
                Test-Path -LiteralPath (Join-Path $ProjectRoot $name) |
                    Should -BeTrue -Because "$name is exempt from the naming convention, so its removal must be noticed"
            }
        }
    }

    Context "Data contract names" {
        It "every declared data contract still exists under its exact name" {
            foreach ($entry in $script:DataContractNames) {
                Test-Path -LiteralPath (Join-Path $ProjectRoot $entry.Path) |
                    Should -BeTrue -Because "$($entry.Path) is a name readers depend on; once it is renamed the contract moves with it, and this entry must be revisited first"
            }
        }

        It "no data contract is tracked under a second spelling" {
            # Test-Path would pass here for the wrong reason: Windows folds
            # case, so a file saved as Config.json is found as config.json and
            # the drift is invisible. Worse, a hashtable keyed on the folded
            # name hides it too, because the two spellings collide on one key
            # and the last one read silently wins. So the count is asserted
            # first: Git must hold exactly one entry, and it must be the agreed
            # spelling. A duplicate is a duplicate whether the disk can show it
            # or not.
            $files = @(& $script:GetTrackedFiles)
            foreach ($entry in $script:DataContractNames) {
                $found = @($files | Where-Object { $_ -ieq $entry.Path })
                $found.Count |
                    Should -Be 1 -Because "Git must record exactly one spelling of $($entry.Path); a second entry differing only in case is a duplicate that a case-insensitive working tree hides"
                $found[0] | Should -BeExactly $entry.Path -Because "Git records this name, and it is the name every reader uses"
            }
        }
    }

    Context "A renamed path keeps one spelling" {
        It "no live file references a retired path spelling" {
            $offenders = & $script:GetRetiredSpellingOffenders
            ($offenders -join [Environment]::NewLine) | Should -BeNullOrEmpty -Because "a reference to the old spelling still reads correctly and simply stops resolving, which is exactly how a rename rots; historical release records are exempt by name and marked with a reason"
        }

        It "the retired-spelling pattern sees a whole path segment, not only a prefix" {
            # The rule above passes this suite whether or not the pattern can
            # tell a path from prose, so both patterns are asserted directly
            # against the shapes a live reference takes, and against the prose
            # that must not be mistaken for one. The fixtures are built from
            # the stored spelling rather than typed out, so this test cannot
            # itself become the stale reference that the rule above reports.
            $rule = $script:RetiredPathSpellings | Where-Object { $_.Current -ceq "Brave-Omega" }
            $bare = $script:RetiredBareSegments | Where-Object { $_.Current -ceq "Brave-Omega" }
            $name = $rule.Retired
            # Built from the stored spelling with the same boundary the scanner
            # applies. Asserting a pattern looser than the one in use would pass
            # for the wrong reason: it would prove the rule can fire while saying
            # nothing about what the rule actually rejects.
            $prefixPattern = $script:RetiredNameBoundary + [regex]::Escape($rule.Retired) + $rule.Tail
            $barePattern = $script:RetiredNameBoundary + [regex]::Escape($bare.Retired) + $bare.Tail

            foreach ($reference in @("$name\config.json", "$name/config.json")) {
                $reference -cmatch $prefixPattern |
                    Should -BeTrue -Because "'$reference' is a live path that continues past the directory segment"
            }

            foreach ($reference in @(
                    "Join-Path `$root '$name'",
                    "Join-Path `$PSScriptRoot '..\$name'",
                    "Test-Path `$root\$name")) {
                $reference -cmatch $script:PathConstructionPattern |
                    Should -BeTrue -Because "admitting the bare-segment form depends on this condition, and '$reference' is building a path"
                $reference -cmatch $barePattern |
                    Should -BeTrue -Because "'$reference' is a live path written as a whole segment, where no separator follows the name for the prefix rule to key on"
            }

            # The bare pattern is context-free on purpose: on its own it cannot
            # tell a path from a sentence, which is precisely why it is gated.
            # What it has to survive alone is prose that reaches right up
            # against the name - the Turkish possessive and the escaped form.
            foreach ($prose in @("$name\u2019n\u0131n Yakla", "$name'nin Yaklasimi")) {
                $prose -cmatch $barePattern |
                    Should -BeFalse -Because "'$prose' puts prose immediately after the name, and a pattern that matched it would flag the Turkish half of every file it touches"
            }

            # Everything else is kept out by the gate rather than by the
            # pattern. The quote closing a JSON or YAML value is the same
            # character as the quote closing a path segment, so only the
            # surrounding line can tell a reference from a mention - and the
            # marker is a cmdlet name rather than the English word, so a
            # sentence about a path is not mistaken for code that builds one.
            foreach ($prose in @(
                    "description: `"Suggest an idea for $name`"",
                    "Removing all $name policies from the registry",
                    "the authoritative policy data in $name.",
                    "See the install path for $name.")) {
                $prose -cmatch $script:PathConstructionPattern |
                    Should -BeFalse -Because "'$prose' is prose, and treating it as a path-building line would put every product mention back in scope"
            }
        }

        It "a retired name is not found inside the longer name that replaced it" {
            # The left edge and the tightened tail exist for one reason: the new
            # filenames are built out of the old stems. "Brave.admx" contains the
            # retired "brave" followed by an extension, "admx-validate.ps1"
            # contains the retired "admx" followed by a hyphen, and both are the
            # current spelling. A rule that reports them is a rule that has to be
            # silenced, and a silenced rule is gone. The fixtures are assembled
            # from the stored values so this test cannot introduce the very
            # reference it is checking for.
            $dirRule = $script:RetiredBareSegments | Where-Object { $_.Current -ceq "ADMX" }
            $fileRule = $script:RetiredPathSpellings | Where-Object { $_.Current -ceq "ADMX-Validate.ps1" }
            $stemRule = $script:RetiredPathSpellings | Where-Object { $_.Current -ceq "Brave.admx" }

            foreach ($rule in @($dirRule, $fileRule, $stemRule)) {
                $pattern = $script:RetiredNameBoundary + [regex]::Escape($rule.Retired) + $rule.Tail
                ($rule.Current -cmatch $pattern) |
                    Should -BeFalse -Because "$($rule.Current) is the spelling that replaced $($rule.Retired), and a rule that matched it would report the rename's own result as a stale reference"
            }

            # And the same tokens still fire where they are a path of their own.
            # The reference is assembled from the stored value rather than
            # written out, so this test cannot introduce the very reference it
            # is checking for: a hardcoded fixture would be a second copy of
            # the retired spelling to keep in step with the rule, and the copy
            # is the one that goes stale. The extension is read back off the
            # current spelling, which is where the rule already records it, so
            # there is nothing left here that has to be updated by hand.
            foreach ($rule in @($dirRule, $fileRule, $stemRule)) {
                $pattern = $script:RetiredNameBoundary + [regex]::Escape($rule.Retired) + $rule.Tail
                $extension = if ($rule.Current -match '\.([A-Za-z0-9]+)$') { "." + $Matches[1] } else { "" }
                $reference = "Join-Path `"`$root`" `"$($rule.Retired)$extension`""
                $reference -cmatch $pattern |
                    Should -BeTrue -Because "'$reference' is a live path carrying the retired name, and the tightened boundary must not have made the rule blind to it"
            }
        }

        It "every declared rule-declaration line still carries a retired name" {
            # This file is the only file allowed to name a retired spelling, and
            # it earns that by declaring each such line individually, with the
            # reason. Two things are checked, because a listed line that quietly
            # stopped meaning anything is worse than no list: the file has to
            # still be here, and the line the anchor names has to still be
            # carrying a name that some rule would report. A rewording that made
            # a declaration unnecessary fails there instead of leaving an entry
            # that demonstrates nothing.
            #
            # What is deliberately not checked is that an anchor occurs once. It
            # cannot: naming the anchor in this declaration is what puts a second
            # copy of it into this file, so a count of one is unreachable rather
            # than merely unmet. The count that carries meaning is the guard's
            # own report over the repository, which is empty.
            #
            # The declaration block is excluded from the search, and that is not
            # a convenience. The entry naming an anchor is itself a line carrying
            # a retired spelling, so leaving it in would let every one of these
            # checks be satisfied by the entry it is checking - a test that
            # passes whether or not the line it declares still needs declaring.
            $block = @(& $script:GetRuleDeclarationBlock)
            $block.Count |
                Should -Be 2 -Because "the declaration block has to be locatable before its own entries can be told apart from the lines they exempt, and an empty range means the search below would be satisfied by the entries themselves"

            foreach ($entry in $script:RuleDeclarationLines) {
                Test-Path -LiteralPath (Join-Path $ProjectRoot $entry.File) |
                    Should -BeTrue -Because "$($entry.File) is where the retired-spelling rule is declared, and a missing file would leave every declaration unanchored"

                $carrying = @(& $script:GetLinesCarryingRetiredNames $entry.File $block |
                    Where-Object { $_.Text.Contains($entry.Anchor) })
                $carrying.Count |
                    Should -BeGreaterThan 0 -Because "'$($entry.Anchor)' is declared because the line it names has to carry a retired spelling; $($entry.Why). Only the declaration itself still mentions it, so the entry now exempts nothing and should be deleted rather than kept"
            }
        }

        It "no line in this file carries a retired name without being declared" {
            # The narrowness of a list is only real if something still judges the
            # lines it does not name. This file holds a great many retired
            # spellings - the rule tables, the report format, the anchors
            # themselves - and the guard reads every line of it, so an entry here
            # is a claim about a specific line rather than a waiver for the file.
            # This walks the file and asks the rules directly, which is the
            # check that fails when a later edit adds a retired path beside the
            # rule tables: the new line fires, no declared anchor matches it,
            # and the guard starts reporting a violation in the file that
            # exists to hold the rules.
            $undeclared = @(& $script:GetLinesCarryingRetiredNames "Tests/FileNaming.Tests.ps1" |
                Where-Object {
                    $line = $_.Text
                    $covered = $false
                    foreach ($entry in $script:RuleDeclarationLines) {
                        if ($entry.File -ceq "Tests/FileNaming.Tests.ps1" -and $line.Contains($entry.Anchor)) { $covered = $true }
                    }
                    -not $covered
                })

            $undeclared.Count |
                Should -Be 0 -Because "a retired spelling on a line the list does not name is a real reference and has to stay reportable; the exemptions are $(@($script:RuleDeclarationLines).Count) named lines, not a waiver for this file. Undeclared: $(@($undeclared | ForEach-Object { "line $($_.Line): $($_.Text.Trim())" }) -join '; ')"
        }

        It "every declared external name still exists, and names one line" {
            # The exemption is the only place where a retired spelling is allowed
            # to survive, so it is checked from both sides: the line it claims
            # must still be there, and it must still be exactly one line. A
            # deleted or rewritten line fails here instead of leaving an
            # exemption that silently covers a line nobody has read since.
            foreach ($entry in $script:ExternalNameLines) {
                Test-Path -LiteralPath (Join-Path $ProjectRoot $entry.File) |
                    Should -BeTrue -Because "$($entry.File) is exempt from the retired-spelling rule by line, and a missing file would leave that exemption unanchored"
                $text = [System.IO.File]::ReadAllText((Join-Path $ProjectRoot $entry.File))
                $hits = ([regex]::Matches($text, [regex]::Escape($entry.Anchor))).Count
                $hits |
                    Should -Be 1 -Because "'$($entry.Anchor)' is declared as the one line whose retired name belongs to the vendor; $($entry.Why). Found $hits, which means the line was moved, duplicated, or rewritten and the exemption no longer describes what it does"
            }
        }

        It "the external-name exemption does not extend to this repository's own paths" {
            # An exemption is a hole in a guard, and a hole that widens on its own
            # is the failure this rule exists to prevent. The workflow holding the
            # vendor's filename also holds this repository's own paths, so the
            # narrowness is asserted directly: a local reference in the form that
            # file actually uses is matched by no declared anchor, and is still
            # reported by the rules. If a later edit ever widened an anchor to
            # cover the local template, this fails instead of the guard quietly
            # becoming partial.
            $file = ".github/workflows/admx-validate.yml"
            $anchors = @($script:ExternalNameLines | Where-Object { $_.File -ceq $file } | ForEach-Object { $_.Anchor })
            $anchors.Count |
                Should -BeGreaterThan 0 -Because "this file is expected to hold at least one vendor-side name, and an empty exemption list would mean the fixture no longer describes the file"

            $localReference = '        run: ./admx/admx-validate.ps1'
            $matched = @($anchors | Where-Object { $localReference.Contains($_) })
            $matched | Should -BeNullOrEmpty -Because "a local path in this repository is not a vendor-owned name, so it must not be covered by an exemption granted for one"

            $fired = $false
            foreach ($rule in $script:RetiredPathSpellings) {
                $pattern = $script:RetiredNameBoundary + [regex]::Escape($rule.Retired) + $rule.Tail
                if ($localReference -cmatch $pattern) { $fired = $true }
            }
            $fired |
                Should -BeTrue -Because "the same line must still be reported, which is what makes the exemption above a specific allowance rather than a silent opt-out for the file"
        }

        It "every declared historical record still exists" {
            foreach ($path in $script:HistoricalRecordFiles) {
                Test-Path -LiteralPath (Join-Path $ProjectRoot $path) |
                    Should -BeTrue -Because "$path is exempt from the retired-spelling rule, so its removal must be noticed rather than leaving the exemption silent"
            }
        }

        It "every declared historical line region still has its marker" {
            foreach ($region in $script:HistoricalLineRegions) {
                $text = [System.IO.File]::ReadAllText((Join-Path $ProjectRoot $region.File))
                # Multiline, and not -cmatch against the whole text: a bare ^ in
                # .NET anchors to the start of the string, so a line-anchored
                # marker would only ever be found on line one and this check
                # would pass or fail for the wrong reason.
                $pattern = if ($region.ContainsKey("LinePattern")) { $region.LinePattern } else { $region.StartMarker }
                $found = [regex]::IsMatch($text, $pattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
                $found | Should -BeTrue -Because "$($region.File) is exempt from the retired-spelling rule only inside a marked region, and that marker is what makes the exemption checkable rather than remembered"
            }
        }

        It "the current spelling is the one actually in use, so the mapping is not vacuous" {
            # A guard that also passes when every reference has been deleted
            # proves nothing. This is the check that names what the rule above
            # cannot see: it verifies the replacement spelling is present, not
            # that the old one is absent in every file a human might read.
            $allText = (& $script:GetTrackedFiles | Where-Object {
                $extension = [System.IO.Path]::GetExtension($_)
                $extension -eq "" -or ($script:TextExtensions -ccontains $extension)
            } | ForEach-Object { [System.IO.File]::ReadAllText((Join-Path $ProjectRoot $_)) }) -join "`n"

            foreach ($rule in $script:RetiredPathSpellings) {
                $allText.Contains($rule.Current) | Should -BeTrue -Because "$($rule.Current) is the spelling that replaced $($rule.Retired), and it has to appear in the repository for the rename to have happened at all"
            }
        }
    }

    Context "ADMX version has one source" {
        It "Brave.admx carries a parseable Brave version in its own leading comment" {
            $path = Join-Path $ProjectRoot "ADMX\Brave.admx"
            Test-Path -LiteralPath $path |
                Should -BeTrue -Because "the file was renamed, and a test that reads a path that no longer resolves would pass for the wrong reason"
            $match = [regex]::Match(
                (Get-Content -LiteralPath $path -Raw),
                'brave version:\s*([\d.]+)')
            $match.Success | Should -BeTrue -Because "the update check reads the version from the file itself, so the comment is load-bearing"
            $match.Groups[1].Value | Should -Match '^\d+(\.\d+)+$'
        }

        It "no separate ADMX version file shadows the version in Brave.admx" {
            # A second copy is a second thing to forget to update, and the
            # multi-line form the old copy used is not parseable as a version.
            $strays = Get-ChildItem -LiteralPath (Join-Path $ProjectRoot "ADMX") -File |
                Where-Object { $_.Name -match 'VERSION' }
            $strays | Should -BeNullOrEmpty -Because "Brave.admx is the single source of truth for the ADMX version"
        }

        It "the update-check step reads the version from the renamed local file" {
            $workflow = Get-Content -LiteralPath (Join-Path $ProjectRoot ".github\workflows\admx-validate.yml") -Raw
            $workflow | Should -Not -Match 'VERSION_BRAVE_ADMX' -Because "that file is gone, and a stale reference would break the step"
            # Case-sensitive, and that is the point of the line. The remote archive
            # still names its own file in lowercase, so an ordinary -Match would be
            # satisfied by the one reference that is *not* ours to rename and would
            # pass even if every local path were left pointing at a directory that
            # no longer exists. The inline flag turns case folding off for this one
            # pattern, so the lowercase vendor name cannot stand in for ours.
            $workflow | Should -Match '(?-i:Brave\.admx)' -Because "the step must read the version from the single source of truth, under its current name and nothing else on the page matches it"
        }
    }
}
