import 'assert::fails'
import 'arguments::expect'
import 'path::exists'
import 'temporary::file'

__assert::exits::test() {
  arguments::expect $# 'unexpected' 'command' '[argument]' '...'

  local unexpected=$1
  local command=$2
  local arguments=("${@:3}")

  $command "${arguments[@]}"

  # this code should be unreachable, because $command is expected to exit
  local -i status=$?
  touch "$unexpected"
  return "$status"
}

assert::exits() {
  arguments::expect $# 'command' '[argument]' '...'

  local command=$1
  local arguments=("${@:2}")

  local unexpected
  unexpected="$(temporary::file "$BATS_TEST_TMPDIR")" || return
  rm "$unexpected"                         # delete the temporary file
  assert::fails path::exists "$unexpected" # check that it doesn't exist

  run __assert::exits::test "$unexpected" "$command" "${arguments[@]}"

  # check that the temporary file still doesn't exist
  assert::fails path::exists "$unexpected"
}
