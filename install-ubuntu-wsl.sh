#!/bin/bash

# TODO: Install fzf, install git-delta, fnm

set -e

echo 'Warning: This script will overwrite existing dotfiles and can delete unrelated files when left in directories for to be installed tools.'
confirmation=""

while [[ $confirmation != "y" ]]; do
    if [[ $confirmation == "n" ]]; then
        echo 'Aborting.'
        exit
    fi
    read -rp 'Proceed? [y/n] ' confirmation
done
echo ''

dotfilesPath="$(dirname "$(readlink -f "$0")")"
decorativeLine='----------------------------------'



echo 'Adding required apt repositories.'
echo $decorativeLine

echo 'Adding Fish repository.'
sudo apt-add-repository ppa:fish-shell/release-3 -y

echo ''



echo 'Upgrading packages.'
echo $decorativeLine

sudo apt update
sudo apt -y upgrade

echo ''



echo 'Installing tooling.'
echo $decorativeLine

sudo apt install -y curl fish git build-essential ripgrep fd-find bat

# Fix 'bat' name clash with other Debian package
sudo ln -s --force /usr/bin/batcat /usr/bin/bat

echo ''



echo 'Configuring Git.'
echo $decorativeLine

read -rp 'Enter git.name: ' gitName
read -rp 'Enter git.email: ' gitEmail

localGitConfig="[user]
    name = $gitName
    email = $gitEmail
"

ln -sf "$dotfilesPath/git/.wsl.gitconfig" "$HOME/.gitconfig"
echo ".gitconfig has been placed under $HOME."

echo "$localGitConfig" >"$HOME/.local.gitconfig"
echo ".local.gitconfig has been placed under $HOME."

echo ''



echo 'Configuring generic symlinks.'
echo $decorativeLine

mkdir -p "$HOME/.config"

rm -rf "$HOME/.config/fish"
ln -sf --no-target-directory "$dotfilesPath/fish" "$HOME/.config/fish"
echo 'Created symlink for fish.'

echo ''



echo 'Configuring Neovim.'
echo $decorativeLine

wget -q https://github.com/neovim/neovim/releases/download/v0.10.0/nvim.appimage
chmod +x ./nvim.appimage
sudo mv ./nvim.appimage /usr/local/bin/nvim
echo 'Neovim 0.10.0 has been installed.'

rm -rf "$HOME/.config/nvim"
mkdir -p "$HOME/.config"
ln -sf "$dotfilesPath/neovim" "$HOME/.config/nvim"
echo "Neovim config has been placed under $HOME/.config/nvim."

echo ''



echo "Setting Fish as the login shell."
echo $decorativeLine
if [[ "$SHELL" != "$(command -v fish)" ]]; then
    chsh -s "$(command -v fish)"
fi
echo ''



echo 'Done!'
echo 'Make sure to refresh the shell so everything is loaded correctly.'
