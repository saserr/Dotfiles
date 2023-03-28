import 'abort'
import 'arguments::expect'
import 'log'
import 'path::parent'
import 'recipe::file'
import 'variable::expect'

recipe::load() {
  arguments::expect $# # none
  variable::expect 'recipe'

  local file
  if ! file="$(recipe::file)"; then
    log warn "${recipe:?}" 'has no recipe'
    return 1
  fi

  # shellcheck source=/dev/null
  if ! source "$file"; then
    abort "${recipe:?}" "failed to load from $file"
  fi

  local directory
  directory="$(path::parent "$file")" || return
  cd "$directory" || return
}
