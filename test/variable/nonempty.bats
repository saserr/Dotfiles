#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'variable::nonempty'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run variable::nonempty

  assert::wrong_usage 'variable::nonempty' 'name'
}

@test "succeeds if variable is declared and a non-empty value" {
  foo='bar'

  variable::nonempty 'foo'
}

@test "succeeds if variable is a non-empty indexed array with a non-empty first element" {
  foo=('bar')

  variable::nonempty 'foo'
}

@test "succeeds if variable is a non-empty indexed array with an empty first element" {
  foo=('')

  variable::nonempty 'foo'
}

@test "succeeds if variable is a non-empty associative array" {
  import 'bash::support::associative_array'
  if ! bash::support::associative_array; then
    skip 'associative arrays are not supported'
  fi

  declare -A foo
  foo['bar']='baz'

  variable::nonempty 'foo'
}

@test "fails if variable is declared and an empty value" {
  load '../helpers/import.bash'
  import 'assert::fails'

  foo=''

  assert::fails variable::nonempty 'foo'
}

@test "fails if variable is an empty array" {
  load '../helpers/import.bash'
  import 'assert::fails'

  foo=()

  assert::fails variable::nonempty 'foo'
}

@test "fails if variable is only declared" {
  load '../helpers/import.bash'
  import 'assert::fails'

  declare foo

  assert::fails variable::nonempty 'foo'
}

@test "fails if variable is only declared as an indexed array" {
  load '../helpers/import.bash'
  import 'assert::fails'

  declare -a foo

  assert::fails variable::nonempty 'foo'
}

@test "fails if variable is only declared as an associative array" {
  import 'bash::support::associative_array'
  if ! bash::support::associative_array; then
    skip 'associative arrays are not supported'
  fi

  load '../helpers/import.bash'
  import 'assert::fails'

  declare -A foo

  assert::fails variable::nonempty 'foo'
}

@test "fails if variable is only globally declared" {
  import 'bash::support::declare_global'
  if ! bash::support::declare_global; then
    skip 'declare global is not supported'
  fi

  load '../helpers/import.bash'
  import 'assert::fails'

  declare -g foo

  assert::fails variable::nonempty 'foo'
}

@test "fails if variable is only localy declared" {
  load '../helpers/import.bash'
  import 'assert::fails'

  local foo

  assert::fails variable::nonempty 'foo'
}

@test "fails if variable is only readonly declared" {
  load '../helpers/import.bash'
  import 'assert::fails'

  local foo
  readonly foo

  assert::fails variable::nonempty 'foo'
}

@test "fails if variable is not declared" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails variable::nonempty 'foo'
}
