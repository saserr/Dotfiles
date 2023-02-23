import 'apt::missing'
import 'arguments::expect'
import 'log::error'
import 'log::trace'
import 'log::warn'

apt::install() {
  arguments::expect $# 'package' '...'

  local packages=("$@")

  local installed=()
  local missing=()
  for package in "${packages[@]}"; do
    if apt::missing "$package"; then
      missing+=("$package")
    else
      installed+=("$package")
    fi
  done

  if ((${#installed[@]})); then
    log::trace 'apt' "already installed: ${installed[*]}"
  fi

  if ((${#missing[@]} == 0)); then
    return 0
  fi

  __apt_install() {
    if ! { apt update && apt -y install "${missing[@]}"; }; then
      log::error 'apt' 'installation failed'
      return 1
    fi

    return 0
  }

  log::trace 'apt' "installing: ${missing[*]}"
  if (($(id -u) != 0)); then
    log::warn 'apt' 'running as non-root; sudo is needed'
    export -f __apt_install
    sudo /usr/bin/env bash -c "$(declare -p missing); __apt_install"
  else
    __apt_install
  fi
}
