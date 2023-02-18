#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'homebrew::missing'
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage.bash

  run homebrew::missing

  assert::wrong_usage 'homebrew::missing' 'formula'
}

@test "checks if formula is listable" {
  brew() {
    args=("$@")
    return 1
  }

  homebrew::missing 'foo'

  ((${#args[@]} == 2))
  [[ "${args[0]}" == 'list' ]]
  [[ "${args[1]}" == 'foo' ]]
}

@test "succeeds if formula is not installed" {
  brew() { return 1; }

  run homebrew::missing 'foo'

  ((status == 0))
  [[ "$output" == '' ]]
}

@test "fails if formula is installed" {
  brew() { echo '/usr/bin/bar'; }

  run homebrew::missing 'foo'

  ((status != 0))
  [[ "$output" == '' ]]
}
