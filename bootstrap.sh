#!/usr/bin/env bash
#
# This script sets up a new machine with the basics (Homebrew, rbenv, zsh, etc.)
#

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

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
  if hash brew 2>/dev/null ; then
    brew update
  else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || true
    brew doctor
  fi
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
  rbenv install --list
  echo 'What version of ruby do you want?'
  read -e ruby_version
  rbenv install $ruby_version || true
  rbenv global $ruby_version
}

install_vundle() {
  echo ''
  echo 'Installing vundle...'
  if [ ! -d "~/.vim/bundle/Vundle.vim" ]
  then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
  fi
}

install_tmux() {
  echo ''
  echo 'Installing tmux and TPM'
  if [ "$(uname)" == "Darwin" ]; then
    brew install tmux
  fi
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
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

# Ask whether to install ruby
ruby=true
user "Install rbenv and ruby? [Y/n]?"
read -n 1 action

case "$action" in
  n )
    ruby=false;;
  N )
    ruby=false;;
  * )
    ;;
esac

if [ "$(uname)" == "Darwin" ]; then
  # Mac OS X
  install_homebrew
  if [ "$ruby" == "true" ]; then
    install_rbenv_brew
  fi
  brew install fzf
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  # Linux
  if [ "$ruby" == "true" ]; then
    install_rbenv_git
  fi
fi

if [ "$ruby" == "true" ]; then
  install_ruby
fi
install_vundle
install_tmux
install_oh_my_zsh
setup_zsh

echo ''
echo 'System ready! Now run install.sh'
exit 0
