source src/text/contains.bash
source src/text/ends_with.bash

assert::wrong_usage() {
  local function=$1
  local arguments=("${@:2}")

  [ "${status:?}" -eq 2 ]
  text::contains "${lines[0]:?}" "$function"
  text::contains "${lines[0]:?}" 'wrong number of arguments'
  text::ends_with "${lines[3]:?}" "arguments: ${arguments[*]}"
}
