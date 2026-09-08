BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Reset Mode - Script Parameter" -Tag "Unit" {
    It "unified script should declare -Reset as switch parameter" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[switch\]\$Reset' | Should -Be $true
    }

    It "unified script should alias -Sifirla to -Reset" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[Alias\("Sifirla"\)\]\[switch\]\$Reset' | Should -Be $true
    }
}

Describe "Reset Mode - Reset Policy Count" -Tag "Unit" {
    It "unified reset should target HKLM policies" {
        $content = Get-Content -Path $ScriptMain -Raw
        $removals = [regex]::Matches($content, 'Remove-ItemProperty\s+-Path\s+\$HKLM_Target')
        $removals.Count | Should -BeGreaterOrEqual 1
    }

    It "unified reset should use the Remove-PolicyEntry helper for list-aware removal" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'Remove-PolicyEntry -TargetPath \$HKLM_Target -EntryName \$name' | Should -Be $true
    }

    It "unified reset should also target HKCU policies" {
        $content = Get-Content -Path $ScriptMain -Raw
        $removals = [regex]::Matches($content, 'Remove-ItemProperty\s+-Path\s+\$HKCU_Target')
        $removals.Count | Should -BeGreaterOrEqual 1
    }

    It "wrappers should not implement reset logic themselves" {
        foreach ($wrapper in @($ScriptEN, $ScriptTR)) {
            $content = Get-Content -Path $wrapper -Raw
            $content -match 'Remove-ItemProperty' | Should -Be $false
            $content -match 'Remove-PolicyEntry' | Should -Be $false
        }
    }
}

Describe "Reset Mode - Path Constants Defined Before Reset Block" -Tag "Unit" {
    It "unified script should define HKCU/HKLM target constants before the -Reset block" {
        $content = Get-Content -Path $ScriptMain -Raw
        $hkcudef = $content.IndexOf('$HKCU_Target = ')
        $hklmdef = $content.IndexOf('$HKLM_Target = ')
        $resetIdx = $content.IndexOf('if ($Reset) {')
        $hkcudef | Should -BeGreaterThan 0
        $hklmdef | Should -BeGreaterThan 0
        $resetIdx | Should -BeGreaterThan 0
        $hkcudef | Should -BeLessThan $resetIdx
        $hklmdef | Should -BeLessThan $resetIdx
    }

    It "unified script should not re-define target constants inside the -Reset block" {
        $content = Get-Content -Path $ScriptMain -Raw
        $resetIdx = $content.IndexOf('if ($Reset) {')
        $dupIdx = $content.IndexOf('$HKCU_Target = ', $resetIdx)
        $dupIdx | Should -Be -1
        $dupIdx2 = $content.IndexOf('$HKLM_Target = ', $resetIdx)
        $dupIdx2 | Should -Be -1
    }
}

Describe "Reset Mode - allPolicyNames Array" -Tag "Unit" {
    It "unified script should define allPolicyNames array" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\$allPolicyNames\s*=\s*@\(' | Should -Be $true
    }

    It "unified allPolicyNames should include BraveRewardsDisabled" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'BraveRewardsDisabled' | Should -Be $true
    }

    It "unified allPolicyNames should include MetricsReportingEnabled" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'MetricsReportingEnabled' | Should -Be $true
    }

    It "unified allPolicyNames should include DefaultJavaScriptSetting" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match 'DefaultJavaScriptSetting' | Should -Be $true
    }
}
