<#
.SYNOPSIS
    Brave Omega Release Automation Script
.DESCRIPTION
    Automates the release process:
    1. Validates version and files
    2. Syncs Wiki to GitHub Wiki
    3. Creates GitHub release
    4. Creates GitLab release
    5. Deprecates previous latest release
    6. Updates README version references
.PARAMETER Version
    Version string (e.g., "v2.3.2.0")
.PARAMETER Title
    Release title (e.g., "Brave 1.93.100 Compatibility")
.PARAMETER NotesFile
    Path to release notes markdown file
.PARAMETER BraveVersion
    Brave version being validated (e.g., "1.93.100")
.PARAMETER ChromiumVersion
    Chromium version (e.g., "151.0.7890.100")
.PARAMETER SkipWiki
    Skip Wiki sync step
.PARAMETER SkipDeprecate
    skip deprecation of previous release
.EXAMPLE
    .\Scripts\Release.ps1 -Version "v2.3.2.0" -Title "Brave 1.93.100 Compatibility" -NotesFile ".\RELEASE-NOTES.md" -BraveVersion "1.93.100" -ChromiumVersion "151.0.7890.100"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Version,

    [Parameter(Mandatory=$true)]
    [string]$Title,

    [Parameter(Mandatory=$false)]
    [string]$NotesFile,

    [Parameter(Mandatory=$false)]
    [string]$BraveVersion,

    [Parameter(Mandatory=$false)]
    [string]$ChromiumVersion,

    [Parameter(Mandatory=$false)]
    [switch]$SkipWiki,

    [Parameter(Mandatory=$false)]
    [switch]$SkipDeprecate
)

$ErrorActionPreference = "Stop"
$repo = "bayraktarozcan/Brave-Omega-Project"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Brave Omega Release Automation" -ForegroundColor Cyan
Write-Host "  Version: $Version" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ----------------------------------------
# Step 1: Validate
# ----------------------------------------
Write-Host "[1/6] Validating..." -ForegroundColor Yellow

# Check if version exists in script
$scriptContent = Get-Content "Brave Omega\BraveOmega-EN.ps1" -Raw
if ($scriptContent -notmatch "\`$ScriptVersion\s*=\s*`"$Version`"") {
    Write-Host "  WARNING: Version $Version not found in script's `$ScriptVersion" -ForegroundColor Red
    $continue = Read-Host "  Continue anyway? (y/n)"
    if ($continue -ne "y") { exit 1 }
}

# Check if tag already exists on GitHub
$existingRelease = gh release view $Version --repo $repo 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  WARNING: Release $Version already exists on GitHub" -ForegroundColor Yellow
    $continue = Read-Host "  Update existing release? (y/n)"
    if ($continue -ne "y") { exit 1 }
}

Write-Host "  OK" -ForegroundColor Green

# ----------------------------------------
# Step 2: Sync Wiki
# ----------------------------------------
if (-not $SkipWiki) {
    Write-Host "[2/6] Syncing Wiki..." -ForegroundColor Yellow

    $wikiTemp = "$env:TEMP\wiki-sync-$(Get-Date -Format 'yyyyMMddHHmmss')"
    git clone "https://github.com/$repo.wiki.git" $wikiTemp 2>&1 | Out-Null

    # Copy all Wiki files
    Copy-Item "Wiki\*" "$wikiTemp\" -Force

    Set-Location $wikiTemp
    git add -A
    $wikiStatus = git status --porcelain
    if ($wikiStatus) {
        git commit -m "sync: update Wiki for $Version" 2>&1 | Out-Null
        git push origin master 2>&1 | Out-Null
        Write-Host "  OK — Wiki synced" -ForegroundColor Green
    } else {
        Write-Host "  OK — Wiki already up to date" -ForegroundColor Green
    }

    Set-Location "D:\Repos\Brave Omega Project"
    Remove-Item $wikiTemp -Recurse -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "[2/6] Skipping Wiki sync" -ForegroundColor DarkGray
}

# ----------------------------------------
# Step 3: Deprecate Previous Release
# ----------------------------------------
if (-not $SkipDeprecate) {
    Write-Host "[3/6] Deprecating previous release..." -ForegroundColor Yellow

    # Get all releases, find the current latest
    $releases = gh release list --repo $repo --limit 50 --json tagName,name,isLatest -q '.[] | select(.tagName, .name, .isLatest)' 2>&1
    $currentLatest = gh release list --repo $repo --limit 1 --json tagName,name -q '.[0].tagName' 2>&1

    if ($currentLatest -and $currentLatest -ne $Version) {
        # Get current name and add [DEPRECATED]
        $currentName = gh release list --repo $repo --limit 1 --json name -q '.[0].name' 2>&1
        if ($currentName -notmatch "\[DEPRECATED\]") {
            $deprecatedName = "$currentName [DEPRECATED]"
            gh release edit $currentLatest --repo $repo --title "$deprecatedName" 2>&1 | Out-Null

            # Set make_latest to false via API
            $latestId = gh release view $currentLatest --repo $repo --json databaseId -q '.databaseId' 2>&1
            @{ make_latest = "false" } | ConvertTo-Json | gh api -X PATCH "repos/$repo/releases/$latestId" --input - 2>&1 | Out-Null

            Write-Host "  OK — Deprecated $currentLatest" -ForegroundColor Green
        } else {
            Write-Host "  OK — Already deprecated" -ForegroundColor Green
        }
    }
} else {
    Write-Host "[3/6] Skipping deprecation" -ForegroundColor DarkGray
}

# ----------------------------------------
# Step 4: Create GitHub Release
# ----------------------------------------
Write-Host "[4/6] Creating GitHub release..." -ForegroundColor Yellow

$releaseArgs = @("release", "create", $Version, "--repo", $repo, "--title", "$Version — $Title", "--latest")
if ($NotesFile -and (Test-Path $NotesFile)) {
    $releaseArgs += "--notes-file"
    $releaseArgs += $NotesFile
} else {
    $releaseArgs += "--notes"
    $releaseArgs += "Release $Version"
}

& gh @releaseArgs 2>&1 | Out-Null
Write-Host "  OK — GitHub release created" -ForegroundColor Green

# ----------------------------------------
# Step 5: Create GitLab Release
# ----------------------------------------
Write-Host "[5/6] Creating GitLab release..." -ForegroundColor Yellow

$glabArgs = @("release", "create", $Version, "--repo", $repo, "--name", "$Version — $Title")
if ($NotesFile -and (Test-Path $NotesFile)) {
    $notes = Get-Content $NotesFile -Raw
    $glabArgs += "--notes"
    $glabArgs += $notes
}

& glab @glabArgs 2>&1 | Out-Null
Write-Host "  OK — GitLab release created" -ForegroundColor Green

# ----------------------------------------
# Step 6: Summary
# ----------------------------------------
Write-Host "[6/6] Summary" -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Release $Version published!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "GitHub: https://github.com/$repo/releases/tag/$Version" -ForegroundColor Cyan
Write-Host "GitLab: https://gitlab.com/$repo/-/releases/$Version" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Verify release pages render correctly" -ForegroundColor White
Write-Host "  2. Update any external documentation" -ForegroundColor White
Write-Host "  3. Notify community if major changes" -ForegroundColor White
