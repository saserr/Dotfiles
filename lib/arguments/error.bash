import 'abort'
import 'arguments::expect'
import 'caller::location'
import 'caller::name'

arguments::error() {
  arguments::expect $# 'message' '...'

  local messages=("$@")
  local location
  if location="$(caller::location 2)"; then
    messages+=("at $location")
  fi

  abort "$(caller::name)" "${messages[@]}"
}
