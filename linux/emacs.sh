#!/usr/bin/env bash

source ../functions.sh

if ! apt list -i | grep -q emacs; then
  echo "[linux] do you want to install emacs (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[apt] installing emacs ..."
      sudo apt -y install emacs-nox
      ;;
    No)
      echo "[linux] emacs will not be installed"
      ;;
  esac
else
  echo "[linux] emacs already installed"
fi
