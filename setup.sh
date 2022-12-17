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

text::header "Setting up $profile"

if file::missing? ~/.setup/$profile; then
  if variable::empty? "$program"; then
    program="$profile"
  fi

  platform::install $program || exit 1

  if [[ "$(type -t configure)" == function ]]; then
    configure || exit 1
    mkdir -p ~/.setup/
    echo "1" > ~/.setup/$profile
  fi
else
  echo "[$profile] already set up"
fi
