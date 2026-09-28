BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe "Level Selection" -Tag "Unit" {

    Context "Level name resolution contract" {

        It "resolves every Turkish level name onto a level the data layer defines" {
            $order = Get-OmegaLevelOrder
            $map = Get-OmegaScriptHashtable -VariableName "LevelMap"
            $map | Should -Not -BeNullOrEmpty
            foreach ($turkish in $map.Keys) {
                $map[$turkish] | Should -BeIn $order
            }
        }

        It "maps each Turkish level name to a distinct level" {
            $map = Get-OmegaScriptHashtable -VariableName "LevelMap"
            $map.Values.Count | Should -Be @($map.Values | Sort-Object -Unique).Count
        }

        It "accepts exactly the Turkish names the interface advertises" {
            $map = Get-OmegaScriptHashtable -VariableName "LevelMap"
            $display = Get-OmegaScriptHashtable -VariableName "LevelDisplayNames"
            $advertised = @($display.Values | ForEach-Object { $_["TR"] })
            (Compare-Object @($map.Keys | Sort-Object) @($advertised | Sort-Object)) | Should -BeNullOrEmpty
        }

        It "gives every level in the data layer a localized display name" {
            $order = Get-OmegaLevelOrder
            $display = Get-OmegaScriptHashtable -VariableName "LevelDisplayNames"
            $display | Should -Not -BeNullOrEmpty
            (Compare-Object @($display.Keys | Sort-Object) @($order | Sort-Object)) | Should -BeNullOrEmpty
        }

        It "provides both English and Turkish display text for every level" {
            $display = Get-OmegaScriptHashtable -VariableName "LevelDisplayNames"
            foreach ($level in $display.Keys) {
                $display[$level]["EN"] | Should -Not -BeNullOrEmpty
                $display[$level]["TR"] | Should -Not -BeNullOrEmpty
            }
        }
    }

    Context "Interactive menu coverage" {

        It "offers every level in the data layer" {
            $order = Get-OmegaLevelOrder
            $menu = Get-OmegaLevelMenuMap
            $menu | Should -Not -BeNullOrEmpty -Because "the level menu switch must stay parseable; update Get-OmegaLevelMenuMap if its shape changed"
            (Compare-Object @($menu.Values | Sort-Object) @($order | Sort-Object)) | Should -BeNullOrEmpty
        }

        It "offers exactly one menu option per level in the data layer" {
            $order = Get-OmegaLevelOrder
            $menu = Get-OmegaLevelMenuMap
            $menu.Keys.Count | Should -Be $order.Count
        }

        It "numbers the menu sequentially from one so no option is unreachable" {
            $order = Get-OmegaLevelOrder
            $menu = Get-OmegaLevelMenuMap
            $expected = @(1..$order.Count | ForEach-Object { [string]$_ })
            (Compare-Object @($menu.Keys) $expected) | Should -BeNullOrEmpty
        }
    }

    Context "Level reachability" {

        It "ships a policy profile for every level in the data layer" {
            $order = Get-OmegaLevelOrder
            $profilesDir = Join-Path (Split-Path -Path $ScriptMain -Parent) "Profiles"
            foreach ($level in $order) {
                Join-Path $profilesDir "$level.json" | Should -Exist
            }
        }
    }
}
