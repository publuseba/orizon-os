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
echo -e "  ${CYAN}Win+Shift+A${NC}   — Ark"
echo ""
