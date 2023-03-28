#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'setup::done'

  XDG_STATE_HOME="$BATS_TEST_TMPDIR"
}

teardown() {
  rm -f "$HOME/.setup/test"
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run setup::done

  assert::wrong_usage 'setup::done' 'recipe'
}

@test "creates a file under ~/.setup/ with value 1" {
  import 'setup::directory'

  local directory
  directory="$(setup::directory)"

  setup::done 'test'

  [[ -f "$directory/test" ]]
  [[ "$(cat "$directory/test")" == '1' ]]
}
