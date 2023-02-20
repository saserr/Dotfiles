import 'arguments::expect'
import 'platform::readlink'

file::exists() {
  arguments::expect $# 'path'

  local path=$1
  path="$(platform::readlink -f "$path")" || return 1

  [[ -f "$path" ]]
}
