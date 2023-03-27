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
  local script="$BATS_TEST_TMPDIR/test.bash"
  echo '#!/usr/bin/env bash' >"$script"
  echo "source 'lib/import.bash'" >>"$script"
  echo 'test() { import; }' >>"$script"
  echo 'test' >>"$script"
  chmod +x "$script"

  run "$script"

  ((status == 2))
  ((${#lines[@]} == 5))
  [[ "${lines[0]}" == *'[import]'* ]]
  [[ "${lines[0]}" == *'wrong number of arguments' ]]
  [[ "${lines[1]}" == '         actual: 0' ]]
  [[ "${lines[2]}" == '         expected: 1' ]]
  [[ "${lines[3]}" == '         arguments: function' ]]
  [[ "${lines[4]}" == "         at $script (line: 3)" ]]
}

@test "fails without arguments (no arguments::expect)" {
  local script="$BATS_TEST_TMPDIR/test.bash"
  echo '#!/usr/bin/env bash' >"$script"
  echo "source 'lib/import.bash'" >>"$script"
  echo "unset -f 'arguments::expect'" >>"$script"
  echo 'test() { import; }' >>"$script"
  echo 'test' >>"$script"
  chmod +x "$script"

  run "$script"

  ((status == 2))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == '[import] expected argument: function' ]]
  [[ "${lines[1]}" == "         at $script (line: 4)" ]]
}

@test "doesn't do anything if function already exists" {
  source 'lib/import.bash'

  platform::name() { echo 'foo'; }
  local expected="$(type 'platform::name')"
  [[ "$expected" == *'foo'* ]]

  import 'platform::name'

  # check that the above function is still the one declared as platform::name
  [[ "$(type 'platform::name')" == "$expected" ]]
}

@test "imports a missing function" {
  source 'lib/import.bash'

  # test that platform::name is not declared
  declare -F 'platform::name' && return 1

  import 'platform::name'

  declare -F 'platform::name'
}

@test "skips paths in \$IMPORT_PATH that don't have the function file" {
  IMPORT_PATH=("$BATS_TEST_TMPDIR")
  source 'lib/import.bash'

  # test that platform::name is not declared
  declare -F 'platform::name' && return 1

  import 'platform::name'

  declare -F 'platform::name'
}

@test "imports from the first location in \$IMPORT_PATH which has the function files" {
  IMPORT_PATH=("$BATS_TEST_TMPDIR")
  mkdir -p "$BATS_TEST_TMPDIR/platform"
  echo 'platform::name() { echo "foo"; }' >"$BATS_TEST_TMPDIR/platform/name.bash"
  source 'lib/import.bash'

  # test that 'platform::name is not declared
  declare -F 'platform::name' && return 1

  import 'platform::name'

  declare -F 'platform::name'
  [[ "$(platform::name)" == 'foo' ]]
}

@test "validates that correct function has been imported" {
  IMPORT_PATH=("$BATS_TEST_TMPDIR")
  touch "$BATS_TEST_TMPDIR/foo.bash"
  source 'lib/import.bash'

  run import 'foo'

  ((status == 2))
  [[ "${lines[0]}" == *'[import]'* ]]
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

  ((status == 2))
  [[ "${lines[0]}" == *'[import]'* ]]
  [[ "${lines[0]}" == *'unknown function: bar' ]]
}

@test "skips directories that have the same name as the expected function file" {
  IMPORT_PATH=("$BATS_TEST_TMPDIR")
  mkdir "$BATS_TEST_TMPDIR/foo.bash"
  source 'lib/import.bash'

  run import 'foo'

  ((status == 2))
  [[ "${lines[0]}" == *'[import]'* ]]
  [[ "${lines[0]}" == *'unknown function: foo' ]]
}

@test "fails if a function is used while being imported" {
  IMPORT_PATH=("$BATS_TEST_TMPDIR")

  echo "import 'bar'" >"$BATS_TEST_TMPDIR/foo.bash"
  echo "foo() { echo 'foo'; }" >>"$BATS_TEST_TMPDIR/foo.bash"

  echo "import 'foo'" >"$BATS_TEST_TMPDIR/bar.bash"
  echo 'foo' >>"$BATS_TEST_TMPDIR/bar.bash"
  echo "bar() { echo 'bar'; }" >>"$BATS_TEST_TMPDIR/bar.bash"

  source 'lib/import.bash'

  # fails because foo is called in bar.bash before it was actually declared
  run import 'foo'

  ((status == 2))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == '[foo] is being loaded; do not call' ]]
  [[ "${lines[1]}" == "      at $BATS_TEST_TMPDIR/bar.bash (line: 2)" ]]

  # works when imported the other way around
  run import 'bar'

  ((status == 0))
  [[ "$output" == 'foo' ]]
}

@test "fails if sourcing the function file fails" {
  IMPORT_PATH=("$BATS_TEST_TMPDIR")
  echo 'return 1' >"$BATS_TEST_TMPDIR/foo.bash"
  source 'lib/import.bash'

  run import 'foo'

  ((status == 2))
  [[ "${lines[0]}" == *'[import]'* ]]
  [[ "${lines[0]}" == *"can't load the 'foo' function from $BATS_TEST_TMPDIR/foo.bash" ]]
}

test_unknown_function() {
  echo 'test() {' >>"$BATS_TEST_TMPDIR/test.bash"

  echo "import 'foo'" >>"$BATS_TEST_TMPDIR/test.bash"
  local -i import_line
  import_line="$(wc -l <"$BATS_TEST_TMPDIR/test.bash")"

  local unexpected="$BATS_TEST_TMPDIR/unexpected"
  echo "touch '$unexpected'" >>"$BATS_TEST_TMPDIR/test.bash"

  echo '}' >>"$BATS_TEST_TMPDIR/test.bash"
  echo 'test' >>"$BATS_TEST_TMPDIR/test.bash"

  chmod u+x "$BATS_TEST_TMPDIR/test.bash"
  run "$BATS_TEST_TMPDIR/test.bash"

  ((status == 2))
  [[ ! -e "$unexpected" ]]
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == *'[import]'* ]]
  [[ "${lines[0]}" == *'unknown function: foo' ]]
  [[ "${lines[1]}" == "         at $BATS_TEST_TMPDIR/test.bash (line: $import_line)" ]]
}

@test "exits if an unknown function is imported" {
  echo '#!/usr/bin/env bash' >"$BATS_TEST_TMPDIR/test.bash"
  echo "source 'lib/import.bash'" >>"$BATS_TEST_TMPDIR/test.bash"

  test_unknown_function
}

@test "exits if an unknown function is imported (no abort)" {
  echo '#!/usr/bin/env bash' >"$BATS_TEST_TMPDIR/test.bash"
  echo "source 'lib/import.bash'" >>"$BATS_TEST_TMPDIR/test.bash"
  echo "unset -f 'abort'" >>"$BATS_TEST_TMPDIR/test.bash"

  test_unknown_function
}

@test "exits if an unknown function is imported (no abort and log::error)" {
  echo '#!/usr/bin/env bash' >"$BATS_TEST_TMPDIR/test.bash"
  echo "source 'lib/import.bash'" >>"$BATS_TEST_TMPDIR/test.bash"
  echo "unset -f 'abort'" >>"$BATS_TEST_TMPDIR/test.bash"
  echo "unset -f 'log::error'" >>"$BATS_TEST_TMPDIR/test.bash"

  test_unknown_function
}
