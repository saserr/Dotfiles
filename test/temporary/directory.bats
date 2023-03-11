#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'temporary::directory'
}

@test "outputs a path to a directory under \$TMPDIR or /tmp if no path is provided" {
  import 'text::starts_with'

  run temporary::directory

  ((status == 0))
  text::starts_with "$output" "${TMPDIR:-/tmp}"
  [[ -d "$output" ]]
}

@test "outputs a path to a directory under the provided path" {
  import 'text::starts_with'

  run temporary::directory "$BATS_TEST_TMPDIR"

  ((status == 0))
  text::starts_with "$output" "$BATS_TEST_TMPDIR"
  [[ -d "$output" ]]
}

@test "fails if mktemp fails" {
  load '../helpers/mocks/stub.bash'

  stub mktemp 'exit 1'

  run temporary::directory

  unstub mktemp
  ((status == 1))
  [[ "$output" == '' ]]
}

@test "fails if the provided path does not exist" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails temporary::directory "$BATS_TEST_TMPDIR/foo"
}
