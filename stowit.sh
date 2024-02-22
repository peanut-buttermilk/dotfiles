#!/bin/bash

# Ensure the script runs from the directory where it's located
cd "$(dirname "$0")"

# Refresh sudo credential cache
sudo -v

# Update system packages based on the operating system
update_system_packages() {
    case "$(uname -s)" in
        Linux*)
            distro=$(grep ^ID= /etc/os-release | cut -d= -f2 | tr -d '"')
            if [ "$distro" = "ubuntu" ]; then
                sudo add-apt-repository universe && sudo apt-get update && sudo apt-get upgrade -y
            elif [ "$distro" = "arch" ]; then
                sudo pacman -Syu --noconfirm
            else
                echo "Unsupported Linux distribution for automatic updates."
            fi
            ;;
        Darwin*)
            brew update && brew upgrade
            ;;
        *)
            echo "Unsupported operating system for automatic updates."
            ;;
    esac
}

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

install_jetbrains_mono_nerd_font() {
    # Define the URL for downloading the fonts
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"

    # Define the local fonts directory
    FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"

    # Create the font directory if it doesn't exist
    mkdir -p "$FONT_DIR"

    # Download the font zip file to the font directory
    echo "Downloading JetBrains Mono Nerd Font..."
    wget -qO "$FONT_DIR/JetBrainsMono.zip" "$FONT_URL"

    # Navigate to the font directory
    cd "$FONT_DIR"

    # Unzip the fonts
    echo "Extracting fonts..."
    unzip -qo JetBrainsMono.zip

    # Remove the zip file
    rm JetBrainsMono.zip

    # Update the font cache
    echo "Updating font cache..."
    fc-cache -fv

    echo "JetBrains Mono Nerd Font installation complete!"
}

# List of software to check and install
software_list=("wget" "zip" "unzip" "stow" "pyright" "html" "tsserver" "brightnessctl" "shutter" "feh" "bluez" "bluez-utils" "pavucontrol" "alsa-utils" "i3lock" "xss-lock" "pulseaudio-alsa" "pulseaudio-bluetooth" "pulseaudio-equalizer" "pulseaudio-jack" "pulseaudio-lirc" "pulseaudio-zeroconf" "xautolock" "ripgrep")

for software in "${software_list[@]}"; do
    check_and_install "$software"
done

install_jetbrains_mono_nerd_font
install_oh_my_zsh
install_p10k

echo "Starting to stow dotfiles..."

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

