#!/bin/bash

CONFIG_DIR="$HOME/.config"

#GTK
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' 
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
#QT
ln -sf "$CONFIG_DIR/hypr/hyprqt6engine-dark.conf" "$CONFIG_DIR/hypr/hyprqt6engine.conf"
#Foot
ln -sf "$CONFIG_DIR/foot/foot-dark.ini" "$CONFIG_DIR/foot/foot.ini"
#Swaync
ln -sf "$CONFIG_DIR/swaync/sway-dark.css" "$CONFIG_DIR/swaync/style.css"
swaync-client -rs
#Btop
ln -sf "$CONFIG_DIR/btop/themes/btop-dark.theme" "$CONFIG_DIR/btop/themes/current.theme"
#Waybar
ln -sf "$CONFIG_DIR/waybar/waybar-dark.css" "$CONFIG_DIR/waybar/style.css"
pkill waybar && waybar &
#Fuzzel
ln -sf "$CONFIG_DIR/fuzzel/fuzzel-dark.ini" "$CONFIG_DIR/fuzzel/fuzzel.ini"
#Wallpaper
hyprctl hyprpaper preload "$HOME/Pictures/Wallpapers/dark-wallpaper.jpg"
hyprctl hyprpaper wallpaper DP-3, "$HOME/Pictures/Wallpapers/dark-wallpaper.jpg"
ln -sf "$CONFIG_DIR/hypr/hyprpaper-dark.conf" "$CONFIG_DIR/hypr/hyprpaper.conf"
#Hyprlock
ln -sf "$CONFIG_DIR/hypr/hyprlock-dark.conf" "$CONFIG_DIR/hypr/hyprlock.conf"
#Icons
gsettings set org.gnome.desktop.interface icon-theme 'Colloid-Dark'

notify-send -h int:transient:1 "Theme manager" "Dark theme applied."

