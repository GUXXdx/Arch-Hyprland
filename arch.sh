#!/usr/bin/env bash
set -euo pipefail

# Variables
#----------------------------
# Color variables
GREEN="\e[32m"
WHITE="\e[0m"
YELLOW="\e[33m"
BLUE="\e[34m"
#----------------------------


# Welcome message
echo -e "
 ${PINK}\e[1mWELCOME!${PINK} Now we will install and setup Hyprland on an Arch-based system
                       Created by \e[1;4mPhunt_Vieg_\e[0m
                          ${PINK}Edited by \e[1;4mGUXXdx
${WHITE}"

cd ~

# Updating the system
echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[1/9]${GREEN} ==> Updating system packages\n---------------------------------------------------------------------\n${WHITE}"
sudo pacman -Syu --noconfirm

# Setting locale 
echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[2/9]${GREEN} ==> Setting locale \n---------------------------------------------------------------------\n${WHITE}"
sudo sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
sudo locale-gen
sudo localectl set-locale LANG=en_US.UTF-8

# Download some terminal tool
echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[3/9]${GREEN} ==> Download some terminal tool\n---------------------------------------------------------------------\n${WHITE}"
sudo pacman -S --noconfirm --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ~
rm -rf ~/yay

pacman_packages=(
    # System monitoring and fun terminal visuals
    btop cmatrix cowsay fastfetch

    # Essential utilities
    make curl wget unzip dpkg fzf eza bat zoxide neovim tmux ripgrep fd stow man openssh netcat

    # CTF tools
    perl-image-exiftool gdb ascii ltrace strace checksec patchelf upx binwalk

    # Programming languages
    python3 python-pip nodejs npm ruby

    # Shell & customization
    zsh
)
aur_packages=(
    # System monitoring and fun terminal visuals
    cbonsai pipes.sh oh-my-posh 

    # CTF tools
    pwninit
)

# Download pacman packages
echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[4/9]${GREEN} ==> Download pacman packages\n---------------------------------------------------------------------\n${WHITE}"
sudo pacman -S --noconfirm "${pacman_packages[@]}"

# Download yay packages
echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[5/9]${GREEN} ==> Download yay packages\n---------------------------------------------------------------------\n${WHITE}"
yay -S --noconfirm "${aur_packages[@]}"

# Allow pip3 install by removing EXTERNALLY-MANAGED file
echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[6/9]${GREEN} ==> Allow pip3 install by removing EXTERNALLY-MANAGED file\n---------------------------------------------------------------------\n${WHITE}"
sudo rm -rf $(python3 -c "import sys; print(f'/usr/lib/python{sys.version_info.major}.{sys.version_info.minor}/EXTERNALLY-MANAGED')")


# Download file config"
echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[7/9]${GREEN} ==> Download file config\n---------------------------------------------------------------------\n${WHITE}"
git clone --depth=1 https://github.com/GUXXdx/Dotfiles.git ~/dotfiles
git clone --depth=1 https://github.com/tmux-plugins/tpm ~/dotfiles/.tmux/plugins/tpm

# Stow
echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[8/9]${GREEN} ==> Stow\n---------------------------------------------------------------------\n${WHITE}"
cd ~/dotfiles
./.config/guxxdx/backup_config.sh
stow -t ~ .
cd ~

# Change shell
echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[9/9]${GREEN} ==> Change shell\n---------------------------------------------------------------------\n${WHITE}"
ZSH_PATH="$(which zsh)"
grep -qxF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
chsh -s "$ZSH_PATH"


echo -e "\n ${GREEN}
 **************************************************
 *                    \e[1;4mDone\e[0m${GREEN}!!!                     *
 *       Please relogin to apply new config.      *
 **************************************************
 ${WHITE}
"
