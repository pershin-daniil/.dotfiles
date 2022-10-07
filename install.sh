#!/bin/bash

rm -frd ~/.config/{nvim|kitty|sway}
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/kitty ~/.config/kitty
ln -s ~/.dotfiles/sway ~/.config/sway

