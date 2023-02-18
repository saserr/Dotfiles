#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'mac::install'
}

@test "installs \$homebrew_formula using apt" {
  homebrew::install() { args=("$@"); }

  local recipe='foo'
  local homebrew_formula='bar'

  mac::install

  ((${#args[@]} == 2))
  [ "${args[0]}" = 'foo' ]
  [ "${args[1]}" = 'bar' ]
}

@test "installs \$program using apt" {
  homebrew::install() { args=("$@"); }

  local recipe='foo'
  local program='bar'

  mac::install

  ((${#args[@]} == 2))
  [ "${args[0]}" = 'foo' ]
  [ "${args[1]}" = 'bar' ]
}

@test "preferes \$homebrew_formula over \$program" {
  homebrew::install() { args=("$@"); }

  local recipe='foo'
  local homebrew_formula='bar'
  local program='baz'

  mac::install

  ((${#args[@]} == 2))
  [ "${args[0]}" = 'foo' ]
  [ "${args[1]}" = 'bar' ]
}

@test "fails if both \$homebrew_formula and \$program are missing" {
  import 'log::error'

  local recipe='foo'

  run mac::install

  ((status == 1))
  [ "$output" = "$(log::error 'mac' "don't know how to install foo")" ]
}

@test "fails if \$recipe is missing" {
  import 'log::error'

  local homebrew_formula='foo'
  local program='bar'

  run mac::install

  ((status == 2))
  [ "${lines[0]}" = "$(log::error 'mac::install' "expected nonempty variables: recipe")" ]
}
