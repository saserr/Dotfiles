import 'abort'
import 'arguments::expect'
import 'caller::location'
import 'caller::name'

arguments::integer() {
  arguments::expect $# 'name' 'value'

  local name=$1
  local -i value=$2

  if [[ "$value" != "$2" ]]; then
    local messages=("expected integer argument: $name" "actual: $2")
    local location
    if location="$(caller::location 2)"; then
      messages+=("at $location")
    fi
    abort "$(caller::name)" "${messages[@]}"
  fi
}
