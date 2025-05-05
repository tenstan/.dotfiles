#!/bin/bash

set -e

dotfilesPath="$(dirname "$(readlink -f "$0")")"
decorativeLine='----------------------------------'

echo "Installing packages."
echo $decorativeLine
packages_to_install=(
    base-devel
    bat
    curl
    docker
    docker-buildx
    docker-compose
    fd
    fish
    fzf
    git
    git-delta
    jq
    less
    man-db
    neovim
    openssh
    polkit
    ripgrep
    unzip
    wget
)
sudo pacman --needed --noconfirm -Syu "${packages_to_install[@]}"
echo ''

echo "Installing yay."
echo $decorativeLine
if command -v yay >/dev/null 2>&1; then
    echo "yay seems to be already installed."
else
    yay_tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$yay_tmp"
    original_dir=$(pwd)
    cd "$yay_tmp"
    makepkg -sif
    cd "$original_dir"
fi
echo ''

echo "Installing AUR packages."
echo $decorativeLine
aur_packages=(
    fnm
    aspnet-runtime-8.0-bin    # Pacman also has .NET 8 available, but that is an outdated version.
    dotnet-sdk-8.0-bin
)
yay -Syu --needed "${aur_packages[@]}"
echo ''

echo 'Starting Docker.'
echo $decorativeLine
sudo systemctl enable docker.service
sudo systemctl start docker.service
echo ''

echo 'Configuring generic symlinks.'
echo $decorativeLine
mkdir -p "$HOME/.config"
ln -sf --no-target-directory "$dotfilesPath/fish" "$HOME/.config/fish"
echo 'Created symlink for fish.'
echo ''

echo 'Configuring neovim.'
echo $decorativeLine
rm -rf "$HOME/.config/nvim"
ln -sf "$dotfilesPath/neovim" "$HOME/.config/nvim"
echo "Neovim config has been placed under HOME/.config/nvim."
echo ''

echo 'Configuring Git.'
echo $decorativeLine
ln -sf "$dotfilesPath/git/.gitconfig" "$HOME/.gitconfig"
echo ".gitconfig has been placed under $HOME."

if [ ! -f "$HOME/.local.gitconfig" ]; then
    read -rp 'Enter git.name: ' gitName
    read -rp 'Enter git.email: ' gitEmail
    localGitConfig="[user]
        name = $gitName
        email = $gitEmail
    "
    echo "$localGitConfig" >"$HOME/.local.gitconfig"
    echo ".local.gitconfig has been placed under $HOME."
fi
echo ''

echo "Setting Fish as the login shell."
echo $decorativeLine
if [[ "$SHELL" != "/usr/bin/fish" ]]; then
    chsh -s "/usr/bin/fish"
fi
echo ''

echo 'Done!'
