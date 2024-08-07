# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

setopt HIST_IGNORE_DUPS  # Do not record duplicate entries
setopt HIST_IGNORE_SPACE # Ignore commands that start with a space
setopt HIST_FIND_NO_DUPS # Do not display duplicates in history search
setopt INC_APPEND_HISTORY # Append history entries as they are typed
setopt SHARE_HISTORY # Share history between terminal sessions
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS



alias vim="nvim"
alias vi="nvim"
alias oldvim="vim"
alias vimdiff='nvim -d'
export EDITOR=nvim
bindkey -e

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/balaji_vinci4d_ai/google-cloud-sdk/path.zsh.inc' ]; then . '/home/balaji_vinci4d_ai/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/balaji_vinci4d_ai/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/balaji_vinci4d_ai/google-cloud-sdk/completion.zsh.inc'; fi


