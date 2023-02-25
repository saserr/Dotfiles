#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'path::exists'

  test_path="$BATS_TEST_TMPDIR/foo"
  [[ ! -e "$test_path" ]] # $test_path does not exist
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run path::exists

  assert::wrong_usage 'path::exists' 'path'
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
  ln -s "$BATS_TEST_TMPDIR/bar" "$test_path"

  ! path::exists "$test_path"
}

@test "a path to a valid symlink that links to a directory exists" {
  mkdir "$BATS_TEST_TMPDIR/bar"
  ln -s "$BATS_TEST_TMPDIR/bar" "$test_path"

  path::exists "$test_path"
}

@test "a path to a valid symlink that links to a file exists" {
  touch "$BATS_TEST_TMPDIR/bar"
  ln -s "$BATS_TEST_TMPDIR/bar" "$test_path"

  path::exists "$test_path"
}
