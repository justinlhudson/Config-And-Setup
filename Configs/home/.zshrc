export ZSH=~/.oh-my-zsh

ZSH_THEME="robbyrussell"
#DISABLE_AUTO_UPDATE="true"

source $ZSH/oh-my-zsh.sh

plugins=(cake coffee docker gem git github history mercurial node npm python pip screen sublime sudo supervisor tmux tmuxinator virtualenv vi-mode web-search) 

# run profile script not in zsh mode
if [ -f ~/.profile ]; then
  emulate sh -c '. ~/.profile'
fi

if [ -f ~/.zshrc-user ]; then
  source ~/.zshrc-user
fi
