# Yeni Brave Politikaları Ekleme

> **v1.0.0** — İlk sürüm

## Görev

Eksik Brave politikalarını betiğe ekle. Politika adı, değeri, türü ve hangi seviyeye ait olduğunu `docs/Brave-Group-Policy-Reference.md` referansına göre belirle.

## Ön Koşul

Bu prompt'u çalıştırmadan önce `02-politika-bosluk-analizi.md` çalıştırılmış ve eksik politikalar listelenmiş olmalı.

## Kaynaklar

| Kaynak | Yol |
|--------|-----|
| Referans doküman | `docs/Brave-Group-Policy-Reference.md` (satır 149-217) — tür, varsayılan, açıklama |
| İngilizce betik | `Brave Omega/BraveOmega-EN.ps1` — `$PolicyDefinitions` bloğu (satır 351-509) |
| Türkçe betik | `Brave Omega/BraveOmega-TR.ps1` — aynı yapı |
| Birincil kaynak | https://github.com/brave/brave-core/tree/master/components/policy/resources/templates/policy_definitions/BraveSoftware |

## Adımlar

### 1. Eklenecek Politikaları ve Seviyelerini Belirle

Aşağıdaki tabloyu kullan. Değerler referanstaki açıklamalara göre belirlenmiştir:

#### Sıra 1 — BraveOnly (sıfır kullanıcı etkili gizlilik politikaları)

| Politika | Tür | Değer | Açıklama |
|----------|-----|-------|----------|
| `BraveDeAmpEnabled` | DWord | `0` | AMP atlama — varsayılanı etkin, `0` (false) ile kapat |
| `BraveDebouncingEnabled` | DWord | `0` | İzleyici zıplama koruması — varsayılanı etkin, `0` (false) ile kapat |
| `BraveGlobalPrivacyControlEnabled` | DWord | `0` | GPC sinyali — varsayılanı etkin, `0` (false) ile kapat |
| `BraveReduceLanguageEnabled` | DWord | `0` | Dil azaltma — varsayılanı etkin, `0` (false) ile kapat |
| `BraveTrackingQueryParametersFilteringEnabled` | DWord | `0` | İzleme parametre temizliği — varsayılanı etkin, `0` (false) ile kapat |
| `BraveLocalAIEnabled` | DWord | `0` | Yerel AI — varsayılanı etkin, `0` (false) ile kapat |
| `EmailAliasesEnabled` | DWord | `0` | E-posta takma adları — varsayılanı etkin, `0` (false) ile kapat |

**Tri-state notu:** Bu politikalar `Boolean (tri-state)` tipinde. `null` (unset) = kullanıcı karar verebilir. Brave Omega yaklaşımı: tüm Brave ek özelliklerini `false`/`0` yap, kullanıcı isterse `brave://flags` veya ayarlardan açar. Betikte DWord tipi kullanıldığı için değer yokluğu = null, `0` = false anlamına gelir. <!-- markdownlint-disable-line MD013 -->

#### Sıra 2 — Essential (varsayılan koruma seviyeleri, kullanıcıyı kilitle)

| Politika | Tür | Değer | Açıklama |
|----------|-----|-------|----------|
| `DefaultBraveAdblockSetting` | DWord | `2` | Reklam engelleme — `2` = Block ads. Reference: "If unset, blocked by default but user can override via Shields." `2` ile kullanıcı override edemez. |
| `DefaultBraveFingerprintingV2Setting` | DWord | `3` | Parmak izi koruma — `3` = Enable standard mode. `1` = Disable (yanlış!). |
| `DefaultBraveHttpsUpgradeSetting` | DWord | `3` | HTTPS yükseltme — `3` = Standard (upgrade when available). `1` = Allow HTTP (yanlış!). |
| `DefaultBraveReferrersSetting` | DWord | `2` | Referrer sınırlama — `2` = Cap to `strict-origin-when-cross-origin`. `1` = unsafe-url (yanlış!). |
| `DefaultBraveRemember1PStorageSetting` | DWord | `2` | 1. taraf depolama unutma — `2` = Forget. `1` = Remember. |

#### Sıra 3 — Balanced (kurumsal kontrol politikaları)

| Politika | Tür | Değer | Açıklama |
|----------|-----|-------|----------|
| `BraveSyncUrl` | String | `""` (boş) veya özel URL | Sync sunucusu. Boş bırakılırsa varsayılan Brave Sync kullanılır. Kurumsal ortamda özel sync URL'si verilebilir. |

### 2. Betiğe Ekleme Kuralları

Her politika şu formatta eklenir:

```powershell
@{Name="PolitikaAdi"; Value=<değer>; Type="DWord|String|MultiString"}
```

**Kurallar:**

- BraveOnly seviyesine eklenenler `true`/`false` mantığıyla: `1` = disabled (BraveOnly'de özellikleri kapatıyoruz), `0` = enabled
- Tri-state Boolean'lar DWord olarak: `0` = false (disabled), `1` = true (enabled), yok = null
- Enum Integer'lar DWord olarak: doğrudan enum değeri
- String'ler: String tipi
- Dizi'ler: MultiString tipi

### 3. Yorum Satırı Ekle

Her politikanın üstüne (varsa) İngilizce/Türkçe betiğe uygun yorum satırı ekle:

```powershell
# BraveOnly'e ekleme:
@{Name="BraveDeAmpEnabled";                      Value=0; Type="DWord"}  # De-AMP — bypasses Google AMP pages

# Essential'a ekleme:
@{Name="DefaultBraveAdblockSetting";             Value=2; Type="DWord"}  # Lock ad blocking to Block mode
```

### 4. Yorumların Dilini Koru

- `BraveOmega-EN.ps1` — tüm yorumlar İngilizce
- `BraveOmega-TR.ps1` — tüm yorumlar Türkçe
- Politika adları, değerler ve parametre isimleri her iki dosyada birebir aynı

### 5. Politika Sırasını Koru

Her seviye bloğunda politikaları alfabetik sırayla veya mevcut sıraya uygun şekilde ekle. Mevcut yapıyı bozma.

## Doğrulama

1. Eklenen her politikanın adını `docs/Brave-Group-Policy-Reference.md` ile birebir eşleştir
2. Değerlerin türünü referansın "Type" sütunuyla kontrol et
3. Enum değerlerinin anlamını referans açıklamasından doğrula
4. Her iki betik dosyasına da aynı politikayı ekle (EN + TR)
5. `DefaultBraveFingerprintingV2Setting` değerinin `3` olduğundan emin ol (`1` = Disable, DEĞİL — yaygın hata)
6. `DefaultBraveHttpsUpgradeSetting` değerinin `2` veya `3` olduğundan emin ol (`1` = Allow HTTP — Brave Omega hedefiyle çelişir)
