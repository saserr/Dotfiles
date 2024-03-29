#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'text::ends_with'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run text::ends_with

  assert::wrong_usage 'text::ends_with' 'text' 'suffix'
}

@test "fails with only one argument" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run text::ends_with 'foo'

  assert::wrong_usage 'text::ends_with' 'text' 'suffix'
}

@test "succeeds if text and suffix are equal" {
  text::ends_with 'foo' 'foo'
}

@test "succeeds if text ends with the given suffix" {
  text::ends_with 'foobar' 'bar'
}

@test "fails if text doesn't end with the given suffix" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails text::ends_with 'foo' 'bar'
}

@test "fails if text is suffix of the given suffix" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails text::ends_with 'oo' 'foo'
}

@test "succeeds if both text and suffix are empty" {
  text::ends_with '' ''
}

@test "fails if text is empty" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails text::ends_with '' 'foo'
}

@test "succeeds if suffix is empty" {
  text::ends_with 'foo' ''
}
