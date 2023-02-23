#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'recipe::load'
}

@test "fails if there is no \$recipe file" {
  import 'log::error'

  local recipe='foo'
  run recipe::load

  ((status == 1))
  [[ "$output" == "$(log::error 'foo' 'has no recipe')" ]]
}

@test "fails if recipe::file fails" {
  import 'log::error'

  recipe::file() { return 1; }

  local recipe='foo'
  run recipe::load

  ((status == 2))
  [[ "${lines[0]}" == "$(log::error 'recipe::file' 'failed')" ]]
}

@test "exits if recipe::file fails" {
  recipe::file() { return 1; }
  fail() {
    echo 'foo'
    recipe::load 2>/dev/null
    echo 'bar'
  }

  local recipe='baz'
  run fail

  ((status == 2))
  [[ "$output" == 'foo' ]]
}

@test "loads the \$recipe file" {
  recipe::file() { echo "$BATS_TEST_TMPDIR/foo"; }
  echo "echo 'bar'" >"$BATS_TEST_TMPDIR/foo"

  local recipe='baz'
  run recipe::load

  ((status == 0))
  [[ "$output" == 'bar' ]]
}

@test "cd to the \$recipe's directory" {
  recipe::file() { echo "$BATS_TEST_TMPDIR/foo"; }
  echo "echo 'bar'" >"$BATS_TEST_TMPDIR/foo"

  local recipe='baz'
  recipe::load

  [[ "$PWD" == "$BATS_TEST_TMPDIR" ]]
}

@test "fails if loading the \$recipe file fails" {
  import 'log::error'

  recipe::file() { echo "$BATS_TEST_TMPDIR/foo"; }
  echo "return 1" >"$BATS_TEST_TMPDIR/foo"

  local recipe='bar'
  run recipe::load

  ((status == 2))
  [[ "${lines[0]}" == "$(log::error 'bar' "failed to load from $(recipe::file)")" ]]
}

@test "exits if loading the \$recipe file fails" {
  recipe::file() { echo "$BATS_TEST_TMPDIR/foo"; }
  echo "return 1" >"$BATS_TEST_TMPDIR/foo"
  fail() {
    echo 'foo'
    recipe::load 2>/dev/null
    echo 'bar'
  }

  local recipe='baz'
  run fail

  ((status == 2))
  [[ "$output" == 'foo' ]]
}

@test "fails if \$recipe is missing" {
  import 'log::error'

  run recipe::load

  ((status == 2))
  [[ "${lines[0]}" == "$(log::error 'recipe::load' 'expected nonempty variables: recipe')" ]]
}

@test "fails if cd to the \$recipe's directory fails" {
  recipe::file() { echo "$BATS_TEST_TMPDIR/foo"; }
  echo "echo 'bar'" >"$BATS_TEST_TMPDIR/foo"
  cd() { [[ "$1" != "$BATS_TEST_TMPDIR" ]]; }

  local recipe='baz'
  run recipe::load

  ((status == 1))
  [[ "$output" == 'bar' ]]
}
