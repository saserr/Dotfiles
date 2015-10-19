#!/bin/bash

source ../functions.sh

echo "[homebrew] do you want to install emacs (Yes / No)? "
answer=$(yes_or_no)
case $answer in
  Yes)
    echo "[homebrew] installing emacs ..."
    brew install emacs
    ;;
  No)
    echo "[homebrew] emacs will not be installed"
    ;;
esac
