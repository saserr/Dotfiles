#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'temporary::file'
}

@test "outputs a path to an empty file under \$TMPDIR or /tmp if no path is provided" {
  import 'file::empty'
  import 'file::exists'
  import 'text::starts_with'

  run temporary::file

  ((status == 0))
  text::starts_with "$output" "${TMPDIR:-/tmp}"
  file::exists "$output"
  file::empty "$output"
}

@test "outputs a path to an empty file under the provided path" {
  import 'file::empty'
  import 'file::exists'
  import 'text::starts_with'

  run temporary::file "$BATS_TEST_TMPDIR"

  ((status == 0))
  text::starts_with "$output" "$BATS_TEST_TMPDIR"
  file::exists "$output"
  file::empty "$output"
}

@test "fails if mktemp fails" {
  load '../helpers/mocks/stub.bash'

  stub mktemp 'exit 1'

  run temporary::file

  unstub mktemp
  ((status == 1))
  [[ "$output" == '' ]]
}

@test "fails if the provided path does not exist" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails temporary::file "$BATS_TEST_TMPDIR/foo"
}
