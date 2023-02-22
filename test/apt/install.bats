#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'apt::install'

  # return that package is not installed
  apt::missing() { return 0; }
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage.bash

  run apt::install

  assert::wrong_usage 'apt::install' '[name]' 'package' '...'
}

@test "checks if package is installed" {
  apt::missing() {
    args=("$@")
    return 1
  }

  apt::install 'foo' 'bar'

  [[ "${args[0]}" == 'bar' ]]
}

@test "installs package if not installed" {
  load ../helpers/mocks/stub
  import 'log::trace'

  stub id '-u : echo 0'
  stub apt 'update : '
  stub apt ' -y install bar : '

  run apt::install 'foo' 'bar'

  unstub apt
  unstub id
  ((status == 0))
  [[ "$output" == "$(log::trace 'apt' 'installing foo')" ]]
}

@test "installs multiple packages" {
  load ../helpers/mocks/stub
  import 'log::trace'

  stub id '-u : echo 0'
  stub apt 'update : '
  stub apt ' -y install bar baz : '

  run apt::install 'foo' 'bar' 'baz'

  unstub apt
  unstub id
  ((status == 0))
  [[ "$output" == "$(log::trace 'apt' 'installing foo')" ]]
}

@test "installs only missing packages" {
  load ../helpers/mocks/stub
  import 'log::trace'

  apt::missing() { [[ "$1" != 'bar' ]]; }

  stub id '-u : echo 0'
  stub apt 'update : '
  stub apt ' -y install baz : '

  run apt::install 'foo' 'bar' 'baz'

  unstub apt
  unstub id
  ((status == 0))
  [[ "$output" == "$(log::trace 'apt' 'installing foo')" ]]
}

@test "installs package with sudo if the current user is not root" {
  load ../helpers/mocks/stub
  import 'log::warn'

  stub id '-u : echo 1000'
  stub sudo '/usr/bin/env bash -c \* : /usr/bin/env bash -c "$4" '
  stub apt 'update : '
  stub apt ' -y install bar : '

  run apt::install 'foo' 'bar'

  unstub apt
  unstub sudo
  unstub id
  ((status == 0))
  [[ "${lines[1]}" == "$(log::warn 'apt' 'running as non-root; sudo is needed')" ]]
}

@test "succeeds if package is already installed" {
  import 'log::trace'

  apt::missing() { return 1; }

  run apt::install 'foo' 'bar'

  ((status == 0))
  [[ "$output" == "$(log::trace 'apt' 'foo already installed')" ]]
}

@test "fails if apt update fails" {
  load ../helpers/mocks/stub
  import 'log::error'

  stub id '-u : echo 0'
  stub apt 'update : exit 1'

  run apt::install 'foo' 'bar'

  unstub apt
  unstub id
  ((status == 1))
  [[ "${lines[1]}" == "$(log::error 'apt' 'failed to install foo')" ]]
}

@test "fails if apt install fails" {
  load ../helpers/mocks/stub
  import 'log::error'

  stub id '-u : echo 0'
  stub apt 'update : '
  stub apt ' -y install bar : exit 1'

  run apt::install 'foo' 'bar'

  unstub apt
  unstub id
  ((status == 1))
  [[ "${lines[1]}" == "$(log::error 'apt' 'failed to install foo')" ]]
}

@test "uses package as name when only one argument is passed" {
  load ../helpers/mocks/stub
  import 'log::trace'

  stub id '-u : echo 0'
  stub apt 'update : '
  stub apt ' -y install foo : '

  run apt::install 'foo'

  unstub apt
  unstub id
  ((status == 0))
  [[ "$output" == "$(log::trace 'apt' 'installing foo')" ]]
}
