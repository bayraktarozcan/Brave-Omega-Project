BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Reset Mode - Script Parameter" -Tag "Unit" {
    It "unified script should declare -Reset as switch parameter" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[switch\]\$Reset' | Should -Be $true
    }

    It "unified script should alias -Sifirla to -Reset" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[Alias\("Sifirla"\)\]\[switch\]\$Reset' | Should -Be $true
    }
}

Describe "Reset Mode - Reset Policy Count" -Tag "Unit" {
    It "unified reset should target HKLM policies" {
        $content = Get-Content -Path $ScriptMain -Raw
        $removals = [regex]::Matches($content, 'Remove-ItemProperty\s+-Path\s+\$HKLM_Target')
        $removals.Count | Should -BeGreaterOrEqual 1
    }

    It "unified reset should use the Remove-PolicyEntry helper for list-aware removal" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'Remove-PolicyEntry -TargetPath \$HKLM_Target -EntryName \$name' | Should -Be $true
    }

    It "unified reset should also target HKCU policies" {
        $content = Get-Content -Path $ScriptMain -Raw
        $removals = [regex]::Matches($content, 'Remove-ItemProperty\s+-Path\s+\$UserHive\.HkcuTarget')
        $removals.Count | Should -BeGreaterOrEqual 1
    }
}

Describe "Reset Mode - Path Constants Defined Before Reset Block" -Tag "Unit" {
    It "unified script should define HKCU/HKLM target constants before the -Reset block" {
        $content = Get-Content -Path $ScriptMain -Raw
        $hkcudef = $content.IndexOf('$HKCU_Target = ')
        $hklmdef = $content.IndexOf('$HKLM_Target = ')
        $resetIdx = $content.IndexOf('if ($Reset) {')
        $hkcudef | Should -BeGreaterThan 0
        $hklmdef | Should -BeGreaterThan 0
        $resetIdx | Should -BeGreaterThan 0
        $hkcudef | Should -BeLessThan $resetIdx
        $hklmdef | Should -BeLessThan $resetIdx
    }

    It "unified script should not re-define target constants inside the -Reset block" {
        $content = Get-Content -Path $ScriptMain -Raw
        $resetIdx = $content.IndexOf('if ($Reset) {')
        $dupIdx = $content.IndexOf('$HKCU_Target = ', $resetIdx)
        $dupIdx | Should -Be -1
        $dupIdx2 = $content.IndexOf('$HKLM_Target = ', $resetIdx)
        $dupIdx2 | Should -Be -1
    }
}

Describe "Reset Mode - allPolicyNames Array" -Tag "Unit" {
    It "unified script should source allPolicyNames from the data layer" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\$allPolicyNames\s*=\s*\$OmegaState\.AllPolicyNames' | Should -Be $true
    }

    It "data-layer allPolicyNames should include BraveRewardsDisabled" {
        (Get-OmegaAllPolicyNames -ScriptPath $ScriptMain) -contains "BraveRewardsDisabled" | Should -Be $true
    }

    It "data-layer allPolicyNames should include MetricsReportingEnabled" {
        (Get-OmegaAllPolicyNames -ScriptPath $ScriptMain) -contains "MetricsReportingEnabled" | Should -Be $true
    }

    It "data-layer allPolicyNames should include DefaultJavaScriptSetting" {
        (Get-OmegaAllPolicyNames -ScriptPath $ScriptMain) -contains "DefaultJavaScriptSetting" | Should -Be $true
    }
}

Describe "Reset Mode - Backup Before Removal" -Tag "Unit" {
    BeforeAll {
        $content = Get-Content -Path $ScriptMain -Raw
        $resetIdx = $content.IndexOf('if ($Reset) {')
        $resetBody = $content.Substring($resetIdx)
        $backupIdx = $resetBody.IndexOf('Export-OmegaRegistryBackup')
        $firstRemovalIdx = $resetBody.IndexOf('Remove-PolicyEntry -TargetPath $HKLM_Target')
        $guardIdx = $resetBody.IndexOf('if (-not $ResetBackupFile)')
        $exitIdx = $resetBody.IndexOf('exit 1')
    }

    It "unified reset should export both hives before it removes anything" {
        $backupIdx | Should -BeGreaterThan 0
        $firstRemovalIdx | Should -BeGreaterThan 0
        $backupIdx | Should -BeLessThan $firstRemovalIdx
    }

    It "unified reset should back up the machine-wide hive and the per-user root" {
        $resetBody | Should -Match 'Prefix\s*=\s*"HKLM_BravePolicy"'
        $resetBody | Should -Match 'HKCU_BraveSoftware_" \+ \$safeLabel'
    }

    It "unified reset should stop before removing when a backup fails" {
        # The guard and the exit have to sit between the export and the first
        # removal. An exit placed after a removal would report the failed backup
        # only once the policies it was meant to protect were already gone.
        $guardIdx | Should -BeGreaterThan $backupIdx
        $exitIdx | Should -BeGreaterThan $guardIdx
        $exitIdx | Should -BeLessThan $firstRemovalIdx
    }

    It "unified reset should back up only the hives that exist" {
        $resetBody | Should -Match 'if\s*\(-not\s*\(Test-Path\s+\$BackupTarget\.Path\)\)\s*\{\s*continue'
    }
}

Describe "Registry Backup Helper" -Tag "Unit" {
    It "unified script should declare a single backup helper" {
        (Get-ScriptFunctions -ScriptPath $ScriptMain) -contains "Export-OmegaRegistryBackup" | Should -Be $true
    }

    It "unified script should call reg export from exactly one place" {
        # One call site means the apply step and the reset step cannot drift into
        # two backup routines that disagree about the path, the name or the check.
        $content = Get-Content -Path $ScriptMain -Raw
        [regex]::Matches($content, 'reg export "\$flatPath"').Count | Should -Be 1
    }

    It "helper should write backups under the temporary BravePolicyBackup folder" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content | Should -Match 'Join-Path\s+-Path\s+\$env:TEMP\s+-ChildPath\s+"BravePolicyBackup"'
    }

    It "helper should name the backup by prefix and timestamp" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content | Should -Match '\{0\}_\{1\}\.reg'
        $content | Should -Match "Get-Date -Format 'yyyyMMdd_HHmmss'"
    }

    It "helper should require both a clean exit code and a file on disk" {
        # reg export signals failure through its exit code without throwing, so a
        # success message in the output stream proves nothing on its own.
        $content = Get-Content -Path $ScriptMain -Raw
        $content | Should -Match '\$regExitCode\s+-ne\s+0\s+-or\s+-not\s+\(Test-Path\s+-LiteralPath\s+\$backupFile\)'
    }

    It "helper should convert an HKLM provider path to the flat form reg export accepts" {
        ConvertTo-OmegaFlatRegistryPath -ScriptPath $ScriptMain -Path 'HKLM:\SOFTWARE\Policies\BraveSoftware\Brave' |
            Should -Be 'HKLM\SOFTWARE\Policies\BraveSoftware\Brave'
    }

    It "helper should convert an HKCU provider path to the flat form reg export accepts" {
        ConvertTo-OmegaFlatRegistryPath -ScriptPath $ScriptMain -Path 'HKCU:\Software\BraveSoftware' |
            Should -Be 'HKCU\Software\BraveSoftware'
    }

    It "helper should leave a single separator after the hive name" {
        $flat = ConvertTo-OmegaFlatRegistryPath -ScriptPath $ScriptMain -Path 'HKCU:\Software\BraveSoftware\Brave-Browser'
        $flat | Should -Not -Match '\\\\'
        $flat | Should -Be 'HKCU\Software\BraveSoftware\Brave-Browser'
    }
}
