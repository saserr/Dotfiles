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

@test "creates a file with value 1" {
  import 'file::exists'
  import 'setup::file'

  local file
  file="$(setup::file 'foo')"

  setup::done 'foo'

  file::exists "$file"
  [[ "$(cat "$file")" == '1' ]]
}

@test "fails if setup::file fails" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'log'

  setup::file() { return 1; }

  run setup::done 'foo'

  ((status == 1))
  ((${#lines[@]} == 1))
  [[ "${lines[0]}" == "$(capture::stderr log error 'foo' 'failed to save the state file')" ]]
}

@test "fails if it can't determine the parent directory of setup::file" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'log'

  path::parent() { return 1; }

  run setup::done 'foo'

  ((status == 1))
  ((${#lines[@]} == 1))
  [[ "${lines[0]}" == "$(capture::stderr log error 'foo' 'failed to save the state file')" ]]
}

@test "fails if can't create the parent directory for setup::file" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'log'

  mkdir() { return 1; }

  run setup::done 'foo'

  ((status == 1))
  ((${#lines[@]} == 1))
  [[ "${lines[0]}" == "$(capture::stderr log error 'foo' 'failed to save the state file')" ]]
}
