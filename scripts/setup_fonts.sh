#!/usr/bin/env bash

install_jetbrains_mono_nerd_font() {
    # Check if JetBrains Mono Nerd Font is already installed
    if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
        echo " >> JetBrains Mono Nerd Font is already installed."
        return 0
    fi

    # Define the URL for downloading the fonts
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"

    # Define the local fonts directory
    FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"

    # Create the font directory if it doesn't exist
    mkdir -p "$FONT_DIR"

    # Download the font zip file to the font directory
    echo " >> Downloading JetBrains Mono Nerd Font..."
    wget -qO "$FONT_DIR/JetBrainsMono.zip" "$FONT_URL"

    # Navigate to the font directory
    pushd "$FONT_DIR" || exit

    # Unzip the fonts
    echo " >> Extracting fonts..."
    unzip -qo JetBrainsMono.zip

    # Remove the zip file
    rm JetBrainsMono.zip

    # Update the font cache
    echo " >> Updating font cache..."
    fc-cache -fv

    echo " >> JetBrains Mono Nerd Font installation complete!"
    popd || exit
}

wrap install_jetbrains_mono_nerd_font
