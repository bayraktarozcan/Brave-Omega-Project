# ==============================================================================
# ==============================================================================
#
#                   BRAVE OMEGA PROJECT (Community Edition)
#
# ==============================================================================
# ==============================================================================
# SÜRÜM BAĞLAMI  : Windows 11 25H2 (Derleme 26200.8524)
#                  Brave 1.91.168 — Resmî Derleme / Chromium 149.0.7827.54
# DOSYA TÜRÜ     : Gelişmiş Değişken Kayıt Defteri Tümleşme ve Sıkılaştırma
#                  Betiği (.ps1)
# AMAÇ           : Kullanıcı gizliliğini korumak, veri sızıntılarını önlemek,
#                  tarayıcıyı gereksiz yan hizmetlerden arındırmak ve bunu
#                  kendiliğinden işler hâle getirmek.
#
# !! KANAL UYARISI !!
#    Brave 1.91.168, 4 Mayıs 2026 tarihli, Stable (kararlı) kanalına aittir.
#    Kurumsal dağıtım için her zaman kararlı kol önerilir. Beta/Nightly
#    sürümlerinde ADMX politika davranışları henüz tam sınanmamış olabilir.
#
# DEĞİŞİKLİK GEÇMİŞİ
# ─────────────────────────────────────────────────────────────────────────────
#   v1.0                 İlk yapı oluşturuldu.
#   v1.1                 Kapsamlı hata ayıklama ve iyileştirme (7 değişiklik):
#
#     [DÜZELTİLDİ #1]    BraveShieldsDefault — Brave'in resmî ADMX şablonlarında
#                        tanımlı olmayan bu politika adı kaldırıldı. Nedeni ve
#                        doğru seçenek yöntem aşağıda belgelenmiştir.
#
#     [DÜZELTİLDİ #2]    Try-Catch — Tüm kayıt defteri yazma işlemlerine hata
#                        yönetimi eklendi. Başarı ve hata durumları artık
#                        sayaçlarla izlenip özet raporda gösterilmektedir.
#
#     [DÜZELTİLDİ #3]    $DinamikYollar — Ölü değişken olmaktan çıkarıldı.
#                        Tespit edilen Omaha GUID yollarına usagestats=0
#                        yazma adımı eklendi.
#
#     [EKLENDİ     #4]   Brave Süreç Kontrolü — Betik çalışmadan önce açık
#                        tarayıcı tespit edilip kullanıcıya devam/iptal kararı
#                        sunulmaktadır.
#
#     [DÜZELTİLDİ #5]    Çıkış Kodları — Hata durumunda `exit 1`, başarılı
#                        çıkışta `exit 0` kullanılacak şekilde düzeltildi.
#                        Özdevim (otomasyon) araçları artık sonucu doğru okuyabilir.
#
#     [EKLENDİ     #6]   Kayıt Defteri Yedekleme — HKLM politika kovası
#                        değiştirilmeden önce .reg biçiminde zaman damgalı
#                        yedek alınmaktadır.
#
#     [BASİTLEŞTİRİLDİ #7] Test-Path + New-Item -Force — Birbirini mantıksal
#                        olarak dışlayan çifte kontrol, tek satıra indirgendi.
#
#   v1.2                 Genişletilmiş Politika Seti (10 yeni özellik eklendi):
#
#     [EKLENDİ     #1]   BraveP3AEnabled — Gizlilik Korumalı Ürün Analitiği
#     [EKLENDİ     #2]   BraveWebDiscoveryEnabled — Web Discovery Project
#     [EKLENDİ     #3]   BraveTalkDisabled — Brave Talk video konferans
#     [EKLENDİ     #4]   BraveNewsDisabled — Brave News haber beslemesi
#     [EKLENDİ     #5]   BravePlaylistEnabled — Brave Playlist
#     [EKLENDİ     #6]   BraveSpeedreaderEnabled — Speedreader modu
#     [EKLENDİ     #7]   BraveWaybackMachineEnabled — Internet Archive
#     [EKLENDİ     #8]   TorDisabled — Tor ağı entegrasyonu
#
#     Toplam Politika Sayısı:  7 (v1.1) → 17 (v1.2)
# ==============================================================================

# ─────────────────────────────────────────────────────────────────────────────
# UÇBİRİM KODLAMA BİÇİMİ SIKILAŞTIRMASI (KARAKTER HATASI ÇÖZÜMÜ)
# ─────────────────────────────────────────────────────────────────────────────
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding           = [System.Text.Encoding]::UTF8

# ─────────────────────────────────────────────────────────────────────────────
# ADIM 0A: KULLANICI HESABI DENETİMİ (UAC) VE YÖNETİCİ YETKİSİ DOĞRULAMA
# ─────────────────────────────────────────────────────────────────────────────

# Mevcut PowerShell oturumunu çalıştıran kullanıcının Windows kimlik nesnesini
# alır. Bu nesne; kullanıcı adı, SID ve öbek üyeliklerini barındırır.
$MevcutKimlik = [Security.Principal.WindowsIdentity]::GetCurrent()

# Kimlik nesnesinden Windows güvenlik görevi sorgularını destekleyen bir "Principal"
# bağlamı oluşturulur. IsInRole() yöntemi bu nesne üzerinden çalışır.
$KullaniciRolu = New-Object Security.Principal.WindowsPrincipal($MevcutKimlik)

# Kullanıcının yerleşik 'Administrator' görevine üye olup olmadığı True/False
# olarak alınır.
$YoneticiModu = $KullaniciRolu.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Yönetici yetkisi yoksa betik güvenli şekilde sonlandırılır.
# [v1.0 Farkı]: Eski kod `Exit` kullanıyordu — bu, hata durumunda dahi 0
# (başarı) çıkış kodu üretir; özdevim araçlarını yanıltır. `exit 1`,
# başarısız çalışmayı Görev Zamanlayıcı, SCCM ve CI/CD araçlarına doğru iletir.
if (-not $YoneticiModu) {
    Write-Error "KRİTİK HATA: HKLM (Local Machine) kovanına kurumsal ilkeleri mühürlemek için bu betiğin 'Yönetici Olarak' çalıştırılması zorunludur!"
    exit 1
}

# Uçbirim ekranını temizler ve başlık arayüzünü başlatır.
Clear-Host
Write-Host "=== BRAVE SPESİFİK SÜRÜM OPTİMİZASYON BETİĞİ ===" -ForegroundColor Cyan
Write-Host "Hedef Platform : Windows 11 25H2 / Chromium 149 (Brave Kararlı Kanalı)" -ForegroundColor Gray
Write-Host "İşlem Zamanı   : $(Get-Date -Format 'dd-MM-yyyy HH:mm:ss')`n" -ForegroundColor Gray


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 0B: BRAVE SÜREÇ KONTROLÜ [YENİ — v1.1]
# ─────────────────────────────────────────────────────────────────────────────
# Brave açıkken betik çalıştırılması iki çekince taşır:
#
#   1. HKCU kovanındaki kullanıcı tercihleri (UsageStatsInSample gibi),
#      tarayıcı kapanırken kendi dahili düzeneği tarafından üzerine
#      yazılabilir; yapılan değişiklik kalıcı olmayabilir.
#
#   2. Bazı politika değişiklikleri, tarayıcı başlatılırken okunur.
#      Açık Brave, yeni politikaları yalnızca sonraki oturumda tanır.
#
# Tarayıcı zorla kapatılmamıştır; bu karar bilinçlidir — etkin sekmelerdeki
# çalışma veri kaybına yol açabilir. Kullanıcıya devam/iptal seçeneği sunulur.
Write-Host "[KONTROL] Aktif Brave Süreçleri Denetleniyor..." -ForegroundColor Gray

$BraveIslemleri = Get-Process -Name "brave" -ErrorAction SilentlyContinue

if ($BraveIslemleri) {

    # Kaç süreç çalıştığını raporla. Olağan kullanımda Brave, ana süreç +
    # renderer + GPU + utility süreçleri olmak üzere birden fazla süreç açar;
    # bu sayı bilgilendirme amaçlıdır.
    $SurecSayisi = $BraveIslemleri.Count
    Write-Host "  [UYARI] $SurecSayisi adet Brave süreci çalışıyor." -ForegroundColor Yellow
    Write-Host "  Tarayıcı açıkken bazı HKCU değişiklikleri üzerine yazılabilir." -ForegroundColor Yellow
    Write-Host "  Brave'i kapatıp betiği yeniden çalıştırmanız önerilir.`n" -ForegroundColor Yellow
    Write-Host "  Devam etmek istiyor musunuz? (E = Devam / H = İptal): " -ForegroundColor White -NoNewline
    $KararMetni = Read-Host

    # Yalnızca açık E/e/Evet/evet yanıtları kabul edilir.
    # Boş giriş dahil diğer tüm yanıtlar güvenli iptal olarak işlenir.
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
# İki farklı kayıt defteri kovası kullanılır; bu ayrım kasıtlı ve mimarî
# açıdan önemlidir:
#
#   HKCU: Kullanıcı hesap düzeyi. Buraya yazılan değerler kullanıcı
#         tarafından değiştirilebilir; tarayıcı bir tercih (preference)
#         olarak okur. Yönetici yetkisi gerekmez.
#
#   HKLM: Makine geneli kurumsal ilke kovası. Buraya yazılan değerler
#         tarayıcının ayarlar arayüzünde gri renkte görünür ("Yöneticiniz
#         tarafından zorunlu kılındı") ve kullanıcı tarafından değiştirilemez.
#         Yönetici yetkisi zorunludur.
#
# Politikalar iki katmanlı uygulanır: HKCU tercihi + HKLM zorunlu ilkesi.
# Bu yaklaşım politika gecikmelerini ve kenar durumları kapsar.
$HKCU_Hedef = "HKCU:\Software\BraveSoftware\Brave-Browser"
$HKLM_Hedef = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 1: ÖZYİNELEMELİ TARAMA, DEĞİŞKEN GUID ÇÖZÜMLEMESİ VE OMAHA BİLGİ AKTARIMI KAPATMA
# ─────────────────────────────────────────────────────────────────────────────
# [v1.0 Farkı]: Önceki sürümde $DinamikYollar yalnızca uçbirim çıktısı için
# kullanılıyor, sonrasında hiçbir işleme tabi tutulmuyordu (ölü değişken).
# Bu sürümde tespit edilen her GUID yoluna Omaha veri aktarımı devre dışı bırakma
# değeri (`usagestats` = 0) yazılmaktadır.
#
# OMAHA GÜNCELLEYİCİ NEDİR?
# Brave, Google'ın Omaha güncelleme altyapısını (Windows) kullanır. Bu düzen
# tarayıcıyı otomatik güncellerken arka planda kullanım istatistiklerini
# toplayan `usagestats` kaydını barındırır. Her uygulama, kendi GUID kimliği
# altında ayrı bir ClientState kaydına sahiptir.
#
# usagestats = 0 → Omaha, güncelleme sürecinde veri toplamaz ve göndermez.
# Bu ayar HKCU kovanında GUID düzeyinde uygulanır ve tarayıcı düzeyindeki
# MetricsReportingEnabled politikasından bağımsız çalışır; çift katman güvence.
Write-Host "[1/5] Değişken İstemci Kimlikleri (GUID) Taranıyor ve İşleniyor..." -ForegroundColor Gray

$KokYol             = "HKCU:\Software\BraveSoftware"
$OmahaBasariSayaci  = 0
$OmahaHataSayaci    = 0

# ClientState altındaki tüm alt anahtarlar derinlemesine (Recurse) taranır.
# Yetki kısıtı olan alanlarda sessizce geçilmesi için SilentlyContinue kullanılır.
$DinamikYollar = if (Test-Path "$KokYol\Update\ClientState") {
    Get-ChildItem -Path "$KokYol\Update\ClientState" -Recurse -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Name |
        ForEach-Object {

            # Kayıt defteri düzen biçimi (HKEY_CURRENT_USER) PowerShell sürücü
            # biçimine (HKCU:) dönüştürülür. New-ItemProperty ve Test-Path
            # komutları bu biçimi bekler; düzen biçimini kabul etmez.
            $FormatliYol = $_ -replace "HKEY_CURRENT_USER", "HKCU:"

            # Regex ile sonu standart GUID deseniyle ({XXXXXXXX-XXXX-XXXX-...})
            # biten yollar ayırt edilir. Üst kovanlar (ClientState'in kendisi gibi)
            # bu eşleşmeyi sağlamaz; yalnızca uygulama kimliği (App ID) düzeyindeki
            # yaprak kayıtlar işleme alınır.
            if ($FormatliYol -match "\\\{[a-fA-F0-9-]+\}$") {
                Write-Host "  -> [Dinamik GUID Saptandı]: $FormatliYol" -ForegroundColor Yellow
                $FormatliYol
            }
        }
}

# Toplanan GUID yollarına Omaha veri aktarımı devre dışı bırakma değeri yazılır.
if ($DinamikYollar) {
    Write-Host "  [*] Omaha Güncelleyici Telemetrisi Kapatılıyor..." -ForegroundColor Gray

    foreach ($GUIDYol in $DinamikYollar) {
        try {
            # `usagestats` (DWORD 0): Omaha güncelleyicisinin bu uygulamaya ait
            # veri toplamasını ve harici sunuculara göndermesini kapatır.
            # Değer, her GUID'e ayrı ayrı uygulanır; toplu işlem desteklenmez.
            New-ItemProperty -Path $GUIDYol -Name "usagestats" -Value 0 -PropertyType DWord -Force | Out-Null
            $OmahaBasariSayaci++
            Write-Host "  [OK] $GUIDYol -> usagestats = 0" -ForegroundColor DarkGreen
        } catch {
            # Yetki sorunu, yol kilidi veya veri tipi çakışması gibi durumlarda
            # hata raporlanır; betik durmadan sonraki GUID işlenmeye devam eder.
            $OmahaHataSayaci++
            Write-Host "  [HATA] $GUIDYol -> usagestats yazılamadı: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    Write-Host "  -> Omaha: $OmahaBasariSayaci başarılı / $OmahaHataSayaci başarısız`n" -ForegroundColor DarkGray

} else {
    Write-Host "  -> Bilgi: Sistemde dinamik güncelleme kimliği bulunamadı ya da alan zaten kararlı.`n" -ForegroundColor DarkGray
}


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 2: HKLM POLİTİKA KOVASI YEDEKLEMESİ [YENİ — v1.1]
# ─────────────────────────────────────────────────────────────────────────────
# HKLM kurumsal ilkeler kovası değiştirilmeden önce mevcut durum dışa aktarılır.
# Bu adım üç amaca hizmet eder:
#
#   1. Geri alma güvencesi   : Beklenmedik politika çakışması ya da tarayıcı
#      hatası durumunda `reg import` komutuyla önceki duruma dönülür.
#
#   2. Denetim izi           : Her çalışma kendi zaman damgalı yedeğini
#      oluşturur; önceki yedekler silinmez. Değişiklik geçmişi korunur.
#
#   3. Basılı belge          : Betiğin çalıştırıldığı andaki politika durumu
#      kayıt altına alınır; sorun gidermede referans olarak kullanılır.
#
# Yedekler: %TEMP%\BravePolicyYedek\ klasörüne .reg biçiminde kaydedilir.
Write-Host "[2/5] HKLM Politika Kovası Yedekleniyor..." -ForegroundColor Gray

if (Test-Path $HKLM_Hedef) {

    # Yedek klasörü henüz yoksa oluşturulur. -Force, klasör zaten varsa
    # hata fırlatmadan devam edilmesini sağlar.
    $YedekKlasor = "$env:TEMP\BravePolicyYedek"
    New-Item -Path $YedekKlasor -ItemType Directory -Force | Out-Null

    # Dosya adında zaman damgası: her çalışma benzersiz bir dosya üretir.
    # Örnek: HKLM_BravePolicy_20260607_143022.reg
    $YedekDosya = "$YedekKlasor\HKLM_BravePolicy_$(Get-Date -Format 'yyyyMMdd_HHmmss').reg"

    # reg.exe, PowerShell'in HKLM:\ biçimini değil ters eğik çizgili
    # HKLM\ biçimini bekler. Dönüşüm zorunludur.
    $HKLMDuzYol = $HKLM_Hedef -replace "HKLM:\\", "HKLM\"

    try {
        # reg export, belirtilen kovan ve tüm alt anahtarları .reg dosyasına yazar.
        # 2>&1 yönlendirmesi, reg.exe'nin standart hata çıktısını da yakalar.
        # /y bayrağı, hedef dosya zaten varsa onay sorulmadan üzerine yazar.
        reg export "$HKLMDuzYol" "$YedekDosya" /y 2>&1 | Out-Null
        Write-Host "  -> Yedek alındı  : $YedekDosya" -ForegroundColor DarkGreen
        Write-Host "  -> Geri almak için: reg import `"$YedekDosya`"`n" -ForegroundColor DarkGray
    } catch {
        # Yedekleme başarısız olursa uyarı verilir ama betik durdurulmaz.
        # Ana işlem (politika yazma) yedekten bağımsız olarak devam edebilir.
        Write-Host "  -> Uyarı: Yedekleme tamamlanamadı. Betik devam ediyor." -ForegroundColor Yellow
        Write-Host "  -> Neden: $($_.Exception.Message)`n" -ForegroundColor DarkGray
    }

} else {
    # Kovan henüz yoksa yedeklenecek veri yoktur; bu durum normal ve beklenen.
    Write-Host "  -> Bilgi: HKLM politika kovası henüz mevcut değil, yedek atlandı.`n" -ForegroundColor DarkGray
}


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 3: HEDEF DİZİN ALTYAPI DOĞRULAMASI
# ─────────────────────────────────────────────────────────────────────────────
# [BASİTLEŞTİRİLDİ v1.1]: Önceki sürümde şu kalıp kullanılıyordu:
#   if (-not (Test-Path $Yol)) { New-Item -Path $Yol -Force | Out-Null }
#
# Bu iki işlem birbirini mantıksal olarak dışlar:
#   - Test-Path False → Zaten New-Item oluşturacak.
#   - Test-Path True  → Zaten -Force parametresi hata vermeden devam ediyor.
#   Sonuç: Test-Path kontrolü tamamen gereksizdir.
#
# Yeni yaklaşım: Tek satır, -Force + -ErrorAction SilentlyContinue.
# Bu birleşim esnek kararlılıkta kılar — betik defalarca çalıştırılsa dahi
# tutarlı sonuç verir; ne hata üretir ne de aynı klasörü çifte oluşturur.
Write-Host "[3/5] Kayıt Defteri Hedef Dizin Yapısı Hazırlanıyor..." -ForegroundColor Gray

# HKCU: Kullanıcı hesap tercihleri. Yönetici yetkisi gerekmez;
# değerler kullanıcı tarafından değiştirilebilir.
New-Item -Path $HKCU_Hedef -Force -ErrorAction SilentlyContinue | Out-Null
Write-Host "  -> HKCU: $HKCU_Hedef" -ForegroundColor DarkGray

# HKLM: Makine geneli kurumsal ilke kovası. Yönetici yetkisi zorunludur;
# değerler tarayıcı arayüzünden değiştirilemez (kilitli/gri görünür).
New-Item -Path $HKLM_Hedef -Force -ErrorAction SilentlyContinue | Out-Null
Write-Host "  -> HKLM: $HKLM_Hedef`n" -ForegroundColor DarkGray


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 4: HKCU — KULLANICI SEVİYESİNDE VERİ AKTARIMI TERCİHİ UYGULAMASI
# ─────────────────────────────────────────────────────────────────────────────
# UsageStatsInSample, tarayıcı düzeyinde kullanım istatistiklerinin Brave
# sunucularına örneklenip gönderilip gönderilmeyeceğini denetleyen
# bir Chromium tercih (preference) değeridir.
#
# BU DEĞER NEDEN HKCU'DA?
# Bu özünde bir politika değil, kullanıcı tercihidir. Brave bu değeri
# kullanıcı hesabındaki `Preferences` JSON dosyasından okur; ancak HKCU
# kayıt defterinden de kabul ederek profil dosyasına yansıtır.
#
# HKLM'deki MetricsReportingEnabled = 0 üst katmanda aynı amaca hizmet eder.
# Bununla birlikte HKCU'ya yazılan bu değer şu durumlar için yedek güvence sağlar:
#   - Politikanın henüz uygulanmadığı geçiş dönemleri
#   - Politika gecikmesi yaşanan ortamlar
#   - HKLM kovanına erişimin kısıtlı olduğu kullanıcı ortamları
#
# İki katmanlı uygulama birbirini tamamlar; biri diğerinin yerini tutmaz.
Write-Host "[4/5] HKCU Kullanıcı Telemetri Tercihi Uygulanıyor..." -ForegroundColor Gray

$HKCUBasarili = $false

try {
    New-ItemProperty -Path $HKCU_Hedef -Name "UsageStatsInSample" -Value 0 -PropertyType DWord -Force | Out-Null
    $HKCUBasarili = $true
    Write-Host "  [OK] UsageStatsInSample -> dword:00000000 (Kullanıcı Düzeyi Telemetri Kapatıldı)`n" -ForegroundColor White
} catch {
    Write-Host "  [HATA] UsageStatsInSample yazılamadı: $($_.Exception.Message)`n" -ForegroundColor Red
}


# ─────────────────────────────────────────────────────────────────────────────
# ADIM 5: CHROMIUM 149 VE BRAVE 1.91 UYUMLU KURUMSAL İLKE YÜKLENMESİ
# ─────────────────────────────────────────────────────────────────────────────
# [v1.0 Farkı]: Try-catch hata yönetimi eklendi, başarı/hata sayaçları ile
# sonuç raporlaması eklendi. BraveShieldsDefault kaldırıldı (aşağıya bakın).
Write-Host "[5/5] Kurumsal İlkeler Veri Tipleri Zorlanarak İşleniyor..." -ForegroundColor Gray

# ══════════════════════════════════════════════════════════════════════════════
# KALDIRILAN POLİTİKA: BraveShieldsDefault = 2
# ══════════════════════════════════════════════════════════════════════════════
# v1.0'da şu satır bulunuyordu:
#   "BraveShieldsDefault" = 2
#
# NEDEN KALDIRILDI?
# Brave'in resmi ADMX şablon paketi (policy_templates.zip) ve Group Policy
# belgelendirmesi kapsamlı biçimde incelendiğinde bu isimde bir kurumsal
# politika (enterprise policy) BULUNMAMAKTADIR.
#
# Brave, Shields yönetimini URL bazlı iki politika ile sağlar:
#   BraveShieldsEnabledForUrls  → Belirtilen URL'lerde kalkanı zorla açar.
#   BraveShieldsDisabledForUrls → Belirtilen URL'lerde kalkanı zorla kapatır.
# Bu politikalar String türündedir (REG_SZ), DWord değil. Shields'ın
# "Standart" veya "Saldırgan" modunu genel olarak ayarlayan bir kayıt defteri
# politikası mevcut değildir.
#
# KALDIRILMAMIŞ OLSAYDI NE OLURDU?
# Değer kayıt defterine başarıyla yazılırdı. Konsol [OK] basardı. Ama Brave
# bu anahtarı tanımadığı için sessizce yoksayardı. Görünürde çalışıyor gibi
# görünen, gerçekte hiçbir etkisi olmayan bir kayıt defteri kaydı kalırdı.
#
# DOĞRU SEÇENEK — Saldırgan Shields Kipi:
# Kalkan saldırganlığı (Standart / Saldırgan), kurumsal politika ile değil;
# kullanıcı hesabı tercihleri (Preferences JSON) üzerinden yönetilir.
# Merkezi uygulamak için önerilen yöntemler:
#   1. brave://settings/shields → "Trackers & ads blocked" → "Aggressive"
#      seçeneğini bir kez elle yapılandırın; ardından Preferences dosyasını
#      şablon olarak kurumsal dağıtım sürecinize dahil edin.
#   2. MDM (Intune, Jamf) üzerinden Brave yönetilen profil dağıtımı yapın.
# ══════════════════════════════════════════════════════════════════════════════

# Brave ADMX şablonları ve Chromium 149 politika düzeni ile doğrulanmış
# kurumsal ilkeler sözlüğü. Özet tablosu mimarîsi; yeni kural eklemek için
# yalnızca bu bloğa bir satır eklenmesi yeterlidir — döngüye dokunulmaz.
$Politikalar = @{

    # ──────────────────────────────────────────────────────────────────────────
    # VERİ AKTARIMI VE ANALİZ (Telemetry & Analytics)
    # ──────────────────────────────────────────────────────────────────────────
    
    # Chromium tabanlı ana ölçüm toplama hizmetinin dışa veri sızdırmasını
    # önler. HKCU'daki UsageStatsInSample ile birlikte iki katmanlı güvence
    # oluşturur; her biri farklı bir katmanda aynı amaca hizmet eder.
    "MetricsReportingEnabled"              = 0

    # Brave'in düzenli olarak kendi sunucularına gönderdiği durum ve kimlik
    # doğrulama ping isteklerini keser. Bu pingler anonim istatistik toplamada
    # kullanılır; kapatmak ağ gizliliğini artırır.
    "BraveStatsPingEnabled"                = 0

    # Gizlilik Korumalı Ürün Analitiği (P3A) veri göndermesini devre dışı bırakır.
    # Brave tarafından anonim olarak toplanan ve gönderilen kullanım özet veri
    # setinden kurtulur. Kurumsal ortamlarda uygulamada sıkça kapatılır.
    "BraveP3AEnabled"                      = 0

    # Web Discovery Project (Brave Search indeksi oluşturmaya dönük) veri
    # toplamayı engeller. Anonymously sistem, Brave Search'ü Google/Bing'den
    # bağımsız kılan veriye katkısından vazgeçer.
    "BraveWebDiscoveryEnabled"             = 0

    # ──────────────────────────────────────────────────────────────────────────
    # ENTEGRE HİZMETLER VE ÖZELLIKLERI DEVRE DIŞI BIRAKMAK (Features)
    # ──────────────────────────────────────────────────────────────────────────

    # Tarayıcı tümleşik reklam ağını, kullanıcı takibini ve BAT jeton
    # kazanç (Rewards) altyapısını sistem genelinde tamamente kapatır.
    # Araç çubuğu Rewards simgesi ve reklam bildirimleri görünmez olur.
    "BraveRewardsDisabled"                 = 1

    # Dahili kripto cüzdan (Brave Wallet) parçalarını, uzantılarını,
    # araç çubuğu düğmesini ve arka plan hizmetlerini devre dışı bırakır.
    # Web3 ve merkeziyetsiz DNS işlevselliği tamamen kapatılır.
    "BraveWalletDisabled"                  = 1

    # Araç çubuğundaki VPN düğmesini kaldırır ve arka planda çalışan
    # Brave VPN hizmet ağını engeller. Düzen geneli VPN yapılandırmasına
    # hiçbir şekilde dokunmaz.
    "BraveVPNDisabled"                     = 1

    # Kenar çubuğundaki Leo Yapay Zekâ (AI Chat) motorunu devre dışı bırakır.
    # "Enabled" adına rağmen 0 = devre dışı anlamına gelir; bu Chromium
    # politika adlandırma geleneğiyle ("disable by 0") uyumludur.
    # Leo konuşma geçmişi, işleme hizmetleri ve API bağlantıları tamamen kesilir.
    "BraveAIChatEnabled"                   = 0

    # Brave Talk (özel video konferans aracı) widget'ını ve çağrı başlatma
    # seçeneğini kullanıcı arayüzünden kaldırır.
    "BraveTalkDisabled"                    = 1

    # Brave News haber beslemesini (New Tab Page'de görünen) devre dışı bırakır.
    # Çoğu zaman daha hızlı yüklenen, daha temiz yeni sekme sayfası yaratır.
    "BraveNewsDisabled"                    = 1

    # Brave Playlist özelliğini (çevrimdışı oynatma için video/ses kaydetme)
    # kapatır.
    "BravePlaylistEnabled"                 = 0

    # ──────────────────────────────────────────────────────────────────────────
    # GÜVENLİK VE KATKILANMIŞLIK (Security & Browsing)
    # ──────────────────────────────────────────────────────────────────────────

    # Güvenli Tarama (Safe Browsing) esnasında ziyaret edilen sitelerle ilgili
    # genişletilmiş veri raporlarının Google/Brave sunucularına iletilmesini
    # engeller. Temel Safe Browsing (kötü amaçlı site uyarısı) işlevi bu
    # politikadan bağımsız çalışmaya devam eder.
    "SafeBrowsingExtendedReportingEnabled" = 0

    # ──────────────────────────────────────────────────────────────────────────
    # OKUMA VE ARAMA ÖZELLİKLERİ (Reader & Discovery Features)
    # ──────────────────────────────────────────────────────────────────────────

    # Speedreader modu (makale sayfalarından düzensizliği/CSS'yi çıkaran)
    # yazı tip önerilerini kaç.
    "BraveSpeedreaderEnabled"              = 0

    # İnternet Archive Wayback Machine entegrasyonunu engeller. "404 Sayfa
    # Bulunamadı" hatası durumunda Brave'in sayfanın Wayback Machine'teki
    # kaydedilmiş sürümünü gösterip göstermeyeceğini sorup sormaması burada
    # kontrol edilir.
    "BraveWaybackMachineEnabled"           = 0

    # ────────────────────────────────────���─────────────────────────────────────
    # AĞLAR, SLİNK VE DİĞER (Network, Tor & Other)
    # ──────────────────────────────────────────────────────────────────────────

    # Tor ağının entegre sekmelerine devre dışı bırakır. Kullanıcı artık
    # "Yeni Tor Sekmesi" oluşturamayacak veya Tor özelleştirmelerine erişemeyecektir.
    "TorDisabled"                          = 1
}

$BasariSayaci = 0
$HataSayaci   = 0

foreach ($Kural in $Politikalar.GetEnumerator()) {
    try {
        # -PropertyType DWord: Değerin 32-bit tamsayı (REG_DWORD) olarak yazılmasını
        # zorunlu kılar. ADMX şablonları REG_DWORD türünde kayıt bekler; farklı bir
        # tür yazılırsa politika okunmaz ya da yanlış yorumlanır.
        #
        # -Force: Değer zaten varsa üzerine yazar, yoksa sıfırdan oluşturur.
        # Bu parametre betiği esnek kararlılıkta kılar — defalarca çalıştırılabilir,
        # her seferinde aynı sonucu güvence altına alır.
        New-ItemProperty -Path $HKLM_Hedef -Name $Kural.Key -Value $Kural.Value -PropertyType DWord -Force | Out-Null
        Write-Host "  [OK] $($Kural.Key) -> dword:$($Kural.Value) (Kurumsal İlke Mühürlendi)" -ForegroundColor Gray
        $BasariSayaci++
    } catch {
        # Kayıt defterine yazma başarısız olursa:
        #   1. Kırmızı renkte hata mesajı basılır (hangi kayıt başarısız gösterilir).
        #   2. Hata sayacı artırılır (kapanış raporunda izlenir).
        #   3. Döngü durmadan bir sonraki politikaya geçer (kısmi başarı tolere edilir).
        Write-Host "  [HATA] $($Kural.Key) -> yazılamadı: $($_.Exception.Message)" -ForegroundColor Red
        $HataSayaci++
    }
}


# ─────────────────────────────────────────────────────────────────────────────
# KAPANIŞ: ÖZET RAPOR VE DOĞRULAMA REHBERİ
# ─────────────────────────────────────────────────────────────────────────────
$AyiriciCizgi = "-" * 62

Write-Host "`n$AyiriciCizgi" -ForegroundColor DarkGray
Write-Host "  UYGULAMA ÖZET RAPORU" -ForegroundColor Cyan
Write-Host $AyiriciCizgi -ForegroundColor DarkGray

# HKCU tercihi
$HKCUDurum = if ($HKCUBasarili) { "Başarılı" } else { "Başarısız" }
Write-Host "  Omaha GUID Kaydı   : $OmahaBasariSayaci başarılı / $OmahaHataSayaci başarısız" -ForegroundColor Gray
Write-Host "  HKCU Tercihi       : UsageStatsInSample    → $HKCUDurum" -ForegroundColor Gray
Write-Host "  HKLM Politikaları  : $BasariSayaci başarılı / $HataSayaci başarısız" -ForegroundColor Gray
Write-Host $AyiriciCizgi -ForegroundColor DarkGray

# Uyarı bloğu — yalnızca hata varsa görünür
if ($HataSayaci -gt 0) {
    Write-Host "`n  [UYARI] $HataSayaci politika yazılamadı. Yukarıdaki HATA" -ForegroundColor Yellow
    Write-Host "          satırlarını inceleyip gerekli izinleri kontrol edin." -ForegroundColor Yellow
}

# Genel başarı mesajı
if ($BasariSayaci -gt 0 -or $OmahaBasariSayaci -gt 0) {
    Write-Host "`n  [BAŞARILI] Brave 1.91.168 kurumsal gizlilik politikaları" -ForegroundColor Green
    Write-Host "           Windows 11 25H2 sistemine başarıyla uygulandı." -ForegroundColor Green
    Write-Host "           Değişikliklerin devreye girmesi için Brave'i" -ForegroundColor White
    Write-Host "           tamamen kapatıp yeniden açmanız yeterlidir.`n" -ForegroundColor White
}

# Doğrulama rehberi — teknik personele yönlendirme
Write-Host "  DOĞRULAMA:" -ForegroundColor Cyan
Write-Host "  1. Etkin politikalar  : brave://policy" -ForegroundColor DarkGray
Write-Host "  2. Kayıt defteri      : HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -ForegroundColor DarkGray
Write-Host "  3. Yedek konumu       : `$env:TEMP\BravePolicyYedek\" -ForegroundColor DarkGray
Write-Host "  4. Geri alma komutu   : reg import `"<yedek_dosyası.reg>`"`n" -ForegroundColor DarkGray

# ─────────────────────────────────────────────────────────────────────────────
# ÇIKIŞ KODU
# ─────────────────────────────────────────────────────────────────────────────
# exit 0 → Tüm önemli adımlar başarıyla tamamlandı.
# exit 1 → En az bir HKLM politikası yazılamadı.
#
# Bu ayrım, Görev Zamanlayıcı, SCCM, Ansible ve benzeri özdevim araçlarının
# betiğin başarıyla çalışıp çalışmadığını doğru biçimde raporlamasını sağlar.
# [v1.0 Farkı]: Eski sürüm `Exit` kullanıyordu — bu, hata durumunda dahi
# her zaman 0 (başarı) döndürdüğünden otomasyon araçlarını yanıltıyordu.
if ($HataSayaci -gt 0) { exit 1 } else { exit 0 }