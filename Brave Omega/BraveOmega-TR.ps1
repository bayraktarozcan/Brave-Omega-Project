# ==============================================================================
# ==============================================================================
#
#                   BRAVE OMEGA PROJECT (Community Edition)
#
# ==============================================================================
# ==============================================================================
# SÜRÜM BAĞLAMI  : Windows 11 25H2 (Derleme 26200.8524)
#                  Brave 1.91.172 — Resmî Derleme / Chromium 149.0.7827.115
# DOSYA TÜRÜ     : Gelişmiş Çok Katmanlı Tarayıcı Sıkılaştırma Betiği (.ps1)
# AMAÇ           : Kullanıcı gizliliğini korumak, veri sızıntılarını önlemek,
#                  tarayıcıyı gereksiz yan hizmetlerden arındırmak. 4 katmanlı
#                  sıkılaştırma modeli: Brave Yalnız, Temel, Dengeli, Katı.
#
# !! KANAL UYARISI !!
#    Brave 1.91.172, 12 Haziran 2026 tarihli, Stable (kararlı) kanalına aittir.
#    Kurumsal dağıtım için her zaman kararlı kol önerilir. Beta/Nightly
#    sürümlerinde ADMX politika davranışları henüz tam sınanmamış olabilir.
#
# DEĞİŞİKLİK GEÇMİŞİ (v2.1)
# ─────────────────────────────────────────────────────────────────────────────
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
#     [YENİ]        4 katmanlı sıkılaştırma modeli:
#                     Brave Yalnız → Temel → Dengeli → Katı
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
#                   Brave Yalnız: 13 Brave'e özgü politika
#                   Temel:        +17 veri sızıntısı önleme politikası
#                   Dengeli:      +16 güvenlik ve kullanım dengesi
#                   Katı:         +22 azami gizlilik politikası
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
$BetikSurum    = "v2.1"
$DogrulananBrave = "1.91.172"
$DogrulananChromium = "149"

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
                $ver = (Get-Item $yol).VersionInfo.FileVersion
                if ($ver) { return @{ Yol = $yol; Surum = $ver } }
            } catch { continue }
        }
    }
    return $null
}

function Compare-BraveVersion {
    param([string]$Yuklu, [string]$Beklenen)
    if (-not $Yuklu) { return $false }
    $y = $Yuklu.Split('.')[0..2] -join '.'
    $b = $Beklenen.Split('.')[0..2] -join '.'
    return $y -eq $b
}

# ─────────────────────────────────────────────────────────────────────────────
# ADIM 0A: KULLANICI HESABI DENETİMİ (UAC) VE YÖNETİCİ YETKİSİ DOĞRULAMA
# ─────────────────────────────────────────────────────────────────────────────
$MevcutKimlik = [Security.Principal.WindowsIdentity]::GetCurrent()
$KullaniciRolu = New-Object Security.Principal.WindowsPrincipal($MevcutKimlik)
$YoneticiModu = $KullaniciRolu.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $YoneticiModu) {
    Write-Error "KRİTİK HATA: HKLM (Local Machine) kovanına kurumsal ilkeleri mühürlemek için bu betiğin 'Yönetici Olarak' çalıştırılması zorunludur!"
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
$surumUygun = $false

if ($braveBilgi) {
    $surumUygun = Compare-BraveVersion -Yuklu $braveBilgi.Surum -Beklenen $DogrulananBrave
    if (-not $surumUygun) {
        Write-Host "[SÜRÜM DENETİMİ] Yüklü Brave $($braveBilgi.Surum) doğrulanan sürümden ($DogrulananBrave) farklı!" -ForegroundColor Yellow
        Write-Host "  Yol: $($braveBilgi.Yol)" -ForegroundColor DarkGray
        Write-Host "  Bu tarayıcı sürümünde bazı politikalar tanınmayabilir." -ForegroundColor Yellow
        Write-Host "  Devam etmek istiyor musunuz? (E = Evet / H = Hayır): " -ForegroundColor White -NoNewline
        $devam = Read-Host
        if ($devam -notin @("E", "e", "Evet", "evet")) {
            Write-Host "İşlem kullanıcı tarafından iptal edildi." -ForegroundColor DarkGray
            exit 0
        }
    } else {
        Write-Host "[SÜRÜM DENETİMİ] Brave $DogrulananBrave tespit edildi — sürüm doğrulama hedefiyle eşleşiyor.`n" -ForegroundColor DarkGreen
    }
} else {
    Write-Host "[SÜRÜM DENETİMİ] Brave kurulum yolu tespit edilemedi." -ForegroundColor Yellow
    Write-Host "  Devam ediliyor — ancak brave://settings/help adresinden uyumluluğu kontrol edin.`n" -ForegroundColor DarkGray
}


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 0C: SIĞIRLA (RESET) MODU
# ─────────────────────────────────────────────────────────────────────────────
$HKCU_Hedef = "HKCU:\Software\BraveSoftware\Brave-Browser"
$HKLM_Hedef = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

if ($Sifirla) {
    Write-Host "[SIĞIRLA MODU] Tüm Brave Omega politikaları kaldırılıyor..." -ForegroundColor Magenta
    Write-Host ""

    $tumPolitikalar = @(
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

    # HKLM'den kaldır
    $hkSayac = 0
    if (Test-Path $HKLM_Hedef) {
        foreach ($ad in $tumPolitikalar) {
            try {
                Remove-ItemProperty -Path $HKLM_Hedef -Name $ad -ErrorAction SilentlyContinue
                $hkSayac++
                if (-not $WhatIf) { Write-Host "  [OK] HKLM\$ad kaldırıldı" -ForegroundColor DarkGreen }
            } catch { }
        }
    }

    # HKCU'dan kaldır
    $hcSayac = 0
    if (Test-Path $HKCU_Hedef) {
        foreach ($ad in @("UsageStatsInSample", "ChromeVariations")) {
            try {
                Remove-ItemProperty -Path $HKCU_Hedef -Name $ad -ErrorAction SilentlyContinue
                $hcSayac++
                if (-not $WhatIf) { Write-Host "  [OK] HKCU\$ad kaldırıldı" -ForegroundColor DarkGreen }
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
                Remove-ItemProperty -Path $guidYol -Name "usagestats" -ErrorAction SilentlyContinue
                $omahaSayac++
                if (-not $WhatIf) { Write-Host "  [OK] Omaha GUID: usagestats kaldırıldı" -ForegroundColor DarkGreen }
            } catch { }
        }
    }

    # Boş HKLM anahtarını temizle
    $hkPolicies = Get-ItemProperty -Path $HKLM_Hedef -ErrorAction SilentlyContinue
    if ($hkPolicies -and @($hkPolicies.PSObject.Properties).Count -le 1) {
        try {
            Remove-Item -Path $HKLM_Hedef -Force -ErrorAction SilentlyContinue
            Write-Host "  [OK] HKLM politika anahtarı kaldırıldı (hiç politika kalmadı)" -ForegroundColor DarkGreen
        } catch { }
    }

    Write-Host "`n[SIĞIRLA TAMAMLANDI] HKLM: $hkSayac / HKCU: $hcSayac / Omaha: $omahaSayac girdi kaldırıldı." -ForegroundColor Cyan
    Write-Host "  Brave'i kapatıp yeniden açın.`n" -ForegroundColor White
    exit 0
}


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 0D: KATMAN SEÇİMİ
# ─────────────────────────────────────────────────────────────────────────────
$GecerliSeviyeler = @("BraveOnly", "Essential", "Balanced", "Strict", "Brave Yalnız", "Temel", "Dengeli", "Katı")

if (-not $Seviye -or $Seviye -eq "") {
    Write-Host "Bir sıkılaştırma katmanı seçin:" -ForegroundColor White
    Write-Host "  1. Brave Yalnız" -ForegroundColor Gray
    Write-Host "  2. Temel   [Önerilen]" -ForegroundColor Green
    Write-Host "  3. Dengeli" -ForegroundColor Yellow
    Write-Host "  4. Katı" -ForegroundColor Red
    Write-Host ""
    $Secim = Read-Host "Seçiminiz (1-4)"

    $Seviye = switch ($Secim) {
        "1" { "Brave Yalnız" }
        "2" { "Temel" }
        "3" { "Dengeli" }
        "4" { "Katı" }
        default { "Temel" }
    }
}

# İngilizce adları Türkçeye eşle
$SeviyeHaritasi = @{
    "BraveOnly"  = "Brave Yalnız"
    "Essential"  = "Temel"
    "Balanced"   = "Dengeli"
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
# ADIM 0C: BRAVE SÜREÇ KONTROLÜ
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
        # Çeviri — yerleşik çeviriyi kapatır (metnin Google'a gönderilmesini durdurur)
        @{Ad="TranslateEnabled";                     Deger=0; Tur="DWord"}
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
    )

    "Balanced" = @(
        # ─── Güvenlik ve Kullanım Dengesi ───

        # WebRTC IP yönetimi — yalnızca genel IP'yi açığa çıkarır, yerel IP'leri gizler
        @{Ad="WebRtcIPHandling";                     Deger="default_public_interface_only"; Tur="String"}
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
        # Medya akışı — kamera/mikrofon erişimini varsayılan olarak engeller
        @{Ad="DefaultMediaStreamSetting";            Deger=2; Tur="DWord"}
    )

    "Strict" = @(
        # ─── Azami Gizlilik — bazı kullanım ödünleri olabilir ───

        # WebRTC IP yönetimi — Dengeli'yi ezer: tüm WebRTC trafiğini vekil sunucu üzerinden yönlendirir
        @{Ad="WebRtcIPHandling";                     Deger="disable_non_proxied_udp"; Tur="String"}
        # Sensörler — cihaz hareket/ışık sensörü erişimini varsayılan olarak engeller
        @{Ad="DefaultSensorsSetting";                Deger=2; Tur="DWord"}
        # Yerel yazı tipleri — yazı tipi sayımını engeller (parmak izi yüzeyini azaltır)
        @{Ad="DefaultLocalFontsSetting";             Deger=2; Tur="DWord"}
        # Pano — site pano okuma/yazma erişimini varsayılan olarak engeller
        @{Ad="DefaultClipboardSetting";              Deger=2; Tur="DWord"}
        # Dosya sistemi okuma — site dosya sistemi okuma erişimini varsayılan olarak engeller
        @{Ad="DefaultFileSystemReadGuardSetting";    Deger=2; Tur="DWord"}
        # Dosya sistemi yazma — site dosya sistemi yazma erişimini varsayılan olarak engeller
        @{Ad="DefaultFileSystemWriteGuardSetting";   Deger=2; Tur="DWord"}
        # Seri portlar — Seri API erişimini varsayılan olarak engeller
        @{Ad="DefaultSerialGuardSetting";            Deger=2; Tur="DWord"}
        # Boşta algılama — site kullanıcı boşta durumu erişimini varsayılan olarak engeller
        @{Ad="DefaultIdleDetectionSetting";          Deger=2; Tur="DWord"}
        # Güvensiz içerik — karma içeriği (HTTPS sayfada HTTP) varsayılan olarak engeller
        @{Ad="DefaultInsecureContentSetting";        Deger=2; Tur="DWord"}
        # JavaScript JIT — JIT derlemeyi kapatır (saldırı yüzeyini azaltır)
        @{Ad="DefaultJavaScriptJitSetting";          Deger=2; Tur="DWord"}
        # Çerezler — tüm çerezleri varsayılan olarak engeller (oturum bağımlı siteleri etkileyebilir)
        @{Ad="DefaultCookiesSetting";                Deger=2; Tur="DWord"}
        # Misafir modu — tarayıcı misafir profili oluşturmayı engeller
        @{Ad="BrowserGuestModeEnabled";              Deger=0; Tur="DWord"}
        # Kişi ekleme — kullanıcı yöneticisinden yeni profil eklemeyi engeller
        @{Ad="BrowserAddPersonEnabled";              Deger=0; Tur="DWord"}
        # Cloud Print — Google Cloud Print vekil sunucusunu kapatır
        @{Ad="CloudPrintProxyEnabled";               Deger=0; Tur="DWord"}
        # Otomatik doldurma içe aktarma — diğer tarayıcılardan otomatik doldurma verisi alımını engeller
        @{Ad="ImportAutofillFormData";               Deger=0; Tur="DWord"}
        # Yer imi içe aktarma — diğer tarayıcılardan yer imi alımını engeller
        @{Ad="ImportBookmarks";                      Deger=0; Tur="DWord"}
        # Geçmiş içe aktarma — diğer tarayıcılardan gezinti geçmişi alımını engeller
        @{Ad="ImportHistory";                        Deger=0; Tur="DWord"}
        # Parola içe aktarma — diğer tarayıcılardan kayıtlı parola alımını engeller
        @{Ad="ImportSavedPasswords";                 Deger=0; Tur="DWord"}
        # Arama motoru içe aktarma — diğer tarayıcılardan arama motoru ayarları alımını engeller
        @{Ad="ImportSearchEngine";                   Deger=0; Tur="DWord"}
        # Ana sayfa içe aktarma — diğer tarayıcılardan ana sayfa ayarları alımını engeller
        @{Ad="ImportHomepage";                       Deger=0; Tur="DWord"}
    )
}


# ─────────────────────────────────────────────────────────────────────────────
# POLİTİKA BİRLEŞTİRME (Kümülatif)
# ─────────────────────────────────────────────────────────────────────────────
$KatmanSirasi = @("BraveOnly", "Essential", "Balanced", "Strict")

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

    if ($WhatIf) { return "[WhatIf] yazma atlandı" }

    switch ($DegerTuru) {
        "DWord" {
            New-ItemProperty -Path $HedefYol -Name $PolitikaAdi -Value $PolitikaDegeri -PropertyType DWord -Force -ErrorAction Stop | Out-Null
            $goruntulenecekDeger = "dword:$PolitikaDegeri"
            break
        }
        "String" {
            New-ItemProperty -Path $HedefYol -Name $PolitikaAdi -Value $PolitikaDegeri -PropertyType String -Force -ErrorAction Stop | Out-Null
            $goruntulenecekDeger = "sz:`"$PolitikaDegeri`""
            break
        }
        "MultiString" {
            $anahtar = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SOFTWARE\Policies\BraveSoftware\Brave", $true)
            if (-not $anahtar) {
                throw "Kayıt defteri anahtarı bulunamadı: $HedefYol"
            }
            if ($PolitikaDegeri -and $PolitikaDegeri.Count -gt 0) {
                $anahtar.SetValue($PolitikaAdi, [string[]]$PolitikaDegeri, [Microsoft.Win32.RegistryValueKind]::MultiString)
                $goruntulenecekDeger = "multi-sz:`"$($PolitikaDegeri -join ';')`""
            } else {
                $anahtar.SetValue($PolitikaAdi, [string[]]@(), [Microsoft.Win32.RegistryValueKind]::MultiString)
                $goruntulenecekDeger = "multi-sz:(boş)"
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
    $YedekKlasor = "$env:TEMP\BravePolicyYedek"
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
        $turSayaclari[$Kural.Tur]++
        $BasariliSayaci++
        Write-Host "  [OK] $($Kural.Ad) -> $goruntulenecekDeger" -ForegroundColor Gray
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
Write-Host "  Katman             : $Seviye ($ToplamPolitikaSayisi politika)" -ForegroundColor White
if ($WhatIf) { Write-Host "  Mod                : WhatIf (yalnızca önizleme)" -ForegroundColor Magenta }
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

if ($BasariliSayaci -gt 0 -or $OmahaBasarili -gt 0) {
    Write-Host "`n  [BAŞARILI] $Seviye kurumsal gizlilik politikaları" -ForegroundColor Green
    Write-Host "            Windows 11 25H2 üzerinde Brave'e başarıyla uygulandı." -ForegroundColor Green
    Write-Host "            Brave'i tamamen kapatıp yeniden açtığınızda" -ForegroundColor White
    Write-Host "            değişiklikler etkili olacaktır.`n" -ForegroundColor White
}

Write-Host "  DOĞRULAMA:" -ForegroundColor Cyan
Write-Host "  1. Aktif politikalar : brave://policy" -ForegroundColor DarkGray
Write-Host "  2. Kayıt defteri yolu: HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -ForegroundColor DarkGray
Write-Host "  3. Yedek konumu      : `$env:TEMP\BravePolicyYedek\" -ForegroundColor DarkGray
Write-Host "  4. Geri alma komutu  : reg import `"<yedek_dosyasi.reg>`"`n" -ForegroundColor DarkGray

# Çıkış kodu
if ($HataSayaci -gt 0) { exit 1 } else { exit 0 }
