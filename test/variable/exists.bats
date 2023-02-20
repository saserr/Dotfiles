#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'variable::exists'
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

  run variable::exists

  assert::wrong_usage 'variable::exists' 'name'
}

@test "succeeds if variable is declared and a non-empty value" {
  foo='bar'

  variable::exists 'foo'
}

@test "succeeds if variable is a non-empty indexed array with a non-empty first element" {
  foo=('bar')

  variable::exists 'foo'
}

@test "succeeds if variable is a non-empty indexed array with an empty first element" {
  foo=('')

  variable::exists 'foo'
}

@test "succeeds if variable is a non-empty associative array" {
  if ((${BASH_VERSINFO[0]} < 4)); then
    skip 'associative arrays are unsupported'
  fi

  declare -A foo
  foo['bar']='baz'

  variable::exists 'foo'
}

@test "succeeds if variable is declared and an empty value" {
  foo=''

  variable::exists 'foo'
}

@test "succeeds if variable is an empty array" {
  foo=()

  variable::exists 'foo'
}

@test "succeeds if variable is only declared" {
  declare foo

  variable::exists 'foo'
}

@test "succeeds if variable is only declared as an indexed array" {
  declare -a foo

  variable::exists 'foo'
}

@test "succeeds if variable is only declared as an associative array" {
  if ((${BASH_VERSINFO[0]} < 4)); then
    skip 'associative arrays are unsupported'
  fi

  declare -A foo

  variable::exists 'foo'
}

@test "succeeds if variable is only globally declared" {
  if ((${BASH_VERSINFO[0]} < 4)) \
    || (((${BASH_VERSINFO[0]} == 4) && (${BASH_VERSINFO[1]} < 2))); then
    skip "'declare -g' is unsupported"
  fi

  declare -g foo

  variable::exists 'foo'
}

@test "succeeds if variable is only localy declared" {
  local foo

  variable::exists 'foo'
}

@test "succeeds if variable is only readonly declared" {
  local foo
  readonly foo

  variable::exists 'foo'
}

@test "fails if variable is not declared" {
  ! variable::exists 'foo'
}
