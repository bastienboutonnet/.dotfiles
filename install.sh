#!/usr/bin/env bash
set -e

echo "[dotfiles] Starting setup..."

# Ensure GNU Stow is available
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

# Detect environment: macOS VS Code vs. code-server
if [ -d "$HOME/.local/share/code-server" ]; then
  echo "[dotfiles] Detected code-server environment."
  mkdir -p "$HOME/.local/share/code-server/User"
  cd "$HOME/.dotfiles"
  stow --restow --target="$HOME/.local/share/code-server" vscode
elif [ "$(uname)" = "Darwin" ]; then
  echo "[dotfiles] Detected macOS VS Code environment."
  mkdir -p "$HOME/Library/Application Support/Code/User"
  cd "$HOME/.dotfiles"
  stow --restow vscode
else
  echo "[dotfiles] Unknown environment; skipping VS Code linking."
fi

# Optional: install VS Code extensions
if [ -f "$HOME/.dotfiles/vscode/extensions.txt" ]; then
  echo "[dotfiles] Installing extensions from extensions.txt..."
  if command -v code >/dev/null 2>&1; then
    while read -r ext; do
      [ -z "$ext" ] && continue
      code --install-extension "$ext" || true
    done < "$HOME/.dotfiles/vscode/extensions.txt"
  else
    echo "[dotfiles] 'code' command not found; skipping extension install."
  fi
fi

echo "[dotfiles] Setup complete!"
