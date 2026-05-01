#!/usr/bin/env bash
set -e

FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
FONT_DIR="/usr/share/fonts/JetBrainsMono"
FONT_NAME="JetBrainsMono Nerd Font"

echo "==> Checking font..."

if fc-list | grep -qi "$FONT_NAME"; then
    echo "Font already installed"
    exit 0
fi

echo "==> Installing font..."

sudo dnf install -y curl unzip fontconfig

sudo mkdir -p "$FONT_DIR"

curl -L "$FONT_URL" -o /tmp/JetBrainsMono.zip
sudo unzip -o /tmp/JetBrainsMono.zip -d "$FONT_DIR"

sudo fc-cache -fv

rm /tmp/JetBrainsMono.zip

echo "Font installed"
