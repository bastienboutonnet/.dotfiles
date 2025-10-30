#!/usr/bin/env bash
set -e

echo "[dotfiles] Starting setup..."

# Make sure stow is installed
if ! command -v stow >/dev/null 2>&1; then
  echo "[dotfiles] Installing GNU Stow..."
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -y && sudo apt-get install -y stow
  elif command -v brew >/dev/null 2>&1; then
    brew install stow
  else
    echo "[dotfiles] Please install GNU Stow manually." >&2
  fi
fi

# Apply only the vscode package
if [ -d "$HOME/dotfiles/vscode" ]; then
  echo "[dotfiles] Applying VS Code configuration..."
  cd "$HOME/dotfiles"
  stow vscode
else
  echo "[dotfiles] vscode/ directory not found, skipping."
fi

# Optional: install VS Code extensions if the list exists
if [ -f "$HOME/dotfiles/vscode/.vscode/extensions.txt" ]; then
  echo "[dotfiles] Installing extensions from extensions.txt..."
  while read -r ext; do
    code --install-extension "$ext" || true
  done < "$HOME/dotfiles/vscode/.vscode/extensions.txt"
else
  echo "[dotfiles] No extensions.txt found, skipping extension install."
fi

echo "[dotfiles] Setup complete!"
