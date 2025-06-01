#!/bin/bash

set -e

dotfilesPath="$(dirname "$(readlink -f "$0")")"
decorativeLine='----------------------------------'

echo 'Configuring pacman.'
echo $decorativeLine
sudo sed -i 's/#Color/Color/' /etc/pacman.conf
sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 5/' /etc/pacman.conf
echo ''

echo "Installing Arch packages."
echo $decorativeLine
packages_to_install=(
    base-devel
    bat
    blueman
    brightnessctl
    curl
    discord
    docker
    docker-buildx
    docker-compose
    fd
    firefox-developer-edition
    fish
    fzf
    git
    git-delta
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
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    openssh
    pavucontrol                  # waybar dependency
    pipewire
    pipewire-pulse
    polkit
    python-gpgme                 # Dropbox dependency when installing from AUR, see https://wiki.archlinux.org/title/Dropbox#Required_packages
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
aur_packages=(
    chatterino2-git
    dropbox
    fnm
    ttf-ms-win11-auto   # Only used for websites that don't know how to configure their fonts properly; provide OS fonts as fallback
    wezterm-git
)
yay -Syu --needed "${aur_packages[@]}"
echo ''

echo 'Starting NetworkManager.'
echo $decorativeLine
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
echo ''

echo 'Starting Docker.'
echo $decorativeLine
sudo systemctl enable docker.service
sudo systemctl start docker.service
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

echo 'Starting UFW.'
echo $decorativeLine
sudo systemctl enable ufw.service
sudo systemctl start ufw.service
echo ''

echo 'Starting ssh-agent.'
echo $decorativeLine
systemctl --user enable ssh-agent.service
systemctl --user start ssh-agent.service
echo ''

echo 'Configuring generic symlinks.'
echo $decorativeLine
mkdir -p "$HOME/.config"
ln -sf --no-target-directory "$dotfilesPath/hyprland" "$HOME/.config/hypr"
echo 'Created symlink for Hyprland.'
ln -sf --no-target-directory "$dotfilesPath/waybar" "$HOME/.config/waybar"
echo 'Created symlink for waybar.'
ln -sf --no-target-directory "$dotfilesPath/wezterm" "$HOME/.config/wezterm"
echo 'Created symlink for wezterm.'
ln -sf --no-target-directory "$dotfilesPath/fish" "$HOME/.config/fish"
echo 'Created symlink for fish.'
ln -sf --no-target-directory "$dotfilesPath/fuzzel" "$HOME/.config/fuzzel"
echo 'Created symlink for fuzzel.'
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

# Necessary workaround for the dropbox client, see https://wiki.archlinux.org/title/Dropbox#Prevent_automatic_updates
echo "Initializing '.dropbox-dist'."
echo $decorativeLine
rm -rf ~/.dropbox-dist
install -dm0 ~/.dropbox-dist
echo ''

echo "Setting Fish as the login shell."
echo $decorativeLine
if [[ "$SHELL" != "$(command -v fish)" ]]; then
    chsh -s "$(command -v fish)"
fi
echo ''

echo 'Done!'
