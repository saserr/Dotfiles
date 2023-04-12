import 'abort'
import 'apt::missing'
import 'arguments::expect'
import 'log'
import 'platform::is_root'

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
    log trace 'apt' "already installed: ${installed[*]}"
  fi

  if ((${#missing[@]} == 0)); then
    return 0
  fi

  __apt_install() {
    apt update && apt -y install "${missing[@]}"
    local -i status=$?
    if ((status)); then
      log error 'apt' 'installation failed'
    fi
    return "$status"
  }

  log trace 'apt' "installing: ${missing[*]}"
  if platform::is_root; then
    __apt_install
  else
    log warn 'apt' 'running as non-root' 'sudo is needed'

    local missing_declaration
    if ! missing_declaration="$(declare -p missing)"; then
      abort platform_error 'declare' 'command failed'
    fi

    export -f __apt_install
    sudo /usr/bin/env bash -c "$missing_declaration && __apt_install"
  fi
}
