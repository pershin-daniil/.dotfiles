sudo apt update && sudo apt upgrade
sudo apt install git
git config --global user.name "Daniil Pershin"
git config --global user.email pershin.daniil.e@gmail.com
git config --global core.editor code
ssh-keygen -t ed25519 -C "pershin.daniil.e@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
echo "copy key and add it in setting in your account"
git --version
