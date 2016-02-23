export ZSH=/Users/"$(id -un)"/.oh-my-zsh

ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh

plugins=(git bundler osx vi-mode history-substring-search autojump zsh-syntax-highlighting command-not-found docker) 

### Open My Profile Configuration ###
source ~/.my_profile > /dev/null 2>&1
