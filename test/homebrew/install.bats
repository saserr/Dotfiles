#!/usr/bin/env bats

setup() {
  source 'src/import.bash'
  load ../helpers/assert/wrong_usage
  load ../helpers/mocks/stub

  import 'homebrew::install'
}

@test "fails without arguments" {
  run homebrew::install

  assert::wrong_usage 'homebrew::install' '[name]' 'formula'
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

@test "uses package as name when only one argument is passed" {
  stub brew 'list foo : exit 1'
  stub brew 'update : '
  stub brew 'install foo : '

  run homebrew::install 'foo'

  unstub brew
  [ "$status" -eq 0 ]
  [ "$output" = '[homebrew] installing foo ...' ]
}
