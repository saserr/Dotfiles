#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'file::contains'

  test_file="$BATS_TEST_TMPDIR/test"
  [[ ! -e "$test_file" ]] # $test_file does not exist
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run file::contains

  assert::wrong_usage 'file::contains' 'file' 'text'
}

@test "fails with only one argument" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run file::contains "$test_file"

  assert::wrong_usage 'file::contains' 'file' 'text'
}

@test "a non-existant file doesn't contain given text" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails file::contains "$test_file" 'foo'
}

@test "an empty file doesn't contain given text" {
  load '../helpers/import.bash'
  import 'assert::fails'

  touch "$test_file"

  assert::fails file::contains "$test_file" 'foo'
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
  load '../helpers/import.bash'
  import 'assert::fails'

  echo 'foo' >"$test_file"

  assert::fails file::contains "$test_file" 'bar'
}
