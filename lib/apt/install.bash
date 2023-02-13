import 'arguments::expect'
import 'message::error'
import 'message::info'
import 'message::warning'

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
    message::info 'apt' "$name already installed ..."
    return 0
  fi

  __apt_install() {
    if ! { apt update && apt -y install "$package"; }; then
      message::error 'apt' "failed to install $name"
      return 1
    fi

    return 0
  }

  message::info 'apt' "installing $name ..."
  if [ "$(id -u)" -ne 0 ]; then
    message::warning 'apt' 'running as non-root; sudo is needed ...'
    export -f __apt_install
    export name package
    sudo bash -c "__apt_install"
  else
    __apt_install
  fi
}
