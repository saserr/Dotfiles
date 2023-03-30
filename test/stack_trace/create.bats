#!/usr/bin/env bats

setup() {
  load '../setup.bash'
}

@test "\$STACK_TRACE contains the stack trace" {
  load '../helpers/import.bash'
  import 'file::write'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/configure.bash'" \
    "import 'stack_trace::create'" \
    'stack_trace::create' \
    'printf "%s\n" "${STACK_TRACE[@]}"'
  chmod +x "$script"

  run "$script"

  ((status == 0))
  [[ "$output" == "at $script (line: 4)" ]]
}

@test "\$STACK_TRACE contains the stack trace across function calls" {
  load '../helpers/import.bash'
  import 'file::write'

  local foo="$BATS_TEST_TMPDIR/foo.bash"
  file::write "$foo" \
    "import 'stack_trace::create'" \
    'foo() {' \
    'stack_trace::create' \
    'printf "%s\n" "${STACK_TRACE[@]}"' \
    '}'
  local bar="$BATS_TEST_TMPDIR/bar.bash"
  file::write "$bar" \
    "import 'foo'" \
    'bar() { foo; }'
  local baz="$BATS_TEST_TMPDIR/baz"
  file::write "$baz" \
    '#!/usr/bin/env bash' \
    "IMPORT_PATH=('$BATS_TEST_TMPDIR')" \
    "source 'lib/configure.bash'" \
    "import 'bar'" \
    'bar'
  chmod +x "$baz"

  run "$baz"

  ((status == 0))
  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == "at $foo (line: 3)" ]]
  [[ "${lines[1]}" == "at $bar (line: 2)" ]]
  [[ "${lines[2]}" == "at $baz (line: 5)" ]]
}

@test "\$STACK_TRACE does not contain stack trace when invoked directly in the shell" {
  run /usr/bin/env bash -c "source 'lib/configure.bash' \
    && import 'stack_trace::create' \
    && stack_trace::create \
    && printf '%s\n' \"${STACK_TRACE[@]}\""

  ((status == 0))
  [[ "$output" == '' ]]
}

@test "\$STACK_TRACE will skip a file if it is in \$SKIP_ON_STACK_TRACE" {
  load '../helpers/import.bash'
  import 'file::write'

  local foo="$BATS_TEST_TMPDIR/foo.bash"
  file::write "$foo" \
    "import 'stack_trace::create'" \
    'foo() {' \
    'stack_trace::create' \
    'printf "%s\n" "${STACK_TRACE[@]}"' \
    '}'
  local bar="$BATS_TEST_TMPDIR/bar.bash"
  file::write "$bar" \
    "import 'foo'" \
    'SKIP_ON_STACK_TRACE+=("${BASH_SOURCE[0]}")' \
    'bar() { foo; }'
  local baz="$BATS_TEST_TMPDIR/baz"
  file::write "$baz" \
    '#!/usr/bin/env bash' \
    "IMPORT_PATH=('$BATS_TEST_TMPDIR')" \
    "source 'lib/configure.bash'" \
    "import 'bar'" \
    'bar'
  chmod +x "$baz"

  run "$baz"

  ((status == 0))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == "at $foo (line: 3)" ]]
  [[ "${lines[1]}" == "at $baz (line: 5)" ]]
}
