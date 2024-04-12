#!/bin/bash

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

refresh_dotfiles() {
    git pull
    git submodule init
    git submodule sync --recursive
    git submodule update --recursive
    git submodule foreach --recursive git checkout master
}

# Function to check if software is installed and install it if not
# Modified function to handle command:package pairs
check_and_fail() {
    # Split input into command and package using IFS and read
    IFS=':' read -r command package <<< "$1"
    # If package is empty, use command as package
    [[ -z "$package" ]] && package=$command
    
    if [ x$command = "xignore" ] ; then
        echo "ignoring $1"
    elif ! command -v $command &> /dev/null; then
        echo "[ Error ] $command could not be found."
    fi
}

refresh_dotfiles

echo "Starting to stow dotfiles...: $(pwd)"

## declare an array variable
declare -a arr=(
    "ignore:wallpapers"
    "fontconfig"
    "Hyprland:hypr"
    "i3:i3-wm"
    "ignore:applications"
    "kitty"
    "nvim"
    "zsh"
)

## now loop through the above array
for pkg in "${arr[@]}"
do
   echo "Installing package: $pkg"
   check_and_fail "$pkg"

   # Split input into command and package using IFS and read
   IFS=':' read -r command package <<< "$pkg"
   # If package is empty, use command as package
   [[ -z "$package" ]] && package=$command
 
   # Stow tmux configuration
   if [ -d "$package" ]; then
       echo "stowing package: $package"
       stow $package
   else
       echo "$package not found"
   fi

done

echo "Dotfiles stow completed."

