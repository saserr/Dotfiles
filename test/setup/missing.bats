#!/usr/bin/env bats

setup() {
  load ../helpers/assert/wrong_usage

  source src/setup/missing.bash
}

@test "fails without arguments" {
  run setup::missing

  assert::wrong_usage 'setup::missing' 'profile'
}

@test "is missing if profile has not been set up" {
  setup::missing 'test'
}

@test "is not missing if profile has been set up" {
  mkdir -p ~/.setup/
  touch ~/.setup/test

  ! setup::missing 'test'

  rm ~/.setup/test
}
