# Intune / MDM Dağıtım Paketi Hazırlama

> **v1.0.0** — İlk sürüm

## Görev

Kurumsal ortamda Brave politikalarını Intune (Microsoft Endpoint Manager) üzerinden dağıtmak için gerekli yapılandırma dosyalarını ve kılavuzu oluştur.

## Kaynaklar

| Kaynak | Yol / URL |
|--------|-----------|
| Platform deployment referansı | `docs/Brave-Group-Policy-Reference.md` (satır 54-77, Windows) |
| ADMX yükleme yolları | Aynı doküman (satır 71-74) |
| Omaha güncelleyici notu | Aynı doküman (satır 77) |
| Chrome→Brave yol eşleme | Aynı doküman (satır 325-353) |
| Brave ADMX indirme | `https://brave-browser-downloads.s3.brave.com/latest/policy_templates.zip` |
| PowerShell betiği | `Brave Omega/BraveOmega-EN.ps1` |

## Adımlar

### 1. ADMX Dosyalarını Hazırla

Brave ADMX paketinden gerekli dosyaları ayıkla:

| Dosya | Intune'a Yükleme |
|-------|------------------|
| `brave.admx` | Ayarlar Kataloğu'na yükle |
| `BraveSoftware.admx` | Ayarlar Kataloğu'na yükle |
| `brave.adml` | `%systemroot%\PolicyDefinitions\<locale>\` |
| `BraveSoftware.adml` | `%systemroot%\PolicyDefinitions\<locale>\` |

**Windows Server GPO için:**

- ADMX → `%systemroot%\PolicyDefinitions\`
- ADML → `%systemroot%\PolicyDefinitions\<locale>\`
- Domain-wide: `\\domain\SYSVOL\domain\Policies\PolicyDefinitions\`

### 2. Intune Ayarlar Kataloğu Profili

Intune'da "Ayarlar Kataloğu" profili oluşturmak için referans:

```xml
<!-- Intune Settings Catalog Profile — Brave Omega Essential -->
<!-- Kategori: BraveSoftware > Brave > BraveSensitive -->
<SettingsCatalogProfile>
  <Category>BraveSoftware > Brave</Category>
  <Settings>
    <!-- BraveOnly seviyesi -->
    <Setting>
      <Name>BraveRewardsDisabled</Name>
      <Value>1</Value>
    </Setting>
    <Setting>
      <Name>BraveWalletDisabled</Name>
      <Value>1</Value>
    </Setting>
    <!-- ... diğer politikalar ... -->
  </Settings>
</SettingsCatalogProfile>
```

Not: Intune Ayarlar Kataloğu ADMX dosyalarını yükledikten sonra Brave politikalarını "BraveSoftware > Brave" kategorisi altında gösterir. Yukarıdaki XML referans amaçlıdır — Intune portal üzerinden yapılandırılır.

### 3. PowerShell Dağıtım Betiği (Intune Win32)

Intune Win32 uygulaması olarak dağıtmak için:

```powershell
# deploy-brave-omega.ps1
# Intune Win32 App wrapper for Brave Omega

param(
    [string]$Level = "Essential"
)

# Admin kontrolü
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "Lütfen yönetici olarak çalıştırın."
}

# Brave Omega betiğini çalıştır
$scriptPath = Join-Path $PSScriptRoot "BraveOmega-EN.ps1"
& $scriptPath -Level $Level

# Exit code
if ($LASTEXITCODE -eq 0) {
    Write-Host "Brave Omega başarıyla uygulandı."
    exit 0
} else {
    Write-Host "Hata oluştu."
    exit 1
}
```

**Intune Win32 dağıtımı için gerekenler:**

- `.intunewin` paketi (IntuneWinAppUtil.exe ile oluştur)
- Yükleme komutu: `powershell.exe -ExecutionPolicy Bypass -File "deploy-brave-omega.ps1" -Level Essential`
- Kaldırma komutu: `powershell.exe -ExecutionPolicy Bypass -File "BraveOmega-EN.ps1" -Reset`
- Cihaz yeniden başlatma gereksinimi: Hayır (Brave yeniden başlatılmalı)

### 4. Intune Detection Script

```powershell
# detect-brave-omega.ps1
# Intune detection — Brave Omega politikalarının uygulandığını doğrula

$policies = @(
    "BraveRewardsDisabled",
    "BraveWalletDisabled",
    "BraveVPNDisabled"   
)

$regPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

foreach ($policy in $policies) {
    if (-not (Test-Path "$regPath\$policy")) {
        Write-Host "Eksik: $policy"
        exit 1
    }
}

Write-Host "Tüm politikalar mevcut."
exit 0
```

### 5. Configuration Manager (SCCM) Kılavuzu

1. Uygulama oluştur → "Windows PowerShell betiği"
2. Dağıtım türü: PowerShell betiği
3. Betik: `BraveOmega-EN.ps1 -Level Essential`
4. Kullanıcı deneyimi: Sistem bağlamında çalıştır
5. Algılama: `HKLM\SOFTWARE\Policies\BraveSoftware\Brave\BraveRewardsDisabled` mevcut mu?

### 6. Registry (.reg) Dosyası Oluştur

GPO'nun veya Intune'un desteklemediği durumlar için doğrudan `.reg` dosyası:

```reg
Windows Registry Editor Version 5.00

; Brave Omega — BraveOnly Level
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\BraveSoftware\Brave]
"BraveRewardsDisabled"=dword:00000001
"BraveWalletDisabled"=dword:00000001
"BraveVPNDisabled"=dword:00000001
"BraveAIChatEnabled"=dword:00000000
"BraveTalkDisabled"=dword:00000001
"BraveNewsDisabled"=dword:00000001
"BravePlaylistEnabled"=dword:00000000
"BraveSpeedreaderEnabled"=dword:00000000
"BraveWaybackMachineEnabled"=dword:00000000
"BraveP3AEnabled"=dword:00000000
"BraveStatsPingEnabled"=dword:00000000
"BraveWebDiscoveryEnabled"=dword:00000000
"TorDisabled"=dword:00000001
```

Her seviye için ayrı `.reg` dosyası oluştur:

- `BraveOmega-BraveOnly.reg`
- `BraveOmega-Essential.reg`
- `BraveOmega-Balanced.reg`
- `BraveOmega-Strict.reg`

## Doğrulama

- ADMX dosyaları doğru yola kopyalandı mı?
- Intune Ayarlar Kataloğu'nda Brave kategorisi görünüyor mu?
- Win32 uygulama algılama betiği doğru çalışıyor mu?
- `.reg` dosyası çift tıklandığında sorunsuz import ediliyor mu?
- Farklı seviyeler için ayrı Intune profilleri oluşturulabilir mi?
- Kaldırma işlemi tüm politikaları temizliyor mu?
