#!/usr/bin/env bash

profile=$1

source lib/import.bash

import 'path::exists'

if ! path::exists $profile/profile; then
  echo "[$profile] does not exits"
  exit 1
fi

import 'function::exists'
import 'platform::install'
import 'platform::name'
import 'prompt::yes_or_no'
import 'setup::done'
import 'setup::missing'
import 'text::header'
import 'value::empty'

source $profile/profile

if setup::missing $profile; then
  maybe_required=($required)

  case "$(platform::name)" in
  mac)
    maybe_required+=($mac_required)
    ;;
  debian)
    maybe_required+=($debian_required)
    ;;
  esac

  required=()

  for maybe_required_profile in ${maybe_required[@]}; do
    if setup::missing $maybe_required_profile; then
      required+=($maybe_required_profile)
    fi
  done

  if ! value::empty "${required[@]}"; then
    echo "[$profile] requires (${required[@]}); do you want to set them up (Yes / No)?"
    case $(prompt::yes_or_no) in
    Yes)
      echo
      for required_profile in ${required[@]}; do
        ./setup.sh $required_profile || exit 1
        echo
      done
      ;;
    No)
      exit 1
      ;;
    esac
  fi

  text::header "Setting up $profile"

  if value::empty "$program"; then
    program="$profile"
  fi

  platform::install $program || exit 1

  if function::exists configure; then
    configure || exit 1
  fi

  setup::done $profile
else
  echo "[$profile] already set up"
fi

if ! value::empty "${recommended[@]}"; then
  for recommended_profile in ${recommended[@]}; do
    if setup::missing $recommended_profile; then
      echo "[$profile] do you want to install $recommended_profile (Yes / No)? "
      if [[ $(prompt::yes_or_no) == Yes ]]; then
        echo
        ./setup.sh $recommended_profile
      fi
    fi
  done
fi
