#!/bin/bash

source ../functions.sh

if ! brew list | grep -q google-chrome; then
  echo "[homebrew] do you want to install google-chrome (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[homebrew] installing google-chrome ..."
      brew install --cask google-chrome
      ;;
    No)
      echo "[homebrew] google-chrome will not be installed"
      ;;
  esac
else
  echo "[homebrew] google-chrome already installed"
fi
