# ==============================================================================
# BRAVE OMEGA PROJECT (Community Edition) — English interface wrapper
# ==============================================================================
# This is a thin compatibility wrapper. All logic lives in BraveOmega.ps1.
# It pins the interface language to EN (unless -Language is given explicitly)
# and forwards every bound parameter by name, so existing commands such as:
#     PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-EN.ps1" -Level Essential
# keep working exactly as before. Use BraveOmega.ps1 directly (with
# -Language EN|TR|Auto) for the bilingual entry point.
# ==============================================================================
#Requires -Version 5.1
param(
    [Alias("Seviye")][string]$Level = "",
    [switch]$WhatIf,
    [Alias("Sifirla")][switch]$Reset,
    [Alias("SenkronizasyonaIzinVer")][switch]$AllowSync,
    [Alias("Dil")][ValidateSet("EN", "TR", "Auto")][string]$Language = "Auto"
)

$canonical = Join-Path -Path $PSScriptRoot -ChildPath 'BraveOmega.ps1'
if (-not (Test-Path -LiteralPath $canonical)) {
    Write-Error "Canonical script not found: $canonical"
    exit 1
}

$forward = @{}
foreach ($key in $PSBoundParameters.Keys) {
    $forward[$key] = $PSBoundParameters[$key]
}
if (-not $forward.ContainsKey('Language')) {
    $forward['Language'] = 'EN'
}

& $canonical @forward
exit $LASTEXITCODE
