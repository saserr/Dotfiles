#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'file::exists'

  test_file="$BATS_TEST_TMPDIR/test"
  [[ ! -e "$test_file" ]] # $test_file does not exist
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

  run file::exists

  assert::wrong_usage 'file::exists' 'path'
}

@test "a non-existant path is not a file" {
  ! file::exists "$test_file"
}

@test "a path to a directory is not a file" {
  mkdir "$test_file"

  ! file::exists "$test_file"
}

@test "a path to a file is a file" {
  touch "$test_file"

  file::exists "$test_file"
}

@test "a path to a broken symlink is not a file" {
  ln -s "$BATS_TEST_TMPDIR/test2" "$test_file"

  ! file::exists "$test_file"
}

@test "a path to a valid file symlink is a file" {
  touch "$BATS_TEST_TMPDIR/test2"
  ln -s "$BATS_TEST_TMPDIR/test2" "$test_file"

  file::exists "$test_file"
}

@test "a path to a valid directory symlink is not a file" {
  mkdir "$BATS_TEST_TMPDIR/test2"
  ln -s "$BATS_TEST_TMPDIR/test2" "$test_file"

  ! file::exists "$test_file"
}
