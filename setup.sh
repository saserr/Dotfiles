#!/usr/bin/env bash

profile=$1

source function/is_file_missing

if is_file_missing "$profile/profile"; then
  echo "$profile/profile does not exits"
  exit 1
fi

source function/header
source function/install
source function/is_empty
source function/is_not_setup
source function/mark_setup_successful

source $profile/profile

if is_empty "$program"; then
  program="$profile"
fi

header "Setting up $program"

if is_not_setup $program; then
  install $program || exit 1

  if [[ "$(type -t configure)" == function ]]; then
    configure || exit 1
    mark_setup_successful $program
  fi
else
  echo "[$program] already set up"
fi
