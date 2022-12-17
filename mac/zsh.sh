#!/usr/bin/env bash

source ../functions.sh

if ! brew list | grep -q zsh; then
  echo "[mac] do you want to install zsh (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[homebrew] installing zsh ..."
      brew install zsh
      if [ $SHELL != /usr/local/bin/zsh ]; then
        echo "[mac] do you want to set zsh as login shell (current: $SHELL) (Yes / No)? "
        answer=$(yes_or_no)
        case $answer in
          Yes)
            echo "[mac] changing login shell"
            if ! grep -q /usr/local/bin/zsh /etc/shells; then
              sudo echo /usr/local/bin/zsh >> /etc/shells
            fi
            chsh -s /usr/local/bin/zsh
            ;;
          No)
            echo "[mac] $SHELL will remain the login shell"
            ;;
        esac
      fi
      ;;
    No)
      echo "[mac] zsh will not be installed"
      ;;
  esac
else
  echo "[mac] zsh already installed"
fi
