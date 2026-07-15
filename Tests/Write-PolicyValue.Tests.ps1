BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
    $funcBlock = New-FunctionScriptBlock -ScriptPath $ScriptEN
    . $funcBlock
}

Describe "Write-PolicyValue" -Tag "Unit" {
    It "should write DWord value to registry" {
        Mock New-ItemProperty { return $null }
        Write-PolicyValue -TargetPath "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -PolicyName "TestPolicy" -PolicyValue 1 -ValueType "DWord"
        Should -Invoke New-ItemProperty -Times 1 -Exactly
    }

    It "should write String value to registry" {
        Mock New-ItemProperty { return $null }
        Write-PolicyValue -TargetPath "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -PolicyName "TestPolicy" -PolicyValue "automatic" -ValueType "String"
        Should -Invoke New-ItemProperty -Times 1 -Exactly
    }

    It "should handle MultiString type in WhatIf mode" {
        $result = Write-PolicyValue -TargetPath "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -PolicyName "TestMulti" -PolicyValue @("val1","val2") -ValueType "MultiString" -WhatIf
        $result | Should -BeLike "*val1*val2*"
    }

    It "should skip write in WhatIf mode" {
        Mock New-ItemProperty { return $null }
        Write-PolicyValue -TargetPath "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -PolicyName "TestPolicy" -PolicyValue 1 -ValueType "DWord" -WhatIf
        Should -Invoke New-ItemProperty -Times 0 -Exactly
    }
}
