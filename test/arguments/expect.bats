#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'arguments::expect'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'capture::stderr'
  import 'file::write'
  import 'log'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'arguments::expect'" \
    "foo() { arguments::expect; }" \
    'foo' \
    "echo 'unreachable'"
  chmod +x "$script"

  run "$script"

  ((status == 3))
  ((${#lines[@]} == 6))
  [[ "${lines[0]}" == "$(capture::stderr log error 'arguments::expect' 'wrong number of arguments')" ]]
  [[ "${lines[1]}" == '                    actual: 0' ]]
  [[ "${lines[2]}" == '                    expected: 1 (or more)' ]]
  [[ "${lines[3]}" == '                    arguments: $# [name] ...' ]]
  [[ "${lines[4]}" == "                    at $script (line: 4)" ]]
  [[ "${lines[5]}" == "                    at $script (line: 5)" ]]
}

@test "fails when first argument is not an integer" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'capture::stderr'
  import 'file::write'
  import 'log'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'arguments::expect'" \
    "foo() { arguments::expect 'bar'; }" \
    'foo' \
    "echo 'unreachable'"
  chmod +x "$script"

  run "$script"

  ((status == 3))
  ((${#lines[@]} == 4))
  [[ "${lines[0]}" == "$(capture::stderr log error 'arguments::expect' 'expected integer argument: $#')" ]]
  [[ "${lines[1]}" == '                    actual: bar' ]]
  [[ "${lines[2]}" == "                    at $script (line: 4)" ]]
  [[ "${lines[3]}" == "                    at $script (line: 5)" ]]
}

@test "succeeds when no arguments are expected and there were none" {
  run arguments::expect 0

  ((status == 0))
  [[ "$output" == '' ]]
}

@test "fails when no arguments are expected but there was one" {
  load '../helpers/import.bash'
  import 'assert::exits'

  assert::exits arguments::expect 1

  ((status == 3))
}

@test "fails when an argument is expected but there were none" {
  load '../helpers/import.bash'
  import 'assert::exits'

  assert::exits arguments::expect 0 'bar'

  ((status == 3))
}

@test "succeeds when an argument is expected and there was one" {
  run arguments::expect 1 'foo'

  ((status == 0))
  [[ "$output" == '' ]]
}

@test "fails when an argument is expected but there was more than one" {
  load '../helpers/import.bash'
  import 'assert::exits'

  assert::exits arguments::expect 2 'bar'

  ((status == 3))
}

@test "fails when two arguments are expected but there were none" {
  load '../helpers/import.bash'
  import 'assert::exits'

  assert::exits arguments::expect 0 'bar' 'baz'

  ((status == 3))
}

@test "fails when two arguments are expected but there is only one" {
  load '../helpers/import.bash'
  import 'assert::exits'

  assert::exits arguments::expect 1 'bar' 'baz'

  ((status == 3))
}

@test "succeeds when two arguments are expected and there were two" {
  run arguments::expect 2 'foo' 'bar'

  ((status == 0))
  [[ "$output" == '' ]]
}

@test "succeeds when an optional argument is expected and there were none" {
  run arguments::expect 0 '[foo]'

  ((status == 0))
  [[ "$output" == '' ]]
}

@test "succeeds when an optional argument is expected and there was one" {
  run arguments::expect 1 '[foo]'

  ((status == 0))
  [[ "$output" == '' ]]
}

@test "fails when an optional argument is expected but there was more than one" {
  load '../helpers/import.bash'
  import 'assert::exits'

  assert::exits arguments::expect 2 '[bar]'

  ((status == 3))
}

@test "succeeds when vararg is expected and there were none" {
  run arguments::expect 0 '...'

  ((status == 0))
  [[ "$output" == '' ]]
}

@test "succeeds when vararg is expected and there was one" {
  run arguments::expect 1 '...'

  ((status == 0))
  [[ "$output" == '' ]]
}

@test "succeeds when vararg is expected but there was more than one" {
  run arguments::expect 2 '...'

  ((status == 0))
  [[ "$output" == '' ]]
}

@test "the failure message contains the function name and the reason" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'log'
  import 'text::starts_with'

  foo() {
    arguments::expect 1
  }

  run foo

  text::starts_with "${lines[0]}" "$(capture::stderr log error 'foo' 'wrong number of arguments')"
}

@test "the failure message contains the actual number of arguments" {
  foo() {
    arguments::expect 1 'foo' 'bar'
  }

  run foo

  [[ "${lines[1]}" == '      actual: 1' ]]
}

@test "the failure message contains expected arguments" {
  foo() {
    arguments::expect 0 'foo'
  }

  run foo

  [[ "${lines[2]}" == '      expected: 1' ]]
  [[ "${lines[3]}" == '      arguments: foo' ]]
}

@test "the failure message contains optional arguments" {
  import 'text::ends_with'

  run arguments::expect 0 'foo' '[bar]'

  text::ends_with "${lines[2]}" 'expected: 1 (+ 1 optional)'
  text::ends_with "${lines[3]}" 'arguments: foo [bar]'
}

@test "the failure message contains vararg" {
  import 'text::ends_with'

  run arguments::expect 0 'foo' '...'

  text::ends_with "${lines[2]}" 'expected: 1 (or more)'
  text::ends_with "${lines[3]}" 'arguments: foo ...'
}

@test "the failure message only contains vararg even if there is an optional argument" {
  import 'text::ends_with'

  run arguments::expect 0 'foo' '[bar]' '...'

  text::ends_with "${lines[2]}" 'expected: 1 (or more)'
  text::ends_with "${lines[3]}" 'arguments: foo [bar] ...'
}

@test "the failure message does not contain arguments when none are expected" {
  load '../helpers/import.bash'
  import 'assert::fails'
  import 'text::contains'

  run arguments::expect 1

  assert::fails text::contains "${lines[3]}" 'arguments:'
}

@test "the failure message contains the stack trace" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'file::write'
  import 'log'
  import 'text::ends_with'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'arguments::expect'" \
    'foo() { arguments::expect 1; }' \
    'foo' \
    "echo 'unreachable'"
  chmod +x "$script"

  run "$script"

  ((${#lines[@]} == 4))
  [[ "${lines[0]}" == "$(capture::stderr log error 'foo' 'wrong number of arguments')" ]]
  [[ "${lines[1]}" == '      actual: 1' ]]
  [[ "${lines[2]}" == '      expected: 0' ]]
  [[ "${lines[3]}" == "      at $script (line: 5)" ]]
}

@test "the failure message contains the shell if it is invoked outside of a function" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'log'

  run /usr/bin/env bash -c "source 'lib/import.bash' && import 'arguments::expect' && arguments::expect 1"

  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == "$(capture::stderr log error 'bash' 'wrong number of arguments')" ]]
  [[ "${lines[1]}" == '       actual: 1' ]]
  [[ "${lines[2]}" == '       expected: 0' ]]
}

@test "the failure message contains the script name if it is invoked outside of a function" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'file::write'
  import 'log'
  import 'text::ends_with'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'arguments::expect'" \
    'arguments::expect 1' \
    "echo 'unreachable'"
  chmod +x "$script"

  run "$script"

  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == "$(capture::stderr log error "$script" 'wrong number of arguments')" ]]
  text::ends_with "${lines[1]}" 'actual: 1'
  text::ends_with "${lines[2]}" 'expected: 0'
}
