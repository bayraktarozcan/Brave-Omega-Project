# Invariant: release metadata is derived from the canonical changelog, so a new
# tag cannot drift from the title and body rules in AGENTS.md §12.
BeforeAll {
    $script:RepoRoot = Split-Path -Parent $PSScriptRoot
    $script:Helper = Join-Path $script:RepoRoot 'Scripts\Build-ReleaseNotes.ps1'
    $script:Output = Join-Path $script:RepoRoot 'Agent-Scratch\release-notes-test.md'

    function Get-ReleaseMetadata {
        param([string]$Version, [switch]$Current)
        $bare = $Version.TrimStart('v')
        if ($Current) { $title = (& $script:Helper $bare $script:Output -Current 2>&1 | Select-Object -First 1) }
        else { $title = (& $script:Helper $bare $script:Output 2>&1 | Select-Object -First 1) }
        $body = if (Test-Path -LiteralPath $script:Output) { Get-Content -LiteralPath $script:Output -Raw } else { '' }
        return @{ Title = $title; Body = $body }
    }

    $script:Current = Get-ReleaseMetadata -Version 'v3.1.0.5' -Current
    $script:Older = Get-ReleaseMetadata -Version 'v3.1.0.4'
}

Describe 'Release notes invariants' -Tag 'Unit' {
    It 'derives a canonical current title without a DEPRECATED prefix' {
        $script:Current.Title | Should -Match '^v3\.1\.0\.5 — \S'
        $script:Current.Title | Should -Not -Match '\[DEPRECATED\]'
        ([regex]::Matches($script:Current.Title, 'v3\.1\.0\.5')).Count | Should -Be 1
    }

    It 'prefixes older release titles at the start' {
        $script:Older.Title | Should -Match '^\[DEPRECATED\] v3\.1\.0\.4 — \S'
        $script:Older.Title | Should -Not -Match 'v3\.1\.0\.4.*\[DEPRECATED\]'
    }

    It 'emits a clean bilingual body with no bare issue links or embedded TOC' {
        $script:Current.Body | Should -Match '(?m)^## v3\.1\.0\.5 — '
        $script:Current.Body | Should -Match '(?m)^### Summary\s*$'
        $script:Current.Body | Should -Match '(?m)^### Özet\s*$'
        $script:Current.Body | Should -Match '(?m)^### Documentation\s*$'
        $script:Current.Body | Should -Match '(?m)^### Belgelendirme\s*$'
        $script:Current.Body | Should -Not -Match '(?m)^\|\s*#\d+'
        $script:Current.Body | Should -Not -Match 'Table of Contents|İçindekiler'
    }
}
