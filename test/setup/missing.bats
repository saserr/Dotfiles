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
  setup::missing 'foo'
}

@test "is not missing if recipe has been set up" {
  load '../helpers/import.bash'
  import 'assert::fails'
  import 'path::parent'
  import 'setup::file'

  local file
  file="$(setup::file 'foo')"
  mkdir -p "$(path::parent "$file")"
  touch "$file"

  assert::fails setup::missing 'foo'
}

@test "fails if setup::file fails" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'capture::stderr'
  import 'log'

  setup::file() { return 1; }

  assert::exits setup::missing 'foo'

  ((status == 3))
  [[ "${lines[0]}" == "$(capture::stderr log error 'foo' 'the state file is missing')" ]]
}
