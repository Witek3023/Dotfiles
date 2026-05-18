#!/bin/bash

set -e

echo "Starting SDDM Theme installation..."

sudo dnf install sddm -y
sudo systemctl set-default graphical.target  
sudo systemctl enable sddm --now

echo "Configuring /etc/sddm.conf..."
echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf > /dev/null

echo "Copying modified theme from ~/Dotfiles..."
THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"

sudo mkdir -p /usr/share/sddm/themes

if [ -d "$THEME_DIR" ]; then
    echo "Removing existing theme directory..."
    sudo rm -rf "$THEME_DIR"
fi

sudo cp -r ~/Dotfiles/sddm_astronaut_theme_modified "$THEME_DIR"

echo "Configure outputs in /var/lib/sddm/.config/kwinoutputconfig.json"
echo "Installation complete!"
