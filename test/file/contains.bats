#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'file::contains'

  test_file="$BATS_TEST_TMPDIR/test"
  [[ ! -e "$test_file" ]] # $test_file does not exist
}

@test "fails without arguments" {
  load '../helpers/assert/wrong_usage.bash'

  run file::contains

  assert::wrong_usage 'file::contains' 'file' 'text'
}

@test "fails with only one argument" {
  load '../helpers/assert/wrong_usage.bash'

  run file::contains "$test_file"

  assert::wrong_usage 'file::contains' 'file' 'text'
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
