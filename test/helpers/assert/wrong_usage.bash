import 'arguments::expect'
import 'log::error'
import 'text::starts_with'
import 'text::ends_with'
import 'variable::expect'

assert::wrong_usage() {
  arguments::expect $# 'function' '[argument]' '...'
  variable::expect 'status' 'lines'

  local function=$1
  local arguments=("${@:2}")

  ((${status:?} == 2))
  text::starts_with "${lines[0]:?}" "$(log::error "$function" 'wrong number of arguments')"
  text::ends_with "${lines[3]:?}" "arguments: ${arguments[*]}"
}
