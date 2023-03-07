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
sudo pacman -Syu base-devel sudo zsh neovim git ripgrep fd fzf tmux make cmake rsync npm  # TODO: Remove some of these in favor of putting them in ricing stuff

# Install yay 
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd .. && rm -rf yay

yay -Syu hyprland eww

# Change shell to zsh
chsh -s /usr/bin/zsh

mkdir git && cd git

mkdir .config
cd .config

sudo pacman -S bat zathura firefox texlive-most 


echo "Linking configs"
ln -s ~/git/dots/{bat,doom,zathura}

echo "Pick a terminal emulator"
echo "(1) foot"
echo "(2) alacritty"
echo "(3) kitty"

while true; do
    read -p '\b Selection: ' opt
    case $opt in
        1*)
            sudo pacman -S foot
            ln -s ~/git/dots/foot 
            break 
            ;;
        2*)
            sudo pacman -S alacritty 
            ln -s ~/git/dots/alacritty 
            break 
            ;;
        3*)
            sudo pacman -S kitty 
            ln -s ~/git/dots/kitty
            break 
            ;;
        *)
            printf "\b Please enter a valid option"
    esac
done

# List of package
# eww
# rofi
# rust
#

