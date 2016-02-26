export ZSH=~/.oh-my-zsh

ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh

plugins=(git bundler osx vi-mode history-substring-search autojump zsh-syntax-highlighting command-not-found docker) 

# installing gems local need to add to path
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

### Open My Profile Configuration ###
source ~/.my_profile 2> /dev/null
