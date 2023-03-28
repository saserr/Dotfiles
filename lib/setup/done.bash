import 'abort'
import 'arguments::expect'
import 'path::parent'
import 'setup::file'

setup::done() {
  arguments::expect $# 'recipe'

  local recipe=$1

  local file
  if ! file="$(setup::file "$recipe")"; then
    abort internal_error "${FUNCNAME[0]}" "failed to get the path to the ${recipe}'s state file"
  fi

  mkdir -p "$(path::parent "$file")"
  echo "1" >"$file"
}
