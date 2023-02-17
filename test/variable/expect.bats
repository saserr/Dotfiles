#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'variable::expect'
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

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
  declare -A foo
  foo['bar']='baz'

  variable::expect 'foo'
}

@test "fails if variable is declared and an empty value" {
  import 'text::ends_with'

  foo=''

  run variable::expect 'foo'

  [ "$status" -eq 2 ]
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is an empty array" {
  import 'text::ends_with'

  foo=()

  run variable::expect 'foo'
  [ "$status" -eq 2 ]
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is only declared" {
  import 'text::ends_with'

  declare -g foo

  run variable::expect 'foo'

  [ "$status" -eq 2 ]
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is only declared as an indexed array" {
  import 'text::ends_with'

  declare -ga foo

  run variable::expect 'foo'

  [ "$status" -eq 2 ]
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is only declared as an associative array" {
  import 'text::ends_with'

  declare -gA foo

  run variable::expect 'foo'

  [ "$status" -eq 2 ]
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is only localy declared" {
  import 'text::ends_with'

  local foo

  run variable::expect 'foo'

  [ "$status" -eq 2 ]
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is only readonly declared" {
  import 'text::ends_with'

  readonly foo

  run variable::expect 'foo'

  [ "$status" -eq 2 ]
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if variable is not declared" {
  import 'text::ends_with'

  run variable::expect 'foo'

  [ "$status" -eq 2 ]
  text::ends_with "${lines[0]}" "expected nonempty variables: foo"
}

@test "fails if any variable is not declared" {
  import 'text::ends_with'

  foo='bar'

  run variable::expect 'foo' 'baz'

  [ "$status" -eq 2 ]
  text::ends_with "${lines[0]}" "expected nonempty variables: baz"
}

@test "fails if multiple variables are not declared" {
  import 'text::ends_with'

  run variable::expect 'foo' 'bar'

  [ "$status" -eq 2 ]
  text::ends_with "${lines[0]}" "expected nonempty variables: foo bar"
}

@test "exits when it fails" {
  fail() {
    echo 'foo'
    variable::expect 'bar' 2>/dev/null
    echo 'baz'
  }

  run fail

  [ "$output" = 'foo' ]
}
