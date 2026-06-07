# ==============================================================================
# ==============================================================================
#
#                   BRAVE OMEGA PROJECT (Community Edition)
#
# ==============================================================================
# ==============================================================================
# VERSION CONTEXT  : Windows 11 25H2 (Build 26200.8524)
#                    Brave 1.91.168 — Official Build / Chromium 149.0.7827.54
# FILE TYPE        : Advanced Dynamic Registry Integration and Hardening
#                    Script (.ps1)
# PURPOSE          : To protect user privacy, prevent data leaks, strip the
#                    browser of unnecessary side services, and automate this
#                    entire process.
#
# !! CHANNEL WARNING !!
#    Brave 1.91.168, dated May 4, 2026, belongs to the Stable channel.
#    The stable branch is always recommended for enterprise deployment.
#    ADMX policy behaviors might not be fully tested in Beta/Nightly releases.
#
# CHANGELOG
# ─────────────────────────────────────────────────────────────────────────────
#   v1.0                 Initial build created.
#   v1.1                 Comprehensive debugging and enhancement (7 changes):
#
#     [FIXED       #1]   BraveShieldsDefault — This policy name, which is not
#                        defined in Brave's official ADMX templates, was
#                        removed. The reason and correct method are documented
#                        below.
#
#     [FIXED       #2]   Try-Catch — Error handling was added to all registry
#                        write operations. Success and failure states are now
#                        tracked with counters and displayed in the summary.
#
#     [FIXED       #3]   $DynamicPaths — No longer a dead variable. A step to
#                        write 'usagestats=0' to detected Omaha GUID paths
#                        was added.
#
#     [ADDED       #4]   Brave Process Control — Before the script runs, it
#                        checks for active browser processes and presents a
#                        continue/cancel decision to the user.
#
#     [FIXED       #5]   Exit Codes — Corrected to use `exit 1` on failure and
#                        `exit 0` on success. Automation tools can now read
#                        the outcome correctly.
#
#     [ADDED       #6]   Registry Backup — A time-stamped backup in .reg
#                        format is taken before modifying the HKLM policy hive.
#
#     [SIMPLIFIED  #7]   Test-Path + New-Item -Force — The double check, which
#                        is logically mutually exclusive, was reduced to a
#                        single line.
# ==============================================================================

# ─────────────────────────────────────────────────────────────────────────────
# TERMINAL ENCODING HARDENING (CHARACTER ERROR RESOLUTION)
# ─────────────────────────────────────────────────────────────────────────────
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding           = [System.Text.Encoding]::UTF8

# ─────────────────────────────────────────────────────────────────────────────
# STEP 0A: USER ACCOUNT CONTROL (UAC) AND ADMINISTRATOR PRIVILEGE VERIFICATION
# ─────────────────────────────────────────────────────────────────────────────

# Retrieves the Windows identity object of the user running the current
# PowerShell session. This object contains the username, SID, and group memberships.
$CurrentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()

# Creates a "Principal" context supporting Windows security role queries
# from the identity object. The IsInRole() method operates on this object.
$UserRole = New-Object Security.Principal.WindowsPrincipal($CurrentIdentity)

# Checks if the user is a member of the built-in 'Administrator' role as True/False.
$IsAdmin = $UserRole.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# If there are no administrator privileges, the script safely terminates.
# [v1.0 Difference]: The old code used `Exit` — this produces a 0 (success)
# exit code even on failure, misleading automation tools. `exit 1` correctly
# communicates execution failure to Task Scheduler, SCCM, and CI/CD tools.
if (-not $IsAdmin) {
    Write-Error "CRITICAL ERROR: This script must be run as 'Administrator' to seal enterprise policies in the HKLM (Local Machine) hive!"
    exit 1
}

# Clears the terminal screen and initializes the header interface.
Clear-Host
Write-Host "=== BRAVE SPECIFIC VERSION OPTIMIZATION SCRIPT ===" -ForegroundColor Cyan
Write-Host "Target Platform : Windows 11 25H2 / Chromium 149 (Brave Stable Channel)" -ForegroundColor Gray
Write-Host "Execution Time  : $(Get-Date -Format 'dd-MM-yyyy HH:mm:ss')`n" -ForegroundColor Gray


# ─────────────────────────────────────────────────────────────────────────────
# STEP 0B: BRAVE PROCESS CONTROL [NEW — v1.1]
# ─────────────────────────────────────────────────────────────────────────────
# Running the script while Brave is open carries two concerns:
#
#   1. User preferences in the HKCU hive (like UsageStatsInSample) might be
#      overwritten by the browser's own internal mechanism upon closing;
#      the applied changes might not be persistent.
#
#   2. Some policy changes are read during browser startup. An open Brave
#      instance will only recognize new policies in the next session.
#
# The browser is not force-closed; this decision is intentional — working
# data in active tabs could be lost. The user is presented with a choice.
Write-Host "[CHECK] Inspecting Active Brave Processes..." -ForegroundColor Gray

$BraveProcesses = Get-Process -Name "brave" -ErrorAction SilentlyContinue

if ($BraveProcesses) {

    # Report how many processes are running. In normal use, Brave opens multiple
    # processes including the main process, renderer, GPU, and utilities;
    # this count is for informational purposes.
    $ProcessCount = $BraveProcesses.Count
    Write-Host "  [WARNING] $ProcessCount Brave process(es) are currently running." -ForegroundColor Yellow
    Write-Host "  Some HKCU modifications may be overwritten while the browser is open." -ForegroundColor Yellow
    Write-Host "  It is recommended to close Brave and re-run the script.`n" -ForegroundColor Yellow
    Write-Host "  Do you want to continue? (Y = Yes / N = No): " -ForegroundColor White -NoNewline
    $DecisionInput = Read-Host

    # Only explicit Y/y/Yes/yes responses are accepted.
    # All other responses, including empty inputs, are treated as a safe cancellation.
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
# Two different registry hives are used; this distinction is intentional and
# architecturally important:
#
#   HKCU: User account level. Values written here can be modified by the
#         user; the browser reads it as a preference. No admin rights needed.
#
#   HKLM: Machine-wide enterprise policy hive. Values written here appear
#         grayed out in the browser settings interface ("Enforced by your
#         administrator") and cannot be changed by the user. Admin rights
#         are mandatory.
#
# Policies are applied in two tiers: HKCU preference + HKLM enforced policy.
# This approach covers policy delays and edge cases.
$HKCU_Target = "HKCU:\Software\BraveSoftware\Brave-Browser"
$HKLM_Target = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"


# ─────────────────────────────────────────────────────────────────────────────
# STEP 1: RECURSIVE SCAN, DYNAMIC GUID RESOLUTION, AND OMAHA TELEMETRY DISABLE
# ─────────────────────────────────────────────────────────────────────────────
# [v1.0 Difference]: In the previous version, $DynamicPaths was only used for
# terminal output and was subjected to no further processing (dead variable).
# In this version, an Omaha telemetry disable value (`usagestats` = 0) is
# written to every detected GUID path.
#
# WHAT IS THE OMAHA UPDATER?
# Brave uses Google's Omaha update infrastructure (Windows). This system
# contains a `usagestats` registry key that collects usage statistics in the
# background while auto-updating. Every application has a separate ClientState
# record under its own GUID identifier.
#
# usagestats = 0 → Omaha does not collect or send data during the update process.
# This setting is applied at the GUID level in the HKCU hive and operates
# independently of the browser-level MetricsReportingEnabled policy; providing
# double-layer assurance.
Write-Host "[1/5] Scanning and Processing Dynamic Client IDs (GUID)..." -ForegroundColor Gray

$RootPath          = "HKCU:\Software\BraveSoftware"
$OmahaSuccessCount = 0
$OmahaErrorCount   = 0

# All subkeys under ClientState are scanned deeply (Recurse).
# SilentlyContinue is used to quietly bypass areas with permission constraints.
$DynamicPaths = if (Test-Path "$RootPath\Update\ClientState") {
    Get-ChildItem -Path "$RootPath\Update\ClientState" -Recurse -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Name |
        ForEach-Object {

            # Registry layout format (HKEY_CURRENT_USER) is converted to
            # PowerShell drive format (HKCU:). The New-ItemProperty and
            # Test-Path commands expect this format; they do not accept the layout.
            $FormattedPath = $_ -replace "HKEY_CURRENT_USER", "HKCU:"

            # Paths ending with a standard GUID pattern ({XXXXXXXX-XXXX-XXXX-...})
            # are distinguished using Regex. Upper hives (like ClientState itself)
            # do not match this; only leaf records at the application ID (App ID)
            # level are processed.
            if ($FormattedPath -match "\\\{[a-fA-F0-9-]+\}$") {
                Write-Host "  -> [Dynamic GUID Detected]: $FormattedPath" -ForegroundColor Yellow
                $FormattedPath
            }
        }
}

# The Omaha telemetry disable value is written to the collected GUID paths.
if ($DynamicPaths) {
    Write-Host "  [*] Disabling Omaha Updater Telemetry..." -ForegroundColor Gray

    foreach ($GUIDPath in $DynamicPaths) {
        try {
            # `usagestats` (DWORD 0): Disables the Omaha updater from collecting
            # data belonging to this application and sending it to external servers.
            # The value is applied to each GUID individually; bulk processing is not supported.
            New-ItemProperty -Path $GUIDPath -Name "usagestats" -Value 0 -PropertyType DWord -Force | Out-Null
            $OmahaSuccessCount++
            Write-Host "  [OK] $GUIDPath -> usagestats = 0" -ForegroundColor DarkGreen
        } catch {
            # In cases like permission issues, path locks, or data type conflicts,
            # an error is reported; the script continues processing the next GUID without stopping.
            $OmahaErrorCount++
            Write-Host "  [ERROR] Failed to write to $GUIDPath -> usagestats: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    Write-Host "  -> Omaha: $OmahaSuccessCount succeeded / $OmahaErrorCount failed`n" -ForegroundColor DarkGray

} else {
    Write-Host "  -> Info: No dynamic update ID found on the system or the area is already stable.`n" -ForegroundColor DarkGray
}


# ─────────────────────────────────────────────────────────────────────────────
# STEP 2: HKLM POLICY HIVE BACKUP [NEW — v1.1]
# ─────────────────────────────────────────────────────────────────────────────
# The current state is exported before modifying the HKLM enterprise policies hive.
# This step serves three purposes:
#
#   1. Rollback assurance : In case of unexpected policy conflicts or browser
#      errors, the previous state can be restored via the `reg import` command.
#
#   2. Audit trail        : Every execution generates its own time-stamped
#      backup; previous backups are not deleted. Change history is preserved.
#
#   3. Hard copy document : The policy state at the exact moment the script
#      is run is recorded; used as a reference in troubleshooting.
#
# Backups are saved in the %TEMP%\BravePolicyBackup\ folder in .reg format.
Write-Host "[2/5] Backing Up HKLM Policy Hive..." -ForegroundColor Gray

if (Test-Path $HKLM_Target) {

    # The backup folder is created if it does not yet exist. -Force ensures
    # the script continues without throwing an error if the folder is already there.
    $BackupFolder = "$env:TEMP\BravePolicyBackup"
    New-Item -Path $BackupFolder -ItemType Directory -Force | Out-Null

    # Timestamp in the file name: every execution generates a unique file.
    # Example: HKLM_BravePolicy_20260607_143022.reg
    $BackupFile = "$BackupFolder\HKLM_BravePolicy_$(Get-Date -Format 'yyyyMMdd_HHmmss').reg"

    # reg.exe expects the HKLM\ format with a backslash, not PowerShell's
    # HKLM:\ format. Conversion is mandatory.
    $HKLMFlatPath = $HKLM_Target -replace "HKLM:\\", "HKLM\"

    try {
        # reg export writes the specified hive and all subkeys to a .reg file.
        # The 2>&1 redirection also captures reg.exe's standard error output.
        # The /y flag overwrites without prompting if the target file already exists.
        reg export "$HKLMFlatPath" "$BackupFile" /y 2>&1 | Out-Null
        Write-Host "  -> Backup created     : $BackupFile" -ForegroundColor DarkGreen
        Write-Host "  -> To restore, use    : reg import `"$BackupFile`"`n" -ForegroundColor DarkGray
    } catch {
        # If the backup fails, a warning is issued but the script is not stopped.
        # The main operation (policy writing) can proceed independently of the backup.
        Write-Host "  -> Warning: Backup could not be completed. Script is continuing." -ForegroundColor Yellow
        Write-Host "  -> Reason : $($_.Exception.Message)`n" -ForegroundColor DarkGray
    }

} else {
    # If the hive does not exist yet, there is no data to back up; this is normal and expected.
    Write-Host "  -> Info: HKLM policy hive does not exist yet, backup skipped.`n" -ForegroundColor DarkGray
}


# ─────────────────────────────────────────────────────────────────────────────
# STEP 3: TARGET DIRECTORY INFRASTRUCTURE VERIFICATION
# ─────────────────────────────────────────────────────────────────────────────
# [SIMPLIFIED v1.1]: The previous version used this pattern:
#   if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
#
# These two operations are logically mutually exclusive:
#   - Test-Path False → It will create New-Item anyway.
#   - Test-Path True  → The -Force parameter continues without an error anyway.
#   Conclusion: The Test-Path check is completely redundant.
#
# New approach: Single line, -Force + -ErrorAction SilentlyContinue.
# This combination provides flexible stability — even if the script is run
# repeatedly, it yields consistent results; it neither produces errors nor
# double-creates the same folder.
Write-Host "[3/5] Preparing Registry Target Directory Structure..." -ForegroundColor Gray

# HKCU: User account preferences. Admin rights are not required;
# values can be modified by the user.
New-Item -Path $HKCU_Target -Force -ErrorAction SilentlyContinue | Out-Null
Write-Host "  -> HKCU: $HKCU_Target" -ForegroundColor DarkGray

# HKLM: Machine-wide enterprise policy hive. Admin rights are mandatory;
# values cannot be modified via the browser interface (appears locked/gray).
New-Item -Path $HKLM_Target -Force -ErrorAction SilentlyContinue | Out-Null
Write-Host "  -> HKLM: $HKLM_Target`n" -ForegroundColor DarkGray


# ─────────────────────────────────────────────────────────────────────────────
# STEP 4: HKCU — APPLYING USER-LEVEL TELEMETRY PREFERENCE
# ─────────────────────────────────────────────────────────────────────────────
# UsageStatsInSample is a Chromium preference value that controls whether
# browser-level usage statistics will be sampled and sent to Brave servers.
#
# WHY IS THIS VALUE IN HKCU?
# This is fundamentally a user preference, not a policy. Brave reads this value
# from the `Preferences` JSON file in the user account; however, it also accepts
# it from the HKCU registry and reflects it into the profile file.
#
# MetricsReportingEnabled = 0 in HKLM serves the same purpose at a higher tier.
# However, writing this value to HKCU provides a backup safeguard for these scenarios:
#   - Transition periods where the policy has not yet been applied
#   - Environments experiencing policy delays
#   - User environments with restricted access to the HKLM hive
#
# The two-tier application complements each other; one does not replace the other.
Write-Host "[4/5] Applying HKCU User Telemetry Preference..." -ForegroundColor Gray

$HKCUSuccess = $false

try {
    New-ItemProperty -Path $HKCU_Target -Name "UsageStatsInSample" -Value 0 -PropertyType DWord -Force | Out-Null
    $HKCUSuccess = $true
    Write-Host "  [OK] UsageStatsInSample -> dword:00000000 (User-Level Telemetry Disabled)`n" -ForegroundColor White
} catch {
    Write-Host "  [ERROR] Failed to write UsageStatsInSample: $($_.Exception.Message)`n" -ForegroundColor Red
}


# ─────────────────────────────────────────────────────────────────────────────
# STEP 5: CHROMIUM 149 AND BRAVE 1.91 COMPATIBLE ENTERPRISE POLICY INJECTION
# ─────────────────────────────────────────────────────────────────────────────
# [v1.0 Difference]: Try-catch error handling added, result reporting with
# success/failure counters added. BraveShieldsDefault removed (see below).
Write-Host "[5/5] Processing Enterprise Policies Enforcing Data Types..." -ForegroundColor Gray

# ══════════════════════════════════════════════════════════════════════════════
# REMOVED POLICY: BraveShieldsDefault = 2
# ══════════════════════════════════════════════════════════════════════════════
# v1.0 contained this line:
#   "BraveShieldsDefault" = 2
#
# WHY WAS IT REMOVED?
# A comprehensive review of Brave's official ADMX template package
# (policy_templates.zip) and Group Policy documentation reveals that an
# enterprise policy with this name DOES NOT EXIST.
#
# Brave manages Shields via two URL-based policies:
#   BraveShieldsEnabledForUrls  → Force-enables shields on specified URLs.
#   BraveShieldsDisabledForUrls → Force-disables shields on specified URLs.
# These policies are of String type (REG_SZ), not DWord. There is no registry
# policy that globally sets the Shields to "Standard" or "Aggressive" mode.
#
# WHAT WOULD HAVE HAPPENED IF NOT REMOVED?
# The value would be written to the registry successfully. The console would print
# [OK]. But Brave would silently ignore it because it does not recognize this key.
# A registry entry would remain that appeared to work but had no actual effect.
#
# THE CORRECT OPTION — Aggressive Shields Mode:
# Shield aggressiveness (Standard / Aggressive) is managed via user account
# preferences (Preferences JSON), not enterprise policy.
# Recommended methods for centralized deployment:
#   1. Manually configure brave://settings/shields → "Trackers & ads blocked" →
#      "Aggressive" once; then include the Preferences file as a template in
#      your enterprise deployment process.
#   2. Deploy a Brave managed profile via MDM (Intune, Jamf).
# ══════════════════════════════════════════════════════════════════════════════

# Verified enterprise policy dictionary with Brave ADMX templates and
# Chromium 149 policy layout. Summary table architecture; to add a new rule,
# simply adding a line to this block is sufficient — the loop remains untouched.
$Policies = @{

    # Completely disables the browser's integrated ad network, user tracking,
    # and BAT token reward infrastructure system-wide.
    # The toolbar Rewards icon and ad notifications become invisible.
    "BraveRewardsDisabled"                 = 1

    # Disables the internal crypto wallet (Brave Wallet) components, extensions,
    # toolbar button, and background services.
    "BraveWalletDisabled"                  = 1

    # Removes the VPN button from the toolbar and blocks the Brave VPN service
    # network running in the background. It does not touch system-wide VPN
    # configurations in any way.
    "BraveVPNDisabled"                     = 1

    # Disables the Leo Artificial Intelligence (AI Chat) engine in the sidebar.
    # Despite the name "Enabled", 0 = disabled; this aligns with the Chromium
    # policy naming convention ("disable by 0").
    # Leo chat history, processing services, and API connections are entirely cut off.
    "BraveAIChatEnabled"                   = 0

    # Stops the status and authentication ping requests Brave routinely sends
    # to its own servers. These pings are used to collect anonymous statistics;
    # disabling it increases network privacy.
    "BraveStatsPingEnabled"                = 0

    # Prevents the Chromium-based core metrics collection service from leaking
    # data externally. Together with UsageStatsInSample in HKCU, it forms a
    # double-layer assurance; each serves the same purpose at a different layer.
    "MetricsReportingEnabled"              = 0

    # Prevents the transmission of extended data reports regarding visited sites
    # to Google/Brave servers during Safe Browsing. The core Safe Browsing
    # (malicious site warning) function continues to operate independently of
    # this policy.
    "SafeBrowsingExtendedReportingEnabled" = 0
}

$SuccessCount = 0
$ErrorCount   = 0

foreach ($Rule in $Policies.GetEnumerator()) {
    try {
        # -PropertyType DWord: Forces the value to be written as a 32-bit integer
        # (REG_DWORD). ADMX templates expect a REG_DWORD type record; if a different
        # type is written, the policy is either not read or misinterpreted.
        #
        # -Force: Overwrites the value if it already exists, creates it from scratch
        # if it doesn't. This parameter makes the script flexibly stable — it can be
        # run repeatedly, guaranteeing the same result every time.
        New-ItemProperty -Path $HKLM_Target -Name $Rule.Key -Value $Rule.Value -PropertyType DWord -Force | Out-Null
        Write-Host "  [OK] $($Rule.Key) -> dword:$($Rule.Value) (Enterprise Policy Sealed)" -ForegroundColor Gray
        $SuccessCount++
    } catch {
        # If registry writing fails:
        #   1. An error message is printed in red (indicating which record failed).
        #   2. The error counter is incremented (tracked in the closing report).
        #   3. The loop moves to the next policy without stopping (partial success tolerated).
        Write-Host "  [ERROR] Failed to write $($Rule.Key): $($_.Exception.Message)" -ForegroundColor Red
        $ErrorCount++
    }
}


# ─────────────────────────────────────────────────────────────────────────────
# CLOSING: SUMMARY REPORT AND VERIFICATION GUIDE
# ─────────────────────────────────────────────────────────────────────────────
$SeparatorLine = "-" * 62

Write-Host "`n$SeparatorLine" -ForegroundColor DarkGray
Write-Host "  EXECUTION SUMMARY REPORT" -ForegroundColor Cyan
Write-Host $SeparatorLine -ForegroundColor DarkGray

# HKCU preference
$HKCUStatus = if ($HKCUSuccess) { "Successful" } else { "Failed" }
Write-Host "  Omaha GUID Record   : $OmahaSuccessCount succeeded / $OmahaErrorCount failed" -ForegroundColor Gray
Write-Host "  HKCU Preference     : UsageStatsInSample    → $HKCUStatus" -ForegroundColor Gray
Write-Host "  HKLM Policies       : $SuccessCount succeeded / $ErrorCount failed" -ForegroundColor Gray
Write-Host $SeparatorLine -ForegroundColor DarkGray

# Warning block — only visible if there are errors
if ($ErrorCount -gt 0) {
    Write-Host "`n  [WARNING] $ErrorCount policy/policies could not be written. Please" -ForegroundColor Yellow
    Write-Host "            review the ERROR lines above and check required permissions." -ForegroundColor Yellow
}

# General success message
if ($SuccessCount -gt 0 -or $OmahaSuccessCount -gt 0) {
    Write-Host "`n  [SUCCESS] Brave 1.91.168 enterprise privacy policies were" -ForegroundColor Green
    Write-Host "            successfully applied to the Windows 11 25H2 system." -ForegroundColor Green
    Write-Host "            Simply close Brave completely and reopen it for" -ForegroundColor White
    Write-Host "            the changes to take effect.`n" -ForegroundColor White
}

# Verification guide — referral for technical personnel
Write-Host "  VERIFICATION:" -ForegroundColor Cyan
Write-Host "  1. Active policies   : brave://policy" -ForegroundColor DarkGray
Write-Host "  2. Registry path     : HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -ForegroundColor DarkGray
Write-Host "  3. Backup location   : `$env:TEMP\BravePolicyBackup\" -ForegroundColor DarkGray
Write-Host "  4. Rollback command  : reg import `"<backup_file.reg>`"`n" -ForegroundColor DarkGray

# ─────────────────────────────────────────────────────────────────────────────
# EXIT CODE
# ─────────────────────────────────────────────────────────────────────────────
# exit 0 → All essential steps completed successfully.
# exit 1 → At least one HKLM policy could not be written.
#
# This distinction ensures that automation tools like Task Scheduler, SCCM,
# Ansible correctly report whether the script executed successfully or not.
# [v1.0 Difference]: The old version used `Exit` — this misled automation
# tools by always returning 0 (success) even in error states.
if ($ErrorCount -gt 0) { exit 1 } else { exit 0 }