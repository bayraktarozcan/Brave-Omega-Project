#!/usr/bin/env python3
r"""Mojibake / UTF-8 integrity scanner for the Brave Omega repo.

Detects:
  1. Files that are not valid UTF-8 (latin-1/cp1252 storage, broken multi-byte)
  2. U+FFFD replacement characters
  3. Latin-1-misread mojibake signatures in decoded text (the "double-encoded"
     form: a superscript A-with-diacritic beside another non-ASCII letter, or
     a euro-sign preceded by a circumflex A — these only ever appear when
     UTF-8 bytes were read as cp1252/latin-1 and re-saved)
  4. \uXXXX escape sequences inside HTML/JS that decode to mojibake characters
     (e.g. the escape for capital I-circumflex where a capital C-cedilla was
     meant; missed by byte-level scans)
  5. Lossy non-ASCII flattening: a non-ASCII character replaced by literal '?'
     characters, one per code unit (UTF-16 pass) or one per byte (UTF-8 pass).
     This damage is invisible to checks 1-4 - the result is still valid UTF-8
     with no U+FFFD and no mojibake signature - so it needs its own signature.
     Two shapes are detectable without a hand-kept glyph list: a run of two or
     more '?', and a single '?' welded between two word characters. Both are
     suppressed inside fenced blocks, inline code spans and URLs, where '?' is
     legitimately frequent (regex, ternary, query strings, C# nullable types).

Usage: python Scripts/Mojibake-Scan.py [root]
Scans the given directory recursively (default: repo root).
Exit code 0 = clean, 1 = findings.
"""
import os
import re
import sys

# Extensions / names treated as text. Everything else is skipped (binary).
TEXT_HINTS = {
    ".ps1", ".md", ".html", ".htm", ".json", ".yml", ".yaml", ".admx", ".adml",
    ".xml", ".txt", ".csv", ".gitignore", ".js", ".css", ".hatrules", ".py",
    ".code-workspace", ".mdx",
}
ALWAYS_TEXT = {".gitignore", ".gitattributes", "Dockerfile", "LICENSE",
               "CHANGELOG", "index.html"}
SKIP_DIRS = {".git", "node_modules", ".vs", "bin", "obj"}

# Mojibake signatures searched on the DECODED text. These characters cannot
# legitimately appear in English/Turkish prose; they are the cp1252/latin-1
# renderings of UTF-8 multibyte sequences. Calibrated: 0 hits on a clean tree,
# ~2436 hits on the previously corrupted tree.
PATTERNS = [
    # each pattern names the mojibake signature family it detects
    ("latin1-misread-c3", re.compile(r"\u00C3[\u0080-\u02FF]")),
    ("latin1-misread-c4", re.compile(r"\u00C4[\u0080-\u02FF]")),
    ("latin1-misread-c5", re.compile(r"\u00C5[\u0080-\u02FF]")),
    ("latin1-misread-c2", re.compile(r"\u00C2[\u00A0-\u00BF]")),
    ("cp1252-emdash", re.compile(r"\u00E2\u20AC[\u0080-\u00BF]")),
    ("cp1252-quotes", re.compile(r"\u00E2\u20AC[\u0153\"]|\u00E2\u20AC\u2122")),
    ("replacement-char", re.compile(r"\uFFFD")),
    ("cp1252-punct", re.compile(r"\u00E2\u20AC")),
]

# \uXXXX codepoints that can only be mojibake in an EN/TR project (the latin-1
# superscript A-with-diacritic family and capital I-circumflex — non-Turkish
# letters that cannot be intended).
SUSPICIOUS_ESCAPES = {0x00C2, 0x00C3, 0x00C4, 0x00C5, 0x00CE}
ESCAPE_RX = re.compile(r"\\u([0-9a-fA-F]{4})")

# --- lossy non-ASCII flattening -------------------------------------------
# A non-ASCII character turned into literal '?'. The count is the code unit
# count under a UTF-16 pass (1 for BMP, 2 for astral, 3 with a variation
# selector) or the byte count under a UTF-8 pass (2 for Turkish letters, 3 for
# an em dash, 4 for an emoji). Neither count is ever a natural number of
# question marks in prose, so the run itself is the signature.
QUESTION_RUN_RX = re.compile(r"\?{2,}")

# The single-'?' variant: a BMP character damaged by a UTF-16 pass leaves one
# '?' standing where no question mark belongs - welded between two word
# characters, the way the Turkish word below reads with its diacritics gone.
# Written with escaped question marks so this file does not flag itself.
QUESTION_GLUE_RX = re.compile(r"(?<=[^\W_])\?(?=[^\W_])", re.UNICODE)

FENCE_RX = re.compile(r"^\s{0,3}(`{3,}|~{3,})")
CODE_SPAN_RX = re.compile(r"`+[^`\n]*`+")
URL_RX = re.compile(r"(?:https?|ftp|mailto):[^\s)\]>'\"`]+|\]\([^)\s]*\)")
# Query-string start: '?q=', '?output=chrome'. Policy templates carry URL
# placeholders with no scheme ('{google:baseURL}search?q={searchTerms}'), so a
# URL-only mask leaves every one of them flagged as glued '?'.
QUERY_RX = re.compile(r"\?[A-Za-z_][A-Za-z0-9_]*=")


def is_probably_text(b):
    if not b:
        return True
    zeros = b.count(0)
    if zeros and (zeros / len(b)) > 0.05 and zeros > 8:
        return False
    return True


def decode_utf8(b):
    """Returns decoded text, or None if the file is not valid UTF-8."""
    # BOM is tolerated (BraveOmega.ps1 intentionally carries one for PS 5.1).
    if b.startswith(b"\xff\xfe") or b.startswith(b"\xfe\xff"):
        return None
    try:
        return b.decode("utf-8-sig")
    except UnicodeDecodeError:
        return None


def scan_escapes(text):
    r"""Flags \uXXXX escapes decoding to mojibake chars (HTML/JS only)."""
    hits = []
    for m in ESCAPE_RX.finditer(text):
        cp = int(m.group(1), 16)
        if cp in SUSPICIOUS_ESCAPES:
            start = max(0, m.start() - 20)
            end = min(len(text), m.end() + 20)
            ctx = text[start:end].replace("\n", " ")
            hits.append((m.group(0), ctx))
    return hits


def code_mask(text):
    """True where a '?' is legitimate: fenced blocks, code spans, URLs.

    Fenced blocks are matched per line so an unterminated fence still masks to
    end of file rather than swallowing the rest of the document.
    """
    mask = [False] * len(text)

    def paint(a, b):
        for i in range(max(0, a), min(len(text), b)):
            mask[i] = True

    for rx in (CODE_SPAN_RX, URL_RX, QUERY_RX):
        for m in rx.finditer(text):
            paint(*m.span())

    fence = None
    offset = 0
    for line in text.split("\n"):
        m = FENCE_RX.match(line)
        if fence is None:
            if m:
                fence = m.group(1)
                paint(offset, offset + len(line))
        else:
            paint(offset, offset + len(line))
            if m and m.group(1)[0] == fence[0] and len(m.group(1)) >= len(fence):
                fence = None
        offset += len(line) + 1
    return mask


def scan_questions(text):
    r"""Flags '?' runs and glued '?' - the lossy non-ASCII flattening signature.

    Returns (category, run, line_number, column, context) tuples.
    """
    mask = code_mask(text)
    hits = []
    for category, rx in (("question-run", QUESTION_RUN_RX),
                         ("question-glue", QUESTION_GLUE_RX)):
        for m in rx.finditer(text):
            if mask[m.start()]:
                continue
            line = text.count("\n", 0, m.start()) + 1
            col = m.start() - (text.rfind("\n", 0, m.start()) + 1) + 1
            start = max(0, m.start() - 40)
            end = min(len(text), m.end() + 40)
            ctx = text[start:end].replace("\n", " ").replace("\r", " ")
            hits.append((category, m.group(0), line, col, ctx))
    return hits


def main():
    root = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else ".")
    findings = []
    nfiles = 0

    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for fn in sorted(filenames):
            ext = os.path.splitext(fn)[1].lower()
            if ext not in TEXT_HINTS and fn not in ALWAYS_TEXT:
                continue
            full = os.path.join(dirpath, fn)
            rel = os.path.relpath(full, root)
            with open(full, "rb") as f:
                b = f.read()
            if not is_probably_text(b):
                continue
            nfiles += 1
            text = decode_utf8(b)
            if text is None:
                findings.append((rel, "not-valid-utf8",
                                 "file is not valid UTF-8 (latin-1/cp1252 or "
                                 "broken multibyte storage)"))
                continue
            for name, rx in PATTERNS:
                for m in rx.finditer(text):
                    start = max(0, m.start() - 40)
                    end = min(len(text), m.end() + 40)
                    ctx = text[start:end].replace("\n", " ").replace("\r", " ")
                    findings.append((rel, name,
                                     f"{m.group(0)!r} ctx=[...{ctx}...]"))
            # Escape-level check only where \uXXXX is meaningful (HTML/JS).
            if ext in {".html", ".htm", ".js"} or fn == "index.html":
                for esc, ctx in scan_escapes(text):
                    findings.append((rel, "suspicious-escape",
                                     f"{esc} decodes to mojibake ctx=[...{ctx}...]"))
            for cat, run, line, col, ctx in scan_questions(text):
                findings.append((rel, cat,
                                 f"L{line}:{col} {run!r} ctx=[...{ctx}...]"))

    print(f"scanned {nfiles} text files under {root}")
    if findings:
        for rel, cat, detail in findings:
            print(f"[{cat}] {rel}: {detail}")
        print(f"\nFAIL: {len(findings)} mojibake/UTF-8 finding(s)")
        return 1
    print("CLEAN")
    return 0


if __name__ == "__main__":
    sys.exit(main())