<#
.SYNOPSIS
    Audits published releases on GitHub and GitLab against the §12 rule.
.DESCRIPTION
    Read-only. Checks, by name: pair-count, title-format, body-structure,
    no-garbage and cross-host. Any failure exits 1.

    GitHub is read with gh; GitLab is read through its public REST API, with
    glab only as a local fallback. No credential is needed for the read-only
    audit. Bodies are compared after LF normalization and trailing trim.

.PARAMETER Library
    Define the functions without running the audit. Used by the Pester suite.
#>
param(
    [switch]$Library,
    [string]$Repository = 'bayraktarozcan/Brave-Omega-Project',
    [string]$GitLabProject = 'bayraktarozcan%2FBrave-Omega-Project'
)

$ErrorActionPreference = 'Stop'

# v1.0 and v1.1 notes were curated after the post-release audit: their
# changelog bullets are more granular than the published summary, and the
# audit deliberately removed unrelated global content. Keep the exemption
# named and narrow so it cannot silently spread to newer releases.
$script:CoverageExemptTags = @('v1.0', 'v1.1')

function Get-CurrentVersion {
    $path = Join-Path (Split-Path -Parent $PSScriptRoot) 'Brave-Omega\BraveOmega.ps1'
    $text = [System.IO.File]::ReadAllText($path)
    $match = [regex]::Match($text, '\$ScriptVersion\s*=\s*"v([0-9.]+)"')
    if (-not $match.Success) { throw 'current version not found in BraveOmega.ps1' }
    return 'v' + $match.Groups[1].Value
}

function Normalize-ReleaseBody {
    param([string]$Body)
    if ($null -eq $Body) { return '' }
    return $Body.Replace("`r`n", "`n").Replace("`r", "`n").TrimEnd("`n")
}

function Get-GitHubReleases {
    param([string]$Repo)
    $json = & gh api --paginate "repos/$Repo/releases" 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0) { throw "gh release listing failed: $json" }
    # Windows PowerShell 5.1 wraps a multi-document JSON array as one object
    # when it is piped straight into @(...). Assign first, then wrap so both
    # engines enumerate the releases identically.
    $parsed = $json | ConvertFrom-Json
    $items = @($parsed)
    if ($items.Count -eq 0) { throw 'empty GitHub release list' }
    return @($items | ForEach-Object {
        [pscustomobject]@{ tag_name = $_.tag_name; name = $_.name; body = $_.body }
    })
}

function Get-GitLabReleases {
    param([string]$Project)
    $url = "https://gitlab.com/api/v4/projects/$Project/releases?per_page=100"
    # The project is public, so a read-only audit needs no credential. Passing
    # a write-capable push token here would violate least privilege.
    # ConvertFrom-Json on the raw body keeps a 51-element array as 51 items on
    # every host; Invoke-RestMethod returned one wrapping object on Linux.
    try {
        $response = Invoke-WebRequest -Uri $url -TimeoutSec 30 -UseBasicParsing
        # PS 5.1 can decode a charset-less JSON body as Latin-1, turning em
        # dashes into mojibake before the byte-parity check ever sees them.
        $stream = $response.RawContentStream
        $jsonText = $response.Content
        if ($null -ne $stream -and $stream.Length -gt 0) {
            $stream.Position = 0
            $bytes = New-Object byte[] $stream.Length
            [void]$stream.Read($bytes, 0, $bytes.Length)
            $jsonText = [System.Text.Encoding]::UTF8.GetString($bytes)
        }
        $parsed = $jsonText | ConvertFrom-Json
        $items = @($parsed)
        if ($items.Count -eq 0) { throw 'empty release list' }
    } catch {
        $json = & glab api "projects/$Project/releases?per_page=100" 2>&1 | Out-String
        if ($LASTEXITCODE -ne 0) { throw "GitLab release listing failed: $_; glab: $json" }
        $parsed = $json | ConvertFrom-Json
        $items = @($parsed)
    }
    return @($items | ForEach-Object {
        [pscustomobject]@{ tag_name = $_.tag_name; name = $_.name; body = $_.description }
    })
}

function Get-NormalizedWords {
    param([string]$Text)
    $clean = [regex]::Replace($Text, '[^\p{L}\p{N} ]', ' ')
    return @($clean.ToLowerInvariant().Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries))
}

function Test-NoteGenerator {
    param([string]$CurrentTag, [string]$GeneratorPath, [string]$RepoRoot)
    if (-not (Test-Path -LiteralPath $GeneratorPath)) { return @('note-generator: Build-ReleaseNotes.ps1 missing') }
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('note-gen-' + [guid]::NewGuid().ToString('N') + '.md')
    try {
        $null = & $GeneratorPath -Version $CurrentTag.TrimStart('v', 'V') -Current -Output $tmp 2>&1
        if (-not (Test-Path -LiteralPath $tmp)) { return @('note-generator: no body produced') }
        $body = [System.IO.File]::ReadAllText($tmp)
        $required = @('### Summary', '### Files', '### Documentation',
            '### Özet', '### Dosyalar', '### Belgelendirme')
        $missing = @($required | Where-Object { -not $body.Contains($_) })
        if ($missing.Count -gt 0) { return @('note-generator: missing ' + ($missing -join ', ')) }
        if ($body -cnotmatch '(?ms)^### Summary\s*\n+\S') { return @('note-generator: empty English summary') }
        if ($body -cnotmatch '(?ms)^### Özet\s*\n+\S') { return @('note-generator: empty Turkish summary') }
        $enContent = @([regex]::Matches($body, '(?m)^### (Added|Changed|Removed|Fixed)\s*$'))
        $trContent = @([regex]::Matches($body, '(?m)^### (Eklendi|Eklenenler|Değiştirildi|Değiştirilenler|Kaldırıldı|Kaldırılanlar|Düzeltildi|Düzeltilendi|Düzeltilenler)\s*$'))
        if ($enContent.Count -eq 0 -or $trContent.Count -eq 0 -or $enContent.Count -ne $trContent.Count) {
            return @('note-generator: EN/TR content sections differ')
        }
        if (@([regex]::Matches($body, '(?m)^## v')).Count -ne 2) {
            return @('note-generator: body does not have two version headings')
        }
        return @()
    } catch {
        return @("note-generator: $_")
    } finally {
        if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Force }
    }
}

function Test-ReleaseHygiene {
    param(
        [object[]]$GitHub,
        [object[]]$GitLab,
        [string]$CurrentTag,
        [string]$ChangelogPath = (Join-Path (Split-Path -Parent $PSScriptRoot) 'CHANGELOG.md')
    )
    $failures = @()
    $ghByTag = @{}
    foreach ($r in $GitHub) { $ghByTag[$r.tag_name] = $r }
    $glByTag = @{}
    foreach ($r in $GitLab) { $glByTag[$r.tag_name] = $r }

    $ghOnly = @($ghByTag.Keys | Where-Object { -not $glByTag.ContainsKey($_) })
    $glOnly = @($glByTag.Keys | Where-Object { -not $ghByTag.ContainsKey($_) })
    if ($ghOnly.Count -gt 0 -or $glOnly.Count -gt 0) {
        Write-Host "pair-count detail: gh=$($ghByTag.Count) gl=$($glByTag.Count) gh-only=[$($ghOnly -join ',')] gl-only=[$($glOnly -join ',')]"
        $failures += 'pair-count: the hosts report different tag sets'
    } else {
        Write-Host "PASS pair-count: $($ghByTag.Count) releases on both hosts"
    }

    $badTitles = @()
    foreach ($tag in $ghByTag.Keys) {
        $title = [string]$ghByTag[$tag].name
        $expected = '^' + [regex]::Escape($tag) + ' — \S'
        if ($tag -eq $CurrentTag) {
            if ($title -cnotmatch $expected -or $title -match '\[DEPRECATED\]') { $badTitles += $tag }
        } else {
            if ($title -cnotmatch '^\[DEPRECATED\] ' + [regex]::Escape($tag) + ' — \S') { $badTitles += $tag }
        }
        if (([regex]::Matches($title, [regex]::Escape($tag))).Count -ne 1) { $badTitles += "$tag (tag repeated)" }
    }
    if ($badTitles.Count) { $failures += 'title-format: ' + ($badTitles -join ', ') }
    else { Write-Host 'PASS title-format: all titles canonical' }

    $badBodies = @()
    $garbage = @()
    $enCore = @('Summary', 'Files', 'Documentation')
    $trCore = @('Özet', 'Dosyalar', 'Belgelendirme')
    $enContent = @('Added', 'Changed', 'Removed', 'Fixed', 'Statistics')
    # Release bodies written before the template used several Turkish
    # variants for the same section; all of them are valid scope markers.
    $trContent = @(
        'Eklendi', 'Eklenenler', 'Değiştirildi', 'Değiştirilenler',
        'Kaldırıldı', 'Kaldırılanlar', 'Düzeltilendi', 'Düzeltilenler',
        'Düzeltildi', 'Değişti', 'İstatistikler'
    )
    foreach ($tag in $ghByTag.Keys) {
        $body = Normalize-ReleaseBody -Body ([string]$ghByTag[$tag].body)
        $halves = @([regex]::Split($body, '(?m)^## v'))
        if ($halves.Count -lt 3) { $badBodies += "$tag (no bilingual halves)"; continue }
        $en = $halves[1]
        $tr = '## v' + $halves[2]
        $enHeads = @([regex]::Matches($en, '(?m)^### (.+)$') | ForEach-Object { $_.Groups[1].Value.Trim() })
        $trHeads = @([regex]::Matches($tr, '(?m)^### (.+)$') | ForEach-Object { $_.Groups[1].Value.Trim() })
        foreach ($h in $enCore) { if ($enHeads -cnotcontains $h) { $badBodies += "$tag (missing $h)" } }
        foreach ($h in $trCore) { if ($trHeads -cnotcontains $h) { $badBodies += "$tag (missing $h)" } }
        $enCount = @($enHeads | Where-Object { $enContent -ccontains $_ }).Count
        $trCount = @($trHeads | Where-Object { $trContent -ccontains $_ }).Count
        if ($enCount -ne $trCount) { $badBodies += "$tag (EN/TR scope differs)" }

        # A #N inside Markdown link text is an explicit link, not an
        # accidental GitHub autolink. A bare one in prose still is.
        # "Fixes #50" is an intentional GitHub keyword link, not a bare token.
        if ($body -cmatch '(?m)^\s*\|\s*#\d+' -or
            $body -cmatch '(?<!Fixes )(?<!\w)#\d+\b(?!\]\()') { $garbage += "$tag (bare #N)" }
        if ($body -match 'Table of Contents|İçindekiler|<details|<a id=') { $garbage += "$tag (embedded TOC)" }
        foreach ($other in $ghByTag.Keys) {
            if ($other -cne $tag -and $body -cmatch '(?m)^## ' + [regex]::Escape($other) + ' —') {
                $garbage += "$tag (other version $other)"
                break
            }
        }
    }
    if ($badBodies.Count) { $failures += 'body-structure: ' + ($badBodies -join ', ') }
    else { Write-Host 'PASS body-structure: bilingual sections present' }
    if ($garbage.Count) { $failures += 'no-garbage: ' + ($garbage -join ', ') }
    else { Write-Host 'PASS no-garbage: no autolinks, TOCs or foreign versions' }

    $mismatch = @()
    foreach ($tag in $ghByTag.Keys) {
        if (-not $glByTag.ContainsKey($tag)) { continue }
        $a = Normalize-ReleaseBody -Body ([string]$ghByTag[$tag].body)
        $b = Normalize-ReleaseBody -Body ([string]$glByTag[$tag].body)
        if ($a -cne $b -or [string]$ghByTag[$tag].name -cne [string]$glByTag[$tag].name) { $mismatch += $tag }
    }
    if ($mismatch.Count) { $failures += 'cross-host: ' + ($mismatch -join ', ') }
    else { Write-Host 'PASS cross-host: titles and bodies byte-identical after LF normalization' }

    # Every changelog bullet under a released version must still be visible
    # in that release's notes, in the matching language half. Cross-host byte
    # parity proves both hosts publish the same text, not that each language
    # still carries its own changelog content.
    if (-not (Test-Path -LiteralPath $ChangelogPath)) {
        $failures += 'changelog-coverage: CHANGELOG.md not found'
        return $failures
    }
    $changelog = [System.IO.File]::ReadAllText($ChangelogPath)
    $enStart = $changelog.IndexOf('## EN English Changelog')
    $trStart = $changelog.IndexOf('## TR Türkçe Değişiklik Günlüğü')
    if ($enStart -lt 0 -or $trStart -le $enStart) {
        $failures += 'changelog-coverage: English changelog half not found'
        return $failures
    }
    $enHalf = $changelog.Substring($enStart, $trStart - $enStart)
    $trHalf = $changelog.Substring($trStart)
    $uncovered = @()
    foreach ($tag in $ghByTag.Keys) {
        if ($script:CoverageExemptTags -ccontains $tag) { continue }
        $version = [regex]::Escape($tag.TrimStart('v'))
        $halves = @([regex]::Split((Normalize-ReleaseBody -Body ([string]$ghByTag[$tag].body)), '(?m)^## v'))
        $languages = @(
            @{ Name = 'EN'; Lines = @($enHalf -split "`n"); Body = $(if ($halves.Count -ge 2) { $halves[1] } else { '' }) },
            @{ Name = 'TR'; Lines = @($trHalf -split "`n"); Body = $(if ($halves.Count -ge 3) { $halves[2] } else { '' }) }
        )
        foreach ($language in $languages) {
            $lines = @($language.Lines)
            $start = -1
            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -cmatch "^## \[v?$version\]") { $start = $i; break }
            }
            if ($start -lt 0) { $uncovered += "${tag} $($language.Name): no changelog section"; continue }
            $end = $lines.Count
            for ($i = $start + 1; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -cmatch '^## ') { $end = $i; break }
            }
            $bodyWords = @(Get-NormalizedWords -Text ([string]$language.Body))
            for ($i = $start + 1; $i -lt $end; $i++) {
                $line = $lines[$i]
                if ($line -cnotmatch '^\s*- ') { continue }
                $bold = [regex]::Match($line, '^\s*-\s+\*\*(.+?)\*\*')
                if ($bold.Success) { $prose = $bold.Groups[1].Value }
                else { $prose = ([regex]::Replace($line, '^\s*-\s+', '') -replace '[*`]', '').Split('.')[0] }
                $lead = @(Get-NormalizedWords -Text $prose | Select-Object -First 4)
                if ($lead.Count -eq 0) { continue }
                $missing = @($lead | Where-Object { $bodyWords -cnotcontains $_ })
                if ($missing.Count -gt 0) { $uncovered += "${tag} $($language.Name): $($lead -join ' ')" }
            }
        }
    }
    if ($uncovered.Count) {
        $failures += 'changelog-coverage: ' + (($uncovered | Select-Object -First 10) -join ', ')
        Write-Host 'changelog-coverage detail: first ten uncovered bullets shown'
    } else {
        Write-Host 'PASS changelog-coverage: every changelog bullet is represented in its notes'
    }

    return $failures
}

if ($Library) { return }

$current = Get-CurrentVersion
$repoRoot = Split-Path -Parent $PSScriptRoot
$gh = @(Get-GitHubReleases -Repo $Repository)
$gl = @(Get-GitLabReleases -Project $GitLabProject)
$failures = @(Test-ReleaseHygiene -GitHub $gh -GitLab $gl -CurrentTag $current)
$failures += @(Test-NoteGenerator -CurrentTag $current -GeneratorPath (Join-Path $PSScriptRoot 'Build-ReleaseNotes.ps1') -RepoRoot $repoRoot)
if (@($failures | Where-Object { $_ -like 'note-generator:*' }).Count -eq 0) {
    Write-Host 'PASS note-generator: canonical bilingual notes for the current tag'
}
if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Host "FAIL $_" }
    exit 1
}
Write-Host 'PASS published release hygiene'
exit 0
