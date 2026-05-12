fetch:
	pacman -Qqe > pkglist
	pacman -Qqm > aurlist
	flatpak list --app --columns=application > flatpak-apps
