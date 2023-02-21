import 'arguments::expect'
import 'platform::readlink'

file::exists() {
  arguments::expect $# 'path'

  local path=$1
  while [[ -L "$path" ]]; do
    path="$(platform::readlink -f "$path")" || return 1
  done

  [[ -f "$path" ]]
}
