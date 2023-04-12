import 'arguments::expect'
import 'log'
import 'path::exists'

path::parent() {
  arguments::expect $# 'file'

  local file=$1

  local parent
  if ! parent="$(dirname -- "$file")"; then
    log error "${FUNCNAME[0]}" \
      'unable to determine the parent directory' \
      "file: $file"
    return 1
  fi

  if path::exists "$parent"; then
    (cd -- "$parent" >/dev/null && pwd)
  else
    echo "$parent"
  fi
}
