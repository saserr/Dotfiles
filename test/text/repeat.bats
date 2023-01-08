#!/usr/bin/env bats

setup() {
  source src/text/repeat.bash
}

@test "fails without arguments" {
  run text::repeat

  [ "$status" -eq 1 ]
  [ "$output" = 'Usage: text::repeat TIMES TEXT' ]
}

@test "fails with only one argument" {
  run text::repeat 2

  [ "$status" -eq 1 ]
  [ "$output" = 'Usage: text::repeat TIMES TEXT' ]
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
