#!/bin/bash

set -e

echo "Starting SDDM Theme installation..."

#installsddm
#enable service
#  sudo nano /usr/share/wayland-sessions/labwc.desktop
#   GNU nano 8.7.1                             /usr/share/wayland-sessions/labwc.desktop                                        
# [Desktop Entry]
# Name=labwc
# Exec=labwc
# Type=Application
# DesktopNames=labwc


# systemctl restart

# 1. Set the current theme in sddm.conf
echo "Configuring /etc/sddm.conf..."
echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf > /dev/null

# 2. Copy the modified theme to the system's SDDM theme directory
echo "Copying modified theme from ~/Dotfiles..."
THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"

# Ensure the base themes directory exists
sudo mkdir -p /usr/share/sddm/themes

# Remove the old theme directory if it already exists to ensure a clean install
if [ -d "$THEME_DIR" ]; then
    echo "Removing existing theme directory..."
    sudo rm -rf "$THEME_DIR"
fi

# Copy the modified folder and rename it to match the config
sudo cp -r ~/Dotfiles/sddm_astronaut_theme_modified "$THEME_DIR"

echo "Installation complete! You can test the theme using:"
echo "sddm-greeter --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme"