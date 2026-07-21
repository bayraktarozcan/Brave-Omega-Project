BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Reset Mode - Script Parameter" -Tag "Unit" {
    It "EN script should declare -Reset as switch parameter" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '\[switch\]\$Reset' | Should -Be $true
    }

    It "TR script should declare -Sifirla as switch parameter" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match '\[switch\]\$Sifirla' | Should -Be $true
    }
}

Describe "Reset Mode - Reset Policy Count" -Tag "Unit" {
    It "EN reset should target HKLM policies" {
        $content = Get-Content -Path $ScriptEN -Raw
        $removals = [regex]::Matches($content, 'Remove-ItemProperty\s+-Path\s+\$HKLM_Target')
        $removals.Count | Should -BeGreaterOrEqual 1
    }

    It "TR reset should target HKLM policies" {
        $content = Get-Content -Path $ScriptTR -Raw
        $removals = [regex]::Matches($content, 'Remove-ItemProperty\s+-Path\s+\$HKLM_Hedef')
        $removals.Count | Should -BeGreaterOrEqual 1
    }

    It "EN reset should also target HKCU policies" {
        $content = Get-Content -Path $ScriptEN -Raw
        $removals = [regex]::Matches($content, 'Remove-ItemProperty\s+-Path\s+\$HKCU_Target')
        $removals.Count | Should -BeGreaterOrEqual 1
    }

    It "TR reset should also target HKCU policies" {
        $content = Get-Content -Path $ScriptTR -Raw
        $removals = [regex]::Matches($content, 'Remove-ItemProperty\s+-Path\s+\$HKCU_Hedef')
        $removals.Count | Should -BeGreaterOrEqual 1
    }

    It "EN and TR should have similar reset policy counts" {
        $enContent = Get-Content -Path $ScriptEN -Raw
        $trContent = Get-Content -Path $ScriptTR -Raw
        $enRemovals = [regex]::Matches($enContent, 'Remove-ItemProperty\s+-Path\s+\$HKLM_Target')
        $trRemovals = [regex]::Matches($trContent, 'Remove-ItemProperty\s+-Path\s+\$HKLM_Hedef')
        $enRemovals.Count | Should -Be $trRemovals.Count
    }
}

Describe "Reset Mode - allPolicyNames Array" -Tag "Unit" {
    It "EN should define allPolicyNames array" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match '\$allPolicyNames\s*=\s*@\(' | Should -Be $true
    }

    It "EN allPolicyNames should include BraveRewardsDisabled" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match 'BraveRewardsDisabled' | Should -Be $true
    }

    It "EN allPolicyNames should include MetricsReportingEnabled" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match 'MetricsReportingEnabled' | Should -Be $true
    }

    It "EN allPolicyNames should include DefaultJavaScriptSetting" {
        $content = Get-Content -Path $ScriptEN -Raw
        $content -match 'DefaultJavaScriptSetting' | Should -Be $true
    }

    It "TR should define tumPolitikalar array" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match '\$tumPolitikalar\s*=\s*@\(' | Should -Be $true
    }

    It "TR tumPolitikalar should include BraveRewardsDisabled" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match 'BraveRewardsDisabled' | Should -Be $true
    }

    It "TR tumPolitikalar should include MetricsReportingEnabled" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match 'MetricsReportingEnabled' | Should -Be $true
    }

    It "TR tumPolitikalar should include DefaultJavaScriptSetting" {
        $content = Get-Content -Path $ScriptTR -Raw
        $content -match 'DefaultJavaScriptSetting' | Should -Be $true
    }
}
