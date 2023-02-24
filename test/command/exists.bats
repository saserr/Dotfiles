#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'command::exists'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

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
