BeforeAll {
    . $PSScriptRoot\TestHelper.ps1

    # The marker this project uses for a local-only layer. It is a fixed
    # spelling understood by tooling, not a name this repository owns, which is
    # why it is written out here rather than derived from the naming rules.
    $script:Marker = '._dont_migrate_'

    $script:IgnoreRules = Get-OmegaIgnoreRule -IgnoreFilePath (Join-Path $ProjectRoot '.gitignore')

    # A directory Git ignores as a whole, other than the generic build-output
    # patterns. The project declares its own layers by anchoring the pattern to
    # the repository root or by prefixing it with **/, so that shape is what
    # separates a deliberate layer from `node_modules/` or `Backup/`. A bare
    # pattern is not one: `.idea/` matches that shape too and is editor state the
    # IDE rewrites on its own, not content this project routes anywhere.
    $script:LayerRulePattern = '^(/|\*\*/)'

    # A layer root is the ignored directory whose parent is not ignored: that is
    # the point at which a tool walking the tree decides to stop, so it is the
    # only place a marker has any work to do. A directory nested inside one is
    # already covered by the marker above it, and asking for one at every depth
    # would be asking for a file that repeats what its parent already says.
    $script:AllDirectories = @(
        Get-ChildItem -LiteralPath $ProjectRoot -Directory -Recurse -Force |
            Where-Object { $_.FullName -notmatch '[\\/]\.git([\\/]|$)' } |
            ForEach-Object { $_.FullName.Substring($ProjectRoot.Length + 1).Replace('\', '/') }
    )

    $script:IsLayerRoot = {
        param($RelativePath)
        $decision = Get-OmegaIgnoreDecision -Rules $script:IgnoreRules -Path $RelativePath
        if (-not $decision.Ignored) { return $false }
        if (-not $decision.Rule.DirOnly) { return $false }
        if ($decision.Rule.Pattern -notmatch $script:LayerRulePattern) { return $false }
        $parts = @($RelativePath.Split('/'))
        $parent = if ($parts.Count -gt 1) { $parts[0..($parts.Count - 2)] -join '/' } else { '' }
        if (-not $parent) { return $true }
        return -not (Get-OmegaIgnoreDecision -Rules $script:IgnoreRules -Path $parent).Ignored
    }
}

Describe "Local-only layer markers" -Tag "Unit" {

    Context "A layer root carries the marker" {
        It "every directory Git ignores as a whole carries the marker" {
            $missing = @()
            foreach ($dir in $script:AllDirectories) {
                if (-not (& $script:IsLayerRoot $dir)) { continue }
                if (Test-Path -LiteralPath (Join-Path $ProjectRoot "$dir/$($script:Marker)")) { continue }
                $missing += $dir
            }

            $missing | Should -BeNullOrEmpty -Because "a directory Git ignores is invisible to every tool that walks the tree instead of reading the ignore rules, so the marker at the layer root is the only signal that reaches those tools"
        }
    }

    Context "A tracked directory does not carry the marker" {
        It "no directory outside the ignore rules carries the marker" {
            $strays = @()
            foreach ($dir in $script:AllDirectories) {
                $decision = Get-OmegaIgnoreDecision -Rules $script:IgnoreRules -Path $dir
                if ($decision.Ignored) { continue }
                if (-not (Test-Path -LiteralPath (Join-Path $ProjectRoot "$dir/$($script:Marker)"))) { continue }
                $strays += $dir
            }

            $strays | Should -BeNullOrEmpty -Because "the same tooling that is told to skip a local layer would be told to skip the product itself, so the marker belongs only where Git already refuses to look"
        }
    }

    Context "The marker is never committed" {
        It "no tracked path is named as the marker" {
            $tracked = @(git -C $ProjectRoot ls-files)
            $found = @($tracked | Where-Object { (Split-Path -Leaf $_) -ceq $script:Marker })

            $found | Should -BeNullOrEmpty -Because "the marker is a signal for tools that walk the tree and has no meaning to Git, so a committed copy would be a file every repository carries and no tool reads"
        }
    }

    Context "A misplaced marker stays visible" {
        It "the marker is not swallowed by the pattern that matches its spelling" {
            # `._*` matches the name at every depth. Without a later rule to
            # re-include it, a copy dropped into a tracked directory would never
            # appear in `git status` - exactly where it does damage and exactly
            # where someone would have to notice it.
            foreach ($parent in @('Scripts', 'Tests', 'ADMX', 'Wiki')) {
                Test-OmegaIgnorePath -Rules $script:IgnoreRules -Path "$parent/$($script:Marker)" |
                    Should -BeFalse -Because "a misplaced marker in $parent has to reach `git status`, otherwise the rule that forbids it cannot be noticed when it breaks"
            }
        }

        It "still keeps the marker out of Git inside a layer" {
            foreach ($layer in @('Docs', 'Agent-Scratch', 'Intelligence')) {
                Test-OmegaIgnorePath -Rules $script:IgnoreRules -Path "$layer/$($script:Marker)" |
                    Should -BeTrue -Because "the layer rule, not the marker rule, is what keeps a local layer out of the repository"
            }
        }
    }
}