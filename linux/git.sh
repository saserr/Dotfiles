#!/usr/bin/env bash

source ../functions.sh

if ! apt list -i | grep -q git; then
  echo "[linux] do you want to install git (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[apt] installing git ..."
      sudo apt -y install git git-lfs
      ;;
    No)
      echo "[linux] git will not be installed"
      ;;
  esac
else
  echo "[linux] git already installed"
fi
