import 'arguments::expect'
import 'debian::install'
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
    debian::install
    return
    ;;
  esac

  log::error "$platform" "don't know how to install ${recipe:?}"
  return 1
}
