#!/usr/bin/env bash
set -e

echo "[dotfiles] Starting setup..."

# ─── 1. Ensure GNU Stow ────────────────────────────────────────────────────────
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

# ─── 2. Detect environment (macOS vs code-server) ───────────────────────────────
if [ -d "$HOME/.local/share/code-server" ]; then
  echo "[dotfiles] Detected code-server environment."
  TARGET_DIR="$HOME/.local/share/code-server"
  mkdir -p "$TARGET_DIR/User"
elif [ "$(uname)" = "Darwin" ]; then
  echo "[dotfiles] Detected macOS VS Code environment."
  TARGET_DIR="$HOME/Library/Application Support/Code"
  mkdir -p "$TARGET_DIR/User"
else
  echo "[dotfiles] Unknown environment; skipping VS Code linking."
  TARGET_DIR=""
fi

# ─── 3. Apply symlinks with Stow ────────────────────────────────────────────────
if [ -n "$TARGET_DIR" ]; then
  cd "$HOME/.dotfiles"
  echo "[dotfiles] Applying symlinks into: $TARGET_DIR"
  stow --restow --target="$TARGET_DIR" --quiet vscode
fi

# ─── 4. Install VS Code extensions ─────────────────────────────────────────────
if [ -f "$HOME/.dotfiles/vscode/extensions.txt" ]; then
  echo "[dotfiles] Installing VS Code extensions..."
  if command -v code >/dev/null 2>&1; then
    while read -r ext; do
      [[ -z "$ext" || "$ext" =~ ^# ]] && continue
      if ! code --list-extensions | grep -q "$ext"; then
        echo "  ↳ Installing: $ext"
        code --install-extension "$ext" || true
      fi
    done < "$HOME/.dotfiles/vscode/extensions.txt"
  else
    echo "[dotfiles] 'code' command not found; skipping extension install."
  fi
fi

echo "[dotfiles] Setup complete!"
