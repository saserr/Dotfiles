#!/usr/bin/env bats

@test "creates \$IMPORT_PATH with 'recipes' if \$IMPORT_PATH is not declared" {
  declare -p 'IMPORT_PATH' && return 1 # test that IMPORT_PATH is not declared

  source 'lib/import.bash'

  ((${#IMPORT_PATH[@]} == 1))
  [[ "${IMPORT_PATH[0]}" == "$PWD/lib" ]]
}

@test "appends 'recipes' to \$IMPORT_PATH if \$IMPORT_PATH is an array" {
  local IMPORT_PATH=('foo')

  source 'lib/import.bash'

  ((${#IMPORT_PATH[@]} == 2))
  [[ "${IMPORT_PATH[0]}" == 'foo' ]]
  [[ "${IMPORT_PATH[1]}" == "$PWD/lib" ]]
}

@test "redeclares \$IMPORT_PATH as an array and appends 'recipes' if \$IMPORT_PATH is not an array" {
  local IMPORT_PATH='foo'

  source 'lib/import.bash'

  ((${#IMPORT_PATH[@]} == 2))
  [[ "${IMPORT_PATH[0]}" == 'foo' ]]
  [[ "${IMPORT_PATH[1]}" == "$PWD/lib" ]]
}

@test "declares the 'import' function" {
  declare -F 'import' && return 1 # test that import is not declared

  source 'lib/import.bash'

  declare -F 'import'
}

@test "fails without arguments" {
  source 'lib/import.bash'
  run import

  load 'helpers/assert/wrong_usage.bash'
  assert::wrong_usage 'import' 'function'
}

@test "doesn't do anything if function already exists" {
  platform::name() { echo 'foo'; }
  local expected="$(type 'platform::name')"
  [[ "$expected" == *'foo'* ]]

  source 'lib/import.bash'
  import 'platform::name'

  # check that the above function is still the one declared as platform::name
  [[ "$(type 'platform::name')" == "$expected" ]]
}

@test "imports a missing function" {
  # test that arguments::expect is not declared
  declare -F 'arguments::expect' && return 1

  source 'lib/import.bash'
  import 'arguments::expect'

  declare -F 'arguments::expect'
}

@test "skips paths in \$IMPORT_PATH that don't have the function file" {
  IMPORT_PATH=("$BATS_TEST_TMPDIR")
  # test that arguments::expect is not declared
  declare -F 'arguments::expect' && return 1

  source 'lib/import.bash'
  import 'arguments::expect'

  declare -F 'arguments::expect'
}

@test "imports from the first location in \$IMPORT_PATH which has the function files" {
  IMPORT_PATH=("$BATS_TEST_TMPDIR")
  mkdir -p "$BATS_TEST_TMPDIR/arguments"
  echo 'arguments::expect() { echo "foo"; }' >"$BATS_TEST_TMPDIR/arguments/expect.bash"
  # test that arguments::expect is not declared
  declare -F 'arguments::expect' && return 1

  source 'lib/import.bash'
  import 'arguments::expect'

  declare -F 'arguments::expect'
  [[ "$(arguments::expect)" == 'foo' ]]
}

@test "validates that correct function has been imported" {
  IMPORT_PATH=("$BATS_TEST_TMPDIR")
  touch "$BATS_TEST_TMPDIR/foo.bash"

  source 'lib/import.bash'
  run import 'foo'

  ((status == 2))
  [[ "${lines[0]}" == *'import'* ]]
  [[ "${lines[0]}" == *"the 'foo' function is missing in $BATS_TEST_TMPDIR/foo.bash" ]]
}

@test "imports from symbolic links that have the same name as the expected function file" {
  IMPORT_PATH=("$BATS_TEST_TMPDIR")
  echo 'foo() { echo "bar"; }' >"$BATS_TEST_TMPDIR/baz.bash"
  ln -s "$BATS_TEST_TMPDIR/baz.bash" "$BATS_TEST_TMPDIR/foo.bash"
  [[ -L "$BATS_TEST_TMPDIR/foo.bash" ]]

  source 'lib/import.bash'
  import 'foo'

  declare -F 'foo'
  [[ "$(foo)" == 'bar' ]]
}

@test "skips broken links that have the same name as the expected function file" {
  IMPORT_PATH=("$BATS_TEST_TMPDIR")
  ln -s "$BATS_TEST_TMPDIR/foo.bash" "$BATS_TEST_TMPDIR/bar.bash"
  [[ -L "$BATS_TEST_TMPDIR/bar.bash" ]]

  source 'lib/import.bash'
  run import 'bar'

  declare -F 'bar' && return 1 # test that bar is not declared
  ((status == 2))
  [[ "${lines[0]}" == *'import'* ]]
  [[ "${lines[0]}" == *'unknown function: bar'* ]]
}

@test "skips directories that have the same name as the expected function file" {
  IMPORT_PATH=("$BATS_TEST_TMPDIR")
  mkdir "$BATS_TEST_TMPDIR/foo.bash"

  source 'lib/import.bash'
  run import 'foo'

  declare -F 'foo' && return 1 # test that foo is not declared
  ((status == 2))
  [[ "${lines[0]}" == *'import'* ]]
  [[ "${lines[0]}" == *'unknown function: foo'* ]]
}

@test "fails if an unknown function is imported" {
  source 'lib/import.bash'
  run import 'foo'

  declare -F 'foo' && return 1 # test that foo is not declared
  ((status == 2))
  [[ "${lines[0]}" == *'import'* ]]
  [[ "${lines[0]}" == *'unknown function: foo'* ]]
}

@test "exits if an unknown function is imported" {
  source 'lib/import.bash'

  __test() {
    echo 'foo'
    import 'bar' >/dev/null
    echo 'baz'
  }
  run __test

  ((status == 2))
  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == 'foo' ]]
  [[ "${lines[1]}" == *'unknown function: bar'* ]]
  [[ "${lines[2]}" != *'baz'* ]]
}
