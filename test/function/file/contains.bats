#!/usr/bin/env bats

setup() {
  source function/file/contains
  test_file="$BATS_TEST_TMPDIR/test"
  [ ! -e "$test_file" ] # $test_file does not exist
}

@test "a non-existant file doesn't contain given string" {
  ! file::contains "$test_file" 'foo'
}

@test "an empty file doesn't contain given string" {
  touch "$test_file"

  ! file::contains "$test_file" 'foo'
}

@test "a file with just the given string" {
  echo 'foo' >"$test_file"

  file::contains "$test_file" 'foo'
}

@test "a file with the given string as part of a longer word" {
  echo 'foobar' >"$test_file"

  file::contains "$test_file" 'foo'
  file::contains "$test_file" 'bar'
}

@test "a file without the given string" {
  echo 'foo' >"$test_file"

  ! file::contains "$test_file" 'bar'
}
