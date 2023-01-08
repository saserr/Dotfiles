#!/usr/bin/env bats

setup() {
  source src/value/empty.bash
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
