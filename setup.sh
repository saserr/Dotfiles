#!/usr/bin/env bash

profile=$1

source function/file/missing

if file::missing? "$profile/profile"; then
  echo "$profile/profile does not exits"
  exit 1
fi

source function/platform/install
source function/text/header
source function/variable/empty

source $profile/profile

if variable::empty? "$program"; then
  program="$profile"
fi

text::header "Setting up $program"

if file::missing? ~/.setup/$program; then
  platform::install $program || exit 1

  if [[ "$(type -t configure)" == function ]]; then
    configure || exit 1
    mkdir -p ~/.setup/
    echo "1" > ~/.setup/$program
  fi
else
  echo "[$program] already set up"
fi
