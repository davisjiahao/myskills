#!/bin/bash
#
# Install script for zhipu-web-search skill
# Supports multiple AI coding clients: Claude Code, OpenCode, Cline, etc.
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_NAME="zhipu-web-search"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
INSTALL_CLAUDE=false
INSTALL_OPENCLAW=false
INSTALL_CLINE=false
INSTALL_ALL=false

show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --claude       Install to Claude Code"
    echo "  --openclaw     Install to OpenClaw"
    echo "  --cline        Install to Cline (VS Code)"
    echo "  --all          Install to all supported clients"
    echo "  -h, --help     Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --claude              # Install to Claude Code only"
    echo "  $0 --openclaw            # Install to OpenClaw only"
    echo "  $0 --all                 # Install to all clients"
    echo "  $0                       # Interactive mode (prompt for each)"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --claude)
            INSTALL_CLAUDE=true
            shift
            ;;
        --openclaw)
            INSTALL_OPENCLAW=true
            shift
            ;;
        --cline)
            INSTALL_CLINE=true
            shift
            ;;
        --all)
            INSTALL_ALL=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
done

# If no options specified, run interactive mode
if [ "$INSTALL_CLAUDE" = false ] && [ "$INSTALL_OPENCLAW" = false ] && [ "$INSTALL_CLINE" = false ] && [ "$INSTALL_ALL" = false ]; then
    echo -e "${BLUE}Interactive Installation Mode${NC}"
    echo ""

    read -p "Install to Claude Code? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_CLAUDE=true
    fi

    read -p "Install to OpenClaw? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_OPENCLAW=true
    fi

    read -p "Install to Cline? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_CLINE=true
    fi
fi

# If --all flag is set
if [ "$INSTALL_ALL" = true ]; then
    INSTALL_CLAUDE=true
    INSTALL_OPENCLAW=true
    INSTALL_CLINE=true
fi

install_to_claude() {
    local TARGET_DIR="$HOME/.claude/skills/$SKILL_NAME"
    echo -e "${GREEN}Installing to Claude Code...${NC}"

    mkdir -p "$TARGET_DIR/scripts"
    cp -r "$SCRIPT_DIR/skills/$SKILL_NAME/"* "$TARGET_DIR/"
    chmod +x "$TARGET_DIR/scripts/zhipu-search.py"

    echo -e "${GREEN}✓ Claude Code: $TARGET_DIR${NC}"
}

install_to_openclaw() {
    local TARGET_DIR="$HOME/.openclaw/skills/$SKILL_NAME"
    echo -e "${GREEN}Installing to OpenClaw...${NC}"

    mkdir -p "$TARGET_DIR/scripts"
    cp -r "$SCRIPT_DIR/skills/$SKILL_NAME/"* "$TARGET_DIR/"
    chmod +x "$TARGET_DIR/scripts/zhipu-search.py"

    echo -e "${GREEN}✓ OpenClaw: $TARGET_DIR${NC}"
}

install_to_cline() {
    # Cline stores skills in VS Code extension directory or workspace
    # For global installation, we create a symlink or copy to a common location
    local TARGET_DIR="$HOME/.cline/skills/$SKILL_NAME"
    echo -e "${GREEN}Installing to Cline...${NC}"

    mkdir -p "$TARGET_DIR/scripts"
    cp -r "$SCRIPT_DIR/skills/$SKILL_NAME/"* "$TARGET_DIR/"
    chmod +x "$TARGET_DIR/scripts/zhipu-search.py"

    echo -e "${GREEN}✓ Cline: $TARGET_DIR${NC}"
    echo -e "${YELLOW}Note: You may need to configure Cline to recognize this skill directory${NC}"
}

# Perform installations
echo -e "${BLUE}Installing zhipu-web-search skill...${NC}"
echo ""

INSTALLED_ANY=false

if [ "$INSTALL_CLAUDE" = true ]; then
    install_to_claude
    INSTALLED_ANY=true
fi

if [ "$INSTALL_OPENCLAW" = true ]; then
    install_to_openclaw
    INSTALLED_ANY=true
fi

if [ "$INSTALL_CLINE" = true ]; then
    install_to_cline
    INSTALLED_ANY=true
fi

if [ "$INSTALLED_ANY" = false ]; then
    echo -e "${YELLOW}No clients selected for installation.${NC}"
    exit 0
fi

# Check for API key
echo ""
if [ -z "$ZHIPU_API_KEY" ] && [ -z "$BIGMODEL_API_KEY" ]; then
    echo -e "${YELLOW}⚠ API key not found!${NC}"
    echo "Please set one of the following environment variables:"
    echo "  export ZHIPU_API_KEY=\"your_api_key\""
    echo "  export BIGMODEL_API_KEY=\"your_api_key\""
    echo ""
    echo "Get your API key from: https://open.bigmodel.cn/"
    echo ""
    echo "Add to your shell config (~/.zshrc or ~/.bashrc):"
    echo "  echo 'export ZHIPU_API_KEY=\"your_api_key\"' >> ~/.zshrc"
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Usage:"
echo "  ~/.claude/skills/zhipu-web-search/scripts/zhipu-search.py \"query\"    # Claude Code"
echo "  ~/.openclaw/skills/zhipu-web-search/scripts/zhipu-search.py \"query\"  # OpenClaw"
echo ""
echo "Or use via /zhipu-web-search skill in your AI client"
