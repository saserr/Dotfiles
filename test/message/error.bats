#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  load ../helpers/assert/wrong_usage

  import 'message::error'
  import 'text::contains'
}

@test "fails without arguments" {
  run message::error

  assert::wrong_usage 'message::error' 'tag' 'message' '...'
}

@test "fails with only one argument" {
  run message::error 'foo'

  assert::wrong_usage 'message::error' 'tag' 'message' '...'
}

@test "the output contains the tag" {
  run message::error 'foo' 'bar'

  [ "$status" -eq 0 ]
  text::contains "$output" 'foo'
}

@test "the output contains the message" {
  run message::error 'foo' 'bar'

  [ "$status" -eq 0 ]
  text::contains "$output" 'bar'
}

@test "the output contains the additional messages" {
  run message::error 'foo' 'bar' 'baz'

  [ "$status" -eq 0 ]
  [ "${lines[1]}" = '      baz' ]
}
