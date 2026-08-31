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

    It "should write MultiString as numbered REG_SZ values under a list subkey" {
        Mock Join-Path { return "TestDrive:\$($args[1])" }
        Mock Remove-ItemProperty { return $null }
        Mock Test-Path { return $false }
        Mock New-Item { return $null }
        Mock New-ItemProperty { return $null }
        Write-PolicyValue -TargetPath "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -PolicyName "TestMulti" -PolicyValue @("val1","val2") -ValueType "MultiString"
        Should -Invoke Remove-ItemProperty -Times 1 -Exactly
        Should -Invoke New-Item -Times 1 -Exactly
        Should -Invoke New-ItemProperty -Times 2 -Exactly
        Should -Invoke New-ItemProperty -ParameterFilter { $Name -eq "1" -and $Value -eq "val1" } -Times 1 -Exactly
        Should -Invoke New-ItemProperty -ParameterFilter { $Name -eq "2" -and $Value -eq "val2" } -Times 1 -Exactly
    }

    It "should create the list subkey even when MultiString value is empty" {
        Mock Join-Path { return "TestDrive:\$($args[1])" }
        Mock Remove-ItemProperty { return $null }
        Mock Test-Path { return $false }
        Mock New-Item { return $null }
        Mock New-ItemProperty { return $null }
        Write-PolicyValue -TargetPath "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -PolicyName "TestMulti" -PolicyValue @() -ValueType "MultiString"
        Should -Invoke New-Item -Times 1 -Exactly
        Should -Invoke New-ItemProperty -Times 0 -Exactly
    }

    It "should remove a stale value and list subkey before writing MultiString" {
        Mock Join-Path { return "TestDrive:\$($args[1])" }
        Mock Remove-ItemProperty { return $null }
        Mock Test-Path { return $true }
        Mock Remove-Item { return $null }
        Mock New-Item { return $null }
        Mock New-ItemProperty { return $null }
        Write-PolicyValue -TargetPath "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -PolicyName "TestMulti" -PolicyValue @("val1") -ValueType "MultiString"
        Should -Invoke Remove-ItemProperty -Times 1 -Exactly
        Should -Invoke Remove-Item -Times 1 -Exactly
    }
}

Describe "Remove-PolicyEntry" -Tag "Unit" {
    It "should remove the value and the list subkey" {
        Mock Join-Path { return "TestDrive:\$($args[1])" }
        Mock Remove-ItemProperty { return $null }
        Mock Test-Path { return $true }
        Mock Remove-Item { return $null }
        Remove-PolicyEntry -TargetPath "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -EntryName "TestMulti"
        Should -Invoke Remove-ItemProperty -Times 1 -Exactly
        Should -Invoke Remove-Item -Times 1 -Exactly
    }

    It "should skip list subkey removal when it does not exist" {
        Mock Join-Path { return "TestDrive:\$($args[1])" }
        Mock Remove-ItemProperty { return $null }
        Mock Test-Path { return $false }
        Mock Remove-Item { return $null }
        Remove-PolicyEntry -TargetPath "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -EntryName "TestMulti"
        Should -Invoke Remove-ItemProperty -Times 1 -Exactly
        Should -Invoke Remove-Item -Times 0 -Exactly
    }
}
