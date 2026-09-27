BeforeAll {
    $RepoRoot = Split-Path -Path $PSScriptRoot -Parent
    Set-Location -Path $RepoRoot

    function Test-Ignored {
        param([string]$Path)
        $null = git check-ignore -q -- $Path
        return ($LASTEXITCODE -eq 0)
    }
}

Describe "Ignore rule anchoring" -Tag "Unit" {

    Context "Root-anchored directory patterns" {

        It "ignores scratch notes placed at the repository root" {
            Test-Ignored "docs/agent-notes.md" | Should -BeTrue
        }

        It "does not ignore product documentation shipped inside the project" {
            Test-Ignored "Brave Omega/docs/architecture.md" | Should -BeFalse
        }

        It "does not ignore a documentation directory nested several levels deep" {
            Test-Ignored "x/y/docs/probe.md" | Should -BeFalse
        }

        It "anchors the docs rule to the repository root" {
            $entry = @(git check-ignore -v --no-index -- "docs/agent-notes.md" 2>$null) | Select-Object -First 1
            $entry | Should -Not -BeNullOrEmpty
            $origin = ($entry -split "`t")[0]
            $origin -match '^(?<file>.*\.gitignore):\d+:(?<rule>.*)$' | Should -BeTrue -Because "git reports the matching ignore rule as source:line:pattern"
            $Matches['rule'] | Should -Be "/docs/" -Because "an unanchored docs/ pattern also swallows the product documentation directory"
        }
    }
}
