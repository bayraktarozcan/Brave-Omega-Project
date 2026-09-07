BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    . (Join-Path $ProjectRoot 'scripts\Export-PolicyCatalog.ps1')

    $script:Definitions = Get-OmegaPolicyDefinitions -ScriptPath $ScriptEN
    $script:Cumulative   = Get-OmegaCumulativePolicySets -Definitions $script:Definitions
    $script:Order        = Get-OmegaLevelOrder
}

Describe "Policy Definitions Loading" -Tag "Unit" {
    It "extracts definitions for all 5 tiers from EN script" {
        $script:Definitions.Keys.Count | Should -BeExactly 5
    }

    It "has the expected incremental policy counts" {
        $expected = @{
            'BraveOnly' = 24
            'Essential' = 27
            'Balanced'  = 32
            'Advanced'  = 40
            'Strict'    = 28
        }
        foreach ($tier in $script:Order) {
            @($script:Definitions[$tier]).Count | Should -BeExactly $expected[$tier]
        }
    }

    It "only uses supported policy types" {
        foreach ($tier in $script:Order) {
            foreach ($policy in $script:Definitions[$tier]) {
                $policy['Type'] | Should -BeIn @('DWord', 'String', 'MultiString', 'ExpandString')
            }
        }
    }
}

Describe "Cumulative Merge" -Tag "Unit" {
    It "grows cumulative totals to 151 unique policies" {
        $expected = @{
            'BraveOnly' = 24
            'Essential' = 51
            'Balanced'  = 83
            'Advanced'  = 123
            'Strict'    = 151
        }
        foreach ($tier in $script:Order) {
            $script:Cumulative[$tier].Count | Should -BeExactly $expected[$tier]
        }
    }

    It "each tier is a superset of the previous tier" {
        for ($i = 1; $i -lt $script:Order.Count; $i++) {
            foreach ($name in $script:Cumulative[$script:Order[$i - 1]].Keys) {
                $script:Cumulative[$script:Order[$i]].ContainsKey($name) | Should -Be $true
            }
        }
    }

    It "later tiers override earlier values for shared names" {
        $defs = @{
            'BraveOnly' = @(@{Name='Shared'; Value=1; Type='DWord'})
            'Essential' = @(@{Name='Shared'; Value=0; Type='DWord'})
        }
        $cum = Get-OmegaCumulativePolicySets -Definitions $defs
        $cum['Essential']['Shared'].Value | Should -BeExactly 0
    }
}

Describe "Value Serialization" -Tag "Unit" {
    It "converts DWord to its decimal string" {
        $value = Convert-OmegaPolicyToOneLineStreamValue -Policy @{Name='X'; Value=1; Type='DWord'}
        $value | Should -BeExactly '1'
    }

    It "keeps scalar String values unchanged" {
        $value = Convert-OmegaPolicyToOneLineStreamValue -Policy @{Name='X'; Value='automatic'; Type='String'}
        $value | Should -BeExactly 'automatic'
    }

    It "serializes array String values as compressed JSON" {
        $value = Convert-OmegaPolicyToOneLineStreamValue -Policy @{Name='X'; Value=@('a', 'b'); Type='String'}
        $value | Should -BeExactly '["a","b"]'
    }

    It "escapes backslashes and double quotes for reg files" {
        ConvertTo-OmegaRegEscapedValue -Text 'a\b "c"' | Should -BeExactly 'a\\b \"c\"'
    }
}

Describe "Reg Content" -Tag "Unit" {
    BeforeAll {
        $script:StrictReg = ConvertTo-OmegaRegContent -PolicySet $script:Cumulative['Strict']
    }

    It "starts with the version header and uses CRLF line endings" {
        $script:StrictReg -match '^Windows Registry Editor Version 5\.00\r\n\r\n' | Should -Be $true
    }

    It "uses no bare LF line endings" {
        $script:StrictReg -match "(?<!\r)\n" | Should -Be $false
    }

    It "contains the Brave base registry key" {
        $script:StrictReg -match '\[HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\BraveSoftware\\Brave\]' | Should -Be $true
    }

    It "writes every DWord as an 8-digit lowercase hex dword value" {
        $dwordCount = @($script:Cumulative['Strict'].Values | Where-Object { $_['Type'] -eq 'DWord' }).Count
        $dwordMatches = [regex]::Matches($script:StrictReg, '=dword:[0-9a-f]{8}')
        $dwordMatches.Count | Should -BeExactly $dwordCount
    }

    It "writes every populated MultiString as a subkey with numbered values" {
        $multiPolicies = @($script:Cumulative['Strict'].Values | Where-Object {
            $_['Type'] -eq 'MultiString' -and @($_['Value']).Count -gt 0
        })
        foreach ($policy in $multiPolicies) {
            $name = $policy['Name']
            $subkey = '\[HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\BraveSoftware\\Brave\\' +
                      [regex]::Escape($name) + '\]'
            $script:StrictReg -match $subkey | Should -Be $true

            $start = $script:StrictReg.IndexOf("[$('HKEY_LOCAL_MACHINE\SOFTWARE\Policies\BraveSoftware\Brave\' + $name)]")
            $next = $script:StrictReg.IndexOf('[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\BraveSoftware\Brave]', $start + 1)
            $end = [regex]::Match($script:StrictReg.Substring($start + 1), '\r?\n\[HKEY_LOCAL_MACHINE')
            $section = if ($end.Success) {
                $script:StrictReg.Substring($start, $end.Index + 1)
            } else {
                $script:StrictReg.Substring($start)
            }
            ([regex]::Matches($section, '^"\d+"="', [System.Text.RegularExpressions.RegexOptions]::Multiline)).Count |
                Should -BeExactly @($policy['Value']).Count
        }
    }

    It "writes an empty MultiString as an empty subkey" {
        $name = 'ScreenCaptureAllowedByOrigins'
        $start = $script:StrictReg.IndexOf("[$('HKEY_LOCAL_MACHINE\SOFTWARE\Policies\BraveSoftware\Brave\' + $name)]")
        $start | Should -BeGreaterOrEqual 0
        $section = $script:StrictReg.Substring($start + 1)
        $end = [regex]::Match($section, '^\[', [System.Text.RegularExpressions.RegexOptions]::Multiline)
        $body = if ($end.Success) { $section.Substring(0, $end.Index) } else { $section }
        $body -match '"1"=' | Should -Be $false
    }

    It "keeps all generated text ASCII-safe" {
        $script:StrictReg -cmatch '[^\x00-\x7F]' | Should -Be $false
    }
}

Describe "Levels Json" -Tag "Unit" {
    BeforeAll {
        $script:Json = New-OmegaLevelsJson `
            -Definitions $script:Definitions `
            -Cumulative $script:Cumulative `
            -SourceScript $ScriptEN `
            -ScriptVersion (Get-OmegaScriptVersion -ScriptPath $ScriptEN) `
            -GeneratedAtUtc (Get-Date)
        $script:JsonText = ($script:Json | ConvertTo-Json -Depth 10)
    }

    It "exposes catalog metadata" {
        $script:Json.generatedBy        | Should -BeExactly 'scripts/Export-PolicyCatalog.ps1'
        $script:Json.sourceScript       | Should -BeExactly 'Brave Omega\BraveOmega-EN.ps1'
        [System.IO.Path]::IsPathRooted($script:Json.sourceScript) | Should -Be $false
        $script:Json.scriptVersion      | Should -Match '^v\d+\.\d+\.\d+\.\d+$'
        $script:Json.registryTargetHklm | Should -BeExactly 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\BraveSoftware\Brave'
        $script:Json.registryTargetPs   | Should -BeExactly 'HKLM:\SOFTWARE\Policies\BraveSoftware\Brave'
    }

    It "lists levels in canonical order" {
        @($script:Json.levelOrder) | Should -BeExactly @('BraveOnly', 'Essential', 'Balanced', 'Advanced', 'Strict')
    }

    It "reports matching incremental and cumulative totals" {
        $incremental = @{ 'BraveOnly'=24; 'Essential'=27; 'Balanced'=32; 'Advanced'=40; 'Strict'=28 }
        $cumulative  = @{ 'BraveOnly'=24; 'Essential'=51; 'Balanced'=83; 'Advanced'=123; 'Strict'=151 }
        foreach ($tier in $script:Order) {
            $script:Json.perLevelIncremental.$tier | Should -BeExactly $incremental[$tier]
            $script:Json.cumulativeTotals.$tier    | Should -BeExactly $cumulative[$tier]
        }
    }

    It "each tier lists policies sorted by name and dedicated to the tier" {
        foreach ($tier in $script:Order) {
            $level = $script:Json.levels.$tier
            $names = @($level.policies | ForEach-Object { $_.name })
            $names.Count | Should -BeExactly $level.policyCount
            $level.policyCount | Should -BeExactly $level.cumulativeCount
            $sorted = @($names | Sort-Object)
            ($names -join '|') | Should -BeExactly ($sorted -join '|')
            @($names | Sort-Object -Unique).Count | Should -BeExactly $names.Count
        }
    }

    It "serializes MultiString values as arrays, never null" {
        foreach ($tier in $script:Order) {
            foreach ($policy in $script:Json.levels.$tier.policies) {
                if ($policy.type -eq 'MultiString') {
                    $policy.value -is [System.Array] | Should -Be $true
                    $null -eq $policy.value | Should -Be $false
                }
            }
        }
    }

    It "serializes an empty MultiString as an empty array" {
        $screenCapture = $script:Json.levels.Strict.policies |
            Where-Object { $_.name -eq 'ScreenCaptureAllowedByOrigins' }
        @($screenCapture.value).Count | Should -BeExactly 0
    }

    It "contains no empty-object or null value stubs" {
        $script:JsonText -match '"value":\s*\{\}' | Should -Be $false
        $script:JsonText -match '"value":\s*null' | Should -Be $false
    }
}

Describe "Full Export" -Tag "Integration" {
    BeforeAll {
        $script:OutDir = Join-Path ([System.IO.Path]::GetTempPath()) ('OmegaCatalog_' + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $script:OutDir -Force | Out-Null
        $script:Summary = Export-OmegaPolicyCatalog -ScriptPath $ScriptEN -OutputDir $script:OutDir
    }

    AfterAll {
        Remove-Item -Path $script:OutDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    It "writes levels.json and one reg file per tier" {
        $script:Summary.Files.Count | Should -BeExactly 6
        Join-Path $script:OutDir 'levels.json' | Should -Exist
        foreach ($tier in $script:Order) {
            Join-Path $script:OutDir "$tier.reg" | Should -Exist
        }
    }

    It "writes UTF-8 without BOM and keeps the repo untouched" {
        foreach ($filePath in $script:Summary.Files) {
            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            $emptyBom = ($bytes.Length -ge 3) -and
                        ($bytes[0] -eq 0xEF) -and ($bytes[1] -eq 0xBB) -and ($bytes[2] -eq 0xBF)
            $emptyBom | Should -Be $false
            ($bytes | Where-Object { $_ -gt 0x7F }).Count | Should -BeExactly 0
        }
    }

    It "produces a parseable, consistent levels.json" {
        $catalog = Get-Content -Path (Join-Path $script:OutDir 'levels.json') -Raw | ConvertFrom-Json
        $catalog.generatedBy  | Should -BeExactly 'scripts/Export-PolicyCatalog.ps1'
        $catalog.scriptVersion | Should -Match '^v\d+\.\d+\.\d+\.\d+$'
        $catalog.cumulativeTotals.Strict | Should -BeExactly 151
        @($catalog.levels.Strict.policies).Count | Should -BeExactly 151
    }

    It "fails loudly when expected counts are out of date" {
        { Export-OmegaPolicyCatalog -ScriptPath $ScriptEN -OutputDir $script:OutDir `
            -ExpectedCounts @{ 'Strict' = 999 } } | Should -Throw
    }
}

Describe "Checked-In Artifact Cross-Check" -Tag "Integration" {

    BeforeAll {

        function ConvertFrom-OmegaRegFile {
        [CmdletBinding()]
        [OutputType([hashtable])]
        param(
            [Parameter(Mandatory)]
            [string]$Path
        )

        $baseRegKey = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\BraveSoftware\Brave'
        $content = Get-Content -LiteralPath $Path -Raw
        $map = @{}
        $section = $null

        foreach ($line in ($content -split "\r?\n")) {
            if ($line -match '^\[(?<key>.*)\]$') {
                $key = $matches['key']
                if ($key -ceq $baseRegKey) {
                    $section = ''
                }
                elseif ($key -clike ($baseRegKey + '\*')) {
                    $section = $key.Substring($baseRegKey.Length + 1)
                    if (-not $map.ContainsKey($section)) {
                        $map[$section] = [pscustomobject]@{
                            Kind  = 'MultiString'
                            Hex   = $null
                            Text  = $null
                            Items = @()
                        }
                    }
                }
                else {
                    $section = $null
                }
                continue
            }

            if ($null -eq $section) { continue }

            if ($line -match '^\s*"(?<name>[^"]+)"\s*=\s*dword:(?<hex>[0-9a-fA-F]{8})\s*$') {
                $map[$matches['name']] = [pscustomobject]@{
                    Kind  = 'DWord'
                    Hex   = $matches['hex'].ToLowerInvariant()
                    Text  = $null
                    Items = @()
                }
            }
            elseif ($line -match '^\s*"(?<name>[^"]+)"\s*=\s*hex\(2\):(?<hex>[0-9a-fA-F,]+)\s*$') {
                $hexBytes = $matches['hex'] -split ',' | ForEach-Object { [Convert]::ToByte($_, 16) }
                $textValue = ''
                if ($hexBytes.Count -ge 2 -and $hexBytes[$hexBytes.Count - 1] -eq 0 -and $hexBytes[$hexBytes.Count - 2] -eq 0) {
                    $textValue = [System.Text.Encoding]::Unicode.GetString($hexBytes, 0, $hexBytes.Count - 2)
                }
                $map[$matches['name']] = [pscustomobject]@{
                    Kind  = 'ExpandString'
                    Hex   = $matches['hex'].ToLowerInvariant()
                    Text  = $textValue
                    Items = @()
                }
            }
            elseif ($section -ceq '' -and $line -match '^\s*"(?<name>[^"]+)"\s*=\s*"(?<val>.*)"\s*$') {
                $map[$matches['name']] = [pscustomobject]@{
                    Kind  = 'String'
                    Hex   = $null
                    Text  = $matches['val']
                    Items = @()
                }
            }
            elseif ($section -and $line -match '^\s*"(?<name>\d+)"\s*=\s*"(?<val>.*)"\s*$') {
                $map[$section].Items += $matches['val']
            }
        }

        return $map
        }

        $script:EnterpriseDir    = Join-Path $ProjectRoot 'enterprise'
        $script:EnterpriseJson   = Join-Path $script:EnterpriseDir 'levels.json'
        $script:CheckedInJson    = Get-Content -LiteralPath $script:EnterpriseJson -Raw | ConvertFrom-Json
        $script:CheckedInReg     = @{}
        $script:RegDriftDir      = Join-Path ([System.IO.Path]::GetTempPath()) ('OmegaRegDrift_' + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $script:RegDriftDir -Force | Out-Null
        $script:DriftReg         = @{}

        foreach ($tier in $script:Order) {
            $script:CheckedInReg[$tier] = ConvertFrom-OmegaRegFile (Join-Path $script:EnterpriseDir "$tier.reg")
        }

        Export-OmegaPolicyCatalog -ScriptPath $ScriptEN -OutputDir $script:RegDriftDir | Out-Null

        foreach ($tier in $script:Order) {
            $script:DriftReg[$tier] = ConvertFrom-OmegaRegFile (Join-Path $script:RegDriftDir "$tier.reg")
        }
    }

    AfterAll {
        Remove-Item -Path $script:RegDriftDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    It "checked-in reg name sets match the catalog cumulative names" {
        foreach ($tier in $script:Order) {
            $expected = @($script:CheckedInJson.levels.$tier.policies | ForEach-Object { $_.name } | Sort-Object)
            $actual   = @($script:CheckedInReg[$tier].Keys | Sort-Object)
            $actual | Should -BeExactly $expected
        }
    }

    It "checked-in reg values match the catalog values" {
        foreach ($tier in $script:Order) {
            foreach ($policy in $script:CheckedInJson.levels.$tier.policies) {
                $name  = [string]$policy.name
                $entry = $script:CheckedInReg[$tier][$name]
                $entry | Should -Not -BeNullOrEmpty

                switch ($policy.type) {
                    'DWord' {
                        $entry.Kind | Should -BeExactly 'DWord'
                        $entry.Hex | Should -BeExactly ('{0:x8}' -f ([int64]$policy.value))
                    }
                    'String' {
                        $entry.Kind | Should -BeExactly 'String'
                        $entry.Text | Should -BeExactly (ConvertTo-OmegaRegEscapedValue $policy.value)
                    }
                    'ExpandString' {
                        $entry.Kind | Should -BeExactly 'ExpandString'
                        $entry.Text | Should -BeExactly ([string]$policy.value)
                    }
                    'MultiString' {
                        $entry.Kind | Should -BeExactly 'MultiString'
                        $rawItems = @([object[]]$policy.value)
                        @($entry.Items).Count | Should -BeExactly $rawItems.Count
                        for ($i = 0; $i -lt $rawItems.Count; $i++) {
                            $entry.Items[$i] | Should -BeExactly (ConvertTo-OmegaRegEscapedValue $rawItems[$i])
                        }
                    }
                }
            }
        }
    }

    It "regenerated reg files stay in sync with the checked-in reg files" {
        foreach ($tier in $script:Order) {
            $expected = $script:CheckedInReg[$tier]
            $actual   = $script:DriftReg[$tier]

            @($expected.Keys | Sort-Object) | Should -BeExactly @($actual.Keys | Sort-Object)

            foreach ($name in $expected.Keys) {
                foreach ($field in 'Kind', 'Hex', 'Text') {
                    $actual[$name].$field | Should -BeExactly $expected[$name].$field
                }
                @($actual[$name].Items) | Should -BeExactly @($expected[$name].Items)
            }
        }
    }
}