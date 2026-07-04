# Politika Kataloğu Oluşturma

> **v1.0.0** — İlk sürüm

## Görev

Projedeki tüm politikaları (hem Brave hem Chromium) kapsayan, her politikanın ayrıntılı bilgilerini içeren bir politika kataloğu dokümanı oluştur.

## Kaynaklar

| Kaynak | Yol |
|--------|-----|
| Referans doküman | `docs/Brave-Group-Policy-Reference.md` |
| Betik (EN) | `Brave Omega/BraveOmega-EN.ps1` — tüm politika tanımları |
| Mevcut versiyon | `docs/roadmap-and-opportunities.md` — katalog yapısı fikri |

## Adımlar

### 1. Katalog Dosyasını Oluştur

Dosya: `docs/policy-catalog.md`

### 2. Her Politika İçin Şablon

```markdown
## BraveRewardsDisabled

| Alan | Değer |
|------|-------|
| **ID** | `BraveRewardsDisabled` |
| **Kaynak** | Brave özgü (Web3, Crypto & Rewards) |
| **Seviye** | BraveOnly |
| **Min. Chromium** | — |
| **Tür** | DWord (Boolean) |
| **Brave Varsayılanı** | 0 (Enabled) |
| **Brave Omega Değeri** | 1 |
| **Brave Omega Etkisi** | Rewards, BAT ve reklam özelliklerini tamamen kapatır |
| **Risk** | Yok — Brave Only seviyesinde, kullanıcı etkisi yok |
| **Değiştirilebilirlik** | Kullanıcı brave://settings içinden değiştiremez (HKLM kilidi) |
| **ADMX Doğrulama** | <tarih> — uyumlu |
| **Notlar** | — |
```

### 3. Katalog Alan Tanımları

| Alan | Açıklama | Olası Değerler |
|------|----------|---------------|
| **ID** | Politika adı (birebir kayıt defteri adı) | — |
| **Kaynak** | Politikayı tanımlayan kaynak | Brave özgü / Chromium veri / Chromium güvenlik / Chromium içerik |
| **Seviye** | Brave Omega'daki seviyesi | BraveOnly / Essential / Balanced / Strict |
| **Min. Chromium** | Desteklenen minimum Chromium sürümü | chrome.*:N+ veya — |
| **Tür** | Kayıt defteri türü | DWord / String / MultiString |
| **Brave Varsayılanı** | Brave'in fabrika varsayılanı | 0, 1, null, veya metin |
| **Brave Omega Değeri** | Brave Omega'nın uyguladığı değer | sayı, metin, dizi |
| **Brave Omega Etkisi** | Kullanıcıya etkisi | Kullanıcı dostu açıklama |
| **Risk** | Kullanıcı deneyimine etki seviyesi | Yok / Düşük / Orta / Yüksek |
| **Değiştirilebilirlik** | Kullanıcının bypass edip edemeyeceği | Kullanıcı değiştiremez / brave://settings'den değişebilir |
| **ADMX Doğrulama** | Son ADMX uyumluluk kontrolü tarihi ve sonucu | <tarih> — uyumlu / uyumsuz / kontrol edilmedi |
| **Notlar** | Varsa ek uyarılar | — |

### 4. Katalog Kategorileri

Politikaları şu kategorilere ayır:

| Kategori | Açıklama | Örnek |
|----------|----------|-------|
| **Brave Özgü** | Yalnızca Brave'de bulunan politikalar | BraveRewardsDisabled |
| **Chromium Veri Sızıntısı** | Telemetri ve veri toplamayı engelleyen Chromium politikaları | MetricsReportingEnabled |
| **Chromium Güvenlik** | Tarayıcı güvenliğini artıran Chromium politikaları | SafeBrowsingProtectionLevel |
| **Chromium İçerik** | Web içeriği davranışını kontrol eden Chromium politikaları | DefaultCookiesSetting |
| **Chromium Platform** | Tarayıcı platform davranışını kontrol eden Chromium politikaları | BackgroundModeEnabled |

### 5. Seviye Özet Tablosu

```markdown
## Seviye Özeti

### BraveOnly (13 politika) — Brave özellikleri kapatılır
- BraveRewardsDisabled, BraveWalletDisabled, BraveVPNDisabled, ...
- Toplam DWord: 13 | String: 0 | MultiString: 0

### Essential (+16 = 29) — Veri sızıntısı engellenir
- MetricsReportingEnabled, SafeBrowsingExtendedReportingEnabled, ...
- Toplam DWord: 16 | String: 0 | MultiString: 0

### Balanced (+18 = 47) — Güvenlik artırılır
- WebRtcIPHandling, HttpsOnlyMode, DnsOverHttpsMode, ...
- Toplam DWord: 15 | String: 3 | MultiString: 1 (bir MultiString dizi olarak sayılır)

### Strict (+20 = 67) — Maksimum gizlilik
- TranslateEnabled, DefaultCookiesSetting, ...
- Toplam DWord: 18 | String: 1 (WebRtcIPHandling override) | MultiString: 0
```

Not: Sayılar `$PolicyDefinitions` bloklarındaki politika sayılarıdır. Kesin sayıları betikten oku.

### 6. Cross-Reference Tablosu

```markdown
## Politika → Dosya Eşleme

| Politika | Windows (REG) | macOS (.plist) | Linux (JSON) |
|----------|--------------|----------------|--------------|
| BraveRewardsDisabled | `HKLM\...\BraveRewardsDisabled` | `com.brave.Browser` → `BraveRewardsDisabled` | `brave_policies.json` |
| ... | ... | ... | ... |
```

### 7. Politika Türü Dağılımı

Her seviye için tür dağılımını gösteren bir özet tablo:

| Seviye | Toplam | DWord | String | MultiString |
|--------|--------|-------|--------|-------------|
| BraveOnly | 13 | 13 | 0 | 0 |
| Essential | 29 | 29 | 0 | 0 |
| Balanced | 47 | 44 | 3 | 0 |
| Strict | 67 | 62 | 4 | 1 |

## Doğrulama

- Her politika için tüm alanlar dolu mu? (varsa "—" işareti)
- Politikaların kaynak kategorisi doğru mu? (Brave özgü vs Chromium)
- Brave varsayılan değerleri referansla eşleşiyor mu?
- Min. Chromium sürümleri referanstaki "Since" sütunuyla uyumlu mu?
- ADMX doğrulama durumu güncel mi?
- Katalogdaki politika sayısı ile betikteki sayı eşleşiyor mu?
