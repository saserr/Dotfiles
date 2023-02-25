#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
}

@test "returns the location of the current function when level is 0" {
  load '../helpers/import.bash'
  import 'file::write'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'caller::location'" \
    'bar() { baz; }' \
    'baz() { caller::location 0; }' \
    'bar'
  chmod +x "$script"

  run "$script"

  ((status == 0))
  [[ "$output" == "$script (line: 5)" ]]
}

@test "returns the location of the calling function when level is 1" {
  load '../helpers/import.bash'
  import 'file::write'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'caller::location'" \
    'bar() { baz; }' \
    'baz() { caller::location 1; }' \
    'bar'
  chmod +x "$script"

  run "$script"

  ((status == 0))
  [[ "$output" == "$script (line: 4)" ]]
}

@test "returns the location of the caller's calling function when level is 2" {
  load '../helpers/import.bash'
  import 'file::write'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'caller::location'" \
    'bar() { baz; }' \
    'baz() { caller::location 2; }' \
    'bar'
  chmod +x "$script"

  run "$script"

  ((status == 0))
  [[ "$output" == "$script (line: 6)" ]]
}

@test "fails if it is invoked directly in the shell" {
  run /usr/bin/env bash -c "source 'lib/import.bash' && import 'caller::location' && caller::location 0"

  ((status == 1))
  [[ "$output" == '' ]]
}

@test "fails if level is invalid" {
  load '../helpers/import.bash'
  import 'file::write'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'caller::location'" \
    'caller::location 1'
  chmod +x "$script"

  run "$script"

  ((status == 1))
  [[ "$output" == '' ]]
}
