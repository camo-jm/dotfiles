PS1='\n|\[\e[94m\]\u\[\e[0m\]@\[\e[94m\]\h\[\e[0m\] \[\e[92m\]\w\n\[\e[0m\]|>_ '

alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'
alias grep='grep --color=auto'
alias l='eza -l --color=always --group-directories-first --icons'
alias la='eza -l --color=always --group-directories-first --icons -a'
alias vi='nvim'
alias wget='wget -c'
alias fetch='fastfetch --file-raw ~/dotfiles/fastfetch/.config/fastfetch/lucario'

HISTSIZE=10000
SAVEHIST=20000
HISTTIMEFORMAT='%F %T '
HISTFILE=~/.zsh_history
HISTIGNORE="ls:eza:cd:pwd:exit"
export HISTCONTROL=ignoreboth:erasedups
HISTCONTROL=erasedups
HISTCONTROL=ignoredups
HISTCONTROL=ignorespace
history -a; history -n via PROMPT_COMMAND
set -o noclobber
shopt -s histappend
PROMPT_COMMAND="history -a; history -n${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

export BROWSER="librewolf"
export EDITOR="nvim"
export LESS="-FRX"
export PAGER="less"
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export TERM="foot"
export __GL_THREADED_OPTIMIZATIONS=0

function ai() {
  local cmd=$1
  shift
  command docker exec -it ollama ollama "$cmd" "$@"
}

function co() {
	local file=$1
	shift
	local -a flags=(\
      -Wall -Wextra -Wpedantic -Werror -Wstrict-prototypes \
      -Wold-style-definition -Wshadow -Wconversion -Wundef -Wwrite-strings \
      -Wformat=2 -std=c89)
	command musl-gcc "$file" "${flags[@]}" "$@"
}

function lf()
{
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
