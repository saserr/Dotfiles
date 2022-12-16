#!/bin/bash

source ../functions.sh

if ! brew list | grep -q emacs; then
  echo "[homebrew] do you want to install emacs (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[homebrew] installing emacs ..."
      brew install --with-cocoa emacs
      ;;
    No)
      echo "[homebrew] emacs will not be installed"
      ;;
  esac
else
  echo "[homebrew] emacs already installed"
fi
