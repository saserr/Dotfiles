#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'abort'

  export test_abort_status=42
}

@test "fails without arguments" {
  load 'helpers/import.bash'
  import 'assert::wrong_usage'

  run abort

  assert::wrong_usage 'abort' 'error' 'tag' 'message' '...'
}

@test "fails with only one argument" {
  load 'helpers/import.bash'
  import 'assert::wrong_usage'

  run abort test

  assert::wrong_usage 'abort' 'error' 'tag' 'message' '...'
}

@test "fails with two arguments" {
  load 'helpers/import.bash'
  import 'assert::wrong_usage'

  run abort test 'foo'

  assert::wrong_usage 'abort' 'error' 'tag' 'message' '...'
}

@test "the output contains the tag and the message" {
  load 'helpers/import.bash'
  import 'assert::exits'
  import 'log'

  assert::exits abort test 'foo' 'bar'

  ((status == 42))
  [[ "$output" == "$(log error 'foo' 'bar')" ]]
}

@test "the output contains any additional messages" {
  load 'helpers/import.bash'
  import 'assert::exits'

  assert::exits abort test 'test' 'foo' 'bar' 'baz'

  ((status == 42))
  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == "$(log error 'test' 'foo')" ]]
  [[ "${lines[1]}" == '       bar' ]]
  [[ "${lines[2]}" == '       baz' ]]
}

@test "the output does not contain the stack trace if error is not in \$ABORT_WITH_STACK_TRACE" {
  load 'helpers/import.bash'
  import 'file::write'
  import 'log'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'abort'" \
    "abort test 'foo' 'bar'"
  chmod +x "$script"

  run "$script"

  ((status == 42))
  [[ "$output" == "$(log error 'foo' 'bar')" ]]
}

@test "the output contains the stack trace if error is in \$ABORT_WITH_STACK_TRACE" {
  load 'helpers/import.bash'
  import 'file::write'
  import 'log'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'abort'" \
    "ABORT_WITH_STACK_TRACE+=('test')" \
    "abort test 'foo' 'bar'"
  chmod +x "$script"

  run "$script"

  ((status == 42))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == "$(log error 'foo' 'bar')" ]]
  [[ "${lines[1]}" == "      at $script (line: 5)" ]]
}

@test "the user_error does not print stack trace" {
  load 'helpers/import.bash'
  import 'assert::exits'

  assert::exits abort user_error 'foo' 'bar'

  ((status == 1))
  [[ "$output" == "$(log error 'foo' 'bar')" ]]
}

@test "the platform_error does not print stack trace" {
  load 'helpers/import.bash'
  import 'assert::exits'

  assert::exits abort platform_error 'foo' 'bar'

  ((status == 2))
  [[ "$output" == "$(log error 'foo' 'bar')" ]]
}

@test "the internal_error prints stack trace" {
  load 'helpers/import.bash'
  import 'assert::exits'
  import 'file::write'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'abort'" \
    "abort internal_error 'foo' 'bar'"
  chmod +x "$script"

  run "$script"

  ((status == 3))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == "$(log error 'foo' 'bar')" ]]
  [[ "${lines[1]}" == "      at $script (line: 4)" ]]
}
