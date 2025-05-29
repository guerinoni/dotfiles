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
symlink "$SCRIPT_DIR/config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
symlink "$SCRIPT_DIR/config/nvim/lua" "$HOME/.config/nvim/lua"

log "Linking shell configs..."
symlink "$SCRIPT_DIR/.alias" "$HOME/.alias"
symlink "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
symlink "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"

log "Setting up terminal config..."
symlink "$SCRIPT_DIR/ghostty" "$HOME/.config/ghostty/config"

log "Setting up Atuin config..."
symlink "$SCRIPT_DIR/atuin" "$HOME/.config/atuin/config.toml"

log "Setting up Finicky config..."
symlink "$SCRIPT_DIR/finicky.js" "$HOME/.config/finicky/finicky.js"

log "Running macOS defaults script..."
if [[ -x "$SCRIPT_DIR/macos.sh" ]]; then
  "$SCRIPT_DIR/macos.sh"
else
  log "Skipped: macos.sh not found or not executable"
fi

log "Running brew setup..."
if [[ -x "$SCRIPT_DIR/brew.sh" ]]; then
  "$SCRIPT_DIR/brew.sh"
else
  log "Skipped: brew.sh not found or not executable"
fi

log "Installing Devbox..."
if command -v curl &>/dev/null; then
  curl -fsSL https://get.jetify.com/devbox | bash
else
  log "Error: curl is not installed, cannot install Devbox"
fi

log "Setup complete 🎉"
