BeforeAll {
    $VerifierPath = Join-Path (Split-Path -Parent $PSScriptRoot) "Scripts/Verify-Mirror-Sync.ps1"

    # Same algorithm the verifier documents: drop the marker line, normalize
    # EOL to LF, hash what is left. Fixtures are built with it so a test never
    # depends on the hash of a real, frequently edited file.
    function Get-FixtureSha {
        param([string]$Body)

        # A here-string carries no trailing newline and the marker regex is
        # anchored at line start, so the marker always sits on a line of its
        # own. Removing that line therefore leaves the body plus the newline
        # that separated them, and that is what gets hashed.
        #
        # The normalization is not optional here. This file is a text file, so a
        # CRLF checkout hands us a CRLF body, while the verifier hashes the LF
        # form of whatever it reads. Without this the fixtures would only agree
        # on a checkout that happened to use LF.
        $normalized = ($Body -replace "`r`n", "`n") -replace "`r", "`n"
        $sha = [System.Security.Cryptography.SHA1]::Create()
        try {
            $hash = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("$normalized`n"))
        } finally {
            $sha.Dispose()
        }
        return (($hash | ForEach-Object { $_.ToString('x2') }) -join '')
    }

    function Write-Fixture {
        param([string]$Path, [string]$Body, [string]$Sha, [switch]$Crlf)

        $text = "$Body`n<!-- mirror-sync: sync-sha=$Sha -->`n"
        if ($Crlf) { $text = $text -replace "(?<!`r)`n", "`r`n" }
        [System.IO.File]::WriteAllText($Path, $text, (New-Object System.Text.UTF8Encoding $false))
        return $Path
    }

    function Invoke-SyncCheck {
        param([string]$Canonical, [string]$Mirror, [switch]$AllowMissing)

        $output = & $VerifierPath -Canonical $Canonical -Mirror $Mirror -AllowMissingMirror:$AllowMissing *>&1
        # Write-Host lands on the information stream, so a captured line arrives
        # wrapped in an InformationRecord. Unwrap it, or every failure line
        # stringifies to a hashtable name and the assertions below stop meaning
        # anything.
        $messages = @($output | ForEach-Object {
            if ($_ -is [System.Management.Automation.InformationRecord]) { $_.MessageData.Message } else { "$_" }
        })
        return [pscustomobject]@{
            ExitCode = $LASTEXITCODE
            Output   = $messages
            Failures = @($messages | Where-Object { $_ -match '^\[FAIL\]' } | ForEach-Object { $_ -replace '^\[FAIL\] ', '' })
        }
    }

    # A pair that differs only in its ordered action checklist. The scaffolding
    # around it is identical, so a failure can only be about the checklist and
    # never about the section skeleton the other checks compare.
    function Write-ChecklistPair {
        param([string]$Dir, [string]$CanonicalItems, [string]$MirrorItems)

        $scaffold = @'
## Bootstrap

Sıra kuraldır, öneri değil.

## Sonrası

- Kural.
'@

        $canonicalBody = "# Kılavuz`n" + $scaffold + "`n" + $CanonicalItems + "`n"
        $mirrorBody = "# Kilavuz`n" + $scaffold + "`n" + $MirrorItems + "`n"
        $sha = Get-FixtureSha -Body $canonicalBody

        return [pscustomobject]@{
            Canonical = Write-Fixture -Path (Join-Path $Dir 'checklist-canonical.md') -Body $canonicalBody -Sha $sha
            Mirror    = Write-Fixture -Path (Join-Path $Dir 'checklist-mirror.md') -Body $mirrorBody -Sha $sha
        }
    }

    # Two documents with identical structure. The mirror is a different language
    # on purpose: the verifier must not compare wording, only shape.
    $script:CanonicalBody = @'
# Kılavuz

Giriş metni.

## Birinci bölüm

- Kural bir.
- Kural iki.
- Kural üç.

## İkinci bölüm

| Sütun | Değer |
|-------|-------|
| a     | b     |

## Üçüncü bölüm

```powershell
Get-Item .
```
'@

    $script:MirrorBody = @'
# Kilavuz

Giris metni.

## Birinci bolum

- Kural bir.
- Kural iki.
- Kural uc.

## Ikinci bolum

| Sutun | Deger |
|-------|-------|
| a     | b     |

## Ucuncu bolum

```powershell
Get-Item .
```
'@
}

Describe "Mirror sync verification" -Tag "Unit" {

    BeforeEach {
        $script:Sha = Get-FixtureSha -Body $script:CanonicalBody
        $script:CanonicalPath = Write-Fixture -Path (Join-Path $TestDrive "canonical.md") -Body $script:CanonicalBody -Sha $script:Sha
        $script:MirrorPath = Write-Fixture -Path (Join-Path $TestDrive "mirror.md") -Body $script:MirrorBody -Sha $script:Sha
    }

    Context "A mirror that matches the canonical file" {

        It "passes every check" {
            $result = Invoke-SyncCheck -Canonical $script:CanonicalPath -Mirror $script:MirrorPath
            $result.ExitCode | Should -Be 0
            $result.Failures | Should -BeNullOrEmpty
        }

        It "reports a check total that matches the work it actually did" {
            $result = Invoke-SyncCheck -Canonical $script:CanonicalPath -Mirror $script:MirrorPath
            $passed = @($result.Output | Where-Object { $_ -match 'Checks passed:\s+(\d+) of (\d+)' })
            $passed | Should -Not -BeNullOrEmpty -Because "the summary is the only place the totals are published"
            $passed[0] -match 'Checks passed:\s+(\d+) of (\d+)' | Out-Null
            [int]$Matches[1] | Should -Be ([int]$Matches[2]) -Because "a clean run has nothing to report as a failure"
            [int]$Matches[2] | Should -BeGreaterThan 4 -Because "the marker checks alone are 2; the rest are the structural ones"
        }

        It "accepts a mirror whose line endings differ from the canonical" {
            $crlfMirror = Write-Fixture -Path (Join-Path $TestDrive "mirror-crlf.md") -Body $script:MirrorBody -Sha (Get-FixtureSha -Body $script:CanonicalBody) -Crlf
            $result = Invoke-SyncCheck -Canonical $script:CanonicalPath -Mirror $crlfMirror
            $result.ExitCode | Should -Be 0 -Because "the SHA is specified over the LF form so a Windows checkout and a committed blob agree"
        }
    }

    Context "Structural drift the mirror check must catch" {

        It "fails when the mirror is missing a section" {
            $broken = $script:MirrorBody -replace '(?s)## Ucuncu bolum.*', ''
            Write-Fixture -Path $script:MirrorPath -Body $broken -Sha (Get-FixtureSha -Body $script:CanonicalBody) | Out-Null
            $result = Invoke-SyncCheck -Canonical $script:CanonicalPath -Mirror $script:MirrorPath
            $result.ExitCode | Should -Be 1
            $result.Failures -join ' ' | Should -Match 'section count differs'
        }

        It "fails when a heading was re-levelled on one side" {
            $broken = $script:MirrorBody -replace '(?m)^## Ikinci bolum', '### Ikinci bolum'
            Write-Fixture -Path $script:MirrorPath -Body $broken -Sha (Get-FixtureSha -Body $script:CanonicalBody) | Out-Null
            $result = Invoke-SyncCheck -Canonical $script:CanonicalPath -Mirror $script:MirrorPath
            $result.ExitCode | Should -Be 1
            $result.Failures -join ' ' | Should -Match 'depth sequence differs'
        }

        It "fails when a single rule was dropped from a section" {
            $broken = $script:MirrorBody -replace '(?m)^- Kural iki\.\r?\n', ''
            Write-Fixture -Path $script:MirrorPath -Body $broken -Sha (Get-FixtureSha -Body $script:CanonicalBody) | Out-Null
            $result = Invoke-SyncCheck -Canonical $script:CanonicalPath -Mirror $script:MirrorPath
            $result.ExitCode | Should -Be 1
            $result.Failures -join ' ' | Should -Match 'Rule count differs under 1 section'
        }

        It "fails when a code block was lost" {
            $broken = $script:MirrorBody -replace '(?s)```powershell.*?```', ''
            Write-Fixture -Path $script:MirrorPath -Body $broken -Sha (Get-FixtureSha -Body $script:CanonicalBody) | Out-Null
            $result = Invoke-SyncCheck -Canonical $script:CanonicalPath -Mirror $script:MirrorPath
            $result.ExitCode | Should -Be 1
            $result.Failures -join ' ' | Should -Match 'Code fence count differs'
        }

        It "fails when a table was lost" {
            $broken = $script:MirrorBody -replace '(?s)\| Sutun \| Deger \|.*?\r?\n\r?\n', ''
            Write-Fixture -Path $script:MirrorPath -Body $broken -Sha (Get-FixtureSha -Body $script:CanonicalBody) | Out-Null
            $result = Invoke-SyncCheck -Canonical $script:CanonicalPath -Mirror $script:MirrorPath
            $result.ExitCode | Should -Be 1
            $result.Failures -join ' ' | Should -Match 'Table block count differs'
        }

        It "tolerates granularity a translation is allowed to add" {
            # A rule split into two table rows, and a rule expanded into nested
            # sub-items. Neither is drift, so neither may fail the check.
            $elaborated = $script:MirrorBody -replace '(?m)^\| a     \| b     \|$', "| a     | b     |`n| c     | d     |"
            $elaborated = $elaborated -replace '(?m)^- Kural bir\.$', "- Kural bir.`n  - alt bir`n  - alt iki"
            Write-Fixture -Path $script:MirrorPath -Body $elaborated -Sha (Get-FixtureSha -Body $script:CanonicalBody) | Out-Null
            $result = Invoke-SyncCheck -Canonical $script:CanonicalPath -Mirror $script:MirrorPath
            $result.ExitCode | Should -Be 0 -Because "the mirror is allowed to read more naturally than the canonical wording"
        }
    }

    Context "Marker drift" {

        It "fails when the mirror declares a different sync-sha" {
            Write-Fixture -Path $script:MirrorPath -Body $script:MirrorBody -Sha ('0' * 40) | Out-Null
            $result = Invoke-SyncCheck -Canonical $script:CanonicalPath -Mirror $script:MirrorPath
            $result.ExitCode | Should -Be 1
            $result.Failures -join ' ' | Should -Match 'Mirror drift'
        }

        It "fails when the canonical marker is stale against its own content" {
            Write-Fixture -Path $script:CanonicalPath -Body $script:CanonicalBody -Sha ('a' * 40) | Out-Null
            $result = Invoke-SyncCheck -Canonical $script:CanonicalPath -Mirror $script:MirrorPath
            $result.ExitCode | Should -Be 1
            $result.Failures -join ' ' | Should -Match 'Canonical sync-sha is stale'
        }
    }

    Context "Ordered action checklist" {

        # A checklist is a sequence of steps, so the tolerance granted to prose -
        # a rule expanded into nested sub-items - does not apply to it. Losing a
        # step is a lost instruction, and these fixtures pin that the check
        # notices rather than passing on shape alone.
        It "passes when the mirror keeps every action in the same order" {
            $pair = Write-ChecklistPair -Dir $TestDrive -CanonicalItems @'
  - [ ] `.gitignore` written first?
  - [ ] `README.md` added?
'@ -MirrorItems @'
  - [ ] `.gitignore` ilk yazılan mı?
  - [ ] `README.md` eklendi mi?
'@
            $result = Invoke-SyncCheck -Canonical $pair.Canonical -Mirror $pair.Mirror
            $result.ExitCode | Should -Be 0 -Because "only the wording differs, and the tokens are the same in both languages"
        }

        It "fails when the mirror lost an action" {
            $pair = Write-ChecklistPair -Dir $TestDrive -CanonicalItems @'
  - [ ] `.gitignore` written first?
  - [ ] `README.md` added?
'@ -MirrorItems @'
  - [ ] `.gitignore` ilk yazılan mı?
'@
            $result = Invoke-SyncCheck -Canonical $pair.Canonical -Mirror $pair.Mirror
            $result.ExitCode | Should -Be 1
            $result.Failures -join ' ' | Should -Match 'Action checklist differs'
        }

        It "fails when the mirror reordered the actions" {
            $pair = Write-ChecklistPair -Dir $TestDrive -CanonicalItems @'
  - [ ] `.gitignore` written first?
  - [ ] `README.md` added?
'@ -MirrorItems @'
  - [ ] `README.md` eklendi mi?
  - [ ] `.gitignore` ilk yazılan mı?
'@
            $result = Invoke-SyncCheck -Canonical $pair.Canonical -Mirror $pair.Mirror
            $result.ExitCode | Should -Be 1
            $result.Failures -join ' ' | Should -Match 'Action checklist differs'
        }

        It "fails when a side drops the token that names the action" {
            # The token is the language-neutral anchor of a step, so both files
            # are expected to name their target the same way. Writing a
            # checklist item without its token is a contract violation, not a
            # translation choice, and the check says so instead of passing
            # because the item count still agrees.
            $pair = Write-ChecklistPair -Dir $TestDrive -CanonicalItems @'
  - [ ] `.gitignore` written first?
  - [ ] `README.md` added?
'@ -MirrorItems @'
  - [ ] Önce `.gitignore` yazıldı mı?
  - [ ] Belgeler eklendi mi?
'@
            $result = Invoke-SyncCheck -Canonical $pair.Canonical -Mirror $pair.Mirror
            $result.ExitCode | Should -Be 1 -Because "an action that lost its anchor is no longer the same action on both sides"
        }

        It "tolerates prose granularity that leaves the anchors intact" {
            # Same actions, same order, same tokens, different words - and a rule
            # elsewhere in the document expanded into nested sub-items, which is
            # the granularity a translation is allowed to add.
            $pair = Write-ChecklistPair -Dir $TestDrive -CanonicalItems @'
  - [ ] `.gitignore` written first?
  - [ ] `README.md` added?
'@ -MirrorItems @'
  - [ ] `.gitignore` en başta mı yazıldı?
  - [ ] `README.md` eklendi mi?
'@
            $result = Invoke-SyncCheck -Canonical $pair.Canonical -Mirror $pair.Mirror
            $result.ExitCode | Should -Be 0 -Because "a mirror is allowed to read more naturally than the canonical wording"
        }
    }

    Context "Absent mirror" {

        It "fails when no mirror is supplied and none is allowed" {
            $result = Invoke-SyncCheck -Canonical $script:CanonicalPath -Mirror (Join-Path $TestDrive "does-not-exist.md")
            $result.ExitCode | Should -Be 1
            $result.Failures -join ' ' | Should -Match 'Mirror file not found'
        }

        It "passes without claiming anything when the mirror is optional" {
            $result = Invoke-SyncCheck -Canonical $script:CanonicalPath -Mirror (Join-Path $TestDrive "does-not-exist.md") -AllowMissing
            $result.ExitCode | Should -Be 0
            $result.Output -join "`n" | Should -Match 'Mirror check was skipped'
        }
    }
}
