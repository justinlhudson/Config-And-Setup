#!/bin/bash

# http://rvm.io/
curl -sSL https://get.rvm.io | bash -s stable

# https://github.com/tmuxinator/tmuxinator
gem install tmuxinator

# https://github.com/gmarik/Vundle.vim
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

# terminal landscape systeminformation
apt-get install landscape-client
