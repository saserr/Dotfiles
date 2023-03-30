#!/usr/bin/env bats

setup() {
  load '../setup.bash'
  import 'prompt::yes_or_no'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run prompt::yes_or_no

  assert::wrong_usage 'prompt::yes_or_no' 'tag' 'question' '[default: Yes|No]'
}

@test "fails with only one argument" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run prompt::yes_or_no 'foo'

  assert::wrong_usage 'prompt::yes_or_no' 'tag' 'question' '[default: Yes|No]'
}

@test "fails with wrong default value" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'text::contains'
  import 'text::ends_with'

  assert::exits prompt::yes_or_no 'foo' 'bar' 'baz'

  ((status == 3))
  text::contains "${lines[0]}" '[prompt::yes_or_no]'
  text::ends_with "${lines[0]}" 'wrong default value'
  text::ends_with "${lines[1]}" 'actual: baz'
  text::ends_with "${lines[2]}" 'expected: Yes|No'
}

@test "prompts the question and shows the choice with no default answer" {
  import 'text::contains'

  run prompt::yes_or_no 'foo' 'bar' <<<''

  ((${#lines[@]} == 1))
  text::contains "${lines[0]}" '[foo]'
  text::contains "${lines[0]}" 'bar [y/n]'
}

@test "prompts the question and shows the choice with the default 'Yes' answer" {
  import 'text::contains'

  run prompt::yes_or_no 'foo' 'bar' 'Yes' <<<''

  ((${#lines[@]} == 1))
  text::contains "${lines[0]}" '[foo]'
  text::contains "${lines[0]}" 'bar [Y/n]'
}

@test "prompts the question and shows the choice with the default 'No' answer" {
  import 'text::contains'

  run prompt::yes_or_no 'foo' 'bar' 'No' <<<''

  ((${#lines[@]} == 1))
  text::contains "${lines[0]}" '[foo]'
  text::contains "${lines[0]}" 'bar [y/N]'
}

@test "returns Yes if the answer is y" {
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' <<<'y'

  ((status == 0))
  text::ends_with "$output" 'Yes'
}

@test "returns Yes if the answer is yes" {
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' <<<'yes'

  ((status == 0))
  text::ends_with "$output" 'Yes'
}

@test "returns Yes if no answer is given and the default answer is Yes" {
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' 'Yes' <<<$'\n'

  ((status == 0))
  text::ends_with "$output" 'Yes'
}

@test "returns No if the answer is n" {
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' <<<'n'

  ((status == 0))
  text::ends_with "$output" 'No'
}

@test "returns No if the answer is no" {
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' <<<'no'

  ((status == 0))
  text::ends_with "$output" 'No'
}

@test "returns No if no answer is given and the default answer is No" {
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' 'No' <<<$'\n'

  ((status == 0))
  text::ends_with "$output" 'No'
}

@test "waits until a y/n answer is given" {
  import 'text::ends_with'

  run prompt::yes_or_no 'foo' 'bar' <<<$'a\nb\nc\ny'

  ((status == 0))
  text::ends_with "$output" 'Yes'
}

@test "fails if no answer" {
  load '../helpers/import.bash'
  import 'assert::fails'
  import 'text::contains'

  run prompt::yes_or_no 'foo' 'bar' <<<$'\n'

  ((status == 1))
  assert::fails text::contains "$output" 'Yes'
  assert::fails text::contains "$output" 'No'
}

@test "fails if unknown answer" {
  load '../helpers/import.bash'
  import 'assert::fails'
  import 'text::contains'

  run prompt::yes_or_no 'foo' 'bar' <<<'a'

  ((status == 1))
  assert::fails text::contains "$output" 'Yes'
  assert::fails text::contains "$output" 'No'
}
