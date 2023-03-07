#!/bin/bash

# Assumes this is being run by a user with sudoers permission

spin () {
    pid=$!
    spin='-\|/'

    i=0
    while kill -0 $pid 2>/dev/null
    do
      i=$(( (i+1) %4 ))
      printf "\b${spin:$i:1}"
      sleep .5
    done
}

# Update mirrors
sudo pacman -Syu reflector
echo -n "Updating mirrors...  "
sudo reflector --download-timeout 60 --country 'Canada,United States' --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist 2>/dev/null &
spin
sudo systemctl enable reflector.service
printf "\bdone"

# Check if we need to install special asahi drivers
echo "Installing important drivers..."
while true; do
    read -p 'Running on asahi-linux? (y/N)' yesno
    case $yesno in 
        [Yy]*)
            sudo pacman -Syu linux-asahi-edge mesa-asahi-edge
            sudo update-grub
            break
            ;;
        *)
            break;;
    esac
done

# Install base utils
sudo pacman -Sy base-devel sudo zsh neovim git ripgrep fd alacritty make cmake rsync  # TODO: Remove some of these in favor of putting them in ricing stuff

# Install yay 
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd .. && rm -rf yay

yay -Syu hyprland brave

# Change shell to zsh
chsh -s /usr/bin/zsh
# List of package
# tex
# eww
# rofi
# hyprland
# qutebrowser
# rust
#

