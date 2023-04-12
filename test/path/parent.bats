#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'path::parent'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run path::parent

  assert::wrong_usage 'path::parent' 'file'
}

@test "returns the parent directory of the given file" {
  local foo="$BATS_TEST_TMPDIR/foo"
  touch "$foo"

  [[ "$(path::parent "$foo")" == "$BATS_TEST_TMPDIR" ]]
}

@test "returns the parent directory of the given directory" {
  local foo="$BATS_TEST_TMPDIR/foo"
  local bar="$foo/bar"
  mkdir -p "$bar"

  [[ "$(path::parent "$bar")" == "$foo" ]]
}

@test "returns the parent directory even when the file doesn't exist" {
  local foo="$BATS_TEST_TMPDIR/foo"

  [[ "$(path::parent "$foo")" == "$BATS_TEST_TMPDIR" ]]
}

@test "returns the parent directory even when the parent directory does not exist" {
  local foo="$BATS_TEST_TMPDIR/foo"
  local bar="$foo/bar"

  [[ "$(path::parent "$bar")" == "$foo" ]]
}

@test "returns the parent directory even when the file is a symlink" {
  local foo="$BATS_TEST_TMPDIR/foo"
  touch "$foo"
  local bar="$BATS_TEST_TMPDIR/bar"
  mkdir "$bar"
  local baz="$bar/baz"
  ln -s "$foo" "$baz"

  [[ "$(path::parent "$baz")" == "$bar" ]]
}

@test "returns the parent directory even when the parent directory is a symlink" {
  local foo="$BATS_TEST_TMPDIR/foo"
  mkdir "$foo"
  local bar="$BATS_TEST_TMPDIR/bar"
  ln -s "$foo" "$bar"
  local baz="$bar/baz"
  touch "$baz"

  [[ "$(path::parent "$baz")" == "$bar" ]]
}

@test "fails if unable to determine the parent directory" {
  load '../helpers/import.bash'
  load '../helpers/mocks/stub.bash'
  import 'capture::stderr'
  import 'log'

  local foo="$BATS_TEST_TMPDIR/foo"
  touch "$foo"

  stub dirname "-- $foo : exit 1"

  run path::parent "$foo"

  unstub dirname
  ((status == 1))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == "$(capture::stderr log error 'path::parent' 'unable to determine the parent directory')" ]]
  [[ "${lines[1]}" == "               file: $foo" ]]
}
