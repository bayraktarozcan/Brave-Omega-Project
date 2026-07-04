# Web Arayüzü — Politika Yapılandırıcı

> **v1.0.0** — İlk sürüm

## Görev

Mevcut `index.html` GitHub Pages sayfasını, kullanıcının politikaları seçip özelleştirilmiş betik oluşturabileceği bir politika yapılandırıcıya dönüştür.

## Kaynaklar

| Kaynak | Yol |
|--------|-----|
| Mevcut HTML | `index.html` (Tailwind CSS, çift dilli, i18n) |
| Referans doküman | `docs/Brave-Group-Policy-Reference.md` |
| Betik (EN) | `Brave Omega/BraveOmega-EN.ps1` |

## Adımlar

### 1. Mevcut Yapıyı Anla

Mevcut `index.html`:

- Tailwind CSS ile stillendirilmiş
- Çift dilli (EN + TR, i18n data attributes)
- Lucide ikonları
- 1631 satır
- Versiyon tablosu içeriyor

### 2. Eklenecek Özellikler

#### Seviye Seçici

```text
[BraveOnly] [Essential] [Balanced] [Strict] [Custom]
```

- Her seviye seçildiğinde altındaki politika listesi güncellenir
- Custom seçeneğinde tüm politikalar gösterilir, her biri toggle edilebilir

#### Politika Listesi

| Aç/Kapa | Politika Adı | Açıklama | Değer | Tür |
|---------|-------------|----------|-------|-----|
| [✓] | BraveRewardsDisabled | BAT rewards kapat | 1 | DWord |

Her satırda:

- Checkbox (seviyeye göre önceden işaretli)
- Politika adı (monospace)
- Açıklama (kısa, Türkçe/İngilizce)
- Değer girişi (integer, string veya dropdown — türe göre)
- Tür göstergesi (DWord/String/MultiString badge)

#### Çıktı Oluşturucu

Seçilen politikalara göre:

1. **PowerShell Betiği** — `.ps1` dosyası indir
2. **Registry Dosyası** — `.reg` dosyası indir
3. **Linux JSON** — `brave_policies.json` indir
4. **macOS plist** — `.mobileconfig` veya PlistBuddy komutları

#### İhracat Formatları

```javascript
// PS1 export
function exportPowerShell(policies) {
    let script = `# Brave Omega Custom Profile\n# Generated: ${new Date()}\n\n`;
    policies.forEach(p => {
        script += `New-ItemProperty -Path "${regPath}" -Name "${p.name}" -Value ${p.value} -PropertyType ${p.type} -Force\n`;
    });
    return script;
}

// REG export
function exportReg(policies) {
    let reg = 'Windows Registry Editor Version 5.00\n\n';
    reg += '[HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\BraveSoftware\\Brave]\n';
    policies.forEach(p => {
        reg += `"${p.name}"=dword:${('0000000' + p.value.toString(16)).slice(-8)}\n`;
    });
    return reg;
}
```

### 3. Dil Desteği

Mevcut i18n yapısını kullan:

```javascript
const i18n = {
    en: {
        title: "Brave Omega Policy Configurator",
        levelBraveOnly: "Brave Only",
        levelEssential: "Essential",
        policyName: "Policy Name",
        description: "Description",
        exportPS1: "Download PowerShell Script",
        exportREG: "Download Registry File"
    },
    tr: {
        title: "Brave Omega Politika Yapılandırıcı",
        levelBraveOnly: "Brave Yalnız",
        levelEssential: "Temel",
        policyName: "Politika Adı",
        description: "Açıklama",
        exportPS1: "PowerShell Betiği İndir",
        exportREG: "Kayıt Defteri Dosyası İndir"
    }
};
```

### 4. localStorage ile Profil Kaydetme

```javascript
// Kullanıcının seçimlerini kaydet
function saveProfile(policies) {
    localStorage.setItem('brave-omega-profile', JSON.stringify({
        version: '1',
        timestamp: new Date(),
        policies: policies
    }));
}

// Kaydedilmiş profili yükle
function loadProfile() {
    const saved = localStorage.getItem('brave-omega-profile');
    return saved ? JSON.parse(saved) : null;
}
```

## Doğrulama

- Tailwind CSS mevcut yapıya uygun kullanıldı mı?
- i18n data attributes korundu mu?
- Çıktı formatları geçerli PowerShell/REG/JSON mı?
- localStorage ile profil kaydetme çalışıyor mu?
- Seviye seçimi doğru politikaları işaretliyor mu?
- Custom seçeneğinde tüm politikalar gösteriliyor mu?
