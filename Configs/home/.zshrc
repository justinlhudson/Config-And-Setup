export ZSH=~/.oh-my-zsh

ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh

plugins=(git brew bower cake bundler coffee gem npm node python redis-cli screen sublime supervisor svn tmux tmuxinator vagrant bundler osx vi-mode history-substring-search autojump zsh-syntax-highlighting command-not-found docker) 

# installing gems local need to add to path
if type ruby >/dev/null && type gem >/dev/null; then
  PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

if [ -f ~/.zshrc-user ]; then
  source ~/.zshrc-user
fi

### Open My Profile Configuration ###
if [ -f ~/.my_profile ]; then
  source ~/.my_profile 2> /dev/null
fi
