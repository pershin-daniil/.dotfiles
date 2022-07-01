firefox https://www.google.com/chrome/thank-you.html?platform=linux&statcb=0&installdataindex=empty&defaultbrowser=0# --headless
sudo apt install ~/Downloads/google-chrome*.deb
rm -frd ~/Downloads/google-*.deb
google-chrome
snap remove firefox
google-chrome --version