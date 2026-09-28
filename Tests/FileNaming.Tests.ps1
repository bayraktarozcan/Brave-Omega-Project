BeforeAll {
    $ProjectRoot = Split-Path -Parent $PSScriptRoot

    # Directories whose name a tool, platform, or vendor fixes in lowercase.
    # The exemption is declared here so it is checked, not remembered.
    $script:LowercaseDirAllowList = @(
        ".github"
        "admx"
        "docs"
        "scripts"
    )

    # Directories whose name may contain whitespace, and so exempt from the rule
    # that forbids it. The list is empty on purpose: a space in a tracked path
    # is not a style preference, it is a defect that has already cost this
    # repository one broken CI path, and an empty list is what makes the next
    # one fail by name instead of passing unnoticed.
    $script:WhitespaceDirAllowList = @()

    # Trees a tool or platform names for us, so no convention of ours applies
    # to anything inside them.
    $script:PlatformFixedTrees = @(
        ".github"
        "admx"
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
    $script:OwnedDirectories = @(
        "Brave-Omega"
        "Brave-Omega\Profiles"
        "Enterprise"
        "Brave-Omega\Docs"
        "Tests"
        "Wiki"
    )

    # The convention in force for source files in a directory we own, and the
    # files already in the directory that predate it. A new file that does not
    # match is a defect; an existing exception is a known, named debt.
    $script:SourceFileConventions = @{
        "scripts" = @{
            Convention   = "PascalCase"
            Exceptions   = @(
                "deploy-brave-omega.ps1"
                "detect-brave-omega.ps1"
                "verify-mirror-sync.ps1"
                "mojibake-scan.py"
            )
            ExceptionWhy = "kebab-case, kept so the existing references stay valid; rename is a separate change"
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

    # Source files in a directory whose naming is fixed by a vendor or a tool.
    $script:VendorFileConventions = @{
        "admx" = @{
            Convention = "kebab-case"
            Why        = "the vendor's own Group Policy tooling spells it this way"
        }
    }

    $script:SourceExtensions = @(".ps1", ".psm1", ".py")

    # The vendor tree also carries the two files Group Policy itself consumes.
    # They are not source, so they fall outside the source extension set, and
    # without this the vendor convention would be declared over a directory it
    # never actually looked at.
    $script:VendorExtensions = @(".ps1", ".psm1", ".py", ".admx", ".adml")

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
            # does not end the segment either.
            Tail    = '(?![\\/])(?!\p{L})(?!''\p{L})'
            Label   = "the pre-rename directory name"
        }
    )

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

    $script:GetTrackedFiles = {
        & git -C $ProjectRoot ls-files | Sort-Object
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

                # No exemption for the line that declares a rule. The two forms
                # are kept apart on purpose: the prefix form needs a separator
                # that a declaration does not have, and the bare form is gated
                # on a path being built, which a declaration is not. An
                # exemption here would have been an admission that the gate does
                # not hold, and it would hide a real reference written as
                # 'Current = ...' in the meantime.
                foreach ($rule in $script:RetiredPathSpellings) {
                    $pattern = [regex]::Escape($rule.Retired) + $rule.Tail
                    if ($line -cmatch $pattern) {
                        # The line itself, not the pattern. A report that shows
                        # the matcher tells the reader what to fix by handing
                        # them the matcher; showing the text is what they
                        # actually have to edit. Trimmed inside the
                        # subexpression, because "$line.Trim()" interpolates
                        # the method name and points the reader at a line that
                        # ends in a call to it.
                        $offenders += "$path line $($i + 1): $($rule.Label) is retired, now '$($rule.Current)' -- $($line.Trim())"
                    }
                }

                # The whole-segment form, admitted only where a path is being
                # built. The report is the same either way, so a stale reference
                # reads the same whether it was written as a prefix or as a
                # segment.
                if ($line -cmatch $script:PathConstructionPattern) {
                    foreach ($rule in $script:RetiredBareSegments) {
                        $pattern = [regex]::Escape($rule.Retired) + $rule.Tail
                        if ($line -cmatch $pattern) {
                            $offenders += "$path line $($i + 1): $($rule.Label) is retired, now '$($rule.Current)' -- $($line.Trim())"
                        }
                    }
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
                $files = Get-ChildItem -LiteralPath $full -File |
                    Where-Object { $_.Extension -in $script:SourceExtensions }
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

        It "source files in a vendor directory follow the vendor's spelling" {
            foreach ($dir in $script:VendorFileConventions.Keys) {
                $rule = $script:VendorFileConventions[$dir]
                $full = Join-Path $ProjectRoot $dir
                if (-not (Test-Path -LiteralPath $full)) { continue }
                $tester = $script:Testers[$rule.Convention]
                $offenders = Get-ChildItem -LiteralPath $full -File |
                    Where-Object { $_.Extension -in $script:VendorExtensions } |
                    Where-Object {
                        $stem = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
                        -not (& $tester $stem)
                    } |
                    ForEach-Object { "$dir/$($_.Name)" }
                $offenders | Should -BeNullOrEmpty -Because "($rule.Why)"
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

            $offenders | Should -BeNullOrEmpty -Because "a root file outside the UPPER convention has to be named by the tool that reads it, and that exemption belongs in the list above"
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
            $offenders | Should -BeNullOrEmpty -Because "a reference to the old spelling still reads correctly and simply stops resolving, which is exactly how a rename rots; historical release records are exempt by name and marked with a reason"
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
            $prefixPattern = [regex]::Escape($rule.Retired) + $rule.Tail
            $barePattern = [regex]::Escape($bare.Retired) + $bare.Tail

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
        It "brave.admx carries a parseable Brave version in its own leading comment" {
            $path = Join-Path $ProjectRoot "admx\brave.admx"
            $match = [regex]::Match(
                (Get-Content -LiteralPath $path -Raw),
                'brave version:\s*([\d.]+)')
            $match.Success | Should -BeTrue -Because "the update check reads the version from the file itself, so the comment is load-bearing"
            $match.Groups[1].Value | Should -Match '^\d+(\.\d+)+$'
        }

        It "no separate ADMX version file shadows the version in brave.admx" {
            # A second copy is a second thing to forget to update, and the
            # multi-line form the old copy used is not parseable as a version.
            $strays = Get-ChildItem -LiteralPath (Join-Path $ProjectRoot "admx") -File |
                Where-Object { $_.Name -match 'VERSION' }
            $strays | Should -BeNullOrEmpty -Because "brave.admx is the single source of truth for the ADMX version"
        }

        It "the update-check step reads the version from brave.admx" {
            $workflow = Get-Content -LiteralPath (Join-Path $ProjectRoot ".github\workflows\admx-validate.yml") -Raw
            $workflow | Should -Not -Match 'VERSION_BRAVE_ADMX' -Because "that file is gone, and a stale reference would break the step"
            $workflow | Should -Match 'brave\.admx' -Because "the step must read the version from the single source of truth"
        }
    }
}
