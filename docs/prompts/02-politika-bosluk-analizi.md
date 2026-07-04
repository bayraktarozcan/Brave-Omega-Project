# Politika Boşluk Analizi

> **v1.0.0** — İlk sürüm

## Görev

`docs/Brave-Group-Policy-Reference.md` içindeki Brave politikaları ile `Brave Omega/*.ps1` betiklerinde uygulanan politikalar arasındaki farkları tespit et.

## Kaynaklar

| Kaynak | Yol |
|--------|-----|
| Referans doküman | `docs/Brave-Group-Policy-Reference.md` (bölüm "Brave-Specific Policies", satır 149-217) |
| İngilizce betik | `Brave Omega/BraveOmega-EN.ps1` (bölüm "LEVEL POLICY DEFINITIONS", satır 351-509) |
| Türkçe betik | `Brave Omega/BraveOmega-TR.ps1` (aynı yapı, Türkçe yorumlar) |
| Birincil kaynak | https://github.com/brave/brave-core/tree/master/components/policy/resources/templates/policy_definitions/BraveSoftware |

## Adımlar

### 1. Referans Politikalarını Çıkar

Referanstaki her Brave politikasını listele. Şu kategorilere ayır:

- **Web3, Crypto & Rewards**: BraveRewardsDisabled, BraveWalletDisabled
- **Privacy & Security (Shields)**: BraveShieldsDisabledForUrls, BraveShieldsEnabledForUrls, DefaultBraveAdblockSetting, DefaultBraveFingerprintingV2Setting, DefaultBraveHttpsUpgradeSetting, DefaultBraveReferrersSetting, DefaultBraveRemember1PStorageSetting, BraveDeAmpEnabled, BraveDebouncingEnabled, BraveGlobalPrivacyControlEnabled, BraveReduceLanguageEnabled, BraveTrackingQueryParametersFilteringEnabled <!-- markdownlint-disable-line MD013 -->
- **Network & Connectivity**: BraveVPNDisabled, TorDisabled
- **AI & Content Features**: BraveAIChatEnabled, BraveLocalAIEnabled, BraveNewsDisabled, BravePlaylistEnabled, BraveSpeedreaderEnabled, BraveTalkDisabled, BraveWaybackMachineEnabled
- **Telemetry, Analytics & Sync**: BraveP3AEnabled, BraveStatsPingEnabled, BraveWebDiscoveryEnabled, BraveSyncUrl
- **Other**: EmailAliasesEnabled
- **Deprecated**: IPFSEnabled (chrome.*:87+, kullanımdan kaldırıldı)

### 2. Betik Politikalarını Çıkar

Her iki `.ps1` dosyasındaki `$PolicyDefinitions` bloğundan tüm `Name` alanlarını oku:

```powershell
# BraveOnly seviyesi — Brave politikaları
# Essential seviyesi — Chromium veri sızıntısı politikaları
# Balanced seviyesi — Chromium güvenlik/dengeli politikalar
# Strict seviyesi — Chromium maksimum gizlilik politikaları
```

### 3. Karşılaştırma Tablosu Oluştur

Her referans politikası için şu durumu belirle:

| Durum | Anlamı |
|-------|--------|
| **Mevcut** | Betikte aynı isimle tanımlı |
| **Eksik** | Referansta var, betikte yok |
| **Farklı değer** | Referanstaki önerilen/ varsayılan değerden farklı |
| **Kullanımdan kaldırılmış** | Referansta deprecated, betikte hala varsa uyar |

### 4. Chromium Politikalarını Da Ekle

Referanstaki "Chromium-Inherited Policy Categories" (satır 221-301) bölümündeki kategorileri de betikteki Chromium politikalarıyla karşılaştır. Şu an betikte Essential/ Balanced/ Strict seviyelerinde Chromium politikaları var — bunların referanstaki kategorilerle eşleştiğini doğrula. Eksik kategori varsa not et (örneğin: Proxy, Printing, Extensions, Sync, Remote Access, Native Messaging, Browser Switcher, Certificate Management). <!-- markdownlint-disable-line MD013 -->

### 5. Çıktı Formatı

Aşağıdaki formatı kullan:

```markdown
## Politika Boşluk Analizi Raporu

### Mevcut Politikalar (N adet)
- ...

### Eksik Politikalar (N adet)
| Politika | Kategori | Min. Chromium | Önerilen Değer | Seviye Önerisi |
|----------|----------|--------------|----------------|----------------|
| ... | ... | ... | ... | BraveOnly/Essential/Balanced/Strict |

### Değer Farklılıkları
| Politika | Referans Değeri | Betik Değeri | Açıklama |
|----------|----------------|--------------|----------|
| ... | ... | ... | ... |

### Deprecated Uyarıları
| Politika | Ne Zaman Kaldırıldı | Not |
|----------|---------------------|-----|
| ... | ... | ... |
```

## Doğrulama

- Her politika adını referanstaki birebir yazımla karşılaştır (büyük/küçük harf)
- Değerlerin türünü kontrol et (DWord vs String vs MultiString)
- Varsayılan değerleri referansın "Default" sütunuyla karşılaştır
- Enum değerlerinin anlamını referansın açıklama sütunundan doğrula
- IPFSEnabled deprecated listesinde — betikte varsa uyar ve kaldırılmasını öner
