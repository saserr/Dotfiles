source src/arguments/expect.bash

function::exists() {
  arguments::expect $# 'name'

  local name=$1

  [ "$(type -t "$name")" = 'function' ]
}
