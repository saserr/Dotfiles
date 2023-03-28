#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'apt::install'

  # return that any package is not installed
  apt::missing() { return 0; }
  # return that the current user is root
  platform::is_root() { return 0; }
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run apt::install

  assert::wrong_usage 'apt::install' 'package' '...'
}

@test "checks if package is installed" {
  apt::missing() {
    args=("$@")
    return 1
  }

  apt::install 'foo'

  ((${#args[@]} == 1))
  [[ "${args[0]}" == 'foo' ]]
}

@test "installs package if not installed" {
  load '../helpers/mocks/stub.bash'
  import 'log'

  stub apt \
    'update : ' \
    '-y install foo : '

  run apt::install 'foo'

  unstub apt
  ((status == 0))
  [[ "$output" == "$(log trace 'apt' 'installing: foo')" ]]
}

@test "installs multiple packages" {
  load '../helpers/mocks/stub.bash'
  import 'log'

  stub apt \
    'update : ' \
    '-y install foo bar baz : '

  run apt::install 'foo' 'bar' 'baz'

  unstub apt
  ((status == 0))
  [[ "$output" == "$(log trace 'apt' 'installing: foo bar baz')" ]]
}

@test "installs only missing packages" {
  load '../helpers/mocks/stub.bash'
  import 'log'

  apt::missing() { [[ "$1" != 'bar' ]]; }

  stub apt \
    'update : ' \
    '-y install foo baz : '

  run apt::install 'foo' 'bar' 'baz'

  unstub apt
  ((status == 0))
  [[ "${lines[0]}" == "$(log trace 'apt' 'already installed: bar')" ]]
  [[ "${lines[1]}" == "$(log trace 'apt' 'installing: foo baz')" ]]
}

@test "installs package with sudo if the current user is not root" {
  load '../helpers/mocks/stub.bash'
  import 'log'

  platform::is_root() { return 1; }
  stub sudo '/usr/bin/env bash -c \* : /usr/bin/env bash -c "$4" '
  stub apt \
    'update : ' \
    '-y install foo : '

  run apt::install 'foo'

  unstub apt
  unstub sudo
  ((status == 0))
  [[ "${lines[1]}" == "$(log warn 'apt' 'running as non-root; sudo is needed')" ]]
}

@test "succeeds if package is already installed" {
  import 'log'

  apt::missing() { return 1; }

  run apt::install 'foo'

  ((status == 0))
  [[ "$output" == "$(log trace 'apt' 'already installed: foo')" ]]
}

@test "fails if apt update fails" {
  load '../helpers/mocks/stub.bash'
  import 'log'

  stub apt 'update : exit 1'

  run apt::install 'foo'

  unstub apt
  ((status == 1))
  [[ "${lines[1]}" == "$(log error 'apt' 'installation failed')" ]]
}

@test "fails if apt install fails" {
  load '../helpers/mocks/stub.bash'
  import 'log'

  stub apt \
    'update : ' \
    '-y install foo : exit 1'

  run apt::install 'foo'

  unstub apt
  ((status == 1))
  [[ "${lines[1]}" == "$(log error 'apt' 'installation failed')" ]]
}
