#!/bin/bash

source ../functions.sh

if installed ssh; then
  missing() {
    local what=$1
    [ ! -f "$~/config.d/$what" ]
  }

  if installed tailscale && tailscale status > /dev/null && missing "tailscale"; then
    echo "Do you want to set up ssh through tailscale (Yes / No)? "
    answer=$(yes_or_no)
    case $answer in
      Yes)
        echo "[ssh] setting up ssh through tailscale ..."
        mkdir -p ~/.ssh/config.d/
        safe_link "tailscale" $PWD/tailscale ~/.ssh/config.d/tailscale
        safe_link "nas.pub" $PWD/nas.pub ~/.ssh/nas.pub
        safe_link "dev.pub" $PWD/dev.pub ~/.ssh/dev.pub
        safe_link "server.pub" $PWD/server.pub ~/.ssh/server.pub
        safe_link "esxi.pub" $PWD/esxi.pub ~/.ssh/esxi.pub
        echo "Include config.d/tailscale" >> ~/.ssh/config
        ;;
      No)
        echo "[ssh] ssh through tailscale will not be set up"
        ;;
    esac
  fi

  if installed git && missing "github"; then
    echo "Do you want to set up ssh to github.com (Yes / No)? "
    answer=$(yes_or_no)
    case $answer in
      Yes)
        echo "[ssh] setting up ssh to github.com ..."
        mkdir -p ~/.ssh/config.d/
        safe_link "github" $PWD/github ~/.ssh/config.d/github
        safe_link "github.pub" $PWD/github.pub ~/.ssh/github.pub
        echo "Include config.d/github" >> ~/.ssh/config
        ;;
      No)
        echo "[ssh] ssh to github.com will not be set up"
        ;;
    esac
  fi

  if missing "1password"; then
    echo "Do you want to set up 1password as ssh agent (Yes / No)? "
    answer=$(yes_or_no)
    case $answer in
      Yes)
        echo "[ssh] setting up 1password as ssh agent"
        if [ "$(uname -s)" == "Darwin" ]; then
          mkdir -p ~/.ssh/config.d/
          safe_link "1password" $PWD/1password.mac ~/.ssh/config.d/1password
          echo "Include config.d/1password" >> ~/.ssh/config
        elif [ "$(uname -s)" == "Linux" ]; then
          mkdir -p ~/.ssh/config.d/
          safe_link "1password" $PWD/1password.linux ~/.ssh/config.d/1password
          echo "Include config.d/1password" >> ~/.ssh/config
        else
          echo "[ssh] unknown OS \"$(uname -s)\""
        fi
        ;;
      No)
        echo "[ssh] 1password as ssh agent will not be set up"
        ;;
    esac
  else
    echo "[ssh] 1password as ssh agent already set up"
  fi
else
  echo "[ssh] not installed; skipping its setup"
fi
