#!/usr/bin/env bash

source lib/import.bash

import 'arguments::expect'
arguments::expect $# 'recipe'

recipe=$1

import 'log'
import 'path::exists'

if ! path::exists "$recipe/recipe"; then
  log::error "$recipe" 'does not exits'
  exit 1
fi

import 'function::exists'
import 'platform::name'
import 'prompt::yes_or_no'
import 'recipe::install'
import 'setup::done'
import 'setup::missing'
import 'text::header'
import 'variable::is_array'

# shellcheck source=/dev/null
source "$recipe/recipe"

if setup::missing "$recipe"; then
  if variable::is_array 'required'; then
    maybe_required=("${required[@]}")
  else
    maybe_required=()
  fi

  case "$(platform::name)" in
  'mac')
    if variable::is_array 'mac_required'; then
      maybe_required+=("${mac_required[@]}")
    fi
    ;;
  'debian')
    if variable::is_array 'debian_required'; then
      maybe_required+=("${debian_required[@]}")
    fi
    ;;
  esac

  required=()

  for maybe_required_recipe in "${maybe_required[@]}"; do
    if setup::missing "$maybe_required_recipe"; then
      required+=("$maybe_required_recipe")
    fi
  done

  if ((${#required[@]})); then
    case "$(prompt::yes_or_no "$recipe" "requires (${required[*]}); do you want to set them up?" 'Yes')" in
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

  recipe::install || exit 1

  if function::exists configure; then
    configure || exit 1
  fi

  setup::done "$recipe"
else
  log::info "$recipe" 'already set up'
fi

if variable::is_array 'recommended'; then
  for recommended_recipe in "${recommended[@]:?}"; do
    if setup::missing "$recommended_recipe"; then
      if [ "$(prompt::yes_or_no "$recipe" "do you want to install $recommended_recipe")" = 'Yes' ]; then
        echo
        ./setup.sh "$recommended_recipe"
      fi
    fi
  done
fi
