#!/bin/bash

source ../functions.sh

if installed git
then
  echo "Setting up .gitconfig ..."
  ./gitconfig.sh
else
  echo "git not installed; skipping its configuration"
fi
