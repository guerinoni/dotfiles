#!/bin/sh

set -euo pipefail

log() {
  printf "\033[1;34m==>\033[0m %s\n" "$1"
}

install_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    log "Installing Homebrew..."
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    log "Homebrew already installed"
  fi
}

install_formulae() {
  FORMULAE=(
    git
    gh
    gpg2
    tree
    git-delta
    orbstack
    wget
    nvim
    ripgrep
    libpq
    atuin
    direnv
    gitui
    finicky
  )

  log "Installing CLI tools..."
  for formula in "${FORMULAE[@]}"; do
    if ! brew list "$formula" >/dev/null 2>&1; then
      brew install "$formula"
    else
      log "$formula already installed"
    fi
  done
}

install_casks() {
  CASKS=(
    font-iosevka
    font-jetbrains-mono
    rectangle
    bitwarden
    maccy
    brave-browser
    zen-browser
    zed
    notion-calendar
    telegram
    discord
    slack
    proxyman
    netnewswire
    mongodb-compass
    visual-studio-code
  )

  log "Installing GUI applications..."
  for cask in "${CASKS[@]}"; do
    if ! brew list --cask "$cask" >/dev/null 2>&1; then
      brew install --cask "$cask"
    else
      log "$cask already installed"
    fi
  done
}

cleanup() {
  log "Cleaning up Homebrew..."
  brew cleanup
}

### Run steps
install_brew
install_formulae
install_casks
cleanup

log "Brew setup complete ✅"
