#!/usr/bin/env bats

setup() {
  load '../setup.bash'
  import 'file::append'

  test_file="$BATS_TEST_TMPDIR/test"
  [[ ! -e "$test_file" ]] # $test_file does not exist
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run file::append

  assert::wrong_usage 'file::append' 'file' '[text]'
}

@test "appends a new line with only one argument" {
  touch "$test_file"

  file::append "$test_file"

  [[ "$(cat -e "$test_file")" == '$' ]]
}

@test "append to an empty file" {
  touch "$test_file"

  file::append "$test_file" 'foo'

  [[ "$(cat "$test_file")" == 'foo' ]]
}

@test "append to a non-empty file" {
  echo 'foo' >"$test_file"

  file::append "$test_file" 'bar'

  [[ "$(cat "$test_file")" == $'foo\nbar' ]]
}

@test "append to a non-existent file" {
  file::append "$test_file" 'foo'

  [[ "$(cat "$test_file")" == 'foo' ]]
}
