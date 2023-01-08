#!/usr/bin/env bats

setup() {
  source function/value/empty
}

@test "fails without arguments" {
  run value::empty

  [ "$status" -eq 1 ]
  [ "$output" = 'Usage: value::empty VALUE' ]
}

@test "an empty value is empty" {
  value::empty ''
}

@test "a non-empty value is not empty" {
  ! value::empty 'foo'
}
