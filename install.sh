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

# wezterm
ln -sfn "$PWD/.wezterm.lua" "$HOME/.wezterm.lua"

echo "finished :)"
