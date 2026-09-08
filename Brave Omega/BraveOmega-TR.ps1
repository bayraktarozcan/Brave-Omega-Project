# ==============================================================================
# BRAVE OMEGA PROJECT (Community Edition) — Türkçe arayüz sarmalayıcı
# ==============================================================================
# Bu dosya ince bir uyumluluk sarmalayıcıdır. Tüm mantık BraveOmega.ps1
# içindedir. Arayüz dilini TR olarak sabitler (aksi -Language ile belirtilmedikçe)
# ve bağlı tüm parametreleri ismen iletir; böylece aşağıdaki gibi mevcut
# komutlar eskisi gibi çalışır:
#     PowerShell -ExecutionPolicy Bypass -File ".\BraveOmega-TR.ps1" -Seviye Temel
# İki dilli giriş noktası için doğrudan BraveOmega.ps1 kullanın
# (-Language EN|TR|Auto).
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
    $forward['Language'] = 'TR'
}

& $canonical @forward
exit $LASTEXITCODE
