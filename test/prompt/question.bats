#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'prompt::question'
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

  run prompt::question

  assert::wrong_usage 'prompt::question' 'tag' 'message'
}

@test "fails with only one argument" {
  load ../helpers/assert/wrong_usage

  run prompt::question 'foo'

  assert::wrong_usage 'prompt::question' 'tag' 'message'
}

@test "prompts the message" {
  import 'log'

  run prompt::question 'foo' 'bar' <<<''

  [[ "$output" == "$(log '0;34' 'foo' 'bar')" ]]
}

@test "echos the answer" {
  import 'text::ends_with'

  run prompt::question 'foo' 'bar' <<<'baz'

  ((status == 0))
  text::ends_with "$output" 'baz'
}
