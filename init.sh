#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
  echo "******************"
  echo "* Setting up Mac *"
  echo "******************"
  cd mac
  ./init.sh
  cd ..

  echo
fi

echo "******************"
echo "* Setting up zsh *"
echo "******************"
cd zsh
./init.sh
cd ..

echo

echo "******************"
echo "* Setting up git *"
echo "******************"
cd git
./init.sh
cd ..

echo

echo "********************"
echo "* Setting up emacs *"
echo "********************"
cd emacs
./init.sh
cd ..

echo

echo "****************************"
echo "* Setting up 1password-cli *"
echo "****************************"
cd 1password-cli
./init.sh
cd ..

echo

echo "************************"
echo "* Setting up tailscale *"
echo "************************"
cd tailscale
./init.sh
cd ..
