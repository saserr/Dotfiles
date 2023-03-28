#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'abort'
}

@test "fails without arguments" {
  load 'helpers/import.bash'
  import 'assert::wrong_usage'

  run abort

  assert::wrong_usage 'abort' 'tag' 'message' '...'
}

@test "fails with only one argument" {
  load 'helpers/import.bash'
  import 'assert::wrong_usage'

  run abort 'foo'

  assert::wrong_usage 'abort' 'tag' 'message' '...'
}

@test "the output contains the tag and the message" {
  load 'helpers/import.bash'
  import 'assert::exits'
  import 'log'

  assert::exits abort 'foo' 'bar'

  ((status == 2))
  [[ "${lines[0]}" == "$(log error 'foo' 'bar')" ]]
}

@test "the output contains any additional messages" {
  load 'helpers/import.bash'
  import 'assert::exits'

  assert::exits abort 'test' 'foo' 'bar' 'baz'

  ((status == 2))
  [[ "${lines[0]}" == "$(log error 'test' 'foo')" ]]
  [[ "${lines[1]}" == '       bar' ]]
  [[ "${lines[2]}" == '       baz' ]]
}

@test "the output contains the stack trace" {
  load 'helpers/import.bash'
  import 'file::write'
  import 'log'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'abort'" \
    "abort 'foo' 'bar'"
  chmod +x "$script"

  run "$script"

  ((status == 2))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == "$(log error 'foo' 'bar')" ]]
  [[ "${lines[1]}" == "      at $script (line: 4)" ]]
}
