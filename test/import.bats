#!/usr/bin/env bats

@test "declares the 'import' function" {
  ! type -t 'import'

  source 'lib/import.bash'

  [ "$(type -t 'import')" = 'function' ]
}

@test "fails without arguments" {
  source 'lib/import.bash'
  run import

  load helpers/assert/wrong_usage
  assert::wrong_usage 'import' 'function'
}

@test "imports a missing function" {
  ! type -t 'arguments::expect'

  source 'lib/import.bash'
  import 'arguments::expect'

  [ "$(type -t 'arguments::expect')" = 'function' ]
}

@test "doesn't do anything if function already exists" {
  platform::name() { echo 'foo'; }
  local expected="$(type 'platform::name')"
  [[ "$expected" == *'foo'* ]]

  source 'lib/import.bash'
  import 'platform::name'

  # check that the above function is still the one declared as platform::name
  [ "$(type 'platform::name')" = "$expected" ]
}

@test "fails if an unknown function is imported" {
  source 'lib/import.bash'
  run import 'foo'

  ! type -t 'foo'
  [ "$status" -eq 2 ]
  [[ "${lines[0]}" == *"import"* ]]
  [[ "${lines[0]}" == *"can't load the 'foo' function"* ]]
}

@test "exists if an unknown function is imported" {
  fail() {
    echo 'foo'
    import 'bar'
    echo 'baz'
  }

  source 'lib/import.bash'
  run fail

  # check that output does not contain 'baz'
  [[ "$output" != *'baz'* ]]
}

@test "uses \$LIB_DIR for the location of function files" {
  LIB_DIR="$BATS_TEST_TMPDIR"
  echo 'foo() { echo "bar"; }' >"$LIB_DIR/foo.bash"
  ! type -t 'foo'

  source 'lib/import.bash'
  import 'foo'

  [ "$(type -t 'foo')" = 'function' ]
}

@test "validates that correct function has been imported" {
  LIB_DIR="$BATS_TEST_TMPDIR"
  echo '' >"$LIB_DIR/foo.bash"

  source 'lib/import.bash'
  run import 'foo'

  [ "$status" -eq 2 ]
  [[ "${lines[0]}" == *"import"* ]]
  [[ "${lines[0]}" == *"the 'foo' function is missing in $LIB_DIR/foo.bash" ]]
}
