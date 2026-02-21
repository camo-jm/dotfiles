# If not running interactively, don't do anything
[[ -o interactive ]] || return

# History settings
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
export EDITOR="nvim"
export PAGER="less"
export LESS="-FRX"

# Aliases
alias pls='sudo'
alias l='eza -l --color=always --group-directories-first --icons --sort=size'
alias la='eza -l --color=always --group-directories-first --icons --sort=size -a'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias wget='wget -c'
alias grep='grep --color=auto -E'
alias dotar='tar -acf'
alias untar='tar -zxvf'
alias cleanpac='sudo pacman -Rns $(pacman -Qtdq)'
alias fixpac='sudo rm /var/lib/pacman/db.lck'
alias mirrorpac='sudo cachyos-rate-mirrors'
alias gitpush='git add . && git commit -m "update" && git pull --rebase --autostash && git push'

# Enable completion system
autoload -Uz compinit
compinit

# Prompt
PROMPT='|%F{blue}%n@%m%f %F{magenta}%?%f %F{green}%~%f %B>_%b '
