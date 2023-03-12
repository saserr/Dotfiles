import 'arguments::expect'
import 'path::exists'

path::parent() {
  arguments::expect $# 'file'

  local file=$1

  local parent
  parent="$(dirname -- "$file")" || return
  if path::exists "$parent"; then
    (cd -- "$(dirname -- "$file")" >/dev/null 2>&1 && pwd)
  else
    echo "$parent"
  fi
}
