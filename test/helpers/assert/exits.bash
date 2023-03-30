import 'abort'
import 'assert::fails'
import 'arguments::expect'
import 'path::exists'
import 'temporary::file'

export __assert_exits_unexpected
if ! __assert_exits_unexpected="$(temporary::file "$BATS_TEST_TMPDIR")"; then
  abort 'assert::exits' 'failed to create a temporary file'
fi

__assert_exits_test() {
  local command=$1
  local arguments=("${@:2}")

  # delete the temporary file
  rm -f "$__assert_exits_unexpected"
  # check that it doesn't exist
  assert::fails path::exists "$__assert_exits_unexpected"

  $command "${arguments[@]}"

  # this code should be unreachable, because $command is expected to exit
  local -i status=$?
  touch "$__assert_exits_unexpected"
  return "$status"
}

assert::exits() {
  arguments::expect $# 'command' '[argument]' '...'

  local command=$1
  local arguments=("${@:2}")

  run __assert_exits_test "$command" "${arguments[@]}"

  # check that the temporary file still doesn't exist
  assert::fails path::exists "$__assert_exits_unexpected"
}
