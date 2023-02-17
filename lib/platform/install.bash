import 'arguments::expect'
import 'debian::install'
import 'log'
import 'mac::install'
import 'platform::name'
import 'variable::expect'

platform::install() {
  arguments::expect $# # none
  variable::expect 'recipe'

  local platform
  platform="$(platform::name)"

  case $platform in
  'mac')
    mac::install
    return
    ;;
  'debian')
    debian::install
    return
    ;;
  esac

  log::error "$platform" "don't know how to install ${recipe:?}"
  return 1
}
