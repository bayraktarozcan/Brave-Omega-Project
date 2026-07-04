# Modüler Betik Mimarisi — Geçiş Prosedürü

> **v1.0.0** — İlk sürüm

## Görev

Mevcut tek parça `.ps1` betiğini modüler PowerShell modül yapısına dönüştür. `modules/*.psm1` + `config.json` + `profiles/*.json` mimarisine geçiş yap.

## Kaynaklar

| Kaynak | Yol |
|--------|-----|
| Mevcut EN betik | `Brave Omega/BraveOmega-EN.ps1` (788 satır, tüm mantık tek dosyada) |
| Mevcut TR betik | `Brave Omega/BraveOmega-TR.ps1` |
| Referans doküman | `docs/Brave-Group-Policy-Reference.md` |
| Modüler yapı fikri | `docs/roadmap-and-opportunities.md` (satır 148-168) |
| Pester test yapısı | `docs/prompts/07-pester-test.md` |

## Adımlar

### 1. Hedef Dizin Yapısı

```text
Brave Omega/
  modules/
    core.psm1                # Kayıt defteri yazma, yedekleme, -WhatIf, -Reset yardımcıları
    core.tr.psm1             # Core — Türkçe çıktılar
    privacy-brave.psm1       # Brave'e özgü gizlilik politikaları
    privacy-chromium.psm1    # Chromium veri sızıntısı politikaları
    security.psm1            # Chromium güvenlik politikaları
    permissions.psm1         # İzin/API politikaları
    content.psm1             # İçerik ayarları
    telemetry.psm1           # Telemetri politikaları
    omaha.psm1               # Omaha güncelleyici GUID yönetimi
    version.psm1             # Sürüm kontrolü, Brave version detection
  profiles/
    brave-only.json          # BraveOnly seviyesi
    essential.json           # Essential seviyesi
    balanced.json            # Balanced seviyesi
    strict.json              # Strict seviyesi
  config.json                # Politika → seviye eşleme tablosu
  BraveOmega-EN.ps1          # Ana giriş (modülleri config.json'a göre çağırır)
  BraveOmega-TR.ps1          # Ana giriş — Türkçe
```

### 2. config.json Formatı

```json
{
  "version": "v2.2.0",
  "validated": {
    "brave": "1.92.134",
    "chromium": "150"
  },
  "levels": {
    "BraveOnly": {
      "description": "Brave-specific features disabled",
      "policies": {
        "BraveRewardsDisabled": {
          "type": "DWord", "value": 1, "module": "privacy-brave"
        },
        "BraveWalletDisabled": {
          "type": "DWord", "value": 1, "module": "privacy-brave"
        }
      }
    },
    "Essential": {
      "description": "Chromium data leak prevention",
      "inherit": ["BraveOnly"],
      "policies": {
        "MetricsReportingEnabled": {
          "type": "DWord", "value": 0, "module": "telemetry"
        }
      }
    }
  },
  "profiles": {
    "brave-only": {
      "level": "BraveOnly"
    },
    "essential": {
      "level": "Essential"
    }
  }
}
```

### 3. core.psm1 Fonksiyonları

```powershell
# Write-PolicyRegistry - Tüm politika türlerini yazar
function Write-PolicyRegistry {
    param(
        [string]$Path,
        [string]$Name,
        $Value,
        [ValidateSet("DWord","String","MultiString")]
        [string]$Type,
        [switch]$WhatIf
    )
    # Mevcut Write-PolicyValue mantığını taşı
}

# Backup-RegistryPolicies - Zaman damgalı yedekleme
function Backup-RegistryPolicies {
    # mevcut yedekleme mantığı
}

# Invoke-PolicyLevel - config.json'dan seviye okur ve uygular
function Invoke-PolicyLevel {
    param(
        [string]$Level,
        [string]$ConfigPath,
        [switch]$WhatIf
    )
    # config.json oku, seviyeyi çöz, tüm politikaları uygula
}
```

### 4. Geçiş Stratejisi

| Aşama | İş | Süre |
|-------|-----|------|
| **Aşama 1** | `core.psm1` oluştur, mevcut yardımcı fonksiyonları taşı | 1 gün |
| **Aşama 2** | `config.json` oluştur, tüm politikaları taşı | 2 gün |
| **Aşama 3** | Modül dosyalarını oluştur, politikaları modüllere dağıt | 2 gün |
| **Aşama 4** | `BraveOmega-EN.ps1` girişini modüler hale getir | 1 gün |
| **Aşama 5** | Türkçe modülleri oluştur | 1 gün |
| **Aşama 6** | Test et (Pester) | 2 gün |

### 5. Modül İçeriği Standartları

Her `.psm1` dosyası şu yapıda olmalı:

```powershell
# privacy-brave.psm1
# Brave'e özgü gizlilik politikaları

function Get-BravePrivacyPolicies {
    param([string]$Level)
    
    $policies = @{
        "BraveOnly" = @(
            @{Name="BraveRewardsDisabled"; Value=1; Type="DWord"}
            @{Name="BraveWalletDisabled";  Value=1; Type="DWord"}
        )
    }
    
    if ($policies.ContainsKey($Level)) {
        return $policies[$Level]
    }
    return @()
}

Export-ModuleMember -Function Get-BravePrivacyPolicies
```

### 6. Ana Giriş Betiği (Yeni)

```powershell
# BraveOmega-EN.ps1 (modüler versiyon)
param(
    [string]$Level = "",
    [switch]$WhatIf,
    [switch]$Reset
)

# Modülleri yükle
Import-Module "$PSScriptRoot\modules\core.psm1" -Force
Import-Module "$PSScriptRoot\modules\privacy-brave.psm1" -Force
# ...

# config.json oku
$config = Get-Content "$PSScriptRoot\config.json" | ConvertFrom-Json

# Seviyeyi işle
if ($Reset) {
    # Tüm politikaları temizle
    Invoke-PolicyReset
    exit 0
}

# Seviyeye göre politikaları topla
$policies = @()
$policies += Get-BravePrivacyPolicies -Level $Level
# ...

# Uygula
foreach ($policy in $policies) {
    Write-PolicyRegistry -Path $regPath -Name $policy.Name -Value $policy.Value -Type $policy.Type -WhatIf:$WhatIf
}
```

### 7. config.json'dan Profil Oluşturma

```powershell
# profile-generator.ps1
# Kullanıcının config.json düzenlemesiyle özel profil oluşturmasını sağlar

$config = Get-Content "config.json" | ConvertFrom-Json
$userPolicies = @{}

# Kullanıcıya seçenekleri göster
Write-Host "Kullanılabilir politikalar:"
$config.levels.PSObject.Properties | ForEach-Object {
    $_.Value.policies.PSObject.Properties | ForEach-Object {
        Write-Host "  $($_.Name) = $($_.Value.value) [$($_.Value.type)]"
    }
}

# Kullanıcı seçimlerini al ve profiles/custom.json oluştur
```

## Doğrulama

- `config.json`'daki her politika en az bir modülde tanımlı mı?
- Modüller `Export-ModuleMember` ile doğru fonksiyonları dışa aktarıyor mu?
- Ana betik tüm modülleri yükleyebiliyor mu?
- Eski parametreler (`-Level`, `-WhatIf`, `-Reset`) aynen çalışıyor mu?
- Politika sayıları eski betikle birebir aynı mı?
- Türkçe modüller ayrı mı yoksa parametreyle mi yönetiliyor? (Tutarlı ol)
- Tüm mevcut testler geçiyor mu?
