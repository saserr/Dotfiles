#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'recipe::file'
}

@test "adds 'recipes' to \$RECIPES_PATH on import" {
  ((${#RECIPES_PATH[@]} == 1))
  [[ "${RECIPES_PATH[0]}" == 'recipes' ]]
}

@test "returns the location of the \$recipe's configuration" {
  local expected="$BATS_TEST_TMPDIR/foo/recipe.bash"
  mkdir -p "$(dirname -- "$expected")"
  touch "$expected"

  local RECIPES_PATH=("$BATS_TEST_TMPDIR")
  local recipe='foo'
  run recipe::file

  ((status == 0))
  [[ "$output" == "$expected" ]]
}

@test "skips paths that don't have the \$recipe's configuration" {
  local RECIPES_PATH=("$BATS_TEST_TMPDIR" 'recipes')
  local recipe='git'
  run recipe::file

  ((status == 0))
  [[ "$output" == "recipes/$recipe/recipe.bash" ]]
}

@test "returns the first location which has the \$recipe's configuration" {
  local expected="$BATS_TEST_TMPDIR/git/recipe.bash"
  mkdir -p "$(dirname -- "$expected")"
  touch "$expected"

  local RECIPES_PATH=("$BATS_TEST_TMPDIR" 'recipes')
  local recipe='git'
  run recipe::file

  ((status == 0))
  [[ "$output" == "$expected" ]]
}

@test "fails if no \$recipe configuration can be found" {
  [[ ! -e "$BATS_TEST_TMPDIR/foo/recipe.bash" ]]

  local RECIPES_PATH=("$BATS_TEST_TMPDIR")
  local recipe='foo'
  run recipe::file

  ((status == 1))
}

@test "fails if \$recipe is missing" {
  import 'log::error'

  run recipe::file

  ((status == 2))
  [[ "${lines[0]}" == "$(log::error 'recipe::file' "expected nonempty variables: recipe")" ]]
}
