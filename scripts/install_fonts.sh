#!/usr/bin/env bash
set -e

FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
FONT_DIR="/usr/share/fonts/JetBrainsMono"
FONT_NAME="JetBrainsMono Nerd Font"

echo "==> Checking font..."

if fc-list | grep -qi "$FONT_NAME"; then
    echo "Jet Brains Mono already installed"
fi

echo "==> Installing font..."

sudo dnf install -y curl unzip fontconfig

sudo mkdir -p "$FONT_DIR"

curl -L "$FONT_URL" -o /tmp/JetBrainsMono.zip
sudo unzip -o /tmp/JetBrainsMono.zip -d "$FONT_DIR"

sudo fc-cache -fv

rm /tmp/JetBrainsMono.zip

sudo flatpak override --filesystem=/usr/share/fonts:ro
sudo flatpak override --filesystem=$HOME/.local/share/fonts:ro

echo "Font installed"
