#!/bin/bash

source ../functions.sh

if installed zsh; then
  echo "Setting up .zshenv ..."
  safe_link ".zshenv" $PWD/zshenv ~/.zshenv

  echo "Setting up .zshrc ..."
  safe_link ".zshrc" $PWD/zshrc ~/.zshrc

  echo "Save the local specific zsh environment configuration into ~/.zshenv.local.zsh"
  touch ~/.zshenv.local.zsh

  echo "Save the local specific zsh configuration into ~/.zshrc.local.zsh"
  touch ~/.zshrc.local.zsh
else
  echo "zsh not installed; skipping its configuration"
fi
