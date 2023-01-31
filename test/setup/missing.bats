#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  load ../helpers/assert/wrong_usage

  import 'setup::missing'
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
