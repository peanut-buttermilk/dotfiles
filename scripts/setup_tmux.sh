
install_tmux() {
   if [ -d "$HOME/.tmux/plugins/tpm" ]; then
       echo " >> tmux plugin manager already installed"
       return 0
   fi

   echo " >> cloning up tmux plugin manager tpm"

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

wrap setup_tmux_plugin_manager

