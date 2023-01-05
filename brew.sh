#! /bin/sh

/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"

brew install ripgrep git-delta wget
brew tap homebrew/cask-fonts
brew install --cask font-iosevka
