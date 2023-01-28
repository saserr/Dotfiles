#!/usr/bin/env bats

setup() {
  load ../helpers/assert/wrong_usage

  source src/arguments/expect.bash
  source src/text/contains.bash
  source src/text/ends_with.bash
}

@test "fails without arguments" {
  run arguments::expect

  assert::wrong_usage 'arguments::expect' '$#' '[name]' '...'
}

@test "succeeds when no arguments are expected and there were none" {
  run arguments::expect 0

  [ "$status" -eq 0 ]
}

@test "fails when no arguments are expected but there was one" {
  run arguments::expect 1

  [ "$status" -eq 2 ]
}

@test "fails when an argument is expected but there were none" {
  run arguments::expect 0 'bar'

  [ "$status" -eq 2 ]
}

@test "succeeds when an argument is expected and there was one" {
  run arguments::expect 1 'foo'

  [ "$status" -eq 0 ]
}

@test "fails when an argument is expected but there was more than one" {
  run arguments::expect 2 'bar'

  [ "$status" -eq 2 ]
}

@test "fails when two arguments are expected but there were none" {
  run arguments::expect 0 'bar' 'baz'

  [ "$status" -eq 2 ]
}

@test "fails when two arguments are expected but there is only one" {
  run arguments::expect 1 'bar' 'baz'

  [ "$status" -eq 2 ]
}

@test "succeeds when two arguments are expected and there were two" {
  run arguments::expect 2 'foo' 'bar'

  [ "$status" -eq 0 ]
}

@test "succeeds when an optional argument is expected and there were none" {
  run arguments::expect 0 '[foo]'

  [ "$status" -eq 0 ]
}

@test "succeeds when an optional argument is expected and there was one" {
  run arguments::expect 1 '[foo]'

  [ "$status" -eq 0 ]
}

@test "fails when an optional argument is expected but there was more than one" {
  run arguments::expect 2 '[bar]'

  [ "$status" -eq 2 ]
}

@test "succeeds when vararg is expected and there were none" {
  run arguments::expect 0 '...'

  [ "$status" -eq 0 ]
}

@test "succeeds when vararg is expected and there was one" {
  run arguments::expect 1 '...'

  [ "$status" -eq 0 ]
}

@test "succeeds when vararg is expected but there was more than one" {
  run arguments::expect 2 '...'

  [ "$status" -eq 0 ]
}

@test "failure message mentions the function name and the reason" {
  foo() {
    arguments::expect 1
  }

  run foo

  text::contains "${lines[0]}" 'foo'
  text::contains "${lines[0]}" 'wrong number of arguments'
}

@test "failure message mentions the actual number of arguments" {
  run arguments::expect 1 'foo' 'bar'

  text::ends_with "${lines[1]}" 'actual: 1'
}

@test "failure message mentions expected arguments" {
  run arguments::expect 0 'foo'

  text::ends_with "${lines[2]}" 'expected: 1'
  text::ends_with "${lines[3]}" 'arguments: foo'
}

@test "failure message mentions optional arguments" {
  run arguments::expect 0 'foo' '[bar]'

  text::ends_with "${lines[2]}" 'expected: 1 (+ 1 optional)'
  text::ends_with "${lines[3]}" 'arguments: foo [bar]'
}

@test "failure message mentions vararg" {
  run arguments::expect 0 'foo' '...'

  text::ends_with "${lines[2]}" 'expected: 1 (or more)'
  text::ends_with "${lines[3]}" 'arguments: foo ...'
}

@test "failure message only mentions vararg even if there is an optional argument" {
  run arguments::expect 0 'foo' '[bar]' '...'

  text::ends_with "${lines[2]}" 'expected: 1 (or more)'
  text::ends_with "${lines[3]}" 'arguments: foo [bar] ...'
}

@test "failure message does not mention arguments when none are expected" {
  run arguments::expect 1

  [ "${lines[3]}" = '' ]
}

@test "failure message mentions the current program if it is invoked outside of a function" {
  run bash -c 'source src/arguments/expect.bash && arguments::expect 1'

  text::contains "${lines[0]}" 'bash'
  text::contains "${lines[0]}" 'wrong number of arguments'
}

@test "exits when it fails" {
  fail() {
    echo 'foo'
    arguments::expect 1 2>/dev/null
    echo 'bar'
  }

  run fail

  [ "$output" = 'foo' ]
}
