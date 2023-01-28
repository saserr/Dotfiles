#!/usr/bin/env bats

setup() {
  load ../helpers/assert/wrong_usage

  source src/text/starts_with.bash
}

@test "fails without arguments" {
  run text::starts_with

  assert::wrong_usage 'text::starts_with' 'text' 'prefix'
}

@test "fails with only one argument" {
  run text::starts_with 'foo'

  assert::wrong_usage 'text::starts_with' 'text' 'prefix'
}

@test "succeeds if text and prefix are equal" {
  text::starts_with 'foo' 'foo'
}

@test "succeeds if text starts with the given prefix" {
  text::starts_with 'foobar' 'foo'
}

@test "fails if text doesn't start with the given prefix" {
  ! text::starts_with 'foo' 'bar'
}

@test "fails if text is prefix of the given prefix" {
  ! text::starts_with 'fo' 'foo'
}

@test "succeeds if both text and prefix are empty" {
  text::starts_with '' ''
}

@test "fails if text is empty" {
  ! text::starts_with '' 'foo'
}

@test "succeeds if prefix is empty" {
  text::starts_with 'foo' ''
}