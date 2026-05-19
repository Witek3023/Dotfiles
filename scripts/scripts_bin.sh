#!/usr/bin/env bash
#           _ _       _
# __      _(_) |_ ___| | ____ _
# \ \ /\ / / | __/ _ \ |/ / _` |
#  \ V  V /| | ||  __/   < (_| |
#   \_/\_/ |_|\__\___|_|\_\__, |
#                         |___/
# Witek3023
# https://github.com/Witek3023

set -e

BIN_DIR="$HOME/.local/bin"
REPO_URL="https://gitlab.com/dwt1/shell-color-scripts.git"
TMP_DIR="/tmp/shell-color-scripts"

mkdir -p "$BIN_DIR"

if [ -d "$BIN_DIR/colorscripts" ]; then
    echo "--- Shell-color-scripts already installed. Skipping. ---"
else
    echo "Installing shell-color-scripts..."
    rm -rf "$TMP_DIR"
    git clone --depth 1 "$REPO_URL" "$TMP_DIR"
    cp -r "$TMP_DIR/colorscripts" "$BIN_DIR/"
    chmod +x "$BIN_DIR/colorscripts"/*
    rm -rf "$TMP_DIR"
    echo "Done with color scripts."
fi

if [ -f "$BIN_DIR/rickroll" ]; then
    echo "--- Rickroll already installed. Skipping. ---"
else
    echo "Installing rickrollrc..."
    curl -fsSL https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh -o "$BIN_DIR/rickroll"
    chmod +x "$BIN_DIR/rickroll"
    echo "Done with rickroll."
fi

echo "All tasks finished."