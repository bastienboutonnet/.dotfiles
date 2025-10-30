#!/usr/bin/env bash
set -e

echo "[dotfiles] Starting setup..."

# ─── 1. Ensure GNU Stow ────────────────────────────────────────────────────────
if ! command -v stow >/dev/null 2>&1; then
  echo "[dotfiles] Installing GNU Stow..."
  if command -v apt-get >/dev/null 2>&1; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq stow
  elif command -v brew >/dev/null 2>&1; then
    brew install stow
  else
    echo "[dotfiles] Please install GNU Stow manually." >&2
  fi
fi

# ─── 2. Detect environment ─────────────────────────────────────────────────────
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

# ─── 3. Apply symlinks with Stow ───────────────────────────────────────────────
if [ -n "$TARGET_DIR" ]; then
  cd "$HOME/.dotfiles"
  echo "[dotfiles] Cleaning up conflicts in $TARGET_DIR/User"
  rm -f "$TARGET_DIR/User/settings.json" "$TARGET_DIR/User/keybindings.json"
  echo "[dotfiles] Applying symlinks into: $TARGET_DIR"
  stow --restow --target="$TARGET_DIR" vscode
fi

# ─── 4. Install VS Code or code-server extensions ──────────────────────────────
EXT_LIST="$HOME/.dotfiles/vscode/extensions.txt"
if [ -f "$EXT_LIST" ]; then
  echo "[dotfiles] Installing VS Code extensions..."

  # Wait up to 30s for code-server to become available
  INSTALL_CMD=""
  for i in {1..30}; do
    if command -v code >/dev/null 2>&1; then
      INSTALL_CMD="code"; break
    elif command -v code-server >/dev/null 2>&1; then
      INSTALL_CMD="code-server"; break
    elif [ -x "/tmp/coder-script-data/bin/code-server" ]; then
      INSTALL_CMD="/tmp/coder-script-data/bin/code-server"; break
    fi
    echo "[dotfiles] Waiting for code-server to become available... ($i/30)"
    sleep 1
  done

  if [ -z "$INSTALL_CMD" ]; then
    echo "[dotfiles] No VS Code binary found after waiting; skipping extension install."
  else
    echo "[dotfiles] Using: $INSTALL_CMD"
    INSTALLED=0
    SKIPPED=0
    while read -r ext; do
      [[ -z "$ext" || "$ext" =~ ^# ]] && continue
      if $INSTALL_CMD --list-extensions | grep -q "$ext"; then
        ((SKIPPED++))
      else
        echo "  ↳ Installing: $ext"
        $INSTALL_CMD --install-extension "$ext" || true
        ((INSTALLED++))
      fi
    done < "$EXT_LIST"
    echo "[dotfiles] Extension sync complete! Installed: $INSTALLED, Skipped: $SKIPPED"
  fi
else
  echo "[dotfiles] No extensions.txt found, skipping extension install."
fi

# ─── 5. Ensure theme is applied after extension install ────────────────────────
SETTINGS_FILE="$HOME/.local/share/code-server/User/settings.json"
if [ -f "$SETTINGS_FILE" ]; then
  THEME_NAME=$(grep -oP '(?<="workbench.colorTheme": ")[^"]+' "$SETTINGS_FILE" || true)
  if [ -n "$THEME_NAME" ]; then
    echo "[dotfiles] Ensuring color theme '$THEME_NAME' is applied..."
    # Clear cached theme state to force reload on next start
    rm -f "$HOME/.local/share/code-server/User/workbenchState.json" || true
  fi
fi

# ─── 6. Wrap up ────────────────────────────────────────────────────────────────
echo "[dotfiles] Setup complete!"
sleep 2
