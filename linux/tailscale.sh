#!/bin/bash

source ../functions.sh

if ! apt list -i | grep -q tailscale; then
  echo "[linux] do you want to install tailscale (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[apt] installing curl ..."
      sudo apt -y install curl

      echo "[apt] adding the key for the tailscale apt repository ..."
      curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null

      echo "[apt] adding the tailscale apt repository ..."
      curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

      echo "[apt] installing tailscale"
      sudo apt update && sudo apt -y install tailscale
      ;;
    No)
      echo "[linux] tailscale will not be installed"
      ;;
  esac
else
  echo "[linux] tailscale already installed"
fi
