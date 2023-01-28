source src/arguments/expect.bash

value::empty() {
  arguments::expect $# 'value'

  local value=$1

  [ -z "$value" ]
}
