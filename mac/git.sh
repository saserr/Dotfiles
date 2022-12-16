#!/bin/bash

source ../functions.sh

if ! brew list | grep -q git; then
  echo "[homebrew] do you want to install git (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[homebrew] installing git ..."
      brew install git git-lfs
      ;;
    No)
      echo "[homebrew] git will not be installed"
      ;;
  esac
else
  echo "[homebrew] git already installed"
fi
