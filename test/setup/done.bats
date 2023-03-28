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
  import 'setup::file'

  local file
  file="$(setup::file 'foo')"

  setup::done 'foo'

  [[ -f "$file" ]]
  [[ "$(cat "$file")" == '1' ]]
}

@test "fails if setup::file fails" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'log'

  setup::file() { return 1; }

  assert::exits setup::done 'foo'

  ((status == 3))
  [[ "${lines[0]}" == "$(log error 'setup::done' 'failed to get the path to the foo'\''s state file')" ]]
}
