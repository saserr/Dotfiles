#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'temporary::directory'
}

@test "creates a directory under \$TMPDIR or /tmp if no path is provided" {
  import 'text::starts_with'

  local dir="$(temporary::directory)"

  [[ -d "$dir" ]]
  text::starts_with "$dir" "${TMPDIR:-/tmp}"
}

@test "creates a directory under the given path" {
  import 'text::starts_with'

  local dir="$(temporary::directory "$BATS_TEST_TMPDIR")"

  echo "$dir"

  [[ -d "$dir" ]]
  text::starts_with "$dir" "$BATS_TEST_TMPDIR"
}
