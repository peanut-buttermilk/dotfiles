
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
        echo " >> yay is already installed."
    fi
}

# Update system packages based on the operating system
update_system_packages() {
    case "$(uname -s)" in
        Linux*)
            distro=$(grep ^ID= /etc/os-release | cut -d= -f2 | tr -d '"')
            if [ "$distro" = "ubuntu" ]; then
                sudo add-apt-repository universe && sudo apt-get update && sudo apt-get upgrade -y
            elif [ "$distro" = "arch" ]; then
                setup_yay
                sudo pacman -Syu --noconfirm
                yay -Syu --noconfirm
            else
                echo " >> Unsupported Linux distribution for automatic updates."
            fi
            ;;
        Darwin*)
            brew update && brew upgrade
            ;;
        *)
            echo " >> Unsupported operating system for automatic updates."
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

wrap update_system_packages
wrap firmware_update
wrap refresh_dotfiles

