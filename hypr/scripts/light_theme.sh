#!/bin/bash

CONFIG_DIR="$HOME/.config"

#GTK
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
gsettings set org.gnome.desktop.interface color-scheme 'default'
#QT
ln -sf "$CONFIG_DIR/hypr/hyprqt6engine-light.conf" "$CONFIG_DIR/hypr/hyprqt6engine.conf"
#Foot
ln -sf "$CONFIG_DIR/foot/foot-light.ini" "$CONFIG_DIR/foot/foot.ini"
#Swaync
ln -sf "$CONFIG_DIR/swaync/sway-light.css" "$CONFIG_DIR/swaync/style.css"
swaync-client -rs
#Btop
ln -sf "$CONFIG_DIR/btop/themes/btop-light.theme" "$CONFIG_DIR/btop/themes/current.theme"
#Waybar
ln -sf "$CONFIG_DIR/waybar/waybar-light.css" "$CONFIG_DIR/waybar/style.css"
pkill waybar; uwsm-app -- waybar &
#Fuzzel
ln -sf "$CONFIG_DIR/fuzzel/fuzzel-light.ini" "$CONFIG_DIR/fuzzel/fuzzel.ini"
#Wallpaper
hyprctl hyprpaper preload "$HOME/Pictures/Wallpapers/light-wallpaper.jpg"
hyprctl hyprpaper wallpaper DP-3, "$HOME/Pictures/Wallpapers/light-wallpaper.jpg"
ln -sf "$CONFIG_DIR/hypr/hyprpaper-light.conf" "$CONFIG_DIR/hypr/hyprpaper.conf"
#Hyprlock
ln -sf "$CONFIG_DIR/hypr/hyprlock-light.conf" "$CONFIG_DIR/hypr/hyprlock.conf"
#Icons
gsettings set org.gnome.desktop.interface icon-theme 'Colloid-Light'

notify-send "Light theme applied."
