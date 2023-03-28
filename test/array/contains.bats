#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'array::contains'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run array::contains

  assert::wrong_usage 'array::contains' 'value' '[element]' '...'
}

@test "fails if the array is empty" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails array::contains 'foo'
}

@test "fails if the array does not contain the value" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails array::contains 'foo' 'bar' 'baz'
}

@test "fails if the array contains the value at the start" {
  array::contains 'foo' 'foo' 'bar' 'baz'
}

@test "fails if the array contains the value in the middle" {
  array::contains 'foo' 'bar' 'foo' 'baz'
}

@test "fails if the array contains the value at the end" {
  array::contains 'foo' 'bar' 'baz' 'foo'
}
