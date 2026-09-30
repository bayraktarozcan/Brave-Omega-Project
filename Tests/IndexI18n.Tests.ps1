#Requires -Version 5.1
<#
.SYNOPSIS
    Guards the bilingual integrity of the landing page.

.DESCRIPTION
    The page ships the same sentences three times: in the tr table, in the en
    table, and as static text in the markup. setLang rewrites the markup with
    textContent, so the static copy is what a visitor without JavaScript sees
    and what every reader sees before the script runs. Those three copies
    drifted apart, and nothing caught it: a passing test suite, a clean build
    and a green deployment all said nothing about the sentences a reader would
    actually see.

    One file, one invariant, as every other test in this tree is. Each It
    below states a rule the page must keep holding, so a break is reported by
    name instead of by line number.

    Two properties are asserted here on purpose:

    * The checks re-derive every expectation from the bytes on disk. A writer
      that also grades its own homework agrees with itself and detects nothing.
    * Character comparisons are ordinal. This host runs a Turkish locale, where
      PowerShell's -match and -ne fold case through the culture: 'i' and 'I'
      are the same letter, 'I' and 'ı' are the same letter, and U+0130 matches a
      plain 'i'. A regex over Turkish characters written with -match therefore
      reports "Policies" as containing a Turkish character, and a -ne over two
      texts differing only in that letter calls them equal. Both hide exactly
      the mojibake this file exists to catch, so nothing here relies on
      culture-aware comparison.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

BeforeAll {
    $indexPath = Join-Path (Split-Path -Parent $PSScriptRoot) 'index.html'
    if (-not (Test-Path -LiteralPath $indexPath)) {
        throw "index.html not found at $indexPath"
    }

    # Read bytes, never Get-Content: a BOM or a lone LF would be invisible to a
    # line-oriented read and both are defects this file is meant to catch.
    $script:Bytes = [System.IO.File]::ReadAllBytes($indexPath)
    $script:Text = [System.Text.Encoding]::UTF8.GetString($script:Bytes)

    # Strip script blocks so a translation table is never mistaken for markup.
    $script:Markup = [regex]::Replace($script:Text, '(?is)<script\b.*?</script>', '')

    # --- a JS-string aware object reader, so \" and \\ inside values survive ---

    function script:Read-StringAt {
        param([string]$Source, [int]$QuoteIndex)
        $sb = [System.Text.StringBuilder]::new()
        $i = $QuoteIndex + 1
        while ($i -lt $Source.Length) {
            $ch = $Source[$i]
            if ($ch -eq '\') {
                [void]$sb.Append($ch)
                [void]$sb.Append($Source[$i + 1])
                $i += 2
                continue
            }
            if ($ch -eq '"') {
                return [pscustomobject]@{ Value = $sb.ToString(); Next = $i + 1 }
            }
            [void]$sb.Append($ch)
            $i++
        }
        throw 'unterminated string literal'
    }

    function script:Read-Object {
        param([string]$Source, [int]$Start)
        $map = [ordered]@{}
        $dups = [System.Collections.Generic.List[string]]::new()
        $i = $Start
        while ($i -lt $Source.Length) {
            while ($i -lt $Source.Length -and ([char]::IsWhiteSpace($Source[$i]) -or $Source[$i] -eq ',')) { $i++ }
            if ($i -ge $Source.Length -or $Source[$i] -eq '}') { break }
            $nameStart = $i
            while ($i -lt $Source.Length -and ($Source[$i] -match '[A-Za-z0-9_$]')) { $i++ }
            $key = $Source.Substring($nameStart, $i - $nameStart)
            while ($i -lt $Source.Length -and $Source[$i] -ne ':') { $i++ }
            $i++
            while ($i -lt $Source.Length -and [char]::IsWhiteSpace($Source[$i])) { $i++ }
            if ($Source[$i] -ne '"') { throw "value for '$key' is not a string literal" }
            $read = script:Read-StringAt -Source $Source -QuoteIndex $i
            if ($map.Contains($key)) { $dups.Add($key) }
            $map[$key] = $read.Value
            $i = $read.Next
        }
        return [pscustomobject]@{ Keys = @($map.Keys); Map = $map; Duplicates = @($dups) }
    }

    function script:Unescape {
        param([string]$Value)
        return [regex]::Replace($Value, '\\u([0-9a-fA-F]{4})|\\(.)', {
            param($m)
            if ($m.Groups[1].Success) { return [char][Convert]::ToInt32($m.Groups[1].Value, 16) }
            switch ($m.Groups[2].Value) {
                'n' { "`n" } 't' { "`t" } 'r' { "`r" }
                '"' { '"' } "'" { "'" } '/' { '/' } '\' { '\' } '`' { '`' }
                default { $m.Groups[2].Value }
            }
        })
    }

    function script:HtmlText {
        param([string]$Fragment)
        $s = [regex]::Replace($Fragment, '<[^>]+>', '')
        return $s -replace '&amp;', '&' -replace '&lt;', '<' -replace '&gt;', '>' -replace '&quot;', '"' -replace '&#39;', "'"
    }

    # The exact characters that make a value Turkish, as code points. Listed as
    # characters rather than as a pattern so no regex engine can reinterpret
    # them: IndexOfAny is ordinal, and ordinal has no case and no culture.
    $script:TurkishChars = @(
        [char]0x00E7, [char]0x015F, [char]0x011F, [char]0x00FC,
        [char]0x00F6, [char]0x0131, [char]0x0130
    )

    # --- locate the two tables inside `const translations = {` ---------------

    $constAt = $script:Text.IndexOf('const translations = {')
    if ($constAt -lt 0) { throw 'const translations = { not found' }
    $trAt = $script:Text.IndexOf('        tr: {', $constAt)
    $enAt = $script:Text.IndexOf('        en: {', $constAt)
    if ($trAt -lt 0 -or $enAt -lt 0) { throw 'tr or en table not found' }
    $script:Tr = script:Read-Object -Source $script:Text -Start ($trAt + '        tr: {'.Length)
    $script:En = script:Read-Object -Source $script:Text -Start ($enAt + '        en: {'.Length)

    # --- walk every data-i18n element, tag-aware and quote-aware ------------

    $script:Elements = [System.Collections.Generic.List[object]]::new()
    $attr = 'data-i18n="'
    $p = $script:Markup.IndexOf($attr)
    while ($p -ge 0) {
        $q = $p + $attr.Length
        $e = $script:Markup.IndexOf('"', $q)
        $key = $script:Markup.Substring($q, $e - $q)

        $lt = $script:Markup.LastIndexOf('<', $p)
        $tagName = $null
        $tagEnd = -1
        if ($lt -ge 0) {
            $m = [regex]::Match($script:Markup.Substring($lt), '^<([A-Za-z][\w-]*)')
            if ($m.Success) { $tagName = $m.Groups[1].Value; $tagEnd = $lt + $m.Length }
        }
        $gt = $script:Markup.IndexOf('>', $tagEnd)
        $wellFormed = ($null -ne $tagName) -and ($gt -gt $p)

        $text = $null
        if ($wellFormed) {
            $i = $e + 1
            $quote = [char]0
            while ($i -lt $script:Markup.Length) {
                $c = $script:Markup[$i]
                if ($quote -ne [char]0) {
                    if ($c -eq $quote) { $quote = [char]0 }
                }
                elseif ($c -eq '"' -or $c -eq "'") { $quote = $c }
                elseif ($c -eq '>') { break }
                $i++
            }
            $close = $script:Markup.IndexOf("</$tagName", $i + 1)
            $text = $script:Markup.Substring($i + 1, $close - $i - 1)
        }

        $script:Elements.Add([pscustomobject]@{
            Key        = $key
            Tag        = $tagName
            WellFormed = $wellFormed
            Text       = $text
        })
        $p = $script:Markup.IndexOf($attr, $e)
    }
    $script:MarkupKeys = @($script:Elements | ForEach-Object { $_.Key } | Select-Object -Unique)
}

Describe 'Landing page bilingual integrity' {

    Context 'File encoding' {

        It 'is saved without a UTF-8 BOM' {
            # A BOM makes the byte count and the first key disagree, and it is
            # invisible in most editors. Asserted on the bytes themselves so
            # the check cannot be satisfied by a decoded string.
            $hasBom = $script:Bytes.Length -ge 3 -and
                      $script:Bytes[0] -eq 0xEF -and
                      $script:Bytes[1] -eq 0xBB -and
                      $script:Bytes[2] -eq 0xBF
            $hasBom | Should -BeFalse
        }

        It 'uses one line ending style throughout' {
            # Deliberately not "CRLF". The tracked blob is LF and a Windows
            # checkout rewrites it to CRLF through core.autocrlf, so a style
            # assertion measures the checkout rather than the content: it passes
            # on the machine that wrote the file and fails on every other clone.
            #
            # A consistent file is all CRLF or all bare LF, so a bare LF is not
            # a defect on its own - in a uniform LF file every terminator is
            # one. The defect is both styles in one file, plus the bare CR that
            # is never a terminator. The two styles are counted separately
            # because deriving one from the other only works while CRLF is in
            # the majority, which is the very assumption being removed.
            $crlf = ([regex]::Matches($script:Text, "`r`n")).Count
            $bareLf = ([regex]::Matches($script:Text, "(?<!`r)`n")).Count
            $bareCr = ([regex]::Matches($script:Text, "`r(?!`n)")).Count
            $mixed = ($crlf -gt 0 -and $bareLf -gt 0) -or $bareCr -gt 0
            $mixed | Should -BeFalse
        }
    }

    Context 'The two translation tables' {

        It 'declares the same set of keys in tr and en' {
            # Compared with -ccontains rather than Should -Be, because
            # Should -Be folds case and a key pair differing only in case would
            # then pass.
            $trKeys = @($script:Tr.Keys)
            $enKeys = @($script:En.Keys)
            @($trKeys | Where-Object { $enKeys -cnotcontains $_ }) | Should -BeNullOrEmpty
            @($enKeys | Where-Object { $trKeys -cnotcontains $_ }) | Should -BeNullOrEmpty
        }

        It 'does not require tr and en to list their keys in the same order' {
            # Stated as its own test because the tempting fix for a key-set
            # failure is to reorder one table, which would then be a real
            # behavioural change to the page. Order is not a rule here, and
            # a test that says so stops the next reader from "correcting" it.
            $script:Tr.Keys.Count | Should -Be $script:En.Keys.Count
            $script:Tr.Keys[0] | Should -Not -BeNullOrEmpty
            $script:En.Keys[0] | Should -Not -BeNullOrEmpty
        }

        It 'declares no key twice in tr' {
            $script:Tr.Duplicates | Should -BeNullOrEmpty
        }

        It 'declares no key twice in en' {
            $script:En.Duplicates | Should -BeNullOrEmpty
        }

        It 'keeps one tr source of truth with no override applied afterwards' {
            # Object.assign(translations.tr, ...) was a second source: an edit
            # made to the table appeared to do nothing, and the static markup
            # disagreed with both. A translation page has exactly one tr table.
            $script:Text | Should -Not -Match 'Object\.assign\(\s*translations\.tr'
        }
    }

    Context 'Markup' {

        It 'places every data-i18n attribute on a real element' {
            # setLang resolves elements with querySelectorAll, so an attribute
            # that is not on a tag can never be translated: the key looks
            # translated in the source and is dead in the browser.
            @($script:Elements | Where-Object { -not $_.WellFormed } | ForEach-Object { $_.Key }) |
                Should -BeNullOrEmpty
        }

        It 'translates every data-i18n key that the markup declares' {
            $trKeys = @($script:Tr.Keys)
            $enKeys = @($script:En.Keys)
            @($script:MarkupKeys | Where-Object { $trKeys -cnotcontains $_ }) | Should -BeNullOrEmpty
            @($script:MarkupKeys | Where-Object { $enKeys -cnotcontains $_ }) | Should -BeNullOrEmpty
        }

        It 'uses every key that the tables declare' {
            # A key nobody renders is either a typo or a string that was meant
            # to be marked up; both are invisible without this check.
            $markupKeys = @($script:MarkupKeys)
            @($script:Tr.Keys | Where-Object { $markupKeys -cnotcontains $_ }) | Should -BeNullOrEmpty
            @($script:En.Keys | Where-Object { $markupKeys -cnotcontains $_ }) | Should -BeNullOrEmpty
        }

        It 'gives the same static text to every element that shares a key' {
            # The same sentence is repeated in the hero, the card and the table
            # row. If one copy drifts, the page contradicts itself in a single
            # viewport and no language switch will reveal it. Compared with -cne
            # so a difference in that one Turkish letter is still a difference.
            $drifted = @(
                $script:Elements |
                    Where-Object { $_.WellFormed } |
                    Group-Object Key |
                    ForEach-Object {
                        $texts = @($_.Group | ForEach-Object { (script:HtmlText $_.Text).Trim() })
                        $first = $texts[0]
                        if (@($texts | Where-Object { $_ -cne $first }).Count -gt 0) { $_.Name }
                    }
            )
            $drifted | Should -BeNullOrEmpty
        }

        It 'keeps the static text equal to the tr value for every element' {
            # The static copy is the no-JavaScript page, and the tr table is
            # what setLang writes over it on load. When the two disagree, the
            # page shows one sentence before the script runs and another after,
            # and the reader never learns which one the project means.
            $mismatched = @(
                $script:Elements |
                    Where-Object { $_.WellFormed -and $script:Tr.Map.Contains($_.Key) } |
                    Where-Object {
                        (script:HtmlText $_.Text).Trim() -cne (script:Unescape $script:Tr.Map[$_.Key]).Trim()
                    } |
                    ForEach-Object { $_.Key } |
                    Select-Object -Unique
            )
            $mismatched | Should -BeNullOrEmpty
        }

        It 'renders no \uXXXX escape as visible text' {
            # A literal \u0130 left in the markup is shown to the reader
            # verbatim, and every browser-based inspection of the file agrees
            # the text is correct while the page is not.
            [regex]::Matches($script:Markup, '(\\u[0-9a-fA-F]{4})+') | Should -BeNullOrEmpty
        }

        It 'keeps no nested markup inside a data-i18n element' {
            # setLang assigns textContent, so a <br> or a <strong> inside one
            # of these elements is deleted the moment the language is applied.
            $nested = @(
                $script:Elements |
                    Where-Object { $_.WellFormed -and $_.Text -match '<[A-Za-z/]' } |
                    ForEach-Object { $_.Key } |
                    Select-Object -Unique
            )
            $nested | Should -BeNullOrEmpty
        }
    }

    Context 'English table' {

        It 'contains no Turkish characters' {
            # A Turkish character in the en table is a copy-paste that survives
            # review because the surrounding sentence is still readable.
            # IndexOfAny is ordinal, so a plain 'i' is not an 'İ' here.
            $leaked = @(
                $script:En.Keys |
                    Where-Object {
                        (script:Unescape $script:En.Map[$_]).IndexOfAny($script:TurkishChars) -ge 0
                    }
            )
            $leaked | Should -BeNullOrEmpty
        }

        It 'differs from tr for every translatable key' {
            # Equal values are usually a missing translation, but product names,
            # version columns and the PowerShell edition are legitimately the
            # same in both tables, so the allowlist is named rather than implied.
            $allowed = @(
                'compat_col_chromium', 'compat_col_omega', 'compat_col_windows',
                'prereq_ps_title', 'term_title'
            )
            $identical = @(
                $script:En.Keys |
                    Where-Object {
                        $script:Tr.Map.Contains($_) -and
                        (script:Unescape $script:En.Map[$_]) -ceq (script:Unescape $script:Tr.Map[$_]) -and
                        $allowed -cnotcontains $_
                    }
            )
            $identical | Should -BeNullOrEmpty
        }
    }
}
