#!/usr/bin/env bats

setup() {
  source function/file/contains.bash

  test_file="$BATS_TEST_TMPDIR/test"
  [ ! -e "$test_file" ] # $test_file does not exist
}

@test "fails without arguments" {
  run file::contains

  [ "$status" -eq 1 ]
  [ "$output" = 'Usage: file::contains FILE TEXT' ]
}

@test "fails with only one argument" {
  run file::contains "$test_file"

  [ "$status" -eq 1 ]
  [ "$output" = 'Usage: file::contains FILE TEXT' ]
}

@test "a non-existant file doesn't contain given text" {
  ! file::contains "$test_file" 'foo'
}

@test "an empty file doesn't contain given text" {
  touch "$test_file"

  ! file::contains "$test_file" 'foo'
}

@test "a file with just the given text" {
  echo 'foo' >"$test_file"

  file::contains "$test_file" 'foo'
}

@test "a file with the given text as part of a longer word" {
  echo 'foobar' >"$test_file"

  file::contains "$test_file" 'foo'
  file::contains "$test_file" 'bar'
}

@test "a file without the given text" {
  echo 'foo' >"$test_file"

  ! file::contains "$test_file" 'bar'
}
