import 'abort'
import 'arguments::expect'

arguments::error() {
  arguments::expect $# 'message' '...'

  local messages=("$@")
  if [ ${#BASH_SOURCE[@]} -gt 2 ]; then
    local file="${BASH_SOURCE[2]}"
    local line="${BASH_LINENO[1]}"
    messages+=("at $file (line: $line)")
  fi

  local function
  # skip the last element of the FUNCNAME array which is 'main'
  if [ ${#FUNCNAME[@]} -gt 2 ]; then
    function="${FUNCNAME[1]}"
  else
    function="$0"
  fi

  abort "$function" "${messages[@]}"
}
