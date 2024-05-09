#!/usr/bin/env bash

source ./scripts/wrap.sh

main() {
    # Ensure the script runs from the directory where it's located
    cd "$(dirname "$0")"
    
    # Refresh sudo credential cache
    sudo -v
    
    cleanup() {
      echo "Caught SIGINT signal. Cleaning up..."
      # Place your cleanup commands here
      exit 1
    }
    
    # Trap SIGINT (Ctrl+C) and call the cleanup() function
    trap cleanup SIGINT
    
    source ./scripts/sysupdate.sh
    source ./scripts/pkg_install.sh
    # List of software to check and install
    software_list=(
        "waybar-module-pacman-updates-git"
        "bat"
        "neofetch"
        "aconnect:alsa-utils"
        "acpi"
        "bemenu"
        "blueman"
        "bluetoothctl:bluez-utils"
        "bluez"
        "clipman"
        "brightnessctl"
        "dig:bind-tools"
        "dunst"
        "ethtool"
        "feh"
        "foot"
        "fusermount:fuse2"
        "fwupdmgr:fwupd"
        "gcc:base-devel"
        "get-edid:read-edid"
        "hostname:inetutils"
        "hyprpaper"
        "hyprpicker"
        "hwinfo"
        "i3lock"
        "libnotify"
        # "mako"
        "networkmanager"
        "networkmanager-openconnect"
        "nm-applet"
        "nwg-bar"
        "pamixer"
        "papirus-icon-theme"
        "pavucontrol"
        "playerctl"
        "powertop"
        "pipwire"
        "lib32-pipewire"
        "pipewire-docs"
        "pipewire-pulse"
        "pipewire-jack"
        "pipewire-jack-client"
        "pipewire-audio"
        "pipewire-zeroconf"
        "carla"
        "realtime-privileges"
        "python-pillow"
        "rg:ripgrep"
        "rofi-wayland"
        "rofi-bluetooth-git"
        "smartctl:smartmontools"
        "stow"
        "swayfx"
        "swaylock"
        "swayidle"
        "swaybg"
        "swaync"
        "swww"
        "tlp"
        "unzip"
        "upower"
        "waybar"
        "wdisplays"
        "wget"
        "which"
        "wired"
        "wlogout"
        "wlsunset"
        "wl-copy:wl-clipboard"
        "wofi"
        "wmenu"
        "xautolock"
        "xhost:xorg-xhost"
        "xrandr:xorg-xrandr"
        "xss-lock"
        "zip"
        "zoom"
        "fzf"
        "pipewire"
        "polkit-kde-agent"
        "chrony"
        "grim"
        "slurp"
        "hyprlock"
        "xdg-desktop-portal-hyprland"
        "xdg-desktop-portal-gtk"
        "qt6-wayland"
        "obs-studio"
        "shellcheck"
    )
    
    # Iterate over the associative array
    for software in "${software_list[@]}"; do
        check_and_install "$software"
    done
    
    source ./scripts/setup_fonts.sh
    source ./scripts/setup_zsh.sh
    source ./scripts/setup_network.sh
    source ./scripts/setup_tmux.sh
    source ./scripts/setup_udev.sh
    
    echo "[ START ] Starting to stow dotfiles...: $(pwd)"
    
    ## declare an array variable
    declare -a arr=(
        "alacritty"
        "dunst"
        "feh:wallpapers"
        "fontconfig"
        "hyprland:hypr"
        "i3:i3-wm"
        "ignore:applications"
        "ignore:p10k"
        "kitty"
        "nvim"
        "picom"
        "rofi"
        "polybar"
        "ranger"
        "tmux"
        "waybar"
        "zsh"
        "kanshi"
    )
    
    ## now loop through the above array
    for pkg in "${arr[@]}"
    do
       echo " >> Installing package: $pkg"
       check_and_install "$pkg"
    
       # Split input into command and package using IFS and read
       IFS=':' read -r command package <<< "$pkg"
       # If package is empty, use command as package
       [[ -z "$package" ]] && package=$command
     
       # Stow tmux configuration
       if [ -d "$package" ]; then
           stow "$package"
       else
           echo " >> $package not found"
       fi
    
    done
    
    
    source ./scripts/setup_power_save.sh
    source ./scripts/setup_apps.sh
}

wrap main
