#!/bin/sh
# Brave Omega Linux installer: writes managed JSON policies for
# Chromium-based browsers. POSIX sh only; python3 (stdlib json) renders.
#
# Usage: Install-OmegaLinux.sh [--browser brave|chrome] [--tier Tier] [--dry-run]
# Must run as root. --dry-run prints targets and JSON without writing.
set -eu

BROWSER="brave"
TIER="Balanced"
DRY_RUN=0

usage() {
    echo "usage: $0 [--browser brave|chrome] [--tier Tier] [--dry-run]" >&2
    exit 2
}

while [ $# -gt 0 ]; do
    case "$1" in
        --browser) BROWSER="$2"; shift 2 ;;
        --tier) TIER="$2"; shift 2 ;;
        --dry-run) DRY_RUN=1; shift ;;
        -h|--help) usage ;;
        *) usage ;;
    esac
done

case "$BROWSER" in
    brave|chrome) ;;
    *) echo "error: unknown browser '$BROWSER'" >&2; exit 2 ;;
esac

case "$TIER" in
    BraveOnly|Essential|Balanced|Advanced|Strict) ;;
    *) echo "error: unknown tier '$TIER'" >&2; exit 2 ;;
esac

if [ "$(id -u)" -ne 0 ]; then
    echo "error: must run as root" >&2
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    echo "error: python3 is required" >&2
    exit 1
fi

SCRIPT_DIR="$(dirname -- "$0")"
case "$SCRIPT_DIR" in
    /*) ;;
    *) SCRIPT_DIR="$PWD/$SCRIPT_DIR" ;;
esac
RENDER="$SCRIPT_DIR/Render-PolicyJSON.py"
if [ ! -f "$RENDER" ]; then
    echo "error: renderer not found at $RENDER" >&2
    exit 1
fi

DIRS=$(python3 -c 'import json,sys; print(" ".join(json.load(open(sys.argv[1] + "/../Brave-Omega/Browsers/" + sys.argv[2] + ".json"))["policyDirs"]))' "$SCRIPT_DIR" "$BROWSER")

TARGET=""
FIRST=""
# shellcheck disable=SC2086
for d in $DIRS; do
    if [ -z "$FIRST" ]; then
        FIRST="$d"
    fi
    if [ -d "/etc/$d/policies/managed" ]; then
        TARGET="/etc/$d/policies/managed"
        break
    fi
done
if [ -z "$TARGET" ]; then
    TARGET="/etc/$FIRST/policies/managed"
    if [ "$DRY_RUN" -eq 0 ]; then
        mkdir -p "$TARGET"
    fi
fi

DEST="$TARGET/brave-omega.json"
TMP_JSON=$(mktemp)
trap 'rm -f "$TMP_JSON"' EXIT INT TERM

python3 "$RENDER" --browser "$BROWSER" --tier "$TIER" --platform linux > "$TMP_JSON"
python3 -m json.tool "$TMP_JSON" > /dev/null

if [ "$DRY_RUN" -eq 1 ]; then
    echo "target: $DEST"
    cat "$TMP_JSON"
    exit 0
fi

cp "$TMP_JSON" "$DEST"
chmod 0644 "$DEST"
chown root:root "$DEST"
echo "wrote $DEST"
echo "verify at brave://policy (reload policies if the browser is open)"
