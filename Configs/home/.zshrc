export ZSH=~/.oh-my-zsh

ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"

source $ZSH/oh-my-zsh.sh

plugins=(cake coffee docker gem git github history mercurial node npm python pip screen sublime sudo supervisor tmux tmuxinator vi-mode web-search) 

# installing gems local need to add to path
#if type ruby >/dev/null && type gem >/dev/null; then
#  PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
#fi

if [ -f ~/.zshrc-user ]; then
  source ~/.zshrc-user
fi
