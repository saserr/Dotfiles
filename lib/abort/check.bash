import 'abort::in_subshell'
import 'arguments::expect'
import 'file::empty'
import 'log'
import 'value::integer'
import 'variable::nonempty'

# TODO tests

abort::check() {
  # TODO handle pipes

  arguments::expect $# # none

  local abort_file="${RUNTIME_DIR:?}/abort"

  if ! file::empty "$abort_file"; then
    local status
    if ! status="$(head -n 1 "$abort_file")"; then
      log warn "${FUNCNAME[0]}" 'failed to retrieve the exit status'
      error::status 'internal_error'
      status=$?
    fi
    if ! value::integer "$status"; then
      log warn "${FUNCNAME[0]}" \
        'the exit status is not an integer' \
        "found: $status"
      error::status 'internal_error'
      status=$?
    fi

    # TODO test this
    if ! abort::in_subshell; then
      if tail -n +2 "$abort_file"; then
        rm "$abort_file"
      else
        log error "${FUNCNAME[0]}" 'failed to retrieve the abort message' \
          "to see it, run: cat $abort_file"
      fi
    fi

    exit "$status"
  fi
}
