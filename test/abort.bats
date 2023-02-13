#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  load helpers/assert/wrong_usage

  import 'abort'
  import 'text::contains'
}

@test "fails without arguments" {
  run abort

  assert::wrong_usage 'abort' 'tag' 'message' '...'
}

@test "fails with only one argument" {
  run abort 'foo'

  assert::wrong_usage 'abort' 'tag' 'message' '...'
}

@test "the output contains the tag" {
  run abort 'foo' 'bar'

  [ "$status" -eq 2 ]
  text::contains "$output" 'foo'
}

@test "the output contains the message" {
  run abort 'foo' 'bar'

  [ "$status" -eq 2 ]
  text::contains "$output" 'bar'
}

@test "the output contains the additional messages" {
  run abort 'foo' 'bar' 'baz'

  [ "$status" -eq 2 ]
  [ "${lines[1]}" = '      baz' ]
}

@test "exits" {
  fail() {
    echo 'foo'
    abort 'bar' 'test' 2>/dev/null
    echo 'baz'
  }

  run fail

  [ "$output" = 'foo' ]
}
