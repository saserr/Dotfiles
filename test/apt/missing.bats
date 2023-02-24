#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'apt::missing'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run apt::missing

  assert::wrong_usage 'apt::missing' 'package'
}

@test "succeeds if package is not installed" {
  load '../helpers/mocks/stub.bash'

  stub dpkg '-s foo : exit 1'

  apt::missing 'foo'

  unstub dpkg
}

@test "succeeds if status is not installed" {
  load '../helpers/mocks/stub.bash'

  stub dpkg '-s foo : echo "Status: not installed"'

  apt::missing 'foo'

  unstub dpkg
}

@test "fails if package is installed" {
  load '../helpers/mocks/stub.bash'

  stub dpkg '-s foo : echo "Status: install ok installed"'

  ! apt::missing 'foo'

  unstub dpkg
}
