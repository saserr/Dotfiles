import 'arguments::expect'
import 'log::error'
import 'stack_trace::create'

abort() {
  arguments::expect $# 'tag' 'message' '...'

  local tag=$1
  local messages=("${@:2}")

  if stack_trace::create; then
    # skip ${STACK_TRACE[0]} which is this file (abort.bash)
    messages+=("${STACK_TRACE[@]:1}")
  fi

  log::error "$tag" "${messages[@]}" 1>&2
  exit 2
}
