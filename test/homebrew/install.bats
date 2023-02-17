#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'homebrew::install'

  # return that formula is not installed
  homebrew::missing() { return 0; }
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

  run homebrew::install

  assert::wrong_usage 'homebrew::install' '[name]' 'formula' '...'
}

@test "checks if formula is installed" {
  homebrew::missing() {
    args=("$@")
    return 1
  }

  homebrew::install 'foo' 'bar'

  [ "${args[0]}" = 'bar' ]
}

@test "installs formula if not installed" {
  load ../helpers/mocks/stub
  import 'log'

  stub brew 'update : '
  stub brew 'install bar : '

  run homebrew::install 'foo' 'bar'

  unstub brew
  [ "$status" -eq 0 ]
  [ "$output" = "$(log::info 'homebrew' 'installing foo ...')" ]
}

@test "installs multiple formulas" {
  load ../helpers/mocks/stub

  stub brew 'update : '
  stub brew 'install bar baz : '

  run homebrew::install 'foo' 'bar' 'baz'

  unstub brew
  [ "$status" -eq 0 ]
  [ "$output" = "$(log::info 'homebrew' 'installing foo ...')" ]
}

@test "installs only missing formulas" {
  load ../helpers/mocks/stub

  homebrew::missing() { [ $1 != 'bar' ]; }

  stub brew 'update : '
  stub brew 'install baz : '

  run homebrew::install 'foo' 'bar' 'baz'

  unstub brew
  [ "$status" -eq 0 ]
  [ "$output" = "$(log::info 'homebrew' 'installing foo ...')" ]
}

@test "succeeds if formula is already installed" {
  import 'log'

  homebrew::missing() { return 1; }

  run homebrew::install 'foo' 'bar'

  [ "$status" -eq 0 ]
  [ "$output" = "$(log::info 'homebrew' 'foo already installed ...')" ]
}

@test "fails if brew update fails" {
  load ../helpers/mocks/stub
  import 'log'

  stub brew 'update : exit 1'

  run homebrew::install 'foo' 'bar'

  unstub brew
  [ "$status" -eq 1 ]
  [ "${lines[1]}" = "$(log::error 'homebrew' 'failed to install foo')" ]
}

@test "fails if brew install fails" {
  load ../helpers/mocks/stub
  import 'log'

  stub brew 'update : '
  stub brew 'install bar : exit 1'

  run homebrew::install 'foo' 'bar'

  unstub brew
  [ "$status" -eq 1 ]
  [ "${lines[1]}" = "$(log::error 'homebrew' 'failed to install foo')" ]
}

@test "uses formula as name when only one argument is passed" {
  load ../helpers/mocks/stub
  import 'log'

  stub brew 'update : '
  stub brew 'install foo : '

  run homebrew::install 'foo'

  unstub brew
  [ "$status" -eq 0 ]
  [ "$output" = "$(log::info 'homebrew' 'installing foo ...')" ]
}
