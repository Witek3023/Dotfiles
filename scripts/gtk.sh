#!/usr/bin/env bash
set -e

echo "Instaling dependencies..."
sudo dnf install -y git gtk3 gtk4 libadwaita sassc

echo "Downloading theme..."
# używamy tymczasowego katalogu
TMP_THEME_DIR=$(mktemp -d /tmp/orchis-XXXX)
cd "$TMP_THEME_DIR"

if [ ! -d "Orchis-theme" ]; then
    git clone https://github.com/vinceliuice/Orchis-theme.git
else
    echo "Exists, updating..."
    cd Orchis-theme
    git pull
fi

cd "$TMP_THEME_DIR/Orchis-theme"

echo "Installing Orchis-theme..."
./install.sh -t green -c dark --tweaks solid nord -l

GTK_THEME="Orchis-Green-Dark-Nord"
echo "Setting theme..."
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

echo "Linking for libadwaita..."
sudo rm -rf ~/.config/gtk-4.0 
ln -s ~/.local/share/themes/Orchis-Green-Dark-Nord/gtk-4.0 ~/.config/gtk-4.0

# usuwamy katalog tymczasowy po instalacji
rm -rf "$TMP_THEME_DIR"

ICON_DIR="$HOME/.local/share/icons"
mkdir -p "$ICON_DIR"
cd "$ICON_DIR"

echo "Installing icons..."
if [ ! -d "Tela-circle-icon-theme" ]; then
    git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
    cd Tela-circle-icon-theme
else
    cd Tela-circle-icon-theme
    git pull
fi

echo "Instalacja ikon Tela Circle (nord)..."
./install.sh nord

ICON_THEME="Tela-circle-nord"
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"

sudo flatpak override --filesystem=/usr/share/themes:ro
sudo flatpak override --filesystem=/usr/share/icons:ro
sudo flatpak override --filesystem=/usr/share/fonts:ro
sudo flatpak override --filesystem=$HOME/.local/share/themes:ro
sudo flatpak override --filesystem=$HOME/.local/share/icons:ro
sudo flatpak override --filesystem=$HOME/.local/share/fonts:ro
sudo flatpak override --filesystem=$HOME/.config/gtk-3.0:ro
sudo flatpak override --filesystem=$HOME/.config/gtk-4.0:ro

echo "Icons instaled and set."
echo "Done"