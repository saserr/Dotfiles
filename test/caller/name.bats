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

@test "returns the shell name when invoked directly in the shell" {
  run /usr/bin/env bash -c "source 'lib/import.bash' && import 'caller::name' && caller::name"

  ((status == 0))
  [[ "$output" == 'bash' ]]
}

@test "returns the script name when invoked directly in the script" {
  load '../helpers/import.bash'
  import 'file::write'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'caller::name'" \
    'caller::name'
  chmod +x "$script"

  run "$script"

  ((status == 0))
  [[ "$output" == "$script" ]]
}
