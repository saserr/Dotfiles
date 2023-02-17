#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'apt::install'
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage.bash

  run apt::install

  assert::wrong_usage 'apt::install' '[name]' 'package'
}

@test "installs package if not installed" {
  load ../helpers/mocks/stub
  import 'log'

  stub dpkg '-s bar : exit 1'
  stub id '-u : echo 0'
  stub apt 'update : '
  stub apt ' -y install bar : '

  run apt::install 'foo' 'bar'

  unstub apt
  unstub id
  unstub dpkg
  [ "$status" -eq 0 ]
  [ "$output" = "$(log::info 'apt' 'installing foo ...')" ]
}

@test "installs package unless status is installed" {
  load ../helpers/mocks/stub
  import 'log'

  stub dpkg '-s bar : echo "Status: not installed"'
  stub id '-u : echo 0'
  stub apt 'update : '
  stub apt ' -y install bar : '

  run apt::install 'foo' 'bar'

  unstub apt
  unstub id
  unstub dpkg
  [ "$status" -eq 0 ]
  [ "$output" = "$(log::info 'apt' 'installing foo ...')" ]
}

@test "installs package with sudo if the current user is not root" {
  load ../helpers/mocks/stub
  import 'log'

  stub dpkg '-s bar : exit 1'
  stub id '-u : echo 1000'
  stub sudo 'bash -c \* : $3 '
  stub apt 'update : '
  stub apt ' -y install bar : '

  run apt::install 'foo' 'bar'

  unstub apt
  unstub sudo
  unstub id
  unstub dpkg
  [ "$status" -eq 0 ]
  [ "${lines[1]}" = "$(log::warn 'apt' 'running as non-root; sudo is needed ...')" ]
}

@test "succeeds if package is already installed" {
  load ../helpers/mocks/stub
  import 'log'

  stub dpkg '-s bar : echo "Status: install ok installed"'

  run apt::install 'foo' 'bar'

  unstub dpkg
  [ "$status" -eq 0 ]
  [ "$output" = "$(log::info 'apt' 'foo already installed ...')" ]
}

@test "fails if apt update fails" {
  load ../helpers/mocks/stub
  import 'log'

  stub dpkg '-s bar : exit 1'
  stub id '-u : echo 0'
  stub apt 'update : exit 1'

  run apt::install 'foo' 'bar'

  unstub apt
  unstub id
  unstub dpkg
  [ "$status" -eq 1 ]
  [ "${lines[1]}" = "$(log::error 'apt' 'failed to install foo')" ]
}

@test "fails if apt install fails" {
  load ../helpers/mocks/stub
  import 'log'

  stub dpkg '-s bar : exit 1'
  stub id '-u : echo 0'
  stub apt 'update : '
  stub apt ' -y install bar : exit 1'

  run apt::install 'foo' 'bar'

  unstub apt
  unstub id
  unstub dpkg
  [ "$status" -eq 1 ]
  [ "${lines[1]}" = "$(log::error 'apt' 'failed to install foo')" ]
}

@test "uses package as name when only one argument is passed" {
  load ../helpers/mocks/stub
  import 'log'

  stub dpkg '-s foo : exit 1'
  stub id '-u : echo 0'
  stub apt 'update : '
  stub apt ' -y install foo : '

  run apt::install 'foo'

  unstub apt
  unstub id
  unstub dpkg
  [ "$status" -eq 0 ]
  [ "$output" = "$(log::info 'apt' 'installing foo ...')" ]
}
