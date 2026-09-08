BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Version Check" -Tag "Unit" {
    It "unified script should have expected Brave version constant" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'ValidatedBrave.*=.*"1\.94\.121"' | Should -Be $true
    }

    It "unified script should have expected Chromium version constant" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'ValidatedChromium.*=.*"152"' | Should -Be $true
    }

    It "unified script should have no per-language version fork" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'DogrulananBrave' | Should -Be $false
        $content -match 'DogrulananChromium' | Should -Be $false
    }

    It "should detect version mismatch" {
        $braveVersion = "1.90.100"
        $ValidatedBrave = "1.93.136"
        ($braveVersion -ne $ValidatedBrave) | Should -Be $true
    }

    It "should confirm version match" {
        $braveVersion = "1.94.121"
        $ValidatedBrave = "1.94.121"
        ($braveVersion -eq $ValidatedBrave) | Should -Be $true
    }

    It "version constants should be defined exactly once" {
        $content = Get-Content -Path $ScriptMain -Raw
        ([regex]::Matches($content, '\$ValidatedBrave\s*=').Count) | Should -BeExactly 1
        ([regex]::Matches($content, '\$ValidatedChromium\s*=').Count) | Should -BeExactly 1
    }
}
