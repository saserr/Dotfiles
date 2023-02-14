import 'arguments::expect'
import 'log'

apt::install() {
  arguments::expect $# '[name]' 'package'

  if [ $# -eq 1 ]; then
    local name=$1
    local package=$1
  else
    local name=$1
    local package=$2
  fi

  if dpkg -s "$package" 2>&1 | grep -q 'Status: install ok installed'; then
    log::info 'apt' "$name already installed ..."
    return 0
  fi

  __apt_install() {
    if ! { apt update && apt -y install "$package"; }; then
      log::error 'apt' "failed to install $name"
      return 1
    fi

    return 0
  }

  log::info 'apt' "installing $name ..."
  if [ "$(id -u)" -ne 0 ]; then
    log::warn 'apt' 'running as non-root; sudo is needed ...'
    export -f __apt_install
    export name package
    sudo bash -c "__apt_install"
  else
    __apt_install
  fi
}
