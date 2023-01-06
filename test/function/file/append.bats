#!/usr/bin/env bats

setup() {
  source function/file/append
  test_file="$BATS_TEST_TMPDIR/test"
  [ ! -e "$test_file" ] # $test_file does not exist
}

@test "append to an empty file" {
  touch "$test_file"

  file::append "$test_file" 'foo'

  [ "$(cat "$test_file")" = 'foo' ]
}

@test "append to a non-empty file" {
  echo 'foo' >"$test_file"

  file::append "$test_file" 'bar'

  [ "$(cat "$test_file")" = $'foo\nbar' ]
}

@test "append to a non-existent file" {
  file::append "$test_file" 'foo'

  [ "$(cat "$test_file")" = 'foo' ]
}
