#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'variable::is_array'
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

  run variable::is_array

  assert::wrong_usage 'variable::is_array' 'name'
}

@test "succeeds if variable is a non-empty array with a non-empty first element" {
  foo=('bar')

  variable::is_array 'foo'
}

@test "succeeds if variable is a non-empty array with an empty first element" {
  foo=('')

  variable::is_array 'foo'
}

@test "succeeds if variable is an empty array" {
  foo=()

  variable::is_array 'foo'
}

@test "succeeds if variable is globaly declared as an indexed array" {
  declare -ga foo

  variable::is_array 'foo'
}
  if [[ "$BASH_VERSION" < '4' ]]; then
    skip 'associative arrays are unsupported'
  fi

  declare -gA foo

  variable::is_array 'foo'
}

@test "succeeds if variable is localy declared as an indexed array" {
  local -a foo

  variable::is_array 'foo'
}

@test "succeeds if variable is localy declared as an associative array" {
  if [[ "$BASH_VERSION" < '4' ]]; then
    skip 'associative arrays are unsupported'
  fi

  local -A foo

  variable::is_array 'foo'
}

@test "fails if variable a non-array value" {
  foo='bar'

  ! variable::is_array 'foo'
}

@test "fails if variable is globally declared" {
  declare -g foo

  ! variable::is_array 'foo'
}

@test "fails if variable is localy declared" {
  local foo

  ! variable::is_array 'foo'
}

@test "fails if variable is readonly declared" {
  readonly foo

  ! variable::is_array 'foo'
}

@test "fails if variable is not declared" {
  ! variable::is_array 'foo'
}
