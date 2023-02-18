import 'arguments::expect'
import 'text::contains'
import 'text::ends_with'
import 'variable::expect'

assert::wrong_usage() {
  arguments::expect $# 'function' '[argument]' '...'
  variable::expect 'status' 'lines'

  local function=$1
  local arguments=("${@:2}")

  ((${status:?} == 2))
  text::contains "${lines[0]:?}" "$function"
  text::contains "${lines[0]:?}" 'wrong number of arguments'
  text::ends_with "${lines[3]:?}" "arguments: ${arguments[*]}"
}
