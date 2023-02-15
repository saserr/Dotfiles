#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  load ../helpers/assert/wrong_usage

  import 'log'
  import 'prompt::yes_or_no'
  import 'text::contains'
  import 'text::ends_with'
  import 'text::starts_with'
}

@test "fails without arguments" {
  run prompt::yes_or_no

  assert::wrong_usage 'prompt::yes_or_no' 'tag' 'question' '[default: Yes|No]'
}

@test "fails with only one argument" {
  run prompt::yes_or_no 'foo'

  assert::wrong_usage 'prompt::yes_or_no' 'tag' 'question' '[default: Yes|No]'
}

@test "fails with wrong default value" {
  run prompt::yes_or_no 'foo' 'bar' 'baz'

  [ "$status" -eq 2 ]
  text::contains "${lines[0]}" 'prompt::yes_or_no'
  text::contains "${lines[0]}" 'wrong default value'
  text::ends_with "${lines[1]}" 'actual: baz'
  text::ends_with "${lines[2]}" 'expected: Yes|No'
}

@test "prompts the question" {
  run prompt::yes_or_no 'foo' 'bar' <<<''

  text::contains "$output" 'foo'
  text::contains "$output" 'bar [y/n]'
}

@test "returns Yes if the answer is y" {
  run prompt::yes_or_no 'foo' 'bar' <<<'y'

  [ $status -eq 0 ]
  text::ends_with "$output" 'Yes'
}

@test "returns Yes if the answer is yes" {
  run prompt::yes_or_no 'foo' 'bar' <<<'yes'

  [ $status -eq 0 ]
  text::ends_with "$output" 'Yes'
}

@test "returns Yes if no answer is given and the default answer is Yes" {
  run prompt::yes_or_no 'foo' 'bar' 'Yes' <<<$'\n'

  [ $status -eq 0 ]
  text::ends_with "$output" 'Yes'
}

@test "returns No if the answer is n" {
  run prompt::yes_or_no 'foo' 'bar' <<<'n'

  [ $status -eq 0 ]
  text::ends_with "$output" 'No'
}

@test "returns No if the answer is no" {
  run prompt::yes_or_no 'foo' 'bar' <<<'no'

  [ $status -eq 0 ]
  text::ends_with "$output" 'No'
}

@test "returns No if no answer is given and the default answer is No" {
  run prompt::yes_or_no 'foo' 'bar' 'No' <<<$'\n'

  [ $status -eq 0 ]
  text::ends_with "$output" 'No'
}

@test "waits until a y/n answer is given" {
  run prompt::yes_or_no 'foo' 'bar' <<<$'a\nb\nc\ny'

  [ $status -eq 0 ]
  text::ends_with "$output" 'Yes'
}

@test "fails if no answer" {
  run prompt::yes_or_no 'foo' 'bar' <<<$'\n'

  [ $status -eq 1 ]
  ! text::contains "$output" 'Yes'
  ! text::contains "$output" 'No'
}

@test "fails if unknown answer" {
  run prompt::yes_or_no 'foo' 'bar' <<<'a'

  [ $status -eq 1 ]
  ! text::contains "$output" 'Yes'
  ! text::contains "$output" 'No'
}
