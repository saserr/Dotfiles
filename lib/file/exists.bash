import 'arguments::expect'

file::exists() {
  arguments::expect $# 'path'

  local path=$1
  path="$(readlink -f "$path")" || return 1

  [[ -f "$path" ]]
}
