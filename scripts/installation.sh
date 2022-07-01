!/bin/bash
./install-kitty.sh
reset
./istall-ohmyzsh.sh
reset
./install-vscode.sh
reset
./install-git.sh
reset
./install-google.sh
reset
./install-nvim.sh

# Copy config file
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/nvim ~/.config/