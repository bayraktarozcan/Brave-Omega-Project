BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $script:RendererPath = Join-Path $ProjectRoot 'Scripts/Render-PolicyJSON.py'
    $script:PythonCmd = @('python3', 'python') | Where-Object {
        $cmd = Get-Command $_ -ErrorAction SilentlyContinue
        if (-not $cmd) { return $false }
        & $cmd.Source --version 2>$null | Out-Null
        $LASTEXITCODE -eq 0
    } | Select-Object -First 1
    if (-not $script:PythonCmd) {
        throw 'a working python interpreter is required to exercise Scripts/Render-PolicyJSON.py'
    }

    function Invoke-OmegaRenderer {
        param([string[]]$Arguments)
        $out = & $script:PythonCmd $script:RendererPath @Arguments 2>&1
        return @{ Output = ($out -join "`n"); ExitCode = $LASTEXITCODE }
    }
}

Describe 'Linux managed-JSON renderer' -Tag 'Unit' {

    It 'exits non-zero on an unknown browser' {
        $r = Invoke-OmegaRenderer @('--browser', 'opera', '--tier', 'Strict')
        $r.ExitCode | Should -Not -Be 0 -Because 'an unknown browser has no profile and no policy directory'
    }

    It 'renders 151 keys for brave Strict on linux' {
        $r = Invoke-OmegaRenderer @('--browser', 'brave', '--tier', 'Strict', '--platform', 'linux')
        $r.ExitCode | Should -Be 0
        ($r.Output | ConvertFrom-Json).PSObject.Properties |
            Measure-Object | Select-Object -ExpandProperty Count |
            Should -Be 151
    }

    It 'renders exactly the chromium-origin set for chrome' {
        $r = Invoke-OmegaRenderer @('--browser', 'chrome', '--tier', 'Strict', '--platform', 'linux')
        $r.ExitCode | Should -Be 0
        $keys = @((($r.Output | ConvertFrom-Json).PSObject.Properties | ForEach-Object { $_.Name }))
        $brave = @('BraveAIChatEnabled', 'TorDisabled', 'EmailAliasesEnabled', 'DefaultBraveAdblockSetting')
        foreach ($name in $brave) { $keys | Should -Not -Contain $name }
        $keys.Count | Should -Be 124
    }

    It 'prefers platform values per platform' {
        $lin = Invoke-OmegaRenderer @('--browser', 'brave', '--tier', 'Balanced', '--platform', 'linux')
        $win = Invoke-OmegaRenderer @('--browser', 'brave', '--tier', 'Balanced', '--platform', 'windows')
        ($lin.Output | ConvertFrom-Json).DownloadDirectory | Should -BeExactly '${HOME}/Downloads'
        ($win.Output | ConvertFrom-Json).DownloadDirectory | Should -BeExactly '%USERPROFILE%\Downloads\'
    }

    It 'keeps dictionary values as dictionaries' {
        $r = Invoke-OmegaRenderer @('--browser', 'brave', '--tier', 'Advanced', '--platform', 'linux')
        $json = $r.Output | ConvertFrom-Json
        $json.ExtensionSettings | Should -BeOfType [System.Management.Automation.PSCustomObject]
    }

    It 'emits empty lists as empty arrays' {
        $r = Invoke-OmegaRenderer @('--browser', 'brave', '--tier', 'BraveOnly', '--platform', 'linux')
        $json = $r.Output | ConvertFrom-Json
        @($json.BraveShieldsDisabledForUrls).Count | Should -Be 0
    }

    It 'defaults to the linux platform' {
        $r = Invoke-OmegaRenderer @('--browser', 'brave', '--tier', 'Balanced')
        $r.ExitCode | Should -Be 0
        ($r.Output | ConvertFrom-Json).DownloadDirectory | Should -BeExactly '${HOME}/Downloads'
    }
}
