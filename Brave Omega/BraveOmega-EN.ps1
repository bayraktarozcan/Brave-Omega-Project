# ==============================================================================
# ==============================================================================
#
#                   BRAVE OMEGA PROJECT (Community Edition)
#
# ==============================================================================
# ==============================================================================
# VERSION CONTEXT  : Windows 11 25H2 (Build 26200.8524)
#                    Brave 1.91.175 — Official Build / Chromium 149.0.7827.155
# FILE TYPE        : Advanced Multi-Tier Browser Hardening Script (.ps1)
# PURPOSE          : Protect user privacy, prevent data leaks, strip the
#                    browser of unnecessary services. Supports 4 hardening
#                    tiers: Brave Only, Essential, Balanced, Strict.
#
# !! CHANNEL WARNING !!
#    Brave 1.91.175, dated June 18, 2026, belongs to the Stable channel.
#    The stable branch is always recommended for enterprise deployment.
#    ADMX policy behaviors might not be fully tested in Beta/Nightly releases.
#
# CHANGELOG (v2.1)
# ─────────────────────────────────────────────────────────────────────────────
#   v2.1                 Feature expansion — Version check, -WhatIf, -Reset:
#
#     [NEW]        Automated Brave version detection.
#                   Warns when installed Brave differs from validated version.
#
#     [NEW]        -WhatIf parameter (standard PowerShell semantics).
#                   Preview all changes without writing to the registry.
#
#     [NEW]        -Reset parameter.
#                   Removes all Brave Omega policies across HKCU, HKLM, and
#                   Omaha GUID — clean uninstall in one command.
#
#     [IMPROVED]    Write-PolicyValue now accepts -WhatIf for preview mode.
#                   Backup and directory steps skipped in -WhatIf mode.
#
#   v2.0                 Complete architectural overhaul — Multi-Tier System:
#
#     [NEW]        4-Tier hardening model:
#                     Brave Only → Essential → Balanced → Strict
#                     Each level cumulatively includes all policies below it.
#
#     [NEW]        Multi-type registry support:
#                     - DWord      (REG_DWORD)   for boolean/integer policies
#                     - String     (REG_SZ)      for string-enum policies
#                     - MultiString (REG_MULTI_SZ) for list-type policies
#
#     [NEW]        Interactive level selection when run without parameters.
#                   -Level parameter for silent/automated deployment.
#
#     [NEW]        50+ Chromium enterprise policies added across all tiers.
#                   Brave Only: 13 Brave-specific policies
#                   Essential:  +16 data-leak prevention policies
#                   Balanced:   +18 security & convenience balance
#                   Strict:     +21 maximum privacy policies
#
#     [IMPROVED]    Registry writing engine now dispatches by type and
#                   produces a comprehensive per-policy audit trail.
#
#     All v1.x fixes (process control, backup, try-catch, exit codes, GUID
#     resolution, UAC check) are preserved and enhanced.
# ==============================================================================

# ─────────────────────────────────────────────────────────────────────────────
# PARAMETERS
# ─────────────────────────────────────────────────────────────────────────────
param(
    [string]$Level = "",
    [switch]$WhatIf,
    [switch]$Reset
)

# ─────────────────────────────────────────────────────────────────────────────
# SCRIPT VERSION CONSTANTS
# ─────────────────────────────────────────────────────────────────────────────
$ScriptVersion   = "v2.1.2"
$ValidatedBrave  = "1.91.175"
$ValidatedChromium = "149"

# ─────────────────────────────────────────────────────────────────────────────
# TERMINAL ENCODING HARDENING (CHARACTER ERROR RESOLUTION)
# ─────────────────────────────────────────────────────────────────────────────
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding           = [System.Text.Encoding]::UTF8

# ─────────────────────────────────────────────────────────────────────────────
# BRAVE VERSION DETECTION
# ─────────────────────────────────────────────────────────────────────────────
function Get-BraveVersion {
    $paths = @(
        "${env:ProgramFiles}\BraveSoftware\Brave-Browser\Application\brave.exe",
        "${env:ProgramFiles(x86)}\BraveSoftware\Brave-Browser\Application\brave.exe",
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\Application\brave.exe"
    )
    foreach ($path in $paths) {
        if (Test-Path $path) {
            try {
                $verInfo = (Get-Item $path).VersionInfo
                $fileVer = $verInfo.FileVersion
                if ($fileVer) {
                    $parts = $fileVer.Split('.')
                    if ($parts.Count -lt 4) { continue }
                    return @{
                        Path          = $path
                        BraveVersion  = "$($parts[1]).$($parts[2]).$($parts[3])"
                        ChromiumMajor = $parts[0]
                    }
                }
            } catch { continue }
        }
    }
    return $null
}

# ─────────────────────────────────────────────────────────────────────────────
# STEP 0A: USER ACCOUNT CONTROL (UAC) AND ADMINISTRATOR PRIVILEGE VERIFICATION
# ─────────────────────────────────────────────────────────────────────────────
$CurrentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$UserRole = New-Object Security.Principal.WindowsPrincipal($CurrentIdentity)
$IsAdmin = $UserRole.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Error "CRITICAL ERROR: This script must be run as 'Administrator' to seal enterprise policies in the HKLM (Local Machine) hive!"
    exit 1
}

Clear-Host
Write-Host "=== BRAVE OMEGA PROJECT $ScriptVersion — MULTI-TIER HARDENING SCRIPT ===" -ForegroundColor Cyan
Write-Host "Target Platform : Windows 11 25H2 / Chromium $ValidatedChromium (Brave $ValidatedBrave)" -ForegroundColor Gray
Write-Host "Execution Time  : $(Get-Date -Format 'dd-MM-yyyy HH:mm:ss')`n" -ForegroundColor Gray


# ─────────────────────────────────────────────────────────────────────────────
# STEP 0B: VERSION CHECK
# ─────────────────────────────────────────────────────────────────────────────
$braveInfo = Get-BraveVersion
$versionsMatch = $false

if ($braveInfo) {
    $braveMatch  = $braveInfo.BraveVersion  -eq $ValidatedBrave
    $chromeMatch = $braveInfo.ChromiumMajor -eq $ValidatedChromium
    $versionsMatch = $braveMatch -and $chromeMatch

    if (-not $versionsMatch) {
        Write-Host "[VERSION CHECK] Version mismatch detected!" -ForegroundColor Yellow
        Write-Host "  Path: $($braveInfo.Path)" -ForegroundColor DarkGray
        Write-Host "  Detected: Brave $($braveInfo.BraveVersion) / Chromium $($braveInfo.ChromiumMajor)" -ForegroundColor Yellow
        Write-Host "  Expected: Brave $ValidatedBrave / Chromium $ValidatedChromium" -ForegroundColor Yellow
        Write-Host "  Some policies may not be recognized by this browser version." -ForegroundColor Yellow
        Write-Host "  Continue? (Y = Yes / N = No): " -ForegroundColor White -NoNewline
        $cont = Read-Host
        if ($cont -notin @("Y", "y", "Yes", "yes")) {
            Write-Host "Operation cancelled by the user." -ForegroundColor DarkGray
            exit 0
        }
    } else {
        Write-Host "[VERSION CHECK] Brave $ValidatedBrave / Chromium $ValidatedChromium detected — versions match validation target.`n" -ForegroundColor DarkGreen
    }
} else {
    Write-Host "[VERSION CHECK] Could not detect Brave installation path." -ForegroundColor Yellow
    Write-Host "  Proceeding — but verify compatibility at brave://settings/help`n" -ForegroundColor DarkGray
}


# ─────────────────────────────────────────────────────────────────────────────
# STEP 0C: RESET MODE
# ─────────────────────────────────────────────────────────────────────────────
$HKCU_Target = "HKCU:\Software\BraveSoftware\Brave-Browser"
$HKLM_Target = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

if ($Reset) {
    Write-Host "[RESET MODE] Removing all Brave Omega policies..." -ForegroundColor Magenta
    Write-Host ""

    # All known policy names across all levels (hardcoded for safety before definitions load)
    $allPolicyNames = @(
        "UsageStatsInSample", "ChromeVariations",
        "BraveRewardsDisabled", "BraveWalletDisabled", "BraveVPNDisabled",
        "BraveAIChatEnabled", "BraveTalkDisabled", "BraveNewsDisabled",
        "BravePlaylistEnabled", "BraveSpeedreaderEnabled", "BraveWaybackMachineEnabled",
        "BraveP3AEnabled", "BraveStatsPingEnabled", "BraveWebDiscoveryEnabled", "TorDisabled",
        "MetricsReportingEnabled", "SafeBrowsingExtendedReportingEnabled",
        "UrlKeyedAnonymizedDataCollectionEnabled", "SearchSuggestEnabled",
        "NetworkPredictionOptions", "TranslateEnabled", "SpellcheckEnabled",
        "AlternateErrorPagesEnabled", "BrowserNetworkTimeQueriesEnabled",
        "DomainReliabilityAllowed", "BackgroundModeEnabled", "SafeBrowsingSurveysEnabled",
        "SafeBrowsingDeepScanningEnabled", "WebRtcEventLogCollectionAllowed",
        "WebRtcTextLogCollectionAllowed", "AudioCaptureAllowed", "VideoCaptureAllowed",
        "WebRtcIPHandling", "WebRtcLocalIpsAllowedUrls", "HttpsOnlyMode", "DnsOverHttpsMode",
        "BlockThirdPartyCookies", "PasswordManagerEnabled", "PasswordManagerPasskeysEnabled",
        "AutofillAddressEnabled", "AutofillCreditCardEnabled", "ShowFullUrlsInAddressBar",
        "DisableSafeBrowsingProceedAnyway", "QuicAllowed", "ChromeVariations",
        "NetworkServiceSandboxEnabled", "AudioSandboxEnabled",
        "DefaultGeolocationSetting", "DefaultNotificationsSetting", "DefaultPopupsSetting",
        "DefaultMediaStreamSetting",
        "DefaultSensorsSetting", "DefaultLocalFontsSetting", "DefaultClipboardSetting",
        "DefaultFileSystemReadGuardSetting", "DefaultFileSystemWriteGuardSetting",
        "DefaultSerialGuardSetting", "DefaultIdleDetectionSetting",
        "DefaultInsecureContentSetting", "DefaultJavaScriptJitSetting", "DefaultCookiesSetting",
        "BrowserGuestModeEnabled", "BrowserAddPersonEnabled", "CloudPrintProxyEnabled",
        "ImportAutofillFormData", "ImportBookmarks", "ImportHistory",
        "ImportSavedPasswords", "ImportSearchEngine", "ImportHomepage"
    )

    # Remove from HKLM
    $hkCount = 0
    if (Test-Path $HKLM_Target) {
        foreach ($name in $allPolicyNames) {
            try {
                if (-not $WhatIf) {
                    Remove-ItemProperty -Path $HKLM_Target -Name $name -ErrorAction SilentlyContinue
                }
                $hkCount++
                Write-Host "  [OK] HKLM\$name removed" -ForegroundColor $(if ($WhatIf) { "Magenta" } else { "DarkGreen" })
            } catch { }
        }
    }

    # Remove from HKCU
    $hcCount = 0
    if (Test-Path $HKCU_Target) {
        foreach ($name in @("UsageStatsInSample", "ChromeVariations")) {
            try {
                if (-not $WhatIf) {
                    Remove-ItemProperty -Path $HKCU_Target -Name $name -ErrorAction SilentlyContinue
                }
                $hcCount++
                Write-Host "  [OK] HKCU\$name removed" -ForegroundColor $(if ($WhatIf) { "Magenta" } else { "DarkGreen" })
            } catch { }
        }
    }

    # Remove Omaha usagestats from GUIDs
    $omahaCount = 0
    $rootPath = "HKCU:\Software\BraveSoftware"
    if (Test-Path "$rootPath\Update\ClientState") {
        $guids = Get-ChildItem -Path "$rootPath\Update\ClientState" -Recurse -ErrorAction SilentlyContinue |
            Select-Object -ExpandProperty Name |
            ForEach-Object { $_ -replace "HKEY_CURRENT_USER", "HKCU:" } |
            Where-Object { $_ -match "\\\{[a-fA-F0-9-]+\}$" }
        foreach ($guidPath in $guids) {
            try {
                if (-not $WhatIf) {
                    Remove-ItemProperty -Path $guidPath -Name "usagestats" -ErrorAction SilentlyContinue
                }
                $omahaCount++
                Write-Host "  [OK] Omaha GUID: usagestats removed" -ForegroundColor $(if ($WhatIf) { "Magenta" } else { "DarkGreen" })
            } catch { }
        }
    }

    # Optionally remove empty HKLM key
    $hkPolicies = Get-ItemProperty -Path $HKLM_Target -ErrorAction SilentlyContinue
    $hkRealProperties = @($hkPolicies.PSObject.Properties | Where-Object { $_.Name -notin @('PSPath','PSParentPath','PSChildName','PSDrive','PSProvider') })
    if ($hkPolicies -and $hkRealProperties.Count -eq 0) {
        try {
            if (-not $WhatIf) {
                Remove-Item -Path $HKLM_Target -Force -ErrorAction SilentlyContinue
            }
            Write-Host "  [OK] HKLM policy key removed (no policies remain)" -ForegroundColor $(if ($WhatIf) { "Magenta" } else { "DarkGreen" })
        } catch { }
    }

    Write-Host "`n[RESET COMPLETE] HKLM: $hkCount / HKCU: $hcCount / Omaha: $omahaCount entries removed." -ForegroundColor Cyan
    Write-Host "  Close Brave and reopen for changes to take effect.`n" -ForegroundColor White
    exit 0
}


# ─────────────────────────────────────────────────────────────────────────────
# STEP 0D: LEVEL SELECTION
# ─────────────────────────────────────────────────────────────────────────────
$ValidLevels = @("BraveOnly", "Essential", "Balanced", "Strict", "Brave Yalnız", "Temel", "Dengeli", "Katı")

if (-not $Level -or $Level -eq "") {
    Write-Host "Select a hardening level:" -ForegroundColor White
    Write-Host "  1. Brave Only" -ForegroundColor Gray
    Write-Host "  2. Essential  [Recommended]" -ForegroundColor Green
    Write-Host "  3. Balanced" -ForegroundColor Yellow
    Write-Host "  4. Strict" -ForegroundColor Red
    Write-Host ""
    $Choice = Read-Host "Enter choice (1-4)"

    $Level = switch ($Choice) {
        "1" { "BraveOnly" }
        "2" { "Essential" }
        "3" { "Balanced" }
        "4" { "Strict" }
        default { "Essential" }
    }
}

# Map Turkish names to English
$LevelMap = @{
    "Brave Yalnız" = "BraveOnly"
    "Temel"        = "Essential"
    "Dengeli"      = "Balanced"
    "Katı"         = "Strict"
}
if ($LevelMap.ContainsKey($Level)) {
    $Level = $LevelMap[$Level]
}

# Validate
if ($ValidLevels -notcontains $Level -and $LevelMap.Values -notcontains $Level) {
    Write-Host "Invalid level '$Level'. Falling back to Essential." -ForegroundColor Yellow
    $Level = "Essential"
}

# Ensure English internal name
if ($Level -eq "Brave Yalnız") { $Level = "BraveOnly" }
if ($Level -eq "Temel")        { $Level = "Essential"  }
if ($Level -eq "Dengeli")      { $Level = "Balanced"   }
if ($Level -eq "Katı")         { $Level = "Strict"     }

if ($WhatIf) {
    Write-Host "Mode: -WhatIf (preview only — no registry changes will be made)" -ForegroundColor Magenta
}
Write-Host "Selected Level: $Level" -ForegroundColor Cyan
Write-Host ""


# ─────────────────────────────────────────────────────────────────────────────
# STEP 0C: BRAVE PROCESS CONTROL
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[CHECK] Inspecting Active Brave Processes..." -ForegroundColor Gray

$BraveProcesses = Get-Process -Name "brave" -ErrorAction SilentlyContinue

if ($BraveProcesses) {
    $ProcessCount = $BraveProcesses.Count
    Write-Host "  [WARNING] $ProcessCount Brave process(es) are currently running." -ForegroundColor Yellow
    Write-Host "  Some HKCU modifications may be overwritten while the browser is open." -ForegroundColor Yellow
    Write-Host "  It is recommended to close Brave and re-run the script.`n" -ForegroundColor Yellow
    Write-Host "  Do you want to continue? (Y = Yes / N = No): " -ForegroundColor White -NoNewline
    $DecisionInput = Read-Host

    if ($DecisionInput -notin @("Y", "y", "Yes", "yes")) {
        Write-Host "`n  Operation cancelled by the user. Please close Brave and try again." -ForegroundColor DarkGray
        exit 0
    }
    Write-Host ""
} else {
    Write-Host "  -> Clean: No running Brave processes detected.`n" -ForegroundColor DarkGreen
}


# ─────────────────────────────────────────────────────────────────────────────
# PATH CONSTANTS
# ─────────────────────────────────────────────────────────────────────────────
$HKCU_Target = "HKCU:\Software\BraveSoftware\Brave-Browser"
$HKLM_Target = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"


# ─────────────────────────────────────────────────────────────────────────────
# LEVEL POLICY DEFINITIONS
# ─────────────────────────────────────────────────────────────────────────────
# Each policy: @{Name=""; Value=; Type="DWord|String|MultiString"}
# Levels are cumulative: each level includes all policies from previous levels.

$PolicyDefinitions = @{
    "BraveOnly" = @(
        # Brave Rewards — disables integrated ad network, BAT tokens, and rewards
        @{Name="BraveRewardsDisabled";                 Value=1; Type="DWord"}
        # Brave Wallet — disables crypto wallet, Web3, and decentralized DNS
        @{Name="BraveWalletDisabled";                  Value=1; Type="DWord"}
        # Brave VPN — removes VPN button and blocks background VPN service
        @{Name="BraveVPNDisabled";                     Value=1; Type="DWord"}
        # Leo AI Chat — disables the built-in AI assistant in sidebar
        @{Name="BraveAIChatEnabled";                   Value=0; Type="DWord"}
        # Brave Talk — disables built-in video conferencing tool
        @{Name="BraveTalkDisabled";                    Value=1; Type="DWord"}
        # Brave News — disables news feed on New Tab Page
        @{Name="BraveNewsDisabled";                    Value=1; Type="DWord"}
        # Brave Playlist — disables offline video/audio saving feature
        @{Name="BravePlaylistEnabled";                 Value=0; Type="DWord"}
        # Speedreader — disables reader mode suggestion on article pages
        @{Name="BraveSpeedreaderEnabled";              Value=0; Type="DWord"}
        # Wayback Machine — disables Internet Archive integration for 404 pages
        @{Name="BraveWaybackMachineEnabled";           Value=0; Type="DWord"}
        # P3A — disables Privacy-Preserving Product Analytics data transmission
        @{Name="BraveP3AEnabled";                      Value=0; Type="DWord"}
        # Stats Ping — disables status/authentication ping requests to Brave
        @{Name="BraveStatsPingEnabled";                Value=0; Type="DWord"}
        # Web Discovery Project — disables anonymous search index contribution
        @{Name="BraveWebDiscoveryEnabled";             Value=0; Type="DWord"}
        # Tor — disables New Private Window with Tor integration
        @{Name="TorDisabled";                          Value=1; Type="DWord"}
    )

    "Essential" = @(
        # ─── Data Leak Prevention (zero usability impact) ───

        # Chromium metrics master switch — stops usage/crash data to Google/Brave
        @{Name="MetricsReportingEnabled";              Value=0; Type="DWord"}
        # Safe Browsing extended reporting — stops sending page content to Google
        @{Name="SafeBrowsingExtendedReportingEnabled"; Value=0; Type="DWord"}
        # URL-keyed data collection — stops sending visited URLs to Google
        @{Name="UrlKeyedAnonymizedDataCollectionEnabled"; Value=0; Type="DWord"}
        # Search suggestions — stops keystroke data from leaving the device
        @{Name="SearchSuggestEnabled";                 Value=0; Type="DWord"}
        # Network prediction — stops DNS prefetching and pre-connection
        @{Name="NetworkPredictionOptions";             Value=2; Type="DWord"}
        # Spellcheck — disables spellcheck (stops sending text to Google servers)
        @{Name="SpellcheckEnabled";                    Value=0; Type="DWord"}
        # Alternate error pages — stops network requests when DNS resolution fails
        @{Name="AlternateErrorPagesEnabled";           Value=0; Type="DWord"}
        # Network time queries — stops time synchronization requests to Google
        @{Name="BrowserNetworkTimeQueriesEnabled";     Value=0; Type="DWord"}
        # Domain reliability — stops diagnostic data reporting to Google
        @{Name="DomainReliabilityAllowed";             Value=0; Type="DWord"}
        # Background mode — prevents Brave from running when all windows closed
        @{Name="BackgroundModeEnabled";                Value=0; Type="DWord"}
        # Safe Browsing surveys — disables post-browsing surveys
        @{Name="SafeBrowsingSurveysEnabled";           Value=0; Type="DWord"}
        # Safe Browsing deep scanning — disables server-side download scanning
        @{Name="SafeBrowsingDeepScanningEnabled";      Value=0; Type="DWord"}
        # WebRTC event log — stops WebRTC event log upload to Google
        @{Name="WebRtcEventLogCollectionAllowed";     Value=0; Type="DWord"}
        # WebRTC text log — stops WebRTC text log upload to Google
        @{Name="WebRtcTextLogCollectionAllowed";      Value=0; Type="DWord"}
        # Audio capture — blocks microphone access by default (can be per-site)
        @{Name="AudioCaptureAllowed";                  Value=0; Type="DWord"}
        # Video capture — blocks camera access by default (can be per-site)
        @{Name="VideoCaptureAllowed";                  Value=0; Type="DWord"}
    )

    "Balanced" = @(
        # ─── Security & Convenience Balance ───

        # WebRTC IP handling — exposes only public IP, hides local IPs from WebRTC
        @{Name="WebRtcIPHandling";                     Value="default_public_interface_only"; Type="String"}
        # WebRTC local IPs — empty list prevents any URL from getting local IP via ICE
        @{Name="WebRtcLocalIpsAllowedUrls";            Value=@(); Type="MultiString"}
        # HTTPS-Only Mode — forces all navigations to use HTTPS
        @{Name="HttpsOnlyMode";                        Value="force_enabled"; Type="String"}
        # DNS-over-HTTPS — upgrades DNS to encrypted queries automatically
        @{Name="DnsOverHttpsMode";                     Value="automatic"; Type="String"}
        # Third-party cookies — blocks cross-site tracking cookies
        @{Name="BlockThirdPartyCookies";               Value=1; Type="DWord"}
        # Password manager — disables built-in password saving
        @{Name="PasswordManagerEnabled";               Value=0; Type="DWord"}
        # Passkeys — disables passkey saving in the browser
        @{Name="PasswordManagerPasskeysEnabled";       Value=0; Type="DWord"}
        # Address autofill — disables address form autofill data storage
        @{Name="AutofillAddressEnabled";               Value=0; Type="DWord"}
        # Credit card autofill — disables payment method autofill data storage
        @{Name="AutofillCreditCardEnabled";            Value=0; Type="DWord"}
        # Full URLs — shows full URL including scheme and subdomain (anti-phishing)
        @{Name="ShowFullUrlsInAddressBar";             Value=1; Type="DWord"}
        # Safe Browsing proceed — prevents bypassing malware/phishing warnings
        @{Name="DisableSafeBrowsingProceedAnyway";     Value=1; Type="DWord"}
        # QUIC protocol — disables QUIC, falls back to TCP/TLS
        @{Name="QuicAllowed";                          Value=0; Type="DWord"}
        # Chrome variations — restricts to critical field trials only
        @{Name="ChromeVariations";                     Value=1; Type="DWord"}
        # Network service sandbox — runs network service in sandboxed process
        @{Name="NetworkServiceSandboxEnabled";         Value=1; Type="DWord"}
        # Audio sandbox — runs audio service in sandboxed process
        @{Name="AudioSandboxEnabled";                  Value=1; Type="DWord"}
        # Geolocation — blocks site access to device location by default
        @{Name="DefaultGeolocationSetting";            Value=2; Type="DWord"}
        # Notifications — blocks site notification requests by default
        @{Name="DefaultNotificationsSetting";          Value=2; Type="DWord"}
        # Pop-ups — blocks pop-up windows by default
        @{Name="DefaultPopupsSetting";                 Value=2; Type="DWord"}
    )

    "Strict" = @(
        # ─── Maximum Privacy — some usability trade-offs ───

        # Translation — disables built-in translation (stops sending text to Google)
        @{Name="TranslateEnabled";                     Value=0; Type="DWord"}
        # WebRTC IP handling — overrides Balanced: proxies all WebRTC traffic
        @{Name="WebRtcIPHandling";                     Value="disable_non_proxied_udp"; Type="String"}
        # Sensors — blocks device motion/light sensor access by default
        @{Name="DefaultSensorsSetting";                Value=2; Type="DWord"}
        # Local fonts — blocks font enumeration (reduces fingerprinting surface)
        @{Name="DefaultLocalFontsSetting";             Value=2; Type="DWord"}
        # Clipboard — blocks site clipboard read/write access by default
        @{Name="DefaultClipboardSetting";              Value=2; Type="DWord"}
        # File system read — blocks site file system read access by default
        @{Name="DefaultFileSystemReadGuardSetting";    Value=2; Type="DWord"}
        # File system write — blocks site file system write access by default
        @{Name="DefaultFileSystemWriteGuardSetting";   Value=2; Type="DWord"}
        # Serial ports — blocks Serial API access by default
        @{Name="DefaultSerialGuardSetting";            Value=2; Type="DWord"}
        # Idle detection — blocks site access to user idle state by default
        @{Name="DefaultIdleDetectionSetting";          Value=2; Type="DWord"}
        # Insecure content — blocks mixed content (HTTP on HTTPS pages) by default
        @{Name="DefaultInsecureContentSetting";        Value=2; Type="DWord"}
        # JavaScript JIT — disables JIT compilation (reduces attack surface)
        @{Name="DefaultJavaScriptJitSetting";          Value=2; Type="DWord"}
        # Cookies — blocks all cookies by default (may break login-dependent sites)
        @{Name="DefaultCookiesSetting";                Value=2; Type="DWord"}
        # Guest mode — prevents browser guest profile creation
        @{Name="BrowserGuestModeEnabled";              Value=0; Type="DWord"}
        # Add person — prevents new profile creation from user manager
        @{Name="BrowserAddPersonEnabled";              Value=0; Type="DWord"}
        # Cloud Print — disables Google Cloud Print proxy
        @{Name="CloudPrintProxyEnabled";               Value=0; Type="DWord"}
        # Import autofill — disables importing autofill data from other browsers
        @{Name="ImportAutofillFormData";               Value=0; Type="DWord"}
        # Import bookmarks — disables importing bookmarks from other browsers
        @{Name="ImportBookmarks";                      Value=0; Type="DWord"}
        # Import history — disables importing browsing history from other browsers
        @{Name="ImportHistory";                        Value=0; Type="DWord"}
        # Import passwords — disables importing saved passwords from other browsers
        @{Name="ImportSavedPasswords";                 Value=0; Type="DWord"}
        # Import search engine — disables importing search engine settings
        @{Name="ImportSearchEngine";                   Value=0; Type="DWord"}
        # Import homepage — disables importing homepage settings
        @{Name="ImportHomepage";                       Value=0; Type="DWord"}
    )
}


# ─────────────────────────────────────────────────────────────────────────────
# POLICY MERGING (Cumulative)
# ─────────────────────────────────────────────────────────────────────────────
$LevelOrder = @("BraveOnly", "Essential", "Balanced", "Strict")

$MergedPolicies = @{}
$SelectedIndex = [array]::IndexOf($LevelOrder, $Level)

if ($SelectedIndex -eq -1) {
    Write-Host "Internal error: invalid level '$Level'. Exiting." -ForegroundColor Red
    exit 1
}

for ($i = 0; $i -le $SelectedIndex; $i++) {
    foreach ($Policy in $PolicyDefinitions[$LevelOrder[$i]]) {
        # Later levels override earlier ones (e.g., Strict overrides Balanced's WebRtcIPHandling)
        $MergedPolicies[$Policy.Name] = $Policy
    }
}

$TotalPolicyCount = $MergedPolicies.Count
Write-Host "[INFO] Level '$Level' will apply $TotalPolicyCount policies.`n" -ForegroundColor DarkGray


# ─────────────────────────────────────────────────────────────────────────────
# REGISTRY WRITING HELPER
# ─────────────────────────────────────────────────────────────────────────────
function Write-PolicyValue {
    param(
        [string]$TargetPath,
        [string]$PolicyName,
        $PolicyValue,
        [string]$ValueType,
        [switch]$WhatIf
    )

    $displayValue = switch ($ValueType) {
        "DWord"      { "dword:$PolicyValue" }
        "String"     { "sz:`"$PolicyValue`"" }
        "MultiString" { "multi-sz:`"$($PolicyValue -join ';')`"" }
        default      { "unknown:$PolicyValue" }
    }

    if ($WhatIf) {
        Write-Host "  [WhatIf] $($TargetPath -replace '^HKLM:\\', 'HKLM\') :: $PolicyName -> $displayValue" -ForegroundColor Magenta
        return $displayValue
    }

    switch ($ValueType) {
        "DWord" {
            New-ItemProperty -Path $TargetPath -Name $PolicyName -Value $PolicyValue -PropertyType DWord -Force -ErrorAction Stop | Out-Null
            break
        }
        "String" {
            New-ItemProperty -Path $TargetPath -Name $PolicyName -Value $PolicyValue -PropertyType String -Force -ErrorAction Stop | Out-Null
            break
        }
        "MultiString" {
            $regPath = $TargetPath -replace "^HKLM:\\", "HKLM\"
            $key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SOFTWARE\Policies\BraveSoftware\Brave", $true)
            if (-not $key) {
                throw "Registry key not found: $regPath"
            }
            if ($PolicyValue -and $PolicyValue.Count -gt 0) {
                $key.SetValue($PolicyName, [string[]]$PolicyValue, [Microsoft.Win32.RegistryValueKind]::MultiString)
            } else {
                $key.SetValue($PolicyName, [string[]]@(), [Microsoft.Win32.RegistryValueKind]::MultiString)
            }
            $key.Close()
            break
        }
        default {
            throw "Unsupported type: $ValueType"
        }
    }

    return $displayValue
}


# ─────────────────────────────────────────────────────────────────────────────
# STEP 1: RECURSIVE SCAN, DYNAMIC GUID RESOLUTION, OMAHA TELEMETRY DISABLE
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[1/7] Scanning and Processing Dynamic Client IDs (GUID)..." -ForegroundColor Gray

$RootPath          = "HKCU:\Software\BraveSoftware"
$OmahaSuccessCount = 0
$OmahaErrorCount   = 0

$DynamicPaths = if (Test-Path "$RootPath\Update\ClientState") {
    Get-ChildItem -Path "$RootPath\Update\ClientState" -Recurse -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Name |
        ForEach-Object {
            $FormattedPath = $_ -replace "HKEY_CURRENT_USER", "HKCU:"
            if ($FormattedPath -match "\\\{[a-fA-F0-9-]+\}$") {
                Write-Host "  -> [Dynamic GUID Detected]: $FormattedPath" -ForegroundColor Yellow
                $FormattedPath
            }
        }
}

if ($DynamicPaths) {
    Write-Host "  [*] Disabling Omaha Updater Telemetry..." -ForegroundColor Gray
    foreach ($GUIDPath in $DynamicPaths) {
        try {
            if (-not $WhatIf) {
                New-ItemProperty -Path $GUIDPath -Name "usagestats" -Value 0 -PropertyType DWord -Force | Out-Null
            }
            $OmahaSuccessCount++
            $msg = if ($WhatIf) { "[WhatIf] $GUIDPath -> usagestats = 0" } else { "[OK] $GUIDPath -> usagestats = 0" }
            Write-Host "  $msg" -ForegroundColor $(if ($WhatIf) { "Magenta" } else { "DarkGreen" })
        } catch {
            $OmahaErrorCount++
            Write-Host "  [ERROR] Failed to write to $GUIDPath -> usagestats: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    Write-Host "  -> Omaha: $OmahaSuccessCount succeeded / $OmahaErrorCount failed`n" -ForegroundColor DarkGray
} else {
    Write-Host "  -> Info: No dynamic update ID found on the system or the area is already stable.`n" -ForegroundColor DarkGray
}


# ─────────────────────────────────────────────────────────────────────────────
# STEP 2: HKLM POLICY HIVE BACKUP (skipped in -WhatIf mode)
# ─────────────────────────────────────────────────────────────────────────────
if (-not $WhatIf) {
    Write-Host "[2/7] Backing Up HKLM Policy Hive..." -ForegroundColor Gray

    if (Test-Path $HKLM_Target) {
        $BackupFolder = "$env:TEMP\BravePolicyBackup"
        New-Item -Path $BackupFolder -ItemType Directory -Force | Out-Null

        $BackupFile = "$BackupFolder\HKLM_BravePolicy_$(Get-Date -Format 'yyyyMMdd_HHmmss').reg"
        $HKLMFlatPath = $HKLM_Target -replace "HKLM:\\", "HKLM\"

        try {
            reg export "$HKLMFlatPath" "$BackupFile" /y 2>&1 | Out-Null
            Write-Host "  -> Backup created     : $BackupFile" -ForegroundColor DarkGreen
            Write-Host "  -> To restore, use    : reg import `"$BackupFile`"`n" -ForegroundColor DarkGray
        } catch {
            Write-Host "  -> Warning: Backup could not be completed. Script is continuing." -ForegroundColor Yellow
            Write-Host "  -> Reason : $($_.Exception.Message)`n" -ForegroundColor DarkGray
        }
    } else {
        Write-Host "  -> Info: HKLM policy hive does not exist yet, backup skipped.`n" -ForegroundColor DarkGray
    }
} else {
    Write-Host "[2/7] Backup Skipped (-WhatIf mode)`n" -ForegroundColor DarkGray
}


# ─────────────────────────────────────────────────────────────────────────────
# STEP 3: TARGET DIRECTORY INFRASTRUCTURE VERIFICATION (skipped in -WhatIf mode)
# ─────────────────────────────────────────────────────────────────────────────
if (-not $WhatIf) {
    Write-Host "[3/7] Preparing Registry Target Directory Structure..." -ForegroundColor Gray
    New-Item -Path $HKCU_Target -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Host "  -> HKCU: $HKCU_Target" -ForegroundColor DarkGray
    New-Item -Path $HKLM_Target -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Host "  -> HKLM: $HKLM_Target`n" -ForegroundColor DarkGray
} else {
    Write-Host "[3/7] Directory Verification Skipped (-WhatIf mode)`n" -ForegroundColor DarkGray
}


# ─────────────────────────────────────────────────────────────────────────────
# STEP 4: HKCU — USER-LEVEL TELEMETRY PREFERENCE
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[4/7] Applying HKCU User Telemetry Preference..." -ForegroundColor Gray

$HKCUSuccess = $false

try {
    if (-not $WhatIf) {
        New-ItemProperty -Path $HKCU_Target -Name "UsageStatsInSample" -Value 0 -PropertyType DWord -Force | Out-Null
    }
    $HKCUSuccess = $true
    $tag = if ($WhatIf) { "[WhatIf]" } else { "[OK]" }
    $fg  = if ($WhatIf) { "Magenta" } else { "White" }
    Write-Host "  $tag UsageStatsInSample -> dword:00000000 (User-Level Telemetry Disabled)`n" -ForegroundColor $fg
} catch {
    Write-Host "  [ERROR] Failed to write UsageStatsInSample: $($_.Exception.Message)`n" -ForegroundColor Red
}


# ─────────────────────────────────────────────────────────────────────────────
# STEP 5: ENTERPRISE POLICY INJECTION (Multi-Level, Multi-Type)
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[5/7] Processing Enterprise Policies (Level: $Level)..." -ForegroundColor Gray

$SuccessCount = 0
$ErrorCount   = 0

# Track which type counts for summary
$typeCounts = @{ "DWord" = 0; "String" = 0; "MultiString" = 0 }

foreach ($Rule in $MergedPolicies.Values) {
    try {
        $displayValue = Write-PolicyValue -TargetPath $HKLM_Target -PolicyName $Rule.Name -PolicyValue $Rule.Value -ValueType $Rule.Type -WhatIf:$WhatIf
        if (-not $WhatIf) {
            $typeCounts[$Rule.Type]++
            $SuccessCount++
            Write-Host "  [OK] $($Rule.Name) -> $displayValue" -ForegroundColor Gray
        } else {
            $typeCounts[$Rule.Type]++
            $SuccessCount++
        }
    } catch {
        $ErrorCount++
        Write-Host "  [ERROR] $($Rule.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}


# ─────────────────────────────────────────────────────────────────────────────
# STEP 6: HKCU — ADDITIONAL USER-LEVEL TELEMETRY SETTINGS
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[6/7] Applying Additional HKCU Settings..." -ForegroundColor Gray

# Chromium Variations (User-level preference)
try {
    if (-not $WhatIf) {
        New-ItemProperty -Path $HKCU_Target -Name "ChromeVariations" -Value 1 -PropertyType DWord -Force | Out-Null
    }
    $tag = if ($WhatIf) { "[WhatIf]" } else { "[OK]" }
    $fg  = if ($WhatIf) { "Magenta" } else { "DarkGreen" }
    Write-Host "  $tag ChromeVariations (HKCU) -> dword:1" -ForegroundColor $fg
} catch {
    Write-Host "  [WARN] ChromeVariations (HKCU) could not be set: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""


# ─────────────────────────────────────────────────────────────────────────────
# STEP 7: SUMMARY REPORT AND VERIFICATION GUIDE
# ─────────────────────────────────────────────────────────────────────────────
$SeparatorLine = "-" * 62

Write-Host "`n$SeparatorLine" -ForegroundColor DarkGray
Write-Host "  EXECUTION SUMMARY REPORT" -ForegroundColor Cyan
Write-Host "  Script Version    : $ScriptVersion" -ForegroundColor White
Write-Host "  Level             : $Level ($TotalPolicyCount policies)" -ForegroundColor White
if ($WhatIf) { Write-Host "  Mode              : -WhatIf (preview only — no changes written)" -ForegroundColor Magenta }
Write-Host $SeparatorLine -ForegroundColor DarkGray

$HKCUStatus = if ($HKCUSuccess) { "Applied" } else { "Failed" }
Write-Host "  Omaha GUID Record  : $OmahaSuccessCount succeeded / $OmahaErrorCount failed" -ForegroundColor Gray
Write-Host "  HKCU Preference    : UsageStatsInSample    → $HKCUStatus" -ForegroundColor Gray
Write-Host "  HKLM Policies      : $SuccessCount applied / $ErrorCount failed" -ForegroundColor Gray
Write-Host "  Types Applied      : DWord=$($typeCounts.DWord) / String=$($typeCounts.String) / MultiString=$($typeCounts.MultiString)" -ForegroundColor Gray
Write-Host $SeparatorLine -ForegroundColor DarkGray

if ($ErrorCount -gt 0) {
    Write-Host "`n  [WARNING] $ErrorCount policy/policies could not be written. Please" -ForegroundColor Yellow
    Write-Host "            review the ERROR lines above and check required permissions." -ForegroundColor Yellow
}

if (-not $WhatIf -and ($SuccessCount -gt 0 -or $OmahaSuccessCount -gt 0)) {
    Write-Host "`n  [SUCCESS] $Level enterprise privacy policies were successfully" -ForegroundColor Green
    Write-Host "            applied to Brave on Windows 11 25H2." -ForegroundColor Green
    Write-Host "            Simply close Brave completely and reopen it for" -ForegroundColor White
    Write-Host "            the changes to take effect.`n" -ForegroundColor White
}

if ($WhatIf) {
    Write-Host "  [WhatIf] No registry changes were made. Run without -WhatIf to apply.`n" -ForegroundColor Magenta
}

Write-Host "  VERIFICATION:" -ForegroundColor Cyan
Write-Host "  1. Active policies   : brave://policy" -ForegroundColor DarkGray
Write-Host "  2. Registry path     : HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -ForegroundColor DarkGray
Write-Host "  3. Backup location   : `$env:TEMP\BravePolicyBackup\" -ForegroundColor DarkGray
Write-Host "  4. Rollback command  : reg import `"<backup_file.reg>`"`n" -ForegroundColor DarkGray

# Exit code
if ($ErrorCount -gt 0) { exit 1 } else { exit 0 }
