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

JB_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
IBM_URL="https://github.com/IBM/plex/releases/download/v6.4.0/OpenType.zip"

JB_DIR="/usr/share/fonts/JetBrainsMono"
IBM_DIR="/usr/share/fonts/IBMPlexSans"

echo "==> Setting up..."
sudo dnf install -y curl unzip fontconfig

install_font() {
    local url=$1
    local dir=$2
    local name=$3

    if fc-list | grep -qi "$name"; then
        echo "--- Font $name already installed ---"
    else
        echo "--- Installing $name... ---"
        sudo mkdir -p "$dir"
        curl -L "$url" -o /tmp/font.zip
        sudo unzip -o /tmp/font.zip -d "$dir"
        if [[ "$name" == *"IBM"* ]]; then
             echo "--- Rozpakowywanie wersji Sans... ---"
        fi
        rm /tmp/font.zip
    fi
}

install_font "$JB_URL" "$JB_DIR" "JetBrainsMono Nerd Font"
install_font "$IBM_URL" "$IBM_DIR" "IBM Plex Sans"

echo "==> Reloading cache..."
sudo fc-cache -f

echo "==> Setting flatpak overrides..."
sudo flatpak override --filesystem=/usr/share/fonts:ro
sudo flatpak override --filesystem=$HOME/.local/share/fonts:ro

echo "Done."