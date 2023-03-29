import 'assert::fails'
import 'arguments::expect'
import 'path::exists'
import 'temporary::file'

assert::exits() {
  arguments::expect $# 'command' '[argument]' '...'

  local command=$1
  local arguments=("${@:2}")

  local unexpected
  unexpected="$(temporary::file "$BATS_TEST_TMPDIR")"
  rm "$unexpected"                         # delete the temporary file
  assert::fails path::exists "$unexpected" # check that it doesn't exist

  # shellcheck disable=SC2317
  # __test is called by the run method bellow
  __test() {
    $command "${arguments[@]}"

    # this code should be unreachable, because $command is expected to exit
    local -i status=$?
    touch "$unexpected"
    return "$status"
  }
  run __test

  # check that the temporary file still doesn't exist
  assert::fails path::exists "$unexpected"
}
