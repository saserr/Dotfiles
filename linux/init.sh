#!/bin/bash

if installed apt; then
  echo "[apt] updating ..."
  sudo apt update
  echo "[apt] upgrading"
  sudo apt upgrade

  ./zsh.sh
  ./git.sh
  ./emacs.sh
  ./tailscale.sh
fi
