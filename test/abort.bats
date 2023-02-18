#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'abort'
}

@test "fails without arguments" {
  load helpers/assert/wrong_usage

  run abort

  assert::wrong_usage 'abort' 'tag' 'message' '...'
}

@test "fails with only one argument" {
  load helpers/assert/wrong_usage

  run abort 'foo'

  assert::wrong_usage 'abort' 'tag' 'message' '...'
}

@test "the output contains the tag" {
  import 'text::contains'

  run abort 'foo' 'bar'

  ((status == 2))
  text::contains "$output" 'foo'
}

@test "the output contains the message" {
  import 'text::contains'

  run abort 'foo' 'bar'

  ((status == 2))
  text::contains "$output" 'bar'
}

@test "the output contains the additional messages" {
  run abort 'foo' 'bar' 'baz'

  ((status == 2))
  [[ "${lines[1]}" == '      baz' ]]
}

@test "exits" {
  fail() {
    echo 'foo'
    abort 'bar' 'test' 2>/dev/null
    echo 'baz'
  }

  run fail

  ((status == 2))
  [[ "$output" == 'foo' ]]
}
