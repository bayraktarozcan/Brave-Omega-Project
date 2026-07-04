# Politika Değer ve Tür Doğrulama

> **v1.0.0** — İlk sürüm

## Görev

`Brave Omega/*.ps1` betiklerindeki her politikanın değerini, türünü ve varsayılanını `docs/Brave-Group-Policy-Reference.md` referansına göre doğrula.

## Kaynaklar

| Kaynak | Yol |
|--------|-----|
| Referans doküman | `docs/Brave-Group-Policy-Reference.md` — tüm Brave politikaları için "Type", "Default", "Description" sütunları |
| Policy Type Reference | Aynı dokümanda "Policy Type Reference" bölümü (satır 304-314) — tür-dönüşüm tablosu |
| Betikler | `Brave Omega/BraveOmega-EN.ps1` ve `Brave Omega/BraveOmega-TR.ps1` |
| Chromium referans | https://chromeenterprise.google/policies/ — Chromium politikaları için |

## Adımlar

### 1. Brave Politikalarını Doğrula

Her Brave politikası için:

```powershell
# Örnek kontrol tablosu
# Politika          | Referans Türü    | Betik Türü | Referans Default | Betik Değeri | Uyum?
# BraveRewardsDisabled | Boolean        | DWord      | 0 (Enabled)      | 1            | ✓
# BraveAIChatEnabled   | Boolean        | DWord      | 1 (Enabled)      | 0            | ✓
# DefaultBraveFingerprintingV2Setting | Integer (enum) | DWord | null | 3 | ✓ (doğru mu?)
```

**Tür dönüşüm kuralları:**

| Referans Türü | Registry Türü | Açıklama |
|--------------|---------------|----------|
| Boolean | DWord | `0` = false, `1` = true |
| Boolean (tri-state) | DWord | `0` = false, `1` = true, yok = null |
| Integer / Integer (enum) | DWord | Doğrudan sayısal değer |
| String | REG_SZ | Doğrudan metin |
| Array of strings | REG_MULTI_SZ | Dizi olarak |
| Dictionary | Registry subkey | Alt anahtar + değerler |

### 2. Brave Politikası Değer Mantığını Doğrula

**BraveOnly seviyesi:** Tüm Brave özelliklerini kapat. `Disabled = 1`, `Enabled = 0`.

| Politika | Betik Değeri | Beklenen | Açıklama |
|----------|-------------|----------|----------|
| BraveRewardsDisabled | 1 | 1 | Disable Rewards ✓ |
| BraveWalletDisabled | 1 | 1 | Disable Wallet ✓ |
| BraveVPNDisabled | 1 | 1 | Disable VPN ✓ |
| BraveAIChatEnabled | 0 | 0 | Disable AI Chat (Enabled=0) ✓ |
| BraveTalkDisabled | 1 | 1 | Disable Talk ✓ |
| BraveNewsDisabled | 1 | 1 | Disable News ✓ |
| BravePlaylistEnabled | 0 | 0 | Disable Playlist (Enabled=0) ✓ |
| BraveSpeedreaderEnabled | 0 | 0 | Disable Speedreader (Enabled=0) ✓ |
| BraveWaybackMachineEnabled | 0 | 0 | Disable Wayback (Enabled=0) ✓ |
| BraveP3AEnabled | 0 | 0 | Disable P3A ✓ |
| BraveStatsPingEnabled | 0 | 0 | Disable Stats Ping ✓ |
| BraveWebDiscoveryEnabled | 0 | 0 | Disable Web Discovery ✓ |
| TorDisabled | 1 | 1 | Disable Tor ✓ |

### 3. Chromium Politikalarını Doğrula

Chromium politikaları için `docs/Brave-Group-Policy-Reference.md` referansının "Chromium-Inherited Policy Categories" bölümü (satır 221-301) ile eşleştir. Kesin değerler için `https://chromeenterprise.google/policies/` kullan.

**Kritik Chromium politikaları ve beklenen değerler:**

- `MetricsReportingEnabled` = `0` (disable)
- `SafeBrowsingExtendedReportingEnabled` = `0` (disable)
- `SearchSuggestEnabled` = `0` (disable)
- `NetworkPredictionOptions` = `2` (disable prediction)
- `PasswordManagerEnabled` = `0` (disable)
- `BlockThirdPartyCookies` = `1` (block)
- `HttpsOnlyMode` = `"force_enabled"` (String)
- `DnsOverHttpsMode` = `"automatic"` (String)
- `DefaultGeolocationSetting` = `2` (block)
- `DefaultNotificationsSetting` = `2` (block)
- `DefaultCookiesSetting` = `2` (block) — yalnızca Strict seviyesinde

### 4. Seviye Bazında Beklenen Değerler

| Politika | BraveOnly | Essential | Balanced | Strict |
|----------|-----------|-----------|----------|--------|
| BraveRewardsDisabled | 1 | 1 | 1 | 1 |
| MetricsReportingEnabled | — | 0 | 0 | 0 |
| WebRtcIPHandling | — | — | "default_public_interface_only" | "disable_non_proxied_udp" |
| DefaultCookiesSetting | — | — | — | 2 |
| ChromeVariations | — | — | 1 | 1 |

Not: Her seviye bir öncekini kapsar. BraveOnly politikaları her seviyede geçerlidir.

### 5. Hata Raporu Formatı

```markdown
## Doğrulama Raporu

### Tür Uyuşmazlıkları
| Politika | Referans Türü | Betik Türü | Düzeltme |
|----------|--------------|------------|----------|
| ... | ... | ... | ... |

### Değer Uyuşmazlıkları
| Politika | Beklenen Değer | Betik Değeri | Düzeltme |
|----------|---------------|--------------|----------|
| ... | ... | ... | ... |

### Eksik Politikalar
| Politika | Beklenen Seviye |
|----------|-----------------|
| ... | ... |

### Onaylanan Politikalar
- ...
```

## Doğrulama

- `DefaultBraveFingerprintingV2Setting = 3` mü kontrol et (`1` değil — `1` = Disable protection)
- `DefaultBraveHttpsUpgradeSetting = 3` veya `2` mi (`1` değil — `1` = Allow HTTP)
- `DefaultBraveAdblockSetting = 2` mi (`1` değil — `1` = Allow ads)
- `DefaultBraveReferrersSetting = 2` mi (`1` değil — `1` = unsafe-url)
- `DefaultBraveRemember1PStorageSetting = 2` mi (geçerli değerler sadece `1` ve `2`, `0` geçersiz)
