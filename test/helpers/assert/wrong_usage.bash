import 'arguments::expect'
import 'capture::stderr'
import 'log'
import 'variable::expect'

assert::wrong_usage() {
  arguments::expect $# 'function' '[argument]' '...'
  variable::expect 'status' 'lines'

  local function=$1
  local arguments=("${@:2}")

  ((${status:?} == 3))

  local error_message
  error_message="$(capture::stderr log error "$function" 'wrong number of arguments')" || return
  [[ "${lines[0]:?}" == "$error_message" ]]

  local indentation
  printf -v indentation " %.0s" $(seq 1 $((${#function} + 2)))
  [[ "${lines[3]:?}" == "$indentation arguments: ${arguments[*]}" ]]
}
