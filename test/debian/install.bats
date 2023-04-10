#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'debian::install'
}

@test "installs \$apt_package using apt" {
  apt::install() { args=("$@"); }

  local recipe='foo'
  local apt_package='bar'
  debian::install

  ((${#args[@]} == 1))
  [[ "${args[0]}" == 'bar' ]]
}

@test "installs \$program using apt" {
  apt::install() { args=("$@"); }

  local recipe='foo'
  local program='bar'
  debian::install

  ((${#args[@]} == 1))
  [[ "${args[0]}" == 'bar' ]]
}

@test "preferes \$apt_package over \$program" {
  apt::install() { args=("$@"); }

  local recipe='foo'
  local apt_package='bar'
  local program='baz'
  debian::install

  ((${#args[@]} == 1))
  [[ "${args[0]}" == 'bar' ]]
}

@test "fails if both \$apt_package and \$program are missing" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'log'

  local recipe='foo'
  run debian::install

  ((status == 1))
  [[ "$output" == "$(capture::stderr log error 'debian' "don't know how to install foo")" ]]
}

@test "fails if \$recipe is missing" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'capture::stderr'
  import 'log'

  local apt_package='foo'
  local program='bar'
  assert::exits debian::install

  ((status == 3))
  [[ "${lines[0]}" == "$(capture::stderr log error 'debian::install' "expected nonempty variables: recipe")" ]]
}
