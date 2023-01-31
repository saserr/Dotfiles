#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  load ../helpers/assert/wrong_usage

  import 'value::empty'
}

@test "fails without arguments" {
  run value::empty

  assert::wrong_usage 'value::empty' 'value'
}

@test "an empty value is empty" {
  value::empty ''
}

@test "a non-empty value is not empty" {
  ! value::empty 'foo'
}
