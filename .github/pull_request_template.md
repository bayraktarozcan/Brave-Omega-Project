## Summary

_Describe the change and what problem it solves._

- Closes #_ (if applicable)

---

## Type of Change

- [ ] Policy data-layer update (no browser-version pin)
- [ ] New policy addition
- [ ] Policy fix / correction
- [ ] Bug fix
- [ ] Documentation (README, CHANGELOG, Wiki, index.html)
- [ ] Translation / i18n
- [ ] CI/CD or automation
- [ ] Security
- [ ] Chore / refactor

---

## Checklist

- [ ] Script runs without errors (`-WhatIf -Level Essential`)
- [ ] `$ScriptVersion` updated if this is a project release (browser versions are detected at runtime, never pinned)
- [ ] CHANGELOG.md updated
- [ ] index.html updated (if applicable — version table, i18n keys)
- [ ] README.md updated (if applicable)
- [ ] ADMX validation passes (GitHub Actions)

---

## Testing

_Steps to verify:_

```powershell
.\"Brave-Omega\BraveOmega.ps1" -Language EN -WhatIf -Level Essential
```
