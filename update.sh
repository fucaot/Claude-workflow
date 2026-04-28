#!/bin/bash

# Claude Workflow Updater
# Incrementally updates .claude/commands and .claude/template from GitHub
# Only overwrites files that are new or have changed upstream

set -e

REPO_URL="https://github.com/fucaot/Claude-workflow"
REPO_BRANCH="main"
TEMP_DIR=$(mktemp -d)
TARGET_DIR=".claude"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

NEW_COUNT=0
UPDATED_COUNT=0
SKIPPED_COUNT=0
NEW_FILES=()
UPDATED_FILES=()
SKIPPED_FILES=()

echo -e "${GREEN}Claude Workflow Updater${NC}"
echo "================================"
echo ""

# Verify .claude exists
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}.claude directory not found. Run install.sh first.${NC}"
    exit 1
fi

# Clone latest
echo -e "${CYAN}Fetching latest from GitHub...${NC}"
git clone --depth 1 --branch "$REPO_BRANCH" "$REPO_URL" "$TEMP_DIR/repo" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to clone repository. Check your internet connection.${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi
echo -e "${GREEN}Repository fetched.${NC}"
echo ""

# Backup dir for overwritten files
backup_dir="$TARGET_DIR/backup_$(date +%Y%m%d_%H%M%S)"

# Create backup dir only when needed
NEED_BACKUP=false

update_category() {
    local src_dir="$1"
    local dst_dir="$2"
    local label="$3"

    echo -e "${CYAN}── ${label} ──${NC}"

    if [ ! -d "$src_dir" ]; then
        echo -e "${RED}  Source directory not found, skipping.${NC}"
        echo ""
        return
    fi

    mkdir -p "$dst_dir"

    for src_file in "$src_dir"/*; do
        [ -e "$src_file" ] || continue
        local fname=$(basename "$src_file")
        local dst_file="$dst_dir/$fname"

        if [ ! -f "$dst_file" ]; then
            # NEW
            cp "$src_file" "$dst_file"
            echo -e "  ${GREEN}+ ${fname}${NC} (new)"
            NEW_COUNT=$((NEW_COUNT + 1))
            NEW_FILES+=("$label/$fname")
        elif ! diff -q "$src_file" "$dst_file" > /dev/null 2>&1; then
            # UPDATED
            if [ "$NEED_BACKUP" = false ]; then
                mkdir -p "$backup_dir"
                NEED_BACKUP=true
            fi
            mkdir -p "$(dirname "$backup_dir/$label")"
            cp "$dst_file" "$backup_dir/$label/$fname"
            cp "$src_file" "$dst_file"
            echo -e "  ${YELLOW}~ ${fname}${NC} (updated, backup: $backup_dir)"
            UPDATED_COUNT=$((UPDATED_COUNT + 1))
            UPDATED_FILES+=("$label/$fname")
        else
            # UNCHANGED
            echo -e "  ${GREEN}= ${fname}${NC} (unchanged)"
            SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
            SKIPPED_FILES+=("$label/$fname")
        fi
    done
    echo ""
}

update_category "$TEMP_DIR/repo/commands" "$TARGET_DIR/commands" "commands"
update_category "$TEMP_DIR/repo/template" "$TARGET_DIR/template" "template"

# Summary
echo "================================"
echo -e "${GREEN}Update complete!${NC}"
echo ""
echo -e "  ${GREEN}New:      ${NEW_COUNT}${NC}"
echo -e "  ${YELLOW}Updated:  ${UPDATED_COUNT}${NC}"
echo -e "  ${CYAN}Unchanged: ${SKIPPED_COUNT}${NC}"

if [ "$NEED_BACKUP" = true ]; then
    echo ""
    echo -e "${YELLOW}Backup of overwritten files: $backup_dir${NC}"
fi

# Cleanup
rm -rf "$TEMP_DIR"
