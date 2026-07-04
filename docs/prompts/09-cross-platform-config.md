# Cross-Platform Yapılandırma Oluşturma

> **v1.0.0** — İlk sürüm

## Görev

Windows için yazılmış Brave Omega politikalarını macOS ve Linux platformlarına uygun formata dönüştür.

## Kaynaklar

| Kaynak | Yol / URL |
|--------|-----------|
| Platform deployment referansı | `docs/Brave-Group-Policy-Reference.md` (satır 54-146) |
| macOS bundle ID'leri | Aynı doküman (satır 91-97) |
| macOS CLI örnekleri | Aynı doküman (satır 99-112) |
| Linux formatı | Aynı doküman (satır 114-131) |
| Windows betiği | `Brave Omega/BraveOmega-EN.ps1` — `$PolicyDefinitions` bloğu |
| iOS desteklenen politikalar | Aynı doküman (satır 139-145) |
| Chrome→Brave yol eşleme | Aynı doküman (satır 325-353) |

## Adımlar

### 1. macOS .plist Yapılandırması Oluştur

#### Managed plist (tüm seviyeler için)

```bash
#!/bin/bash
# Brave Omega — macOS Managed Preferences Generator
# Hedef: /Library/Managed Preferences/com.brave.Browser.plist

PLIST_PATH="/Library/Managed Preferences/com.brave.Browser.plist"

# BraveOnly seviyesi
sudo /usr/libexec/PlistBuddy -c "Add :BraveRewardsDisabled bool true" "$PLIST_PATH"
sudo /usr/libexec/PlistBuddy -c "Add :BraveWalletDisabled bool true" "$PLIST_PATH"
sudo /usr/libexec/PlistBuddy -c "Add :BraveVPNDisabled bool true" "$PLIST_PATH"
sudo /usr/libexec/PlistBuddy -c "Add :BraveAIChatEnabled bool false" "$PLIST_PATH"
sudo /usr/libexec/PlistBuddy -c "Add :BraveTalkDisabled bool true" "$PLIST_PATH"
sudo /usr/libexec/PlistBuddy -c "Add :BraveNewsDisabled bool true" "$PLIST_PATH"
sudo /usr/libexec/PlistBuddy -c "Add :BravePlaylistEnabled bool false" "$PLIST_PATH"
sudo /usr/libexec/PlistBuddy -c "Add :BraveSpeedreaderEnabled bool false" "$PLIST_PATH"
sudo /usr/libexec/PlistBuddy -c "Add :BraveWaybackMachineEnabled bool false" "$PLIST_PATH"
sudo /usr/libexec/PlistBuddy -c "Add :BraveP3AEnabled bool false" "$PLIST_PATH"
sudo /usr/libexec/PlistBuddy -c "Add :BraveStatsPingEnabled bool false" "$PLIST_PATH"
sudo /usr/libexec/PlistBuddy -c "Add :BraveWebDiscoveryEnabled bool false" "$PLIST_PATH"
sudo /usr/libexec/PlistBuddy -c "Add :TorDisabled bool true" "$PLIST_PATH"
```

**Her seviye için ayrı shell betiği oluştur:**

- `BraveOmega-Mac-BraveOnly.sh`
- `BraveOmega-Mac-Essential.sh`
- `BraveOmega-Mac-Balanced.sh`
- `BraveOmega-Mac-Strict.sh`

#### Dönüşüm Kuralları (Windows → macOS)

| Windows Tipi | macOS defaults Komutu |
|-------------|----------------------|
| DWord (0/1) | `-bool true` / `-bool false` |
| DWord (enum) | `-integer <değer>` |
| String | `-string "<değer>"` |
| MultiString | `-array "item1" "item2"` |

#### Kanal Bazlı Bundle ID'leri

- Release: `com.brave.Browser`
- Beta: `com.brave.Browser.beta`
- Nightly: `com.brave.Browser.nightly`
- Development: `com.brave.Browser.development`

### 2. Linux JSON Yapılandırması Oluştur

```json
{
  "BraveRewardsDisabled": true,
  "BraveWalletDisabled": true,
  "BraveVPNDisabled": true,
  "BraveAIChatEnabled": false,
  "BraveTalkDisabled": true,
  "BraveNewsDisabled": true,
  "BravePlaylistEnabled": false,
  "BraveSpeedreaderEnabled": false,
  "BraveWaybackMachineEnabled": false,
  "BraveP3AEnabled": false,
  "BraveStatsPingEnabled": false,
  "BraveWebDiscoveryEnabled": false,
  "TorDisabled": true
}
```

**Her seviye için ayrı JSON dosyası oluştur:**

- `BraveOmega-Linux-BraveOnly.json`
- `BraveOmega-Linux-Essential.json`
- `BraveOmega-Linux-Balanced.json`
- `BraveOmega-Linux-Strict.json`

#### Dönüşüm Kuralları (Windows → Linux)

| Windows Tipi | Linux JSON |
|-------------|-----------|
| DWord (0/1) | `true` / `false` |
| DWord (enum) | integer (örn: `2`, `3`) |
| String | string (örn: `"force_enabled"`) |
| MultiString | array (örn: `["url1", "url2"]`) |

**Hedef dizin:** `/etc/brave/policies/managed/`

### 3. iOS .mobileconfig Referansı Oluştur

iOS'ta yalnızca şu Brave politikaları desteklenir (referans satır 139-145):

- BravePlaylistEnabled
- BraveVPNDisabled
- BraveNewsDisabled
- BraveTalkDisabled
- BraveRewardsDisabled
- BraveAIChatEnabled

Bunlar için bir `.mobileconfig` şablonu oluştur. Tam `.mobileconfig` yerine Apple Configurator 2 veya MDM ile içe aktarılmak üzere bir referans XML yapısı hazırla.

### 4. Platform Farklılıklarını Belgele

Her platform için not edilmesi gereken farklılıklar:

| Konu | Windows | macOS | Linux |
|------|---------|-------|-------|
| Politika kaynağı | Registry | .plist | JSON dosyası |
| Yönetim | GPO / Intune | MDM / plist | Elle JSON |
| Kullanıcı override | Mümkün değil (HKLM) | Mümkün (HKCU benzeri) | Mümkün değil |
| Dinamik yenileme | Genelde evet | Genelde evet | Genelde evet |
| Zorlama seviyesi | Yüksek | Orta | Yüksek |
| ADMX desteği | Evet | Kısmi | Hayır |

## Doğrulama

- Her macOS politikası doğru bundle ID ile yazıldı mı? (`com.brave.Browser` — büyük B)
- Linux JSON geçerli JSON formatında mı? (`jq . dosya.json` ile test et)
- Boolean tri-state politikalar macOS'ta `-bool` ile, Linux'ta `true`/`false` ile mi tanımlandı?
- Enum değerleri tüm platformlarda aynı mı? (örn: `DefaultBraveFingerprintingV2Setting = 3` her yerde)
- MultiString politikalar Linux'ta dizi olarak, macOS'ta `-array` ile mi tanımlandı?
