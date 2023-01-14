source src/homebrew/install.bash
source src/platform/name.bash
source src/value/empty.bash

platform::install() {
  local program=$1
  local platform
  platform="$(platform::name)"

  case $platform in
  'mac')
    # shellcheck disable=SC2154
    if ! value::empty "$homebrew_formula"; then
      homebrew::install "$program" "$homebrew_formula"
      return
    fi
    ;;
  'debian')
    if function::exists debian_install; then
      debian_install
    else
      # shellcheck disable=SC2154
      if ! value::empty "$apt_package"; then
        if apt list -i | grep -q git; then
          echo "[apt] $program already installed ..."
          return 0
        fi

        echo "[apt] installing $program ..."
        if ! sudo apt update && sudo apt -y install "$apt_package"; then
          echo "[apt] failed to install $program"
          return 1
        fi

        return 0
      fi
    fi
    ;;
  esac

  echo "[$platform] don't know how to install $program"
  return 1
}
