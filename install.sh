#!/usr/bin/env bash
set -euo pipefail

clear

echo "==> WELCOME! Now we will install and setup Hyprland on an Arch-based system"
echo "==> Create by Phunt_Vieg_, "
echo "==> Edited by GUXXdx"

cd ~

echo "==> Updating system packages"
sudo pacman -Syu --noconfirm

echo "==> Setup terminal"
chmod +x ~/Arch-Hyprland/arch.sh
bash ~/Arch-Hyprland/arch.sh

echo "==> Make executable"
sudo chmod +x ~/dotfiles/.config/guxxdx/*

echo "==> Download wallpaper"
mkdir -p ~/Pictures/Wallpapers
mv ~/Arch-Hyprland/Wallpapers/* ~/Pictures/Wallpapers
rm -rf ~/Arch-Hyprland/Wallpapers/

echo "==> Install package"
~/dotfiles/.config/guxxdx/install_archpkg.sh

echo "==> Enable bluetooth"
sudo systemctl enable --now bluetooth

echo "==> Enable networkmanager"
sudo systemctl enable --now NetworkManager

echo "==> Set Ghostty as the default terminal emulator for Nemo"
gsettings set org.cinnamon.desktop.default-applications.terminal exec ghostty

echo "==> Apply fonts"
fc-cache -fv

echo "==> Set cursor"
~/dotfiles/.config/guxxdx/setcursor.sh

echo "==> Stow dotfiles"
cd ~/dotfiles
stow -t ~ .
cd ~

echo "==> Check display manager"
if [[ ! -e /etc/systemd/system/display-manager.service ]]; then
    sudo systemctl enable sddm
    echo -e "[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee -a /etc/sddm.conf
    sudo sed -i 's|astronaut.conf|purple_leaves.conf|' /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop
    echo "SDDM has been enabled."
fi


clear
echo
echo "*********************************************************************"
echo "*                    Hyprland setup is complete!                    *"
echo "*                                                                   *"
echo "*   It is recommended to REBOOT your system to apply all changes.   *"
echo "*                                                                   *"
echo "*                 Have a great time with Hyprland!!                 *"
echo "*********************************************************************"
echo
echo
