#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Using dotfiles from: $DOTFILES_DIR"

backup_and_link() {
  local source="$1"
  local target="$2"

  if [ ! -e "$source" ]; then
    echo "[ERROR] Missing source: $source"
    return 1
  fi

  if [ -L "$target" ]; then
    local current
    current="$(readlink -f "$target")"

    if [ "$current" = "$source" ]; then
      echo "[SKIP] $target already linked correctly"
      return
    fi

    echo "[BACKUP] Wrong symlink found: $target -> $current"
    mv "$target" "${target}.backup"
  elif [ -e "$target" ]; then
    echo "[BACKUP] $target -> ${target}.backup"
    mv "$target" "${target}.backup"
  fi

  echo "[LINK] $target -> $source"
  ln -s "$source" "$target"
}

mkdir -p "$HOME/.config"

CONFIGS=(
  hypr
  kitty
  nvim
  matugen
  cava
  easyeffects
  spicetify
  swayosd
  qt5ct
  qt6ct
  gtk-3.0
  gtk-4.0
)

for config in "${CONFIGS[@]}"; do
  backup_and_link \
    "$DOTFILES_DIR/$config" \
    "$HOME/.config/$config"
done

backup_and_link \
  "$DOTFILES_DIR/mimeapps.list" \
  "$HOME/.config/mimeapps.list"

backup_and_link \
  "$DOTFILES_DIR/.zshrc" \
  "$HOME/.zshrc"

echo
echo "[DONE] Dotfiles installed successfully."
