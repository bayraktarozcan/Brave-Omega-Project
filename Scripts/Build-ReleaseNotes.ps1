<#
.SYNOPSIS
    Builds canonical release metadata from the canonical CHANGELOG.md.
.DESCRIPTION
    Reads the requested version's EN and TR sections from CHANGELOG.md and
    writes a bilingual release body (UTF-8, LF) to the output path. The first
    stdout line is the canonical title, so the release script can consume it.

    Garbage is excluded: bare #N tokens (GitHub turns them into issue/PR
    links), embedded changelog table of contents, other versions' rows and
    emoji-decorated headings.

.PARAMETER Version
    Bare version, e.g. 3.1.0.5 (a leading v is accepted and stripped).
.PARAMETER Output
    Path of the Markdown body file to write.
.PARAMETER Current
    Omit the [DEPRECATED] prefix (use for the version being published).
.EXAMPLE
    .\Scripts\Build-ReleaseNotes.ps1 3.1.0.5 .\notes.md -Current
#>
param(
    [Parameter(Mandatory = $true)][string]$Version,
    [Parameter(Mandatory = $true)][string]$Output,
    [switch]$Current
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$changelog = Join-Path $repoRoot 'CHANGELOG.md'
if (-not (Test-Path -LiteralPath $changelog)) { throw "CHANGELOG.md not found: $changelog" }

$minor = @('a','an','the','and','or','but','nor','for','of','on','per','to','via','with','as','at','by','in','if','ve','veya','ya','ile','için','bir','göre')
$acronyms = @{
    admx='ADMX'; adml='ADML'; api='API'; ci='CI'; cd='CD'; dns='DNS'; html='HTML'; json='JSON'
    lna='LNA'; owa='OWA'; pdf='PDF'; sha256='SHA256'; smime='S/MIME'; tls='TLS'; url='URL'
    utf8='UTF8'; guid='GUID'; gpg='GPG'; lts='LTS'; webrtc='WebRTC'; webusb='WebUSB'
}
$mixed = @{
    brave='Brave'; changelog='Changelog'; chromium='Chromium'; dependabot='Dependabot'
    github='GitHub'; gitlab='GitLab'; ioc='IoC'; javascript='JavaScript'; linux='Linux'
    markdown='Markdown'; omaha='Omaha'; pester='Pester'; powershell='PowerShell'
    wiki='Wiki'; windows='Windows'
}
$enHeadings = @{
    summary='Summary'; overview='Summary'; added='Added'; changed='Changed'; removed='Removed'
    fixed='Fixed'; notes='Notes'; verification='Verification'; files='Files'; documentation='Documentation'
}
$trHeadings = @{
    'özet'='Özet'; 'genel bakış'='Özet'; 'eklenenler'='Eklenenler'
    'değiştirilenler'='Değiştirilenler'; 'değişiklik'='Değiştirilenler'
    'kaldırılanlar'='Kaldırılanlar'; 'kaldırıldı'='Kaldırılanlar'
    'düzeltilenler'='Düzeltilenler'; 'düzeltildi'='Düzeltilenler'; 'notlar'='Notlar'
    'doğrulama'='Doğrulama'; 'dosyalar'='Dosyalar'; 'belgelendirme'='Belgelendirme'
}
$trCulture = [System.Globalization.CultureInfo]::new('tr-TR')
$invariant = [System.Globalization.CultureInfo]::InvariantCulture

function Convert-ToTitleCase {
    param([string]$Text, [bool]$Turkish = $false)
    $words = @()
    foreach ($token in ($Text -split '\s+')) {
        $word = $token.Trim('-/.,;:|()[]{}*"')
        if ([string]::IsNullOrEmpty($word)) { continue }
        $low = $word.ToLowerInvariant()
        if ($acronyms.ContainsKey($low)) { $words += $acronyms[$low]; continue }
        if ($mixed.ContainsKey($low)) { $words += $mixed[$low]; continue }
        if ($minor -contains $low -and $words.Count -gt 0) { $words += $low; continue }
        $parts = @()
        foreach ($part in @($word -split '[-/]' | Where-Object { $_ -ne '' })) {
            $pl = $part.ToLowerInvariant()
            if ($acronyms.ContainsKey($pl)) { $parts += $acronyms[$pl]; continue }
            if ($mixed.ContainsKey($pl)) { $parts += $mixed[$pl]; continue }
            if ($minor -contains $pl -and $parts.Count -gt 0) { $parts += $pl; continue }
            $culture = if ($Turkish -and $part -cmatch '[çğıöşüÇĞİÖŞÜ]') { $trCulture } else { $invariant }
            $parts += ($part.Substring(0, 1).ToUpper($culture) + $part.Substring(1))
        }
        $words += ($parts -join '-')
    }
    return ($words -join ' ')
}

$bytes = [System.IO.File]::ReadAllBytes($changelog)
$offset = 0
if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) { $offset = 3 }
$raw = [System.Text.Encoding]::UTF8.GetString($bytes, $offset, $bytes.Length - $offset)
$raw = $raw.Replace("`r`n", "`n").Replace("`r", "`n")
$trMarker = [regex]::Match($raw, '(?m)^##\s+TR\s+Türkçe.*$')
$enHalf = if ($trMarker.Success) { $raw.Substring(0, $trMarker.Index) } else { $raw }
$trHalf = if ($trMarker.Success) { $raw.Substring($trMarker.Index) } else { '' }

function Get-Section {
    param([string]$Half, [string]$Tag)
    $lines = @($Half -split "`n")
    $start = -1
    $description = ''
    $pattern = '^##\s*\[v' + [regex]::Escape($Tag) + '\]\s*[—–-]?\s*(.*)$'
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $m = [regex]::Match($lines[$i], $pattern)
        if ($m.Success) { $start = $i + 1; $description = $m.Groups[1].Value.Trim(); break }
    }
    if ($start -lt 0) { return @{ Lines = @(); Description = '' } }
    $body = @()
    for ($i = $start; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -cmatch '^##\s*\[v\d' -or $lines[$i] -cmatch '^##\s+TR\s+Türkçe') { break }
        $body += $lines[$i]
    }
    # The heading often holds only a date. Use the first prose sentence under
    # Summary / Özet as the canonical one-line description.
    for ($i = 0; $i -lt $body.Count; $i++) {
        if ($body[$i] -cnotmatch '^###\s*[^A-Za-zÇĞİÖŞÜçğıöşü]*\s*(Summary|Özet)\s*$') { continue }
        for ($j = $i + 1; $j -lt $body.Count; $j++) {
            $prose = $body[$j].Trim()
            if ([string]::IsNullOrWhiteSpace($prose) -or $prose -eq '---') { continue }
            $bold = [regex]::Match($prose, '^\*\*(.{3,260}?)\*\*')
            $desc = if ($bold.Success -and $bold.Groups[1].Value -cnotmatch '[^\u0000-\u2500]') {
                $bold.Groups[1].Value
            } else {
                # No lead-in: the first sentence is the canonical description.
                # A version such as 1.96.59 has no space after its dots, so it
                # survives this split.
                [regex]::Match($prose, '^[^.!?]+[.!?]?').Value
            }
            $desc = $desc.Replace('**', '')
            # Keep the characters that carry meaning in a release title:
            # dotted version numbers (1.96.59, 150.0.7871.128), inline code
            # backticks, ampersands, arrows and slash-separated acronyms.
            # Dropping them silently corrupts a title on deprecation.
            $desc = [regex]::Replace($desc, '(?<=\d)\.(?=\d)', '--DOT--')
            $desc = [regex]::Replace($desc, '[^\w\s—–›→&`/+\-]', '')
            $desc = $desc.Replace('--DOT--', '.')
            $desc = [regex]::Replace($desc, '^(v?\d+(\.\d+){1,3}|[A-Za-zÇĞİÖŞÜçğıöşü ]+?(release|sürümü))\s*[—–-]\s*', '', 'IgnoreCase')
            $desc = (($desc -split '\s+' | Where-Object { $_ -ne '' }) -join ' ').Trim(' ', '.', ':', '-')
            if (-not [string]::IsNullOrWhiteSpace($desc)) { $description = $desc }
            break
        }
        break
    }
    return @{ Lines = $body; Description = $description }
}

function Convert-Body {
    param([string[]]$Lines, [bool]$Turkish)
    $map = if ($Turkish) { $trHeadings } else { $enHeadings }
    $kept = @()
    foreach ($line in $Lines) {
        $trimmed = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmed)) {
            if ($kept.Count -gt 0 -and $kept[-1] -ne '') { $kept += '' }
            continue
        }
        if ($trimmed -eq '---' -or $trimmed -like '<a id=*' -or $trimmed -like '<*') { continue }
        if ($trimmed -cmatch '^#{1,2}\s') { continue }
        if ($trimmed -match 'Table of Contents|İçindekiler') { continue }
        if ($trimmed -cmatch '^\d+\.\s*\[' -or $trimmed -cmatch '^\s+\*\s*\[') { continue }
        if ($trimmed -cmatch '^\|\s*v\d' -or $trimmed -cmatch '^\|\s*#\d+') { continue }
        if ($trimmed -cmatch '^#{3,6}\s') {
            $heading = [regex]::Replace($trimmed, '^#{3,6}\s*[^A-Za-zÇĞİÖŞÜçğıöşü]*\s*', '')
            $key = [regex]::Replace($heading.ToLowerInvariant(), '\s+', ' ')
            $canonical = if ($map.ContainsKey($key)) { $map[$key] } else { Convert-ToTitleCase -Text $heading -Turkish $Turkish }
            $kept += "### $canonical"
            continue
        }
        $kept += $trimmed
    }
    while ($kept.Count -gt 0 -and $kept[-1] -eq '') { $kept = $kept[0..($kept.Count - 2)] }
    $body = $kept -join "`n"
    # Filtering rows out of a table can leave a header and separator with no
    # data rows. Drop the empty skeleton instead of shipping a broken table.
    $body = [regex]::Replace($body, '(?m)^\|[^\n]*\|\n\|[\s:|-]+\|\n(?=\n|### |\z)', '')
    return $body
}

$bare = $Version.TrimStart('v')
$en = Get-Section -Half $enHalf -Tag $bare
$tr = Get-Section -Half $trHalf -Tag $bare
if ($en.Lines.Count -eq 0) { throw "no changelog section for v$bare" }
if ($tr.Lines.Count -eq 0) { $tr = $en }
$enTitle = Convert-ToTitleCase -Text $en.Description
if ([string]::IsNullOrWhiteSpace($enTitle)) { $enTitle = 'Release' }
$trTitle = Convert-ToTitleCase -Text $tr.Description -Turkish $true
if ([string]::IsNullOrWhiteSpace($trTitle)) { $trTitle = $enTitle }

$fullTitle = "v$bare — $enTitle"
if (-not $Current) { $fullTitle = "[DEPRECATED] $fullTitle" }

$enBody = Convert-Body -Lines $en.Lines -Turkish $false
$trBody = Convert-Body -Lines $tr.Lines -Turkish $true
$filesEn = "### Files`n`n- ``Brave-Omega/BraveOmega.ps1`` — Unified bilingual script (EN/TR)`n- ``index.html`` — Single-page project landing page"
$docsEn = "### Documentation`n`n- [Wiki](https://github.com/bayraktarozcan/Brave-Omega-Project/wiki)`n- [Changelog](https://github.com/bayraktarozcan/Brave-Omega-Project/blob/main/CHANGELOG.md)"
$filesTr = "### Dosyalar`n`n- ``Brave-Omega/BraveOmega.ps1`` — Birleşik iki dilli betik (EN/TR)`n- ``index.html`` — Tek sayfalık proje açılış sayfası"
$docsTr = "### Belgelendirme`n`n- [Wiki](https://github.com/bayraktarozcan/Brave-Omega-Project/wiki)`n- [Değişiklik Günlüğü](https://github.com/bayraktarozcan/Brave-Omega-Project/blob/main/CHANGELOG.md)"
if ($enBody -cnotmatch '(?m)^### Files\s*$') { $enBody += "`n`n$filesEn" }
if ($enBody -cnotmatch '(?m)^### Documentation\s*$') { $enBody += "`n`n$docsEn" }
if ($trBody -cnotmatch '(?m)^### Dosyalar\s*$') { $trBody += "`n`n$filesTr" }
if ($trBody -cnotmatch '(?m)^### Belgelendirme\s*$') { $trBody += "`n`n$docsTr" }

$body = "## v$bare — $enTitle`n`n$enBody`n`n---`n`n## v$bare — $trTitle`n`n$trBody`n"
$dir = Split-Path -Parent $Output
if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
$utf8 = New-Object System.Text.UTF8Encoding($false)
$target = if ([System.IO.Path]::IsPathRooted($Output)) { $Output } else { Join-Path (Get-Location) $Output }
[System.IO.File]::WriteAllText($target, $body, $utf8)
Write-Output $fullTitle
