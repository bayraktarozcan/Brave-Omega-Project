# Invariant: local-only layer names stay inside their layer and in the
# documents that define or verify them. Every other tracked file must speak
# about those layers abstractly, so a private path cannot leak through prose,
# a comment or a generated artifact.
BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $script:RepoRoot = Split-Path -Parent $PSScriptRoot
    $script:Patterns = @('Agent-Scratch', 'AGENTS-TR\.md', '\bIntelligence/')
    $script:Allowed = @{
        '.gitignore'                    = 'declares the ignore patterns'
        'AGENTS.md'                     = 'canonical owner of the no-naming rule'
        'CHANGELOG.md'                  = 'historical record'
        'Wiki/Changelog.md'             = 'historical record projection'
        'Scripts/Release.ps1'           = 'tooling that stages the package'
        'Tests/ReleaseNotes.Tests.ps1'  = 'tooling that writes generated notes'
        'Tests/DocCounts.Tests.ps1'     = 'verifies the mirror count'
        'Tests/CI-Parity.Tests.ps1'     = 'verifies the mirrored workflow inventory'
        'Tests/HeadingCase.Tests.ps1'   = 'verifies the mirror headings'
        'Tests/IgnoreRules.Tests.ps1'   = 'verifies the ignore patterns'
        'Tests/LayerMarkers.Tests.ps1'  = 'verifies the layer roots'
        'Tests/HiddenLayerNames.Tests.ps1' = 'declares this rule and its patterns'
    }

    function Test-HiddenLayerMention {
        param([string]$Text)
        foreach ($pattern in $script:Patterns) {
            if ([regex]::IsMatch($Text, $pattern)) { return $true }
        }
        return $false
    }

    $script:Tracked = @(git -C $script:RepoRoot ls-files |
        Where-Object { $_ -match '\.(ps1|py|md|yml|yaml|json|html|gitignore|gitattributes)$' -or $_ -eq '.gitignore' })
}

Describe 'Hidden layer names' -Tag 'Unit' {
    It 'detects a planted name and accepts abstract prose' {
        Test-HiddenLayerMention -Text 'nothing private is mentioned here' | Should -BeFalse
        Test-HiddenLayerMention -Text 'see the gitignored AGENTS-TR.md mirror' | Should -BeTrue
        Test-HiddenLayerMention -Text 'the scratch directory' | Should -BeFalse
    }

    It 'finds no undeclared tracked file that names a hidden layer' {
        $offenders = @()
        foreach ($path in $script:Tracked) {
            if ($script:Allowed.ContainsKey($path)) { continue }
            $full = Join-Path $script:RepoRoot $path
            if (-not (Test-Path -LiteralPath $full)) { continue }
            $text = [System.IO.File]::ReadAllText($full)
            if (Test-HiddenLayerMention -Text $text) { $offenders += $path }
        }
        $offenders | Should -BeNullOrEmpty -Because ('private paths leaked into: ' + ($offenders -join ', '))
    }

    It 'keeps every declared exception pointing at a real tracked file' {
        $missing = @($script:Allowed.Keys | Where-Object { $script:Tracked -cnotcontains $_ })
        $missing | Should -BeNullOrEmpty -Because ('a stale exception cannot be reviewed: ' + ($missing -join ', '))
    }
}
