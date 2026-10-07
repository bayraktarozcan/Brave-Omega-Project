$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ScriptMain = Join-Path $ProjectRoot "Brave-Omega\BraveOmega.ps1"

$HKCU_Target = "HKCU:\Software\BraveSoftware\Brave-Browser"
$HKLM_Target = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

$TestPolicies = @{
    "BraveOnly" = @(
        @{Name="BraveRewardsDisabled"; Value=1; Type="DWord"}
        @{Name="BraveWalletDisabled"; Value=1; Type="DWord"}
    )
    "Essential" = @(
        @{Name="MetricsReportingEnabled"; Value=0; Type="DWord"}
        @{Name="BraveVPNDisabled"; Value=1; Type="DWord"}
    )
    "Balanced" = @(
        @{Name="PasswordManagerEnabled"; Value=0; Type="DWord"}
        @{Name="DnsOverHttpsMode"; Value="automatic"; Type="String"}
    )
    "Advanced" = @(
        @{Name="DefaultSensorsSetting"; Value=2; Type="DWord"}
        @{Name="BrowserGuestModeEnabled"; Value=1; Type="DWord"}
    )
    "Strict" = @(
        @{Name="TranslateEnabled"; Value=0; Type="DWord"}
        @{Name="DefaultJavaScriptJitSetting"; Value=2; Type="DWord"}
    )
}

function Get-ScriptFunctions {
    param([string]$ScriptPath)
    $content = Get-Content -Path $ScriptPath -Raw
    $functions = @()
    $pattern = 'function\s+([\w-]+)\s*\{'
    $matches = [regex]::Matches($content, $pattern)
    foreach ($m in $matches) { $functions += $m.Groups[1].Value }
    return $functions
}

function Get-PolicyLines {
    param([string]$ScriptPath)
    $lines = @()
    foreach ($p in Get-OmegaProfilePolicies -ScriptPath $ScriptPath) {
        $lines += ('@{{Name="{0}";Type="{1}"}}' -f $p.name, $p.type)
    }
    return $lines
}

function Get-OmegaLevelOrder {
    param([string]$ScriptPath = $ScriptMain)
    $dataDir = Split-Path -Path $ScriptPath -Parent
    $config = Get-Content -Path (Join-Path $dataDir "config.json") -Raw | ConvertFrom-Json
    return @($config.levelOrder)
}

function Get-OmegaStringValue {
    param([System.Management.Automation.Language.Ast]$Node)
    if ($null -eq $Node) { return $null }
    if ($Node -is [System.Management.Automation.Language.StringConstantExpressionAst]) { return $Node.Value }
    if ($Node -is [System.Management.Automation.Language.ExpandableStringExpressionAst]) { return $Node.Value }
    $literal = $Node.Find({
            param($n)
            $n -is [System.Management.Automation.Language.StringConstantExpressionAst] -or
            $n -is [System.Management.Automation.Language.ExpandableStringExpressionAst]
        }, $true)
    if ($literal) { return $literal.Value }
    return $Node.Extent.Text
}

function ConvertFrom-OmegaHashtableAst {
    param([System.Management.Automation.Language.HashtableAst]$Table)
    $pairs = [ordered]@{}
    foreach ($pair in $Table.KeyValuePairs) {
        $key = Get-OmegaStringValue $pair.Item1
        if ($null -eq $key) { continue }
        $nested = $pair.Item2.Find({
                param($n) $n -is [System.Management.Automation.Language.HashtableAst]
            }, $true)
        if ($nested) {
            $pairs[$key] = ConvertFrom-OmegaHashtableAst $nested
        }
        else {
            $pairs[$key] = Get-OmegaStringValue $pair.Item2
        }
    }
    return $pairs
}

function Get-OmegaScriptHashtable {
    param(
        [string]$VariableName,
        [string]$ScriptPath = $ScriptMain
    )
    $content = Get-Content -Path $ScriptPath -Raw -Encoding UTF8
    $tokens = $null; $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($content, [ref]$tokens, [ref]$errors)
    $assignment = $ast.FindAll({
            param($node)
            $node -is [System.Management.Automation.Language.AssignmentStatementAst] -and
            $node.Left -is [System.Management.Automation.Language.VariableExpressionAst]
        }, $true) |
        Where-Object { $_.Left.VariablePath.UserPath -eq $VariableName } |
        Select-Object -First 1
    if (-not $assignment) { return $null }
    $table = $assignment.Right.Find({
            param($node) $node -is [System.Management.Automation.Language.HashtableAst]
        }, $true)
    if (-not $table) { return $null }
    return ConvertFrom-OmegaHashtableAst $table
}

function Get-OmegaLevelMenuMap {
    param([string]$ScriptPath = $ScriptMain)
    $content = Get-Content -Path $ScriptPath -Raw -Encoding UTF8
    $tokens = $null; $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($content, [ref]$tokens, [ref]$errors)
    $switches = $ast.FindAll({
            param($node) $node -is [System.Management.Automation.Language.SwitchStatementAst]
        }, $true)
    foreach ($switchNode in $switches) {
        if ((Get-OmegaStringValue $switchNode.Condition) -ne '$Choice') { continue }
        $menu = [ordered]@{}
        foreach ($clause in $switchNode.Clauses) {
            $choice = Get-OmegaStringValue $clause.Item1
            if ($null -eq $choice) { continue }
            $menu[$choice] = Get-OmegaStringValue $clause.Item2
        }
        return $menu
    }
    return $null
}

function ConvertTo-OmegaIgnoreRegex {
    param([string]$Pattern)

    $anchored = $false
    $body = $Pattern
    if ($body.StartsWith('/')) {
        $anchored = $true
        $body = $body.Substring(1)
    }
    if ($body.Contains('/')) { $anchored = $true }

    $sb = New-Object System.Text.StringBuilder
    [void]$sb.Append('^')
    if (-not $anchored) { [void]$sb.Append('(?:.*/)?') }

    $i = 0
    while ($i -lt $body.Length) {
        $c = $body[$i]
        if ($c -eq '\' -and ($i + 1) -lt $body.Length) {
            [void]$sb.Append([regex]::Escape([string]$body[$i + 1]))
            $i += 2
            continue
        }
        if ($c -eq '*') {
            if (($i + 1) -lt $body.Length -and $body[$i + 1] -eq '*') {
                if (($i + 2) -lt $body.Length -and $body[$i + 2] -eq '/') {
                    [void]$sb.Append('(?:.*/)?')
                    $i += 3
                }
                else {
                    [void]$sb.Append('.*')
                    $i += 2
                }
                continue
            }
            [void]$sb.Append('[^/]*')
            $i++
            continue
        }
        if ($c -eq '?') {
            [void]$sb.Append('[^/]')
            $i++
            continue
        }
        if ($c -eq '[') {
            $close = $i + 1
            if ($close -lt $body.Length -and ($body[$close] -eq '!' -or $body[$close] -eq '^')) { $close++ }
            if ($close -lt $body.Length -and $body[$close] -eq ']') { $close++ }
            while ($close -lt $body.Length -and $body[$close] -ne ']') { $close++ }
            if ($close -ge $body.Length) {
                [void]$sb.Append('[')
                $i++
                continue
            }
            $class = $body.Substring($i + 1, $close - $i - 1)
            if ($class.StartsWith('!')) { $class = '^' + $class.Substring(1) }
            [void]$sb.Append('[' + $class + ']')
            $i = $close + 1
            continue
        }
        [void]$sb.Append([regex]::Escape([string]$c))
        $i++
    }
    [void]$sb.Append('$')

    return [pscustomobject]@{
        Anchored = $anchored
        Regex    = [regex]::new($sb.ToString())
    }
}

function Get-OmegaIgnoreRule {
    param([string]$IgnoreFilePath)

    $rules = @()
    foreach ($line in (Get-Content -Path $IgnoreFilePath)) {
        $text = $line.TrimEnd()
        if ($text.Length -eq 0) { continue }
        if ($text.StartsWith('#')) { continue }

        $negate = $false
        $body = $text
        if ($body.StartsWith('!')) {
            $negate = $true
            $body = $body.Substring(1)
        }
        $dirOnly = $false
        if ($body.EndsWith('/')) {
            $dirOnly = $true
            $body = $body.Substring(0, $body.Length - 1)
        }
        if ($body.Length -eq 0) { continue }

        $compiled = ConvertTo-OmegaIgnoreRegex $body
        $rules += [pscustomobject]@{
            Source   = $text
            Pattern  = $body
            Negate   = $negate
            DirOnly  = $dirOnly
            Anchored = $compiled.Anchored
            Regex    = $compiled.Regex
        }
    }
    return $rules
}

function Get-OmegaIgnoreDecision {
    param(
        [object[]]$Rules,
        [string]$Path
    )

    $rel = ($Path -replace '\\', '/') -replace '^\./', ''
    $rel = $rel.TrimStart('/')
    if ($rel.Length -eq 0) { return [pscustomobject]@{ Ignored = $false; Rule = $null } }

    $candidates = @($rel)
    if ($rel.Contains('/')) {
        $parts = $rel -split '/'
        $acc = ''
        for ($i = 0; $i -lt ($parts.Count - 1); $i++) {
            if ($acc) { $acc = $acc + '/' + $parts[$i] } else { $acc = $parts[$i] }
            $candidates += $acc
        }
    }

    $ignored = $false
    $winner = $null
    foreach ($rule in $Rules) {
        $matched = $false
        foreach ($candidate in $candidates) {
            if ($rule.Regex.IsMatch($candidate)) { $matched = $true; break }
        }
        if ($matched) {
            $ignored = (-not $rule.Negate)
            $winner = $rule
        }
    }
    return [pscustomobject]@{ Ignored = $ignored; Rule = $winner }
}

function Test-OmegaIgnorePath {
    param(
        [object[]]$Rules,
        [string]$Path
    )
    return (Get-OmegaIgnoreDecision -Rules $Rules -Path $Path).Ignored
}

function Get-OmegaIgnoreRuleFor {
    param(
        [object[]]$Rules,
        [string]$Path
    )
    return (Get-OmegaIgnoreDecision -Rules $Rules -Path $Path).Rule
}

function Get-OmegaProfilePolicies {
    param([string]$ScriptPath = $ScriptMain)
    $dataDir = Split-Path -Path $ScriptPath -Parent
    $config = Get-Content -Path (Join-Path $dataDir "config.json") -Raw | ConvertFrom-Json
    $profilesDir = Join-Path $dataDir "Profiles"
    $all = @()
    foreach ($tier in @($config.levelOrder)) {
        $profile = Get-Content -Path (Join-Path $profilesDir "$tier.json") -Raw | ConvertFrom-Json
        foreach ($p in @($profile.policies)) {
            $all += $p
        }
    }
    return $all
}

function Get-OmegaTierPolicies {
    param(
        [string]$Level,
        [string]$ScriptPath = $ScriptMain
    )
    $dataDir = Split-Path -Path $ScriptPath -Parent
    if ($Level -notin (Get-OmegaLevelOrder -ScriptPath $ScriptPath)) { throw "Unknown level: $Level" }
    $profile = Get-Content -Path (Join-Path $dataDir "Profiles\$Level.json") -Raw | ConvertFrom-Json
    return @($profile.policies)
}

function Get-OmegaAllPolicyNames {
    param([string]$ScriptPath = $ScriptMain)
    $names = @()
    foreach ($p in Get-OmegaProfilePolicies -ScriptPath $ScriptPath) {
        if ($p.name -notin $names) { $names += $p.name }
    }
    return $names
}

function Get-MergedPolicyNames {
    param([string]$ScriptPath, [string]$Level)
    $LevelOrder = Get-OmegaLevelOrder -ScriptPath $ScriptPath
    $Merged = @{}
    foreach ($tier in $LevelOrder[0..([array]::IndexOf($LevelOrder, $Level))]) {
        foreach ($p in (Get-OmegaTierPolicies -Level $tier -ScriptPath $ScriptPath)) {
            $Merged[$p.name] = $true
        }
    }
    return $Merged
}

function New-FunctionScriptBlock {
    param([string]$ScriptPath)
    $content = Get-Content -Path $ScriptPath -Raw
    $tokens = $null; $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($content, [ref]$tokens, [ref]$errors)
    $funcNodes = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
    if (-not $funcNodes -or $funcNodes.Count -eq 0) { return [ScriptBlock]::Create("") }
    return [ScriptBlock]::Create(($funcNodes | ForEach-Object { $_.Extent.Text }) -join "`n`n")
}

function Get-OmegaUnhandledSyntaxErrors {
    param([string]$ScriptPath = $ScriptMain)
    $content = Get-Content -Path $ScriptPath -Raw
    $tokens = $null; $errors = $null
    $null = [System.Management.Automation.Language.Parser]::ParseInput($content, [ref]$tokens, [ref]$errors)
    return @($errors | Where-Object {
            $_.Id -ne "ParserMissingEndCurlyBrace" -and
            ($_.Id -ne "ParserError" -or $_.Message -notmatch "Missing closing '}'")
        })
}

function Get-VariableRegex {
    param([string]$ScriptPath, [string]$VariableName)
    $content = Get-Content -Path $ScriptPath -Raw
    $p1 = '(?m)^\s*\$' + [regex]::Escape($VariableName) + '\s*=\s*"([^"]+)"'
    $m1 = [regex]::Match($content, $p1)
    if ($m1.Success) { return $m1.Groups[1].Value }
    $p2 = '(?m)^\s*\$' + [regex]::Escape($VariableName) + '\s*=\s*(@?\([^;]+\))'
    $m2 = [regex]::Match($content, $p2)
    if ($m2.Success) { return $m2.Groups[1].Value }
    $p3 = '(?m)^\s*\$' + [regex]::Escape($VariableName) + '\s*=\s*(\d+)'
    $m3 = [regex]::Match($content, $p3)
    if ($m3.Success) { return $m3.Groups[1].Value }
    return $null
}

# One release, two spellings. The root changelog writes v2.1.6 in three parts and
# the wiki writes v2.1.6.0 in four, and the tree treats both as the same release
# - the wiki changelog carries that four-part spelling in its own compatibility
# table, so it is the wiki's spelling and not a second release.
#
# The rule lives here because two files now need it: VersionParity compares the
# changelog pair, and VersionMatrix compares every compatibility table against the
# changelog. A private copy in each would be free to disagree about which
# spelling is canonical, and that disagreement is invisible - both copies would
# keep passing while reporting a release that never went missing as one that did.
function ConvertTo-FourPartVersion {
    param([string]$Version)

    if ($Version -notmatch '^v\d+(\.\d+){2,3}$') { return $null }
    if ($Version -match '^v\d+\.\d+\.\d+\.\d+$') { return $Version }
    return "$Version.0"
}

# reg export refuses the PowerShell provider form, so the backup step converts
# the path before handing it over. That conversion is a single expression in the
# script; this reads that expression back out of the shipped file and applies it
# to a supplied path, so a test proves the line that ships rather than a copy of
# it that can drift away from it unnoticed.
function ConvertTo-OmegaFlatRegistryPath {
    param(
        [string]$ScriptPath,
        [string]$Path
    )

    $content = Get-Content -Path $ScriptPath -Raw
    $matched = [regex]::Match($content, '(?m)^\s*\$flatPath\s*=\s*(.+?)\s*$')
    if (-not $matched.Success) {
        throw "No flatPath conversion expression found in $ScriptPath"
    }
    $converter = [ScriptBlock]::Create('param($Path) ' + $matched.Groups[1].Value)
    return & $converter $Path
}
