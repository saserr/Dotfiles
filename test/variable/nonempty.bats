#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'variable::nonempty'
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

  run variable::nonempty

  assert::wrong_usage 'variable::nonempty' 'name'
}

@test "succeeds if variable is declared and a non-empty value" {
  foo='bar'

  variable::nonempty 'foo'
}

@test "succeeds if variable is a non-empty indexed array with a non-empty first element" {
  foo=('bar')

  variable::nonempty 'foo'
}

@test "succeeds if variable is a non-empty indexed array with an empty first element" {
  foo=('')

  variable::nonempty 'foo'
}

@test "succeeds if variable is a non-empty associative array" {
  if [[ "$BASH_VERSION" < '4' ]]; then
    skip 'associative arrays are unsupported'
  fi

  declare -A foo
  foo['bar']='baz'

  variable::nonempty 'foo'
}

@test "fails if variable is declared and an empty value" {
  foo=''

  ! variable::nonempty 'foo'
}

@test "fails if variable is an empty array" {
  foo=()

  ! variable::nonempty 'foo'
}

@test "fails if variable is only declared" {
  declare -g foo

  ! variable::nonempty 'foo'
}

@test "fails if variable is only declared as an indexed array" {
  declare -ga foo

  ! variable::nonempty 'foo'
}

@test "fails if variable is only declared as an associative array" {
  if [[ "$BASH_VERSION" < '4' ]]; then
    skip 'associative arrays are unsupported'
  fi

  declare -gA foo

  ! variable::nonempty 'foo'
}

@test "fails if variable is only localy declared" {
  local foo

  ! variable::nonempty 'foo'
}

@test "fails if variable is only readonly declared" {
  readonly foo

  ! variable::nonempty 'foo'
}

@test "fails if variable is not declared" {
  ! variable::nonempty 'foo'
}
