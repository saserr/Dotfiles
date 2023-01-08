#!/usr/bin/env bats

setup() {
  source function/path/exists.bash

  test_path="$BATS_TEST_TMPDIR/test"
  [ ! -e "$test_path" ] # $test_path does not exist
}

@test "fails without arguments" {
  run path::exists

  [ "$status" -eq 1 ]
  [ "$output" = 'Usage: path::exists PATH' ]
}

@test "a non-existant path doesn't exist" {
  ! path::exists "$test_path"
}

@test "a path to a directory exists" {
  mkdir "$test_path"

  path::exists "$test_path"
}

@test "a path to a file exists" {
  touch "$test_path"

  path::exists "$test_path"
}

@test "a path to a broken symlink doesn't exists" {
  ln -s "$BATS_TEST_TMPDIR/test2" "$test_path"

  ! path::exists "$test_path"
}

@test "a path to a valid symlink exists" {
  touch "$BATS_TEST_TMPDIR/test2"
  ln -s "$BATS_TEST_TMPDIR/test2" "$test_path"

  path::exists "$test_path"
}
