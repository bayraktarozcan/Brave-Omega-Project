# Invariant: a transient artifact-metadata failure cannot leave Pages red.
# The workflow retries once after a pause and fails only if both attempts lose.
BeforeAll {
    $script:RepoRoot = Split-Path -Parent $PSScriptRoot
    $script:Workflow = Join-Path $script:RepoRoot '.github\workflows\pages.yml'
}

Describe 'Pages deployment' -Tag 'Unit' {
    It 'retries the deploy step and asserts the final outcome' {
        $text = Get-Content -LiteralPath $script:Workflow -Raw
        $text | Should -Match 'uses: actions/deploy-pages@main'
        ([regex]::Matches($text, 'uses: actions/deploy-pages@main')).Count | Should -Be 2
        $text | Should -Match 'continue-on-error: true'
        $text | Should -Match "steps\.deployment\.outcome == 'failure'"
        $text | Should -Match 'sleep 20'
        $text | Should -Match 'both Pages deployment attempts failed'
        $text | Should -Match 'steps\.retry\.outputs\.page_url \|\| steps\.deployment\.outputs\.page_url'
    }
}
