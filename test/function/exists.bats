#!/usr/bin/env bats

setup() {
  load '../setup.bash'
  import 'function::exists'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run function::exists

  assert::wrong_usage 'function::exists' 'name'
}

@test "a function is a function" {
  function::exists 'function::exists'
}

@test "an unknown function is not a function" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails function::exists 'foo'
}

@test "a program on \$PATH is not a function" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails function::exists 'env'
}

@test "a variable is not a function and thus doesn't exist" {
  load '../helpers/import.bash'
  import 'assert::fails'

  foo='bar'

  assert::fails function::exists 'foo'
}

@test "a global variable is not a function and thus doesn't exist" {
  import 'bash::support::declare_global'
  if ! bash::support::declare_global; then
    skip 'declare global is not supported'
  fi

  load '../helpers/import.bash'
  import 'assert::fails'

  declare -g foo='bar'

  assert::fails function::exists 'foo'
}

@test "a local variable is not a function and thus doesn't exist" {
  load '../helpers/import.bash'
  import 'assert::fails'

  local foo='bar'

  assert::fails function::exists 'foo'
}

@test "a readonly variable is not a function and thus doesn't exist" {
  load '../helpers/import.bash'
  import 'assert::fails'

  local foo='bar'
  readonly foo

  assert::fails function::exists 'foo'
}
