import 'arguments::expect'
import 'file::exists'
import 'setup::directory'

setup::missing() {
  arguments::expect $# 'recipe'

  local recipe=$1

  local directory
  if ! directory="$(setup::directory)"; then
    abort 'setup::missing' 'failed to get the path to the state directory' 1>&2
  fi

  ! file::exists "$directory/$recipe"
}
