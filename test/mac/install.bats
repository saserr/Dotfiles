#!/usr/bin/env bats

setup() {
  load '../setup.bash'
  import 'mac::install'
}

@test "installs \$homebrew_formula using apt" {
  homebrew::install() { args=("$@"); }

  local recipe='foo'
  local homebrew_formula='bar'
  mac::install

  ((${#args[@]} == 1))
  [[ "${args[0]}" == 'bar' ]]
}

@test "installs \$program using apt" {
  homebrew::install() { args=("$@"); }

  local recipe='foo'
  local program='bar'
  mac::install

  ((${#args[@]} == 1))
  [[ "${args[0]}" == 'bar' ]]
}

@test "preferes \$homebrew_formula over \$program" {
  homebrew::install() { args=("$@"); }

  local recipe='foo'
  local homebrew_formula='bar'
  local program='baz'
  mac::install

  ((${#args[@]} == 1))
  [[ "${args[0]}" == 'bar' ]]
}

@test "fails if both \$homebrew_formula and \$program are missing" {
  import 'log'

  local recipe='foo'
  run mac::install

  ((status == 1))
  [[ "$output" == "$(log error 'mac' "don't know how to install foo")" ]]
}

@test "fails if \$recipe is missing" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'log'

  local homebrew_formula='foo'
  local program='bar'
  assert::exits mac::install

  ((status == 3))
  [[ "${lines[0]}" == "$(log error 'mac::install' "expected nonempty variables: recipe")" ]]
}
