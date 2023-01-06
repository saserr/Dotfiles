#!/usr/bin/env bats

setup() {
  source function/string/repeat
}

@test "repeat string 0 times" {
  skip 'broken'
  [ "$(string::repeat 0 'foo')" = '' ]
}

@test "repeat string 1 time" {
  [ "$(string::repeat 1 'foo')" = 'foo' ]
}

@test "repeat string 2 times" {
  [ "$(string::repeat 2 'foo')" = 'foofoo' ]
}

@test "repeat empty string" {
  [ "$(string::repeat 2 '')" = '' ]
}
