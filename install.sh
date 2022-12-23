#! /bin/sh

# -e exit on error
# -u error on undefined variables
# -o option
# pipefail exits on command pipe failures
set -euo pipefail

echo "installing dotfiles..."

# nvim
mkdir -p "$HOME/.config/nvim"
ln -s "$(pwd)/config/nvim/init.lua" "$HOME/.config/nvim/init.lua"

# macos
./macos.sh

# alias
ln -s "$(pwd)/.alias" "$HOME/.alias"

# zsh
ln -s "$(pwd)/.zshrc" "$HOME/.zshrc"

echo "finished :)"

