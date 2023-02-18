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

  ((${#args[@]} == 2))
  [[ "${args[0]}" == 'foo' ]]
  [[ "${args[1]}" == 'bar' ]]
}

@test "installs \$program using apt" {
  apt::install() { args=("$@"); }

  local recipe='foo'
  local program='bar'

  debian::install

  ((${#args[@]} == 2))
  [[ "${args[0]}" == 'foo' ]]
  [[ "${args[1]}" == 'bar' ]]
}

@test "preferes \$apt_package over \$program" {
  apt::install() { args=("$@"); }

  local recipe='foo'
  local apt_package='bar'
  local program='baz'

  debian::install

  ((${#args[@]} == 2))
  [[ "${args[0]}" == 'foo' ]]
  [[ "${args[1]}" == 'bar' ]]
}

@test "fails if both \$apt_package and \$program are missing" {
  import 'log::error'

  local recipe='foo'

  run debian::install

  ((status == 1))
  [[ "$output" == "$(log::error 'debian' "don't know how to install foo")" ]]
}

@test "fails if \$recipe is missing" {
  import 'log::error'

  local apt_package='foo'
  local program='bar'

  run debian::install

  ((status == 2))
  [[ "${lines[0]}" == "$(log::error 'debian::install' "expected nonempty variables: recipe")" ]]
}
