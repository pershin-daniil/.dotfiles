#!/bin/bash
git config --global user.name "Daniil Pershin"
git config --global user.email pershin.daniil.e@gmail.com
git config --global init.defaultBranch main
ssh-keygen -t ed25519 -C "pershin.daniil.e@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
