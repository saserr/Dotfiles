#!/bin/bash

source ../functions.sh

if installed zsh; then
  if [ -e ~/.oh-my-zsh ]
  then
    echo "[oh-my-zsh] already installed"
  else
    echo "[oh-my-zsh] not installed; do you want to install oh-my-zsh (Yes / No)? "
    answer=$(yes_or_no)
    case $answer in
      Yes)
        sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        ;;
      No)
        echo "[oh-my-zsh] will not be installed"
        ;;
    esac
  fi

  echo "Setting up .zshenv ..."
  safe_link ".zshenv" $PWD/zshenv ~/.zshenv

  echo "Setting up .zshrc ..."
  safe_link ".zshrc" $PWD/zshrc ~/.zshrc

  echo "Setting up saserr.zsh-theme ..."
  safe_link "saserr.zsh-theme" $PWD/saserr.zsh-theme ~/.oh-my-zsh/themes/saserr.zsh-theme

  echo "Save the local specific zsh environment configuration into ~/.zshenv.local.zsh"
  touch ~/.zshenv.local.zsh

  echo "Save the local specific zsh configuration into ~/.zshrc.local.zsh"
  touch ~/.zshrc.local.zsh
else
  echo "zsh not installed; skipping its configuration"
fi
