# Invariant: published release titles and bodies stay hygienic on both hosts.
# Fixtures are injected, so these tests never call the release APIs.
BeforeAll {
    $script:RepoRoot = Split-Path -Parent $PSScriptRoot
    $script:Helper = Join-Path $script:RepoRoot 'Scripts\Assert-ReleaseHygiene.ps1'
    $script:Hygiene = Join-Path $script:RepoRoot '.github\workflows\hygiene.yml'
    . $script:Helper -Library

    $script:Changelog = Join-Path ([System.IO.Path]::GetTempPath()) ("hygiene-cl-" + [guid]::NewGuid().ToString('N') + '.md')
    @'
## EN English Changelog

## [9.9.9.9] — 2026-11-21

### Added

- **One change** — described in the notes.

## [9.9.9.8] — 2026-11-20

### Added

- **One change** — described in the notes.

## TR Türkçe Değişiklik Günlüğü

## [9.9.9.9] — 2026-11-21

### Eklenenler

- Bir değişiklik.

## [9.9.9.8] — 2026-11-20

### Eklenenler

- Bir değişiklik.
'@ | Set-Content -LiteralPath $script:Changelog -Encoding UTF8

    function New-Release {
        param([string]$Tag, [string]$Name, [string]$Body, [string]$OtherBody)
        return [pscustomobject]@{
            tag_name = $Tag
            name = $Name
            body = if ($OtherBody) { $OtherBody } else { $Body }
        }
    }

    function New-Body {
        param([string]$Tag)
        return @"
## $Tag — Good Release

### Summary

A concise summary.

### Added

- One change.

Fixes #50

### Files

- `file.ps1`

### Documentation

- [Wiki](https://example.invalid)

---

## $Tag — İyi Sürüm

### Özet

Kısa özet.

### Eklenenler

- Bir değişiklik.

### Dosyalar

- `file.ps1`

### Belgelendirme

- [Wiki](https://example.invalid)
"@
    }

    $script:Current = 'v9.9.9.9'
    $script:Older = 'v9.9.9.8'
    $script:GoodGh = @(
        New-Release -Tag $script:Current -Name "$($script:Current) — Good Release" -Body (New-Body $script:Current)
        New-Release -Tag $script:Older -Name "[DEPRECATED] $($script:Older) — Older Release" -Body (New-Body $script:Older)
    )
    $script:GoodGl = @(
        New-Release -Tag $script:Current -Name "$($script:Current) — Good Release" -Body ((New-Body $script:Current).Replace("`n", "`r`n"))
        New-Release -Tag $script:Older -Name "[DEPRECATED] $($script:Older) — Older Release" -Body (New-Body $script:Older)
    )
}

Describe 'Published release hygiene' -Tag 'Unit' {
    AfterAll {
        if (Test-Path -LiteralPath $script:Changelog) { Remove-Item -LiteralPath $script:Changelog -Force }
    }

    It 'accepts a clean bilingual pair and tolerates CRLF on one host' {
        @(Test-ReleaseHygiene -GitHub $script:GoodGh -GitLab $script:GoodGl -CurrentTag $script:Current -ChangelogPath $script:Changelog) | Should -BeNullOrEmpty
    }

    It 'reports a tag set that differs between hosts' {
        $gl = @($script:GoodGl | Where-Object tag_name -ne $script:Older)
        $f = @(Test-ReleaseHygiene -GitHub $script:GoodGh -GitLab $gl -CurrentTag $script:Current -ChangelogPath $script:Changelog)
        ($f -join ' ') | Should -Match 'pair-count'
    }

    It 'rejects a missing deprecation prefix and a repeated tag' {
        $gh = @(
            New-Release -Tag $script:Current -Name "$($script:Current) — Good Release" -Body (New-Body $script:Current)
            New-Release -Tag $script:Older -Name "$($script:Older) — $($script:Older) repeated" -Body (New-Body $script:Older)
        )
        $f = @(Test-ReleaseHygiene -GitHub $gh -GitLab $script:GoodGl -CurrentTag $script:Current -ChangelogPath $script:Changelog)
        ($f -join ' ') | Should -Match 'title-format'
    }

    It 'rejects a missing Turkish core section' {
        $body = (New-Body $script:Current).Replace("### Belgelendirme", "### Other")
        $gh = @(
            New-Release -Tag $script:Current -Name "$($script:Current) — Good Release" -Body $body
            $script:GoodGh[1]
        )
        $f = @(Test-ReleaseHygiene -GitHub $gh -GitLab $script:GoodGl -CurrentTag $script:Current -ChangelogPath $script:Changelog)
        ($f -join ' ') | Should -Match 'body-structure'
    }

    It 'rejects bare issue links, embedded TOCs and foreign version headings' {
        $body = (New-Body $script:Current)
        $body = $body.Replace('- One change.', '- Change #5') + "`n`n## $($script:Older) — Foreign`n"
        $gh = @(
            New-Release -Tag $script:Current -Name "$($script:Current) — Good Release" -Body $body
            $script:GoodGh[1]
        )
        $f = @(Test-ReleaseHygiene -GitHub $gh -GitLab $script:GoodGl -CurrentTag $script:Current -ChangelogPath $script:Changelog)
        ($f -join ' ') | Should -Match 'no-garbage'
    }

    It 'rejects a body that differs between hosts' {
        $gl = @(
            New-Release -Tag $script:Current -Name "$($script:Current) — Good Release" -Body ((New-Body $script:Current) + "`nextra")
            $script:GoodGl[1]
        )
        $f = @(Test-ReleaseHygiene -GitHub $script:GoodGh -GitLab $gl -CurrentTag $script:Current -ChangelogPath $script:Changelog)
        ($f -join ' ') | Should -Match 'cross-host'
    }

    It 'rejects a changelog bullet that the published notes omit' {
        $original = [System.IO.File]::ReadAllText($script:Changelog)
        try {
            $planted = $original.Replace('- **One change** — described in the notes.', '- **Unreleased capability** — absent from notes.')
            [System.IO.File]::WriteAllText($script:Changelog, $planted)
            $f = @(Test-ReleaseHygiene -GitHub $script:GoodGh -GitLab $script:GoodGl -CurrentTag $script:Current -ChangelogPath $script:Changelog)
            ($f -join ' ') | Should -Match 'changelog-coverage'
        } finally {
            [System.IO.File]::WriteAllText($script:Changelog, $original)
        }
    }

    It 'rejects a Turkish changelog bullet missing from the Turkish notes' {
        $original = [System.IO.File]::ReadAllText($script:Changelog)
        try {
            $planted = [regex]::Replace($original, [regex]::Escape('- Bir değişiklik.'), '- Görünmeyen özellik.', 1)
            [System.IO.File]::WriteAllText($script:Changelog, $planted)
            $f = @(Test-ReleaseHygiene -GitHub $script:GoodGh -GitLab $script:GoodGl -CurrentTag $script:Current -ChangelogPath $script:Changelog)
            ($f -join ' ') | Should -Match 'changelog-coverage'
        } finally {
            [System.IO.File]::WriteAllText($script:Changelog, $original)
        }
    }

    It 'parses API payloads identically on both PowerShell engines' {
        $helper = Get-Content -LiteralPath $script:Helper -Raw
        $helper | Should -Not -Match '@\([^\r\n]*\|\s*ConvertFrom-Json'
        $helper | Should -Match '\$parsed\s*=\s*\$jsonText\s*\|\s*ConvertFrom-Json'
        $helper | Should -Match 'RawContentStream'
        $helper | Should -Match '\[System\.Text\.Encoding\]::UTF8\.GetString'
    }

    It 'audits the generator for the canonical current tag' {
        $generator = Join-Path $script:RepoRoot 'Scripts\Build-ReleaseNotes.ps1'
        @(Test-NoteGenerator -CurrentTag 'v3.1.0.5' -GeneratorPath $generator -RepoRoot $script:RepoRoot) | Should -BeNullOrEmpty
    }

    It 'keeps the historical coverage exemption narrow' {
        $script:CoverageExemptTags | Should -Be @('v1.0', 'v1.1')
    }

    It 'reads GitLab without a write-capable credential' {
        $workflow = Get-Content -LiteralPath $script:Hygiene -Raw
        $workflow | Should -Not -Match 'GITLAB_PUSH_TOKEN'
        $helper = Get-Content -LiteralPath $script:Helper -Raw
        $helper | Should -Match 'Invoke-WebRequest'
        $helper | Should -Not -Match 'PRIVATE-TOKEN'
    }
}
