#!/bin/bash

source ../functions.sh

if installed git; then
  echo "Do you want to set up git (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[git] setting up .gitconfig ..."
      ./gitconfig.sh

      echo "[mac] setting up .gitignore"
      if [ "$(uname -s)" == "Darwin" ]; then
        curl https://www.toptal.com/developers/gitignore/api/macos >> ~/.gitignore
      elif [ "$(uname -s)" == "Linux" ]; then
        curl https://www.toptal.com/developers/gitignore/api/linux >> ~/.gitignore
      fi
      ;;
    No)
      echo "[git] will not be set up"
      ;;
  esac
else
  echo "[git] not installed; skipping its setup"
fi
