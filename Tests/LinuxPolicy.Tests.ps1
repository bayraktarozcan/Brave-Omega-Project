BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $script:RendererPath = Join-Path $ProjectRoot 'Scripts/Render-PolicyJSON.py'
    $script:PythonCmd = Get-OmegaPythonCommand
    if (-not $script:PythonCmd) {
        throw 'a working python interpreter is required to exercise Scripts/Render-PolicyJSON.py'
    }

    function Invoke-OmegaRenderer {
        param([string[]]$Arguments)
        $exe = $script:PythonCmd[0]
        $pre = @($script:PythonCmd | Select-Object -Skip 1)
        $out = & $exe @pre $script:RendererPath @Arguments 2>&1
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

    It 'never splats the interpreter array as the command' {
        # `& @array` expands arguments, never the command: the exe must be
        # split out first or the joined string fails as one command name.
        # This exact mistake shipped once and broke every suite that shells
        # out to Python, so the shape is pinned, not just the behavior.
        $files = @(
            (Join-Path $ProjectRoot 'Tests/LinuxPolicy.Tests.ps1'),
            (Join-Path $ProjectRoot 'Tests/MojibakeScan.Tests.ps1'),
            (Join-Path $ProjectRoot 'Scripts/Invoke-CI.ps1')
        )
        $bad = $(foreach ($file in $files) {
            $text = Get-Content -LiteralPath $file -Raw
            if ($text -match '&\s+@(script:)?Python(Cmd)?\b') { $file }
        })
        $bad | Should -BeNullOrEmpty -Because 'splatting supplies arguments, never the command itself'
    }
}
