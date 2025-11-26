#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# NX Log Viewer - Uninstallation Script
# ═══════════════════════════════════════════════════════════════════════════════

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Configuration
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/nxlogs}"

echo -e "${BOLD}${CYAN}"
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║              📋 NX Log Viewer - Uninstallation                    ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

echo "This will remove:"
echo "  - $INSTALL_DIR/nxlogs"
echo "  - $CONFIG_DIR/ (optional)"
echo ""

read -p "Continue? [y/N] " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled"
    exit 0
fi

# Remove binary
if [[ -f "$INSTALL_DIR/nxlogs" ]]; then
    rm -f "$INSTALL_DIR/nxlogs"
    echo -e "${GREEN}✓${RESET} Removed $INSTALL_DIR/nxlogs"
else
    echo -e "${YELLOW}!${RESET} Binary not found at $INSTALL_DIR/nxlogs"
fi

# Ask about config
if [[ -d "$CONFIG_DIR" ]]; then
    read -p "Remove configuration directory ($CONFIG_DIR)? [y/N] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$CONFIG_DIR"
        echo -e "${GREEN}✓${RESET} Removed $CONFIG_DIR"
    else
        echo -e "${YELLOW}!${RESET} Kept configuration at $CONFIG_DIR"
    fi
fi

echo -e "\n${GREEN}${BOLD}✓ Uninstallation complete!${RESET}\n"

echo -e "${YELLOW}Note:${RESET} You may want to remove the PATH export from your shell config"
echo "      if you added it during installation."
echo ""
