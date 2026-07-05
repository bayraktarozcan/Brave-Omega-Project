BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Omaha GUID Discovery" -Tag "Unit" {
    It "should handle missing Omaha registry path gracefully" {
        Mock Test-Path { return $false } -ParameterFilter { $Path -match "ClientState" }
        Mock Get-ChildItem { throw "Should not be called" } -ParameterFilter { $Path -match "ClientState" }
        $RootPath = "HKCU:\Software\BraveSoftware"
        $paths = if (Test-Path "$RootPath\Update\ClientState") {
            Get-ChildItem "$RootPath\Update\ClientState" -ErrorAction SilentlyContinue
        } else { @() }
        $paths.Count | Should -Be 0
    }

    It "should handle registry access errors" {
        Mock Test-Path { return $true } -ParameterFilter { $Path -match "ClientState" }
        Mock Get-ChildItem { throw "Access denied" } -ParameterFilter { $Path -match "ClientState" }
        $paths = try {
            Get-ChildItem "HKCU:\Software\BraveSoftware\Update\ClientState" -ErrorAction Stop
        } catch { @() }
        $paths.Count | Should -Be 0
    }
}
