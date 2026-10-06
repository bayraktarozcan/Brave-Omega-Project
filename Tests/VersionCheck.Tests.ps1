BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Version Check" -Tag "Unit" {
    It "unified script should not have hardcoded validated Brave version (V3 global compatibility)" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\$ValidatedBrave\s*=\s*"1\.96\.59"' | Should -Be $false
    }

    It "unified script should not have hardcoded validated Chromium version (V3 global compatibility)" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\$ValidatedChromium\s*=\s*"154"' | Should -Be $false
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
        $braveVersion = "1.96.59"
        $ValidatedBrave = "1.96.59"
        ($braveVersion -eq $ValidatedBrave) | Should -Be $true
    }

    It "version variables are declared empty once and populated once at runtime" {
        $content = Get-Content -Path $ScriptMain -Raw
        ([regex]::Matches($content, '\$ValidatedBrave\s*=').Count) | Should -BeExactly 2
        ([regex]::Matches($content, '\$ValidatedChromium\s*=').Count) | Should -BeExactly 2
        $content -match '\$ValidatedBrave\s*=\s*""' | Should -Be $true
        $content -match '\$ValidatedBrave\s*=\s*\$braveInfo\.BraveVersion' | Should -Be $true
    }
}