#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'setup::missing'

  XDG_STATE_HOME="$BATS_TEST_TMPDIR"
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run setup::missing

  assert::wrong_usage 'setup::missing' 'recipe'
}

@test "is missing if recipe has not been set up" {
  setup::missing 'test'
}

@test "is not missing if recipe has been set up" {
  load '../helpers/import.bash'
  import 'assert::fails'
  import 'setup::directory'

  local directory
  directory="$(setup::directory)"
  mkdir -p "$directory"
  touch "$directory/test"

  assert::fails setup::missing 'test'
}
