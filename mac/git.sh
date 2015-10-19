#!/bin/bash

source ../functions.sh

echo "[homebrew] git not installed; do you want to install git (Yes / No)? "
answer=$(yes_or_no)
case $answer in
  Yes)
    echo "[homebrew] installing git ..."
    brew install git git-extras git-flow
    ;;
  No)
    echo "[homebrew] git will not be installed"
    ;;
esac
