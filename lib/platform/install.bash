import 'apt::install'
import 'arguments::expect'
import 'homebrew::install'
import 'log'
import 'platform::name'
import 'value::empty'
import 'variable::expect'

platform::install() {
  arguments::expect $# # none
  variable::expect 'recipe'

  local platform
  platform="$(platform::name)"

  case $platform in
  'mac')
    if ! value::empty "${homebrew_formula:+ok}"; then
      homebrew::install "${recipe:?}" "$homebrew_formula"
      return
    fi
    ;;
  'debian')
    if function::exists debian_install; then
      debian_install
    else
      if ! value::empty "${apt_package:+ok}"; then
        apt::install "${recipe:?}" "$apt_package"
        return
      fi
    fi
    ;;
  esac

  log::error "$platform" "don't know how to install ${recipe:?}"
  return 1
}
