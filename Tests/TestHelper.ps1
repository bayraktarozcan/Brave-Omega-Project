$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ScriptMain = Join-Path $ProjectRoot "Brave Omega\BraveOmega.ps1"

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

function Get-ScriptContent {
    param([string]$ScriptPath)
    return Get-Content -Path $ScriptPath -Raw
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

function Get-OmegaProfilePolicies {
    param([string]$ScriptPath = $ScriptMain)
    $dataDir = Split-Path -Path $ScriptPath -Parent
    $config = Get-Content -Path (Join-Path $dataDir "config.json") -Raw | ConvertFrom-Json
    $profilesDir = Join-Path $dataDir "profiles"
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
    $profile = Get-Content -Path (Join-Path $dataDir "profiles\$Level.json") -Raw | ConvertFrom-Json
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

function New-FunctionScriptBlock {
    param([string]$ScriptPath)
    $content = Get-Content -Path $ScriptPath -Raw
    $tokens = $null; $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($content, [ref]$tokens, [ref]$errors)
    $funcNodes = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
    if (-not $funcNodes -or $funcNodes.Count -eq 0) { return [ScriptBlock]::Create("") }
    return [ScriptBlock]::Create(($funcNodes | ForEach-Object { $_.Extent.Text }) -join "`n`n")
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

function New-MockBraveVersion {
    param(
        [string]$Version = "1.96.59",
        [string]$ChromiumMajor = "154"
    )
    return @{
        Path = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
        BraveVersion = $Version
        ChromiumMajor = $ChromiumMajor
    }
}
