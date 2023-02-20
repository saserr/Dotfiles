import 'apt::missing'
import 'arguments::expect'
import 'log::error'
import 'log::info'
import 'log::warn'

apt::install() {
  arguments::expect $# '[name]' 'package' '...'

  if (($# == 1)); then
    local name=$1
    local packages=("$1")
  else
    local name=$1
    local packages=("${@:2}")
  fi

  local missing=()
  for package in "${packages[@]}"; do
    if apt::missing "$package"; then
      missing+=("$package")
    fi
  done

  if ((${#missing[@]} == 0)); then
    log::info 'apt' "$name already installed ..."
    return 0
  fi

  __apt_install() {
    if ! { apt update && apt -y install "${missing[@]}"; }; then
      log::error 'apt' "failed to install $name"
      return 1
    fi

    return 0
  }

  log::info 'apt' "installing $name ..."
  if (($(id -u) != 0)); then
    log::warn 'apt' 'running as non-root; sudo is needed ...'
    export -f __apt_install
    export name
    sudo bash -c "$(declare -p missing); __apt_install"
  else
    __apt_install
  fi
}
