setup() {
  source 'lib/import.bash'
  import 'arguments::integer'
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

  run arguments::integer

  assert::wrong_usage 'arguments::integer' 'name' 'value'
}

@test "fails with only one argument" {
  load ../helpers/assert/wrong_usage

  run arguments::integer

  assert::wrong_usage 'arguments::integer' 'name' 'value'
}

@test "succeeds if value is an integer" {
  run arguments::integer 'foo' 42

  ((status == 0))
  [[ "$output" == '' ]]
}

@test "fails if the value is not an integer" {
  run arguments::integer 'foo' 'bar'

  ((status == 2))
}

@test "the failure message contains the function name and the variable name" {
  import 'text::contains'

  foo() {
    arguments::integer 'bar' 'baz'
  }

  run foo

  text::contains "${lines[0]}" 'foo'
  text::contains "${lines[0]}" 'the bar argument is not an integer'
}

@test "the failure message contains the shell if it is invoked outside of a function" {
  import 'text::contains'

  run bash -c "source lib/import.bash && import 'arguments::integer' && arguments::integer 'foo' 'bar'"

  text::contains "${lines[0]}" 'bash'
  text::contains "${lines[0]}" 'the foo argument is not an integer'
}

@test "the failure message contains the script name if it is invoked outside of a function" {
  import 'text::contains'

  local foo="$BATS_TEST_TMPDIR/foo"
  echo '#!/usr/bin/env bash' >>"$foo"
  echo "source lib/import.bash && import 'arguments::integer' && arguments::integer 'bar' 'baz'" >>"$foo"
  chmod +x "$foo"

  run "$foo"

  text::contains "${lines[0]}" "$foo"
  text::contains "${lines[0]}" 'the bar argument is not an integer'
}

@test "exits when it fails" {
  fail() {
    echo 'foo'
    arguments::integer 'bar' 'not-a-number' 2>/dev/null
    echo 'baz'
  }

  run fail

  ((status == 2))
  [[ "$output" == 'foo' ]]
}
