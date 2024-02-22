#!/bin/bash

# Refresh sudo credential cache
sudo -v
sudo pacman -Syu

git pull
git submodule init
git submodule sync --recursive
git submodule update --recursive

# Function to install software based on the operating system
install_software() {
    software=$1
    ubuntu_command="sudo apt-get install -y $1"
    arch_command="sudo pacman -S --noconfirm $1"
    macos_command="brew install $1"

    # Detect the operating system
    os_name="$(uname -s)"
    case "${os_name}" in
        Linux*)     
            distro=$(grep ^ID= /etc/os-release | cut -d= -f2 | tr -d '"')
            if [ "$distro" = "ubuntu" ]; then
                eval $ubuntu_command
            elif [ "$distro" = "arch" ]; then
                eval $arch_command
            else
                echo "Unsupported Linux distribution for automatic installation."
            fi
            ;;
        Darwin*)    
            eval $macos_command
            ;;
        *)          
            echo "Unsupported operating system."
            ;;
    esac
}

# Function to check if software is installed and install it if not
check_and_install() {
    software=$1
    if ! command -v $software &> /dev/null; then
        echo "$software could not be found. Attempting to install..."
        install_software $software
    else
        echo "$software is already installed."
    fi
}

install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "Oh My Zsh is already installed."
    fi
}

# Function to install Powerlevel10k
run_install_powerlevel10k() {
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >>~/.zshrc
}

install_p10k() {

    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        run_install_powerlevel10k
    else
        echo "Powerlevel10k theme is already installed."
    fi
}

# Install GNU Stow, Neovim, and tmux if they are not installed
check_and_install "stow"
check_and_install "pyright"
check_and_install "html"
check_and_install "tsserver"
check_and_install "brightnessctl"
check_and_install "shutter"
check_and_install "feh"
check_and_install "bluez"
check_and_install "bluez-utils"
check_and_install "pavucontrol"
check_and_install "alsa-utils"
check_and_install "i3lock"
check_and_install "xss-lock"
check_and_install "pulseaudio-alsa" # for PulseAudio to manage ALSA as well, see #ALSA
check_and_install "pulseaudio-bluetooth" # for bluetooth support (Bluez), see bluetooth headset page
check_and_install "pulseaudio-equalizer" # for equalizer sink (qpaeq)
check_and_install "pulseaudio-jack" # for JACK sink, source and jackdbus detection
check_and_install "pulseaudio-lirc" # for infrared volume control with LIRC
check_and_install "pulseaudio-zeroconf" # for Zeroconf (Avahi/DNS-SD) support
check_and_install "xautolock"

install_oh_my_zsh
install_p10k

echo "Starting to stow dotfiles..."

# Ensure the script runs from the directory where it's located
cd "$(dirname "$0")"
## declare an array variable
declare -a arr=("nvim" "tmux" "zsh" "picom" "polybar" "alacritty" "fontconfig" "i3-wm" "p10k")

## now loop through the above array
for pkg in "${arr[@]}"
do
   echo "stowing: $pkg"
   check_and_install "$pkg"


   # Stow tmux configuration
   if [ -d "$pkg" ]; then
       stow $pkg
   else
       echo "$pkg not found"
   fi

done

echo "Dotfiles stow completed."

