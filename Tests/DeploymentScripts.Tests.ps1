BeforeAll {
    . $PSScriptRoot\TestHelper.ps1

    $script:ScriptDeploy  = Join-Path $ProjectRoot 'scripts\deploy-brave-omega.ps1'
    $script:ScriptDetect  = Join-Path $ProjectRoot 'scripts\detect-brave-omega.ps1'
    $script:LevelsJson    = Join-Path $ProjectRoot 'enterprise\levels.json'
    $script:Order         = @('BraveOnly', 'Essential', 'Balanced', 'Advanced', 'Strict')

    $script:Catalog = Get-Content -LiteralPath $script:LevelsJson -Raw | ConvertFrom-Json

    $script:DeployFunctions = New-FunctionScriptBlock -ScriptPath $script:ScriptDeploy
    . $script:DeployFunctions

    $script:DetectFunctions = New-FunctionScriptBlock -ScriptPath $script:ScriptDetect
    . $script:DetectFunctions
}

Describe "Deploy Script" -Tag "Unit" {
    It "parses without syntax errors" {
        $tokens = $null; $errors = $null
        [System.Management.Automation.Language.Parser]::ParseFile(
            $script:ScriptDeploy, [ref]$tokens, [ref]$errors) | Out-Null
        @($errors).Count | Should -BeExactly 0
    }

    It "exposes the expected helper functions" {
        $available = @(
            'Get-OmegaLevelOrder',
            'Resolve-OmegaRegPayload',
            'Resolve-OmegaLevelsJson',
            'Get-OmegaLevelNamesFromCatalog',
            'Get-OmegaPolicyRegistryView',
            'Test-OmegaLevelPresent',
            'Invoke-OmegaRegImport',
            'Test-OmegaAdministrator'
        )
        foreach ($name in $available) {
            (Get-Command $name -ErrorAction SilentlyContinue) | Should -Not -BeNullOrEmpty
        }
    }

    It "lists levels in canonical order" {
        @(Get-OmegaLevelOrder) | Should -BeExactly $script:Order
    }

    It "resolves a reg payload from the enterprise folder" {
        $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ('OmegaDeploy_' + [guid]::NewGuid().ToString('N'))
        $enterprise = Join-Path $tempDir 'enterprise'
        New-Item -ItemType Directory -Path $enterprise -Force | Out-Null
        New-Item -ItemType File -Path (Join-Path $enterprise 'Balanced.reg') -Force | Out-Null
        $script:expectedRegPath = Join-Path $enterprise 'Balanced.reg'
        try {
            $result = Resolve-OmegaRegPayload -PayloadDir $tempDir -Level 'Balanced'
            $result | Should -BeExactly (Resolve-Path -LiteralPath $script:expectedRegPath).Path
        } finally {
            Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It "falls back to a top-level reg payload" {
        $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ('OmegaDeploy_' + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        New-Item -ItemType File -Path (Join-Path $tempDir 'Strict.reg') -Force | Out-Null
        try {
            $result = Resolve-OmegaRegPayload -PayloadDir $tempDir -Level 'Strict'
            $result | Should -BeExactly (Resolve-Path -LiteralPath (Join-Path $tempDir 'Strict.reg')).Path
        } finally {
            Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It "throws when the reg payload is missing" {
        $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ('OmegaDeploy_' + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        try {
            { Resolve-OmegaRegPayload -PayloadDir $tempDir -Level 'Balanced' } | Should -Throw
        } finally {
            Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It "throws when the level is unknown" {
        $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ('OmegaDeploy_' + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        try {
            { Resolve-OmegaRegPayload -PayloadDir $tempDir -Level 'Nope' } | Should -Throw
        } finally {
            Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It "reports false when import file does not exist" {
        $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ('OmegaDeploy_' + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        try {
            Invoke-OmegaRegImport -RegFilePath (Join-Path $tempDir 'Missing.reg') | Should -Be $false
        } finally {
            Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It "matches catalog cumulative policy names for every level" {
        foreach ($tier in $script:Order) {
            $fromCatalog = Get-OmegaLevelNamesFromCatalog -JsonPath $script:LevelsJson -Level $tier
            $expected = @($script:Catalog.levels.$tier.policies | ForEach-Object { $_.name } | Sort-Object)
            @($fromCatalog) | Should -BeExactly $expected
        }
    }
}

Describe "Detect Script" -Tag "Unit" {
    It "parses without syntax errors" {
        $tokens = $null; $errors = $null
        [System.Management.Automation.Language.Parser]::ParseFile(
            $script:ScriptDetect, [ref]$tokens, [ref]$errors) | Out-Null
        @($errors).Count | Should -BeExactly 0
    }

    It "exposes the expected helper functions" {
        $available = @(
            'Get-OmegaLevelOrder',
            'Get-OmegaTierPolicyNames',
            'Get-OmegaLevelNames',
            'Get-OmegaPolicyRegistryView',
            'Test-OmegaLevelDeployed'
        )
        foreach ($name in $available) {
            (Get-Command $name -ErrorAction SilentlyContinue) | Should -Not -BeNullOrEmpty
        }
    }

    It "embedded tier counts match the catalog incremental counts" {
        $tiers = Get-OmegaTierPolicyNames
        foreach ($tier in $script:Order) {
            @($tiers[$tier]).Count | Should -BeExactly $script:Catalog.perLevelIncremental.$tier
        }
    }

    It "embedded tier data totals 151 unique policies" {
        $tiers = Get-OmegaTierPolicyNames
        $all = @()
        foreach ($tier in $script:Order) { $all += @($tiers[$tier]) }
        @($all | Sort-Object -Unique).Count | Should -BeExactly 151
    }

    It "embedded tier data is fully covered by existing catalog names" {
        $catalogNames = New-Object System.Collections.Generic.HashSet[string] ([System.StringComparer]::Ordinal)
        foreach ($tier in $script:Order) {
            foreach ($policy in $script:Catalog.levels.$tier.policies) {
                [void]$catalogNames.Add([string]$policy.name)
            }
        }
        $tiers = Get-OmegaTierPolicyNames
        foreach ($tier in $script:Order) {
            foreach ($name in @($tiers[$tier])) {
                $catalogNames.Contains($name) | Should -Be $true
            }
        }
    }

    It "embedded incremental names exactly match the catalog tier deltas" {
        $tiers = Get-OmegaTierPolicyNames
        $priorNames = @()
        foreach ($tier in $script:Order) {
            $catalogNames = @($script:Catalog.levels.$tier.policies | ForEach-Object { $_.name })
            $expectedIncrement = @($catalogNames | Where-Object { $_ -notin $priorNames } | Sort-Object)
            @($tiers[$tier] | Sort-Object) | Should -BeExactly $expectedIncrement
            $priorNames = $catalogNames
        }
    }

    It "compute cumulative names matching catalog cumulative sets" {
        foreach ($tier in $script:Order) {
            $embedded = Get-OmegaLevelNames -Level $tier
            $expected = @($script:Catalog.levels.$tier.policies | ForEach-Object { $_.name } | Sort-Object)
            @($embedded) | Should -BeExactly $expected
        }
    }

    It "deploy and detect agree on every level name set" {
        foreach ($tier in $script:Order) {
            $deploy = Get-OmegaLevelNamesFromCatalog -JsonPath $script:LevelsJson -Level $tier
            $detect = Get-OmegaLevelNames -Level $tier
            @($deploy) | Should -BeExactly @($detect)
        }
    }

    It "returns false when the base registry key is missing" {
        Mock Get-OmegaPolicyRegistryView {
            return [pscustomobject]@{ Exists = $false; ValueNames = @(); SubKeyNames = @() }
        }
        Test-OmegaLevelDeployed -Level 'Balanced' -RegistryPath $HKLM_Target | Should -Be $false
    }

    It "returns false when an expected value name is missing" {
        Mock Get-OmegaPolicyRegistryView {
            return [pscustomobject]@{
                Exists      = $true
                ValueNames  = @('BraveRewardsDisabled', 'BraveWalletDisabled')
                SubKeyNames = @()
            }
        }
        Test-OmegaLevelDeployed -Level 'BraveOnly' -RegistryPath $HKLM_Target | Should -Be $false
    }

    It "returns true when every expected name is present as a value" {
        $names = Get-OmegaLevelNames -Level 'BraveOnly'
        Mock Get-OmegaPolicyRegistryView {
            return [pscustomobject]@{
                Exists      = $true
                ValueNames  = $names
                SubKeyNames = @()
            }
        }
        Test-OmegaLevelDeployed -Level 'BraveOnly' -RegistryPath $HKLM_Target | Should -Be $true
    }

    It "accepts names stored as sub-keys (MultiString policies)" {
        $names = Get-OmegaLevelNames -Level 'Balanced'
        $subKeySample = @($names | Where-Object { $_ -like 'Extension*' })
        Mock Get-OmegaPolicyRegistryView {
            return [pscustomobject]@{
                Exists      = $true
                ValueNames  = @($names | Where-Object { $_ -notin $subKeySample })
                SubKeyNames = $subKeySample
            }
        }
        Test-OmegaLevelDeployed -Level 'Balanced' -RegistryPath $HKLM_Target | Should -Be $true
    }

    It "matches names case-insensitively" {
        $names = Get-OmegaLevelNames -Level 'BraveOnly'
        $upper = @($names | ForEach-Object { $_.ToUpperInvariant() } | Sort-Object)
        Mock Get-OmegaPolicyRegistryView {
            return [pscustomobject]@{
                Exists      = $true
                ValueNames  = $upper
                SubKeyNames = @()
            }
        }
        Test-OmegaLevelDeployed -Level 'BraveOnly' -RegistryPath $HKLM_Target | Should -Be $true
    }
}

Describe "Deployed-Level Verification" -Tag "Unit" {
    It "Test-OmegaLevelPresent is false when the key is missing" {
        Mock Get-OmegaPolicyRegistryView {
            return [pscustomobject]@{ Exists = $false; ValueNames = @(); SubKeyNames = @() }
        }
        Test-OmegaLevelPresent -RegistryPath $HKLM_Target -ExpectedNames @('BraveRewardsDisabled') | Should -Be $false
    }

    It "Test-OmegaLevelPresent is true when all expected names exist" {
        Mock Get-OmegaPolicyRegistryView {
            return [pscustomobject]@{
                Exists      = $true
                ValueNames  = @('A', 'B', 'C')
                SubKeyNames = @('D')
            }
        }
        Test-OmegaLevelPresent -RegistryPath $HKLM_Target -ExpectedNames @('c', 'D') | Should -Be $true
    }

    It "Test-OmegaLevelPresent is false when one expected name is absent" {
        Mock Get-OmegaPolicyRegistryView {
            return [pscustomobject]@{
                Exists      = $true
                ValueNames  = @('A', 'B')
                SubKeyNames = @()
            }
        }
        Test-OmegaLevelPresent -RegistryPath $HKLM_Target -ExpectedNames @('A', 'Z') | Should -Be $false
    }
}