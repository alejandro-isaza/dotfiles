# dotfiles

This is my collection of dot files. Feel free to clone and modify as you please. My toolbox includes:

* git
* ruby with rbenv
  * Use version 2.4.1 of ruby
* zsh with oh-my-zsh
* vim with vundle
* MacOS X defaults
* psql


## Installing

On a new system run `bootstrap.sh`. It will install rbenv, ruby, vundle and set up zsh as the shell. You only need to run this once if you don't have these things installed already. Then run `install.sh` which will install or update all the dotfiles. Run `install.sh` also if you want to update the dotfiles after a pull.


## Using

Keep local zsh commands in `~/.zshrc.local`, `.zshrc` includes this file if it exists.
