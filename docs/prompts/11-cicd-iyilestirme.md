# CI/CD İyileştirme Prosedürü

> **v1.0.0** — İlk sürüm

## Görev

Mevcut GitHub Actions iş akışlarını analiz et, iyileştirme fırsatlarını belirle ve yeni iş akışları ekle.

## Kaynaklar

| Kaynak | Yol |
|--------|-----|
| ADMX doğrulama | `.github/workflows/admx-validate.yml` |
| ADMX betiği | `.github/workflows/admx-validate.ps1` |
| Quality workflow | `.github/workflows/quality.yml` |
| Pages workflow | `.github/workflows/pages.yml` |
| Stale workflow | `.github/workflows/stale.yml` |
| Dependabot | `.github/dependabot.yml` |

## Adımlar

### 1. Mevcut İş Akışlarını Analiz Et

| Workflow | Ne Yapıyor | Ne Eksik |
|----------|-----------|----------|
| `admx-validate.yml` | Haftalık Chromium ADMX tür denetimi | Brave ADMX denetimi yok, değer denetimi yok |
| `quality.yml` | PR'lerde markdown lint, YAML doğrulama, PS sözdizimi | PSScriptAnalyzer yok, platform matrisi yok |
| `pages.yml` | GitHub Pages dağıtımı | Politika bütünlük testi yok |
| `stale.yml` | Eski issue/PR yönetimi | — |
| `dependabot.yml` | Haftalık Güncelleme | Yalnızca GitHub Actions |

### 2. Politik Bütünlük Testi Ekle

Yeni bir iş akışı veya mevcut `quality.yml`'ye ek:

```yaml
# quality.yml içine eklenecek job
policy-integrity:
  name: Check Policy Integrity
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v7
    - name: Validate policy list against reference
      shell: pwsh
      run: |
        # Referanstaki politikaları çıkar
        $referencePolicies = Select-String -Path "docs/Brave-Group-Policy-Reference.md" -Pattern '^\| `(\w+)`' | 
          ForEach-Object { $_.Matches.Groups[1].Value }
        
        # Betikteki politikaları çıkar
        $scriptPolicies = Select-String -Path "Brave Omega/BraveOmega-EN.ps1" -Pattern '\$PolicyDefinitions' -Context 0,500 | 
          ForEach-Object { ... }
        
        # Karşılaştır
        $missing = $referencePolicies | Where-Object { $_ -notin $scriptPolicies }
        $extra = $scriptPolicies | Where-Object { $_ -notin $referencePolicies }
        
        if ($missing) { Write-Host "EKSİK: $missing" }
        if ($extra) { Write-Host "FAZLA: $extra" }
        if ($missing -or $extra) { exit 1 }
```

### 3. PSScriptAnalyzer Ekle

```yaml
powershell-analysis:
  name: PSScriptAnalyzer
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v7
    - name: Install PSScriptAnalyzer
      shell: pwsh
      run: Install-Module -Name PSScriptAnalyzer -Force
    - name: Run analysis
      shell: pwsh
      run: |
        $results = Invoke-ScriptAnalyzer -Path "Brave Omega/" -Recurse -Severity Error
        if ($results) { $results | Format-Table; exit 1 }
```

### 4. Platform Matris Testi

```yaml
cross-platform-syntax:
  name: Cross-Platform Syntax Check
  strategy:
    matrix:
      os: [ubuntu-latest, windows-latest, macos-latest]
  runs-on: ${{ matrix.os }}
  steps:
    - uses: actions/checkout@v7
    - name: Validate PowerShell syntax
      shell: pwsh
      run: |
        $files = Get-ChildItem -Path "Brave Omega/" -Recurse -Filter "*.ps1"
        $errors = @()
        foreach ($file in $files) {
          try {
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$null, [ref]$null)
          } catch {
            $errors += "$($file.Name): $_"
          }
        }
        if ($errors) { $errors | ForEach-Object { Write-Host $_ }; exit 1 }
```

### 5. ADMX Doğrulama İyileştirme

Mevcut `admx-validate.yml`'ye ekle:

```yaml
# Mevcut: Yalnızca tür denetimi
# İyileştirme: Brave ADMX + Değer denetimi

- name: Download Brave ADMX
  run: |
    Invoke-WebRequest -Uri "https://brave-browser-downloads.s3.brave.com/latest/policy_templates.zip" -OutFile "policy_templates.zip"
    Expand-Archive -Path "policy_templates.zip" -DestinationPath "admx/brave" -Force

- name: Validate enum values against Brave ADMX
  shell: pwsh
  run: |
    # ADMX'teki enum değerlerini oku
    # Betikteki değerlerle karşılaştır
    # Uyuşmazlık varsa uyar
```

### 6. Otomatik Sürüm Algılama

```yaml
version-check:
  name: Check Brave Version
  runs-on: ubuntu-latest
  schedule:
    - cron: "0 6 * * 1"  # Her Pazartesi
  steps:
    - name: Fetch Brave latest version
      run: |
        $version = (Invoke-WebRequest -Uri "https://brave.com/latest/" -UseBasicParsing).Content
        # Versiyon numarasını çıkar ve betiktekiyle karşılaştır
        # Fark varsa GitHub Issue aç
```

## Doğrulama

- Tüm iş akışları geçerli YAML formatında mı? (`yamllint` ile kontrol)
- Her iş akışının doğru trigger'ları var mı? (PR, push, schedule)
- Permission'lar minimum seviyede mi? (least privilege)
- Secret'lar varsa doğru kullanılıyor mu?
- `actions/checkout@v7` güncel mi? (son major versiyon)
- PowerShell Core (`pwsh`) Ubuntu'da kullanılabiliyor mu?
- Tüm iş akışları birlikte çalıştığında birbirini bloke ediyor mu?
