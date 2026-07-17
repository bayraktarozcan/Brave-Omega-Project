BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $funcBlock = New-FunctionScriptBlock -ScriptPath $ScriptEN
    . $funcBlock
}

Describe "Get-BraveVersion" -Tag "Unit" {
    It "should detect Brave from ProgramFiles path" {
        Mock Test-Path { return $true }
        Mock Get-Item { return @{VersionInfo = @{FileVersion = "1.70.99.0"}} }
        $version = Get-BraveVersion
        $version | Should -Not -BeNullOrEmpty
        $version.BraveVersion | Should -Be "70.99.0"
    }

    It "should return null when Brave is not installed" {
        Mock Test-Path { return $false }
        $version = Get-BraveVersion
        $version | Should -BeNullOrEmpty
    }

    It "should match expected version format" {
        Mock Test-Path { return $true }
        Mock Get-Item { return @{VersionInfo = @{FileVersion = "1.92.141.0"}} }
        $version = Get-BraveVersion
        $version.BraveVersion | Should -Be "92.141.0"
    }
}
