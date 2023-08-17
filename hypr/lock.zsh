#!/usr/bin/zsh
# Create the background image
file="$HOME/.config/gtklock/background.jpg"
grimblast save output $file
convert $file -blur '0x36' $file
gtklock
