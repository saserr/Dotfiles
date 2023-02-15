#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  load ../helpers/assert/wrong_usage

  import 'log'
  import 'prompt::question'
  import 'text::ends_with'
}

@test "fails without arguments" {
  run prompt::question

  assert::wrong_usage 'prompt::question' 'tag' 'message'
}

@test "fails with only one argument" {
  run prompt::question 'foo'

  assert::wrong_usage 'prompt::question' 'tag' 'message'
}

@test "prompts the message" {
  run prompt::question 'foo' 'bar' <<<''

  [ "$output" = "$(log '0;34' 'foo' 'bar')" ]
}

@test "echos the answer" {
  run prompt::question 'foo' 'bar' <<<'baz'

  [ $status -eq 0 ]
  text::ends_with "$output" 'baz'
}
