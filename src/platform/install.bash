source src/apt/install.bash
source src/arguments/expect.bash
source src/homebrew/install.bash
source src/platform/name.bash
source src/value/empty.bash

platform::install() {
  arguments::expect $# 'program'

  local program=$1
  local platform
  # shellcheck disable=SC2119
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
        apt::install "$program" "$apt_package"
        return
      fi
    fi
    ;;
  esac

  echo "[$platform] don't know how to install $program"
  return 1
}
