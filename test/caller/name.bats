#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'caller::name'
}

@test "returns the name of the calling function" {
  foo() { bar; }
  bar() { caller::name; }

  run foo

  ((status == 0))
  [[ "$output" == 'foo' ]]
}

@test "returns the shell name if it is invoked directly in the shell" {
  run /usr/bin/env bash -c "source 'lib/import.bash' && import 'caller::name' && caller::name"

  ((status == 0))
  [[ "$output" == 'bash' ]]
}

@test "returns the script name if it is invoked directly in the script" {
  local foo="$BATS_TEST_TMPDIR/foo"
  echo '#!/usr/bin/env bash' >>"$foo"
  echo "source 'lib/import.bash' && import 'caller::name' && caller::name" >>"$foo"
  chmod +x "$foo"

  run "$foo"

  ((status == 0))
  [[ "$output" == "$foo" ]]
}
