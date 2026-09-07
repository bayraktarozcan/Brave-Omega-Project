#Requires -Version 5.1

<#
.SYNOPSIS
    Exports a machine-readable policy catalog (levels.json) and per-level
    .reg files from the authoritative $PolicyDefinitions block of
    BraveOmega-EN.ps1.

.DESCRIPTION
    Reads the $PolicyDefinitions hashtable out of BraveOmega-EN.ps1 using the
    PowerShell AST, then produces:
      - enterprise\levels.json                 (machine-readable catalog)
      - enterprise\BraveOnly.reg / Essential / Balanced / Advanced / Strict

    The .reg files mirror exactly what the Brave Omega script writes to
    HKEY_LOCAL_MACHINE\SOFTWARE\Policies\BraveSoftware\Brave for the given
    cumulative level. No registry keys are read or written by this script.

    When run directly the script generates artifacts into the default output
    directory. When dot-sourced (e.g. from Pester) only the functions are
    exposed and nothing is generated.

.PARAMETER ScriptPath
    Path to BraveOmega-EN.ps1. Defaults to the repository copy.

.PARAMETER OutputDir
    Directory for levels.json and the .reg files. Defaults to
    <repo root>\enterprise.

.PARAMETER ExpectedCounts
    Hashtable of tier -> expected incremental policy count used as a sanity
    check against $PolicyDefinitions. Defaults to the v2.6.2.0 baseline.
    Set to @{} to skip the tier count check.

.EXAMPLE
    ./scripts/Export-PolicyCatalog.ps1
#>
[CmdletBinding()]
param(
    [string]$ScriptPath,
    [string]$OutputDir,
    [hashtable]$ExpectedCounts
)

function Get-OmegaLevelOrder {
    return @('BraveOnly', 'Essential', 'Balanced', 'Advanced', 'Strict')
}

function Get-OmegaPolicyDefinitions {
    <#
    .SYNOPSIS
        Extracts and evaluates the $PolicyDefinitions hashtable from a
        Brave Omega script via the PowerShell AST.

    .PARAMETER ScriptPath
        Path to the .ps1 file containing $PolicyDefinitions.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ScriptPath
    )

    if (-not (Test-Path -LiteralPath $ScriptPath)) {
        throw "ScriptPath not found: $ScriptPath"
    }

    $raw = Get-Content -LiteralPath $ScriptPath -Raw -ErrorAction Stop

    $tokens = $null
    $parseErrors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($raw, [ref]$tokens, [ref]$parseErrors)
    if ($parseErrors -and $parseErrors.Count -gt 0) {
        throw "Failed to parse '$ScriptPath': $($parseErrors[0].Message)"
    }

    $assignment = $null
    foreach ($node in $ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.AssignmentStatementAst] }, $true)) {
        if ($node.Left -is [System.Management.Automation.Language.VariableExpressionAst] -and
            $node.Left.VariablePath.UserPath -eq 'PolicyDefinitions') {
            $assignment = $node
            break
        }
    }
    if (-not $assignment) {
        throw "Could not locate `$PolicyDefinitions assignment in '$ScriptPath'."
    }

    $definitions = Invoke-Expression -Command $assignment.Right.Extent.Text -ErrorAction Stop
    if (-not $definitions -or $definitions.Count -eq 0) {
        throw "`$PolicyDefinitions evaluated to an empty result in '$ScriptPath'."
    }

    $knownTiers = Get-OmegaLevelOrder
    foreach ($tier in $knownTiers) {
        if (-not $definitions.ContainsKey($tier)) {
            throw "Tier '$tier' is missing from `$PolicyDefinitions in '$ScriptPath'."
        }

        foreach ($policy in $definitions[$tier]) {
            if ($policy -isnot [hashtable]) {
                throw "Policy entry in tier '$tier' is not a hashtable."
            }
            foreach ($requiredKey in @('Name', 'Value', 'Type')) {
                if (-not $policy.ContainsKey($requiredKey)) {
                    throw "Policy in tier '$tier' is missing the '$requiredKey' key."
                }
            }
            if ($policy['Type'] -notin @('DWord', 'String', 'MultiString', 'ExpandString')) {
                throw "Unsupported policy type '$($policy['Type'])' in tier '$tier'."
            }
        }
    }

    return $definitions
}

function Get-OmegaCumulativePolicySets {
    <#
    .SYNOPSIS
        Merges the tier definitions cumulatively (later tiers override earlier
        tiers), mirroring the consolidation logic in BraveOmega-EN.ps1.

    .PARAMETER Definitions
        Hash of tier name -> array of policy hashtables.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Definitions
    )

    $order = Get-OmegaLevelOrder
    $result = @{}
    $merged = @{}

    foreach ($tier in $order) {
        foreach ($policy in $Definitions[$tier]) {
            $merged[$policy['Name']] = $policy
        }
        $result[$tier] = $merged.Clone()
    }

    return $result
}

function ConvertTo-OmegaSortedJsonValue {
    <#
    .SYNOPSIS
        Recursively reorders hashtable keys (and nested hashtable keys) into a
        deterministic order so ConvertTo-Json output is identical on every
        platform. Array element order is preserved.

    .PARAMETER Value
        The policy value to normalize.
    #>
    [CmdletBinding()]
    param($Value)

    if ($Value -is [System.Collections.IDictionary]) {
        $sorted = [ordered]@{}
        foreach ($key in ($Value.Keys | Sort-Object)) {
            $sorted[$key] = ConvertTo-OmegaSortedJsonValue -Value $Value[$key]
        }
        return $sorted
    }

    if ($Value -is [System.Collections.IEnumerable] -and $Value -isnot [string]) {
        $items = @()
        foreach ($item in $Value) {
            $items += ConvertTo-OmegaSortedJsonValue -Value $item
        }
        return ,$items
    }

    return $Value
}

function Convert-OmegaPolicyToOneLineStreamValue {
    <#
    .SYNOPSIS
        Converts a policy value to the exact string written to the registry
        (matches Write-PolicyValue in BraveOmega-EN.ps1): arrays/hashtables
        become compressed JSON, everything else stays a scalar string.

    .PARAMETER Policy
        Policy hashtable with Name / Value / Type keys.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Policy
    )

    switch ($Policy['Type']) {
        'DWord' {
            return [string][int64]$Policy['Value']
        }
        'String' {
            $value = $Policy['Value']
            if ($value -is [System.Collections.IEnumerable] -and $value -isnot [string]) {
                $sortedValue = ConvertTo-OmegaSortedJsonValue -Value $value
                return (ConvertTo-Json -InputObject $sortedValue -Compress -Depth 5)
            }
            return [string]$value
        }
        default {
            return $null
        }
    }
}

function ConvertTo-OmegaRegEscapedValue {
    <#
    .SYNOPSIS
        Escapes a string for safe embedding in a .reg file: backslash becomes
        \\ and double quote becomes \".
    #>
    [CmdletBinding()]
    param(
        [AllowEmptyString()]
        [string]$Text
    )

    if ($null -eq $Text) {
        return ''
    }
    return ($Text -replace '\\', '\\') -replace '"', '\"'
}

function ConvertTo-OmegaRegContent {
    <#
    .SYNOPSIS
        Builds the .reg file content (CRLF, ASCII-safe) for one cumulative
        policy set. Mirrors the layout brave.admx uses: scalar values under the
        base policy key, list (MultiString) policies as subkeys with numbered
        string values.

    .PARAMETER PolicySet
        Hash of policy name -> policy hashtable (one cumulative tier).

    .PARAMETER BaseRegistryPath
        Fully qualified registry key (default: Brave Software policy key).
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$PolicySet,
        [string]$BaseRegistryPath = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\BraveSoftware\Brave'
    )

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add('Windows Registry Editor Version 5.00')
    $lines.Add('')
    $lines.Add("[$BaseRegistryPath]")

    $listPolicies = @()
    foreach ($name in @($PolicySet.Keys | Sort-Object)) {
        $policy = $PolicySet[$name]
        switch ($policy['Type']) {
            'DWord' {
                $hex = '{0:x8}' -f ([int64]$policy['Value'])
                $lines.Add('"' + $name + '"=dword:' + $hex)
            }
            'String' {
                $streamValue = Convert-OmegaPolicyToOneLineStreamValue -Policy $policy
                $escaped = ConvertTo-OmegaRegEscapedValue -Text $streamValue
                $lines.Add('"' + $name + '"="' + $escaped + '"')
            }
            'ExpandString' {
                $bytes = [System.Text.Encoding]::Unicode.GetBytes(([string]$policy['Value']) + [char]0)
                $hexStream = ($bytes | ForEach-Object { '{0:x2}' -f $_ }) -join ','
                $lines.Add('"' + $name + '"=hex(2):' + $hexStream)
            }
            'MultiString' {
                $listPolicies += $name
            }
            default {
                throw "Unsupported policy type '$($policy['Type'])' for '$name'."
            }
        }
    }

    foreach ($name in @($listPolicies | Sort-Object)) {
        $lines.Add('')
        $lines.Add("[$BaseRegistryPath\$name]")
        $items = @([string[]]$PolicySet[$name]['Value'])
        for ($i = 0; $i -lt $items.Count; $i++) {
            $escaped = ConvertTo-OmegaRegEscapedValue -Text $items[$i]
            $lines.Add('"' + ($i + 1) + '"="' + $escaped + '"')
        }
    }

    return (($lines -join "`r`n") + "`r`n")
}

function Get-OmegaScriptVersion {
    <#
    .SYNOPSIS
        Reads the $ScriptVersion assignment from a Brave Omega script.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ScriptPath
    )

    $raw = Get-Content -LiteralPath $ScriptPath -Raw -ErrorAction Stop
    $match = [regex]::Match($raw, '\$ScriptVersion\s*=\s*"([^"]+)"')
    if ($match.Success) {
        return $match.Groups[1].Value
    }
    return ''
}

function New-OmegaLevelsJson {
    <#
    .SYNOPSIS
        Builds the machine-readable catalog object for levels.json.

    .PARAMETER Definitions
        Hash of tier name -> array of policy hashtables.

    .PARAMETER Cumulative
        Cumulative merged policy sets (see Get-OmegaCumulativePolicySets).

    .PARAMETER SourceScript
        Path to the source .ps1 the catalog was generated from.

    .PARAMETER ScriptVersion
        $ScriptVersion value of the source script.

    .PARAMETER GeneratedAtUtc
        Generation timestamp (converted to UTC).
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Definitions,
        [Parameter(Mandatory = $true)]
        [hashtable]$Cumulative,
        [Parameter(Mandatory = $true)]
        [string]$SourceScript,
        [Parameter(Mandatory = $true)]
        [string]$ScriptVersion,
        [Parameter(Mandatory = $true)]
        [datetime]$GeneratedAtUtc
    )

    $sourceScriptValue = $SourceScript
    if ([System.IO.Path]::IsPathRooted($SourceScript)) {
        $repoRoot = [System.IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot) + [System.IO.Path]::DirectorySeparatorChar)
        $absSource = [System.IO.Path]::GetFullPath($SourceScript)
        if ($absSource.StartsWith($repoRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            $sourceScriptValue = $absSource.Substring($repoRoot.Length)
        } else {
            $sourceScriptValue = $absSource
        }
    }

    $order = Get-OmegaLevelOrder

    $perLevelIncremental = New-Object System.Collections.Specialized.OrderedDictionary
    $cumulativeTotals = New-Object System.Collections.Specialized.OrderedDictionary
    $levels = New-Object System.Collections.Specialized.OrderedDictionary

    foreach ($tier in $order) {
        $perLevelIncremental[$tier] = @($Definitions[$tier]).Count
        $cumulativeTotals[$tier] = $Cumulative[$tier].Count

        $policies = @(
            foreach ($name in @($Cumulative[$tier].Keys | Sort-Object)) {
                $policy = $Cumulative[$tier][$name]
                if ($policy['Type'] -eq 'DWord') {
                    $value = [int64]$policy['Value']
                }
                elseif ($policy['Type'] -eq 'String') {
                    $value = Convert-OmegaPolicyToOneLineStreamValue -Policy $policy
                }
                elseif ($policy['Type'] -eq 'ExpandString') {
                    $value = [string]$policy['Value']
                }
                elseif ($policy['Type'] -eq 'MultiString') {
                    $value = @([string[]]$policy['Value'])
                }
                else {
                    throw "Unknown policy type '$($policy['Type'])' for '$name'."
                }
                [pscustomobject]@{
                    name  = $name
                    type  = $policy['Type']
                    value = $value
                }
            }
        )

        $levels[$tier] = [pscustomobject]@{
            policyCount     = $policies.Count
            cumulativeCount = $Cumulative[$tier].Count
            policies        = $policies
        }
    }

    return [pscustomobject]@{
        generatedBy         = 'scripts/Export-PolicyCatalog.ps1'
        generatedAtUtc      = $GeneratedAtUtc.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
        sourceScript        = $sourceScriptValue
        scriptVersion       = $ScriptVersion
        registryTargetHklm  = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\BraveSoftware\Brave'
        registryTargetPs    = 'HKLM:\SOFTWARE\Policies\BraveSoftware\Brave'
        levelOrder          = $order
        perLevelIncremental = $perLevelIncremental
        cumulativeTotals    = $cumulativeTotals
        levels              = $levels
    }
}

function Assert-OmegaAsciiContent {
    <#
    .SYNOPSIS
        Fails when generated content contains non-ASCII characters, keeping the
        .reg / JSON files byte-safe for REG IMPORT and downstream tooling.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Text,
        [string]$ContextName = 'generated content'
    )

    if ($Text -cmatch '[^\x00-\x7F]') {
        throw "Non-ASCII characters found in $ContextName; refusing to write the artifact."
    }
}

function Export-OmegaPolicyCatalog {
    <#
    .SYNOPSIS
        Validates the definitions, writes levels.json and the per-tier .reg
        files, and returns a summary object.

    .PARAMETER ScriptPath
        Path to BraveOmega-EN.ps1.

    .PARAMETER OutputDir
        Directory the artifacts are written into (created if missing).

    .PARAMETER ExpectedCounts
        Tier -> expected incremental count sanity check. Defaults to the
        v2.6.2.0 baseline; pass @{} to skip.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ScriptPath,
        [Parameter(Mandatory = $true)]
        [string]$OutputDir,
        [hashtable]$ExpectedCounts
    )

    if (-not $ExpectedCounts) {
        $ExpectedCounts = @{
            'BraveOnly' = 24
            'Essential' = 27
            'Balanced'  = 32
            'Advanced'  = 40
            'Strict'    = 28
        }
    }

    $definitions = Get-OmegaPolicyDefinitions -ScriptPath $ScriptPath
    $cumulative = Get-OmegaCumulativePolicySets -Definitions $definitions
    $order = Get-OmegaLevelOrder

    foreach ($tier in $order) {
        if ($ExpectedCounts.Count -gt 0) {
            $actual = @($definitions[$tier]).Count
            $expected = 0
            if ($ExpectedCounts.ContainsKey($tier)) {
                $expected = $ExpectedCounts[$tier]
            }
            if ($actual -ne $expected) {
                throw "Tier '$tier' policy count mismatch: expected $expected, found $actual. Update ExpectedCounts or fix BraveOmega-EN.ps1."
            }
        }
    }

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $files = @()

    foreach ($tier in $order) {
        $content = ConvertTo-OmegaRegContent -PolicySet $cumulative[$tier]
        Assert-OmegaAsciiContent -Text $content -ContextName "$tier.reg"
        $filePath = Join-Path $OutputDir ($tier + '.reg')
        [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBom)
        $files += $filePath
    }

    $jsonObject = New-OmegaLevelsJson `
        -Definitions $definitions `
        -Cumulative $cumulative `
        -SourceScript $ScriptPath `
        -ScriptVersion (Get-OmegaScriptVersion -ScriptPath $ScriptPath) `
        -GeneratedAtUtc (Get-Date)
    $jsonContent = ($jsonObject | ConvertTo-Json -Depth 10)
    Assert-OmegaAsciiContent -Text $jsonContent -ContextName 'levels.json'
    $jsonPath = Join-Path $OutputDir 'levels.json'
    [System.IO.File]::WriteAllText($jsonPath, $jsonContent, $utf8NoBom)
    $files += $jsonPath

    return [pscustomobject]@{
        ScriptPath         = $ScriptPath
        OutputDir          = $OutputDir
        Files              = $files
        Definitions        = $definitions
        Cumulative         = $cumulative
        LevelOrder         = $order
        ScriptVersion      = (Get-OmegaScriptVersion -ScriptPath $ScriptPath)
        Json               = $jsonObject
    }
}

#
# MAIN (runs only when the script is executed, not when dot-sourced)
#
if ($MyInvocation.InvocationName -ne '.') {
    $repoRoot = Split-Path -Parent $PSScriptRoot

    $resolvedScriptPath = if ($ScriptPath) {
        $ScriptPath
    } else {
        Join-Path $repoRoot 'Brave Omega\BraveOmega-EN.ps1'
    }

    $catalogOutputDir = if ($OutputDir) {
        $OutputDir
    } else {
        Join-Path $repoRoot 'enterprise'
    }

    if ($null -eq $ExpectedCounts) {
        $ExpectedCounts = @{}
    }

    try {
        New-Item -ItemType Directory -Path $catalogOutputDir -Force | Out-Null
        $summary = Export-OmegaPolicyCatalog -ScriptPath $resolvedScriptPath -OutputDir $catalogOutputDir -ExpectedCounts $ExpectedCounts

        Write-Host ''
        Write-Host 'Policy catalog generated:' -ForegroundColor Green
        Write-Host ('  Source    : ' + $summary.ScriptPath) -ForegroundColor DarkGray
        Write-Host ('  Version   : ' + $summary.ScriptVersion) -ForegroundColor DarkGray
        Write-Host ('  Output dir: ' + $catalogOutputDir) -ForegroundColor DarkGray
        Write-Host ''
        foreach ($tier in $summary.LevelOrder) {
            $incremental = @($summary.Definitions[$tier]).Count
            $total = $summary.Cumulative[$tier].Count
            Write-Host ('  {0,-10} incremental {1,3}  cumulative {2,3}' -f $tier, $incremental, $total) -ForegroundColor White
        }
        Write-Host ''
        foreach ($filePath in ($summary.Files | ForEach-Object { Split-Path -Leaf $_ })) {
            Write-Host ("  - {0}" -f $filePath) -ForegroundColor Cyan
        }
        Write-Host ''
    } catch {
        Write-Error $_.Exception.Message
        exit 1
    }
}