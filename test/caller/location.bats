#!/usr/bin/env bats

@test "returns the location of the current function when level is 0" {
  local foo="$BATS_TEST_TMPDIR/foo"
  echo '#!/usr/bin/env bash' >>"$foo"
  echo "source 'lib/import.bash'" >>"$foo"
  echo "import 'caller::location'" >>"$foo"
  echo 'bar() { baz; }' >>"$foo"
  echo 'baz() { caller::location 0; }' >>"$foo"
  echo 'bar' >>"$foo"
  chmod +x "$foo"

  run "$foo"

  ((status == 0))
  [[ "$output" == "$foo (line: 5)" ]]
}

@test "returns the location of the calling function when level is 1" {
  local foo="$BATS_TEST_TMPDIR/foo"
  echo '#!/usr/bin/env bash' >>"$foo"
  echo "source 'lib/import.bash'" >>"$foo"
  echo "import 'caller::location'" >>"$foo"
  echo 'bar() { baz; }' >>"$foo"
  echo 'baz() { caller::location 1; }' >>"$foo"
  echo 'bar' >>"$foo"
  chmod +x "$foo"

  run "$foo"

  ((status == 0))
  [[ "$output" == "$foo (line: 4)" ]]
}

@test "returns the location of the caller's calling function when level is 2" {
  local foo="$BATS_TEST_TMPDIR/foo"
  echo '#!/usr/bin/env bash' >>"$foo"
  echo "source 'lib/import.bash'" >>"$foo"
  echo "import 'caller::location'" >>"$foo"
  echo 'bar() { baz; }' >>"$foo"
  echo 'baz() { caller::location 2; }' >>"$foo"
  echo 'bar' >>"$foo"
  chmod +x "$foo"

  run "$foo"

  ((status == 0))
  [[ "$output" == "$foo (line: 6)" ]]
}

@test "fails if it is invoked directly in the shell" {
  run /usr/bin/env bash -c "source 'lib/import.bash' && import 'caller::location' && caller::location 0"

  ((status == 1))
  [[ "$output" == '' ]]
}

@test "fails if level is invalid" {
  local foo="$BATS_TEST_TMPDIR/foo"
  echo '#!/usr/bin/env bash' >>"$foo"
  echo "source 'lib/import.bash'" >>"$foo"
  echo "import 'caller::location'" >>"$foo"
  echo 'caller::location 1' >>"$foo"
  chmod +x "$foo"

  run "$foo"

  ((status == 1))
  [[ "$output" == '' ]]
}
