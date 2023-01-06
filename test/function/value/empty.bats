#!/usr/bin/env bats

setup() {
  source function/value/empty
}

@test "an empty value is empty" {
  value::empty ''
}

@test "a non-empty value is not empty" {
  ! value::empty 'foo'
}
