import 'arguments::expect'
import 'log'
import 'value::empty'
import 'variable::exists'
import 'value::integer'

export user_error_status=1
export platform_error_status=2
export internal_error_status=3

error::status() {
  arguments::expect $# 'error'

  local error
  if value::empty "$1"; then
    log warn "${FUNCNAME[0]}" 'expect nonempty argument: error'
    error='internal_error'
  else
    error=$1
  fi

  local status
  local status_variable_name="${error}_status"
  if variable::exists "$status_variable_name"; then
    status="${!status_variable_name}"
    if ! value::integer "$status"; then
      log warn "${FUNCNAME[0]}" "expect integer variable: \$$status_variable_name" "actual: $status"
      status="$internal_error_status"
    fi
  else
    log warn "${FUNCNAME[0]}" "expect integer variable: \$$status_variable_name"
    status="$internal_error_status"
  fi

  return "$status"
}
