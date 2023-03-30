#!/usr/bin/env bats

setup() {
  load '../setup.bash'
  import 'error::status'
}

@test "returns with the appropriate status for the given error" {
  local test_status=42

  run error::status test

  ((status == 42))
}

@test "prints a warning and returns with the status 3 if the status for the given error is not an integer" {
  local test_status='foo'

  run error::status test

  ((status == 3))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == "$(log warn 'error::status' 'expect integer variable: $test_status')" ]]
  [[ "${lines[1]}" == '                actual: foo' ]]
}

@test "the empty error prints a warning and returns with the status 3" {
  run error::status ''

  ((status == 3))
  [[ "$output" == "$(log warn 'error::status' 'expect nonempty argument: error')" ]]
}

@test "the user_error returns with the status 1" {
  run error::status user_error

  ((status == 1))
  [[ "$output" == '' ]]
}

@test "the platform_error returns with the status 2" {
  run error::status platform_error

  ((status == 2))
  [[ "$output" == '' ]]
}

@test "the internal_error returns with the status 3" {
  run error::status internal_error

  ((status == 3))
  [[ "$output" == '' ]]
}

@test "an unknown error prints a warning and returns with the status 3" {
  run error::status test

  ((status == 3))
  [[ "$output" == "$(log warn 'error::status' 'expect integer variable: $test_status')" ]]
}
