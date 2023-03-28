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

  log error "$(caller::name)" "${messages[@]}"
  exit 2
}
