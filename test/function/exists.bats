#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'function::exists'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run function::exists

  assert::wrong_usage 'function::exists' 'name'
}

@test "a function is a function" {
  function::exists 'function::exists'
}

@test "an unknown function is not a function" {
  ! function::exists 'foo'
}

@test "a program on \$PATH is not a function" {
  ! function::exists 'env'
}

@test "a variable is not a function and thus doesn't exist" {
  foo='bar'

  ! function::exists 'foo'
}

@test "a global variable is not a function and thus doesn't exist" {
  import 'bash::support::declare_global'
  if ! bash::support::declare_global; then
    skip 'declare global is not supported'
  fi

  declare -g foo='bar'

  ! function::exists 'foo'
}

@test "a local variable is not a function and thus doesn't exist" {
  local foo='bar'

  ! function::exists 'foo'
}

@test "a readonly variable is not a function and thus doesn't exist" {
  local foo='bar'
  readonly foo

  ! function::exists 'foo'
}
