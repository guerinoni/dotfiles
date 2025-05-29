#! /bin/zsh

# -e exit on error
# -u error on undefined variables
# -o option
# pipefail exits on command pipe failures
set -euo pipefail

echo "installing nvim things..."

# nvim
mkdir -p "$HOME/.config/nvim"
ln -sfn "$PWD/config/nvim/init.lua" "$HOME/.config/nvim/init.lua"

echo "running macos defaults..."
# macos
./macos.sh

echo "installing with brew"
./brew.sh

# alias
ln -sfn "$PWD/.alias" "$HOME/.alias"

# zsh
ln -sfn "$PWD/.zshrc" "$HOME/.zshrc"

# gitconfig
ln -sfn "$PWD/.gitconfig" "$HOME/.gitconfig"

# ghostty terminal
mkdir -p "$HOME/.config/ghostty/"
ln -sfn "$PWD/ghostty" "$HOME/.config/ghostty/config"

# atuin config
mkdir -p "$HOME/.config/atuin/"
ln -sfn "$PWD/atuin" "$HOME/.config/atuin/config.toml"

# nvim
ln -sfn "$PWD/config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
ln -sfn "$PWD/config/nvim/lua" "$HOME/.config/nvim/lua"

# finicky
mkdir -p "$HOME/.config/finicky"
ln -sfn "$PWD/finicky" "$HOME/.config/finicky/finicky.js"

# install devbox
curl -fsSL https://get.jetify.com/devbox | bash

echo "finished :)"
