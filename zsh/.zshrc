[[ -o interactive ]] || return # If not running interactively, don't do anything
PROMPT='|%F{blue}%n@%m%f %F{magenta}%?%f %F{green}%~%f %B>_%b '

setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt NO_CLOBBER # Prevent overwriting files with >

HISTSIZE=10000
SAVEHIST=20000
HISTFILE=~/.zsh_history
HISTIGNORE="ls:eza:cd:pwd:exit"

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export TERM="foot"
export EDITOR="nvim"
export BROWSER="helium"
export PAGER="less"
export LESS="-FRX"
export __GL_THREADED_OPTIMIZATIONS=0

autoload -Uz compinit
compinit # Enable completion system

alias l='eza -l --color=always --group-directories-first --icons'
alias la='eza -l --color=always --group-directories-first --icons -a'
alias lf='yazi'
alias wget='wget -c'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias cleanpm='sudo pacman -Rns $(pacman -Qtdq)'
alias fixpm='sudo rm /var/lib/pacman/db.lck'
alias mirrorpm='sudo cachyos-rate-mirrors'

# Plugins
source $HOME/dotfiles/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/dotfiles/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
