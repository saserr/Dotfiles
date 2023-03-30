#!/usr/bin/env bats

setup() {
  load '../setup.bash'
  import 'prompt::question'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run prompt::question

  assert::wrong_usage 'prompt::question' 'tag' 'message'
}

@test "fails with only one argument" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run prompt::question 'foo'

  assert::wrong_usage 'prompt::question' 'tag' 'message'
}

@test "prompts the message" {
  run prompt::question 'foo' 'bar' <<<''

  [[ "$output" == "$(echo -e '\033[0;34m[foo]\033[0m bar')" ]]
}

@test "echos the answer" {
  import 'text::ends_with'

  run prompt::question 'foo' 'bar' <<<'baz'

  ((status == 0))
  text::ends_with "$output" 'baz'
}
