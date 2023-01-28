#!/usr/bin/env bats

setup() {
  load ../helpers/assert/wrong_usage

  source src/setup/done.bash

  [ ! -e "$HOME/.setup/test" ] # $HOME/.setup/test does not exist
}

teardown() {
  rm -f "$HOME/.setup/test"
}

@test "fails without arguments" {
  run setup::done

  assert::wrong_usage 'setup::done' 'profile'
}

@test "creates a file under ~/.setup/ with value 1" {
  setup::done 'test'

  [ -f "$HOME/.setup/test" ] # $HOME/.setup/test is a file
  [ "$(cat "$HOME/.setup/test")" = '1' ]
}
