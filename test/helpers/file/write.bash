import 'arguments::expect'
import 'file::append'
import 'path::exists'

file::write() {
  arguments::expect $# 'file' 'line' '...'

  local file=$1
  local lines=("${@:2}")

  if path::exists "$file"; then
    return 1
  fi

  mkdir -p "$(dirname -- "$file")" || return 1

  local line
  for line in "${lines[@]}"; do
    file::append "$file" "$line" || return 1
  done
}
