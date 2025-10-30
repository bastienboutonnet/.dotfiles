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

  # Detect correct binary
  if command -v code >/dev/null 2>&1; then
    INSTALL_CMD="code"
  elif command -v code-server >/dev/null 2>&1; then
    INSTALL_CMD="code-server"
  elif [ -x "/tmp/coder-script-data/bin/code-server" ]; then
    INSTALL_CMD="/tmp/coder-script-data/bin/code-server"
  else
    INSTALL_CMD=""
  fi

  if [ -n "$INSTALL_CMD" ]; then
    while read -r ext; do
      [[ -z "$ext" || "$ext" =~ ^# ]] && continue
      if ! $INSTALL_CMD --list-extensions | grep -q "$ext"; then
        echo "  ↳ Installing: $ext"
        $INSTALL_CMD --install-extension "$ext" || true
      fi
    done < "$EXT_LIST"
    echo "[dotfiles] Extension sync complete!"
  else
    echo "[dotfiles] No VS Code binary found; skipping extension install."
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
    # Clear stale cached theme state so VS Code re-applies the theme on next load
    rm -f "$HOME/.local/share/code-server/User/workbenchState.json" || true
  fi
fi

# ─── 6. Wrap up ────────────────────────────────────────────────────────────────
echo "[dotfiles] Setup complete!"
sleep 2
