BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $script:RepoRoot = Split-Path -Parent $PSScriptRoot
    $script:ScannerPath = Join-Path $script:RepoRoot "Scripts/Mojibake-Scan.py"
    # Damage samples are assembled from the code point rather than written out,
    # so that the samples are still the real thing when they reach the scanner
    # while this file stays clean when the scanner reads it.
    $script:Q = [string][char]0x3F

    # Resolve by running the interpreter, not by finding it: on Windows a Store
    # stub named python3.exe resolves through Get-Command and then exits 9009
    # with "Python was not found", which would fail every check in this file.
    # The shared helper also survives stubs that fail to start at all and falls
    # back to the `py` launcher before giving up.
    $script:PythonCmd = Get-OmegaPythonCommand
    if (-not $script:PythonCmd) {
        throw "a working python interpreter is required to exercise Scripts/Mojibake-Scan.py"
    }

    # The probe is ASCII-only on purpose: it is the file the scanner is loaded
    # from, and it must not be able to introduce a finding of its own.
    $script:ProbePath = Join-Path ([System.IO.Path]::GetTempPath()) `
        ("scancheck-" + [guid]::NewGuid().ToString("N") + ".py")
    @'
import importlib.util, json, subprocess, sys

scanner, request_path = sys.argv[1], sys.argv[2]
spec = importlib.util.spec_from_file_location("moji", scanner)
moji = importlib.util.module_from_spec(spec)
spec.loader.exec_module(moji)

with open(request_path, encoding="utf-8") as fh:
    request = json.load(fh)

out = []
for item in request:
    if item["kind"] == "blob":
        raw = subprocess.run(["git", "cat-file", "blob", item["spec"]],
                             capture_output=True, check=True).stdout
        text = moji.decode_utf8(raw)
        if text is None:
            out.append({"total": None, "categories": [], "lines": [],
                        "first": ""})
            continue
    else:
        text = item["value"]
    hits = moji.scan_questions(text)
    out.append({"total": len(hits),
                "categories": sorted({h[0] for h in hits}),
                "lines": sorted({h[2] for h in hits}),
                "first": hits[0][4] if hits else ""})
print(json.dumps(out, ensure_ascii=False))
'@ | Set-Content -LiteralPath $script:ProbePath -Encoding UTF8

    # The request travels through a UTF-8 file rather than the pipeline: a
    # PowerShell 5.1 native-command pipe encodes stdout in the console code
    # page, which mangles exactly the non-ASCII samples these checks feed in.
    function Invoke-ScanProbe {
        param([Parameter(Mandatory)][object[]]$Request)

        $reqPath = Join-Path ([System.IO.Path]::GetTempPath()) `
            ("scanreq-" + [guid]::NewGuid().ToString("N") + ".json")
        $json = "[" + (($Request | ForEach-Object {
            $_ | ConvertTo-Json -Depth 5 -Compress
        }) -join ",") + "]"
        [System.IO.File]::WriteAllText(
            $reqPath, $json, (New-Object System.Text.UTF8Encoding($false)))
        try {
            # -B: loading the scanner through importlib writes a __pycache__
            # beside it, and a test run must not leave a build artifact in the
            # working tree for the next run to trip over.
            $exe = $script:PythonCmd[0]
            $pre = @($script:PythonCmd | Select-Object -Skip 1)
            $raw = & $exe @pre -B $script:ProbePath $script:ScannerPath $reqPath 2>&1 | Out-String
            if ($LASTEXITCODE -ne 0) { throw "scan probe failed: $raw" }
            return ($raw | ConvertFrom-Json)
        } finally {
            Remove-Item -LiteralPath $reqPath -Force -ErrorAction SilentlyContinue
        }
    }
}

AfterAll {
    if ($script:ProbePath -and (Test-Path -LiteralPath $script:ProbePath)) {
        Remove-Item -LiteralPath $script:ProbePath -Force -ErrorAction SilentlyContinue
    }
}

Describe "Mojibake scanner - lossy '?' damage" -Tag "Unit" {

    Context "Damage the scanner used to walk past" {

        It "flags the UTF-16-pass corruption the changelog actually suffered" {
            $r = Invoke-ScanProbe -Request @(@{ kind = "blob"; spec = "3e46658:CHANGELOG.md" })
            $r.total | Should -BeGreaterThan 0 -Because "every damaged character in this revision became one or more literal '?' and the scanner reported the tree as CLEAN"
            $r.categories | Should -Contain "question-run"
        }

        It "flags the UTF-8-pass corruption the code of conduct actually suffered" {
            $r = Invoke-ScanProbe -Request @(@{ kind = "blob"; spec = "3beb414:CODE_OF_CONDUCT.md" })
            $r.total | Should -BeGreaterThan 0 -Because "this file was committed damaged and was only ever found by reading it by hand"
            $r.categories | Should -Contain "question-run"
        }

        It "flags a single '?' welded between two word characters" {
            # Assembled from a code point, not written literally: the damage
            # samples below would otherwise be findings in this file, and the
            # repository-wide scan reads this file too.
            $r = Invoke-ScanProbe -Request @(@{ kind = "text"; value = "T$script:Q" + "rk$script:Q" + "e" })
            $r.total | Should -Be 2 -Because "each lost diacritic leaves one welded question mark behind"
            $r.categories | Should -Be @("question-glue")
        }

        It "locates the run on the line that carries it" {
            $text = "first line clean`nsecond $script:Q$script:Q broken`nthird line"
            $r = Invoke-ScanProbe -Request @(@{ kind = "text"; value = $text })
            $r.lines | Should -Be @(2)
        }
    }

    Context "Question marks that are legitimate" {

        It "accepts ordinary punctuation" {
            $r = Invoke-ScanProbe -Request @(@{ kind = "text"; value = "Really? What do you think? Why not!" })
            $r.total | Should -Be 0
        }

        It "accepts a run inside an inline code span" {
            $span = [char]0x60 + ($script:Q * 3) + [char]0x60
            $r = Invoke-ScanProbe -Request @(@{ kind = "text"; value = "Document the key $span verbatim" })
            $r.total | Should -Be 0 -Because "the changelog quotes a three-character placeholder key on purpose, so masking the code span is what keeps the scan honest"
        }

        It "accepts runs inside a fenced block" {
            $fence = ([string][char]0x60) * 3
            $sample = $fence + "yaml" + "`n" + "sentinel: " + ($script:Q * 4) + " value" + "`n" + $fence + "`n"
            $r = Invoke-ScanProbe -Request @(@{ kind = "text"; value = $sample })
            $r.total | Should -Be 0
        }

        It "accepts a schemeless policy-template URL with a query string" {
            $r = Invoke-ScanProbe -Request @(@{ kind = "text"; value = "search?q={searchTerms}&{google:RLZ}" })
            $r.total | Should -Be 0 -Because "Brave.adml and the policy templates carry '{google:baseURL}search?q=...' URLs that a scheme-only mask reads as glued '?'"
        }

        It "reports nothing across the undamaged donor revision of the changelog" {
            $r = Invoke-ScanProbe -Request @(@{ kind = "blob"; spec = "2d3f632:CHANGELOG.md" })
            $r.total | Should -Be 0 -Because "a signature that fires on clean bilingual prose is worse than no signature at all"
        }
    }

    Context "The repaired files" {

        It "leaves no question-mark damage in the code of conduct" {
            $r = Invoke-ScanProbe -Request @(@{ kind = "text"; value = [System.IO.File]::ReadAllText((Join-Path $script:RepoRoot "CODE_OF_CONDUCT.md")) })
            $r.total | Should -Be 0
        }

        It "leaves no question-mark damage in the changelog" {
            $r = Invoke-ScanProbe -Request @(@{ kind = "text"; value = [System.IO.File]::ReadAllText((Join-Path $script:RepoRoot "CHANGELOG.md")) })
            $r.total | Should -Be 0
        }

        It "keeps the Turkish letters of the code of conduct" {
            $text = [System.IO.File]::ReadAllText((Join-Path $script:RepoRoot "CODE_OF_CONDUCT.md"))
            # Checked by code point rather than by literal: on this Turkish host
            # -match folds through the culture, and a literal in this file would
            # depend on the BOM surviving every future save.
            $letters = @{
                0x0131 = "dotless i"
                0x00E7 = "c-cedilla"
                0x00FC = "u-umlaut"
                0x015F = "s-cedilla"
                0x011F = "g-breve"
            }
            foreach ($cp in $letters.Keys) {
                $text.Contains([char]$cp) | Should -BeTrue -Because "the commit that damaged the file replaced every $($letters[$cp]) with a literal '?'"
            }
        }

        It "keeps the language switcher resolving to the anchor it names" {
            $text = [System.IO.File]::ReadAllText((Join-Path $script:RepoRoot "CODE_OF_CONDUCT.md"))
            $link = [regex]::Match($text, '\[TR [^\]]+\]\(#([^)]+)\)')
            $anchor = [regex]::Match($text, '<a id="([^"]+)"></a>\s*\r?\n\r?\n## TR')
            $link.Groups[1].Value | Should -Not -BeNullOrEmpty
            $anchor.Groups[1].Value | Should -Be $link.Groups[1].Value -Because "the damaged anchor no longer matched the Turkish heading, which left the language switcher dead"
        }

        It "passes the repository-wide scan both CI hosts run" {
            $exe = $script:PythonCmd[0]
            $pre = @($script:PythonCmd | Select-Object -Skip 1)
            $out = & $exe @pre -B $script:ScannerPath $script:RepoRoot 2>&1 | Out-String
            $LASTEXITCODE | Should -Be 0 -Because "quality.yml and .gitlab-ci.yml both gate on this exit code, so a finding here fails the build on either host"
            $out | Should -Match "CLEAN"
        }
    }
}