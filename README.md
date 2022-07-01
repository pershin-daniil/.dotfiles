## Steps to bootstrap

1. Install git

```zsh
sudo apt install git
```


2. Clone repo into new hidden directory.

```zsh
git clone https://github.com/pppershin/.dotfiles.git ~/.dotfiles
```

3. To install all programms you need run script Installation.

```zsh
~/.dotfiles/scripts/installation.sh
```

4. Create symlinks in the Home directory to the real files in the repo.

```zsh
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
```


