#!/bin/bash

source ../functions.sh

continue=false

if installed brew; then
  echo "[homebrew] already installed"
  continue=true
else
  echo "[homebrew] not installed; do you want to install homebrew (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      continue=true
      ;;
    No)
      echo "[homebrew] will not be installed"
      ;;
  esac
fi

if [ "$continue" = true ]; then
  echo "[homebrew] updating ..."
  brew update
  echo "[homebrew] upgrading ..."
  brew upgrade

  ./zsh.sh
  ./emacs.sh
  ./git.sh
fi
