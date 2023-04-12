#!/usr/bin/env bash

source 'lib/import.bash'

import 'arguments::expect'
arguments::expect $# 'recipe'
recipe=$1

import 'abort'
import 'recipe::load'
if ! recipe::load; then
  abort user_error "$recipe" 'setup aborted'
fi

import 'array::exists'
import 'log'
import 'platform::name'
import 'prompt::yes_or_no'
import 'recipe::configure'
import 'recipe::install'
import 'setup::done'
import 'setup::missing'

if setup::missing "$recipe"; then
  if array::exists 'required'; then
    maybe_required=("${required[@]}")
  else
    maybe_required=()
  fi

  if ! platform="$(platform::name)"; then
    abort platform_error "$recipe" 'unable to determine required recipes'
  fi

  case "$platform" in
    'mac')
      if array::exists 'mac_required'; then
        maybe_required+=("${mac_required[@]}")
      fi
      ;;
    'debian')
      if array::exists 'debian_required'; then
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
    if ! answer="$(prompt::yes_or_no "$recipe" "requires (${required[*]}); do you want to set them up?" 'Yes')"; then
      abort internal_error "$recipe" 'unable to set up required recipes'
    fi

    case "$answer" in
      Yes)
        echo
        for required_recipe in "${required[@]}"; do
          ./setup.sh "$required_recipe" || exit
          echo
        done
        ;;
      No)
        abort user_error "$recipe" 'setup aborted'
        ;;
    esac
  fi

  log info "$recipe" 'installing'
  if ! recipe::install; then
    abort platform_error "$recipe" 'unable to install'
  fi

  log info "$recipe" 'configuring'
  if ! recipe::configure; then
    abort platform_error "$recipe" 'unable to configure'
  fi

  if ! setup::done "$recipe"; then
    abort platform_error "$recipe" 'setup aborted'
  fi
else
  log info "$recipe" 'already set up'
fi

if array::exists 'recommended'; then
  for recommended_recipe in "${recommended[@]:?}"; do
    if setup::missing "$recommended_recipe"; then
      if ! answer="$(prompt::yes_or_no "$recipe" "do you want to install $recommended_recipe")"; then
        log warn "$recommended_recipe" 'unable to set up' 'skipping!'
      fi

      if [[ "$answer" == 'Yes' ]]; then
        echo
        if ! ./setup.sh "$recommended_recipe"; then
          log warn "$recommended_recipe" 'setup failed' 'ignoring!'
        fi
      fi
    fi
  done
fi
