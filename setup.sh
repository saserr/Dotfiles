#!/usr/bin/env bash

profile=$1

source function/path/exists

if ! path::exists? $profile/profile; then
  echo "$profile/profile does not exits"
  exit 1
fi

source function/platform/install
source function/prompt/yes_or_no
source function/setup/done
source function/setup/missing
source function/text/header
source function/variable/empty

source $profile/profile

text::header "Setting up $profile"

if setup::missing? $profile; then
  if variable::empty? "$program"; then
    program="$profile"
  fi

  platform::install $program || exit 1

  if [[ "$(type -t configure)" == function ]]; then
    configure || exit 1
  fi

  setup::done $profile
else
  echo "[$profile] already set up"
fi

if ! variable::empty? "$recommended"; then
  for additonal_profile in ${recommended[@]}; do
    if setup::missing? $additonal_profile; then
      echo "[$profile] do you want to install $additonal_profile (Yes / No)? "
      if [[ $(prompt::yes_or_no) == Yes ]]; then
        echo
        ./setup.sh $additonal_profile
      fi
    fi
  done
fi
