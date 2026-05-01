#!/usr/bin/env bash

set -e
THEME_NAME="sddm-astronaut-modified"
DOTFILES_DIR="$HOME/Dotfiles/sddm"
TARGET_DIR="/usr/share/sddm/themes"

SOURCE="$DOTFILES_DIR/$THEME_NAME"
DEST="$TARGET_DIR/$THEME_NAME"

REQUIRED_PACKAGES=(
    sddm
    qt6-qtsvg
    qt6-qtvirtualkeyboard
    qt6-qtmultimedia
)

echo "==> Checking dependencies..."

MISSING_PACKAGES=()

for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! rpm -q "$pkg" &>/dev/null; then
        MISSING_PACKAGES+=("$pkg")
    fi
done

if [ ${#MISSING_PACKAGES[@]} -ne 0 ]; then
    echo "Missing packages: ${MISSING_PACKAGES[*]}"
    echo "Installing..."

    sudo dnf install -y "${MISSING_PACKAGES[@]}"
else
    echo "All dependencies installed"
fi

echo "==> Checking if theme exists..."
if [ ! -d "$SOURCE" ]; then
    echo "Theme not found in $SOURCE"
    exit 1
fi

echo "==> Copying theme..."
sudo cp -r "$SOURCE/." "$DEST"
sudo chown -R root:root "$DEST"
sudo chmod -R 755 "$DEST"

echo "==> Setting theme for SDDM..."

CONFIG_FILE="/etc/sddm.conf.d/theme.conf"

sudo mkdir -p /etc/sddm.conf.d

sudo tee "$CONFIG_FILE" > /dev/null <<EOF
[Theme]
Current=$THEME_NAME
EOF

echo "Theme set to: $THEME_NAME"
