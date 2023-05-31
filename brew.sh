#! /bin/sh

/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"

brew install docker ripgrep git-delta wget graphviz jq cmake watch tree gh nvim
brew tap homebrew/cask-fonts
brew install --cask font-iosevka
brew install --cask browserosaurus # browser selector on link click :)
brew install --cask iterm2
brew install --cask rectangle

brew cleanup
