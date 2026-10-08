BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $funcBlock = New-FunctionScriptBlock -ScriptPath $ScriptMain
    . $funcBlock
}

Describe "Administrator protection compatibility" -Tag "Unit" {
    It "should define per-profile hive helpers" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'function Get-OmegaUserHivePath' | Should -Be $true
        $content -match 'function Get-OmegaLocalUserHive' | Should -Be $true
        $content -match 'function Mount-OmegaUserHive' | Should -Be $true
        $content -match 'function Dismount-OmegaUserHive' | Should -Be $true
    }

    It "should build HKEY_USERS paths from a SID" {
        Get-OmegaUserHivePath -Sid "S-1-5-21-1000" | Should -BeExactly 'Registry::HKEY_USERS\S-1-5-21-1000'
    }

    It "should detect Brave without environment user paths" {
        $content = Get-Content -Path $ScriptMain -Raw
        $start = $content.IndexOf('function Get-BraveVersion')
        $end = $content.IndexOf('STEP 0A', $start)
        $body = $content.Substring($start, $end - $start)
        ([regex]::Matches($body, '\$env:LOCALAPPDATA')).Count | Should -BeLessOrEqual 1
        $body -match 'Get-OmegaUserProfileList' | Should -Be $true
    }

    It "should write HKCU preferences per profile, not to a single path" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'foreach \(\$UserHive in \$OmegaUserHives\)' | Should -Be $true
        $content -match 'New-ItemProperty -Path \$UserHive\.HkcuTarget -Name "UsageStatsInSample"' | Should -Be $true
        $content -match 'New-ItemProperty -Path \$UserHive\.HkcuTarget -Name "ChromeVariations"' | Should -Be $true
    }

    It "should pair every hive mount with an unload" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'Dismount-OmegaUserHive -UserHive \$UserHive' | Should -Be $true
        $content -match '\$UserHive\.Mounted = \$false' | Should -Be $true
    }

    It "should export backups through flat hive paths" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match "replace '\^Registry::', ''" | Should -Be $true
    }

    It "should fall back to the current-user context when enumeration finds nothing" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match "Label\s+= 'current user'" | Should -Be $true
    }

    It "should never mount hives in WhatIf mode" {
        Mock Test-Path { return $false }
        $hive = @{ Sid = 'S-1-5-21-9999'; Label = 'nobody'; HivePath = 'Registry::HKEY_USERS\S-1-5-21-9999'; HkcuTarget = 'x'; HkcuRoot = 'x'; NtUserDat = 'TestDrive:\NTUSER.DAT'; Mounted = $false }
        Mount-OmegaUserHive -UserHive $hive -WhatIf | Should -Be $false
        $hive.Mounted | Should -Be $false
    }
}
