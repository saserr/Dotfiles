#!/bin/bash

source ../functions.sh

if ! brew list | grep -q zsh; then
  echo "[homebrew] do you want to install zsh (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[homebrew] installing zsh ..."
      brew install zsh
      if [ $SHELL != /usr/local/bin/zsh ]; then
        echo "[homebrew] do you want to set this /usr/local/bin/zsh as login shell (current: $SHELL) (Yes / No)? "
        answer=$(yes_or_no)
        case $answer in
          Yes)
            echo "[homebrew] changing login shell ..."
            if ! grep -q /usr/local/bin/zsh /etc/shells; then
              sudo echo /usr/local/bin/zsh >> /etc/shells
            fi
            chsh -s /usr/local/bin/zsh
            ;;
          No)
            echo "[homebrew] $SHELL will remain the login shell"
            ;;
        esac
      fi
      ;;
    No)
      echo "[homebrew] zsh will not be installed"
      ;;
  esac
else
  echo "[homebrew] zsh already installed"
fi
