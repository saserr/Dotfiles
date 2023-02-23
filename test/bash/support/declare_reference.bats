#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'bash::support::declare_reference'
}

@test "succeeds if on bash version >= 4.3" {
  if (("${BASH_VERSINFO[0]}" < 4)) \
    || ((("${BASH_VERSINFO[0]}" == 4) && ("${BASH_VERSINFO[1]}" < 3))); then
    skip 'declare reference is not supported'
  fi

  bash::support::declare_reference
}

@test "fails if on bash version < 4.3" {
  if (("${BASH_VERSINFO[0]}" > 4)) \
    || ((("${BASH_VERSINFO[0]}" == 4) && ("${BASH_VERSINFO[1]}" >= 3))); then
    skip 'declare reference is supported'
  fi

  ! bash::support::declare_reference
}
