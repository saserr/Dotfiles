#!/bin/bash

source ../functions.sh

if ! apt list -i | grep -q zsh; then
  echo "[linux] do you want to install zsh (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[apt] installing zsh ..."
      sudo apt -y install zsh
      if [ $SHELL != /bin/zsh ]; then
        echo "[linux] do you want to set zsh as login shell (current: $SHELL) (Yes / No)? "
        answer=$(yes_or_no)
        case $answer in
          Yes)
            echo "[linux] changing login shell ..."
            chsh -s /bin/zsh
            ;;
          No)
            echo "[linux] $SHELL will remain the login shell"
            ;;
        esac
      fi
      ;;
    No)
      echo "[linux] zsh will not be installed"
      ;;
  esac
else
  echo "[linux] zsh already installed"
fi
