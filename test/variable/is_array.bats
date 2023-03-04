#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'variable::is_array'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

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

@test "succeeds if variable is declared as an indexed array" {
  declare -a foo

  variable::is_array 'foo'
}
@test "succeeds if variable is declared as an associative array" {
  import 'bash::support::associative_array'
  if ! bash::support::associative_array; then
    skip 'associative arrays are not supported'
  fi

  declare -A foo

  variable::is_array 'foo'
}

@test "succeeds if variable is localy declared as an indexed array" {
  local -a foo

  variable::is_array 'foo'
}

@test "succeeds if variable is localy declared as an associative array" {
  import 'bash::support::associative_array'
  if ! bash::support::associative_array; then
    skip 'associative arrays are not supported'
  fi

  local -A foo

  variable::is_array 'foo'
}

@test "fails if variable a non-array value" {
  load '../helpers/import.bash'
  import 'assert::fails'

  foo='bar'

  assert::fails variable::is_array 'foo'
}

@test "fails if variable is only globally declared" {
  import 'bash::support::declare_global'
  if ! bash::support::declare_global; then
    skip 'declare global is not supported'
  fi

  load '../helpers/import.bash'
  import 'assert::fails'

  declare -g foo

  assert::fails variable::is_array 'foo'
}

@test "fails if variable is only localy declared" {
  load '../helpers/import.bash'
  import 'assert::fails'

  local foo

  assert::fails variable::is_array 'foo'
}

@test "fails if variable is only readonly declared" {
  load '../helpers/import.bash'
  import 'assert::fails'

  local foo
  readonly foo

  assert::fails variable::is_array 'foo'
}

@test "fails if variable is not declared" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails variable::is_array 'foo'
}
