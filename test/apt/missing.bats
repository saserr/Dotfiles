#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  load ../helpers/assert/wrong_usage.bash
  load ../helpers/mocks/stub

  import 'apt::missing'
}

@test "fails without arguments" {
  run apt::missing

  assert::wrong_usage 'apt::missing' 'package'
}

@test "succeeds if package is not installed" {
  stub dpkg '-s foo : exit 1'

  apt::missing 'foo'

  unstub dpkg
}

@test "succeeds if status is not installed" {
  stub dpkg '-s foo : echo "Status: not installed"'

  apt::missing 'foo'

  unstub dpkg
}

@test "fails if package is installed" {
  stub dpkg '-s foo : echo "Status: install ok installed"'

  ! apt::missing 'foo'

  unstub dpkg
}
