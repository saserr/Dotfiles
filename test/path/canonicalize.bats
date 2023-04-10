#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'path::canonicalize'

  # get the physical directory of BATS_TEST_TMPDIR; this fixes the issue on the
  # mac platform where the /var directory is a symlink to /private/var
  BATS_TEST_TMPDIR="$(cd -P -- "$BATS_TEST_TMPDIR" && pwd -P)" || return
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run path::canonicalize

  assert::wrong_usage 'path::canonicalize' 'path'
}

@test "returns the same path even if the path does not exist" {
  local foo="$BATS_TEST_TMPDIR/foo"

  run path::canonicalize "$foo"

  ((status == 0))
  [[ "$output" == "$foo" ]]
}

@test "returns the provided path if the path is a file" {
  local foo="$BATS_TEST_TMPDIR/foo"
  touch "$foo"

  run path::canonicalize "$foo"

  ((status == 0))
  [[ "$output" == "$foo" ]]
}

@test "returns the provided path if the path is a directory" {
  local foo="$BATS_TEST_TMPDIR/foo"
  mkdir "$foo"

  run path::canonicalize "$foo"

  ((status == 0))
  [[ "$output" == "$foo" ]]
}

@test "returns the value of the symbolic link when it points to a file" {
  local foo="$BATS_TEST_TMPDIR/foo"
  touch "$foo"
  local bar="$BATS_TEST_TMPDIR/bar"
  ln -s "$foo" "$bar"

  run path::canonicalize "$bar"

  ((status == 0))
  [[ "$output" == "$foo" ]]
}

@test "returns the value of the symbolic link when it points to a directory" {
  local foo="$BATS_TEST_TMPDIR/foo"
  mkdir "$foo"
  local bar="$BATS_TEST_TMPDIR/bar"
  ln -s "$foo" "$bar"

  run path::canonicalize "$bar"

  ((status == 0))
  [[ "$output" == "$foo" ]]
}

@test "returns the value of the symbolic link even if it points to a non-existant path" {
  local foo="$BATS_TEST_TMPDIR/foo"
  local bar="$BATS_TEST_TMPDIR/bar"
  ln -s "$foo" "$bar"

  run path::canonicalize "$bar"

  ((status == 0))
  [[ "$output" == "$foo" ]]
}

@test "follows symbolic links until a file is found" {
  local foo="$BATS_TEST_TMPDIR/foo"
  touch "$foo"
  local bar="$BATS_TEST_TMPDIR/bar"
  ln -s "$foo" "$bar"
  local baz="$BATS_TEST_TMPDIR/baz"
  ln -s "$bar" "$baz"

  run path::canonicalize "$baz"

  ((status == 0))
  [[ "$output" == "$foo" ]]
}

@test "follows symbolic links until a directory is found" {
  local foo="$BATS_TEST_TMPDIR/foo"
  mkdir "$foo"
  local bar="$BATS_TEST_TMPDIR/bar"
  ln -s "$foo" "$bar"
  local baz="$BATS_TEST_TMPDIR/baz"
  ln -s "$bar" "$baz"

  run path::canonicalize "$baz"

  ((status == 0))
  [[ "$output" == "$foo" ]]
}

@test "follows any symbolic link on the path" {
  local foo="$BATS_TEST_TMPDIR/foo"
  mkdir "$foo"
  touch "$foo/baz"
  local bar="$BATS_TEST_TMPDIR/bar"
  ln -s "$foo" "$bar"

  run path::canonicalize "$bar/baz"

  ((status == 0))
  [[ "$output" == "$foo/baz" ]]
}

@test "follows symbolic links across files and directories" {
  local foo="$BATS_TEST_TMPDIR/foo"
  mkdir "$foo"
  touch "$foo/test1"
  local bar="$BATS_TEST_TMPDIR/bar"
  mkdir "$bar"
  ln -s "$foo/test1" "$bar/test2"
  local baz="$BATS_TEST_TMPDIR/baz"
  ln -s "$bar" "$baz"

  run path::canonicalize "$baz/test2"

  ((status == 0))
  [[ "$output" == "$foo/test1" ]]
}

@test "fails if a symbolic link on a path points to a non-existant path" {
  local foo="$BATS_TEST_TMPDIR/foo"
  local bar="$BATS_TEST_TMPDIR/bar"
  ln -s "$foo" "$bar"

  run path::canonicalize "$bar/baz"

  ((status == 1))
  [[ "$output" == '' ]]
}

@test "fails if greadlink fails on the mac platform" {
  import 'platform::name'
  if [[ "$(platform::name)" != 'mac' ]]; then
    skip 'running on a non-mac platform'
  fi

  load '../helpers/mocks/stub.bash'
  load '../helpers/import.bash'
  import 'assert::fails'

  stub greadlink 'exit 1'

  assert::fails path::canonicalize "$bar"

  unstub greadlink
  [[ "$output" == '' ]]
}

@test "fails if greadlink is missing on mac platform" {
  import 'platform::name'
  if [[ "$(platform::name)" != 'mac' ]]; then
    skip 'running on a non-mac platform'
  fi

  load '../helpers/import.bash'
  import 'assert::exits'
  import 'capture::stderr'
  import 'log'

  command::exists() { [[ "$1" != 'greadlink' ]]; }

  assert::exits path::canonicalize 'foo'

  ((status == 2))
  [[ "$output" == "$(capture::stderr log error 'mac' 'greadlink is not installed')" ]]
}

@test "fails if readlink fails on any other platform" {
  import 'platform::name'
  if [[ "$(platform::name)" == 'mac' ]]; then
    skip 'running on the mac platform'
  fi

  load '../helpers/mocks/stub.bash'
  load '../helpers/import.bash'
  import 'assert::fails'

  stub readlink 'exit 1'

  assert::fails path::canonicalize "$bar"

  unstub readlink
  [[ "$output" == '' ]]
}
