source src/arguments/expect.bash

file::empty() {
  arguments::expect $# 'file'

  local file=$1

  [ ! -s "$file" ]
}
