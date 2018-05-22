#!/usr/bin/env bash
set +e

brews=(
  hub
  htop
  httpie
  iftop
  mackup
  mtr
  tmux
  tree
)

casks=(
  1password
  bartender
  docker
  dropbox
  firefox
  google-chrome
  hammerspoon
  istat-menus
  iterm2
  keybase
  muzzle
  slack
  spotify
  sublime-text
  xquartz
)

fonts=(
  font-inconsolata-for-powerline
)


function install {
  cmd=$1
  shift
  for pkg in $@;
  do
    exec="$cmd $pkg"
    if ${exec} ; then
      echo "Installed $pkg"
    else
      echo "Failed to execute: $exec"
    fi
  done
}


if test ! $(which brew); then
  xcode-select --install
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  brew update
  brew upgrade
fi

brew doctor
brew tap homebrew/dupes

brew info ${brews[@]}
install 'brew install' ${brews[@]}

brew tap caskroom/versions
brew cask info ${casks[@]}
install 'brew cask install' ${casks[@]}

brew tap caskroom/fonts
install 'brew cask install' ${fonts[@]}

brew cleanup
brew cask cleanup
