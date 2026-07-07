# ==============================================================================
# ==============================================================================
#
#                   BRAVE OMEGA PROJECT (Community Edition)
#
# ==============================================================================
# ==============================================================================
# SÜRÜM BAĞLAMI  : Windows 11 25H2 (Derleme 26200.8524)
#                  Brave 1.92.134 — Resmî Derleme / Chromium 150.0.7871.63
# DOSYA TÜRÜ     : Gelişmiş Çok Katmanlı Tarayıcı Sıkılaştırma Betiği (.ps1)
# AMAÇ           : Kullanıcı gizliliğini korumak, veri sızıntılarını önlemek,
#                  tarayıcıyı gereksiz yan hizmetlerden arındırmak. 5 katmanlı
#                  sıkılaştırma modeli: Brave Yalnız, Temel, Dengeli, Gelişmiş, Katı.
#
# !! KANAL UYARISI !!
#    Brave 1.92.134, 3 Temmuz 2026 tarihli, Stable (kararlı) kanalına aittir.
#    Kurumsal dağıtım için her zaman kararlı kol önerilir. Beta/Nightly
#    sürümlerinde ADMX politika davranışları henüz tam sınanmamış olabilir.
#
# DEĞİŞİKLİK GEÇMİŞİ (v2.1)
# ─────────────────────────────────────────────────────────────────────────────
#   v2.2.0.2             WebRTC politika hizalaması — Dengeli azami seviyeye yükseltildi:
#
#     [DEĞİŞTİ]     Dengeli'de WebRtcIPHandling,
#                   "default_public_interface_only" iken "disable_non_proxied_udp"
#                   olarak değiştirildi — Katı ile aynı değer. Ezme artık etkisiz.
#
#     [İYİLEŞTİRME]  Dokümantasyon: README, Wiki/Policy-Reference,
#                   index.html, policy-catalog.md tutarlılık için güncellendi.
#
#     [KALDIRILDI]   GitHub Projects/Issues ile ilgili tüm atıflar kaldırıldı.
#
#   v2.1.6               Faz 2 — Brave politika genişletmesi (+15 politika):
#
#     [YENİ]        Kapsamlı politika boşluk analizi sonucu 15 yeni Brave
#                   kurumsal politikası tüm katmanlara eklendi.
#
#     [YENİ]        Temel:        BraveGlobalPrivacyControlEnabled
#     [YENİ]        Brave Yalnız: 10 politika (DeAmp, Debouncing, Shields,
#                                 ReduceLanguage, TrackingParams, Adblock,
#                                 Fingerprinting, ShieldUrlLists, LocalAI,
#                                 EmailAliases)
#     [YENİ]        Dengeli:      DefaultBraveHttpsUpgradeSetting (Strict),
#                                 DefaultBraveReferrersSetting (Cap),
#                                 BraveSyncUrl
#     [YENİ]        Katı:         DefaultBraveRemember1PStorageSetting
#
#     [KALDIRILDI]   CloudPrintProxyEnabled kaldırıldı (Chromium tarafından
#                   kullanımdan kaldırıldı).
#
#     [İYİLEŞTİRME] Politika sayıları güncellendi: Brave Yalnız 13→23,
#                   Temel 16→17, Dengeli 18→21 (kümülatif katman korundu).
#
#   v2.1                 Özellik genişletmesi — Sürüm denetimi, -WhatIf, -Sıfırla:
#
#     [YENİ]        Otomatik Brave sürüm tespiti.
#                   Yüklü Brave doğrulanmış sürümden farklıysa uyarı verir.
#
#     [YENİ]        -WhatIf parametresi (standart PowerShell semantiği).
#                   Kayıt defterine yazmadan tüm değişiklikleri önizler.
#
#     [YENİ]        -Sıfırla parametresi.
#                   HKCU, HKLM ve Omaha GUID'deki tüm Brave Omega politikalarını
#                   kaldırır — tek komutla temiz kaldırma.
#
#     [İYİLEŞTİRME] Yaz-KayitDegeri artık -WhatIf parametresi alıyor.
#                   Yedekleme ve dizin oluşturma adımları -WhatIf modunda atlanır.
#
#   v2.0                 Köklü mimarî yenileme — Çok Katmanlı Sistem:
#
#     [YENİ]        5 katmanlı sıkılaştırma modeli:
#                     Brave Yalnız → Temel → Dengeli → Gelişmiş → Katı
#                     Her katman bir öncekinin tüm politikalarını kapsar.
#
#     [YENİ]        Çok türlü kayıt defteri desteği:
#                     - DWord      (REG_DWORD)   için true/false ve tamsayı
#                     - String     (REG_SZ)      için metin tipi politikalar
#                     - MultiString (REG_MULTI_SZ) için liste tipi politikalar
#
#     [YENİ]        Parametresiz çalıştırmada etkileşimli katman seçimi.
#                   -Level parametresi ile sessiz/otomasyon dağıtımı.
#
#     [YENİ]        50+ Chromium kurumsal politikası eklendi.
#                   Brave Yalnız: 22 Brave'e özgü politika
#                   Temel:        +17 veri sızıntısı önleme politikası
#                   Dengeli:      +21 güvenlik ve kullanım dengesi
#                   Gelişmiş:     +11 genişletilmiş gizlilik politikası
#                   Katı:         +9 azami gizlilik politikası
#
#     [İYİLEŞTİRME] Kayıt defteri yazma motoru türe göre dağıtım yapar
#                   ve her politika için ayrıntılı denetim izi üretir.
#
#     Tüm v1.x düzeltmeleri (süreç kontrolü, yedekleme, try-catch, çıkış
#     kodları, GUID çözümleme, UAC denetimi) korunmuş ve geliştirilmiştir.
# ==============================================================================

# ─────────────────────────────────────────────────────────────────────────────
# PARAMETRELER
# ─────────────────────────────────────────────────────────────────────────────
param(
    [string]$Seviye = "",
    [switch]$WhatIf,
    [switch]$Sifirla
)

# ─────────────────────────────────────────────────────────────────────────────
# BETİK SÜRÜM SABİTLERİ
# ─────────────────────────────────────────────────────────────────────────────
$BetikSurum    = "v2.2.1.0"
$DogrulananBrave = "1.92.134"
$DogrulananChromium = "150"

# ─────────────────────────────────────────────────────────────────────────────
# UÇBİRİM KODLAMA BİÇİMİ SIKILAŞTIRMASI (KARAKTER HATASI ÇÖZÜMÜ)
# ─────────────────────────────────────────────────────────────────────────────
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding           = [System.Text.Encoding]::UTF8

# ─────────────────────────────────────────────────────────────────────────────
# SÜRÜM ALGILAMA İŞLEVLERİ
# ─────────────────────────────────────────────────────────────────────────────
function Get-BraveVersion {
    $yollar = @(
        "${env:ProgramFiles}\BraveSoftware\Brave-Browser\Application\brave.exe",
        "${env:ProgramFiles(x86)}\BraveSoftware\Brave-Browser\Application\brave.exe",
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\Application\brave.exe"
    )
    foreach ($yol in $yollar) {
        if (Test-Path $yol) {
            try {
                $surumBilgi = (Get-Item $yol).VersionInfo
                $dosyaSurum = $surumBilgi.FileVersion
                if ($dosyaSurum) {
                    $parcalar = $dosyaSurum.Split('.')
                    if ($parcalar.Count -lt 4) { continue }
                    return @{
                        Yol          = $yol
                        BraveSurum   = "$($parcalar[1]).$($parcalar[2]).$($parcalar[3])"
                        ChromiumAna  = $parcalar[0]
                    }
                }
            } catch { continue }
        }
    }
    return $null
}

# ─────────────────────────────────────────────────────────────────────────────
# ADIM 0A: KULLANICI HESABI DENETİMİ (UAC) VE YÖNETİCİ YETKİSİ DOĞRULAMA
# ─────────────────────────────────────────────────────────────────────────────
$MevcutKimlik = [Security.Principal.WindowsIdentity]::GetCurrent()
$KullaniciRolu = New-Object Security.Principal.WindowsPrincipal($MevcutKimlik)
$YoneticiModu = $KullaniciRolu.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $YoneticiModu -and -not $WhatIf) {
    Write-Error "KRİTİK HATA: HKLM (Local Machine) kovanına kurumsal ilkeleri mühürlemek için bu betiğin 'Yönetici Olarak' çalıştırılması zorunludur! (Önizleme için -WhatIf kullanın.)"
    exit 1
}

Clear-Host
Write-Host "=== BRAVE OMEGA PROJECT $BetikSurum — ÇOK KATMANLI SIKILAŞTIRMA BETİĞİ ===" -ForegroundColor Cyan
Write-Host "Hedef Platform : Windows 11 25H2 / Chromium $DogrulananChromium (Brave $DogrulananBrave)" -ForegroundColor Gray
Write-Host "İşlem Zamanı   : $(Get-Date -Format 'dd-MM-yyyy HH:mm:ss')`n" -ForegroundColor Gray


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 0B: SÜRÜM DENETİMİ
# ─────────────────────────────────────────────────────────────────────────────
$braveBilgi = Get-BraveVersion
$surumlerUygun = $false

if ($braveBilgi) {
    $braveUygun  = $braveBilgi.BraveSurum  -eq $DogrulananBrave
    $chromeUygun = $braveBilgi.ChromiumAna -eq $DogrulananChromium
    $surumlerUygun = $braveUygun -and $chromeUygun

    if (-not $surumlerUygun) {
        Write-Host "[SÜRÜM DENETİMİ] Sürüm uyuşmazlığı tespit edildi!" -ForegroundColor Yellow
        Write-Host "  Yol: $($braveBilgi.Yol)" -ForegroundColor DarkGray
        Write-Host "  Tespit: Brave $($braveBilgi.BraveSurum) / Chromium $($braveBilgi.ChromiumAna)" -ForegroundColor Yellow
        Write-Host "  Beklenen: Brave $DogrulananBrave / Chromium $DogrulananChromium" -ForegroundColor Yellow
        Write-Host "  Bu tarayıcı sürümünde bazı politikalar tanınmayabilir." -ForegroundColor Yellow
        Write-Host "  Devam etmek istiyor musunuz? (E = Evet / H = Hayır): " -ForegroundColor White -NoNewline
        $devam = Read-Host
        if ($devam -notin @("E", "e", "Evet", "evet")) {
            Write-Host "İşlem kullanıcı tarafından iptal edildi." -ForegroundColor DarkGray
            exit 0
        }
    } else {
        Write-Host "[SÜRÜM DENETİMİ] Brave $DogrulananBrave / Chromium $DogrulananChromium tespit edildi — sürümler doğrulama hedefiyle eşleşiyor.`n" -ForegroundColor DarkGreen
    }
} else {
    Write-Host "[SÜRÜM DENETİMİ] Brave kurulum yolu tespit edilemedi." -ForegroundColor Yellow
    Write-Host "  Devam ediliyor — ancak brave://settings/help adresinden uyumluluğu kontrol edin.`n" -ForegroundColor DarkGray
}


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 0C: SIFIRLA (RESET) MODU
# ─────────────────────────────────────────────────────────────────────────────
$HKCU_Hedef = "HKCU:\Software\BraveSoftware\Brave-Browser"
$HKLM_Hedef = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

if ($Sifirla) {
    Write-Host "[SIFIRLA MODU] Tüm Brave Omega politikaları kaldırılıyor..." -ForegroundColor Magenta
    Write-Host ""

    $tumPolitikalar = @(
        "UsageStatsInSample", "OmahaMachineLevelUserMetrics",
        "BraveRewardsDisabled", "BraveWalletDisabled", "BraveVPNDisabled",
        "BraveAIChatEnabled", "BraveTalkDisabled", "BraveNewsDisabled",
        "BravePlaylistEnabled", "BraveSpeedreaderEnabled", "BraveWaybackMachineEnabled",
        "BraveP3AEnabled", "BraveStatsPingEnabled", "BraveWebDiscoveryEnabled", "TorDisabled",
        "BraveDeAmpEnabled", "BraveDebouncingEnabled", "BraveReduceLanguageEnabled",
        "BraveTrackingQueryParametersFilteringEnabled", "DefaultBraveAdblockSetting",
        "DefaultBraveFingerprintingV2Setting", "BraveShieldsDisabledForUrls", "BraveShieldsEnabledForUrls",
        "EmailAliasesEnabled",
        "BraveGlobalPrivacyControlEnabled",
        "DefaultBraveHttpsUpgradeSetting", "DefaultBraveReferrersSetting", "BraveSyncUrl",
        "DefaultBraveRemember1PStorageSetting",
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
        "DefaultSensorsSetting", "DefaultLocalFontsSetting", "DefaultClipboardSetting",
        "DefaultFileSystemReadGuardSetting", "DefaultFileSystemWriteGuardSetting",
        "DefaultSerialGuardSetting", "DefaultIdleDetectionSetting",
        "DefaultInsecureContentSetting", "DefaultJavaScriptJitSetting", "DefaultCookiesSetting",
        "BrowserGuestModeEnabled", "BrowserAddPersonEnabled", "CloudPrintProxyEnabled",
        "ImportAutofillFormData", "ImportBookmarks", "ImportHistory",
        "ImportSavedPasswords", "ImportSearchEngine", "ImportHomepage"
    )

    # HKLM'den kaldır
    $hkSayac = 0
    if (Test-Path $HKLM_Hedef) {
        foreach ($ad in $tumPolitikalar) {
            try {
                if (-not $WhatIf) {
                    Remove-ItemProperty -Path $HKLM_Hedef -Name $ad -ErrorAction SilentlyContinue
                }
                $hkSayac++
                Write-Host "  [OK] HKLM\$ad kaldırıldı" -ForegroundColor $(if ($WhatIf) { "Magenta" } else { "DarkGreen" })
            } catch { }
        }
    }

    # HKCU'dan kaldır
    $hcSayac = 0
    if (Test-Path $HKCU_Hedef) {
        foreach ($ad in @("UsageStatsInSample", "ChromeVariations")) {
            try {
                if (-not $WhatIf) {
                    Remove-ItemProperty -Path $HKCU_Hedef -Name $ad -ErrorAction SilentlyContinue
                }
                $hcSayac++
                Write-Host "  [OK] HKCU\$ad kaldırıldı" -ForegroundColor $(if ($WhatIf) { "Magenta" } else { "DarkGreen" })
            } catch { }
        }
    }

    # Omaha usagestats kaldır
    $omahaSayac = 0
    $kokYol = "HKCU:\Software\BraveSoftware"
    if (Test-Path "$kokYol\Update\ClientState") {
        $guids = Get-ChildItem -Path "$kokYol\Update\ClientState" -Recurse -ErrorAction SilentlyContinue |
            Select-Object -ExpandProperty Name |
            ForEach-Object { $_ -replace "HKEY_CURRENT_USER", "HKCU:" } |
            Where-Object { $_ -match "\\\{[a-fA-F0-9-]+\}$" }
        foreach ($guidYol in $guids) {
            try {
                if (-not $WhatIf) {
                    Remove-ItemProperty -Path $guidYol -Name "usagestats" -ErrorAction SilentlyContinue
                }
                $omahaSayac++
                Write-Host "  [OK] Omaha GUID: usagestats kaldırıldı" -ForegroundColor $(if ($WhatIf) { "Magenta" } else { "DarkGreen" })
            } catch { }
        }
    }

    # Boş HKLM anahtarını temizle
    $hkPolicies = Get-ItemProperty -Path $HKLM_Hedef -ErrorAction SilentlyContinue
    $hkGercekOzelikler = @($hkPolicies.PSObject.Properties | Where-Object { $_.Name -notin @('PSPath','PSParentPath','PSChildName','PSDrive','PSProvider') })
    if ($hkPolicies -and $hkGercekOzelikler.Count -eq 0) {
        try {
            if (-not $WhatIf) {
                Remove-Item -Path $HKLM_Hedef -Force -ErrorAction SilentlyContinue
            }
            Write-Host "  [OK] HKLM politika anahtarı kaldırıldı (hiç politika kalmadı)" -ForegroundColor $(if ($WhatIf) { "Magenta" } else { "DarkGreen" })
        } catch { }
    }

    Write-Host "`n[SIFIRLA TAMAMLANDI] HKLM: $hkSayac / HKCU: $hcSayac / Omaha: $omahaSayac girdi kaldırıldı." -ForegroundColor Cyan
    Write-Host "  Brave'i kapatıp yeniden açın.`n" -ForegroundColor White
    exit 0
}


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 0D: KATMAN SEÇİMİ
# ─────────────────────────────────────────────────────────────────────────────
if (-not $Seviye -or $Seviye -eq "") {
    Write-Host "Bir sıkılaştırma katmanı seçin:" -ForegroundColor White
    Write-Host "  1. Brave Yalnız" -ForegroundColor Gray
    Write-Host "  2. Temel   [Önerilen]" -ForegroundColor Green
    Write-Host "  3. Dengeli" -ForegroundColor Yellow
    Write-Host "  4. Gelişmiş" -ForegroundColor DarkYellow
    Write-Host "  5. Katı" -ForegroundColor Red
    Write-Host ""
    $Secim = Read-Host "Seçiminiz (1-5)"

    $Seviye = switch ($Secim) {
        "1" { "Brave Yalnız" }
        "2" { "Temel" }
        "3" { "Dengeli" }
        "4" { "Gelişmiş" }
        "5" { "Katı" }
        default { "Temel" }
    }
}

# İngilizce adları Türkçeye eşle
$SeviyeHaritasi = @{
    "BraveOnly"  = "Brave Yalnız"
    "Essential"  = "Temel"
    "Balanced"   = "Dengeli"
    "Advanced"   = "Gelişmiş"
    "Strict"     = "Katı"
}
if ($SeviyeHaritasi.ContainsKey($Seviye)) {
    $Seviye = $SeviyeHaritasi[$Seviye]
}

# Türkçe adları iç anahtara eşle
$SeviyeAnahtari = @{
    "Brave Yalnız" = "BraveOnly"
    "Temel"        = "Essential"
    "Dengeli"      = "Balanced"
    "Gelişmiş"     = "Advanced"
    "Katı"         = "Strict"
}

if ($SeviyeAnahtari.ContainsKey($Seviye)) {
    $SeviyeAnahtar = $SeviyeAnahtari[$Seviye]
} else {
    Write-Host "Geçersiz katman '$Seviye'. Temel katmanına dönülüyor." -ForegroundColor Yellow
    $Seviye = "Temel"
    $SeviyeAnahtar = "Essential"
}

if ($WhatIf) {
    Write-Host "Mod: -WhatIf (yalnızca önizleme — kayıt defterine yazılmaz)" -ForegroundColor Magenta
}
Write-Host "Seçilen Katman: $Seviye" -ForegroundColor Cyan
Write-Host ""


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 0E: BRAVE SÜREÇ KONTROLÜ
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[KONTROL] Aktif Brave Süreçleri Denetleniyor..." -ForegroundColor Gray

$BraveIslemleri = Get-Process -Name "brave" -ErrorAction SilentlyContinue

if ($BraveIslemleri) {
    $SurecSayisi = $BraveIslemleri.Count
    Write-Host "  [UYARI] $SurecSayisi adet Brave süreci çalışıyor." -ForegroundColor Yellow
    Write-Host "  Tarayıcı açıkken bazı HKCU değişiklikleri üzerine yazılabilir." -ForegroundColor Yellow
    Write-Host "  Brave'i kapatıp betiği yeniden çalıştırmanız önerilir.`n" -ForegroundColor Yellow
    Write-Host "  Devam etmek istiyor musunuz? (E = Devam / H = İptal): " -ForegroundColor White -NoNewline
    $KararMetni = Read-Host

    if ($KararMetni -notin @("E", "e", "Evet", "evet")) {
        Write-Host "`n  İşlem kullanıcı tarafından iptal edildi. Brave'i kapatıp yeniden deneyin." -ForegroundColor DarkGray
        exit 0
    }
    Write-Host ""
} else {
    Write-Host "  -> Temiz: Çalışan Brave süreci tespit edilmedi.`n" -ForegroundColor DarkGreen
}


# ─────────────────────────────────────────────────────────────────────────────
# YOL SABİTLERİ
# ─────────────────────────────────────────────────────────────────────────────
$HKCU_Hedef = "HKCU:\Software\BraveSoftware\Brave-Browser"
$HKLM_Hedef = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"


# ─────────────────────────────────────────────────────────────────────────────
# KATMAN POLİTİKA TANIMLARI
# ─────────────────────────────────────────────────────────────────────────────
# Her politika: @{Ad=""; Deger=; Tur="DWord|String|MultiString"}
# Katmanlar kümülatiftir: her katman bir öncekinin tüm politikalarını içerir.

$PolitikaTanimlari = @{
    "BraveOnly" = @(
        # Brave Rewards — reklam ağı, BAT token ve ödül altyapısını kapatır
        @{Ad="BraveRewardsDisabled";                 Deger=1; Tur="DWord"}
        # Brave Wallet — kripto cüzdan, Web3 ve merkeziyetsiz DNS'i kapatır
        @{Ad="BraveWalletDisabled";                  Deger=1; Tur="DWord"}
        # Brave VPN — VPN düğmesini kaldırır ve arka plan VPN hizmetini engeller
        @{Ad="BraveVPNDisabled";                     Deger=1; Tur="DWord"}
        # Leo AI Chat — kenar çubuğundaki yapay zekâ asistanını kapatır
        @{Ad="BraveAIChatEnabled";                   Deger=0; Tur="DWord"}
        # Brave Talk — yerleşik video konferans aracını kapatır
        @{Ad="BraveTalkDisabled";                    Deger=1; Tur="DWord"}
        # Brave News — Yeni Sekme Sayfası'ndaki haber beslemesini kapatır
        @{Ad="BraveNewsDisabled";                    Deger=1; Tur="DWord"}
        # Brave Playlist — çevrimdışı video/ses kaydetme özelliğini kapatır
        @{Ad="BravePlaylistEnabled";                 Deger=0; Tur="DWord"}
        # Speedreader — makale sayfalarında okuma modu önerisini kapatır
        @{Ad="BraveSpeedreaderEnabled";              Deger=0; Tur="DWord"}
        # Wayback Machine — 404 sayfalarında Internet Archive entegrasyonunu kapatır
        @{Ad="BraveWaybackMachineEnabled";           Deger=0; Tur="DWord"}
        # P3A — Gizlilik Korumalı Ürün Analitiği veri göndermesini kapatır
        @{Ad="BraveP3AEnabled";                      Deger=0; Tur="DWord"}
        # İstatistik Ping'i — Brave sunucularına durum/kimlik ping'lerini kapatır
        @{Ad="BraveStatsPingEnabled";                Deger=0; Tur="DWord"}
        # Web Discovery Project — anonim arama indeksi katkısını kapatır
        @{Ad="BraveWebDiscoveryEnabled";             Deger=0; Tur="DWord"}
        # Tor — Tor ile Özel Pencere özelliğini kapatır
        @{Ad="TorDisabled";                          Deger=1; Tur="DWord"}
        # ─── Yeni Brave Yalnız Politikaları (Faz 2) ───
        # De-AMP — Google AMP sayfalarını atlar, doğrudan yayıncıya yönlendirir
        @{Ad="BraveDeAmpEnabled";                    Deger=1; Tur="DWord"}
        # Bounce tracking — bilinen izleme alan adlarını otomatik atlar
        @{Ad="BraveDebouncingEnabled";               Deger=1; Tur="DWord"}
        # Dil parmak izi azaltma — sitelerin tam yereli okumasını engeller
        @{Ad="BraveReduceLanguageEnabled";            Deger=1; Tur="DWord"}
        # İzleme sorgu parametre filtreleme — URL'lerden bilinen izleyicileri temizler
        @{Ad="BraveTrackingQueryParametersFilteringEnabled"; Deger=1; Tur="DWord"}
        # Reklam engelleme — Shields reklam engellemeyi kilitle (Brave varsayılanı)
        @{Ad="DefaultBraveAdblockSetting";           Deger=2; Tur="DWord"}
        # Parmak izi koruma — Shields parmak izi korumasını sıkı moda kilitle
        @{Ad="DefaultBraveFingerprintingV2Setting";  Deger=3; Tur="DWord"}
        # Shields kapalı URL'ler — boş küme, hiçbir URL beyaz listeye alınmaz
        @{Ad="BraveShieldsDisabledForUrls";          Deger=@(); Tur="MultiString"}
        # Shields açık URL'ler — boş küme, hiçbir URL kara listeye alınmaz
        @{Ad="BraveShieldsEnabledForUrls";           Deger=@(); Tur="MultiString"}
        # E-posta takma adları — anonim e-posta takma adı özelliğini kapatır
        @{Ad="EmailAliasesEnabled";                  Deger=0; Tur="DWord"}
    )

    "Essential" = @(
        # ─── Veri Sızıntısı Önleme (kullanıma sıfır etki) ───

        # Chromium ölçüm anahtarı — kullanım/çökme verisinin Google/Brave'e gitmesini durdurur
        @{Ad="MetricsReportingEnabled";              Deger=0; Tur="DWord"}
        # Safe Browsing genişletilmiş raporlama — sayfa içeriğinin Google'a gönderimini durdurur
        @{Ad="SafeBrowsingExtendedReportingEnabled"; Deger=0; Tur="DWord"}
        # URL anahtarlı veri toplama — ziyaret edilen URL'lerin Google'a gönderimini durdurur
        @{Ad="UrlKeyedAnonymizedDataCollectionEnabled"; Deger=0; Tur="DWord"}
        # Arama önerileri — tuş vuruşu verisinin cihazdan çıkmasını durdurur
        @{Ad="SearchSuggestEnabled";                 Deger=0; Tur="DWord"}
        # Ağ tahmini — DNS ön getirme ve ön bağlantıyı durdurur
        @{Ad="NetworkPredictionOptions";             Deger=2; Tur="DWord"}
        # Yazım denetimi — yazım denetimini kapatır (metnin Google sunucularına gitmesini durdurur)
        @{Ad="SpellcheckEnabled";                    Deger=0; Tur="DWord"}
        # Alternatif hata sayfaları — DNS çözümleme hatasında ağ isteklerini durdurur
        @{Ad="AlternateErrorPagesEnabled";           Deger=0; Tur="DWord"}
        # Ağ zaman sorguları — Google'a zaman eşitleme isteklerini durdurur
        @{Ad="BrowserNetworkTimeQueriesEnabled";     Deger=0; Tur="DWord"}
        # Alan adı güvenilirliği — Google'a tanısal veri raporlamasını durdurur
        @{Ad="DomainReliabilityAllowed";             Deger=0; Tur="DWord"}
        # Arka plan modu — tüm pencereler kapandığında Brave'in çalışmasını engeller
        @{Ad="BackgroundModeEnabled";                Deger=0; Tur="DWord"}
        # Safe Browsing anketleri — tarama sonrası anketleri kapatır
        @{Ad="SafeBrowsingSurveysEnabled";           Deger=0; Tur="DWord"}
        # Safe Browsing derin tarama — sunucu taraflı indirme taramasını kapatır
        @{Ad="SafeBrowsingDeepScanningEnabled";      Deger=0; Tur="DWord"}
        # WebRTC olay günlüğü — WebRTC olay günlüklerinin Google'a yüklenmesini durdurur
        @{Ad="WebRtcEventLogCollectionAllowed";     Deger=0; Tur="DWord"}
        # WebRTC metin günlüğü — WebRTC metin günlüklerinin Google'a yüklenmesini durdurur
        @{Ad="WebRtcTextLogCollectionAllowed";      Deger=0; Tur="DWord"}
        # Ses yakalama — mikrofon erişimini varsayılan olarak engeller (site bazında izin verilebilir)
        @{Ad="AudioCaptureAllowed";                  Deger=0; Tur="DWord"}
        # Video yakalama — kamera erişimini varsayılan olarak engeller (site bazında izin verilebilir)
        @{Ad="VideoCaptureAllowed";                  Deger=0; Tur="DWord"}
        # ─── Yeni Temel Politikaları (Faz 2) ───
        # GPC — Küresel Gizlilik Kontrolü Sec-GPC başlığı gönderir, veri satışını reddeder
        @{Ad="BraveGlobalPrivacyControlEnabled";     Deger=1; Tur="DWord"}
        # ─── Yeni Temel Politikaları (v2.2.1.0 — Donanım API & Güvenlik) ───
        # WebUSB — web sitelerinin USB aygıtlarına erişimini varsayılan olarak engeller
        @{Ad="DefaultWebUsbGuardSetting";            Deger=2; Tur="DWord"}
        # Web Bluetooth — web sitelerinin Bluetooth aygıtlarına erişimini varsayılan olarak engeller
        @{Ad="DefaultWebBluetoothGuardSetting";      Deger=2; Tur="DWord"}
        # WebHID — web sitelerinin HID aygıtlarına erişimini varsayılan olarak engeller
        @{Ad="DefaultWebHidGuardSetting";            Deger=2; Tur="DWord"}
        # Direct Sockets — web sitelerinin Direct Sockets API kullanımını varsayılan olarak engeller
        @{Ad="DefaultDirectSocketsSetting";          Deger=2; Tur="DWord"}
        # Cihaz Özellikleri — tüm kaynakların cihaz özelliklerine erişimini engeller (ChromeOS)
        @{Ad="DeviceAttributesAllowedForOrigins";    Deger=@(); Tur="MultiString"}
        # Şifreli İstemci Selamı — SNI'yi şifrelemek için ECH'yi zorlar
        @{Ad="EncryptedClientHelloEnabled";          Deger=1; Tur="DWord"}
        # Ödeme Yöntemi Sorguları — Payment Request API sorgularını devre dışı bırakır
        @{Ad="PaymentMethodQueryEnabled";            Deger=0; Tur="DWord"}
        # Alt Çerçeve İletişim Kutuları — farklı kaynaklı alt çerçevelerin iletişim kutularını engeller
        @{Ad="SuppressDifferentOriginSubframeDialogs"; Deger=1; Tur="DWord"}
    )

    "Balanced" = @(
        # ─── Güvenlik ve Kullanım Dengesi ───

        # WebRTC IP yönetimi — tüm WebRTC trafiğini yapılandırılmış vekil sunucu üzerinden yönlendirir
        @{Ad="WebRtcIPHandling";                     Deger="disable_non_proxied_udp"; Tur="String"}
        # WebRTC yerel IP'leri — boş liste, hiçbir URL'nin ICE üzerinden yerel IP almasını engeller
        @{Ad="WebRtcLocalIpsAllowedUrls";            Deger=@(); Tur="MultiString"}
        # HTTPS-Yalnızca Modu — tüm gezintileri HTTPS'e zorlar
        @{Ad="HttpsOnlyMode";                        Deger="force_enabled"; Tur="String"}
        # DNS-over-HTTPS — DNS sorgularını şifreli olarak yükseltir
        @{Ad="DnsOverHttpsMode";                     Deger="automatic"; Tur="String"}
        # Üçüncü taraf çerezleri — siteler arası izleme çerezlerini engeller
        @{Ad="BlockThirdPartyCookies";               Deger=1; Tur="DWord"}
        # Parola yöneticisi — yerleşik parola kaydetmeyi kapatır
        @{Ad="PasswordManagerEnabled";               Deger=0; Tur="DWord"}
        # Passkey'ler — tarayıcıda passkey kaydetmeyi kapatır
        @{Ad="PasswordManagerPasskeysEnabled";       Deger=0; Tur="DWord"}
        # Adres otomatik doldurma — adres formu veri depolamayı kapatır
        @{Ad="AutofillAddressEnabled";               Deger=0; Tur="DWord"}
        # Kredi kartı otomatik doldurma — ödeme yöntemi veri depolamayı kapatır
        @{Ad="AutofillCreditCardEnabled";            Deger=0; Tur="DWord"}
        # Tam URL'ler — adres çubuğunda protokol ve alt alan adını gösterir (oltalamaya karşı)
        @{Ad="ShowFullUrlsInAddressBar";             Deger=1; Tur="DWord"}
        # Safe Browsing uyarısını atlama — kötü amaçlı site uyarılarını atlamayı engeller
        @{Ad="DisableSafeBrowsingProceedAnyway";     Deger=1; Tur="DWord"}
        # QUIC protokolü — QUIC'i kapatır, TCP/TLS'e düşer
        @{Ad="QuicAllowed";                          Deger=0; Tur="DWord"}
        # Chrome varyasyonları — yalnızca kritik saha denemelerine izin verir
        @{Ad="ChromeVariations";                     Deger=1; Tur="DWord"}
        # Ağ hizmeti kum havuzu — ağ hizmetini kum havuzlu süreçte çalıştırır
        @{Ad="NetworkServiceSandboxEnabled";         Deger=1; Tur="DWord"}
        # Ses kum havuzu — ses hizmetini kum havuzlu süreçte çalıştırır
        @{Ad="AudioSandboxEnabled";                  Deger=1; Tur="DWord"}
        # Coğrafi konum — site konum erişimini varsayılan olarak engeller
        @{Ad="DefaultGeolocationSetting";            Deger=2; Tur="DWord"}
        # Bildirimler — site bildirim isteklerini varsayılan olarak engeller
        @{Ad="DefaultNotificationsSetting";          Deger=2; Tur="DWord"}
        # Açılır pencereler — açılır pencere isteklerini varsayılan olarak engeller
        @{Ad="DefaultPopupsSetting";                 Deger=2; Tur="DWord"}
        # ─── Yeni Dengeli Politikaları (Faz 2) ───
        # HTTPS yükseltme — Sıkı mod, HTTPS gerektirir, hata sayfası gösterir
        @{Ad="DefaultBraveHttpsUpgradeSetting";      Deger=2; Tur="DWord"}
        # Referrer politikası — strict-origin-when-cross-origin ile sınırla
        @{Ad="DefaultBraveReferrersSetting";         Deger=2; Tur="DWord"}
        # Sync sunucusu — varsayılan Brave sync sunucu adresini belirtir
        @{Ad="BraveSyncUrl";                         Deger="https://sync-v2.brave.com/v2"; Tur="String"}
        # ─── Yeni Dengeli Politikaları (v2.2.1.0 — Donanım API & Güvenlik) ───
        # Pencere Yönetimi — sitelerin ekran bilgilerine erişimini varsayılan olarak engeller
        @{Ad="DefaultWindowManagementSetting";       Deger=2; Tur="DWord"}
        # Site Yalıtımı — tüm siteleri ayrı süreçlerde çalışmaya zorlar
        @{Ad="SitePerProcess";                       Deger=1; Tur="DWord"}
        # Uyandırma Zamanlayıcıları — JavaScript uyandırma zamanlayıcılarını agresif kısıtlar
        @{Ad="IntensiveWakeUpThrottlingEnabled";     Deger=1; Tur="DWord"}
        # Kullanıcı Geri Bildirimi — tarayıcı içi geri bildirim istemlerini devre dışı bırakır
        @{Ad="UserFeedbackAllowed";                  Deger=0; Tur="DWord"}
    )

    "Advanced" = @(
        # ─── Gelişmiş Gizlilik — orta-yüksek koruma ───

        # Sensörler — cihaz hareket/ışık sensörü erişimini varsayılan olarak engeller
        @{Ad="DefaultSensorsSetting";                Deger=2; Tur="DWord"}
        # Yerel yazı tipleri — yazı tipi sayımını engeller (parmak izi yüzeyini azaltır)
        @{Ad="DefaultLocalFontsSetting";             Deger=2; Tur="DWord"}
        # Seri portlar — Seri API erişimini varsayılan olarak engeller
        @{Ad="DefaultSerialGuardSetting";            Deger=2; Tur="DWord"}
        # Boşta algılama — site kullanıcı boşta durumu erişimini varsayılan olarak engeller
        @{Ad="DefaultIdleDetectionSetting";          Deger=2; Tur="DWord"}
        # Misafir modu — tarayıcı misafir profili oluşturmayı engeller
        @{Ad="BrowserGuestModeEnabled";              Deger=0; Tur="DWord"}
        # Kişi ekleme — kullanıcı yöneticisinden yeni profil eklemeyi engeller
        @{Ad="BrowserAddPersonEnabled";              Deger=0; Tur="DWord"}
        # Otomatik doldurma içe aktarma — diğer tarayıcılardan otomatik doldurma verisi alımını engeller
        @{Ad="ImportAutofillFormData";               Deger=0; Tur="DWord"}
        # Geçmiş içe aktarma — diğer tarayıcılardan gezinti geçmişi alımını engeller
        @{Ad="ImportHistory";                        Deger=0; Tur="DWord"}
        # Parola içe aktarma — diğer tarayıcılardan kayıtlı parola alımını engeller
        @{Ad="ImportSavedPasswords";                 Deger=0; Tur="DWord"}
        # Arama motoru içe aktarma — diğer tarayıcılardan arama motoru ayarları alımını engeller
        @{Ad="ImportSearchEngine";                   Deger=0; Tur="DWord"}
        # Ana sayfa içe aktarma — diğer tarayıcılardan ana sayfa ayarları alımını engeller
        @{Ad="ImportHomepage";                       Deger=0; Tur="DWord"}
    )

    "Strict" = @(
        # ─── Azami Gizlilik — bazı kullanım ödünleri olabilir ───

        # Çeviri — yerleşik çeviriyi kapatır (metnin Google'a gönderilmesini durdurur)
        @{Ad="TranslateEnabled";                     Deger=0; Tur="DWord"}
        # Pano — site pano okuma/yazma erişimini varsayılan olarak engeller
        @{Ad="DefaultClipboardSetting";              Deger=2; Tur="DWord"}
        # Dosya sistemi okuma — site dosya sistemi okuma erişimini varsayılan olarak engeller
        @{Ad="DefaultFileSystemReadGuardSetting";    Deger=2; Tur="DWord"}
        # Dosya sistemi yazma — site dosya sistemi yazma erişimini varsayılan olarak engeller
        @{Ad="DefaultFileSystemWriteGuardSetting";   Deger=2; Tur="DWord"}
        # Güvensiz içerik — karma içeriği (HTTPS sayfada HTTP) varsayılan olarak engeller
        @{Ad="DefaultInsecureContentSetting";        Deger=2; Tur="DWord"}
        # JavaScript JIT — JIT derlemeyi kapatır (saldırı yüzeyini azaltır)
        @{Ad="DefaultJavaScriptJitSetting";          Deger=2; Tur="DWord"}
        # Çerezler — tüm çerezleri varsayılan olarak engeller (oturum bağımlı siteleri etkileyebilir)
        @{Ad="DefaultCookiesSetting";                Deger=2; Tur="DWord"}
        # Yer imi içe aktarma — diğer tarayıcılardan yer imi alımını engeller
        @{Ad="ImportBookmarks";                      Deger=0; Tur="DWord"}
        # Birinci taraf depolama — sekme/gezinti sonunda temizle (her oturumda login kaybı)
        @{Ad="DefaultBraveRemember1PStorageSetting"; Deger=2; Tur="DWord"}
    )
}


# ─────────────────────────────────────────────────────────────────────────────
# POLİTİKA BİRLEŞTİRME (Kümülatif)
# ─────────────────────────────────────────────────────────────────────────────
$KatmanSirasi = @("BraveOnly", "Essential", "Balanced", "Advanced", "Strict")

$BirlestirilmisPolitikalar = @{}
$SecilenIndex = [array]::IndexOf($KatmanSirasi, $SeviyeAnahtar)

if ($SecilenIndex -eq -1) {
    Write-Host "İç hata: geçersiz katman '$Seviye'. Çıkılıyor." -ForegroundColor Red
    exit 1
}

for ($i = 0; $i -le $SecilenIndex; $i++) {
    foreach ($Politika in $PolitikaTanimlari[$KatmanSirasi[$i]]) {
        $BirlestirilmisPolitikalar[$Politika.Ad] = $Politika
    }
}

$ToplamPolitikaSayisi = $BirlestirilmisPolitikalar.Count
Write-Host "[BİLGİ] '$Seviye' katmanı $ToplamPolitikaSayisi politika uygulayacak.`n" -ForegroundColor DarkGray


# ─────────────────────────────────────────────────────────────────────────────
# KAYIT DEFTERİ YAZMA YARDIMCISI
# ─────────────────────────────────────────────────────────────────────────────
function Yaz-KayitDegeri {
    param(
        [string]$HedefYol,
        [string]$PolitikaAdi,
        $PolitikaDegeri,
        [string]$DegerTuru,
        [switch]$WhatIf
    )

    $goruntulenecekDeger = switch ($DegerTuru) {
        "DWord"      { "dword:$PolitikaDegeri" }
        "String"     { "sz:`"$PolitikaDegeri`"" }
        "MultiString" { "multi-sz:`"$(if ($PolitikaDegeri) { $PolitikaDegeri -join ';' } else { 'boş' })`"" }
        default      { "unknown:$PolitikaDegeri" }
    }

    if ($WhatIf) {
        Write-Host "  [WhatIf] $(($HedefYol -replace '^HKLM:\\', 'HKLM\')) :: $PolitikaAdi -> $goruntulenecekDeger" -ForegroundColor Magenta
        return $goruntulenecekDeger
    }

    switch ($DegerTuru) {
        "DWord" {
            New-ItemProperty -Path $HedefYol -Name $PolitikaAdi -Value $PolitikaDegeri -PropertyType DWord -Force -ErrorAction Stop | Out-Null
            break
        }
        "String" {
            New-ItemProperty -Path $HedefYol -Name $PolitikaAdi -Value $PolitikaDegeri -PropertyType String -Force -ErrorAction Stop | Out-Null
            break
        }
        "MultiString" {
            $kayitYolu = $HedefYol -replace "^HKLM:\\", "HKLM\"
            $anahtar = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SOFTWARE\Policies\BraveSoftware\Brave", $true)
            if (-not $anahtar) {
                throw "Kayıt defteri anahtarı bulunamadı: $kayitYolu"
            }
            if ($PolitikaDegeri -and $PolitikaDegeri.Count -gt 0) {
                $anahtar.SetValue($PolitikaAdi, [string[]]$PolitikaDegeri, [Microsoft.Win32.RegistryValueKind]::MultiString)
            } else {
                $anahtar.SetValue($PolitikaAdi, [string[]]@(), [Microsoft.Win32.RegistryValueKind]::MultiString)
            }
            $anahtar.Close()
            break
        }
        default {
            throw "Desteklenmeyen tür: $DegerTuru"
        }
    }

    return $goruntulenecekDeger
}


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 1: ÖZYİNELEMELİ TARAMA, DEĞİŞKEN GUID ÇÖZÜMLEMESİ VE OMAHA BİLGİ AKTARIMI KAPATMA
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[1/7] Değişken Kimlik Numaraları (GUID) Taranıyor..." -ForegroundColor Gray

$KokYol            = "HKCU:\Software\BraveSoftware"
$OmahaBasarili     = 0
$OmahaHata         = 0

$DinamikYollar = if (Test-Path "$KokYol\Update\ClientState") {
    Get-ChildItem -Path "$KokYol\Update\ClientState" -Recurse -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Name |
        ForEach-Object {
            $BicimliYol = $_ -replace "HKEY_CURRENT_USER", "HKCU:"
            if ($BicimliYol -match "\\\{[a-fA-F0-9-]+\}$") {
                Write-Host "  -> [Değişken GUID Tespit Edildi]: $BicimliYol" -ForegroundColor Yellow
                $BicimliYol
            }
        }
}

if ($DinamikYollar) {
    Write-Host "  [*] Omaha Güncelleyici Bilgi Aktarımı Kapatılıyor..." -ForegroundColor Gray
    foreach ($GUIDYolu in $DinamikYollar) {
        try {
            $etiket = if ($WhatIf) { "[WhatIf]" } else { "[OK]" }
            $renk   = if ($WhatIf) { "Magenta" } else { "DarkGreen" }
            if (-not $WhatIf) {
                New-ItemProperty -Path $GUIDYolu -Name "usagestats" -Value 0 -PropertyType DWord -Force | Out-Null
            }
            $OmahaBasarili++
            Write-Host "  $etiket $GUIDYolu -> usagestats = 0" -ForegroundColor $renk
        } catch {
            $OmahaHata++
            Write-Host "  [HATA] $GUIDYolu -> usagestats yazılamadı: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    Write-Host "  -> Omaha: $OmahaBasarili başarılı / $OmahaHata başarısız`n" -ForegroundColor DarkGray
} else {
    Write-Host "  -> Bilgi: Sistemde dinamik güncelleme kimliği bulunamadı veya alan zaten kararlı.`n" -ForegroundColor DarkGray
}


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 2: HKLM POLİTİKA KOVASI YEDEKLEME
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[2/7] HKLM Politika Kovası Yedekleniyor..." -ForegroundColor Gray

if ($WhatIf) {
    Write-Host "  -> [WhatIf] Yedekleme atlandı (yalnızca önizleme).`n" -ForegroundColor Magenta
} elseif (Test-Path $HKLM_Hedef) {
    $YedekKlasor = "$env:TEMP\BravePolicyBackup"
    New-Item -Path $YedekKlasor -ItemType Directory -Force | Out-Null

    $YedekDosya = "$YedekKlasor\HKLM_BravePolicy_$(Get-Date -Format 'yyyyMMdd_HHmmss').reg"
    $HKLMDuzyol = $HKLM_Hedef -replace "HKLM:\\", "HKLM\"

    try {
        reg export "$HKLMDuzyol" "$YedekDosya" /y 2>&1 | Out-Null
        Write-Host "  -> Yedek oluşturuldu  : $YedekDosya" -ForegroundColor DarkGreen
        Write-Host "  -> Geri yüklemek için : reg import `"$YedekDosya`"`n" -ForegroundColor DarkGray
    } catch {
        Write-Host "  -> Uyarı: Yedek alınamadı. Betik devam ediyor." -ForegroundColor Yellow
        Write-Host "  -> Sebep : $($_.Exception.Message)`n" -ForegroundColor DarkGray
    }
} else {
    Write-Host "  -> Bilgi: HKLM politika kovası henüz mevcut değil, yedek atlandı.`n" -ForegroundColor DarkGray
}


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 3: HEDEF DİZİN YAPISI HAZIRLIĞI
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[3/7] Kayıt Defteri Hedef Dizin Yapısı Hazırlanıyor..." -ForegroundColor Gray

if ($WhatIf) {
    Write-Host "  [WhatIf] HKCU: $HKCU_Hedef" -ForegroundColor Magenta
    Write-Host "  [WhatIf] HKLM: $HKLM_Hedef`n" -ForegroundColor Magenta
} else {
    New-Item -Path $HKCU_Hedef -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Host "  -> HKCU: $HKCU_Hedef" -ForegroundColor DarkGray

    New-Item -Path $HKLM_Hedef -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Host "  -> HKLM: $HKLM_Hedef`n" -ForegroundColor DarkGray
}


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 4: HKCU — KULLANICI DÜZEYİNDE BİLGİ AKTARIMI TERCİHİ
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[4/7] HKCU Kullanıcı Bilgi Aktarımı Tercihi Uygulanıyor..." -ForegroundColor Gray

$HKCUBasarili = $false

$etiket = if ($WhatIf) { "[WhatIf]" } else { "[OK]" }
$renk   = if ($WhatIf) { "Magenta" } else { "White" }

try {
    if (-not $WhatIf) {
        New-ItemProperty -Path $HKCU_Hedef -Name "UsageStatsInSample" -Value 0 -PropertyType DWord -Force | Out-Null
    }
    $HKCUBasarili = $true
    Write-Host "  $etiket UsageStatsInSample -> dword:00000000 (Kullanıcı Düzeyi Bilgi Aktarımı Devre Dışı)`n" -ForegroundColor $renk
} catch {
    Write-Host "  [HATA] UsageStatsInSample yazılamadı: $($_.Exception.Message)`n" -ForegroundColor Red
}


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 5: KURUMSAL POLİTİKA ENJEKSİYONU (Çok Katmanlı, Çok Türlü)
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[5/7] Kurumsal Politikalar İşleniyor (Katman: $Seviye)..." -ForegroundColor Gray

$BasariliSayaci = 0
$HataSayaci     = 0

$turSayaclari = @{ "DWord" = 0; "String" = 0; "MultiString" = 0 }

foreach ($Kural in $BirlestirilmisPolitikalar.Values) {
    try {
        $goruntulenecekDeger = Yaz-KayitDegeri -HedefYol $HKLM_Hedef -PolitikaAdi $Kural.Ad -PolitikaDegeri $Kural.Deger -DegerTuru $Kural.Tur -WhatIf:$WhatIf
        if (-not $WhatIf) {
            $turSayaclari[$Kural.Tur]++
            $BasariliSayaci++
            Write-Host "  [OK] $($Kural.Ad) -> $goruntulenecekDeger" -ForegroundColor Gray
        } else {
            $turSayaclari[$Kural.Tur]++
            $BasariliSayaci++
        }
    } catch {
        $HataSayaci++
        Write-Host "  [HATA] $($Kural.Ad): $($_.Exception.Message)" -ForegroundColor Red
    }
}


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 6: EK HKCU AYARLARI
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[6/7] Ek HKCU Ayarları Uygulanıyor..." -ForegroundColor Gray

$etiket = if ($WhatIf) { "[WhatIf]" } else { "[OK]" }
$renk   = if ($WhatIf) { "Magenta" } else { "DarkGreen" }

try {
    if (-not $WhatIf) {
        New-ItemProperty -Path $HKCU_Hedef -Name "ChromeVariations" -Value 1 -PropertyType DWord -Force | Out-Null
    }
    Write-Host "  $etiket ChromeVariations (HKCU) -> dword:1" -ForegroundColor $renk
} catch {
    Write-Host "  [UYARI] ChromeVariations (HKCU) ayarlanamadı: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 7: ÖZET RAPORU VE DOĞRULAMA KILAVUZU
# ─────────────────────────────────────────────────────────────────────────────
$AyracCizgisi = "-" * 62

Write-Host "`n$AyracCizgisi" -ForegroundColor DarkGray
Write-Host "  İŞLEM ÖZET RAPORU" -ForegroundColor Cyan
Write-Host "  Betik Sürümü      : $BetikSurum" -ForegroundColor White
Write-Host "  Katman             : $Seviye ($ToplamPolitikaSayisi politika)" -ForegroundColor White
if ($WhatIf) { Write-Host "  Mod                : -WhatIf (yalnızca önizleme)" -ForegroundColor Magenta }
Write-Host $AyracCizgisi -ForegroundColor DarkGray

$HKCUDurum = if ($HKCUBasarili) { "Uygulandı" } else { "Başarısız" }
Write-Host "  Omaha GUID Kaydı   : $OmahaBasarili başarılı / $OmahaHata başarısız" -ForegroundColor Gray
Write-Host "  HKCU Tercihi       : UsageStatsInSample    → $HKCUDurum" -ForegroundColor Gray
Write-Host "  HKLM Politikaları  : $BasariliSayaci uygulandı / $HataSayaci başarısız" -ForegroundColor Gray
Write-Host "  Tür Dağılımı       : DWord=$($turSayaclari.DWord) / String=$($turSayaclari.String) / MultiString=$($turSayaclari.MultiString)" -ForegroundColor Gray
Write-Host $AyracCizgisi -ForegroundColor DarkGray

if ($HataSayaci -gt 0) {
    Write-Host "`n  [UYARI] $HataSayaci politika yazılamadı. Lütfen" -ForegroundColor Yellow
    Write-Host "            yukarıdaki HATA satırlarını inceleyin ve gerekli" -ForegroundColor Yellow
    Write-Host "            izinleri kontrol edin." -ForegroundColor Yellow
}

if (-not $WhatIf -and ($BasariliSayaci -gt 0 -or $OmahaBasarili -gt 0)) {
    Write-Host "`n  [BAŞARILI] $Seviye kurumsal gizlilik politikaları" -ForegroundColor Green
    Write-Host "            Windows 11 25H2 üzerinde Brave'e başarıyla uygulandı." -ForegroundColor Green
    Write-Host "            Brave'i tamamen kapatıp yeniden açtığınızda" -ForegroundColor White
    Write-Host "            değişiklikler etkili olacaktır.`n" -ForegroundColor White
}

if ($WhatIf) {
    Write-Host "  [WhatIf] Hiçbir kayıt defteri değişikliği yapılmadı. Uygulamak için -WhatIf kullanmadan çalıştırın.`n" -ForegroundColor Magenta
}

Write-Host "  DOĞRULAMA:" -ForegroundColor Cyan
Write-Host "  1. Aktif politikalar : brave://policy" -ForegroundColor DarkGray
Write-Host "  2. Kayıt defteri yolu: HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -ForegroundColor DarkGray
Write-Host "  3. Yedek konumu      : `$env:TEMP\BravePolicyBackup\" -ForegroundColor DarkGray
Write-Host "  4. Geri alma komutu  : reg import `"<yedek_dosyasi.reg>`"`n" -ForegroundColor DarkGray

# Çıkış kodu
if ($HataSayaci -gt 0) { exit 1 } else { exit 0 }
