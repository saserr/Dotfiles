#!/usr/bin/env bash

recipe=$1

source lib/import.bash

import 'message::error'
import 'path::exists'

if ! path::exists "$recipe/recipe"; then
  message::error "$recipe" 'does not exits'
  exit 1
fi

import 'function::exists'
import 'message::info'
import 'platform::install'
import 'platform::name'
import 'prompt::yes_or_no'
import 'setup::done'
import 'setup::missing'
import 'text::header'
import 'value::empty'

# shellcheck source=/dev/null
source "$recipe/recipe"

if setup::missing "$recipe"; then
  maybe_required=("${required[@]}")

  case "$(platform::name)" in
  mac)
    maybe_required+=("${mac_required[@]}")
    ;;
  debian)
    maybe_required+=("${debian_required[@]}")
    ;;
  esac

  required=()

  for maybe_required_recipe in "${maybe_required[@]}"; do
    if setup::missing "$maybe_required_recipe"; then
      required+=("$maybe_required_recipe")
    fi
  done

  if [ ${#required[@]} -gt 0 ]; then
    message::info "$recipe" "requires (${required[*]}); do you want to set them up (Yes / No)?"
    case $(prompt::yes_or_no) in
    Yes)
      echo
      for required_recipe in "${required[@]}"; do
        ./setup.sh "$required_recipe" || exit 1
        echo
      done
      ;;
    No)
      exit 1
      ;;
    esac
  fi

  text::header "Setting up $recipe"

  if value::empty "$program"; then
    program="$recipe"
  fi

  platform::install "$recipe" || exit 1

  if function::exists configure; then
    configure || exit 1
  fi

  setup::done "$recipe"
else
  message::info "$recipe" 'already set up'
fi

if [ ${#recommended[@]} -gt 0 ]; then
  for recommended_recipe in "${recommended[@]}"; do
    if setup::missing "$recommended_recipe"; then
      message::info "$recipe" "do you want to install $recommended_recipe (Yes / No)?"
      if [[ $(prompt::yes_or_no) == Yes ]]; then
        echo
        ./setup.sh "$recommended_recipe"
      fi
    fi
  done
fi
