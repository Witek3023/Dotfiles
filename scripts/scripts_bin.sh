#!/usr/bin/env bash
set -e

BIN_DIR="$HOME/.local/bin"
REPO_URL="https://gitlab.com/dwt1/shell-color-scripts.git"
TMP_DIR="/tmp/shell-color-scripts"

mkdir -p "$BIN_DIR"

echo "Installing shell-color-scripts..."

echo "Cloning repository..."
rm -rf "$TMP_DIR"
git clone "$REPO_URL" "$TMP_DIR"

echo "Creating target directory: $BIN_DIR"
mkdir -p "$BIN_DIR"

echo "Copying color scripts..."
cp -r "$TMP_DIR/colorscripts/"* "$BIN_DIR/"

echo "Making scripts executable..."
chmod +x "$BIN_DIR"/*

echo "Cleaning up..."
rm -rf "$TMP_DIR"

echo "Done! Make sure $HOME/.local/bin is in your PATH."

echo "Installing rickrollrc..."

curl -fsSL \
https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh \
-o "$BIN_DIR/rickroll"

chmod +x "$BIN_DIR/rickroll"

echo "Done. Restart shell or run: source ~/.zshrc"