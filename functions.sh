#!/usr/bin/env bash

installed() {
  local program=$1
  hash $program 2>|/dev/null
}

yes_or_no() {
  select answer in "Yes" "No"; do
    case $answer in
      Yes)
        echo "Yes"
        break
        ;;
      No)
        echo "No"
        break
        ;;
    esac
  done
}

safe_link() {
  local what=$1
  local from=$2
  local to=$3

  if [ -e $to ]; then
    echo "[$what] $to exists; do you want to replace it (Yes / No)? "
    local answer=$(yes_or_no)
    case $answer in
      Yes)
        echo "[$what] Old $to will be moved to $to.old"
        mv $to $to.old
        echo "[$what] $to will be linked to $from"
        ln -s $from $to
        ;;
      No)
        echo "[$what] $to will not be linked"
        ;;
    esac
  else
    echo "[$what] $to doesn't exist; it will be linked to $from"
    ln -s $from $to
  fi
}
