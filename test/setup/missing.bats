#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'setup::missing'
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

  run setup::missing

  assert::wrong_usage 'setup::missing' 'recipe'
}

@test "is missing if recipe has not been set up" {
  setup::missing 'test'
}

@test "is not missing if recipe has been set up" {
  mkdir -p "$HOME/.setup/"
  touch "$HOME/.setup/test"

  ! setup::missing 'test'

  rm "$HOME/.setup/test"
}
