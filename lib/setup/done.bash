import 'abort'
import 'arguments::expect'
import 'setup::directory'

setup::done() {
  arguments::expect $# 'recipe'

  local recipe=$1

  local directory
  if ! directory="$(setup::directory)"; then
    abort internal_error "${FUNCNAME[0]}" 'failed to get the path to the state directory' 1>&2
  fi

  mkdir -p "$directory"
  echo "1" >"$directory/$recipe"
}
