#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'text::contains'
}

@test "fails without arguments" {
  load '../helpers/assert/wrong_usage.bash'

  run text::contains

  assert::wrong_usage 'text::contains' 'text' 'infix'
}

@test "fails with only one argument" {
  load '../helpers/assert/wrong_usage.bash'

  run text::contains 'foo'

  assert::wrong_usage 'text::contains' 'text' 'infix'
}

@test "succeeds if text and infix are equal" {
  text::contains 'foo' 'foo'
}

@test "succeeds if text starts with the given infix" {
  text::contains 'foobar' 'foo'
}

@test "succeeds if text ends with the given infix" {
  text::contains 'foobar' 'bar'
}

@test "succeeds if text contains the given infix" {
  text::contains 'foobarbaz' 'bar'
}

@test "fails if text doesn't contain the given infix" {
  ! text::contains 'foo' 'bar'
}

@test "fails if text is prefix of the given infix" {
  ! text::contains 'fo' 'foo'
}

@test "fails if text is suffix of the given infix" {
  ! text::contains 'oo' 'foo'
}

@test "fails if text is infix of the given infix" {
  ! text::contains 'o' 'foo'
}

@test "succeeds if both text and infix are empty" {
  text::contains '' ''
}

@test "fails if text is empty" {
  ! text::contains '' 'foo'
}

@test "succeeds if infix is empty" {
  text::contains 'foo' ''
}
