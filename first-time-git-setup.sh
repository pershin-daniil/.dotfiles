#!/usr/bin/env bash
set -euo pipefail
umask 077

NAME="Daniil Pershin"
EMAIL="pershin.daniil.e@gmail.com"
KEYFILE="${HOME}/.ssh/id_ed25519"

# Git config (при необходимости — делай локально в репо без --global)
git config --global user.name "$NAME"
git config --global user.email "$EMAIL"
git config --global init.defaultBranch main
git config --global user.useConfigOnly true

# Подготовка ~/.ssh с правильными правами
mkdir -p "${HOME}/.ssh"
chmod 700 "${HOME}/.ssh"

# Генерация ключа (если нет). -o -a 100 усиливает защиту passphrase
if [[ -f "${KEYFILE}" || -f "${KEYFILE}.pub" ]]; then
  echo "[-] SSH ключ уже существует: ${KEYFILE} — пропускаю генерацию."
else
  echo "[+] Генерирую новый SSH ключ Ed25519..."
  ssh-keygen -t ed25519 -o -a 100 -C "$EMAIL" -f "$KEYFILE"
fi

# Права на ключи
chmod 600 "${KEYFILE}"
[[ -f "${KEYFILE}.pub" ]] && chmod 644 "${KEYFILE}.pub"

# Агент и добавление ключа
if ! pgrep -u "$USER" ssh-agent >/dev/null 2>&1; then
  eval "$(ssh-agent -s)"
fi
ssh-add "${KEYFILE}"

# Вывести публичный ключ (его можно добавить на GitHub/GitLab)
echo
echo "[+] Ваш публичный ключ:"
cat "${KEYFILE}.pub"
echo

git config --global gpg.format ssh
git config --global user.signingkey "$KEYFILE.pub"
git config --global commit.gpgsign true

