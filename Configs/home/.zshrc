export ZSH=~/.oh-my-zsh

ZSH_THEME="robbyrussell"
# auto update no prompting!
DISABLE_AUTO_PROMPT="true"

source $ZSH/oh-my-zsh.sh

plugins=(git zsh-autocomplete  zsh-syntax-highlighting zsh-autosuggestions history screen sudo tmux tmuxinator tmuxinator) 

# run profile script not in zsh mode
if [ -f ~/.profile ]; then
  emulate sh -c '. ~/.profile'
fi

if [ -f ~/.zshrc-user ]; then
  source ~/.zshrc-user
fi
