import 'abort::in_subshell'
import 'arguments::expect'
import 'array::contains'
import 'error::status'
import 'file::empty'
import 'log'
import 'stack_trace::create'
import 'value::integer'

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

  if abort::in_subshell; then
    local abort_file="${RUNTIME_DIR:?}/abort"
    local status
    local warnings=()

    if file::empty "$abort_file"; then
      warnings+=("$(error::status "$error")")
      status=$?
      echo "$status" >"$abort_file"
    else
      if status="$(head -n 1 "$abort_file")"; then
        warnings+=("$(
          log warn "${FUNCNAME[0]}" \
            'already aborting' \
            'ignoring the new exit status'
        )")
      else
        warnings+=("$(
          log warn "${FUNCNAME[0]}" \
            'failed to retrieve the exit status'
        )")
      fi

      if ! value::integer "$status"; then
        warnings+=("$(
          log warn "${FUNCNAME[0]}" \
            'the original exit status is not an integer' \
            "found: $status"
        )")
        warnings+=("$(error::status "$error")")
        status=$?
      fi
    fi

    {
      log error "$tag" "${messages[@]}"
      local warning
      for warning in "${warnings[@]}"; do
        if [[ "$warning" ]]; then
          echo "$warning"
        fi
      done
    } >>"$abort_file"

    exit "$status"
  else
    log error "$tag" "${messages[@]}" 1>&2
    error::status "$error"
    exit
  fi
}
