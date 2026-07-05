BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Admin Check" -Tag "Integration" {
    It "should detect non-admin context" -Skip:($env:OS -ne "Windows_NT" -or $env:CI) {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $role = New-Object Security.Principal.WindowsPrincipal($identity)
        $isAdmin = $role.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        $isAdmin | Should -Be $false
    }

    It "script should define `$IsAdmin variable" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '\$IsAdmin\s*=' | Should -Be $true
    }
}
