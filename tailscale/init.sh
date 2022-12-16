#!/bin/bash

source ../functions.sh

if installed tailscale; then
  if ! tailscale status > /dev/null; then
    echo "Do you want to setup tailscale (Yes / No)? "
    answer=$(yes_or_no)
    case $answer in
      Yes)
        echo "[tailscale] logging in"
        tailscale up
        ;;
      No)
        echo "[tailscale] will not be setup"
        ;;
    esac
  else
    echo "[tailscale] already setup"
  fi
else
  echo "[tailscale] not installed; skipping its setup"
fi
