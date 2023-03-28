import 'abort::exit'
import 'arguments::expect'
import 'caller::name'
import 'log'
import 'value::integer'

arguments::integer() {
  arguments::expect $# 'name' 'value'

  local name=$1
  local value=$2

  if ! value::integer "$value"; then
    local messages=("expected integer argument: $name" "actual: $2")

    # add stack trace
    if stack_trace::create; then
      # skip this function and the caller on the stack trace because the error was
      # caused by caller's caller
      messages+=("${STACK_TRACE[@]:2}")
    fi

    log error "$(caller::name)" "${messages[@]}"
    abort::exit internal_error
  fi
}
