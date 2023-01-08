#!/usr/bin/env bats

setup() {
  source function/string/repeat
}

@test "fails without arguments" {
  run string::repeat

  [ "$status" -eq 1 ]
  [ "$output" = 'Usage: string::repeat TIMES TEXT' ]
}

@test "fails with only one argument" {
  run string::repeat 2

  [ "$status" -eq 1 ]
  [ "$output" = 'Usage: string::repeat TIMES TEXT' ]
}

@test "repeat string -1 times" {
  [ "$(string::repeat -1 'foo')" = '' ]
}

@test "repeat string 0 times" {
  [ "$(string::repeat 0 'foo')" = '' ]
}

@test "repeat string 1 time" {
  [ "$(string::repeat 1 'foo')" = 'foo' ]
}

@test "repeat string 2 times" {
  [ "$(string::repeat 2 'foo')" = 'foofoo' ]
}

@test "repeat empty text" {
  [ "$(string::repeat 2 '')" = '' ]
}
