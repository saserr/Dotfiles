#!/usr/bin/env bats

setup() {
  load ../helpers/assert/wrong_usage

  source src/value/empty.bash
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
