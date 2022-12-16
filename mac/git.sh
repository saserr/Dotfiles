#!/bin/bash

source ../functions.sh

if ! brew list | grep -q git; then
  echo "[mac] do you want to install git (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[homebrew] installing git"
      brew install git git-lfs
      ;;
    No)
      echo "[mac] git will not be installed"
      ;;
  esac
else
  echo "[mac] git already installed"
fi
