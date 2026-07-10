<#
.SYNOPSIS
    Quick Wiki sync to GitHub Wiki
.DESCRIPTION
    Copies Wiki/ directory to GitHub Wiki repo and pushes changes.
    Returns to original directory on success or failure.
.PARAMETER DryRun
    Show what would be done without making changes
.EXAMPLE
    .\scripts\Wiki-Sync.ps1
.EXAMPLE
    .\scripts\Wiki-Sync.ps1 -DryRun
#>

param(
    [Parameter(Mandatory=$false)]
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$repo = "bayraktarozcan/Brave-Omega-Project"
$originalLocation = Get-Location

Write-Host "Syncing Wiki to GitHub..." -ForegroundColor Yellow
if ($DryRun) { Write-Host "  MODE: DRY-RUN" -ForegroundColor DarkYellow }

$wikiTemp = Join-Path $env:TEMP "wiki-sync-$([guid]::NewGuid().ToString('N').Substring(0,8))"

try {
    # Clone wiki
    $wikiUrl = "https://github.com/$repo.wiki.git"
    Write-Host "  Cloning $wikiUrl..." -ForegroundColor White
    $cloneOutput = git clone $wikiUrl $wikiTemp 2>&1
    if ($LASTEXITCODE -ne 0) { throw "Failed to clone wiki: $cloneOutput" }

    # Copy files
    $wikiSource = Join-Path (Split-Path -Parent $PSScriptRoot) "Wiki\*"
    if (-not (Test-Path $wikiSource)) {
        # Fallback: try from current directory
        $wikiSource = Join-Path $originalLocation "Wiki\*"
    }
    Copy-Item $wikiSource "$wikiTemp\" -Force

    # Check for changes
    Set-Location $wikiTemp
    git add -A | Out-Null
    $wikiStatus = git status --porcelain

    if ($wikiStatus) {
        if (-not $DryRun) {
            git commit -m "sync: update Wiki $(Get-Date -Format 'yyyy-MM-dd')" 2>&1 | Out-Null
            $pushOutput = git push origin master 2>&1
            if ($LASTEXITCODE -ne 0) { throw "Failed to push wiki: $pushOutput" }
        }
        Write-Host "  Wiki synced successfully!" -ForegroundColor Green
    } else {
        Write-Host "  Wiki already up to date." -ForegroundColor Green
    }
} catch {
    Write-Host "  ERROR: $_" -ForegroundColor Red
    exit 1
} finally {
    Set-Location $originalLocation
    if (Test-Path $wikiTemp) {
        Remove-Item $wikiTemp -Recurse -Force -ErrorAction SilentlyContinue
    }
}
