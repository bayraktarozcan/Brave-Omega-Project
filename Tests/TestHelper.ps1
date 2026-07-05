$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ScriptEN = Join-Path $ProjectRoot "Brave Omega\BraveOmega-EN.ps1"
$ScriptTR = Join-Path $ProjectRoot "Brave Omega\BraveOmega-TR.ps1"

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
    $content = Get-ScriptContent -ScriptPath $ScriptPath
    $lines = $content -split "`r`n|`n"
    $inDefs = $false
    $depth = 0
    $result = @()
    foreach ($line in $lines) {
        if ($line -match '\$PolicyDefinitions\s*=\s*@|\$PolitikaTanimlari\s*=\s*@') {
            if ($line -match '@\{') { $inDefs = $true; $depth = 1; continue }
            $inDefs = $true; $depth = 1; continue
        }
        if ($inDefs) {
            if ($line -match '\{') { $depth++ }
            if ($line -match '\}') {
                $depth--
                if ($depth -eq 0) { $inDefs = $false; continue }
            }
            if ($line -match '@\{') {
                $result += $line.Trim()
            }
        }
    }
    return $result
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
        [string]$Version = "1.92.134",
        [string]$ChromiumMajor = "150"
    )
    return @{
        Path = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
        BraveVersion = $Version
        ChromiumMajor = $ChromiumMajor
    }
}

function New-MockRegistryEnvironment {
    $drives = Get-PSDrive -Name "HKLM", "HKCU" -ErrorAction SilentlyContinue
    if (-not $drives) {
        try { New-PSDrive -Name "HKLM" -PSProvider Registry -Root "HKEY_LOCAL_MACHINE" -Scope Script -ErrorAction Stop | Out-Null } catch {}
        try { New-PSDrive -Name "HKCU" -PSProvider Registry -Root "HKEY_CURRENT_USER" -Scope Script -ErrorAction Stop | Out-Null } catch {}
    }
    $testHklmPath = $HKLM_Target -replace "^HKLM:", ""
    $testHkcuPath = $HKCU_Target -replace "^HKCU:", ""
    if (-not (Test-Path "HKLM:\$testHklmPath")) {
        $null = New-Item -Path "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Force -ErrorAction SilentlyContinue
    }
    if (-not (Test-Path "HKCU:\$testHkcuPath")) {
        $null = New-Item -Path "HKCU:\Software\BraveSoftware\Brave-Browser" -Force -ErrorAction SilentlyContinue
    }
}
