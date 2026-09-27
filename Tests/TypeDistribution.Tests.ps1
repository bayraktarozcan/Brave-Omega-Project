BeforeAll {
    . $PSScriptRoot\TestHelper.ps1

    $script:CatalogPath = Join-Path (Split-Path -Parent $ScriptMain) "docs\policy-catalog.md"
    $script:Catalog     = Get-Content -LiteralPath $script:CatalogPath -Raw -Encoding UTF8
    $script:ScriptText  = Get-Content -LiteralPath $ScriptMain -Raw -Encoding UTF8

    # Effective policy set, mirroring the runtime merge in BraveOmega.ps1:
    # tiers are cumulative and a later tier overrides an earlier one by name.
    $script:Effective = @{}
    foreach ($tier in (Get-OmegaLevelOrder -ScriptPath $ScriptMain)) {
        foreach ($policy in (Get-OmegaTierPolicies -Level $tier -ScriptPath $ScriptMain)) {
            $script:Effective[[string]$policy.name] = $policy
        }
    }

    # Truth for every documented type count.
    $script:Actual = @{}
    foreach ($policy in $script:Effective.Values) {
        $type = [string]$policy.type
        if (-not $script:Actual.ContainsKey($type)) { $script:Actual[$type] = 0 }
        $script:Actual[$type]++
    }

    # Types the registry writer can emit, in report order.
    $script:KnownTypes = @('DWord', 'String', 'MultiString', 'ExpandString')

    function Get-CatalogRowTypes {
        param([string]$Text)
        $rows = @{}
        $pattern = '(?m)^\|\s*\d+\s*\|\s*`(?<name>[^`]+)`\s*\|\s*(?<type>[A-Za-z]+)\s*\|'
        foreach ($match in [regex]::Matches($Text, $pattern)) {
            $rows[$match.Groups['name'].Value] = $match.Groups['type'].Value
        }
        return $rows
    }
}

Describe "Registry Type Distribution" -Tag "Integration" {
    It "resolves 151 unique policies from the data layer" {
        $script:Effective.Count | Should -BeExactly 151
    }

    It "uses only registry types the writer supports" {
        foreach ($type in $script:Actual.Keys) {
            $script:KnownTypes | Should -Contain $type
        }
    }

    It "exercises ExpandString in the data layer" {
        $script:Actual.ContainsKey('ExpandString') | Should -Be $true
        $script:Actual['ExpandString'] | Should -BeGreaterThan 0
    }

    It "counts every type exactly once across the merged set" {
        $sum = 0
        foreach ($count in $script:Actual.Values) { $sum += $count }
        $sum | Should -BeExactly $script:Effective.Count
    }
}

Describe "Registry Type Reporting" -Tag "Integration" {
    It "seeds a counter slot for every writable type" {
        foreach ($type in $script:KnownTypes) {
            $pattern = '\$typeCounts\s*=\s*@\{[^}]*"' + [regex]::Escape($type) + '"\s*=\s*0'
            $script:ScriptText -match $pattern | Should -Be $true
        }
    }

    It "reports one field per writable type in both languages" {
        $line = @($script:ScriptText -split "`r?`n" | Where-Object { $_ -match '^\s*SummaryTypes\s*=' })
        $line.Count | Should -BeExactly 1

        # Two languages, one field per type.
        [regex]::Matches($line[0], '\{[0-9]+\}').Count |
            Should -BeExactly ($script:KnownTypes.Count * 2)
    }

    It "labels the ExpandString field in both languages" {
        $line = @($script:ScriptText -split "`r?`n" | Where-Object { $_ -match '^\s*SummaryTypes\s*=' })
        [regex]::Matches($line[0], 'ExpandString=\{[0-9]+\}').Count | Should -BeExactly 2
    }

    It "passes every type count to the summary format" {
        $line = @($script:ScriptText -split "`r?`n" | Where-Object { $_ -match "SummaryTypes'" -and $_ -match ' -f ' })
        $line.Count | Should -BeExactly 1

        $argList = [regex]::Match($line[0], 'SummaryTypes''\)\s*-f(?<args>.+)').Groups['args'].Value
        $argList | Should -Not -BeNullOrEmpty

        foreach ($type in $script:KnownTypes) {
            $argList | Should -Match ('typeCounts\.' + [regex]::Escape($type) + '\b')
        }
    }

    It "keeps the stale three-type comment out of the source" {
        $script:ScriptText -match 'Type="DWord\|String\|MultiString"' | Should -Be $false
    }
}

Describe "Catalog Type Distribution Documentation" -Tag "Integration" {
    It "states the real distribution in the EN header" {
        $expected = '124 DWord ' + [char]0x00B7 + ' 7 String ' + [char]0x00B7 + ' 19 MultiString ' + [char]0x00B7 + ' 1 ExpandString'
        $script:Catalog -match [regex]::Escape('**Type distribution:** ' + $expected) | Should -Be $true
    }

    It "states the real distribution in the TR header" {
        $expected = '124 DWord ' + [char]0x00B7 + ' 7 String ' + [char]0x00B7 + ' 19 MultiString ' + [char]0x00B7 + ' 1 ExpandString'
        $label = '**T' + [char]0x00FC + 'r da' + [char]0x011F + [char]0x0131 + 'l' + [char]0x0131 + 'm' + [char]0x0131 + ':** '
        $script:Catalog -match [regex]::Escape($label + $expected) | Should -Be $true
    }

    It "lists every type with a matching count row" {
        foreach ($type in $script:KnownTypes) {
            $pattern = '(?m)^\|\s*{0}\s*\|\s*{1}\s*\|' -f [regex]::Escape($type), $script:Actual[$type]
            [regex]::Matches($script:Catalog, $pattern).Count |
                Should -BeGreaterOrEqual 2
        }
    }

    It "no longer folds ExpandString into the String count" {
        $script:Catalog -match '124 DWord ' + [regex]::Escape([string][char]0x00B7) + ' 8 String' | Should -Be $false
    }

    It "types every catalog policy row the way the data layer does" {
        $rows = Get-CatalogRowTypes -Text $script:Catalog
        $rows.Count | Should -BeGreaterOrEqual $script:Effective.Count

        foreach ($name in $script:Effective.Keys) {
            $rows.ContainsKey($name) | Should -Be $true -Because "catalog must document $name"
            $rows[$name] | Should -BeExactly ([string]$script:Effective[$name].type)
        }
    }
}
