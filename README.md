# Setup

- Ubuntu LTS (every lts update)

## Programs

### stow configs

- kitty 
- zsh with oh-my-zsh
- nvim

### without configs

- chrome
- blender ?
- goland
- waka-time

Also the repo has configs for:

- qmk config for Iris keyboard Rev6a

## GNU stow

You need **git**, and **stow**

```
stow -nvt ~
```

## kitty install

### Ubuntu

```bash
sudo apt install kitty
sudo update-alternatives --config x-terminal-emulator
```
pacman -Qqe > pkglist
pacman -Qqm > aurlist
yay -S --needed - < aurlist
sudo pacman -S --needed - < pkglist
