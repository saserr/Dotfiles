import 'arguments::expect'
import 'setup::directory'

setup::done() {
  arguments::expect $# 'recipe'

  local recipe=$1

  local directory
  if ! directory="$(setup::directory)"; then
    abort 'setup::done' 'failed to get the path to the state directory' 1>&2
  fi

  mkdir -p "$directory"
  echo "1" >"$directory/$recipe"
}
