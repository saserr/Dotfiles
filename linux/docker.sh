#!/bin/bash

source ../functions.sh

if ! apt list -i | grep -q tailscale; then
  echo "[linux] do you want to install docker (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[apt] uninstalling old versions of docker ..."
      sudo apt -y remove docker docker-engine docker.io containerd runc

      echo "[apt] installing ca-certificates, curl, gnupg and lsb-release ..."
      sudo apt -y install ca-certificates curl gnupg lsb-release

      echo "[apt] adding the key for the docker apt repository ..."
      sudo mkdir -p /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

      echo "[apt] adding the docker apt repository ..."
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

      echo "[apt] installing docker"
      sudo apt update && sudo apt -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
      ;;
    No)
      echo "[linux] docker will not be installed"
      ;;
  esac
else
  echo "[linux] docker already installed"
fi
