import 'abort::exit'
import 'arguments::expect'
import 'caller::name'
import 'log'

arguments::error() {
  arguments::expect $# 'message' '...'

  local messages=("$@")

  # add stack trace
  if stack_trace::create; then
    # skip this function and the caller on the stack trace because the error was
    # caused by caller's caller
    messages+=("${STACK_TRACE[@]:2}")
  fi

  local caller
  if ! caller="$(caller::name)"; then
    caller='__unknown__'
  fi
  log error "$caller" "${messages[@]}"

  abort::exit internal_error
}
