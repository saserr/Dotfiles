#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'abort'
}

@test "fails without arguments" {
  load 'helpers/import.bash'
  import 'assert::wrong_usage'

  run abort

  assert::wrong_usage 'abort' 'tag' 'message' '...'
}

@test "fails with only one argument" {
  load 'helpers/import.bash'
  import 'assert::wrong_usage'

  run abort 'foo'

  assert::wrong_usage 'abort' 'tag' 'message' '...'
}

@test "the output contains the tag" {
  load 'helpers/import.bash'
  import 'assert::exits'
  import 'text::contains'

  assert::exits abort 'foo' 'bar'

  ((status == 2))
  text::contains "$output" 'foo'
}

@test "the output contains the message" {
  load 'helpers/import.bash'
  import 'assert::exits'
  import 'text::contains'

  assert::exits abort 'foo' 'bar'

  ((status == 2))
  text::contains "$output" 'bar'
}

@test "the output contains the additional messages" {
  load 'helpers/import.bash'
  import 'assert::exits'

  assert::exits abort 'foo' 'bar' 'baz'

  ((status == 2))
  [[ "${lines[1]}" == '      baz' ]]
}
