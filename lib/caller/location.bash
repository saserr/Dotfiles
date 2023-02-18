import 'abort'
import 'arguments::expect'
import 'arguments::integer'

caller::location() {
  arguments::expect $# 'level'
  arguments::integer 'level' "$1"

  local -i level=$1

  if ((${#BASH_SOURCE[@]} > (level + 1))); then
    local file="${BASH_SOURCE[$level + 1]}"
    local line="${BASH_LINENO[$level]}"
    echo "$file (line: $line)"
  else
    return 1
  fi
}
