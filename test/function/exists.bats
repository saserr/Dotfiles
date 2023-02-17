#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'function::exists'
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

  run function::exists

  assert::wrong_usage 'function::exists' 'name'
}

@test "a function is a function" {
  function::exists 'function::exists'
}

@test "an unknown function is not a function" {
  ! function::exists 'dummy'
}

@test "a program on \$PATH is not a function" {
  ! function::exists 'env'
}

@test "a local variable is not a function" {
  local _local_value='foo'
  ! function::exists '_local_value'
}
