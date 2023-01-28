#!/usr/bin/env bats

setup() {
  load ../helpers/assert/wrong_usage

  source src/text/repeat.bash
}

@test "fails without arguments" {
  run text::repeat

  assert::wrong_usage 'text::repeat' 'times' 'text'
}

@test "fails with only one argument" {
  run text::repeat 2

  assert::wrong_usage 'text::repeat' 'times' 'text'
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
