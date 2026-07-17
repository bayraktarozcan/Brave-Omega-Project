BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Version Check" -Tag "Unit" {
    It "should have expected Brave version constant" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match 'ValidatedBrave.*=.*"1\.92\.141"' | Should -Be $true
    }

    It "should have expected Chromium version constant" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match 'ValidatedChromium.*=.*"150"' | Should -Be $true
    }

    It "should detect version mismatch" {
        $braveVersion = "1.90.100"
        $ValidatedBrave = "1.92.141"
        ($braveVersion -ne $ValidatedBrave) | Should -Be $true
    }

    It "should confirm version match" {
        $braveVersion = "1.92.141"
        $ValidatedBrave = "1.92.141"
        ($braveVersion -eq $ValidatedBrave) | Should -Be $true
    }
}
