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
    log error "${recipe:?}" 'file is missing'
    return 1
  fi

  # shellcheck source=/dev/null
  if ! source "$file"; then
    log error "${recipe:?}" "failed to load from $file"
    return 1
  fi

  local directory
  if ! { directory="$(path::parent "$file")" && cd "$directory"; }; then
    log error "${recipe:?}" 'failed to cd into recipe'\''s directory'
    return 1
  fi
}
