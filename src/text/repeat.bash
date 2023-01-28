source src/arguments/expect.bash

text::repeat() {
  arguments::expect $# 'times' 'text'

  local times=$1
  local text=$2

  if [ "$times" -gt 0 ]; then
    printf "$text%.0s" $(seq 1 "$times")
  fi
}
