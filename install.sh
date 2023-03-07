#! /bin/sh

# -e exit on error
# -u error on undefined variables
# -o option
# pipefail exits on command pipe failures
set -euo pipefail

echo "installing dotfiles..."

# nvim
mkdir -p "$HOME/.config/nvim"
ln -sfn "$PWD/config/nvim/init.lua" "$HOME/.config/nvim/init.lua"

# macos
./macos.sh

# alias
ln -sfn "$PWD/.alias" "$HOME/.alias"

# zsh
ln -sfn "$PWD/.zshrc" "$HOME/.zshrc"

# gitconfig
ln -sfn "$PWD/.gitconfig" "$HOME/.gitconfig"

echo "finished :)"

