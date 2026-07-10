<#
.SYNOPSIS
    Quick Wiki sync to GitHub Wiki
.DESCRIPTION
    Copies Wiki/ directory to GitHub Wiki repo and pushes changes.
.EXAMPLE
    .\Scripts\Wiki-Sync.ps1
#>

param()

$ErrorActionPreference = "Stop"
$repo = "bayraktarozcan/Brave-Omega-Project"

Write-Host "Syncing Wiki to GitHub..." -ForegroundColor Yellow

$wikiTemp = "$env:TEMP\wiki-sync-$(Get-Date -Format 'yyyyMMddHHmmss')"
git clone "https://github.com/$repo.wiki.git" $wikiTemp 2>&1 | Out-Null

Copy-Item "Wiki\*" "$wikiTemp\" -Force

Set-Location $wikiTemp
git add -A
$wikiStatus = git status --porcelain

if ($wikiStatus) {
    git commit -m "sync: update Wiki $(Get-Date -Format 'yyyy-MM-dd')" 2>&1 | Out-Null
    git push origin master 2>&1 | Out-Null
    Write-Host "Wiki synced successfully!" -ForegroundColor Green
} else {
    Write-Host "Wiki already up to date." -ForegroundColor Green
}

Set-Location "D:\Repos\Brave Omega Project"
Remove-Item $wikiTemp -Recurse -Force -ErrorAction SilentlyContinue
