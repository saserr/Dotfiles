#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  load ../helpers/assert/wrong_usage

  import 'message::info'
  import 'text::contains'
}

@test "fails without arguments" {
  run message::info

  assert::wrong_usage 'message::info' 'tag' 'message' '...'
}

@test "fails with only one argument" {
  run message::info 'foo'

  assert::wrong_usage 'message::info' 'tag' 'message' '...'
}

@test "the output contains the tag" {
  run message::info 'foo' 'bar'

  [ "$status" -eq 0 ]
  text::contains "$output" 'foo'
}

@test "the output contains the message" {
  run message::info 'foo' 'bar'

  [ "$status" -eq 0 ]
  text::contains "$output" 'bar'
}

@test "the output contains the additional messages" {
  run message::info 'foo' 'bar' 'baz'

  [ "$status" -eq 0 ]
  [ "${lines[1]}" = '      baz' ]
}
