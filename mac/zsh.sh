#!/bin/bash

source ../functions.sh

echo "[homebrew] do you want to install zsh (Yes / No)? "
answer=$(yes_or_no)
case $answer in
  Yes)
    echo "[homebrew] installing zsh ..."
    brew install zsh
    ;;
  No)
    echo "[homebrew] zsh will not be installed"
    ;;
esac
