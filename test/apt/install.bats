#!/usr/bin/env bats

setup() {
  load ../helpers/assert/wrong_usage
  load ../helpers/mocks/stub

  source src/apt/install.bash
}

@test "fails without arguments" {
  run apt::install

  assert::wrong_usage 'apt::install' 'name' 'package'
}

@test "fails with only one argument" {
  run apt::install 'foo'

  [ "$status" -eq 2 ]
  text::contains "${lines[0]}" 'apt::install'
  text::contains "${lines[0]}" 'wrong number of arguments'
  text::ends_with "${lines[3]}" 'arguments: name package'
}

@test "installs package if not installed" {
  stub dpkg '-s bar : exit 1'
  stub id '-u : echo 0'
  stub apt 'update : '
  stub apt ' -y install bar : '

  run apt::install 'foo' 'bar'

  unstub apt
  unstub id
  unstub dpkg
  [ "$status" -eq 0 ]
  [ "$output" = '[apt] installing foo ...' ]
}

@test "installs package unless status is installed" {
  stub dpkg '-s bar : echo "Status: not installed"'
  stub id '-u : echo 0'
  stub apt 'update : '
  stub apt ' -y install bar : '

  run apt::install 'foo' 'bar'

  unstub apt
  unstub id
  unstub dpkg
  [ "$status" -eq 0 ]
  [ "$output" = '[apt] installing foo ...' ]
}

@test "installs package with sudo if the current user is not root" {
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
  [ "${lines[1]}" = '[apt] running as non-root; sudo is needed ...' ]
}

@test "succeeds if package is already installed" {
  stub dpkg '-s bar : echo "Status: install ok installed"'

  run apt::install 'foo' 'bar'

  unstub dpkg
  [ "$status" -eq 0 ]
  [ "$output" = '[apt] foo already installed ...' ]
}

@test "fails if apt update fails" {
  stub dpkg '-s bar : exit 1'
  stub id '-u : echo 0'
  stub apt 'update : exit 1'

  run apt::install 'foo' 'bar'

  unstub apt
  unstub id
  unstub dpkg
  [ "$status" -eq 1 ]
  [ "${lines[1]}" = '[apt] failed to install foo' ]
}

@test "fails if apt install fails" {
  stub dpkg '-s bar : exit 1'
  stub id '-u : echo 0'
  stub apt 'update : '
  stub apt ' -y install bar : exit 1'

  run apt::install 'foo' 'bar'

  unstub apt
  unstub id
  unstub dpkg
  [ "$status" -eq 1 ]
  [ "${lines[1]}" = '[apt] failed to install foo' ]
}
