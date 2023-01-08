#!/usr/bin/env bats

setup() {
  source function/file/empty.bash

  test_file="$BATS_TEST_TMPDIR/test"
  [ ! -e "$test_file" ] # $test_file does not exist
}

@test "fails without arguments" {
  run file::empty

  [ "$status" -eq 1 ]
  [ "$output" = 'Usage: file::empty FILE' ]
}

@test "a non-existant file is empty" {
  file::empty "$test_file"
}

@test "an empty file is empty" {
  touch "$test_file"

  file::empty "$test_file"
}

@test "a non-empty file is not empty" {
  echo 'foo' >"$test_file"

  ! file::empty "$test_file"
}
