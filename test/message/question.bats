#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  load ../helpers/assert/wrong_usage

  import 'message::question'
  import 'text::contains'
}

@test "fails without arguments" {
  run message::question

  assert::wrong_usage 'message::question' 'tag' 'message' '...'
}

@test "fails with only one argument" {
  run message::question 'foo'

  assert::wrong_usage 'message::question' 'tag' 'message' '...'
}

@test "the output contains the tag" {
  run message::question 'foo' 'bar'

  [ "$status" -eq 0 ]
  text::contains "$output" 'foo'
}

@test "the output contains the message" {
  run message::question 'foo' 'bar'

  [ "$status" -eq 0 ]
  text::contains "$output" 'bar'
}

@test "the output contains the additional messages" {
  run message::question 'foo' 'bar' 'baz'

  [ "$status" -eq 0 ]
  [ "${lines[1]}" = '      baz' ]
}
