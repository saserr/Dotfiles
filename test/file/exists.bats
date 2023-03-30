#!/usr/bin/env bats

setup() {
  load '../setup.bash'
  import 'file::exists'

  test_file="$BATS_TEST_TMPDIR/foo"
  [[ ! -e "$test_file" ]] # $test_file does not exist
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run file::exists

  assert::wrong_usage 'file::exists' 'path'
}

@test "a non-existant path is not a file" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails file::exists "$test_file"
}

@test "a path to a directory is not a file" {
  load '../helpers/import.bash'
  import 'assert::fails'

  mkdir "$test_file"

  assert::fails file::exists "$test_file"
}

@test "a path to a file is a file" {
  touch "$test_file"

  file::exists "$test_file"
}

@test "a path to a broken symlink is not a file" {
  load '../helpers/import.bash'
  import 'assert::fails'

  ln -s "$BATS_TEST_TMPDIR/bar" "$test_file"

  assert::fails file::exists "$test_file"
}

@test "a path to a valid file symlink is a file" {
  touch "$BATS_TEST_TMPDIR/bar"
  ln -s "$BATS_TEST_TMPDIR/bar" "$test_file"

  file::exists "$test_file"
}

@test "a path to a valid directory symlink is not a file" {
  load '../helpers/import.bash'
  import 'assert::fails'

  mkdir "$BATS_TEST_TMPDIR/bar"
  ln -s "$BATS_TEST_TMPDIR/bar" "$test_file"

  assert::fails file::exists "$test_file"
}

@test "a path to a valid file through multiple symlinks is a file" {
  mkdir "$BATS_TEST_TMPDIR/bar"
  touch "$BATS_TEST_TMPDIR/bar/test"
  ln -s "$BATS_TEST_TMPDIR/bar" "$BATS_TEST_TMPDIR/baz"
  ln -s "$BATS_TEST_TMPDIR/baz/test" "$test_file"

  file::exists "$test_file"
}

@test "a path to a valid directory through multiple symlinks is not a file" {
  load '../helpers/import.bash'
  import 'assert::fails'

  mkdir "$BATS_TEST_TMPDIR/bar"
  ln -s "$BATS_TEST_TMPDIR/bar" "$BATS_TEST_TMPDIR/baz"
  ln -s "$BATS_TEST_TMPDIR/baz" "$test_file"

  assert::fails file::exists "$test_file"
}

@test "a path to a non-existent file through multiple symlinks is not a file" {
  load '../helpers/import.bash'
  import 'assert::fails'

  mkdir "$BATS_TEST_TMPDIR/bar"
  ln -s "$BATS_TEST_TMPDIR/bar" "$BATS_TEST_TMPDIR/baz"
  ln -s "$BATS_TEST_TMPDIR/baz/test" "$test_file"

  assert::fails file::exists "$test_file"
}
