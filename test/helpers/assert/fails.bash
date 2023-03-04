import 'arguments::expect'

assert::fails() {
  arguments::expect $# 'command' '[argument]' '...'

  local command=$1
  local arguments=("${@:2}")

  # the negation must be the last command for it to work with bats
  ! $command "${arguments[@]}"
}
