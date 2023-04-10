import 'abort::exit'
import 'arguments::expect'
import 'array::contains'
import 'log'
import 'stack_trace::create'

ABORT_WITH_STACK_TRACE+=('internal_error')
export ABORT_WITH_STACK_TRACE

abort() {
  arguments::expect $# 'error' 'tag' 'message' '...'

  local error=$1
  local tag=$2
  local messages=("${@:3}")

  if array::contains "$error" "${ABORT_WITH_STACK_TRACE[@]}" \
    && stack_trace::create; then
    # skip ${STACK_TRACE[0]} which is this file (abort.bash)
    messages+=("${STACK_TRACE[@]:1}")
  fi

  log error "$tag" "${messages[@]}"
  abort::exit "$error"
}
