BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    function Get-IgnoreRuleSet {
        Get-OmegaIgnoreRule -IgnoreFilePath (Join-Path (Split-Path -Parent $PSScriptRoot) ".gitignore")
    }
}

Describe "Ignore rule anchoring" -Tag "Unit" {

    Context "Root-anchored directory patterns" {

        It "ignores scratch notes placed at the repository root" {
            Test-OmegaIgnorePath -Rules (Get-IgnoreRuleSet) -Path "docs/agent-notes.md" | Should -BeTrue
        }

        It "does not ignore product documentation shipped inside the project" {
            Test-OmegaIgnorePath -Rules (Get-IgnoreRuleSet) -Path "Brave Omega/Docs/architecture.md" | Should -BeFalse
        }

        It "does not ignore a documentation directory nested several levels deep" {
            Test-OmegaIgnorePath -Rules (Get-IgnoreRuleSet) -Path "x/y/docs/probe.md" | Should -BeFalse
        }

        It "anchors the docs rule to the repository root" {
            $rule = Get-OmegaIgnoreRuleFor -Rules (Get-IgnoreRuleSet) -Path "docs/agent-notes.md"
            $rule | Should -Not -BeNullOrEmpty
            $rule.Source | Should -Be "/docs/" -Because "an unanchored docs/ pattern also swallows the product documentation directory"
            $rule.Anchored | Should -BeTrue
        }

        It "leaves nested product documentation with no ignore rule to override it" {
            foreach ($path in @("Brave Omega/Docs/architecture.md", "x/y/docs/probe.md")) {
                $rule = Get-OmegaIgnoreRuleFor -Rules (Get-IgnoreRuleSet) -Path $path
                $rule | Should -BeNullOrEmpty -Because "$path is tracked output, so no pattern in .gitignore may match it"
            }
        }
    }

    Context "Negation ordering" {

        It "ignores a registry backup at the root but keeps the tracked Enterprise policy profiles" {
            $rules = Get-IgnoreRuleSet
            Test-OmegaIgnorePath -Rules $rules -Path "Backup/local.reg" | Should -BeTrue
            Test-OmegaIgnorePath -Rules $rules -Path "Enterprise/Balanced.reg" | Should -BeFalse -Because "Enterprise/*.reg is a CI-consumed artifact and is re-included by a later rule"
        }

        It "keeps the editor settings that a later rule re-includes" {
            $rules = Get-IgnoreRuleSet
            Test-OmegaIgnorePath -Rules $rules -Path ".vscode/other.json" | Should -BeTrue
            Test-OmegaIgnorePath -Rules $rules -Path ".vscode/settings.json" | Should -BeFalse
        }
    }

    Context "Unanchored patterns still match at any depth" {

        It "matches a bare name in the root and deep in the tree alike" {
            $rules = Get-IgnoreRuleSet
            Test-OmegaIgnorePath -Rules $rules -Path "AGENTS-TR.md" | Should -BeTrue
            Test-OmegaIgnorePath -Rules $rules -Path "deep/nested/AGENTS-TR.md" | Should -BeTrue
        }

        It "leaves the canonical agent guide tracked at any depth" {
            Test-OmegaIgnorePath -Rules (Get-IgnoreRuleSet) -Path "AGENTS.md" | Should -BeFalse
        }
    }
}
