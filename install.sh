#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# NX Log Viewer - Installation Script
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
REPO_URL="https://github.com/Maximus-Canada/nx-log-viewer"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/nxlogs}"

echo -e "${BOLD}${CYAN}"
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║              📋 NX Log Viewer - Installation                      ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

# Check if running from cloned repo or via curl
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "$SCRIPT_DIR/bin/nxlogs" ]]; then
    # Installing from cloned repo
    SOURCE_DIR="$SCRIPT_DIR"
    echo -e "${CYAN}Installing from local repository...${RESET}"
else
    # Installing via curl - need to download
    echo -e "${CYAN}Downloading NX Log Viewer...${RESET}"
    
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT
    
    if command -v git &> /dev/null; then
        git clone --depth 1 "$REPO_URL" "$TEMP_DIR/nx-log-viewer" 2>/dev/null || {
            echo -e "${RED}Failed to clone repository${RESET}"
            exit 1
        }
        SOURCE_DIR="$TEMP_DIR/nx-log-viewer"
    else
        echo -e "${RED}Git is required for installation${RESET}"
        echo "Please install git and try again"
        exit 1
    fi
fi

# Create install directory
echo -e "\n${CYAN}Creating directories...${RESET}"
mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR"

# Install the main script
echo -e "${CYAN}Installing nxlogs...${RESET}"
cp "$SOURCE_DIR/bin/nxlogs" "$INSTALL_DIR/nxlogs"
chmod +x "$INSTALL_DIR/nxlogs"

# Install example config if it doesn't exist
if [[ ! -f "$CONFIG_DIR/config" ]] && [[ -f "$SOURCE_DIR/.nxlogsrc.example" ]]; then
    cp "$SOURCE_DIR/.nxlogsrc.example" "$CONFIG_DIR/config.example"
fi

# Install shell completions
COMPLETION_DIR="$CONFIG_DIR/completions"
mkdir -p "$COMPLETION_DIR"
if [[ -d "$SOURCE_DIR/completions" ]]; then
    echo -e "${CYAN}Installing shell completions...${RESET}"
    cp "$SOURCE_DIR/completions/nxlogs.bash" "$COMPLETION_DIR/" 2>/dev/null || true
    cp "$SOURCE_DIR/completions/_nxlogs" "$COMPLETION_DIR/" 2>/dev/null || true
fi

# Check if install dir is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo -e "\n${YELLOW}Note: $INSTALL_DIR is not in your PATH${RESET}"
    echo ""
    echo "Add it by adding this to your ~/.bashrc or ~/.zshrc:"
    echo ""
    echo -e "  ${BOLD}export PATH=\"\$PATH:$INSTALL_DIR\"${RESET}"
    echo ""
    
    # Offer to add to path automatically
    read -p "Add to PATH automatically? [Y/n] " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        SHELL_RC=""
        if [[ -f "$HOME/.zshrc" ]]; then
            SHELL_RC="$HOME/.zshrc"
        elif [[ -f "$HOME/.bashrc" ]]; then
            SHELL_RC="$HOME/.bashrc"
        fi
        
        if [[ -n "$SHELL_RC" ]]; then
            echo "" >> "$SHELL_RC"
            echo "# NX Log Viewer" >> "$SHELL_RC"
            echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_RC"
            echo -e "${GREEN}✓${RESET} Added to $SHELL_RC"
            echo -e "${YELLOW}  Run: source $SHELL_RC  (or restart your terminal)${RESET}"
        else
            echo -e "${YELLOW}Could not find shell config file${RESET}"
        fi
    fi
fi

echo -e "\n${GREEN}${BOLD}✓ Installation complete!${RESET}\n"

echo -e "${BOLD}Quick Start:${RESET}"
echo "  1. Navigate to your NX project"
echo "  2. Run: nxlogs"
echo ""
echo -e "${BOLD}Commands:${RESET}"
echo "  nxlogs              # Interactive menu"
echo "  nxlogs <app>        # View specific app logs"
echo "  nxlogs -f <app>     # Follow logs live"
echo "  nxlogs --stats      # Show statistics"
echo "  nxlogs --demo       # Generate demo logs"
echo "  nxlogs --help       # Full help"
echo ""

# Show completion instructions
echo -e "${BOLD}Shell Completions:${RESET}"
if [[ -f "$COMPLETION_DIR/nxlogs.bash" ]]; then
    echo "  Bash: Add to ~/.bashrc:"
    echo "    source $COMPLETION_DIR/nxlogs.bash"
fi
if [[ -f "$COMPLETION_DIR/_nxlogs" ]]; then
    echo "  Zsh:  Add to ~/.zshrc (before compinit):"
    echo "    fpath=($COMPLETION_DIR \$fpath)"
fi
echo ""

echo -e "${GRAY}Config: $CONFIG_DIR${RESET}"
echo -e "${GRAY}Binary: $INSTALL_DIR/nxlogs${RESET}"
echo ""
