#!/bin/bash

source ../functions.sh

install_app() {
  local app=$1

  if ! brew list | grep -q $app; then
    echo "[homebrew] do you want to install $app (Yes / No)? "
    answer=$(yes_or_no)
    case $answer in
      Yes)
        echo "[homebrew] installing $app ..."
        brew install --cask $app
        ;;
      No)
        echo "[homebrew] $app will not be installed"
        ;;
    esac
  else
    echo "[homebrew] $app already installed"
  fi
}
