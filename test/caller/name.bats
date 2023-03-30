#!/usr/bin/env bats

setup() {
  load '../setup.bash'
  import 'caller::name'
}

@test "returns the name of the calling function when functions are declared" {
  foo() { caller::name; }
  bar() { foo; }

  run bar

  ((status == 0))
  [[ "$output" == 'bar' ]]
}

@test "returns the name of the calling function when functions are imported" {
  load '../helpers/import.bash'
  import 'file::write'

  file::write "$BATS_TEST_TMPDIR/foo.bash" \
    "import 'caller::name'" \
    'foo() { caller::name; }'
  file::write "$BATS_TEST_TMPDIR/bar.bash" \
    "import 'foo'" \
    'bar() { foo; }'

  IMPORT_PATH+=("$BATS_TEST_TMPDIR")
  import 'bar'

  run bar

  ((status == 0))
  [[ "$output" == 'bar' ]]
}

@test "returns the shell name when invoked directly in the shell" {
  run /usr/bin/env bash -c "source 'lib/configure.bash' \
    && import 'caller::name' \
    && caller::name"

  ((status == 0))
  [[ "$output" == 'bash' ]]
}

@test "returns the script name when invoked directly in the script" {
  load '../helpers/import.bash'
  import 'file::write'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/configure.bash'" \
    "import 'caller::name'" \
    'caller::name'
  chmod +x "$script"

  run "$script"

  ((status == 0))
  [[ "$output" == "$script" ]]
}
