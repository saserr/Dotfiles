#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'bash::support::associative_array'
}

@test "succeeds if on bash version >= 4" {
  if ((${BASH_VERSINFO[0]} < 4)); then
    skip 'associative arrays are not supported'
  fi

  bash::support::associative_array
}

@test "fails if on bash version < 4" {
  if ((${BASH_VERSINFO[0]} >= 4)); then
    skip 'associative arrays are supported'
  fi

  load '../../helpers/import.bash'
  import 'assert::fails'

  assert::fails bash::support::associative_array
}
