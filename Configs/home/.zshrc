alias ohmyzsh="mate ~/.oh-my-zsh"
alias god="sudo"
alias c="clear"
alias ktmux="tmux kill-session -t"

# port forwarding thru SSH
alias torified="ssh -D 127.0.0.1:1080 -L 3128:127.0.0.1:3128 -L 8123:127.0.0.1:8123 -L 8118:127.0.0.1:8118 -L 9050:127.0.0.1:9050 <username>@<ip> -p <port>"

plugins=(git bundler osx vi-mode history-substring-search autojump zsh-syntax-highlighting command-not-found docker)

## Determine OS and set more generic
OS="`uname`"
case $OS in
  'Linux')
    OS='Linux'
    alias ls='ls --color=auto'
    ;;
  'FreeBSD')
    OS='FreeBSD'
    alias ls='ls -G'
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

# Linux
if [[ $OS == Linux ]]; then
  echo ""
fi

# Mac
if [[ $OS == Mac ]]; then
  if type archey > /dev/null 2>&1; then
    archey
  fi
fi

# All
export EDITOR="vnc"