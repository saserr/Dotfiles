#!/usr/bin/env bats

setup() {
  load ../helpers/mocks/stub

  source src/homebrew/install.bash
}

@test "fails without arguments" {
  run homebrew::install

  [ "$status" -eq 1 ]
  [ "$output" = 'Usage: homebrew::install NAME FORMULA' ]
}

@test "fails with only one argument" {
  run homebrew::install 'foo'

  [ "$status" -eq 1 ]
  [ "$output" = 'Usage: homebrew::install NAME FORMULA' ]
}

@test "installs formula if not installed" {
  stub brew 'list bar : exit 1'
  stub brew 'update : '
  stub brew 'install bar : '

  run homebrew::install 'foo' 'bar'

  unstub brew
  [ "$status" -eq 0 ]
  [ "$output" = '[homebrew] installing foo ...' ]
}

@test "succeeds if formula is already installed" {
  stub brew 'list bar : echo "/usr/bin/bar"; exit 0 '

  run homebrew::install 'foo' 'bar'

  unstub brew
  [ "$status" -eq 0 ]
  [ "$output" = '[homebrew] foo already installed ...' ]
}

@test "fails if brew update fails" {
  stub brew 'list bar : exit 1'
  stub brew 'update : exit 1'

  run homebrew::install 'foo' 'bar'

  unstub brew
  [ "$status" -eq 1 ]
  [ "${lines[1]}" = '[homebrew] failed to install foo' ]
}

@test "fails if brew install fails" {
  stub brew 'list bar : exit 1'
  stub brew 'update : '
  stub brew 'install bar : exit 1'

  run homebrew::install 'foo' 'bar'

  unstub brew
  [ "$status" -eq 1 ]
  [ "${lines[1]}" = '[homebrew] failed to install foo' ]
}
