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

    # Directories we own, so their name must start with a capital.
    $script:OwnedDirectories = @(
        "Brave Omega\Profiles"
        "Enterprise"
        "Brave Omega\Docs"
        "Tests"
        "Wiki"
    )

    # The convention in force for source files in a directory we own, and the
    # files already in the directory that predate it. A new file that does not
    # match is a defect; an existing exception is a known, named debt.
    $script:SourceFileConventions = @{
        "Scripts" = @{
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

    # Source files in a directory whose naming is fixed by a vendor or a tool.
    $script:VendorFileConventions = @{
        "admx" = @{
            Convention = "kebab-case"
            Why        = "the vendor's own Group Policy tooling spells it this way"
        }
    }

    $script:SourceExtensions = @(".ps1", ".psm1", ".py")

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

    $script:Testers = @{
        "PascalCase" = $script:IsPascalCase
        "snake_case" = $script:IsSnakeCase
        "kebab-case" = $script:IsKebabCase
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
                    if ($dir -eq $entry -or $dir.StartsWith("$entry\")) {
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
            foreach ($parent in @("", "Brave Omega")) {
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
                    Where-Object { $_.Extension -in $script:SourceExtensions } |
                    Where-Object {
                        $stem = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
                        -not (& $tester $stem)
                    } |
                    ForEach-Object { "$dir/$($_.Name)" }
                $offenders | Should -BeNullOrEmpty -Because "($rule.Why)"
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
