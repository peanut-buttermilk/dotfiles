#!/bin/bash

# Refresh sudo credential cache
sudo -v

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

# Install GNU Stow, Neovim, and tmux if they are not installed
check_and_install "stow"
check_and_install "nvim"
check_and_install "tmux"


# Function to stow packages
stow_package() {
    package=$1
    target=$2
    if [[ -n "$target" ]]; then
        echo "Stowing $package to $target..."
        stow --target="$target" -vR "$package"
    else
        echo "Stowing $package..."
        stow -vR "$package"
    fi
}

echo "Starting to stow dotfiles..."

# Ensure the script runs from the directory where it's located
cd "$(dirname "$0")"

# Stow tmux configuration
if [ -d "tmux" ]; then
    stow -v -R -t ~ tmux
else
    echo "tmux directory not found."
fi

# Stow nvim configuration selectively into ~/.config
if [ -d "nvim" ]; then
    # Ensure ~/.config exists
    mkdir -p ~/.config/nvim
    stow -v -R -t ~/.config/nvim nvim
else
    echo "nvim directory not found."
fi

echo "Dotfiles stow completed."

