BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "WhatIf Mode - Script Parameter" -Tag "Unit" {
    It "unified script should declare -WhatIf as switch parameter" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[switch\]\$WhatIf' | Should -Be $true
    }

    It "unified param block should include Level, WhatIf, Reset, AllowSync, and Language" {
        $content = Get-Content -Path $ScriptMain -Raw
        $content -match '\[string\]\$Level\s*=\s*""' | Should -Be $true
        $content -match '\[switch\]\$WhatIf' | Should -Be $true
        $content -match '\[switch\]\$Reset' | Should -Be $true
        $content -match '\[switch\]\$AllowSync' | Should -Be $true
        $content -match '\$Language' | Should -Be $true
    }
}

Describe "WhatIf Mode - Write-PolicyValue Behavior" -Tag "Unit" {
    It "unified Write-PolicyValue should accept -WhatIf parameter" {
        $content = Get-Content -Path $ScriptMain -Raw
        $funcMatch = [regex]::Match($content, 'function\s+Write-PolicyValue\s*\{[^}]*param\([^)]*\[switch\]\$WhatIf', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        $funcMatch.Success | Should -Be $true
    }
}

Describe "WhatIf Mode - Reset Backup Skipped" -Tag "Unit" {
    BeforeAll {
        $content = Get-Content -Path $ScriptMain -Raw
        $resetIdx = $content.IndexOf('if ($Reset) {')
        $resetBody = $content.Substring($resetIdx)
        $whatIfIdx = $resetBody.IndexOf('if ($WhatIf) {')
        $elseIdx = $resetBody.IndexOf('} else {', $whatIfIdx)
        $backupIdx = $resetBody.IndexOf('Export-OmegaRegistryBackup')
    }

    It "unified script should carry a message for a reset backup skipped by WhatIf" {
        $content -match 'ResetBackupWhatIf\s*=' | Should -Be $true
    }

    It "unified reset should take the export only on the branch that is not WhatIf" {
        # WhatIf promises it changes nothing, and a .reg file on disk is a change.
        # The export therefore belongs to the else branch: a call inside the WhatIf
        # branch would pass the ordering check below while still writing a file.
        $whatIfIdx | Should -BeGreaterThan 0
        $elseIdx | Should -BeGreaterThan $whatIfIdx
        $backupIdx | Should -BeGreaterThan $elseIdx
    }
}
