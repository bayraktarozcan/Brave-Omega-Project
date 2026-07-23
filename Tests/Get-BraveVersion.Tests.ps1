BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $funcBlock = New-FunctionScriptBlock -ScriptPath $ScriptEN
    . $funcBlock
}

Describe "Get-BraveVersion" -Tag "Unit" {
    It "should detect Brave from ProgramFiles path" {
        Mock Test-Path { return $true }
        Mock Get-Item { return @{VersionInfo = @{ProductVersion = "150.1.70.99"}} }
        $version = Get-BraveVersion
        $version | Should -Not -BeNullOrEmpty
        $version.BraveVersion | Should -Be "1.70.99"
    }

    It "should return null when Brave is not installed" {
        Mock Test-Path { return $false }
        $version = Get-BraveVersion
        $version | Should -BeNullOrEmpty
    }

    It "should match expected version format" {
        Mock Test-Path { return $true }
        Mock Get-Item { return @{VersionInfo = @{ProductVersion = "150.1.92.143"}} }
        $version = Get-BraveVersion
        $version.BraveVersion | Should -Be "1.92.143"
    }
}
