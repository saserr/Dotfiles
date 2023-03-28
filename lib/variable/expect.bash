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
    abort internal_error "$(caller::name)" "expected nonempty variables: ${missing[*]}"
  fi
}
