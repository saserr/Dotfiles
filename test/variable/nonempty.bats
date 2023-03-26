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
  import 'bash::support::associative_array'
  import 'bash::support::declare_reference'

  foo=('bar')

  variable::nonempty 'foo'

  # succeeds even when the support for 'declare -n' is ignored
  if bash::support::declare_reference; then
    bash::support::declare_reference() { return 1; }
    variable::nonempty 'foo'
  fi

  # succeeds even when the support for associative arrays is ignored
  if bash::support::associative_array; then
    bash::support::associative_array() { return 1; }
    variable::nonempty 'foo'
  fi
}

@test "succeeds if variable is a non-empty indexed array with an empty first element" {
  import 'bash::support::associative_array'
  import 'bash::support::declare_reference'

  foo=('')

  variable::nonempty 'foo'

  # succeeds even when the support for 'declare -n' is ignored
  if bash::support::declare_reference; then
    bash::support::declare_reference() { return 1; }
    variable::nonempty 'foo'
  fi

  # succeeds even when the support for associative arrays is ignored
  if bash::support::associative_array; then
    bash::support::associative_array() { return 1; }
    variable::nonempty 'foo'
  fi
}

@test "succeeds if variable is a non-empty associative array" {
  import 'bash::support::associative_array'
  if ! bash::support::associative_array; then
    skip 'associative arrays are not supported'
  fi

  import 'bash::support::declare_reference'

  declare -A foo
  foo['bar']='baz'

  variable::nonempty 'foo'

  # succeeds even when the support for 'declare -n' is ignored
  if bash::support::declare_reference; then
    bash::support::declare_reference() { return 1; }
    variable::nonempty 'foo'
  fi
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
  import 'bash::support::associative_array'
  import 'bash::support::declare_reference'

  foo=()

  assert::fails variable::nonempty 'foo'

  # fails even when the support for 'declare -n' is ignored
  if bash::support::declare_reference; then
    bash::support::declare_reference() { return 1; }
    assert::fails variable::nonempty 'foo'
  fi

  # fails even when the support for associative arrays is ignored
  if bash::support::associative_array; then
    bash::support::associative_array() { return 1; }
    assert::fails variable::nonempty 'foo'
  fi
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
  import 'bash::support::associative_array'
  import 'bash::support::declare_reference'

  declare -a foo

  assert::fails variable::nonempty 'foo'

  # fails even when the support for 'declare -n' is ignored
  if bash::support::declare_reference; then
    bash::support::declare_reference() { return 1; }
    assert::fails variable::nonempty 'foo'
  fi

  # fails even when the support for associative arrays is ignored
  if bash::support::associative_array; then
    bash::support::associative_array() { return 1; }
    assert::fails variable::nonempty 'foo'
  fi
}

@test "fails if variable is only declared as an associative array" {
  import 'bash::support::associative_array'
  if ! bash::support::associative_array; then
    skip 'associative arrays are not supported'
  fi

  load '../helpers/import.bash'
  import 'assert::fails'
  import 'bash::support::declare_reference'

  declare -A foo

  assert::fails variable::nonempty 'foo'

  # fails even when the support for 'declare -n' is ignored
  if bash::support::declare_reference; then
    bash::support::declare_reference() { return 1; }
    assert::fails variable::nonempty 'foo'
  fi
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
