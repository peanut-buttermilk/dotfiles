
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


