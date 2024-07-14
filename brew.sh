#! /bin/sh

/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"

brew install gpg2 orbstack git-delta wget gh nvim ripgrep libpq xsv atuin direnv

brew install --cask font-iosevka

brew install --cask browserosaurus # browser selector on link click :)
brew install --cask wezterm
brew install --cask rectangle
brew install --cask bitwarden
brew install --cask maccy
brew install --cask redisinsight

brew cleanup
