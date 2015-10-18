#!/bin/bash

echo "********************"
echo "* Setting up emacs *"
echo "********************"
cd emacs
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

echo "******************"
echo "* Setting up zsh *"
echo "******************"
cd zsh
./init.sh
cd ..
