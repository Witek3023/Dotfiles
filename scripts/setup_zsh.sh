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

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.zsh}"
ZSHRC="$HOME/.zshrc"

mkdir -p "$ZSH_CUSTOM"

sudo dnf install -y zsh git fzf

install_plugin() {
  local name=$1
  local repo=$2

  if [ ! -d "$ZSH_CUSTOM/$name" ]; then
    echo "Installing $name..."
    git clone --depth 1 "$repo" "$ZSH_CUSTOM/$name"
  else
    echo "$name already installed"
  fi
}

ensure_in_zshrc() {
  local line=$1
  grep -Fxq "$line" "$ZSHRC" || echo "$line" >> "$ZSHRC"
}

install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"

ZSH_PATH="$(which zsh)"

if [ "$SHELL" != "$ZSH_PATH" ]; then
  echo "Changing default shell to zsh..."
  chsh -s "$ZSH_PATH"
  echo "Done. Log out and log back in."
else
  echo "Zsh already default shell"
fi

echo "Setup complete. Run: exec zsh"