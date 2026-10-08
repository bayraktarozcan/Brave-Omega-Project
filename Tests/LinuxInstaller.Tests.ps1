BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $script:InstallerPath = Join-Path $ProjectRoot 'Brave-Omega/Install-OmegaLinux.sh'
}

Describe 'Linux installer static contract' -Tag 'Unit' {

    It 'starts with a POSIX sh shebang' {
        $first = @(Get-Content -LiteralPath $script:InstallerPath -TotalCount 1)
        $first | Should -BeExactly '#!/bin/sh'
    }

    It 'fails closed without root and without python3' {
        $text = Get-Content -LiteralPath $script:InstallerPath -Raw
        $text | Should -Match 'id -u'
        $text | Should -Match 'command -v python3'
    }

    It 'supports a dry run that writes nothing' {
        $text = Get-Content -LiteralPath $script:InstallerPath -Raw
        $text | Should -Match '--dry-run'
    }

    It 'contains no bashisms' {
        $text = Get-Content -LiteralPath $script:InstallerPath -Raw
        $text | Should -Not -Match '\[\['
        $text | Should -Not -Match '(?m)^\s*function\s'
        $text | Should -Not -Match '(?m)^\s*source\s'
    }

    It 'writes managed JSON with root-only permissions' {
        $text = Get-Content -LiteralPath $script:InstallerPath -Raw
        $text | Should -Match 'policies/managed'
        $text | Should -Match 'chmod 0644'
        $text | Should -Match 'chown root:root'
    }
}
