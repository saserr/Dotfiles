import 'abort'
import 'arguments::expect'
import 'file::exists'
import 'setup::directory'

setup::missing() {
  arguments::expect $# 'recipe'

  local recipe=$1

  local directory
  if ! directory="$(setup::directory)"; then
    abort internal_error "${FUNCNAME[0]}" 'failed to get the path to the state directory' 1>&2
  fi

  ! file::exists "$directory/$recipe"
}
