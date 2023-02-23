import 'abort'
import 'arguments::expect'
import 'caller::location'
import 'log::warn'
import 'recipe::file'
import 'variable::expect'

recipe::load() {
  arguments::expect $# # none
  variable::expect 'recipe'

  local file
  if ! file="$(recipe::file)"; then
    log::warn "${recipe:?}" 'has no recipe'
    return 1
  fi

  # shellcheck source=/dev/null
  if ! source "$file"; then
    local messages=("failed to load from $file")
    local location
    if location="$(caller::location 1)"; then
      messages+=("at $location")
    fi
    abort "${recipe:?}" "${messages[@]}"
  fi

  cd "$(dirname -- "$file")" || return 1
}
