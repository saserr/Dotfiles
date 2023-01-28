#!/usr/bin/env bats

setup() {
  source 'src/import.bash'
  load ../helpers/assert/wrong_usage.bash
  load ../helpers/mocks/stub

  import 'apt::install'
}

@test "fails without arguments" {
  run apt::install

  assert::wrong_usage 'apt::install' '[name]' 'package'
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

@test "uses package as name when only one argument is passed" {
  stub dpkg '-s foo : exit 1'
  stub id '-u : echo 0'
  stub apt 'update : '
  stub apt ' -y install foo : '

  run apt::install 'foo'

  unstub apt
  unstub id
  unstub dpkg
  [ "$status" -eq 0 ]
  [ "$output" = '[apt] installing foo ...' ]
}
