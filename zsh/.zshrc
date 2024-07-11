neofetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# /usr/bin/neofetch
# ZSH_THEME="powerlevel10k/powerlevel10k"
bindkey -s "^Q" "clear^M"

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
elif [ -n "${commands[fzf]}" ]; then
  eval "$(fzf --zsh)"
fi

if [ -z "${WAYLAND_DISPLAY}" ]; then
  export QT_QPA_PLATFORMTHEME="qt5ct"
  export QT_QPA_PLATFORM=wayland
fi

if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  export XDG_CURRENT_DESKTOP=Hyprland
  export XDG_SESSION_DESKTOP=Hyprland
  exec Hyprland
elif [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 2 ]; then
  export WLR_NO_HARDWARE_CURSORS=1
  export XDG_CURRENT_DESKTOP=sway
  export XDG_SESSION_DESKTOP=sway
  exec sway --unsupported-gpu
fi
source ~/powerlevel10k/powerlevel10k.zsh-theme

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/bcherukuri/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/bcherukuri/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/bcherukuri/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/bcherukuri/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

alias desk="gcloud compute ssh balaji-vm --zone us-west1-a --project lofty-hearth-389420"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

