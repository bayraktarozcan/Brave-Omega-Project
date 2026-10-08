BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $funcBlock = New-FunctionScriptBlock -ScriptPath $ScriptMain
    . $funcBlock
}

Describe 'Browser target selection' -Tag 'Unit' {

    It 'should declare a Browser parameter defaulting to Brave' {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[ValidateSet\("Brave", "Chrome"\)\]\[string\]\$Browser' | Should -Be $true
        $content -match '\[Alias\("Tarayici"\)\]' | Should -Be $true
    }

    It 'should resolve Chrome registry roots from the browser profile' {
        $prof = Get-Content -LiteralPath (Join-Path $ProjectRoot 'Brave-Omega/Browsers/chrome.json') -Raw |
            ConvertFrom-Json
        $prof.windows.hklmRoot | Should -BeExactly 'HKLM:\SOFTWARE\Policies\Google\Chrome'
        $prof.windows.hkcuTarget | Should -BeExactly 'HKCU:\Software\Google\Chrome'
    }

    It 'should build per-profile paths from the given browser roots' {
        Mock Get-OmegaUserProfileList {
            return @([pscustomobject]@{ SID = 'S-1-5-21-9'; LocalPath = 'C:\Users\t'; Special = $false })
        }
        $hives = @(Get-OmegaLocalUserHive -HkcuTarget 'HKCU:\Software\Google\Chrome' -HkcuRoot 'HKCU:\Software\Google')
        $hives.Count | Should -BeExactly 1
        $hives[0].HkcuTarget | Should -BeExactly 'Registry::HKEY_USERS\S-1-5-21-9\Software\Google\Chrome'
        $hives[0].HkcuRoot | Should -BeExactly 'Registry::HKEY_USERS\S-1-5-21-9\Software\Google'
    }

    It 'should filter brave-origin policies out of the Chrome merge' {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\$Policy\.Origin -eq "brave" -and \$Browser -ne "Brave"' | Should -Be $true
    }

    It 'should detect Chrome executables when asked' {
        Mock Test-Path { return $true }
        Mock Get-Item { return @{VersionInfo = @{ProductVersion = "155.1.97.56"}} }
        $version = Get-BraveVersion -Browser Chrome
        $version | Should -Not -BeNullOrEmpty
        $version.BraveVersion | Should -Be '1.97.56'
    }

    It 'should resolve profiles through a mockable helper' {
        $content = Get-Content -Path $ScriptMain -Raw
        $start = $content.IndexOf('function Get-BraveVersion')
        $end = $content.IndexOf('STEP 0A', $start)
        $body = $content.Substring($start, $end - $start)
        $body -match 'Get-OmegaUserProfileList' | Should -Be $true
    }

    It 'should skip empty program-files roots' {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'IsNullOrEmpty\(\$programFiles\)' | Should -Be $true
    }

    It 'should announce the selected browser' {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match "Get-LocalizedString 'SelectedBrowser'" | Should -Be $true
    }

    It 'should report the Chrome success line on Chrome runs' {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match "'FinalSuccess2Chrome'" | Should -Be $true
    }
}
