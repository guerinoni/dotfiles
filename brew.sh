#! /bin/sh

/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"

brew install docker git-delta wget gh nvim ripgrep libpq
brew tap homebrew/cask-fonts
brew install --cask font-iosevka
brew install --cask browserosaurus # browser selector on link click :)
brew install --cask wezterm
brew install --cask rectangle
brew install --cask arc

brew cleanup
