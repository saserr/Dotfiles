import 'arguments::expect'
import 'temporary::directory'

assert::exits() {
  arguments::expect $# 'command' '[argument]' '...'

  local command=$1
  local arguments=("${@:2}")

  local unexpected
  unexpected="$(temporary::directory "$BATS_TEST_TMPDIR")/unexpected"
  [[ ! -e "$unexpected" ]] # doesn't exist

  # shellcheck disable=SC2317
  # __test is called by the run method bellow
  __test() {
    $command "${arguments[@]}"

    # this code should not execute, because $command should exit
    local -i code=$?
    touch "$unexpected"
    return "$code"
  }
  run __test

  [[ ! -e "$unexpected" ]] # still doesn't exist
}
