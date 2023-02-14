#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  load ../helpers/assert/wrong_usage

  import 'setup::missing'
}

@test "fails without arguments" {
  run setup::missing

  assert::wrong_usage 'setup::missing' 'recipe'
}

@test "is missing if recipe has not been set up" {
  setup::missing 'test'
}

@test "is not missing if recipe has been set up" {
  mkdir -p ~/.setup/
  touch ~/.setup/test

  ! setup::missing 'test'

  rm ~/.setup/test
}
