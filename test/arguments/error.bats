#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  load ../helpers/assert/wrong_usage

  import 'arguments::error'
  import 'text::contains'
  import 'text::ends_with'
}

@test "fails without arguments" {
  run arguments::error

  assert::wrong_usage 'arguments::error' 'message' '...'
}

@test "the output contains the function name and the message" {
  foo() {
    arguments::error 'bar'
  }

  run foo

  text::contains "${lines[0]}" 'foo'
  text::contains "${lines[0]}" 'bar'
}

@test "the output contains the additional messages" {
  foo() {
    arguments::error 'bar' 'baz'
  }

  run foo

  [ "${lines[1]}" = '      baz' ]
}

@test "the output contains the shell if it is invoked outside of a function" {
  run bash -c "source lib/import.bash && import 'arguments::error' && arguments::error 'foo'"

  text::contains "${lines[0]}" 'bash'
  text::contains "${lines[0]}" 'foo'
}

@test "the output contains the script name if it is invoked outside of a function" {
  local foo="$BATS_TEST_TMPDIR/foo"
  echo '#!/usr/bin/env bash' >>"$foo"
  echo "source lib/import.bash && import 'arguments::error' && arguments::error 'bar'" >>"$foo"
  chmod +x "$foo"

  run "$foo"

  text::contains "${lines[0]}" "$BATS_TEST_TMPDIR/foo"
  text::contains "${lines[0]}" 'bar'
}

@test "exits" {
  fail() {
    echo 'foo'
    arguments::error 'bar' 2>/dev/null
    echo 'baz'
  }

  run fail

  [ "$status" -eq 2 ]
  [ "$output" = 'foo' ]
}
