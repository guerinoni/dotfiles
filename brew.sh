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
    git                                   # Distributed version control
    git-extras                            # Extra git commands (git-info, git-effort, etc.)
    git-delta                             # Better git diff viewer
    gh                                    # GitHub CLI
    gitui                                 # Terminal UI for git

    atuin                                 # Magical shell history
    direnv                                # Directory-based env vars
    fzf                                   # Fuzzy finder
    ripgrep                               # Fast grep alternative
    tree                                  # Directory tree view
    htop                                  # Interactive process viewer
    btop                                  # Modern resource monitor
    jq                                    # JSON processor
    yq                                    # YAML processor

    neovim                                # Modern vim
    helix                                 # Post-modern editor

    gnupg                                 # GPG encryption

    wget                                  # File download tool
    croc                                  # Secure file transfer

    k9s                                   # Kubernetes TUI
    kubectx                               # Switch k8s contexts/namespaces
    minikube                              # Local Kubernetes
    skaffold                              # K8s dev workflow

    libpq                                 # PostgreSQL client libs
    mongosh                               # MongoDB shell
    mongodb/brew/mongodb-database-tools   # MongoDB tools (mongodump, etc.)

    awscli                                # AWS CLI

    ffmpeg                                # Video/audio processing
    graphviz                              # Graph visualization
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
    font-iosevka                          # Monospace font for coding
    font-jetbrains-mono                   # JetBrains monospace font

    ghostty                               # GPU-accelerated terminal
    visual-studio-code                    # Code editor
    zed                                   # Fast collaborative editor

    orbstack                              # Docker/Linux VM (fast alternative)
    beekeeper-studio                      # SQL database GUI
    mongodb-compass                       # MongoDB GUI

    claude                                # Claude AI assistant
    ollama-app                            # Run local LLMs

    1password                             # Password manager
    1password-cli                         # 1Password CLI
    rectangle                             # Window management
    maccy                                 # Clipboard manager
    caffeine                              # Prevent sleep

    telegram                              # Messaging
    discord                               # Voice/text chat
    slack                                 # Team communication
    whatsapp                              # Messaging
    microsoft-teams                       # Microsoft Teams

    brave-browser                         # Privacy-focused browser
    google-chrome@canary                  # Chrome canary

    gcloud-cli                            # Google Cloud CLI
    google-cloud-sdk                      # Google Cloud SDK

    netnewswire                           # RSS reader
    folo                                  # RSS reader
    cap                                   # Screen recording
    utm                                   # Virtual machines
    tunnelblick                           # OpenVPN client
    wireshark-app                         # Network analyzer GUI
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
