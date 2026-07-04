# Pester Test Altyapısı Oluşturma

> **v1.0.0** — İlk sürüm

## Görev

Brave Omega betikleri için PowerShell Pester test modülleri oluştur. Her test, politika doğruluğunu, hata yönetimini ve güvenlik önlemlerini kontrol etmeli.

## Kaynaklar

| Kaynak | Yol |
|--------|-----|
| İngilizce betik | `Brave Omega/BraveOmega-EN.ps1` |
| Türkçe betik | `Brave Omega/BraveOmega-TR.ps1` |
| Referans doküman | `docs/Brave-Group-Policy-Reference.md` |
| Pester dokümantasyonu | https://pester.dev/docs/quick-start |

## Adımlar

### 1. Test Dizin Yapısını Oluştur

```text
Tests/
  EN/
    unit/
      Write-PolicyValue.tests.ps1
      Level-Selection.tests.ps1
      Version-Check.tests.ps1
      Backup.tests.ps1
    integration/
      Registry-Write.tests.ps1
  TR/
    unit/
      ...
    integration/
      ...
  helpers/
    Test-Helpers.ps1         # Ortak yardımcı fonksiyonlar
    Mock-Registry.ps1        # Kayıt defteri mock'ları
```

### 2. Unit Testler

#### Write-PolicyValue.tests.ps1

```powershell
BeforeAll {
    # Betiği dot-source et (sadece fonksiyonları al)
    . "$PSScriptRoot\..\..\Brave Omega\BraveOmega-EN.ps1"
}

Describe "Write-PolicyValue" {
    Context "DWord type" {
        It "Should write DWord value to registry" {
            # Mock New-ItemProperty
            Mock New-ItemProperty
            $result = Write-PolicyValue -TargetPath "HKLM:\Test" -PolicyName "TestPolicy" -PolicyValue 1 -ValueType "DWord"
            Should -Invoke New-ItemProperty -Exactly 1
        }
        
        It "Should not write in -WhatIf mode" {
            Mock New-ItemProperty
            $result = Write-PolicyValue -TargetPath "HKLM:\Test" -PolicyName "TestPolicy" -PolicyValue 1 -ValueType "DWord" -WhatIf
            Should -Invoke New-ItemProperty -Exactly 0
        }
    }
    
    Context "String type" {
        It "Should write String value to registry" {
            Mock New-ItemProperty
            $result = Write-PolicyValue -TargetPath "HKLM:\Test" -PolicyName "TestPolicy" -PolicyValue "test" -ValueType "String"
            Should -Invoke New-ItemProperty -Exactly 1
        }
    }
    
    Context "MultiString type" {
        It "Should write MultiString via .NET API" {
            Mock -CommandName Microsoft.Win32.Registry::LocalMachine.OpenSubKey
            # MultiString test detayları
        }
    }
    
    Context "Error handling" {
        It "Should throw on unsupported type" {
            { Write-PolicyValue -TargetPath "HKLM:\Test" -PolicyName "TestPolicy" -PolicyValue 1 -ValueType "InvalidType" } | Should -Throw
        }
    }
}
```

#### Level-Selection.tests.ps1

```powershell
Describe "Level Selection" {
    It "Should select BraveOnly for -Level BraveOnly" {
        # Test level parametresi
    }
    
    It "Should merge policies cumulatively" {
        # BraveOnly + Essential = BraveOnly + Essential politikaları
    }
    
    It "Should override earlier level policies with later ones" {
        # Strict'te WebRtcIPHandling override'ı
    }
    
    It "Should count total policies correctly" {
        # Her seviye için toplam politika sayısı
    }
}
```

#### Version-Check.tests.ps1

```powershell
Describe "Version Check" {
    It "Should detect Brave version" {
        Mock Get-Item { return @{VersionInfo = @{FileVersion = "1.92.134"}} }
        # Test
    }
    
    It "Should warn on version mismatch" {
        # Farklı sürüm takılıyken uyarı
    }
}
```

### 3. Integration Testler

#### Registry-Write.tests.ps1

```powershell
Describe "Registry Integration" {
    BeforeAll {
        # Test kayıt defteri yolu
        $testPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave\Test"
        # Test yolunu oluştur
    }
    
    AfterAll {
        # Test yolunu temizle
        Remove-Item -Path $testPath -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    It "Should create registry key if not exists" {
        # Test
    }
    
    It "Should write all policy types correctly" {
        # DWord, String, MultiString test
    }
}
```

### 4. Test Koşulları

Her test şunları doğrulamalı:

| Test | Beklenen Davranış |
|------|------------------|
| Politika doğru yola yazılır | `HKLM:\SOFTWARE\Policies\BraveSoftware\Brave` altında |
| -WhatIf modu | Hiçbir kayıt defteri değişikliği yapılmaz |
| -Reset modu | Tüm politikalar temizlenir |
| Admin yetkisi yok | Hata fırlatılır |
| Brave çalışıyor | Uyarı verilir, kullanıcı onayı alınır |
| Seviye seçimi | Doğru politikalar birleştirilir |
| Çift dilli | EN ve TR betikler aynı politikaları uygular |

### 5. Test Çalıştırma

```powershell
# Tüm testleri çalıştır
Invoke-Pester -Path "Tests/" -Output Detailed

# Sadece unit testler
Invoke-Pester -Path "Tests/EN/unit/" -Output Detailed

# Sadece belirli bir test
Invoke-Pester -Path "Tests/EN/unit/Write-PolicyValue.tests.ps1" -Output Detailed
```

## Doğrulama

- Her politika türü için (DWord/String/MultiString) en az bir test var mı?
- -WhatIf testi tüm modları kapsıyor mu?
- Hata senaryoları test ediliyor mu? (admin değil, Brave açık, geçersiz seviye)
- Hem EN hem TR betikler test ediliyor mu?
- Testler birbirinden bağımsız mı? (izolasyon)
- Kayıt defteri testleri temizleniyor mu? (AfterAll ile cleanup)
