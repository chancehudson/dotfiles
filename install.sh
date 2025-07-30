#!/bin/sh

ln .zshrc ~/.zshrc

# sway config
mkdir -p ~/.config/sway
ln .config/sway/config ~/.config/sway/config

# neovim config
mkdir -p ~/.config/nvim
ln .config/nvim/init.lua ~/.config/nvim/init.lua

# alacritty config
mkdir -p ~/.config/alacritty
ln .config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml

# install fonts
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  mkdir -p ~/.local/share/fonts
  cp -r fonts/* ~/.local/share/fonts
fi
