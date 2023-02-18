import 'arguments::expect'

path::exists() {
  arguments::expect $# 'path'

  local path=$1

  [[ -e "$path" ]]
}
