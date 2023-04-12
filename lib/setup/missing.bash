import 'abort'
import 'arguments::expect'
import 'file::exists'
import 'setup::file'

setup::missing() {
  arguments::expect $# 'recipe'

  local recipe=$1

  local file
  if ! file="$(setup::file "$recipe")"; then
    abort internal_error "$recipe" 'the state file is missing'
  fi

  ! file::exists "$file"
}
