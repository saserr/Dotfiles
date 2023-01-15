apt::install() {
  local name=$1
  local package=$2

  if [ "$#" -lt 2 ]; then
    echo "Usage: ${FUNCNAME[0]} NAME PACKAGE"
    return 1
  fi

  if dpkg -s "$package" 2>&1 | grep -q 'Status: install ok installed'; then
    echo "[apt] $name already installed ..."
    return 0
  fi

  __apt_install() {
    if ! { apt update && apt -y install "$package"; }; then
      echo "[apt] failed to install $name"
      return 1
    fi

    return 0
  }

  echo "[apt] installing $name ..."
  if [ "$(id -u)" -ne 0 ]; then
    echo '[apt] running as non-root; sudo is needed ...'
    export -f __apt_install
    export name package
    sudo bash -c "__apt_install"
  else
    __apt_install
  fi
}
