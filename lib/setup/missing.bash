import 'abort'
import 'arguments::expect'
import 'file::exists'
import 'setup::file'

setup::missing() {
  arguments::expect $# 'recipe'

  local recipe=$1

  local file
  if ! file="$(setup::file "$recipe")"; then
    abort internal_error "${FUNCNAME[0]}" "failed to get the path to the ${recipe}'s state file"
  fi

  ! file::exists "$file"
}
