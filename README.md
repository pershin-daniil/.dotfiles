# Setup

- Arch
- Sway

## Programs

### stow configs

- alacritty
- zsh with oh-my-zsh
- zellij
- nvim

Also the repo has configs for:

- qmk config for Iris keyboard Rev6a

## GNU stow

You need **git**, and **stow**

```shell
stow -nvt ~
```

## Commands for store packages

```shell
pacman -Qqe > pkglist
pacman -Qqm > aurlist
flatpak list --app --columns=application > flatpak-apps
```

```shell
yay -S --needed - < aurlist
sudo pacman -S --needed - < pkglist
for i in $(cat flatpak-apps); do flatpak install flathub $i; done
```
