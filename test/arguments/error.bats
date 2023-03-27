#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'arguments::error'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run arguments::error

  assert::wrong_usage 'arguments::error' 'message' '...'
}

@test "the output contains the function name and the message" {
  load '../helpers/import.bash'
  import 'file::write'
  import 'log::error'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'arguments::error'" \
    "foo() { arguments::error 'bar'; }" \
    'foo'
  chmod +x "$script"

  run "$script"

  ((status == 2))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == "$(log::error 'foo' 'bar')" ]]
  [[ "${lines[1]}" == "      at $script (line: 5)" ]]
}

@test "the output contains the additional messages" {
  load '../helpers/import.bash'
  import 'assert::exits'

  test() { arguments::error 'foo' 'bar' 'baz'; }
  assert::exits test

  ((status == 2))
  [[ "${lines[1]}" == '       bar' ]]
  [[ "${lines[2]}" == '       baz' ]]
}

@test "the output contains the shell if it is invoked outside of a function" {
  import 'log::error'

  run /usr/bin/env bash -c "source 'lib/import.bash' && import 'arguments::error' && arguments::error 'foo'"

  ((status == 2))
  [[ "$output" == "$(log::error 'bash' 'foo')" ]]
}

@test "the output contains the script name if it is invoked outside of a function" {
  load '../helpers/import.bash'
  import 'file::write'
  import 'log::error'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'arguments::error'" \
    "arguments::error 'bar'"
  chmod +x "$script"

  run "$script"

  ((status == 2))
  [[ "$output" == "$(log::error "$script" 'bar')" ]]
}
