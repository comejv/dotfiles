#!/bin/bash

# Quit on error
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# Install nvim latest from prebuilt binary
curl -LO https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

# Install Kitty from prebuilt binaries
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten /usr/local/bin/
# Update the paths to the kitty and its icon in the kitty desktop file(s)
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
# Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
echo 'kitty.desktop' >~/.config/xdg-terminals.list

# Install Btop++
apt install btop
sed -i "s|Exec=btop|Exec=kitty --single-instance btop|g" ~/.local/share/applications/btop.desktop

# Install JetBrainsMono Nerd Font
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip -o JetBrainsMono.zip
mkdir JBM
unzip -d JBM JetBrainsMono.zip
pushd JBM
mkdir JetBrainsMono
cp JetBrainsMonoNerdFont-* JetBrainsMono
mv JetBrainsMono /usr/share/fonts/
fc-cache -f
popd
rmdir JBM
rm JetBrainsMono.zip
