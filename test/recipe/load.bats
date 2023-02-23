#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'recipe::load'
}

@test "fails if there is no \$recipe file" {
  import 'log::warn'

  local recipe='foo'
  run recipe::load

  ((status == 1))
  [[ "$output" == "$(log::warn 'foo' 'has no recipe')" ]]
}

@test "fails if recipe::file fails" {
  import 'log::warn'

  recipe::file() { return 1; }

  local recipe='foo'
  run recipe::load

  ((status == 1))
  [[ "$output" == "$(log::warn 'foo' 'has no recipe')" ]]
}

@test "loads the \$recipe file" {
  local RECIPES_PATH=("$BATS_TEST_TMPDIR")
  mkdir -p "$BATS_TEST_TMPDIR/bar"
  echo "echo 'foo'" >"$BATS_TEST_TMPDIR/bar/recipe.bash"

  local recipe='bar'
  run recipe::load

  ((status == 0))
  [[ "$output" == 'foo' ]]
}

@test "cd to the \$recipe's directory" {
  local RECIPES_PATH=("$BATS_TEST_TMPDIR")
  mkdir -p "$BATS_TEST_TMPDIR/foo"
  touch "$BATS_TEST_TMPDIR/foo/recipe.bash"

  local recipe='foo'
  recipe::load

  [[ "$PWD" == "$BATS_TEST_TMPDIR/foo" ]]
}

@test "fails if loading the \$recipe file fails" {
  import 'log::error'

  local RECIPES_PATH=("$BATS_TEST_TMPDIR")
  mkdir -p "$BATS_TEST_TMPDIR/foo"
  echo 'return 1' >"$BATS_TEST_TMPDIR/foo/recipe.bash"

  local recipe='foo'
  run recipe::load

  ((status == 2))
  [[ "${lines[0]}" == "$(log::error 'foo' "failed to load from $BATS_TEST_TMPDIR/foo/recipe.bash")" ]]
}

@test "exits if loading the \$recipe file fails" {
  local RECIPES_PATH=("$BATS_TEST_TMPDIR")
  mkdir -p "$BATS_TEST_TMPDIR/baz"
  echo 'return 1' >"$BATS_TEST_TMPDIR/baz/recipe.bash"

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

@test "fails if cd to the \$recipe's directory fails" {
  local RECIPES_PATH=("$BATS_TEST_TMPDIR")
  mkdir -p "$BATS_TEST_TMPDIR/bar"
  echo "echo 'foo'" >"$BATS_TEST_TMPDIR/bar/recipe.bash"

  cd() { [[ "$1" != "$BATS_TEST_TMPDIR/bar" ]]; }

  local recipe='bar'
  run recipe::load

  ((status == 1))
  [[ "$output" == 'foo' ]]
}

@test "fails if \$recipe is missing" {
  import 'log::error'

  run recipe::load

  ((status == 2))
  [[ "${lines[0]}" == "$(log::error 'recipe::load' 'expected nonempty variables: recipe')" ]]
}
