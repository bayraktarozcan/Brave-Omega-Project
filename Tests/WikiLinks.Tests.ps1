# Invariant: Wiki-internal links use the wiki-page form, and the link checker
# knows it.
#
# GitHub Wiki serves `Page.md` as the raw file and `Page` as the rendered
# page, so every relative link between Wiki pages drops the `.md` suffix and
# keeps only the page name plus an optional `#fragment`. lychee, the tool both
# CI hosts run over `./**/*.md`, resolves a relative link to a file on disk,
# so a page-form link reads as a missing file and fails the gate. Both CI
# definitions therefore carry one scoped exclusion for exactly this shape, and
# this file is the check that covers what the exclusion hides: the oracle is
# the Wiki tree itself (page files on disk plus the anchors they define), not
# a second list that can drift beside it.
#
# What this check cannot see:
#   - Whether the excluded shape is still the only thing excluded. A broadened
#     exclusion would keep passing here while hiding real breakage from lychee,
#     so the exclusion text is pinned character-for-character on both hosts.
#   - Whether a fragment renders where a human expects it. lychee ignores
#     fragments and this file only proves the anchor exists, so a fragment
#     pointing at the wrong section still passes. Fragments stay a human read.
BeforeAll {
    . $PSScriptRoot\TestHelper.ps1

    $script:WikiDir = Join-Path $ProjectRoot 'Wiki'
    # The exact exclusion both CI definitions must carry. Pinned as one string
    # so the hosts cannot drift into checking different things.
    $script:WikiExclusion = 'file://.*/Wiki/[A-Za-z-]+(#[^/]*)?$'

    function Get-WikiPageLink {
        param([string]$FilePath)
        # Rendered links only: fenced blocks and inline code spans are
        # instructions about links, not links, and both renderers agree.
        $lineNo = 0
        $inFence = $false
        foreach ($line in (Get-Content -LiteralPath $FilePath)) {
            $lineNo++
            if ($line -match '^\s*```') { $inFence = -not $inFence; continue }
            if ($inFence) { continue }
            $prose = [regex]::Replace($line, '`[^`]*`', '')
            foreach ($m in [regex]::Matches($prose, '(?<!\!)\[[^\]]*\]\(([^)]+)\)')) {
                $dest = $m.Groups[1].Value
                if ($dest -match '^(https?://|mailto:|#|/)') { continue }
                if ($dest -match '/') { continue }
                $page = $dest.Split('#')[0]
                if ($page -notmatch '^[A-Za-z0-9_-]+$') { continue }
                if ($page -match '\.') { continue }
                $fragment = $null
                if ($dest.Contains('#')) { $fragment = $dest.Substring($dest.IndexOf('#') + 1) }
                [pscustomobject]@{
                    File     = $FilePath
                    Line     = $lineNo
                    Page     = $page
                    Fragment = $fragment
                }
            }
        }
    }

    function Get-WikiAnchor {
        param([string]$FilePath)
        $text = Get-Content -LiteralPath $FilePath -Raw
        $anchors = @()
        foreach ($m in [regex]::Matches($text, '<a\s+[^>]*\b(?:id|name)\s*=\s*"([^"]+)"')) {
            $anchors += $m.Groups[1].Value
        }
        foreach ($line in ($text -split "`r?`n")) {
            $h = [regex]::Match($line, '^\s*#{1,6}\s+(.+?)\s*$')
            if (-not $h.Success) { continue }
            $slug = $h.Groups[1].Value.ToLowerInvariant() -replace '[^\p{L}\p{N}\s_-]', ''
            $slug = ($slug -replace '\s+', '-').Trim('-')
            if ($slug) { $anchors += $slug }
        }
        return @($anchors | Select-Object -Unique)
    }

    $script:PageLinks = @()
    foreach ($file in (Get-ChildItem -Path $script:WikiDir -Filter '*.md' -File)) {
        $script:PageLinks += @(Get-WikiPageLink -FilePath $file.FullName)
    }
}

Describe 'Wiki page-form links' -Tag 'Unit' {

    Context 'link targets' {
        It 'every extensionless Wiki link names a page that exists in Wiki/' {
            $missing = @($script:PageLinks | Where-Object {
                -not (Test-Path -LiteralPath (Join-Path $script:WikiDir ($_.Page + '.md')))
            } | ForEach-Object { "$([System.IO.Path]::GetFileName($_.File)):$($_.Line) -> $($_.Page)" })
            $missing | Should -BeNullOrEmpty -Because 'a page-form link the Wiki cannot resolve is a dead end for the reader, and lychee is excluded from seeing it'
        }

        It 'every fragment on those links matches an anchor the target page defines' {
            $bad = @()
            foreach ($link in @($script:PageLinks | Where-Object { $_.Fragment })) {
                $target = Join-Path $script:WikiDir ($link.Page + '.md')
                if (-not (Test-Path -LiteralPath $target)) { continue }
                $decoded = [System.Uri]::UnescapeDataString($link.Fragment)
                if ((Get-WikiAnchor -FilePath $target) -notcontains $decoded) {
                    $bad += "$([System.IO.Path]::GetFileName($link.File)):$($link.Line) -> $($link.Page)#$($link.Fragment)"
                }
            }
            $bad | Should -BeNullOrEmpty -Because 'a fragment matching no anchor drops the reader at the top of the page instead of the section the link promises'
        }
    }

    Context 'the lychee exclusion that hides these links' {
        It 'is carried identically by both CI hosts' {
            $github = Join-Path $ProjectRoot '.github/workflows/link-check.yml'
            $gitlab = Join-Path $ProjectRoot '.gitlab-ci.yml'
            $inGithub = (Get-Content -LiteralPath $github -Raw).Contains($script:WikiExclusion)
            $inGitLab = (Get-Content -LiteralPath $gitlab -Raw).Contains($script:WikiExclusion)
            ($inGithub -and $inGitLab) | Should -BeTrue -Because 'the two hosts run the same lychee version with the same arguments, so an exclusion present on one and missing on the other fails one gate while the other stays green'
        }

        It 'has nothing left to hide: no Wiki page links to a sibling with the .md suffix' {
            # The exclusion above exists for the page form. A surviving
            # Page.md link is checked by lychee but opens the raw blob on the
            # wiki, so either side going green proves nothing about the reader.
            # This pins the migration: the suffix form must not creep back.
            $suffixed = @()
            foreach ($file in (Get-ChildItem -Path $script:WikiDir -Filter '*.md' -File)) {
                $lineNo = 0
                $inFence = $false
                foreach ($line in (Get-Content -LiteralPath $file.FullName)) {
                    $lineNo++
                    if ($line -match '^\s*```') { $inFence = -not $inFence; continue }
                    if ($inFence) { continue }
                    $prose = [regex]::Replace($line, '`[^`]*`', '')
                    foreach ($m in [regex]::Matches($prose, '(?<!\!)\[[^\]]*\]\(([A-Za-z0-9_-]+)\.md([)#])')) {
                        $suffixed += "$($file.Name):$lineNo -> $($m.Groups[1].Value).md"
                    }
                }
            }
            $suffixed | Should -BeNullOrEmpty -Because 'a .md-suffixed Wiki link renders as the raw file on the wiki while passing every automated check'
        }
    }
}
