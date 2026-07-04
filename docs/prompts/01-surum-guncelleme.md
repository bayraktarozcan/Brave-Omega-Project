# Sürüm Yükseltme Prosedürü

> **v1.0.0** — İlk sürüm

## Görev

Brave ve Chromium sürüm numaralarını proje genelinde güncelle. Yeni bir Brave kararlı sürümü yayınlandığında tüm referansları, sabitleri ve bağımlı dosyaları güncelle.

## Kaynaklar

| Kaynak | Yol |
|--------|-----|
| Betik (EN) | `Brave Omega/BraveOmega-EN.ps1` — $ScriptVersion, $ValidatedBrave, $ValidatedChromium (satır 76-78) |
| Betik (TR) | `Brave Omega/BraveOmega-TR.ps1` — aynı sabitler |
| CHANGELOG | `CHANGELOG.md` |
| README | `README.md` |
| index.html | `index.html` — sürüm tablosu |
| ADMX workflow | `.github/workflows/admx-validate.yml` — kullanılan Chromium sürümü |
| Wiki | `Wiki/` dizinindeki dosyalar |
| Sürüm kaynağı | https://brave.com/latest/ — Brave kararlı sürüm notları |
| Chromium eşleme | https://brave.com/latest/ veya brave://version sayfası |

## Adımlar

### 1. Yeni Sürüm Bilgilerini Topla

- Brave sürümü (örn: 1.93.100)
- Chromium sürümü (örn: 151.0.7890.42)
- Sürüm tarihi
- Değişiklik notları (Brave release notes)
- Yeni/ değişen politikalar (Brave-core commit log)

### 2. Güncellenecek Dosyalar ve Konumlar

| Dosya | Güncellenecek Alan(lar) |
|-------|------------------------|
| `Brave Omega/BraveOmega-EN.ps1` | satır 76-78: `$ScriptVersion`, `$ValidatedBrave`, `$ValidatedChromium` |
| `Brave Omega/BraveOmega-TR.ps1` | aynı sabitler |
| `CHANGELOG.md` | Yeni sürüm girişi ekle |
| `README.md` | Versiyon tablosu, badge'ler |
| `index.html` | Sürüm tablosu, i18n verileri |
| `docs/Brave-Group-Policy-Reference.md` | Brave politikalarının "Since" sütunları (chrome.*:N+ değerleri) |
| `.github/workflows/admx-validate.yml` | `CHROMIUM_VERSION` sabiti varsa |

### 3. CHANGELOG Formatı

Her yeni sürüm için aşağıdaki formatı kullan:

```markdown
## v1.2.4.0 — 2026-08-15

Brave **1.93.100** · Chromium **151.0.7890.42** · Windows 11 25H2

### Added
- [NEW] Yeni Brave politikaları: BraveDeAmpEnabled, BraveDebouncingEnabled, ...

### Changed
- [UPDATE] Brave sürümü 1.92.134 → 1.93.100
- [UPDATE] Chromium sürümü 150 → 151

### Fixed
- ...
```

### 4. Sürüm Numaralandırma Şeması

| Basamak | Değişiklik Türü | Örnek |
|---------|----------------|-------|
| 1. Version | Brave major rewrite, hedef platform değişikliği | v1.2.3.4 → v2.0.0.0 |
| 2. Major | Betik mimarisi/kırılım değişti | v1.2.3.4 → v1.3.0.0 |
| 3. Minor | Brave/Chromium yükseltmesi veya yeni politika eklendi | v1.2.3.4 → v1.2.4.0 |
| 4. Revision | Düzeltme, revizyon, doküman güncellemesi | v1.2.3.4 → v1.2.3.5 |

### 5. Doğrulama

```powershell
# Yeni sürümün doğru yazıldığını kontrol et
Select-String -Path "Brave Omega/*.ps1" -Pattern '\$ScriptVersion\s*=\s*"v\d+\.\d+\.\d+\.\d+"'
Select-String -Path "Brave Omega/*.ps1" -Pattern '\$ValidatedBrave\s*=\s*"\d+\.\d+\.\d+"'
Select-String -Path "Brave Omega/*.ps1" -Pattern '\$ValidatedChromium\s*=\s*"\d+"'
```

## Doğrulama

- Tüm dosyalarda aynı sürüm numarası kullanıldı mı?
- Brave sürümü ile Chromium sürümü eşleşiyor mu? (Brave'in hangi Chromium tabanında olduğu brave://version sayfasında görünür)
- `CHANGELOG.md` güncellendi mi?
- `index.html`'deki sürüm tablosu güncellendi mi?
- ADMX workflow güncel Chrome/Chromium sürümüne karşı doğrulama yapıyor mu?
