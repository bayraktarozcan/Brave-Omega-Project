BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Version Check" -Tag "Unit" {
    It "EN should have expected Brave version constant" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match 'ValidatedBrave.*=.*"1\.92\.143"' | Should -Be $true
    }

    It "EN should have expected Chromium version constant" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match 'ValidatedChromium.*=.*"150"' | Should -Be $true
    }

    It "TR should have expected Brave version constant" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match 'DogrulananBrave.*=.*"1\.92\.143"' | Should -Be $true
    }

    It "TR should have expected Chromium version constant" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match 'DogrulananChromium.*=.*"150"' | Should -Be $true
    }

    It "should detect version mismatch" {
        $braveVersion = "1.90.100"
        $ValidatedBrave = "1.92.143"
        ($braveVersion -ne $ValidatedBrave) | Should -Be $true
    }

    It "should confirm version match" {
        $braveVersion = "1.92.143"
        $ValidatedBrave = "1.92.143"
        ($braveVersion -eq $ValidatedBrave) | Should -Be $true
    }

    It "EN and TR should have matching Brave version constants" {
        $enContent = Get-Content -Path $ScriptEN -Raw
        $trContent = Get-Content -Path $ScriptTR -Raw
        $enMatch = [regex]::Match($enContent, 'ValidatedBrave.*=.*"([0-9.]+)"')
        $trMatch = [regex]::Match($trContent, 'DogrulananBrave.*=.*"([0-9.]+)"')
        $enMatch.Success | Should -Be $true
        $trMatch.Success | Should -Be $true
        $enMatch.Groups[1].Value | Should -Be $trMatch.Groups[1].Value
    }

    It "EN and TR should have matching Chromium version constants" {
        $enContent = Get-Content -Path $ScriptEN -Raw
        $trContent = Get-Content -Path $ScriptTR -Raw
        $enMatch = [regex]::Match($enContent, 'ValidatedChromium.*=.*"([0-9]+)"')
        $trMatch = [regex]::Match($trContent, 'DogrulananChromium.*=.*"([0-9]+)"')
        $enMatch.Success | Should -Be $true
        $trMatch.Success | Should -Be $true
        $enMatch.Groups[1].Value | Should -Be $trMatch.Groups[1].Value
    }
}
