#!/bin/bash
# ============================================================
#  ORIZON — KDE Hotkeys
#  Usage: bash scripts/hotkeys.sh
#  IMPORTANT: run inside a Plasma session (not via sudo)
# ============================================================

GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'; BOLD='\033[1m'

echo -e "${CYAN}${BOLD}[ORIZON]${NC} Configuring hotkeys..."

# Function — writes and immediately applies via qdbus
set_hotkey() {
    local group="$1" key="$2" value="$3" label="$4"
    kwriteconfig5 --file kglobalshortcutsrc --group "$group" --key "$key" "$value"
    echo -e "${GREEN}  ✓${NC} $label"
}

# ── Terminal ──────────────────────────────────────────────────
set_hotkey "org.kde.konsole.desktop" "_launch" \
    "Ctrl+Alt+T,none,Konsole" "Ctrl+Alt+T → Konsole"

# ── File manager ─────────────────────────────────────────────
set_hotkey "org.kde.dolphin.desktop" "_launch" \
    "Meta+E,none,Dolphin" "Win+E → Dolphin"

set_hotkey "org.kde.ark.desktop" \
    "Meta+Shift+A,none,Ark" "Meta+Shift+A → Ark"

# ── Show desktop ─────────────────────────────────────────────
set_hotkey "kwin" "Show Desktop" \
    "Meta+D,Meta+D,Show Desktop" "Win+D → Desktop"

# ── KRunner (search / launch) ─────────────────────────────────
set_hotkey "org.kde.krunner.desktop" "_launch" \
    "Meta+R\tAlt+F2,Alt+F2,KRunner" "Win+R / Alt+F2 → KRunner"

# ── Lock screen ───────────────────────────────────────────────
set_hotkey "ksmserver" "Lock Session" \
    "Meta+L,Meta+L,Lock Session" "Win+L → Lock"

# ── Screenshot ────────────────────────────────────────────────
set_hotkey "org.kde.spectacle.desktop" "_launch" \
    "Print,Print,Spectacle" "Print → Screenshot"

set_hotkey "org.kde.spectacle.desktop" "ActiveWindowScreenShot" \
    "Meta+Print,none,Window screenshot" "Win+Print → Window screenshot"

set_hotkey "org.kde.spectacle.desktop" "RectangularRegionScreenShot" \
    "Meta+Shift+S,none,Region selection" "Win+Shift+S → Select region"

# ── ORIZON documentation (open in browser) ───────────────────
DOCS_URL="https://docs.google.com/document/d/1kA9LK5qkzpukMxPUKEU55RwFFWAMBbIhvoPwDbxWHHc/edit?usp=sharing"
kwriteconfig5 --file kglobalshortcutsrc \
    --group "org.kde.kglobalaccel" \
    --key "Alt+F1" "none"
# Register via custom shortcut (khotkeys)
KHOTKEYS_CFG="$HOME/.config/khotkeysrc"
# Add section if it doesn't exist
if ! grep -q "orizon_docs" "$KHOTKEYS_CFG" 2>/dev/null; then
    python3 - <<PYEOF
import configparser, os, re

cfg_path = os.path.expanduser("~/.config/khotkeysrc")

# Read as text to preserve section order
try:
    with open(cfg_path, "r") as f:
        content = f.read()
except FileNotFoundError:
    content = "[Data]\nDataCount=0\n"

# Get current DataCount
m = re.search(r'^\[Data\]\s*\nDataCount=(\d+)', content, re.MULTILINE)
count = int(m.group(1)) if m else 0
new_id = count + 1

# Patch DataCount
content = re.sub(
    r'(^\[Data\]\s*\nDataCount=)\d+',
    lambda mo: mo.group(1) + str(new_id),
    content, flags=re.MULTILINE
)

# Append new sections at the end
docs_url = "$DOCS_URL"
ark_entry = f"""
[Data_{new_id}]
Comment=ORIZON Docs
DataCount=1
Enabled=true
Name=orizon_docs
SystemGroup=0
Type=ACTION_DATA_GROUP

[Data_{new_id}Action0]
CommandURL=xdg-open {docs_url}
Type=COMMAND_URL_ACTION_DATA

[Data_{new_id}Trigger0]
Key=Alt+F1
Type=SHORTCUT
Uuid={{orizon-docs-trigger}}

[Data_{new_id}Conditions]
AgeRaw=0
Comment=
ConditionCount=0
"""

ark_id = new_id + 1
content_before_ark = re.sub(
    r'(^\[Data\]\s*\nDataCount=)\d+',
    lambda mo: mo.group(1) + str(ark_id),
    content, flags=re.MULTILINE
)

ark_entry2 = f"""
[Data_{ark_id}]
Comment=Ark Archive Manager
DataCount=1
Enabled=true
Name=orizon_ark
SystemGroup=0
Type=ACTION_DATA_GROUP

[Data_{ark_id}Action0]
CommandURL=ark
Type=COMMAND_URL_ACTION_DATA

[Data_{ark_id}Trigger0]
Key=Meta+Shift+A
Type=SHORTCUT
Uuid={{orizon-ark-trigger}}

[Data_{ark_id}Conditions]
AgeRaw=0
Comment=
ConditionCount=0
"""

with open(cfg_path, "w") as f:
    f.write(content_before_ark + docs_url + ark_entry2)

print("khotkeysrc updated")
PYEOF
fi
echo -e "${GREEN}  ✓${NC} Alt+F1 → ORIZON Documentation"

# ── Ark (archive manager) ─────────────────────────────────────
echo -e "${GREEN}  ✓${NC} Win+Shift+A → Ark"

# ── Apply immediately via DBus ────────────────────────────────
echo ""
echo -e "${CYAN}  Applying...${NC}"
qdbus org.kde.kglobalaccel /kglobalaccel \
    org.kde.KGlobalAccel.reconfigure 2>/dev/null || true

# Restart kglobalaccel for reliability
kquitapp5 kglobalaccel 2>/dev/null || true
sleep 1
kglobalaccel5 & disown 2>/dev/null || true

# Restart khotkeys to apply new hotkeys
kquitapp5 khotkeys 2>/dev/null || true
sleep 1
khotkeys & disown 2>/dev/null || true

echo ""
echo -e "${GREEN}${BOLD}✓ Hotkeys configured!${NC}"
echo ""
echo -e "  ${CYAN}Ctrl+Alt+T${NC}    — Konsole"
echo -e "  ${CYAN}Win+E${NC}         — Dolphin"
echo -e "  ${CYAN}Win+D${NC}         — Desktop"
echo -e "  ${CYAN}Win+R${NC}         — KRunner"
echo -e "  ${CYAN}Win+L${NC}         — Lock"
echo -e "  ${CYAN}Print${NC}         — Screenshot"
echo -e "  ${CYAN}Win+Shift+S${NC}   — Select region"
echo -e "  ${CYAN}Alt+F1${NC}        — ORIZON Documentation"
echo -e "  ${CYAN}Win+Shift+A${NC}   — Ark"
echo ""