#!/bin/bash

# Define color variables
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RED="\e[31m"
RESET="\e[0m"

# Log file
LOGFILE="/var/log/install_script.log"

# Verbose mode flag
VERBOSE=false

# Check for verbose flag
if [[ "$1" == "-v" || "$1" == "--verbose" ]]; then
    VERBOSE=true
fi

# Function to run commands in verbose or silent mode
run_cmd() {
    if [ "$VERBOSE" = true ]; then
        "$@" 2>&1 | tee -a "$LOGFILE"
    else
        "$@" &>/dev/null
    fi
}

# Function to check for required commands
check_command() {
    command -v "$1" >/dev/null 2>&1 || {
        echo -e "${RED}$1 is required but not installed. Aborting.${RESET}" >&2
        exit 1
    }
}

# Check for root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root${RESET}"
    exit 1
fi

# Check if required commands are available
check_command curl
check_command unzip

# Update system
update_system() {
    echo -e "${CYAN}Updating system...${RESET}"
    run_cmd apt update
    run_cmd apt upgrade -y
}

# Add APT backports sources
add_backports() {
    read -p "Do you want to add APT backports sources? (y/n): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}Adding APT backports sources...${RESET}"
        echo "deb https://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware" >>/etc/apt/sources.list
        echo -e "${YELLOW}You may need to install linux-image-amd64 from backports for hardware compatibility.${RESET}"
    else
        echo -e "${GREEN}APT backports sources not added.${RESET}"
    fi
}

# Install Neovim
install_nvim() {
    echo -e "${CYAN}Installing Neovim...${RESET}"
    run_cmd curl -LO https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-linux64.tar.gz
    run_cmd rm -rf /opt/nvim
    run_cmd tar -C /opt -xzf nvim-linux64.tar.gz
}

# Install Kitty terminal
install_kitty() {
    echo -e "${CYAN}Installing Kitty terminal...${RESET}"
    run_cmd curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    run_cmd cp $sudo_user_home/.local/kitty.app/share/applications/kitty.desktop $sudo_user_home/.local/share/applications/
    run_cmd ln -sf $sudo_user_home/.local/kitty.app/bin/kitty $sudo_user_home/.local/kitty.app/bin/kitten /usr/local/bin/
    local icon_path
    icon_path=$sudo_user_home/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png
    run_cmd sed -i "s|Icon=kitty|Icon=$icon_path|g" $sudo_user_home/.local/share/applications/kitty*.desktop
    run_cmd sed -i "s|Exec=kitty|Exec=$sudo_user_home/.local/kitty.app/bin/kitty|g" $sudo_user_home/.local/share/applications/kitty*.desktop
    echo 'kitty.desktop' >$sudo_user_home/.config/xdg-terminals.list
}

# Install Btop++
install_btop() {
    if ! command -v btop &>/dev/null; then
        echo -e "${CYAN}Installing Btop++...${RESET}"
        run_cmd apt install -y btop
        run_cmd sed -i "s|Exec=btop|Exec=kitty --single-instance btop|g" $sudo_user_home/.local/share/applications/btop.desktop
    else
        echo -e "${GREEN}Btop++ is already installed. Skipping.${RESET}"
    fi
}

install_discord() {
    if ! command -v discord &>/dev/null; then
        echo -e "${CYAN}Installing Discord...${RESET}"
        run_cmd curl -L 'https://discord.com/api/download?platform=linux&format=deb' --output discord.deb
        run_cmd dpkg --install discord.deb
    else
        echo -e "${GREEN}Discord is already installed. Skipping.${RESET}"
    fi
}

# Install JetBrainsMono Nerd Font
install_font() {
    echo -e "${CYAN}Installing JetBrainsMono Nerd Font...${RESET}"
    run_cmd curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip -o JetBrainsMono.zip
    run_cmd mkdir -p /usr/share/fonts/JetBrainsMono
    run_cmd unzip JetBrainsMono.zip 'JetBrainsMonoNerdFont-*' -d /usr/share/fonts/JetBrainsMono
    run_cmd fc-cache -f
    run_cmd rm JetBrainsMono.zip
}

# Install TLP
install_tlp() {
    read -p "Do you want to install TLP for power management? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}Installing TLP...${RESET}"
        run_cmd apt install -t bookworm-backports -y tlp tlp-rdw smartmontools
        echo -e "${YELLOW}You can enable battery health tweaks in /etc/tlp.conf${RESET}"
    else
        echo -e "${YELLOW}Skipping TLP installation.${RESET}"
    fi
}

install_keyd() {
    run_cmd git clone https://github.com/rvaiya/keyd
    run_cmd pushd keyd
    run_cmd make && sudo make install
    run_cmd cp $sudo_user_home/.config/keyd/default.conf /etc/keyd/default.conf
    run_cmd systemctl enable keyd && sudo systemctl start keyd
    run_cmd popd
    run_cmd rm -r keyd
}

# Get usr home
sudo_user_home=$(getent passwd "$SUDO_USER" | cut -d: -f6 | grep home | head -n 1)

# Run the installation steps
update_system
add_backports
install_nvim
install_kitty
install_btop
install_discord
install_font
install_tlp
install_keyd

echo -e "${CYAN}Now install fzf binaries from here : https://github.com/junegunn/fzf/releases/tag/latest${RESET}"

echo -e "${GREEN}Installation complete!${RESET}"
