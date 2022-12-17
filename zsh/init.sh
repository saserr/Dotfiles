#!/usr/bin/env bash

source ../functions.sh

if installed zsh; then
  echo "Do you want to set up zsh (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[zsh] setting up .zshenv ..."
      safe_link ".zshenv" $PWD/zshenv ~/.zshenv

      echo "[zsh] setting up .zshrc ..."
      safe_link ".zshrc" $PWD/zshrc ~/.zshrc

      echo "[zsh] save the local specific zsh environment configuration into ~/.zshenv.local.zsh ..."
      touch ~/.zshenv.local.zsh

      echo "[zsh] save the local specific zsh configuration into ~/.zshrc.local.zsh ..."
      touch ~/.zshrc.local.zsh

      ./starship.sh
      ;;
    No)
      echo "[zsh] will not be set up"
      ;;
  esac
else
  echo "[zsh] not installed; skipping its setup"
fi
