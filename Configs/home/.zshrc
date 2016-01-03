plugins=(git bundler osx vi-mode history-substring-search autojump zsh-syntax-highlighting command-not-found docker)

### Determine OS and set more generic ###
OS="`uname`"
case $OS in
  'Linux')
    OS='Linux'
    ;;
  'FreeBSD')
    OS='FreeBSD'
    ;;
  'WindowsNT')
    OS='Windows'
    ;;
  'Darwin')
    OS='Mac'
    ;;
  'SunOS')
    OS='Solaris'
    ;;
  'AIX') ;;
  *) ;;
esac

## OS dependent commands/operations
echo $OS

### All ###

## History Defaults
# saving 10000 lines to disk and loading the last 5000 lines into memory.
HISTSIZE=5000
HISTFILESIZE=10000
# append history from each session, not the last to log out
shopt -s histappend
# add commands immediatley to history, not wait for log out
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

export EDITOR="vim"

alias ohmyzsh="mate ~/.oh-my-zsh"
alias god="sudo"
alias c="clear"
alias ktmux="tmux kill-session -t"
alias ..='cd ..'
alias ...='cd ../../..'
alias ....='cd ../../../..'
alias ls='ls --color=auto'
alias ll='ls -la'
alias l.='ls -d .* --color=auto'
alias mkdir='mkdir -pv'

# port forwarding thru SSH
alias torified="ssh -D 127.0.0.1:1080 -L 3128:127.0.0.1:3128 -L 8123:127.0.0.1:8123 -L 8118:127.0.0.1:8118 -L 9050:127.0.0.1:9050 <username>@<ip> -p <port>"

### Linux ###
if [[ $OS == Linux ]]; then
  alias apt-get='sudo apt-get'
fi

### Mac ###
if [[ $OS == Mac ]]; then
  if type archey > /dev/null 2>&1; then
    archey
  fi

  alias afplay='afplay -q 1'
  # For Fun
  source "$( dirname "${BASH_SOURCE[0]}" )/.phrase"
fi
