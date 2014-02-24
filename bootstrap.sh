#!/usr/bin/env bash
#
# This script sets up a new machine with the basics (Homebrew, rbenv, zsh, etc.)
#

check_requirements() {
  if [ "$(uname)" == "Darwin" ] && ! hash ruby 2>/dev/null; then
    echo 'Please intall ruby'
    exit 1
  fi
  if ! hash git 2>/dev/null; then
    echo 'Please intall git'
    exit 1
  fi
  if ! hash zsh 2>/dev/null; then
    echo 'Please intall zsh'
    exit 1
  fi
}

install_homebrew() {
  echo ''
  echo 'Installing Homebrew...'
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)" || true
  brew doctor
  brew update
}

install_rbenv_brew() {
  echo ''
  echo 'Installing rbenv...'
  brew install rbenv ruby-build
}

install_rbenv_git() {
  echo ''
  echo 'Installing rbenv...'
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  export PATH=$HOME/.rbenv/bin:$PATH
}

install_ruby() {
  echo ''
  echo 'Installing ruby...'
  rbenv install 2.0.0-p353 || true
  rbenv global 2.0.0-p353
}

install_vundle() {
  echo ''
  echo 'Installing vundle...'
  if [ ! -d "~/.vim/bundle/vundle" ]
  then
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    vim +BundleInstall +qall
  fi
}

install_oh_my_zsh() {
  echo ''
  echo 'Installing oh my zsh...'
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
}

setup_zsh() {
  if [ "$SHELL" != "/bin/zsh" ]
  then
    echo ''
    echo 'Changing default shell to zsh...'
    chsh -s /bin/zsh
  fi
}

check_requirements

if [ "$(uname)" == "Darwin" ]; then
  # Mac OS X
  install_homebrew
  install_rbenv_brew
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  # Linux
  install_rbenv_git
fi

install_ruby
install_vundle
install_oh_my_zsh
setup_zsh

echo ''
echo 'System ready! Now run install.sh'
exit 0
