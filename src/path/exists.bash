source src/arguments/expect.bash

path::exists() {
  arguments::expect $# 'path'

  local path=$1

  [ -e "$path" ]
}
