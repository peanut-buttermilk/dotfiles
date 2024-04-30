
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo " >> Installing Oh My Zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null 2>&1
    else
        echo " >> Oh My Zsh is already installed."
    fi
}

# Function to install Powerlevel10k
run_install_powerlevel10k() {
    echo " >> Installing Powerlevel10k theme..."

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k
    echo ' >> source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
}

install_p10k() {

    if [ ! -d "$HOME/powerlevel10k" ]; then
        run_install_powerlevel10k
    else
        echo " >> Powerlevel10k theme is already installed."
    fi
}

wrap install_oh_my_zsh
wrap install_p10k
