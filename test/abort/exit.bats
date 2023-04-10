#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'abort::exit'
}

@test "exits with the appropriate status for the given error" {
  load '../helpers/import.bash'
  import 'assert::exits'

  local test_abort_status=42

  assert::exits abort::exit test

  ((status == 42))
}

@test "prints a warning and exits with the status 3 if the status for the given error is not an integer" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'capture::stderr'

  local test_abort_status='foo'

  assert::exits abort::exit test

  ((status == 3))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == "$(capture::stderr log warn 'abort::exit' 'expect integer variable: $test_abort_status')" ]]
  [[ "${lines[1]}" == '              actual: foo' ]]
}

@test "the empty error prints a warning and exits with the status 3" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'capture::stderr'

  assert::exits abort::exit ''

  ((status == 3))
  [[ "$output" == "$(capture::stderr log warn 'abort::exit' 'expect nonempty argument: error')" ]]
}

@test "the user_error exits with the status 1" {
  load '../helpers/import.bash'
  import 'assert::exits'

  assert::exits abort::exit user_error

  ((status == 1))
  [[ "$output" == '' ]]
}

@test "the platform_error exits with the status 2" {
  load '../helpers/import.bash'
  import 'assert::exits'

  assert::exits abort::exit platform_error

  ((status == 2))
  [[ "$output" == '' ]]
}

@test "the internal_error exits with the status 3" {
  load '../helpers/import.bash'
  import 'assert::exits'

  assert::exits abort::exit internal_error

  ((status == 3))
  [[ "$output" == '' ]]
}

@test "an unknown error prints a warning and exits with the status 3" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'capture::stderr'

  assert::exits abort::exit test

  ((status == 3))
  [[ "$output" == "$(capture::stderr log warn 'abort::exit' 'expect integer variable: $test_abort_status')" ]]
}
