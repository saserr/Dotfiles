#!/bin/bash

source ../functions.sh

if installed git; then
  echo "Do you want to setup git (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[git] setting up .gitconfig ..."
      ./gitconfig.sh
      ;;
    No)
      echo "[git] will not be setup"
      ;;
  esac
else
  echo "[git] not installed; skipping its configuration"
fi
