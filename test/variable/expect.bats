#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'variable::expect'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run variable::expect

  assert::wrong_usage 'variable::expect' 'name' '...'
}

@test "succeeds if variable is declared and a non-empty value" {
  foo='foo'

  variable::expect 'foo'
}

@test "succeeds if variable is a non-empty indexed array with a non-empty first element" {
  foo=('foo')

  variable::expect 'foo'
}

@test "succeeds if variable is a non-empty indexed array with an empty first element" {
  foo=('')

  variable::expect 'foo'
}

@test "succeeds if variable is a non-empty associative array" {
  import 'bash::support::associative_array'
  if ! bash::support::associative_array; then
    skip 'associative arrays are not supported'
  fi

  declare -A foo
  foo['bar']='baz'

  variable::expect 'foo'
}

@test "fails if variable is declared and an empty value" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'text::ends_with'

  foo=''
  assert::exits variable::expect 'foo'

  ((status == 2))
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is an empty array" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'text::ends_with'

  foo=()
  assert::exits variable::expect 'foo'

  ((status == 2))
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is only declared" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'text::ends_with'

  declare foo
  assert::exits variable::expect 'foo'

  ((status == 2))
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is only declared as an indexed array" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'text::ends_with'

  declare -a foo
  assert::exits variable::expect 'foo'

  ((status == 2))
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is only declared as an associative array" {
  import 'bash::support::associative_array'
  if ! bash::support::associative_array; then
    skip 'associative arrays are not supported'
  fi

  load '../helpers/import.bash'
  import 'assert::exits'
  import 'text::ends_with'

  declare -A foo
  assert::exits variable::expect 'foo'

  ((status == 2))
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is only globally declared" {
  import 'bash::support::declare_global'
  if ! bash::support::declare_global; then
    skip 'declare global is not supported'
  fi

  load '../helpers/import.bash'
  import 'assert::exits'
  import 'text::ends_with'

  declare -g foo
  assert::exits variable::expect 'foo'

  ((status == 2))
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is only localy declared" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'text::ends_with'

  local foo
  assert::exits variable::expect 'foo'

  ((status == 2))
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is only readonly declared" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'text::ends_with'

  local foo
  readonly foo
  assert::exits variable::expect 'foo'

  ((status == 2))
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is not declared" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'text::ends_with'

  assert::exits variable::expect 'foo'

  ((status == 2))
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if any variable is not declared" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'text::ends_with'

  foo='bar'
  assert::exits variable::expect 'foo' 'baz'

  ((status == 2))
  text::ends_with "${lines[0]}" "expected nonempty variables: baz"
}

@test "fails if multiple variables are not declared" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'text::ends_with'

  assert::exits variable::expect 'foo' 'bar'

  ((status == 2))
  text::ends_with "${lines[0]}" "expected nonempty variables: foo bar"
}
