## Summary

_Describe the change and what problem it solves._

- Closes #_ (if applicable)

---

## Type of Change

- [ ] Version bump (Brave / Chromium)
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
- [ ] All version constants updated (`$ScriptVersion`, `$DogrulananBrave`, `$DogrulananChromium`)
- [ ] CHANGELOG.md updated
- [ ] index.html updated (if applicable — version table, i18n keys)
- [ ] README.md updated (if applicable)
- [ ] ADMX validation passes (GitHub Actions)

---

## Testing

_Steps to verify:_

```powershell
.\"Brave Omega\BraveOmega-EN.ps1" -WhatIf -Level Essential
```
