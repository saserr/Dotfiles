#!/usr/bin/env bats

setup() {
  load ../helpers/assert/wrong_usage

  source src/file/empty.bash

  test_file="$BATS_TEST_TMPDIR/test"
  [ ! -e "$test_file" ] # $test_file does not exist
}

@test "fails without arguments" {
  run file::empty

  assert::wrong_usage 'file::empty' 'file'
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
