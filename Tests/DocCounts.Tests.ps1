# Invariant: the numbers AGENTS.md states about this repository are read from the
# repository itself, not typed by hand. A hand-typed count agrees with the tree
# on the day it is written and rots on the next test added or policy changed -
# and nothing fails, because no check reads the number back. This file is the
# check that reads it back: the expected Pester total and the expected ADMX
# policy total are parsed out of AGENTS.md (and its Turkish mirror) and
# compared against the tree that has to satisfy them.
#
# What this check cannot see:
#   - Whether the counted tests pass. An It block that fails still counts as
#     one, so a red suite trips the Pester gate, not this file. This file
#     keeps the document honest; the suite keeps itself honest.
#   - Conditional skips. An `It -Skip:($condition)` counts as one here whatever
#     the condition evaluates to at runtime, so on a machine where the skip
#     fires the document overstates the passing count by exactly the skipped
#     tests. The overstatement is visible in the Pester output itself, which
#     reports skipped tests by name.
BeforeAll {
    . $PSScriptRoot\TestHelper.ps1

    $script:AgentsPath = Join-Path $ProjectRoot 'AGENTS.md'
    $script:MirrorPath = Join-Path $ProjectRoot 'AGENTS-TR.md'

    function Get-AgentsCount {
        param([string]$Path, [string]$Pattern)
        $text = Get-Content -LiteralPath $Path -Raw
        $m = [regex]::Match($text, $Pattern)
        if (-not $m.Success) { throw "pattern not found in $(Split-Path -Leaf $Path): $Pattern" }
        return @{ First = [int]$m.Groups[1].Value; Second = [int]$m.Groups[2].Value }
    }

    function Get-ItStatementCount {
        $count = 0
        foreach ($file in (Get-ChildItem -Path (Join-Path $ProjectRoot 'Tests') -Filter '*.Tests.ps1')) {
            $tokens = $null; $errors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$errors)
            $its = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.CommandAst] }, $true) |
                Where-Object { $_.CommandElements.Count -gt 0 -and $_.CommandElements[0].Extent.Text -ceq 'It' }
            $count += @($its).Count
        }
        return $count
    }
}

Describe 'AGENTS.md document counts' -Tag 'Unit' {

    Context 'Pester total' {
        It 'the documented expected total matches the It blocks in the suite' {
            $declared = Get-AgentsCount -Path $script:AgentsPath -Pattern 'expected:\s*(\d+)/(\d+)\s+passing'
            $declared.First | Should -Be $declared.Second -Because 'the document promises a fully passing suite, so a split total would bless failures in advance'
            Get-ItStatementCount | Should -Be $declared.First -Because 'a test added or removed without updating the document leaves the next reader trusting a count the suite no longer produces'
        }

        It 'the Turkish mirror states the same total' {
            $declared = Get-AgentsCount -Path $script:AgentsPath -Pattern 'expected:\s*(\d+)/(\d+)\s+passing'
            $mirror = Get-AgentsCount -Path $script:MirrorPath -Pattern 'beklenen:\s*(\d+)/(\d+)\s+geçti'
            $mirror.First | Should -Be $declared.First -Because 'the mirror is read by a human auditing the canonical file, and a translated count that drifted is a second number to trust instead of one'
            $mirror.Second | Should -Be $declared.Second
        }
    }

    Context 'ADMX policy total' {
        It 'the documented ADMX total matches the policy data layer' {
            $declared = Get-AgentsCount -Path $script:AgentsPath -Pattern 'PASS - (\d+)/(\d+)'
            $declared.First | Should -Be $declared.Second -Because 'the document promises a clean cross-reference, so a split total would bless missing policies in advance'
            @(Get-OmegaAllPolicyNames -ScriptPath $ScriptMain).Count | Should -Be $declared.First -Because 'a policy added or removed without updating the document leaves the validator checking a total the data layer no longer holds'
        }
    }
}
