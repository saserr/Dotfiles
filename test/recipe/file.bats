#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'recipe::file'
}

@test "creates \$RECIPES_PATH with 'recipes' if \$RECIPES_PATH is not declared" {
  load '../helpers/import.bash'
  import 'assert::fails'
  import 'variable::exists'

  unset 'RECIPES_PATH'
  assert::fails variable::exists 'RECIPES_PATH'

  source 'lib/recipe/file.bash'

  ((${#RECIPES_PATH[@]} == 1))
  [[ "${RECIPES_PATH[0]}" == "$PWD/recipes" ]]
}

@test "appends 'recipes' to \$RECIPES_PATH if \$RECIPES_PATH is an array" {
  import 'variable::is_array'

  local RECIPES_PATH=('foo')
  variable::is_array 'RECIPES_PATH'

  source 'lib/recipe/file.bash'

  ((${#RECIPES_PATH[@]} == 2))
  [[ "${RECIPES_PATH[0]}" == 'foo' ]]
  [[ "${RECIPES_PATH[1]}" == "$PWD/recipes" ]]
}

@test "redeclares \$RECIPES_PATH as an array and appends 'recipes' if \$RECIPES_PATH is not an array" {
  load '../helpers/import.bash'
  import 'assert::fails'
  import 'variable::exists'
  import 'variable::is_array'

  local RECIPES_PATH='foo'
  variable::exists 'RECIPES_PATH'
  assert::fails variable::is_array 'RECIPES_PATH'

  source 'lib/recipe/file.bash'

  ((${#RECIPES_PATH[@]} == 2))
  [[ "${RECIPES_PATH[0]}" == 'foo' ]]
  [[ "${RECIPES_PATH[1]}" == "$PWD/recipes" ]]
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

@test "skips paths in \$RECIPES_PATH that don't have the \$recipe's configuration" {
  local RECIPES_PATH=("$BATS_TEST_TMPDIR" 'recipes')
  local recipe='git'
  run recipe::file

  ((status == 0))
  [[ "$output" == "recipes/$recipe/recipe.bash" ]]
}

@test "returns the first location in \$RECIPES_PATH which has the \$recipe's configuration" {
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
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'log::error'

  assert::exits recipe::file

  ((status == 2))
  [[ "${lines[0]}" == "$(log::error 'recipe::file' "expected nonempty variables: recipe")" ]]
}
