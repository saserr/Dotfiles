#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'recipe::load'
}

@test "fails if there is no \$recipe file" {
  import 'log'

  local recipe='foo'
  run recipe::load

  ((status == 1))
  [[ "$output" == "$(log warn 'foo' 'has no recipe')" ]]
}

@test "fails if recipe::file fails" {
  import 'log'

  recipe::file() { return 1; }

  local recipe='foo'
  run recipe::load

  ((status == 1))
  [[ "$output" == "$(log warn 'foo' 'has no recipe')" ]]
}

@test "loads the \$recipe file" {
  load '../helpers/import.bash'
  import 'file::write'

  local RECIPES_PATH=("$BATS_TEST_TMPDIR")
  file::write "$BATS_TEST_TMPDIR/foo/recipe.bash" "echo 'bar'"

  local recipe='foo'
  run recipe::load

  ((status == 0))
  [[ "$output" == 'bar' ]]
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
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'file::write'
  import 'log'

  local RECIPES_PATH=("$BATS_TEST_TMPDIR")
  file::write "$BATS_TEST_TMPDIR/foo/recipe.bash" 'return 1'

  local recipe='foo'
  assert::exits recipe::load

  ((status == 2))
  [[ "${lines[0]}" == "$(log error 'foo' "failed to load from $BATS_TEST_TMPDIR/foo/recipe.bash")" ]]
}

@test "fails if cd to the \$recipe's directory fails" {
  load '../helpers/import.bash'
  import 'file::write'

  local RECIPES_PATH=("$BATS_TEST_TMPDIR")
  file::write "$BATS_TEST_TMPDIR/foo/recipe.bash" "echo 'bar'"

  cd() { return 1; }

  local recipe='foo'
  run recipe::load

  ((status == 1))
  [[ "$output" == 'bar' ]]
}

@test "fails if \$recipe is missing" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'log'

  assert::exits recipe::load

  ((status == 2))
  [[ "${lines[0]}" == "$(log error 'recipe::load' 'expected nonempty variables: recipe')" ]]
}
