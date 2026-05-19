#!/bin/bash
#           _ _       _
# __      _(_) |_ ___| | ____ _
# \ \ /\ / / | __/ _ \ |/ / _` |
#  \ V  V /| | ||  __/   < (_| |
#   \_/\_/ |_|\__\___|_|\_\__, |
#                         |___/
# Witek3023
# https://github.com/Witek3023

echo "Installing packages..."
sudo dnf install -y adwaita-cursor-theme adwaita-icon-theme xdg-desktop-portal-gtk xdg-desktop-portal-wlr qt5ct qt6ct

echo "Installing icon theme"
git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git /tmp/Tela-circle-icon-theme
sudo /tmp/Tela-circle-icon-theme/install.sh -c green -d /usr/share/icons
rm -rf /tmp/Tela-circle-icon-theme

echo "Setting theme..."
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-green'
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface font-name 'IBM Plex Sans 14'

mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

cat <<EOF > ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Tela-circle-green
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
EOF

cp ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini

echo "Setting flatpaks theme..."

if command -v flatpak &> /dev/null; then
    flatpak install -y org.gtk.Gtk3theme.Adwaita-dark
    flatpak install -y org.kde.KStyle.Adwaita
    flatpak override --user --env=XCURSOR_THEME=Adwaita
    flatpak override --user --env=XCURSOR_SIZE=24
    flatpak override --user --filesystem=/usr/share/icons:ro
    flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
    flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
    flatpak override --user --filesystem=xdg-config/qt5ct:ro
    flatpak override --user --filesystem=xdg-config/qt6ct:ro
    flatpak override --user --env=GTK_THEME=Adwaita:dark
    flatpak override --user --env=ICON_THEME=Tela-circle-green
    flatpak override --user --env=QT_QPA_PLATFORMTHEME=qt5ct
else
    echo "Flatpak not installed, skipping."
fi

echo "Done!"