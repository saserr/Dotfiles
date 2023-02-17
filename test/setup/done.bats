#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'setup::done'

  [ ! -e "$HOME/.setup/test" ] # $HOME/.setup/test does not exist
}

teardown() {
  rm -f "$HOME/.setup/test"
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

  run setup::done

  assert::wrong_usage 'setup::done' 'recipe'
}

@test "creates a file under ~/.setup/ with value 1" {
  setup::done 'test'

  [ -f "$HOME/.setup/test" ] # $HOME/.setup/test is a file
  [ "$(cat "$HOME/.setup/test")" = '1' ]
}
