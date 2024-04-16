#!/bin/bash
swayidle -w timeout 300 'swaylock -f -c 000000i ~/.config/wallpapers/0009.jpg' \
            timeout 600 'hyprctl dispatch dpms off' \
            resume 'hyprctl dispatch dpms on' \
            timeout 900 'systemctl suspend' \
            before-sleep 'swaylock -f -c 000000 -i ~/.config/wallpapers/0009.jpg' &
