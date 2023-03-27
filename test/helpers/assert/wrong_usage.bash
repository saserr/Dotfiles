import 'arguments::expect'
import 'log::error'
import 'variable::expect'

assert::wrong_usage() {
  arguments::expect $# 'function' '[argument]' '...'
  variable::expect 'status' 'lines'

  local function=$1
  local arguments=("${@:2}")

  ((${status:?} == 2))
  [[ "${lines[0]:?}" == "$(log::error "$function" 'wrong number of arguments')" ]]

  local indentation
  indentation="$(printf " %.0s" $(seq 1 $((${#function} + 2))))" || return
  [[ "${lines[3]:?}" == "$indentation arguments: ${arguments[*]}" ]]
}
