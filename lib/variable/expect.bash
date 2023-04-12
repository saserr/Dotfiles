import 'abort'
import 'arguments::expect'
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

  if ((${#missing[@]})); then
    local caller
    if ! caller="$(caller::name)"; then
      caller='__unknown__'
    fi
    abort internal_error "$caller" "expected nonempty variables: ${missing[*]}"
  fi
}
