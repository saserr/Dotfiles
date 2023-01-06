#!/usr/bin/env bats

setup() {
  source function/setup/done
  [ ! -e "$HOME/.setup/test" ] # $HOME/.setup/test does not exist
}

teardown() {
  rm -f "$HOME/.setup/test"
}

@test "creates a file under ~/.setup/ with value 1" {
  setup::done 'test'

  [ -f "$HOME/.setup/test" ] # $HOME/.setup/test is a file
  [ "$(cat "$HOME/.setup/test")" = '1' ]
}
