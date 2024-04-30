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
    source ./scripts/setup_zsh.sh
    echo "[ START ] Starting to stow dotfiles...: $(pwd)"
    
    ## declare an array variable
    declare -a arr=(
        "ignore:wallpapers"
        "fontconfig"
        "Hyprland:hypr"
        "ignore:applications"
        "ignore:p10k"
        "kitty"
        "nvim"
        "rofi"
        "waybar"
        "zsh"
        "kanshi"
    )
    
    ## now loop through the above array
    for pkg in "${arr[@]}"
    do
       echo " >> Installing package: $pkg"
       check_and_fail "$pkg"
    
       # Split input into command and package using IFS and read
       IFS=':' read -r command package <<< "$pkg"
       # If package is empty, use command as package
       [[ -z "$package" ]] && package=$command
     
       # Stow tmux configuration
       if [ -d "$package" ]; then
           wrap stow $package
       else
           echo " >> $package not found"
       fi
    
    done
}
wrap main
