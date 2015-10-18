#!/bin/bash

source ../functions.sh

if installed emacs
then
  echo "Setting up .emacs ..."
  safe_link ".emacs" $PWD/emacs ~/.emacs

  echo "Setting up .emacs.linux.el ..."
  safe_link ".emacs.linux.el" $PWD/emacs.linux.el ~/.emacs.linux.el

  echo "Setting up .emacs.mac.el ..."
  safe_link ".emacs.mac.el" $PWD/emacs.mac.el ~/.emacs.mac.el

  echo "Save the local specific emacs configuration into ~/.emacs.local.el"
  touch ~/.emacs.local.el
else
  echo "emacs not installed; skipping its configuration"
fi
