# Deprecated Politika Temizliği

> **v1.0.0** — İlk sürüm

## Görev

Kullanımdan kaldırılmış (deprecated) Brave politikalarını tespit et, betikten çıkar veya uyarı mekanizması ekle.

## Kaynaklar

| Kaynak | Yol / URL |
|--------|-----------|
| Deprecated politikalar | `docs/Brave-Group-Policy-Reference.md` (satır 213-217) |
| Brave-core kaynağı | https://github.com/brave/brave-core/tree/master/components/policy/resources/templates/policy_definitions/BraveSoftware |
| Betikler | `Brave Omega/BraveOmega-EN.ps1`, `Brave Omega/BraveOmega-TR.ps1` |
| Chromium deprecated listesi | https://chromeenterprise.google/policies/#deprecated-policies |
| CHANGELOG | `CHANGELOG.md` |

## Adımlar

### 1. Brave Deprecated Politikaları Tespit Et

Referanstaki deprecated politikalar:

| Politika | Kaldırılma Tarihi | Durum |
|----------|-------------------|-------|
| `IPFSEnabled` | chrome.*:87+ (Brave 1.69.153, Ağu 2024) | IPFS özelliği tamamen kaldırıldı |

### 2. Betikte Kontrol Et

```powershell
# Tüm seviyelerde IPFSEnabled var mı?
$policyDefinitions.Keys | ForEach-Object {
    $policyDefinitions[$_] | Where-Object { $_.Name -eq "IPFSEnabled" }
}
```

Eğer `IPFSEnabled` betikte varsa:

1. Betikten kaldır (ilgili seviyedeki politikalar listesinden çıkar)
2. CHANGELOG'a not ekle: `[REMOVED] IPFSEnabled — Brave 1.69.153+ ile kaldırıldı`
3. Kullanıcıya bilgi vermek için betiğin başına bir uyarı ekle (opsiyonel)

### 3. Chromium Deprecated Politikaları Kontrol Et

`https://chromeenterprise.google/policies/#deprecated-policies` adresini kontrol et. Brave Omega'da kullanılan Chromium politikalarından deprecated olan var mı?

**Özellikle dikkat edilmesi gerekenler:**

- `CloudPrintProxyEnabled` — Google Cloud Print kapatıldı mı?
- `MetricsReportingEnabled` — yerini başka bir politika aldı mı?
- Eski `Default*` ayarları — Chromium yeni sürümlerde değişmiş olabilir

### 4. Deprecated Politika Varsa Yapılacaklar

```powershell
# Seçenek A: Tamamen kaldır
# $PolicyDefinitions["Strict"] içinden çıkar

# Seçenek B: Uyarı ekle (politika halen çalışıyorsa)
Write-Host "[WARN] IPFSEnabled is deprecated since Brave 1.69.153. Consider removing."
```

**Karar kuralı:**

- Brave özelliği tamamen kaldırılmışsa → betikten çıkar
- Politika hala çalışıyor ama deprecated ise → uyarı ekle, sonraki sürümde çıkar
- Yerini başka bir politika almışsa → eskiyi çıkar, yeniyi ekle

### 5. CHANGELOG Formatı

```markdown
### Removed
- [REMOVED] `IPFSEnabled` — Brave 1.69.153+ ile kaldırıldığı için betikten çıkarıldı
```

## Doğrulama

- Tüm deprecated politikalar betikten çıkarıldı mı?
- CHANGELOG güncellendi mi?
- Deprecated politikanın yerini alan yeni bir politika varsa, o eklendi mi?
- IPFSEnabled dışında Brave-core'dan kaldırılmış başka politika var mı? (Brave-core GitHub repo'sunu kontrol et)
