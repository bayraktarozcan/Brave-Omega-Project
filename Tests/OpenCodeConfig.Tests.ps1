BeforeAll {
    $ProjectRoot = Split-Path -Parent $PSScriptRoot
    $ConfigPath = Join-Path $ProjectRoot '.opencode/opencode.json'

    # The vendor's action enum, not a local opinion about it. Three values is
    # the part of the contract this file actually depends on, and it is the
    # part that silently changes behaviour when it drifts.
    $script:Actions = @('allow', 'ask', 'deny')

    $script:ReadConfig = {
        if (-not (Test-Path -LiteralPath $ConfigPath)) {
            throw '.opencode/opencode.json is missing; the runtime control surface is not optional once AGENTS.md refers to it'
        }
        Get-Content -LiteralPath $ConfigPath -Raw | ConvertFrom-Json
    }

    # Every permission map the file declares, whether it belongs to the tool or to
    # one agent: the ordering rule is a property of the last matching rule, so it
    # applies wherever rules are written and an agent map is just as easy to
    # write backwards as the top-level one.
    $script:GetPermissionMaps = {
        param($Config)
        $maps = @()
        foreach ($tool in $Config.permission.PSObject.Properties) {
            $maps += [pscustomobject]@{ Name = $tool.Name; Rules = $tool.Value }
        }
        foreach ($agent in $Config.agent.PSObject.Properties) {
            if ($null -eq $agent.Value.permission) { continue }
            foreach ($tool in $agent.Value.permission.PSObject.Properties) {
                $maps += [pscustomobject]@{ Name = "$($agent.Name)/$($tool.Name)"; Rules = $tool.Value }
            }
        }
        $maps
    }
}

Describe 'OpenCode control surface' {

    Context 'A contract the tool can actually read' {
        It 'the config parses as JSON' {
            { & $script:ReadConfig } | Should -Not -Throw -Because 'the tool reads this file at startup, and a parse error disables the whole control surface without a message that points here'
        }

        It 'the schema is the vendor URL rather than a copy of it' {
            $config = & $script:ReadConfig
            $config.'$schema' |
                Should -BeExactly 'https://opencode.ai/config.json' -Because 'an editor resolves the real schema from this URL; a vendored copy would keep passing while the tool moved on'
        }

        It 'every declared rule carries an action the tool understands' {
            $config = & $script:ReadConfig
            $offenders = foreach ($tool in $config.permission.PSObject.Properties) {
                foreach ($rule in $tool.Value.PSObject.Properties) {
                    if ($script:Actions -cnotcontains $rule.Value) {
                        "$($tool.Name) / $($rule.Name) = $($rule.Value)"
                    }
                }
            }
            ($offenders -join [Environment]::NewLine) |
                Should -BeNullOrEmpty -Because 'an action outside the enum is not a stricter rule, it is a rule the tool cannot resolve'
        }

        It 'no deprecated key is used' {
            $config = & $script:ReadConfig
            $config.PSObject.Properties.Name |
                Should -Not -Contain 'tools' -Because 'the boolean tools config was folded into permission in v1.1.1 and is only kept for backwards compatibility; a second spelling of the same control is a second thing to keep true'
        }
    }

    Context 'Rules that stay narrow' {
        It 'the catch-all precedes the specific rules it is meant to fall back from' {
            $config = & $script:ReadConfig
            $offenders = foreach ($map in (& $script:GetPermissionMaps $config)) {
                $names = @($map.Rules.PSObject.Properties.Name)
                $wildcard = $names.IndexOf('*')
                if ($wildcard -lt 0) { continue }
                $specific = @($names | Where-Object { $_.ToLowerInvariant() -cne '*' })
                if ($specific.Count -gt 0 -and $wildcard -ne 0) {
                    "$($map.Name): $($specific -join ', ')"
                }
            }
            ($offenders -join [Environment]::NewLine) |
                Should -BeNullOrEmpty -Because 'the last matching rule wins, so a specific rule written before the catch-all is dead text that reads as if it were enforced'
        }

        It 'no shell rule is a blanket deny' {
            $config = & $script:ReadConfig
            $offenders = @($config.permission.bash.PSObject.Properties |
                Where-Object { $_.Value -ceq 'deny' })
            $names = @($offenders | ForEach-Object { $_.Name })
            ($names -join [Environment]::NewLine) |
                Should -BeNullOrEmpty -Because 'a deny cannot be approved at the moment of the action, so it removes a capability the project still needs - and the catch-all is no exception, because a deny there takes git, pester and powershell with it; narrow rules ask, and only credential paths deny'
        }

        It 'every external path this repository blocks is a credential store' {
            $config = & $script:ReadConfig
            $blocked = @($config.permission.external_directory.PSObject.Properties)
            $blocked | Should -Not -BeNullOrEmpty -Because 'external_directory defaults to ask, so a credential store the project means to protect has to be named'
            $offenders = @($blocked | Where-Object {
                $_.Value -cne 'deny' -or $_.Name -cnotmatch '^~/\.[^/]+(?:/[^/]+)*/\*\*$'
            })
            $bad = @($offenders | ForEach-Object { "$($_.Name) = $($_.Value)" })
            ($bad -join [Environment]::NewLine) |
                Should -BeNullOrEmpty -Because 'the list is held to hidden home directories, which is what keeps it a list of credential and config stores; ~/Documents would read as protection and function as a denial of ordinary work, and a rule that asks instead of denies does not keep a key out of a session-wide approval'
        }
    }

    Context 'One source of truth' {
        It 'the verify command triggers the gate instead of restating it' {
            $config = & $script:ReadConfig
            $template = $config.command.verify.template
            $template | Should -BeLike '*Scripts/Invoke-CI.ps1*' -Because 'the gate is one command, and naming it is what makes the command a trigger rather than a second copy of the procedure'
            $template | Should -BeLike '*AGENTS.md*' -Because 'the procedure it follows is written down once, in the canonical file, and a command that spelled it out would drift from it silently'
            $restated = @('Invoke-Pester', 'ADMX-Validate', 'markdownlint', 'PSScriptAnalyzer', 'Verify-Mirror-Sync') |
                Where-Object { $template -clike "*$_*" }
            ($restated -join [Environment]::NewLine) |
                Should -BeNullOrEmpty -Because 'a command template that lists the checks is a second statement of what the gate contains, and it is the copy that goes stale first'
        }

        It 'the audit agent cannot modify a file' {
            $config = & $script:ReadConfig
            $config.agent.'policy-auditor'.permission.edit.'*' |
                Should -BeExactly 'deny' -Because 'an audit that can edit is an edit with extra steps; the value of this agent is that the Evaluate stage cannot quietly become a rewrite'
            $config.agent.'policy-auditor'.permission.bash.'*' |
                Should -BeExactly 'ask' -Because 'reading the repository is the job, and every command beyond a read-only git query is the operator''s call'
        }
    }
}