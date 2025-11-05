#!/usr/bin/env bash
set -euo pipefail

# Variables
#----------------------------

# time variable
start=$(date +%s)

# Color variables
PINK="\e[35m"
WHITE="\e[0m"
YELLOW="\e[33m"
GREEN="\e[32m"
BLUE="\e[34m"

clear

# Welcome message
echo -e "
 ${PINK}\e[1mWELCOME!${PINK} Now we will install and setup Hyprland on an Arch-based system
                       Created by \e[1;4mPhunt_Vieg_\e[0m
                          ${PINK}Edited by \e[1;4mGUXXdx$
{WHITE}"


# Warning message
echo -e "${PINK}
 *********************************************************************
 *                         ⚠️  \e[1;4mWARNING\e[0m${PINK}:                              *
 *               This script will modify your system!                *
 *         It will install Hyprland and several dependencies.        *
 *      Make sure you know what you are doing before continuing.     *
 *********************************************************************
\n
"

# Asking if the user want to proceed
echo -e "${YELLOW} Do you still want to continue with Hyprland installation using this script? [y/N]: \n"
read -r confirm
case "$confirm" in
    [yY][eE][sS]|[yY])
        echo -e "\n${GREEN}[OK]${PINK} ==> Continuing with installation..."
        ;;
    *)
        echo -e "${BLUE}[NOTE]${PINK} ==> You 🫵 chose ${YELLOW}NOT${PINK} to proceed.. Exiting..."
        echo
        exit 1
        ;;
esac


# Start of the install procedure
cd ~

# Full system update
echo -e "${PINK}\n---------------------------------------------------------------------\n${YELLOW}[1/12]${PINK} ==> Updating system packages\n---------------------------------------------------------------------\n${WHITE}"
sudo pacman -Syu --noconfirm

# Lunch auto-setup script and dl all the dotfiles
echo -e "${PINK}\n---------------------------------------------------------------------\n${YELLOW}[2/12]${PINK} ==> Setup terminal\n---------------------------------------------------------------------\n${WHITE}"
sleep 0.4
chmod +x ~/Arch-Hyprland/arch.sh
bash ~/Arch-Hyprland/arch.sh

# Making all the scripts executable (not sure we need this one to be a bullet point)
echo -e "${PINK}\n---------------------------------------------------------------------\n${YELLOW}[3/12]${PINK} ==> Make executable\n---------------------------------------------------------------------\n${WHITE}"
sudo chmod +x ~/dotfiles/.config/guxxdx/*

# download & mv the wallpapers in the right director
echo -e "${PINK}\n---------------------------------------------------------------------\n${YELLOW}[4/12]${PINK} ==> Download wallpaper\n---------------------------------------------------------------------\n${WHITE}"
mkdir -p ~/Pictures/Wallpapers
cp ~/Arch-Hyprland/Wallpapers/* ~/Pictures/Wallpapers
rm -rf ~/Arch-Hyprland/Wallpapers/

# Install the required packages
echo -e "${PINK}\n---------------------------------------------------------------------\n${YELLOW}[5/12]${PINK} ==> Install package\n---------------------------------------------------------------------\n${WHITE}"
sleep 0.4
~/dotfiles/.config/guxxdx/install_archpkg.sh

# enable bluetooth & networkmanager
echo -e "${PINK}\n---------------------------------------------------------------------\n${YELLOW}[6/11]${PINK} ==> Enable bluetooth & networkmanager\n---------------------------------------------------------------------\n${WHITE}"
sleep 0.4
sudo systemctl enable --now bluetooth
sudo systemctl enable --now NetworkManager

# Set Ghostty as default terminal emulator for Nemo
echo -e "${PINK}\n---------------------------------------------------------------------\n${YELLOW}[8/12]${PINK} ==> Set Ghostty as the default terminal emulator for Nemo\n---------------------------------------------------------------------\n${WHITE}"
gsettings set org.cinnamon.desktop.default-applications.terminal exec ghostty

# Apply fonts
echo -e "${PINK}\n---------------------------------------------------------------------\n${YELLOW}[9/12]${PINK} ==> Apply fonts\n---------------------------------------------------------------------\n${WHITE}"
fc-cache -fv

# Set cursor
echo -e "${PINK}\n---------------------------------------------------------------------\n${YELLOW}[10/12]${PINK} ==> Set cursor\n---------------------------------------------------------------------\n${WHITE}"
~/dotfiles/.config/guxxdx/setcursor.sh

# Stow
echo -e "${PINK}\n---------------------------------------------------------------------\n${YELLOW}[11/12]${PINK} ==> Stow dotfiles\n---------------------------------------------------------------------\n${WHITE}"
cd ~/dotfiles
stow -t ~ .
cd ~

# Check display manager
echo -e "${PINK}\n---------------------------------------------------------------------\n${YELLOW}[12/12]${PINK} ==> Check display manager\n---------------------------------------------------------------------\n${WHITE}"
sleep 0.4
if [[ ! -e /etc/systemd/system/display-manager.service ]]; then
    sudo systemctl enable sddm
    echo -e "[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee -a /etc/sddm.conf
    sudo sed -i 's|astronaut.conf|purple_leaves.conf|' /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop
    echo -e "\n${PINK}SDDM has been enabled."
fi

# Wait a little just for the last message
sleep 0.7
clear

# Calculate how long the script took
end=$(date +%s)
duration=$((end - start))

hours=$((duration / 3600))
minutes=$(((duration % 3600) / 60))
seconds=$((duration % 60))

printf -v minutes "%02d" "$minutes"
printf -v seconds "%02d" "$seconds"

clear
                
echo -e "\n
 *********************************************************************
 *                    Hyprland setup is complete!                    *
 *                                                                   *
 *             Duration : $hours hours, $minutes minutes, $seconds seconds            *
 *                                                                   *
 *   It is recommended to \e[1;4mREBOOT\e[0m your system to apply all changes.   *
 *                                                                   *
 *                 \e[4mHave a great time with Hyprland!!${WHITE}                 *
 *********************************************************************
 \n
"
