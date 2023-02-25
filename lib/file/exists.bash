import 'arguments::expect'

file::exists() {
  arguments::expect $# 'path'

  local path=$1

  [[ -e "$path" ]] && [[ ! -d "$path" ]]
}
