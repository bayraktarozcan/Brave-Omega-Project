# ADMX Doğrulama İşlemi

> **v1.0.0** — İlk sürüm

## Görev

Brave ve Chromium ADMX şablonlarını indir, betikteki politikaların türlerini ve değerlerini ADMX tanımlarına karşı doğrula.

## Kaynaklar

| Kaynak | Yol / URL |
|--------|-----------|
| ADMX workflow | `.github/workflows/admx-validate.yml` |
| ADMX betiği | `.github/workflows/admx-validate.ps1` |
| Brave policy templates | `https://brave-browser-downloads.s3.brave.com/latest/policy_templates.zip` |
| Chromium policy templates | `https://chromium.googlesource.com/chromium/src/+/master/chrome/app/policy/policy_templates.json?format=TEXT` |
| Chrome Enterprise Policy List | `https://chromeenterprise.google/policies/` |
| Referans doküman | `docs/Brave-Group-Policy-Reference.md` ("Policy Type Reference" bölümü, satır 304-314) |
| Betikler | `Brave Omega/BraveOmega-EN.ps1` ve `Brave Omega/BraveOmega-TR.ps1` |

## Adımlar

### 1. ADMX Şablonlarını İndir

```powershell
# Brave politikaları
$braveUrl = "https://brave-browser-downloads.s3.brave.com/latest/policy_templates.zip"
Invoke-WebRequest -Uri $braveUrl -OutFile "policy_templates.zip"
Expand-Archive -Path "policy_templates.zip" -DestinationPath "admx/brave" -Force

# Chromium politikaları (JSON formatında)
$chromiumUrl = "https://chromium.googlesource.com/chromium/src/+/master/chrome/app/policy/policy_templates.json?format=TEXT"
$base64 = Invoke-WebRequest -Uri $chromiumUrl | Select-Object -ExpandProperty Content
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64)) | Out-File "admx/chromium/policy_templates.json"
```

### 2. Politika Türünü Doğrula

Her politikayı ADMX'teki türüyle karşılaştır:

| ADMX Türü | Registry Türü | PowerShell Tipi |
|-----------|--------------|-----------------|
| `int` / `bool` | REG_DWORD | DWord |
| `string` | REG_SZ | String |
| `list` | REG_MULTI_SZ | MultiString |
| `dict` | Registry subkey | — |
| `int-enum` | REG_DWORD (belirli değerler) | DWord |
| `string-enum` | REG_SZ (belirli değerler) | String |

### 3. ADMX İzin Verilen Değerleri Doğrula

Enum politikaları için ADMX'te tanımlı izin verilen değerlerle betikteki değeri karşılaştır:

```powershell
# Örnek: DefaultBraveFingerprintingV2Setting
# ADMX'te: value="1" = Disable, value="3" = Enable
# Betikte: Value=3 → ✓ doğru
# Betikte: Value=1 → ✗ yanlış (protection'ı kapatır)
```

### 4. Brave ADMX Paketini Ayrıca Doğrula

Brave ADMX paketinde Brave'a özgü politikaların tanımlandığından emin ol:

| Dosya | İçerik |
|-------|--------|
| `brave.admx` | Brave ana politikaları |
| `BraveSoftware.admx` | BraveSoftware ad alanı politikaları |

Bu dosyalardaki her politikanın adını, türünü ve izin verilen değerlerini betikle karşılaştır.

### 5. Rapor Formatı

```markdown
## ADMX Doğrulama Raporu — Tarih: YYYY-AA-GG

### Brave ADMX Sürümü
- Politika sayısı: N
- İndirme tarihi: ...
- Brave sürümü: ...

### Tür Uyuşmazlıkları
| Politika | ADMX Türü | Betik Türü |
|----------|-----------|------------|
| ... | ... | ... |

### Değer Uyuşmazlıkları (Enum)
| Politika | ADMX İzin Verilen | Betik Değeri |
|----------|-------------------|--------------|
| ... | ... | ... |

### Eksik Politikalar (ADMX'te var, betikte yok)
| Politika | ADMX Türü | Varsayılan |
|----------|-----------|-----------|
| ... | ... | ... |

### Fazla Politikalar (Betikte var, ADMX'te yok)
| Politika | Not |
|----------|-----|
| ... | ... |

### Başarılı
- N politika doğrulandı
```

### 6. Hata Durumunda Yapılacaklar

- Tür uyuşmazlığı: Betikteki türü ADMX'e göre düzelt
- Değer uyuşmazlığı: Betikteki değeri ADMX izin verilen değerlerle uyumlu hale getir
- Eksik politika: ADMX'te var, betikte yoksa — roadmap'e ekle
- Fazla politika: Betikte var, ADMX'te yoksa — büyük olasılıkla geçerli bir Chromium politikası, uyar notu ekle

## Doğrulama

- ADMX indirme başarılı mı? (S3 URL'si çalışıyor mu?)
- Tüm Brave politikaları ADMX'te tanımlı mı?
- Enum değerleri ADMX'teki değer aralığında mı?
- Boolean tri-state politikalar ADMX'te "main" tipiyle mi tanımlanmış?
- ADMX güncelleme sıklığı: Brave her yeni sürümde ADMX güncelleyebilir. Her doğrulamada en son ADMX'i indir.
