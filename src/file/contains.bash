import 'arguments::expect'

file::contains() {
  arguments::expect $# 'file' 'text'

  local file=$1
  local text=$2

  grep -q "$text" "$file"
}
