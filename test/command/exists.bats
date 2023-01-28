#!/usr/bin/env bats

setup() {
  source 'src/import.bash'
  load ../helpers/assert/wrong_usage

  import 'command::exists'
}

@test "fails without arguments" {
  run command::exists

  assert::wrong_usage 'command::exists' 'name'
}

@test "a program on \$PATH exists" {
  command::exists 'env'
}

@test "a function exists" {
  command::exists 'command::exists'
}

@test "an unknown command doesn't exist" {
  ! command::exists 'dummy'
}

@test "a local variable doesn't exists" {
  local _local_value='foo'
  ! command::exists '_local_value'
}
