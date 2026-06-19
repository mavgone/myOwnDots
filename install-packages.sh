#!/usr/bin/env bash

set -euo pipefail

if ! command -v pacman >/dev/null 2>&1; then
  echo "[ERROR] This script requires Arch Linux."
  exit 1
fi

if ! command -v paru >/dev/null 2>&1; then
  echo "[ERROR] paru is not installed."
  echo "Install paru first, then rerun this script."
  exit 1
fi

echo "[INFO] Installing official packages..."
sudo pacman -S --needed $(<packages.txt)

echo
echo "[INFO] Installing AUR packages..."
paru -S --needed $(<aur_packages.txt)

echo
echo "[DONE] Packages installed successfully."
