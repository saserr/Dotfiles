import 'abort'
import 'arguments::expect'
import 'caller::location'
import 'file::exists'
import 'log::error'
import 'recipe::file'
import 'variable::expect'

recipe::load() {
  arguments::expect $# # none
  variable::expect 'recipe'

  local file
  if ! file="$(recipe::file)"; then
    local messages=('failed')
    local location
    if location="$(caller::location 1)"; then
      messages+=("at $location")
    fi
    abort 'recipe::file' "${messages[@]}"
  fi

  if ! file::exists "$file"; then
    log::error "${recipe:?}" 'has no recipe'
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
