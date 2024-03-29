#!/usr/bin/env bats

@test "fails if unable to determine the parent directory" {
  load 'helpers/mocks/stub.bash'

  stub dirname 'exit 1'

  run source 'lib/import.bash'

  unstub dirname
  ((status == 3))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == '[import] unable to determine the parent directory' ]]
  [[ "${lines[1]}" == '         file: '* ]]
  [[ "${lines[1]}" == *'lib/import.bash' ]]
}

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

@test "creates \$SKIP_ON_STACK_TRACE with 'lib/import.bash' if \$SKIP_ON_STACK_TRACE is not declared" {
  # test that SKIP_ON_STACK_TRACE is not declared
  declare -p 'SKIP_ON_STACK_TRACE' && return 1

  source 'lib/import.bash'

  ((${#SKIP_ON_STACK_TRACE[@]} == 1))
  [[ "${SKIP_ON_STACK_TRACE[0]}" == 'lib/import.bash' ]]
}

@test "appends 'lib/import.bash' to \$SKIP_ON_STACK_TRACE if \$SKIP_ON_STACK_TRACE is an array" {
  local SKIP_ON_STACK_TRACE=('foo')

  source 'lib/import.bash'

  ((${#SKIP_ON_STACK_TRACE[@]} == 2))
  [[ "${SKIP_ON_STACK_TRACE[0]}" == 'foo' ]]
  [[ "${SKIP_ON_STACK_TRACE[1]}" == 'lib/import.bash' ]]
}

@test "redeclares \$SKIP_ON_STACK_TRACE as an array and appends 'lib/import.bash' if \$SKIP_ON_STACK_TRACE is not an array" {
  local SKIP_ON_STACK_TRACE='foo'

  source 'lib/import.bash'

  ((${#SKIP_ON_STACK_TRACE[@]} == 2))
  [[ "${SKIP_ON_STACK_TRACE[0]}" == 'foo' ]]
  [[ "${SKIP_ON_STACK_TRACE[1]}" == 'lib/import.bash' ]]
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
  echo "echo 'unreachable'" >>"$script"
  chmod +x "$script"

  run "$script"

  ((status == 3))
  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == *'[import]'* ]]
  [[ "${lines[0]}" == *'expected argument: function' ]]
  [[ "${lines[1]}" == "         at $script (line: 3)" ]]
  [[ "${lines[2]}" == "         at $script (line: 4)" ]]
}

@test "fails without arguments (no abort)" {
  local script="$BATS_TEST_TMPDIR/test.bash"
  echo '#!/usr/bin/env bash' >"$script"
  echo "source 'lib/import.bash'" >>"$script"
  echo "unset -f 'abort'" >>"$script"
  echo 'test() { import; }' >>"$script"
  echo 'test' >>"$script"
  echo "echo 'unreachable'" >>"$script"
  chmod +x "$script"

  run "$script"

  ((status == 3))
  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == *'[import]'* ]]
  [[ "${lines[0]}" == *'expected argument: function' ]]
  [[ "${lines[1]}" == "         at $script (line: 4)" ]]
  [[ "${lines[2]}" == "         at $script (line: 5)" ]]
}

@test "fails without arguments (no abort and log)" {
  local script="$BATS_TEST_TMPDIR/test.bash"
  echo '#!/usr/bin/env bash' >"$script"
  echo "source 'lib/import.bash'" >>"$script"
  echo "unset -f 'abort'" >>"$script"
  echo "unset -f 'log'" >>"$script"
  echo 'test() { import; }' >>"$script"
  echo 'test' >>"$script"
  echo "echo 'unreachable'" >>"$script"
  chmod +x "$script"

  run "$script"

  ((status == 3))
  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == '[import] expected argument: function' ]]
  [[ "${lines[1]}" == "         at $script (line: 5)" ]]
  [[ "${lines[2]}" == "         at $script (line: 6)" ]]
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

  import 'foo'
  run foo

  ((status == 3))
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

  ((status == 3))
  [[ "${lines[0]}" == *'[import]'* ]]
  [[ "${lines[0]}" == *'unknown function: bar' ]]
}

@test "skips directories that have the same name as the expected function file" {
  IMPORT_PATH=("$BATS_TEST_TMPDIR")
  mkdir "$BATS_TEST_TMPDIR/foo.bash"
  source 'lib/import.bash'

  run import 'foo'

  ((status == 3))
  [[ "${lines[0]}" == *'[import]'* ]]
  [[ "${lines[0]}" == *'unknown function: foo' ]]
}

@test "fails if a function is used while being imported" {
  echo "import 'bar'" >"$BATS_TEST_TMPDIR/foo.bash"
  echo 'bar' >>"$BATS_TEST_TMPDIR/foo.bash"
  echo "foo() { echo 'foo'; }" >>"$BATS_TEST_TMPDIR/foo.bash"

  echo "import 'foo'" >"$BATS_TEST_TMPDIR/bar.bash"
  echo 'foo' >>"$BATS_TEST_TMPDIR/bar.bash"
  echo "bar() { echo 'bar'; }" >>"$BATS_TEST_TMPDIR/bar.bash"

  # fails because foo is called in bar.bash before it was actually declared
  run bash -c "IMPORT_PATH=('$BATS_TEST_TMPDIR') \
    && source 'lib/import.bash' \
    && import 'foo' \
    && foo"

  ((status == 3))
  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == *'[foo]'* ]]
  [[ "${lines[0]}" == *'is being loaded; do not call' ]]
  [[ "${lines[1]}" == "      at $BATS_TEST_TMPDIR/bar.bash (line: 2)" ]]
  [[ "${lines[2]}" == "      at $BATS_TEST_TMPDIR/foo.bash (line: 2)" ]]
}

@test "fails if a function is used while being imported (no abort)" {
  echo "import 'bar'" >"$BATS_TEST_TMPDIR/foo.bash"
  echo 'bar' >>"$BATS_TEST_TMPDIR/foo.bash"
  echo "foo() { echo 'foo'; }" >>"$BATS_TEST_TMPDIR/foo.bash"

  echo "import 'foo'" >"$BATS_TEST_TMPDIR/bar.bash"
  echo 'foo' >>"$BATS_TEST_TMPDIR/bar.bash"
  echo "bar() { echo 'bar'; }" >>"$BATS_TEST_TMPDIR/bar.bash"

  # fails because foo is called in bar.bash before it was actually declared
  run bash -c "IMPORT_PATH=('$BATS_TEST_TMPDIR') \
    && source 'lib/import.bash' \
    && unset -f 'abort' \
    && import 'foo' \
    && foo"

  ((status == 3))
  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == *'[foo]'* ]]
  [[ "${lines[0]}" == *'is being loaded; do not call' ]]
  [[ "${lines[1]}" == "      at $BATS_TEST_TMPDIR/bar.bash (line: 2)" ]]
  [[ "${lines[2]}" == "      at $BATS_TEST_TMPDIR/foo.bash (line: 2)" ]]
}

@test "fails if a function is used while being imported (no abort and log)" {
  echo "import 'bar'" >"$BATS_TEST_TMPDIR/foo.bash"
  echo 'bar' >>"$BATS_TEST_TMPDIR/foo.bash"
  echo "foo() { echo 'foo'; }" >>"$BATS_TEST_TMPDIR/foo.bash"

  echo "import 'foo'" >"$BATS_TEST_TMPDIR/bar.bash"
  echo 'foo' >>"$BATS_TEST_TMPDIR/bar.bash"
  echo "bar() { echo 'bar'; }" >>"$BATS_TEST_TMPDIR/bar.bash"

  # fails because foo is called in bar.bash before it was actually declared
  run bash -c "IMPORT_PATH=('$BATS_TEST_TMPDIR') \
    && source 'lib/import.bash' \
    && unset -f 'abort' \
    && unset -f 'log' \
    && import 'foo' \
    && foo"

  ((status == 3))
  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == '[foo] is being loaded; do not call' ]]
  [[ "${lines[1]}" == "      at $BATS_TEST_TMPDIR/bar.bash (line: 2)" ]]
  [[ "${lines[2]}" == "      at $BATS_TEST_TMPDIR/foo.bash (line: 2)" ]]
}

@test "fails if sourcing the function file fails" {
  IMPORT_PATH=("$BATS_TEST_TMPDIR")
  echo 'return 1' >"$BATS_TEST_TMPDIR/foo.bash"
  source 'lib/import.bash'

  import 'foo'
  run foo

  ((status == 3))
  [[ "${lines[0]}" == *'[import]'* ]]
  [[ "${lines[0]}" == *"can't load the 'foo' function from $BATS_TEST_TMPDIR/foo.bash" ]]
}

@test "exits if an unknown function is imported" {
  local script="$BATS_TEST_TMPDIR/test.bash"
  echo '#!/usr/bin/env bash' >"$script"
  echo "source 'lib/import.bash'" >>"$script"
  echo 'test() {' >>"$script"
  echo "import 'foo'" >>"$script"
  echo "echo 'unreachable'" >>"$script"
  echo '}' >>"$script"
  echo 'test' >>"$script"
  chmod u+x "$script"

  run "$script"

  ((status == 3))
  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == *'[import]'* ]]
  [[ "${lines[0]}" == *'unknown function: foo' ]]
  [[ "${lines[1]}" == "         at $BATS_TEST_TMPDIR/test.bash (line: 4)" ]]
  [[ "${lines[2]}" == "         at $BATS_TEST_TMPDIR/test.bash (line: 7)" ]]
}

@test "exits if an unknown function is imported (no abort)" {
  local script="$BATS_TEST_TMPDIR/test.bash"
  echo '#!/usr/bin/env bash' >"$script"
  echo "source 'lib/import.bash'" >>"$script"
  echo "unset -f 'abort'" >>"$script"
  echo 'test() {' >>"$script"
  echo "import 'foo'" >>"$script"
  echo "echo 'unreachable'" >>"$script"
  echo '}' >>"$script"
  echo 'test' >>"$script"
  chmod u+x "$script"

  run "$script"

  ((status == 3))
  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == *'[import]'* ]]
  [[ "${lines[0]}" == *'unknown function: foo' ]]
  [[ "${lines[1]}" == "         at $BATS_TEST_TMPDIR/test.bash (line: 5)" ]]
  [[ "${lines[2]}" == "         at $BATS_TEST_TMPDIR/test.bash (line: 8)" ]]
}

@test "exits if an unknown function is imported (no abort and log)" {
  local script="$BATS_TEST_TMPDIR/test.bash"
  echo '#!/usr/bin/env bash' >"$script"
  echo "source 'lib/import.bash'" >>"$script"
  echo "unset -f 'abort'" >>"$script"
  echo "unset -f 'log'" >>"$script"
  echo 'test() {' >>"$script"
  echo "import 'foo'" >>"$script"
  echo "echo 'unreachable'" >>"$script"
  echo '}' >>"$script"
  echo 'test' >>"$script"
  chmod u+x "$script"

  run "$script"

  ((status == 3))
  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == *'[import]'* ]]
  [[ "${lines[0]}" == *'unknown function: foo' ]]
  [[ "${lines[1]}" == "         at $BATS_TEST_TMPDIR/test.bash (line: 6)" ]]
  [[ "${lines[2]}" == "         at $BATS_TEST_TMPDIR/test.bash (line: 9)" ]]
}
