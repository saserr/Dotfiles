source src/arguments/expect.bash

file::contains() {
  arguments::expect $# 'file' 'text'

  local file=$1
  local text=$2

  grep -q "$text" "$file"
}
