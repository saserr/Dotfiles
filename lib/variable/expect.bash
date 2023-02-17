import 'abort'
import 'arguments::expect'
import 'caller::location'
import 'caller::name'
import 'variable::nonempty'

variable::expect() {
  arguments::expect $# 'name' '...'

  local names=("$@")

  local missing=()
  local name
  for name in "${names[@]}"; do
    if ! variable::nonempty "$name"; then
      missing+=("$name")
    fi
  done

  if [ "${#missing[@]}" -gt 0 ]; then
    local messages=("expected variable variables: ${missing[*]}")
    if location="$(caller::location 2)"; then
      messages+=("at $location")
    fi
    abort "$(caller::name)" "${messages[@]}"
  fi
}
