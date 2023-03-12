import 'arguments::expect'
import 'file::append'
import 'path::exists'
import 'path::parent'

file::write() {
  arguments::expect $# 'file' 'line' '...'

  local file=$1
  local lines=("${@:2}")

  if path::exists "$file"; then
    return 1
  fi

  local directory
  directory="$(path::parent "$file")" || return
  mkdir -p "$directory" || return

  local line
  for line in "${lines[@]}"; do
    file::append "$file" "$line" || return
  done
}
