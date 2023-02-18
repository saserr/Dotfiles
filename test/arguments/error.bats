#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'arguments::error'
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

  run arguments::error

  assert::wrong_usage 'arguments::error' 'message' '...'
}

@test "the output contains the function name and the message" {
  import 'text::contains'

  foo() {
    arguments::error 'bar'
  }

  run foo

  ((status == 2))
  text::contains "${lines[0]}" 'foo'
  text::contains "${lines[0]}" 'bar'
}

@test "the output contains the additional messages" {
  foo() {
    arguments::error 'bar' 'baz'
  }

  run foo

  ((status == 2))
  [[ "${lines[1]}" == '      baz' ]]
}

@test "the output contains the shell if it is invoked outside of a function" {
  import 'text::contains'

  run bash -c "source lib/import.bash && import 'arguments::error' && arguments::error 'foo'"

  ((status == 2))
  text::contains "${lines[0]}" 'bash'
  text::contains "${lines[0]}" 'foo'
}

@test "the output contains the script name if it is invoked outside of a function" {
  import 'text::contains'

  local foo="$BATS_TEST_TMPDIR/foo"
  echo '#!/usr/bin/env bash' >>"$foo"
  echo "source lib/import.bash && import 'arguments::error' && arguments::error 'bar'" >>"$foo"
  chmod +x "$foo"

  run "$foo"

  ((status == 2))
  text::contains "${lines[0]}" "$foo"
  text::contains "${lines[0]}" 'bar'
}

@test "exits" {
  fail() {
    echo 'foo'
    arguments::error 'bar' 2>/dev/null
    echo 'baz'
  }

  run fail

  ((status == 2))
  [[ "$output" == 'foo' ]]
}
