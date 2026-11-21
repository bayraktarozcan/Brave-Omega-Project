# Invariant: documentation headings follow the Title Case rule declared in
# AGENTS.md §12. The rule is easy to drift from because it spans 27 Markdown
# files; this guard reads the tree instead of trusting a one-time cleanup.
#
# What this check cannot see: HTML heading tags, prose comments, or whether a
# capitalized word is the *right* word. It checks casing only, on Markdown
# headings outside code fences, with the documented exceptions.

BeforeAll {
    $script:RepoRoot = Split-Path -Parent $PSScriptRoot
    $script:Minor = @('a','an','the','and','or','but','for','nor','of','on','per','to','via','with','as','at','by','in','if','ve','veya','ya','ile','için','den','dan','gibi','kadar','göre','karşın','ancak','fakat','çünkü','ki','bir')
    $script:Acronyms = @('ADMX','ADML','API','ASCII','BOM','CD','CI','CSV','DOM','GUID','HKCU','HKLM','HTML','HTTP','HTTPS','ID','JSON','JS','LTS','MD','OS','PDF','PS1','REG','SHA','SHA1','SHA256','SSL','TLS','UTC','URL','UTF','UTF8','XML','YAML','ZIP','CSS','IO','UI','UX','AI','CLI','CDN','DNS','GDPR','CCPA','TR','EN')
    $script:Mixed = @('ioc','powershell','github','gitlab','dependabot','pester','lychee','gitleaks','actionlint','omaha','markdown','javascript','i18n','changelog','readme','wiki','brave','chrome','chromium','windows','linux','git','codeql','yamllint')

    function Get-HeadingViolations {
        param([string]$Path)
        $violations = @()
        $lines = Get-Content -LiteralPath $Path
        $inFence = $false
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]
            if ($line -match '^\s*(```|~~~)') { $inFence = -not $inFence; continue }
            if ($inFence -or $line -notmatch '^(\s*)(#{1,6})\s+(.*)$') { continue }
            $text = $Matches[3]
            if ($text -cmatch 'İ(?:s|n|f|nto|nside)\b') {
                $violations += "$($Path):$($i+1): Turkish dotted I in an English word"
            }
            if ($text -match '^\[?v\d' -or $text -match '^\[?Unreleased' -or $text -match '^\[?Yayınlanmadı') { continue }
            if ((Split-Path -Leaf $Path) -eq 'Policy-Catalog.md' -and $text -match '— \d+ (policies|politika)') { continue }
            $words = @($text -split '\s+' | Where-Object { $_ -ne '' })
            for ($w = 0; $w -lt $words.Count; $w++) {
                $word = $words[$w]
                if ($word -match '[`\[<]' -or $word -match '://') { continue }
                $core = $word -replace '^[^A-Za-zÇĞİÖŞÜçğıöşü0-9]+','' -replace '[^A-Za-zÇĞİÖŞÜçğıöşü0-9]+$',''
                if ($core -eq '') { continue }
                $low = $core.ToLowerInvariant()
                if ($script:Mixed -contains $low) { continue }
                if ($script:Acronyms -contains $core.ToUpperInvariant()) { continue }
                if ($script:Minor -contains $low -and $w -gt 0 -and $w -lt $words.Count - 1) { continue }
                $subs = @($core -split '[-/]') | Where-Object { $_ -ne '' }
                foreach ($sub in $subs) {
                    $subLow = $sub.ToLowerInvariant()
                    if ($script:Mixed -contains $subLow -or $script:Acronyms -contains $sub.ToUpperInvariant()) { continue }
                    if ($script:Minor -contains $subLow -and $sub -ne $subs[0]) { continue }
                    if ($sub.Substring(0,1) -cne $sub.Substring(0,1).ToUpperInvariant()) {
                        $violations += "$($Path):$($i+1): $sub"
                    }
                }
            }
        }
        return $violations
    }
}

Describe 'Heading case invariants' -Tag 'Unit' {
    It 'the canonical rule and its Turkish mirror declare heading case' {
        $canonical = Get-Content -LiteralPath (Join-Path $script:RepoRoot 'AGENTS.md') -Raw
        $canonical | Should -Match '\*\*Heading case\.\*\*' -Because 'the universal rule must be written down before it can be enforced'
        $mirrorPath = Join-Path $script:RepoRoot 'AGENTS-TR.md'
        if (Test-Path -LiteralPath $mirrorPath) {
            (Get-Content -LiteralPath $mirrorPath -Raw) | Should -Match '\*\*Başlık büyüklüğü\.\*\*' -Because 'the mirror carries the same rule in Turkish'
        }
    }

    It 'documentation headings use title case' {
        $found = @()
        foreach ($file in (git ls-files '*.md')) {
            $found += @(Get-HeadingViolations -Path (Join-Path $script:RepoRoot $file))
        }
        $found | Should -BeNullOrEmpty -Because ('headings are documentation, not code: ' + ($found -join '; '))
    }
}
