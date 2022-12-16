#!/bin/bash

source ../functions.sh

if installed op; then
  if ! op whoami 2> /dev/null; then
    echo "Do you want to set up 1password-cli (Yes / No)? "
    answer=$(yes_or_no)
    case $answer in
      Yes)
        echo "[1password-cli] logging in"
        op signin
        ;;
      No)
        echo "[1password-cli] will not be set up"
        ;;
    esac
  else
    echo "[1password-cli] already set up"
  fi
else
  echo "[1password-cli] not installed; skipping its setup"
fi
