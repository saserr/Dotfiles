#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'homebrew::install'

  # return that any formula is not installed
  homebrew::missing() { return 0; }
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run homebrew::install

  assert::wrong_usage 'homebrew::install' 'formula' '...'
}

@test "fails if homebrew is not installed" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'log'

  command::exists() { [[ "$1" != 'brew' ]]; }

  assert::exits homebrew::install 'foo'

  ((status == 1))
  [[ "$output" == "$(log error 'homebrew' 'is not installed')" ]]
}

@test "checks if formula is installed" {
  load '../helpers/mocks/stub.bash'

  homebrew::missing() {
    args=("$@")
    return 1
  }
  stub brew

  homebrew::install 'foo'

  unstub brew
  ((${#args[@]} == 1))
  [[ "${args[0]}" == 'foo' ]]
}

@test "installs formula if not installed" {
  load '../helpers/mocks/stub.bash'
  import 'log'

  stub brew \
    'update : ' \
    'install foo : '

  run homebrew::install 'foo'

  unstub brew
  ((status == 0))
  [[ "$output" == "$(log trace 'homebrew' 'installing: foo')" ]]
}

@test "installs multiple formulas" {
  load '../helpers/mocks/stub.bash'
  import 'log'

  stub brew \
    'update : ' \
    'install foo bar baz : '

  run homebrew::install 'foo' 'bar' 'baz'

  unstub brew
  ((status == 0))
  [[ "$output" == "$(log trace 'homebrew' 'installing: foo bar baz')" ]]
}

@test "installs only missing formulas" {
  load '../helpers/mocks/stub.bash'
  import 'log'

  homebrew::missing() { [[ "$1" != 'bar' ]]; }
  stub brew \
    'update : ' \
    'install foo baz : '

  run homebrew::install 'foo' 'bar' 'baz'

  unstub brew
  ((status == 0))
  [[ "${lines[0]}" == "$(log trace 'homebrew' 'already installed: bar')" ]]
  [[ "${lines[1]}" == "$(log trace 'homebrew' 'installing: foo baz')" ]]
}

@test "succeeds if formula is already installed" {
  load '../helpers/mocks/stub.bash'
  import 'log'

  homebrew::missing() { return 1; }
  stub brew

  run homebrew::install 'foo'

  unstub brew
  ((status == 0))
  [[ "$output" == "$(log trace 'homebrew' 'already installed: foo')" ]]
}

@test "fails if brew update fails" {
  load '../helpers/mocks/stub.bash'
  import 'log'

  stub brew 'update : exit 1'

  run homebrew::install 'foo'

  unstub brew
  ((status == 1))
  [[ "${lines[1]}" == "$(log error 'homebrew' 'installation failed')" ]]
}

@test "fails if brew install fails" {
  load '../helpers/mocks/stub.bash'
  import 'log'

  stub brew \
    'update : ' \
    'install foo : exit 1'

  run homebrew::install 'foo'

  unstub brew
  ((status == 1))
  [[ "${lines[1]}" == "$(log error 'homebrew' 'installation failed')" ]]
}
