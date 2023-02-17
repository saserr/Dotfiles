#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'prompt::yes_or_no'
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

  run prompt::yes_or_no

  assert::wrong_usage 'prompt::yes_or_no' 'tag' 'question' '[default: Yes|No]'
}

@test "fails with only one argument" {
  load ../helpers/assert/wrong_usage

  run prompt::yes_or_no 'foo'

  assert::wrong_usage 'prompt::yes_or_no' 'tag' 'question' '[default: Yes|No]'
}

@test "fails with wrong default value" {
  import 'text::contains'
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' 'baz'

  [ "$status" -eq 2 ]
  text::contains "${lines[0]}" 'prompt::yes_or_no'
  text::contains "${lines[0]}" 'wrong default value'
  text::ends_with "${lines[1]}" 'actual: baz'
  text::ends_with "${lines[2]}" 'expected: Yes|No'
}

@test "prompts the question" {
  import 'text::contains'

  run prompt::yes_or_no 'foo' 'bar' <<<''

  text::contains "$output" 'foo'
  text::contains "$output" 'bar [y/n]'
}

@test "returns Yes if the answer is y" {
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' <<<'y'

  [ $status -eq 0 ]
  text::ends_with "$output" 'Yes'
}

@test "returns Yes if the answer is yes" {
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' <<<'yes'

  [ $status -eq 0 ]
  text::ends_with "$output" 'Yes'
}

@test "returns Yes if no answer is given and the default answer is Yes" {
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' 'Yes' <<<$'\n'

  [ $status -eq 0 ]
  text::ends_with "$output" 'Yes'
}

@test "returns No if the answer is n" {
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' <<<'n'

  [ $status -eq 0 ]
  text::ends_with "$output" 'No'
}

@test "returns No if the answer is no" {
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' <<<'no'

  [ $status -eq 0 ]
  text::ends_with "$output" 'No'
}

@test "returns No if no answer is given and the default answer is No" {
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' 'No' <<<$'\n'

  [ $status -eq 0 ]
  text::ends_with "$output" 'No'
}

@test "waits until a y/n answer is given" {
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' <<<$'a\nb\nc\ny'

  [ $status -eq 0 ]
  text::ends_with "$output" 'Yes'
}

@test "fails if no answer" {
  import 'text::contains'

  run prompt::yes_or_no 'foo' 'bar' <<<$'\n'

  [ $status -eq 1 ]
  ! text::contains "$output" 'Yes'
  ! text::contains "$output" 'No'
}

@test "fails if unknown answer" {
  import 'text::contains'

  run prompt::yes_or_no 'foo' 'bar' <<<'a'

  [ $status -eq 1 ]
  ! text::contains "$output" 'Yes'
  ! text::contains "$output" 'No'
}
