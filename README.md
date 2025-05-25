# dotfiles

You might have seen dotfiles from other users already, here you can find mine.
My goal is to make everything as multiplatform as possible.

## What's inside

- .gitconfig
- Neovim
- Wezterm
- Fish shell
- Windows Powershell profile
- Windows Terminal
- Waybar
- .ideavimrc for Jetbrains IDEs (only for Rider at the moment)
- Various install scripts for quickly pulling all wanted packages and more

## Installation

For the installation, use the installation script for your platform located at the root of the repository.

### Windows

The Windows installation script requires administrator privileges to run.
You should probably run the script with Conhost instead of Windows Terminal, to prevent conflicts while installing the Windows Terminal settings.

```powershell
# Run Conhost as administrator:
# 1. Press Win + R
# 2. Enter 'conhost.exe powershell.exe'
# 3. Press Ctrl + Shift + Enter

git clone https://github.com/tenstan/.dotfiles "$home\.dotfiles"
& "$home\.dotfiles\install-windows.ps1"
```

If the current execution policy is not set (`Undefined`), make sure to run the installation script as `Unrestricted`.

```powershell
powershell -ExecutionPolicy Unrestricted -File "$home\.dotfiles\install-windows.ps1"
```

### Arch Linux

```sh
git clone https://github.com/tenstan/.dotfiles ~/.dotfiles
cd ~/.dotfiles
./install-arch.sh
```

### Arch Linux (WSL)

```sh
git clone https://github.com/tenstan/.dotfiles ~/.dotfiles
cd ~/.dotfiles
./install-arch-wsl.sh
```

## Post Installation

While not strictly necessary, here are some recommended things to perform post installation.

### SSH - IdentitiesOnly with KeePassXC

To ensure that your SSH agent only sends specific SSH keys to remote servers as needed,
I recommend setting `IdentitiesOnly` to `yes` in your `.ssh/config`.
This option ensures the SSH agent will use only the keys explicitly defined in the configuration for each connection.

However, applying `IdentitiesOnly` can be tricky when using KeepassXC for SSH.
Because KeePassXC doesn’t store private keys on the file system, it’s not possible to reference private keys directly in `.ssh/config`.

You can resolve this by specifying the public key in `IdentityFile` instead of the private key.
When you do this, the SSH client will correctly use the private key managed by KeePassXC for the remote server connection.

Example `.ssh/config`:

```
IdentitiesOnly true

Host github.com
    IdentityFile ~/.ssh/github.pub
```

Public keys will need to be manually copied from KeePassXC to the file system (unfortunately).

Solution inspired by: https://github.com/keepassxreboot/keepassxc/issues/2200#issuecomment-413244897
