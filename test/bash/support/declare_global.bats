#!/usr/bin/env bats

setup() {
  load '../../setup.bash'
  import 'bash::support::declare_global'
}

@test "succeeds if on bash version >= 4.2" {
  if ((${BASH_VERSINFO[0]} < 4)) \
    || (((${BASH_VERSINFO[0]} == 4) && (${BASH_VERSINFO[1]} < 2))); then
    skip 'declare global is not supported'
  fi

  bash::support::declare_global
}

@test "fails if on bash version < 4.2" {
  if ((${BASH_VERSINFO[0]} > 4)) \
    || (((${BASH_VERSINFO[0]} == 4) && (${BASH_VERSINFO[1]} >= 2))); then
    skip 'declare global is supported'
  fi

  load '../../helpers/import.bash'
  import 'assert::fails'

  assert::fails bash::support::declare_global
}
