#!/bin/bash

source ../functions.sh

if installed emacs; then
  echo "Do you want to set up emacs (Yes / No)? "
  answer=$(yes_or_no)
  case $answer in
    Yes)
      echo "[emacs] setting up .emacs ..."
      safe_link ".emacs" $PWD/emacs ~/.emacs

      if [ ! -e ~/.emacs.d/backups-dir/ ]; then
        echo "[emacs] setting up backup-dir ..."
        mkdir -p ~/.emacs.d/backup-dir/
        curl http://www.northbound-train.com/emacs-hosted/backup-dir.el > ~/.emacs.d/backup-dir/backup-dir.el
      fi

      echo "[emacs] setting up .emacs.linux.el ..."
      safe_link ".emacs.linux.el" $PWD/emacs.linux.el ~/.emacs.linux.el

      echo "[emacs] setting up .emacs.mac.el ..."
      safe_link ".emacs.mac.el" $PWD/emacs.mac.el ~/.emacs.mac.el

      echo "[emacs] save the local specific emacs configuration into ~/.emacs.local.el ..."
      touch ~/.emacs.local.el

      if installed git; then
        echo "[emacs] appending emacs .gitignore"
        curl https://www.toptal.com/developers/gitignore/api/emacs >> ~/.gitignore
      fi

      if echo $SHELL | grep -q zsh; then
        if ! echo $EDITOR | grep -q emacs; then
          echo "[zsh] setting up emacs as the default editor"
          echo "export EDITOR='emacs -nw'" >> ~/.zshenv.local.zsh
        fi
      else
        echo "[zsh] setting up emacs as the default editor"
        echo "export EDITOR='emacs -nw'" >> ~/.profile
      fi
      ;;
    No)
      echo "[emacs] will not be set up"
      ;;
  esac
else
  echo "[emacs] not installed; skipping its setup"
fi
