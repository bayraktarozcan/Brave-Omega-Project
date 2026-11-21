#!/usr/bin/env python3
"""Build canonical release title and bilingual notes from CHANGELOG.md.

CLI:
    Build-ReleaseNotes.py <version> <output> [--current]

<version> is the bare version (no leading v); <output> is written as UTF-8/LF.
--current omits the [DEPRECATED] prefix (used for the version being published).

Stdout line 1 is the canonical title, so the release script can consume it
directly. The body is EN first, local language second, with a version heading
and Summary / Added / Changed / Removed / Fixed / Files / Documentation in
both halves. Garbage is excluded: bare #N tokens, embedded changelog TOCs,
other versions' rows and emoji headings. stdlib only.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

MINOR = {
    "a", "an", "the", "and", "or", "but", "nor", "for", "of", "on", "per",
    "to", "via", "with", "as", "at", "by", "in", "if", "ve", "veya", "ya",
    "ile", "için", "bir", "göre",
}
ACRONYMS = {
    "admx": "ADMX", "adml": "ADML", "api": "API", "ci": "CI", "cd": "CD",
    "dns": "DNS", "html": "HTML", "json": "JSON", "lna": "LNA", "owa": "OWA",
    "pdf": "PDF", "sha256": "SHA256", "smime": "S/MIME", "tls": "TLS",
    "url": "URL", "utf8": "UTF8", "guid": "GUID", "gpg": "GPG", "lts": "LTS",
    "webrtc": "WebRTC", "webusb": "WebUSB",
}
MIXED = {
    "brave": "Brave", "changelog": "Changelog", "chromium": "Chromium",
    "dependabot": "Dependabot", "github": "GitHub", "gitlab": "GitLab",
    "ioc": "IoC", "javascript": "JavaScript", "linux": "Linux",
    "markdown": "Markdown", "omaha": "Omaha", "pester": "Pester",
    "powershell": "PowerShell", "wiki": "Wiki", "windows": "Windows",
}
EN_HEADINGS = {
    "summary": "Summary", "overview": "Summary", "added": "Added",
    "changed": "Changed", "removed": "Removed", "fixed": "Fixed",
    "notes": "Notes", "verification": "Verification",
    "files": "Files", "documentation": "Documentation",
}
TR_HEADINGS = {
    "özet": "Özet", "genel bakış": "Özet", "eklenenler": "Eklenenler",
    "değiştirilenler": "Değiştirilenler", "değişiklik": "Değiştirilenler",
    "kaldırılanlar": "Kaldırılanlar", "kaldırıldı": "Kaldırılanlar",
    "düzeltilenler": "Düzeltilenler", "düzeltildi": "Düzeltilenler",
    "notlar": "Notlar", "doğrulama": "Doğrulama",
    "dosyalar": "Dosyalar", "belgelendirme": "Belgelendirme",
}

FILES_EN = (
    "### Files\n\n"
    "- `Brave-Omega/BraveOmega.ps1` — Unified bilingual script (EN/TR)\n"
    "- `index.html` — Single-page project landing page"
)
DOCS_EN = (
    "### Documentation\n\n"
    "- [Wiki](https://github.com/bayraktarozcan/Brave-Omega-Project/wiki)\n"
    "- [Changelog](https://github.com/bayraktarozcan/Brave-Omega-Project/blob/main/CHANGELOG.md)"
)
FILES_TR = (
    "### Dosyalar\n\n"
    "- `Brave-Omega/BraveOmega.ps1` — Birleşik iki dilli betik (EN/TR)\n"
    "- `index.html` — Tek sayfalık proje açılış sayfası"
)
DOCS_TR = (
    "### Belgelendirme\n\n"
    "- [Wiki](https://github.com/bayraktarozcan/Brave-Omega-Project/wiki)\n"
    "- [Değişiklik Günlüğü](https://github.com/bayraktarozcan/Brave-Omega-Project/blob/main/CHANGELOG.md)"
)


def title_case(text: str, turkish: bool = False) -> str:
    words = []
    for token in text.split():
        word = token.strip("-/.,;:|()[]{}*\"")
        if not word or re.fullmatch(r"v?\d+(\.\d+){1,3}", word, re.I):
            continue
        low = word.lower()
        if low in ACRONYMS:
            words.append(ACRONYMS[low])
            continue
        if low in MIXED:
            words.append(MIXED[low])
            continue
        if low in MINOR and words:
            words.append(low)
            continue
        parts = []
        for part in (p for p in re.split(r"[-/]", word) if p):
            pl = part.lower()
            if pl in ACRONYMS:
                parts.append(ACRONYMS[pl])
            elif pl in MIXED:
                parts.append(MIXED[pl])
            elif pl in MINOR and parts:
                parts.append(pl)
            elif turkish and re.search(r"[çğıöşü]", part, re.I):
                # Turkish capitalisation needs locale; Python's upper() maps
                # i -> I, which is wrong for Turkish prose. Keep the token as
                # authored when it already starts uppercase, else use upper().
                parts.append(part if part[0].isupper() else part[0].upper() + part[1:])
            else:
                parts.append(part[0].upper() + part[1:])
        words.append("-".join(parts))
    return " ".join(words)


def split_changelog(text: str) -> tuple[str, str]:
    marker = re.search(r"(?m)^##\s+TR\s+Türkçe.*$", text)
    if not marker:
        return text, ""
    return text[:marker.start()], text[marker.start():]


def extract_section(half: str, version: str) -> tuple[str, list[str]]:
    lines = half.replace("\r\n", "\n").split("\n")
    start = None
    description = ""
    for i, line in enumerate(lines):
        match = re.match(r"^##\s*\[v" + re.escape(version) + r"\]\s*[—–-]?\s*(.*)$", line)
        if match:
            start, description = i + 1, match.group(1).strip()
            break
    if start is None:
        return "", []
    body = []
    for line in lines[start:]:
        if re.match(r"^##\s*\[v\d", line) or re.match(r"^##\s+TR\s+Türkçe", line):
            break
        body.append(line)
    # The changelog heading often carries only a date (or a decorative brand).
    # The first prose sentence under Summary / Özet is the canonical one-line
    # description of the release.
    for i, line in enumerate(body):
        if not re.match(r"^###\s*[^A-Za-zÇĞİÖŞÜçğıöşü]*\s*(Summary|Özet)\s*$", line.strip()):
            continue
        for prose in body[i + 1:]:
            if not prose.strip() or prose.strip() == "---":
                continue
            bold = re.match(r"^\*\*(.+?)\*\*\s*(.*)$", prose)
            if bold and not any(ord(c) > 0x2500 for c in bold.group(1)):
                desc = bold.group(1)
            else:
                desc = prose
            desc = re.sub(r"[^\w\s—–-]", "", desc.replace("**", ""))
            desc = re.sub(r"^[A-Za-zÇĞİÖŞÜçğıöşü ]+?(?:release|sürümü)\s*[—–-]\s*", "", desc, flags=re.I)
            desc = " ".join(desc.split())
            if len(desc) > 110:
                desc = desc[:110].rsplit(" ", 1)[0]
            description = desc.strip(" .:-") or description
            break
        break
    return description, body


def clean_body(lines: list[str], turkish: bool) -> str:
    kept: list[str] = []
    for line in lines:
        stripped = line.strip()
        if not stripped:
            if kept and kept[-1] != "":
                kept.append("")
            continue
        if stripped == "---" or stripped.startswith("<a id=") or stripped.startswith("<") or stripped.startswith("</"):
            continue
        if re.match(r"^#{1,2}\s", line):
            continue
        if "Table of Contents" in stripped or "İçindekiler" in stripped:
            continue
        if re.match(r"^\d+\.\s*\[", stripped) or re.match(r"^\s+\*\s*\[", stripped):
            continue
        if re.match(r"^\|\s*v\d", stripped) or re.match(r"^\|\s*#\d+", stripped):
            continue
        if "#" in stripped and re.search(r"#\d+\b", stripped) and stripped.startswith("|"):
            continue
        if re.match(r"^#{3,6}\s", line):
            heading = re.sub(r"^#{3,6}\s*[^A-Za-zÇĞİÖŞÜçğıöşü]*\s*", "", line).strip()
            key = re.sub(r"\s+", " ", heading.lower())
            table = TR_HEADINGS if turkish else EN_HEADINGS
            canonical = table.get(key)
            if canonical is None:
                canonical = title_case(heading, turkish)
            kept.append(f"### {canonical}")
            continue
        kept.append(line.rstrip())
    while kept and kept[-1] == "":
        kept.pop()
    return "\n".join(kept)


def main() -> None:
    args = sys.argv[1:]
    if len(args) not in (2, 3) or (len(args) == 3 and args[2] != "--current"):
        raise SystemExit("usage: Build-ReleaseNotes.py <version> <output> [--current]")
    version = args[0].lstrip("v")
    current = len(args) == 3
    root = Path(__file__).resolve().parent.parent
    changelog = root / "CHANGELOG.md"
    if not changelog.exists():
        raise SystemExit(f"CHANGELOG.md not found: {changelog}")
    en_half, tr_half = split_changelog(changelog.read_text(encoding="utf-8"))
    en_desc, en_lines = extract_section(en_half, version)
    tr_desc, tr_lines = extract_section(tr_half, version)
    if not en_lines:
        raise SystemExit(f"no changelog section for v{version}")
    if not tr_lines:
        tr_desc, tr_lines = en_desc, en_lines
    en_title = title_case(en_desc) or "Release"
    tr_title = title_case(tr_desc, True) or en_title
    full_title = f"v{version} — {en_title}"
    if not current:
        full_title = f"[DEPRECATED] {full_title}"
    en_body = clean_body(en_lines, False)
    tr_body = clean_body(tr_lines, True)
    if "### Files" not in en_body:
        en_body += "\n\n" + FILES_EN
    if "### Documentation" not in en_body:
        en_body += "\n\n" + DOCS_EN
    if "### Dosyalar" not in tr_body:
        tr_body += "\n\n" + FILES_TR
    if "### Belgelendirme" not in tr_body:
        tr_body += "\n\n" + DOCS_TR
    body = f"## v{version} — {en_title}\n\n{en_body}\n\n---\n\n## v{version} — {tr_title}\n\n{tr_body}\n"
    Path(args[1]).write_text(body, encoding="utf-8", newline="\n")
    print(full_title)


if __name__ == "__main__":
    main()
