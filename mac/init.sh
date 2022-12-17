#!/bin/bash

source ../functions.sh

continue=false

if installed brew; then
  echo "[homebrew] already installed"
  continue=true
else
  echo "[homebrew] not installed; do you want to install homebrew (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      continue=true
      ;;
    No)
      echo "[homebrew] will not be installed"
      ;;
  esac
fi

if [ "$continue" = true ]; then
  echo "[homebrew] updating ..."
  brew update
  echo "[homebrew] upgrading"
  brew upgrade

  ./zsh.sh
  ./git.sh

  install_app() {
    local app=$1

    if ! brew list | grep -q $app; then
      echo "[mac] do you want to install $app (Yes / No)? "
      answer=$(yes_or_no)
      case $answer in
        Yes)
          echo "[homebrew] installing $app"
          brew install --cask $app
          ;;
        No)
          echo "[mac] $app will not be installed"
          ;;
      esac
    else
      echo "[mac] $app already installed"
    fi
  }

  install_app 1password
  install_app 1password-cli
  install_app google-chrome
  install_app tailscale

  install_app emacs
  install_app iterm2
  install_app visual-studio-code
  install_app docker

  install_app google-drive
  install_app resilio-sync
  
  install_app telegram
fi
