#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'value::empty'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run value::empty

  assert::wrong_usage 'value::empty' 'value'
}

@test "an empty value is empty" {
  value::empty ''
}

@test "a non-empty value is not empty" {
  ! value::empty 'foo'
}
