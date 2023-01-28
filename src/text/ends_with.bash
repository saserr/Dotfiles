source src/arguments/expect.bash

text::ends_with() {
  arguments::expect $# 'text' 'suffix'

  local text=$1
  local suffix=$2

  [[ "$text" == *"$suffix" ]]
}
