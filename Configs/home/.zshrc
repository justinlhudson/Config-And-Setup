export ZSH=~/.oh-my-zsh

ZSH_THEME="robbyrussell"
# auto update no prompting!
DISABLE_AUTO_PROMPT="true"

source $ZSH/oh-my-zsh.sh

plugins=(cake coffee docker gem git github history mercurial node npm python pip screen sublime sudo supervisor tmux tmuxinator virtualenv vi-mode web-search tmuxinator) 

# run profile script not in zsh mode
if [ -f ~/.profile ]; then
  emulate sh -c '. ~/.profile'
fi

if [ -f ~/.zshrc-user ]; then
  source ~/.zshrc-user
fi
