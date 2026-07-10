<#
.SYNOPSIS
    Brave Omega Release Automation Script
.DESCRIPTION
    Automates the release process:
    1. Validates version and files
    2. Creates git tag if needed
    3. Syncs Wiki to GitHub Wiki
    4. Deprecates previous latest release
    5. Creates GitHub release
    6. Creates GitLab release
.PARAMETER Version
    Version string (e.g., "v2.3.2.0")
.PARAMETER Title
    Release title (e.g., "Brave 1.93.100 Compatibility")
.PARAMETER NotesFile
    Path to release notes markdown file
.PARAMETER SkipWiki
    Skip Wiki sync step
.PARAMETER SkipDeprecate
    Skip deprecation of previous release
.PARAMETER DryRun
    Show what would be done without making changes
.EXAMPLE
    .\scripts\Release.ps1 -Version "v2.4.0.0" -Title "Brave 1.93.100 Compatibility" -NotesFile ".\RELEASE-NOTES.md"
.EXAMPLE
    .\scripts\Release.ps1 -Version "v2.4.0.0" -Title "Brave 1.93.100" -DryRun
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Version,

    [Parameter(Mandatory=$true)]
    [string]$Title,

    [Parameter(Mandatory=$false)]
    [string]$NotesFile,

    [Parameter(Mandatory=$false)]
    [switch]$SkipWiki,

    [Parameter(Mandatory=$false)]
    [switch]$SkipDeprecate,

    [Parameter(Mandatory=$false)]
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$repo = "bayraktarozcan/Brave-Omega-Project"
$scriptDir = Split-Path -Parent $PSScriptRoot
if (-not $scriptDir) { $scriptDir = Get-Location }

# --- Helpers ---
function Write-Step {
    param([string]$Step, [string]$Message)
    Write-Host "[$Step] $Message" -ForegroundColor Yellow
}

function Write-OK {
    param([string]$Message)
    Write-Host "  OK: $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "  WARNING: $Message" -ForegroundColor Red
}

function Write-Skip {
    param([string]$Message)
    Write-Host "  SKIP: $Message" -ForegroundColor DarkGray
}

function Invoke-OrDie {
    param([string]$Description, [scriptblock]$Command)
    if ($DryRun) {
        Write-Host "  DRY-RUN: $Description" -ForegroundColor DarkYellow
        return $null
    }
    $result = & $Command
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $null) {
        throw "$Description failed with exit code $LASTEXITCODE"
    }
    return $result
}

# --- Banner ---
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Brave Omega Release Automation" -ForegroundColor Cyan
Write-Host "  Version: $Version" -ForegroundColor Cyan
if ($DryRun) { Write-Host "  MODE: DRY-RUN" -ForegroundColor DarkYellow }
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ----------------------------------------
# Step 1: Validate
# ----------------------------------------
Write-Step "1/6" "Validating..."

# Check version format
if ($Version -notmatch "^v\d+\.\d+\.\d+\.\d+$") {
    throw "Invalid version format: $Version (expected: vX.Y.Z.W)"
}

# Check if version exists in script
$scriptPath = Join-Path $scriptDir "Brave Omega\BraveOmega-EN.ps1"
if (Test-Path $scriptPath) {
    $scriptContent = Get-Content $scriptPath -Raw
    if ($scriptContent -notmatch "\`$ScriptVersion\s*=\s*`"$([regex]::Escape($Version))`"") {
        Write-Warn "Version $Version not found in script's `$ScriptVersion"
        if (-not $DryRun) {
            $continue = Read-Host "  Continue anyway? (y/n)"
            if ($continue -ne "y") { exit 1 }
        }
    }
} else {
    Write-Warn "Script file not found at $scriptPath"
}

Write-OK "Validation passed"

# ----------------------------------------
# Step 2: Create Tag (if needed)
# ----------------------------------------
Write-Step "2/6" "Checking git tag..."

$existingTag = git tag -l $Version 2>$null
if ($existingTag) {
    Write-OK "Tag $Version already exists"
} else {
    Write-Host "  Creating tag $Version..." -ForegroundColor White
    if (-not $DryRun) {
        git tag $Version
        git push origin $Version 2>&1
        if ($LASTEXITCODE -ne 0) { throw "Failed to push tag $Version" }
    }
    Write-OK "Tag $Version created and pushed"
}

# ----------------------------------------
# Step 3: Sync Wiki
# ----------------------------------------
if ($SkipWiki) {
    Write-Step "3/6" "Wiki sync skipped"
} else {
    Write-Step "3/6" "Syncing Wiki..."

    $wikiTemp = Join-Path $env:TEMP "wiki-sync-$([guid]::NewGuid().ToString('N').Substring(0,8))"
    $originalLocation = Get-Location

    try {
        # Clone wiki
        $wikiUrl = "https://github.com/$repo.wiki.git"
        Write-Host "  Cloning $wikiUrl..." -ForegroundColor White
        $cloneOutput = git clone $wikiUrl $wikiTemp 2>&1
        if ($LASTEXITCODE -ne 0) { throw "Failed to clone wiki: $cloneOutput" }

        # Copy files
        $wikiSource = Join-Path $scriptDir "Wiki\*"
        Copy-Item $wikiSource "$wikiTemp\" -Force

        # Check for changes
        Set-Location $wikiTemp
        git add -A | Out-Null
        $wikiStatus = git status --porcelain

        if ($wikiStatus) {
            if (-not $DryRun) {
                git commit -m "sync: update Wiki for $Version" 2>&1 | Out-Null
                $pushOutput = git push origin master 2>&1
                if ($LASTEXITCODE -ne 0) { throw "Failed to push wiki: $pushOutput" }
            }
            Write-OK "Wiki synced"
        } else {
            Write-OK "Wiki already up to date"
        }
    } finally {
        Set-Location $originalLocation
        if (Test-Path $wikiTemp) {
            Remove-Item $wikiTemp -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# ----------------------------------------
# Step 4: Deprecate Previous Release
# ----------------------------------------
if ($SkipDeprecate) {
    Write-Step "4/6" "Deprecation skipped"
} else {
    Write-Step "4/6" "Deprecating previous release..."

    # Find current latest release
    $latestJson = gh release list --repo $repo --limit 10 --json tagName,name,isLatest,isDraft 2>&1
    if ($LASTEXITCODE -eq 0) {
        $releases = $latestJson | ConvertFrom-Json
        $currentLatest = $releases | Where-Object { $_.isLatest -eq $true } | Select-Object -First 1

        if (-not $currentLatest) {
            # Fallback: first non-draft release
            $currentLatest = $releases | Where-Object { $_.isDraft -ne $true } | Select-Object -First 1
        }

        if ($currentLatest -and $currentLatest.tagName -ne $Version) {
            if ($currentLatest.name -notmatch "\[DEPRECATED\]") {
                $deprecatedName = "$($currentLatest.name) [DEPRECATED]"

                if (-not $DryRun) {
                    # Update title
                    gh release edit $currentLatest.tagName --repo $repo --title "$deprecatedName" 2>&1 | Out-Null

                    # Set make_latest to false
                    $releaseId = gh release view $currentLatest.tagName --repo $repo --json databaseId -q '.databaseId' 2>&1
                    if ($releaseId) {
                        @{ make_latest = "false" } | ConvertTo-Json | gh api -X PATCH "repos/$repo/releases/$releaseId" --input - 2>&1 | Out-Null
                    }
                }
                Write-OK "Deprecated $($currentLatest.tagName)"
            } else {
                Write-OK "Already deprecated: $($currentLatest.tagName)"
            }
        } else {
            Write-OK "No previous release to deprecate"
        }
    }
}

# ----------------------------------------
# Step 5: Create GitHub Release
# ----------------------------------------
Write-Step "5/6" "Creating GitHub release..."

$ghArgs = @("release", "create", $Version, "--repo", $repo, "--title", "$Version - $Title", "--latest")
if ($NotesFile -and (Test-Path $NotesFile)) {
    $ghArgs += "--notes-file"
    $ghArgs += (Resolve-Path $NotesFile).Path
} else {
    $ghArgs += "--notes"
    $ghArgs += "Release $Version — see [CHANGELOG](https://github.com/$repo/blob/main/CHANGELOG.md) for details."
}

if (-not $DryRun) {
    $createOutput = & gh @ghArgs 2>&1
    if ($LASTEXITCODE -ne 0) { throw "Failed to create GitHub release: $createOutput" }
}
Write-OK "GitHub release created: https://github.com/$repo/releases/tag/$Version"

# ----------------------------------------
# Step 6: Create GitLab Release
# ----------------------------------------
Write-Step "6/6" "Creating GitLab release..."

$glabArgs = @("release", "create", $Version, "--repo", $repo, "--name", "$Version - $Title")
if ($NotesFile -and (Test-Path $NotesFile)) {
    $notes = Get-Content $NotesFile -Raw
    $glabArgs += "--notes"
    $glabArgs += $notes
}

if (-not $DryRun) {
    $glabOutput = & glab @glabArgs 2>&1
    if ($LASTEXITCODE -ne 0) { throw "Failed to create GitLab release: $glabOutput" }
}
Write-OK "GitLab release created: https://gitlab.com/$repo/-/releases/$Version"

# ----------------------------------------
# Summary
# ----------------------------------------
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
if ($DryRun) {
    Write-Host "  DRY-RUN Complete — no changes made" -ForegroundColor DarkYellow
} else {
    Write-Host "  Release $Version published!" -ForegroundColor Green
}
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "GitHub: https://github.com/$repo/releases/tag/$Version" -ForegroundColor Cyan
Write-Host "GitLab: https://gitlab.com/$repo/-/releases/$Version" -ForegroundColor Cyan
