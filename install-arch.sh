#!/bin/bash

set -e

dotfilesPath="$(dirname "$(readlink -f "$0")")"
decorativeLine='----------------------------------'

echo 'Configuring pacman.'
echo $decorativeLine
sudo sed -i 's/#Color/Color/' /etc/pacman.conf
sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 5/' /etc/pacman.conf
echo ''

echo "Installing preferred packages."
echo $decorativeLine
packages_to_install=(
    base-devel
    bat
    blueman
    brightnessctl
    curl
    discord
    fd
    firefox-developer-edition
    fzf
    git
    grim
    hypridle
    hyprland
    hyprlock
    hyprpaper
    jq
    keepassxc
    less
    man-db
    neovim
    network-manager-applet
    networkmanager
    openssh
    pavucontrol                  # waybar dependency
    pipewire
    pipewire-pulse
    ripgrep
    slurp
    sudo
    swappy
    swaync
    ufw
    unzip
    ttf-firacode-nerd            # wezterm, waybar dependency
    ttf-font-awesome             # waybar dependency
    waybar
    wget
    wl-clipboard
    wireplumber
    xdg-desktop-portal-hyprland
)
sudo pacman --needed --noconfirm -Syu "${packages[@]}"
echo ''

echo 'Starting NetworkManager.'
echo $decorativeLine
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
echo ''

echo 'Starting sshd.'
echo $decorativeLine
sudo systemctl enable sshd
sudo systemctl start sshd
echo ''

echo 'Starting Bluetooth.'
echo $decorativeLine
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
echo ''

echo 'Configuring generic symlinks.'
echo $decorativeLine
mkdir -p "$HOME/.config"
ln -sf --no-target-directory "$dotfilesPath/waybar" "$HOME/.config/waybar"
echo 'Created symlink for waybar.'
ln -sf --no-target-directory "$dotfilesPath/wezterm" "$HOME/.config/wezterm"
echo 'Created symlink for wezterm.'
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

echo "Installing yay."
echo $decorativeLine
if command -v yay >/dev/null 2>&1; then
    echo "yay seems to be already installed."
else
    yay_tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$yay_tmp/yay-bin"
    makepkg -sif "$yay_tmp/yay-bin/PKGBUILD"
fi
echo ''

echo "Installing AUR packages."
echo $decorativeLine
yay -Syu --needed \
    chatterino2-git \
    nvm
echo ''

echo 'Done!'
