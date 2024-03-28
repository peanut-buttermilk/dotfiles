#!/bin/bash -xv

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

# Update system packages based on the operating system
update_system_packages() {
    case "$(uname -s)" in
        Linux*)
            distro=$(grep ^ID= /etc/os-release | cut -d= -f2 | tr -d '"')
            if [ "$distro" = "ubuntu" ]; then
                sudo add-apt-repository universe && sudo apt-get update && sudo apt-get upgrade -y
            elif [ "$distro" = "arch" ]; then
                sudo pacman -Syu --noconfirm
                yay -Syu --noconfirm
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

refresh_dotfiles() {
    git pull
    git submodule init
    git submodule sync --recursive
    git submodule update --recursive
    git submodule foreach --recursive git checkout master
}

firmware_update() {
    sudo fwupdmgr refresh
    sudo fwupdmgr get-updates
    sudo fwupdmgr update
}

# Update system packages based on the operating system
setup_yay() {
    if ! command -v yay &> /dev/null; then
        sudo pacman -S --noconfirm git base-devel git
        TEMP=$(mktemp)
        git clone sudo git clone https://aur.archlinux.org/yay.git $TEMP
        pushd $TEMP
        makepkg -si
        popd
        rm -rf $TEMP
    else
        echo "yay is already installed."
    fi
}

# Function to install software based on the operating system
install_software() {
    software=$1
    ubuntu_command="sudo apt-get install -y $1"
    arch_command="yay -Qq $1 &> /dev/null || yay -S --noconfirm $1"
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
                setup_yay
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
# Modified function to handle command:package pairs
check_and_install() {
    # Split input into command and package using IFS and read
    IFS=':' read -r command package <<< "$1"
    # If package is empty, use command as package
    [[ -z "$package" ]] && package=$command
    
    if [ x$command = "xignore" ] ; then
        echo "ignoring $1"
    elif ! command -v $command &> /dev/null; then
        echo "$command could not be found. Attempting to install $package..."
        install_software $package
    else
        echo "$command is already installed."
    fi
}

install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null 2>&1
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
    # Check if JetBrains Mono Nerd Font is already installed
    if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
        echo "JetBrains Mono Nerd Font is already installed."
        return 0
    fi

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
    pushd "$FONT_DIR"

    # Unzip the fonts
    echo "Extracting fonts..."
    unzip -qo JetBrainsMono.zip

    # Remove the zip file
    rm JetBrainsMono.zip

    # Update the font cache
    echo "Updating font cache..."
    fc-cache -fv

    echo "JetBrains Mono Nerd Font installation complete!"
    popd
}

install_tmux() {
   if [ -d "$HOME/.tmux/plugins/tpm" ]; then
       echo "tmux plugin manager already installed"
       return 0
   fi

   echo "cloning up tmux plugin manager tpm"

   mkdir -p ~/.tmux/plugins/
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

}

setup_tmux_plugin_manager() {
    install_tmux

    # Load TMUX environment (simulate as if within TMUX for TPM scripts)
    export TMUX_TMPDIR=/tmp
    export TMUX_PANE=%1
    export TMUX=1
    export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins/"

    # Install plugins using TPM
    bash "$TMUX_PLUGIN_MANAGER_PATH/tpm/scripts/install_plugins.sh"
    bash "$TMUX_PLUGIN_MANAGER_PATH/tpm/scripts/update_plugin.sh" all
    bash "$TMUX_PLUGIN_MANAGER_PATH/tpm/scripts/clean_plugins.sh"
}

refresh_applications() {
    update-desktop-database -v ~/.local/share/applications
}

install_udev_rules() {
    echo "[Start] Installing udev rules"
    sudo cp -rv ~/dotfiles/udev/rules.d/* /etc/udev/rules.d/
    sudo groupadd udevscript
    sudo usermod -aG udevscript bcherukuri
    sudo usermod -aG udevscript root
    echo "[Done] Installing udev rules"
}

refresh_displays() {
    ./udev/scripts/i3/reload.sh
}

setup_network() {
    sudo systemctl enable NetworkManager.service
    sudo systemctl disable iwd.service
    sudo systemctl stop iwd.service
    sudo systemctl start NetworkManager.service
}

enable_power_save() {
    sudo systemctl stop tlp.service
    sudo cp ./tlp/etc/tlp.conf /etc/tlp.conf
    sudo systemctl enable tlp.service
    sudo systemctl start tlp.service

    sudo powertop --auto-tune
}

update_system_packages
refresh_dotfiles

# List of software to check and install
software_list=(
    "aconnect:alsa-utils"
    "acpi"
    "blueman"
    "bluetoothctl:bluez-utils"
    "bluez"
    "brightnessctl"
    "dig:bind-tools"
    "dunst"
    "ethtool"
    "feh"
    "fusermount:fuse2"
    "fwupdmgr:fwupd"
    "gcc:base-devel"
    "get-edid:read-edid"
    "hostname:inetutils"
    "hwinfo"
    "i3lock"
    "networkmanager"
    "nm-applet"
    "pavucontrol"
    "powertop"
    "pulseaudio-alsa"
    "pulseaudio-bluetooth"
    "pulseaudio-equalizer"
    "pulseaudio-jack"
    "pulseaudio-lirc"
    "pulseaudio-zeroconf"
    "rg:ripgrep"
    "rofi"
    "rofi-bluetooth-git"
    "sddm"
    "shutter"
    "smartctl:smartmontools"
    "stow"
    "tlp"
    "unzip"
    "upower"
    "wget"
    "which"
    "xautolock"
    "xhost:xorg-xhost"
    "xrandr:xorg-xrandr"
    "xss-lock"
    "zip"
    "zoom"
)

# Iterate over the associative array
for software in "${software_list[@]}"; do
    echo "[Begin] $software"
    check_and_install "$software"
    echo "[End] $software"
done

firmware_update
install_jetbrains_mono_nerd_font
install_oh_my_zsh
install_p10k
setup_network

echo "Starting to stow dotfiles...: $(pwd)"

## declare an array variable
declare -a arr=(
    "alacritty"
    "fontconfig"
    "i3:i3-wm"
    "ignore:applications"
    "ignore:p10k"
    "nvim"
    "picom"
    "polybar"
    "tmux"
    "zsh"
)

## now loop through the above array
for pkg in "${arr[@]}"
do
   echo "Installing package: $pkg"
   check_and_install "$pkg"

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


setup_tmux_plugin_manager
refresh_applications
install_udev_rules
refresh_displays
enable_power_save

echo "End"

