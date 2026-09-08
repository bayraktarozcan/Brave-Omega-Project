BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Language Selection - Parameter" -Tag "Unit" {
    It "should declare Language with EN/TR/Auto validation defaulting to Auto" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[ValidateSet\("EN", "TR", "Auto"\)\]\[string\]\$Language\s*=\s*"Auto"' | Should -Be $true
    }

    It "should alias Dil to Language" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[Alias\("Dil"\)\]\[ValidateSet' | Should -Be $true
    }

    It "should ask exactly one bilingual question when interactive" {
        $content = Get-Content -Path $ScriptMain -Raw
        ([regex]::Matches($content, 'Press 1 for English').Count) | Should -BeExactly 1
    }

    It "should default to English without prompting when non-interactive" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'IsInputRedirected' | Should -Be $true
        $content -match '\$script:Lang = "EN"' | Should -Be $true
    }

    It "should select Turkish on answer 2" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\$langChoice -eq "2".*\$script:Lang = "TR"' | Should -Be $true
    }
}

Describe "Language Selection - Strings Table" -Tag "Unit" {
    It "should define a script-scoped strings table" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\$script:Strings = @\{' | Should -Be $true
    }

    It "should expose every UI message in both EN and TR" {
        $content = Get-Content -Path $ScriptMain -Raw
        $keys = [regex]::Matches($content, '(?m)^    ([A-Za-z0-9]+) = @\{ EN = "(.*)"; TR = "(.*)" \}\r?$')
        $keys.Count | Should -BeGreaterThan 100
        foreach ($m in $keys) {
            $m.Groups[2].Value.Length | Should -BeGreaterThan 0 -Because "EN text for $($m.Groups[1].Value) must not be empty"
            $m.Groups[3].Value.Length | Should -BeGreaterThan 0 -Because "TR text for $($m.Groups[1].Value) must not be empty"
        }
    }

    It "should resolve display names per language for all five levels" {
        $content = Get-Content -Path $ScriptMain -Raw
        foreach ($level in @('BraveOnly', 'Essential', 'Balanced', 'Advanced', 'Strict')) {
            $content -match ([regex]::Escape($level) + '\s+=\s+@\{ EN = "[^"]+";\s+TR = "[^"]+" \}') | Should -Be $true -Because "$level needs EN/TR display names"
        }
    }
}

Describe "Language Selection - Canonical Logic Guards" -Tag "Unit" {
    It "S/MIME notice condition should use the canonical level key (both languages)" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'if \(\$Level -in @\("Advanced", "Strict"\)\)' | Should -Be $true
        $content -match '\$Seviye -in' | Should -Be $false
    }

    It "yes-answers should accept both English and Turkish affirmatives" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '"E", "e", "Evet", "evet"' | Should -Be $true
        $content -match '"Y", "y", "Yes", "yes"' | Should -Be $true
    }
}
