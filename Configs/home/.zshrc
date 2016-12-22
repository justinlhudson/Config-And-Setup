export ZSH=~/.oh-my-zsh

ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"

source $ZSH/oh-my-zsh.sh

plugins=(git brew bower cake bundler coffee gem npm node python redis-cli screen sublime supervisor svn tmux tmuxinator vagrant bundler osx vi-mode history-substring-search autojump zsh-syntax-highlighting command-not-found docker) 

# installing gems local need to add to path
if type ruby >/dev/null && type gem >/dev/null; then
  PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

if [ -f ~/.zshrc-user ]; then
  source ~/.zshrc-user
fi
