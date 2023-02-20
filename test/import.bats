#!/usr/bin/env bats

@test "declares the 'import' function" {
  ! declare -F 'import'

  source 'lib/import.bash'

  declare -F 'import'
}

@test "fails without arguments" {
  source 'lib/import.bash'
  run import

  load helpers/assert/wrong_usage
  assert::wrong_usage 'import' 'function'
}

@test "imports a missing function" {
  ! declare -F 'arguments::expect'

  source 'lib/import.bash'
  import 'arguments::expect'

  declare -F 'arguments::expect'
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

@test "fails if an unknown function is imported" {
  source 'lib/import.bash'
  run import 'foo'

  ! declare -F 'foo'
  ((status == 2))
  [[ "${lines[1]}" == *'import'* ]]
  [[ "${lines[1]}" == *"can't load the 'foo' function"* ]]
}

@test "exits if an unknown function is imported" {
  fail() {
    echo 'foo'
    import 'bar' 2>/dev/null
    echo 'baz'
  }

  source 'lib/import.bash'
  run fail

  ((status == 2))
  [[ "$output" == 'foo' ]]
}

@test "uses \$LIB_DIR for the location of function files" {
  LIB_DIR="$BATS_TEST_TMPDIR"
  echo 'foo() { echo "bar"; }' >"$LIB_DIR/foo.bash"
  ! declare -F 'foo'

  source 'lib/import.bash'
  import 'foo'

  declare -F 'foo'
}

@test "validates that correct function has been imported" {
  LIB_DIR="$BATS_TEST_TMPDIR"
  echo '' >"$LIB_DIR/foo.bash"

  source 'lib/import.bash'
  run import 'foo'

  ((status == 2))
  [[ "${lines[0]}" == *'import'* ]]
  [[ "${lines[0]}" == *"the 'foo' function is missing in $LIB_DIR/foo.bash" ]]
}
