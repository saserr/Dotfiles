import 'arguments::expect'
import 'temporary::file'

capture::stderr() {
  arguments::expect $# 'command' '[argument]' '...'

  local command=$1
  local arguments=("${@:2}")

  local error
  error="$(temporary::file "$BATS_TEST_TMPDIR")" || return
  $command "${arguments[@]}" 2>"$error"

  cat "$error"
}
