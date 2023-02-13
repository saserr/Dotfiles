#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  load ../helpers/assert/wrong_usage

  import 'message::warning'
  import 'text::contains'
}

@test "fails without arguments" {
  run message::warning

  assert::wrong_usage 'message::warning' 'tag' 'message' '...'
}

@test "fails with only one argument" {
  run message::warning 'foo'

  assert::wrong_usage 'message::warning' 'tag' 'message' '...'
}

@test "the output contains the tag" {
  run message::warning 'foo' 'bar'

  [ "$status" -eq 0 ]
  text::contains "$output" 'foo'
}

@test "the output contains the message" {
  run message::warning 'foo' 'bar'

  [ "$status" -eq 0 ]
  text::contains "$output" 'bar'
}

@test "the output contains the additional messages" {
  run message::warning 'foo' 'bar' 'baz'

  [ "$status" -eq 0 ]
  [ "${lines[1]}" = '      baz' ]
}
