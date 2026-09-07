#Requires -Version 5.1
<#
.SYNOPSIS
    Brave Omega - Intune Win32 Detection Script

.DESCRIPTION
    Detects whether a Brave Omega policy level is deployed under
    HKLM:\SOFTWARE\Policies\BraveSoftware\Brave.

    Fully self-contained: the expected per-level policy names are embedded in this
    file, so it can be uploaded as a standalone Intune "Run script" detection rule.

    Exit codes (Intune semantics):
        0  - Target level is present (detected / installed).
        1  - Target level is not present, or the base key is missing.

.PARAMETER Level
    Policy level to detect (BraveOnly, Essential, Balanced, Advanced, Strict).
    Default: Balanced.

.PARAMETER RegistryPath
    Registry base path to check. Default: HKLM:\SOFTWARE\Policies\BraveSoftware\Brave

.INPUTS
    None. You cannot pipe objects to this script.

.OUTPUTS
    None. Communication happens via the process exit code.

.EXAMPLE
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File detect-brave-omega.ps1 -Level Strict

    Returns exit code 0 when the Strict level is fully present, 1 otherwise.

.NOTES
    - Presence is evaluated per policy NAME (value name or sub-key name under the base
      key). MultiString policies (e.g. ExtensionInstallForcelist) are stored as sub-keys.
    - The policy name sets below mirror the per-tier catalog in enterprise\levels.json and are
      kept in sync by Tests\DeploymentScripts.Tests.ps1. Do not edit by hand.
#>

param(
    [ValidateSet("BraveOnly", "Essential", "Balanced", "Advanced", "Strict")]
    [string]$Level = "Balanced",

    [string]$RegistryPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
)

$ErrorActionPreference = "Stop"

# ---------------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------------

function Get-OmegaLevelOrder {
    return @("BraveOnly", "Essential", "Balanced", "Advanced", "Strict")
}

function Get-OmegaTierPolicyNames {
    return @{
        "BraveOnly" = @(
            "BraveAIChatEnabled"
            "BraveDeAmpEnabled"
            "BraveDebouncingEnabled"
            "BraveNewsDisabled"
            "BraveP3AEnabled"
            "BravePlaylistEnabled"
            "BraveReduceLanguageEnabled"
            "BraveRewardsDisabled"
            "BraveShieldsDisabledForUrls"
            "BraveShieldsEnabledForUrls"
            "BraveSpeedreaderEnabled"
            "BraveStatsPingEnabled"
            "BraveTalkDisabled"
            "BraveTrackingQueryParametersFilteringEnabled"
            "BraveVPNDisabled"
            "BraveWalletDisabled"
            "BraveWaybackMachineEnabled"
            "BraveWebDiscoveryEnabled"
            "DefaultBraveAdblockSetting"
            "DefaultBraveFingerprintingV2Setting"
            "EmailAliasesEnabled"
            "PasswordProtectionWarningTrigger"
            "SafeBrowsingProtectionLevel"
            "TorDisabled"
        )
        "Essential" = @(
            "AlternateErrorPagesEnabled"
            "AudioCaptureAllowed"
            "BackgroundModeEnabled"
            "BraveGlobalPrivacyControlEnabled"
            "BrowserNetworkTimeQueriesEnabled"
            "DefaultWebBluetoothGuardSetting"
            "DefaultWebHidGuardSetting"
            "DefaultWebUsbGuardSetting"
            "DomainReliabilityAllowed"
            "DownloadRestrictions"
            "EnableOnlineRevocationChecks"
            "EncryptedClientHelloEnabled"
            "ExtensionInstallSources"
            "MetricsReportingEnabled"
            "NetworkPredictionOptions"
            "PaymentMethodQueryEnabled"
            "ProxySettings"
            "SafeBrowsingExtendedReportingEnabled"
            "SafeBrowsingSurveysEnabled"
            "ScreenCaptureAllowed"
            "SearchSuggestEnabled"
            "SpellcheckEnabled"
            "SuppressDifferentOriginSubframeDialogs"
            "UrlKeyedAnonymizedDataCollectionEnabled"
            "VideoCaptureAllowed"
            "WebRtcEventLogCollectionAllowed"
            "WebRtcTextLogCollectionAllowed"
        )
        "Balanced" = @(
            "AudioSandboxEnabled"
            "AutofillAddressEnabled"
            "AutofillCreditCardEnabled"
            "BlockThirdPartyCookies"
            "BraveSyncUrl"
            "ChromeVariations"
            "DefaultBraveHttpsUpgradeSetting"
            "DefaultBraveReferrersSetting"
            "DefaultGeolocationSetting"
            "DefaultNotificationsSetting"
            "DefaultPopupsSetting"
            "DefaultWindowManagementSetting"
            "DisableSafeBrowsingProceedAnyway"
            "DnsOverHttpsMode"
            "DownloadDirectory"
            "ExtensionInstallForcelist"
            "GenAILocalFoundationalModelSettings"
            "HttpsOnlyMode"
            "IntensiveWakeUpThrottlingEnabled"
            "LocalNetworkAccessPermissionsPolicyDefaultEnabled"
            "NetworkServiceSandboxEnabled"
            "PasswordManagerEnabled"
            "PasswordManagerPasskeysEnabled"
            "PromptForDownloadLocation"
            "QuicAllowed"
            "RelaunchNotification"
            "RelaunchNotificationPeriod"
            "ShowFullUrlsInAddressBar"
            "SitePerProcess"
            "UserFeedbackAllowed"
            "WebRtcIPHandling"
            "WebRtcLocalIpsAllowedUrls"
        )
        "Advanced" = @(
            "AIModeSettings"
            "AutofillPredictionSettings"
            "BlockExternalExtensions"
            "BrowserAddPersonEnabled"
            "BrowserGuestModeEnabled"
            "BuiltInDnsClientEnabled"
            "ChromeSuggestionsSettings"
            "CreateThemesSettings"
            "DefaultIdleDetectionSetting"
            "DefaultJavaScriptSetting"
            "DefaultLocalFontsSetting"
            "DefaultSensorsSetting"
            "DefaultSerialGuardSetting"
            "DevToolsGenAiSettings"
            "ExtensionAllowedTypes"
            "ExtensionInstallAllowlist"
            "ExtensionInstallBlocklist"
            "ExtensionSettings"
            "GeminiActOnWebSettings"
            "GeminiSettings"
            "GeminiSparkSettings"
            "HelpMeWriteSettings"
            "HideWebStoreIcon"
            "HistorySearchSettings"
            "ImportAutofillFormData"
            "ImportHistory"
            "ImportHomepage"
            "ImportSavedPasswords"
            "ImportSearchEngine"
            "LocalNetworkAccessAllowedForUrls"
            "LocalNetworkAccessBlockedForUrls"
            "LocalNetworkAccessIpAddressSpaceOverrides"
            "LocalNetworkAccessRestrictionsTemporaryOptOut"
            "NativeMessagingAllowlist"
            "NativeMessagingUserLevelHosts"
            "RendererAppContainerEnabled"
            "SearchContentSharingSettings"
            "ShowHomeButton"
            "SmartTabSharingSettings"
            "TabCompareSettings"
        )
        "Strict" = @(
            "AlwaysOpenPdfExternally"
            "BrowserSignin"
            "BrowsingDataLifetime"
            "CertificateTransparencyEnforcementDisabledForUrls"
            "DefaultBraveRemember1PStorageSetting"
            "DefaultClipboardSetting"
            "DefaultCookiesSetting"
            "DefaultFileSystemReadGuardSetting"
            "DefaultFileSystemWriteGuardSetting"
            "DefaultInsecureContentSetting"
            "DefaultJavaScriptJitSetting"
            "DeveloperToolsAvailability"
            "DisablePrintPreview"
            "ImportBookmarks"
            "IncognitoModeAvailability"
            "LocalNetworkAllowedForUrls"
            "LocalNetworkBlockedForUrls"
            "PasswordLeakDetectionEnabled"
            "PrintingEnabled"
            "SafeBrowsingDeepScanningEnabled"
            "SameOriginTabCaptureAllowedByOrigins"
            "ScreenCaptureAllowedByOrigins"
            "SpellCheckServiceEnabled"
            "SyncDisabled"
            "TabCaptureAllowedByOrigins"
            "TaskManagerEndProcessEnabled"
            "TranslateEnabled"
            "WindowCaptureAllowedByOrigins"
        )
    }
}

function Get-OmegaLevelNames {
    param([string]$Level)

    $tiers = Get-OmegaTierPolicyNames
    $cumulative = New-Object System.Collections.Generic.HashSet[string] ([System.StringComparer]::Ordinal)
    $order = Get-OmegaLevelOrder
    $tierIndex = [array]::IndexOf($order, $Level)
    if ($tierIndex -lt 0) { return @() }

    for ($i = 0; $i -le $tierIndex; $i++) {
        foreach ($name in @($tiers[$order[$i]])) {
            [void]$cumulative.Add([string]$name)
        }
    }

    return @($cumulative | Sort-Object)
}

function Get-OmegaPolicyRegistryView {
    param([string]$RegistryPath)

    $exists = Test-Path -LiteralPath $RegistryPath
    $valueNames = @()
    $subKeyNames = @()

    if ($exists) {
        $item = Get-Item -LiteralPath $RegistryPath -ErrorAction SilentlyContinue
        if ($null -ne $item -and $null -ne $item.Property) {
            $valueNames = @($item.Property)
        }
        $children = @(Get-ChildItem -LiteralPath $RegistryPath -ErrorAction SilentlyContinue)
        foreach ($child in $children) {
            if ($null -ne $child.PSChildName) {
                $subKeyNames += [string]$child.PSChildName
            }
        }
    }

    return [pscustomobject]@{
        Exists      = $exists
        ValueNames  = $valueNames
        SubKeyNames = $subKeyNames
    }
}

function Test-OmegaLevelDeployed {
    param([string]$Level, [string]$RegistryPath)

    $expectedNames = Get-OmegaLevelNames -Level $Level
    if (@($expectedNames).Count -eq 0) { return $false }

    $view = Get-OmegaPolicyRegistryView -RegistryPath $RegistryPath
    if (-not $view.Exists) { return $false }

    $available = New-Object System.Collections.Generic.HashSet[string] ([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($name in @($view.ValueNames)) { [void]$available.Add([string]$name) }
    foreach ($name in @($view.SubKeyNames)) { [void]$available.Add([string]$name) }

    foreach ($expected in @($expectedNames)) {
        if (-not $available.Contains($expected)) { return $false }
    }

    return $true
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

if ($MyInvocation.InvocationName -ne ".") {
    try {
        if (Test-OmegaLevelDeployed -Level $Level -RegistryPath $RegistryPath) {
            exit 0
        }
        exit 1
    } catch {
        exit 1
    }
}