#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'arguments::expect'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run arguments::expect

  assert::wrong_usage 'arguments::expect' '$#' '[name]' '...'
}

@test "fails when first argument is not an integer" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run arguments::expect 'foo'

  assert::wrong_usage 'arguments::expect' '$#' '[name]' '...'
}

@test "succeeds when no arguments are expected and there were none" {
  run arguments::expect 0

  ((status == 0))
  [[ "$output" == '' ]]
}

@test "fails when no arguments are expected but there was one" {
  run arguments::expect 1

  ((status == 2))
}

@test "fails when an argument is expected but there were none" {
  run arguments::expect 0 'bar'

  ((status == 2))
}

@test "succeeds when an argument is expected and there was one" {
  run arguments::expect 1 'foo'

  ((status == 0))
  [[ "$output" == '' ]]
}

@test "fails when an argument is expected but there was more than one" {
  run arguments::expect 2 'bar'

  ((status == 2))
}

@test "fails when two arguments are expected but there were none" {
  run arguments::expect 0 'bar' 'baz'

  ((status == 2))
}

@test "fails when two arguments are expected but there is only one" {
  run arguments::expect 1 'bar' 'baz'

  ((status == 2))
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
  run arguments::expect 2 '[bar]'

  ((status == 2))
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
  import 'text::contains'

  foo() {
    arguments::expect 1
  }

  run foo

  text::contains "${lines[0]}" 'foo'
  text::contains "${lines[0]}" 'wrong number of arguments'
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
  run arguments::expect 1

  [[ "${lines[3]}" == '' ]]
}

@test "the failure message contains the shell if it is invoked outside of a function" {
  import 'text::contains'

  run /usr/bin/env bash -c "source 'lib/arguments/expect.bash' && arguments::expect 1"

  text::contains "${lines[0]}" 'bash'
  text::contains "${lines[0]}" 'wrong number of arguments'
}

@test "the failure message contains the script name if it is invoked outside of a function" {
  import 'text::contains'

  local foo="$BATS_TEST_TMPDIR/foo"
  echo '#!/usr/bin/env bash' >>"$foo"
  echo "source 'lib/arguments/expect.bash' && arguments::expect 1" >>"$foo"
  chmod +x "$foo"

  run "$foo"

  text::contains "${lines[0]}" 'foo'
  text::contains "${lines[0]}" 'wrong number of arguments'
}

@test "exits when it fails" {
  fail() {
    echo 'foo'
    arguments::expect 1 2>/dev/null
    echo 'bar'
  }

  run fail

  ((status == 2))
  [[ "$output" == 'foo' ]]
}
