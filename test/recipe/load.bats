#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'recipe::load'
}

@test "fails if there is no \$recipe file" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'log'

  local recipe='foo'
  run recipe::load

  ((status == 1))
  [[ "$output" == "$(capture::stderr log error 'foo' 'file is missing')" ]]
}

@test "fails if recipe::file fails" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'log'

  recipe::file() { return 1; }

  local recipe='foo'
  run recipe::load

  ((status == 1))
  [[ "$output" == "$(capture::stderr log error 'foo' 'file is missing')" ]]
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
  import 'capture::stderr'
  import 'file::write'
  import 'log'

  local RECIPES_PATH=("$BATS_TEST_TMPDIR")
  file::write "$BATS_TEST_TMPDIR/foo/recipe.bash" 'return 1'

  local recipe='foo'
  run recipe::load

  ((status == 1))
  [[ "$output" == "$(capture::stderr log error 'foo' "failed to load from $BATS_TEST_TMPDIR/foo/recipe.bash")" ]]
}

@test "fails if it can't determine the \$recipe's parent directory" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'file::write'

  local RECIPES_PATH=("$BATS_TEST_TMPDIR")
  file::write "$BATS_TEST_TMPDIR/foo/recipe.bash" "echo 'bar'"

  path::parent() { return 1; }

  local recipe='foo'
  run recipe::load

  ((status == 1))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == 'bar' ]]
  [[ "${lines[1]}" == "$(capture::stderr log error 'foo' 'failed to cd into recipe'\''s directory')" ]]
}

@test "fails if cd to the \$recipe's directory fails" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'file::write'

  local RECIPES_PATH=("$BATS_TEST_TMPDIR")
  file::write "$BATS_TEST_TMPDIR/foo/recipe.bash" "echo 'bar'"

  # capture error message before platform::name is mocked because
  # capture::stderr indirectly depends on platform::name
  local error_message
  error_message="$(capture::stderr log error 'foo' 'failed to cd into recipe'\''s directory')"

  cd() { return 1; }

  local recipe='foo'
  run recipe::load

  ((status == 1))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == 'bar' ]]
  [[ "${lines[1]}" == "$error_message" ]]
}

@test "fails if \$recipe is missing" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'capture::stderr'
  import 'log'

  assert::exits recipe::load

  ((status == 3))
  [[ "${lines[0]}" == "$(capture::stderr log error 'recipe::load' 'expected nonempty variables: recipe')" ]]
}
