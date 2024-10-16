#! /bin/sh

/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"

brew install git gpg2 orbstack git-delta wget gh nvim ripgrep libpq atuin direnv gitui

brew install --cask font-iosevka
brew install --cask browserosaurus
brew install --cask rectangle
brew install --cask bitwarden
brew install --cask maccy
brew install --cask brave-browser
brew install --cask zen-browser
brew install --cask zed
brew install --cask notion-calendar
brew install --cask telegram
brew install --cask discord
brew install --cask slack
brew install --cask tableplus
brew install --cask proxyman


brew cleanup
