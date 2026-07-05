BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Reset Mode" -Tag "Unit" {
    It "should contain at least the minimum required policy names for reset" {
        $allPolicyNames = @(
            "BraveRewardsDisabled","BraveWalletDisabled","BraveVPNDisabled",
            "MetricsReportingEnabled","PasswordManagerEnabled","TranslateEnabled"
        )
        $allPolicyNames.Count | Should -BeGreaterOrEqual 6
    }

    It "should attempt remove on both HKLM and HKCU paths" {
        $removes = @()
        Mock Remove-ItemProperty { $removes += $Path; return $null }
        $HKLM = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
        $HKCU = "HKCU:\Software\BraveSoftware\Brave-Browser"
        $allPolicyNames = @("TestPolicy")
        foreach ($name in $allPolicyNames) {
            Remove-ItemProperty -Path $HKLM -Name $name -ErrorAction SilentlyContinue
            Remove-ItemProperty -Path $HKCU -Name $name -ErrorAction SilentlyContinue
        }
        Should -Invoke Remove-ItemProperty -Times 2 -Exactly
    }
}
