#!/bin/bash

source ../functions.sh

if ! installed starship; then
  echo "[starship] not installed; do you want to install starship (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      if [ "$(uname -s)" == "Darwin" ]; then
        echo "[homebrew] installing starship ..."
        brew install starship

        echo "[zsh] enabling starship"
        echo "# enable https://starship.rs\neval \"\$(starship init zsh)\"" >> ~/.zshrc.local.zsh
      elif [ "$(uname -s)" == "Linux" ]; then
        echo "[apt] installing curl ..."
        sudo apt -y install curl

        echo "[apt] installing starship ..."
        curl -sS https://starship.rs/install.sh | sh

        echo "[zsh] enabling starship"
        echo "# enable https://starship.rs\neval \"\$(starship init zsh)\"" >> ~/.zshrc.local.zsh
      else
        echo "[ssh] unknown platform \"$(uname -s)\""
      fi
      ;;
    No)
      echo "[starship] will not be installed"
      ;;
  esac
else
  echo "[starship] already installed"
fi
