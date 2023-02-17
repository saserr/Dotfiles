#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'text::repeat'
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

  run text::repeat

  assert::wrong_usage 'text::repeat' 'times' 'text'
}

@test "fails with only one argument" {
  load ../helpers/assert/wrong_usage

  run text::repeat 2

  assert::wrong_usage 'text::repeat' 'times' 'text'
}

@test "fails when first argument is not an integer" {
  import 'log'

  run text::repeat 'foo' 'bar'

  [ "${lines[0]}" = "$(log::error 'text::repeat' 'the first argument is not an integer')" ]
}

@test "repeat string -1 times" {
  [ "$(text::repeat -1 'foo')" = '' ]
}

@test "repeat string 0 times" {
  [ "$(text::repeat 0 'foo')" = '' ]
}

@test "repeat string 1 time" {
  [ "$(text::repeat 1 'foo')" = 'foo' ]
}

@test "repeat string 2 times" {
  [ "$(text::repeat 2 'foo')" = 'foofoo' ]
}

@test "repeat empty text" {
  [ "$(text::repeat 2 '')" = '' ]
}
