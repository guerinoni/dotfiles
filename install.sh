#!/bin/zsh

set -euo pipefail

# Get the directory this script resides in
SCRIPT_DIR="$(cd -- "$(dirname "$0")" && pwd)"

log() {
  echo "\033[1;32m==>\033[0m $1"
}

symlink() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  log "Linked $src → $dest"
}

log "Installing nvim config..."
symlink "$SCRIPT_DIR/config/nvim/lazy-lock.json" "$HOME/.config/nvim/lazy-lock.json"
symlink "$SCRIPT_DIR/config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
symlink "$SCRIPT_DIR/config/nvim/lua" "$HOME/.config/nvim/lua"

log "Linking shell configs..."
symlink "$SCRIPT_DIR/.alias" "$HOME/.alias"
symlink "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
symlink "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"
symlink "$SCRIPT_DIR/.hushlogin" "$HOME/.hushlogin"
symlink "$SCRIPT_DIR/.editorconfig" "$HOME/.editorconfig"

log "Setting up terminal config..."
symlink "$SCRIPT_DIR/ghostty" "$HOME/.config/ghostty/config"

log "Setting up Atuin config..."
symlink "$SCRIPT_DIR/atuin" "$HOME/.config/atuin/config.toml"

log "Running macOS defaults script..."
if [[ -x "$SCRIPT_DIR/macos.sh" ]]; then
  "$SCRIPT_DIR/macos.sh"
else
  log "Skipped: macos.sh not found or not executable"
fi

log "Installing Homebrew if needed..."
if ! command -v brew >/dev/null 2>&1; then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

log "Running brew bundle..."
if [[ -f "$SCRIPT_DIR/Brewfile" ]]; then
  brew bundle --file="$SCRIPT_DIR/Brewfile"
else
  log "Skipped: Brewfile not found"
fi

log "Installing Devbox..."
if command -v devbox >/dev/null 2>&1; then
  log "Skipped: devbox already installed"
elif command -v curl >/dev/null 2>&1; then
  curl -fsSL https://get.jetify.com/devbox | bash
else
  log "Error: curl is not installed, cannot install Devbox"
fi

log "Setup complete 🎉"
