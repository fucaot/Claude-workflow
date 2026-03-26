#!/bin/bash

# Claude Workflow Installer
# Downloads commands and template directories from GitHub to .claude folder

set -e

REPO_URL="https://github.com/fucaot/Claude-workflow"
REPO_BRANCH="main"
TEMP_DIR=$(mktemp -d)
TARGET_DIR=".claude"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Claude Workflow Installer${NC}"
echo "================================"
echo ""

# Check if we're in a project directory
if [ ! -d ".git" ] && [ ! -f "package.json" ] && [ ! -f "Cargo.toml" ] && [ ! -f "go.mod" ]; then
    echo -e "${YELLOW}Warning: This doesn't appear to be a project root directory.${NC}"
    echo -e "${YELLOW}Continue anyway? (y/n)${NC}"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 1
    fi
fi

# Create .claude directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${GREEN}Creating $TARGET_DIR directory...${NC}"
    mkdir -p "$TARGET_DIR"
else
    echo -e "${YELLOW}Directory $TARGET_DIR already exists.${NC}"
fi

# Backup existing directories if they exist
backup_dir="$TARGET_DIR/backup_$(date +%Y%m%d_%H%M%S)"
if [ -d "$TARGET_DIR/commands" ] || [ -d "$TARGET_DIR/template" ]; then
    echo -e "${YELLOW}Backing up existing directories...${NC}"
    mkdir -p "$backup_dir"
    [ -d "$TARGET_DIR/commands" ] && cp -r "$TARGET_DIR/commands" "$backup_dir/"
    [ -d "$TARGET_DIR/template" ] && cp -r "$TARGET_DIR/template" "$backup_dir/"
    echo -e "${GREEN}Backup created at: $backup_dir${NC}"
fi

echo ""
echo -e "${GREEN}Downloading from GitHub...${NC}"
echo "Repository: $REPO_URL"
echo "Branch: $REPO_BRANCH"
echo ""

# Method 1: Clone entire repo (simpler, more reliable)
echo -e "${YELLOW}Cloning repository to temporary directory...${NC}"
git clone --depth 1 --branch "$REPO_BRANCH" "$REPO_URL" "$TEMP_DIR/repo" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Repository cloned successfully.${NC}"
    echo ""

    # Copy directories
    echo -e "${GREEN}Copying directories to $TARGET_DIR...${NC}"

    if [ -d "$TEMP_DIR/repo/commands" ]; then
        cp -r "$TEMP_DIR/repo/commands" "$TARGET_DIR/"
        echo -e "${GREEN}✓ commands directory installed${NC}"
    else
        echo -e "${RED}✗ commands directory not found in repository${NC}"
    fi

    if [ -d "$TEMP_DIR/repo/template" ]; then
        cp -r "$TEMP_DIR/repo/template" "$TARGET_DIR/"
        echo -e "${GREEN}✓ template directory installed${NC}"
    else
        echo -e "${RED}✗ template directory not found in repository${NC}"
    fi

    # Cleanup
    rm -rf "$TEMP_DIR"
    echo ""
    echo -e "${GREEN}Installation complete!${NC}"
    echo ""
    echo -e "${GREEN}Installed to:${NC}"
    echo "  - $TARGET_DIR/commands/"
    echo "  - $TARGET_DIR/template/"
    [ -d "$backup_dir" ] && echo -e "${YELLOW}Backup saved to: $backup_dir${NC}"
else
    echo -e "${RED}Failed to clone repository.${NC}"
    echo -e "${YELLOW}Please check your internet connection and try again.${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "  1. Review the installed files in .claude/"
echo "  2. Customize commands and templates as needed"
echo "  3. Start using Claude Code with your custom workflow!"
