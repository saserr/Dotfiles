#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'log'
}

@test "fails without arguments" {
  load 'helpers/import.bash'
  import 'assert::wrong_usage'

  run log

  assert::wrong_usage 'log' 'color' 'tag' 'message' '...'
}

@test "fails with only the color argument" {
  load 'helpers/import.bash'
  import 'assert::wrong_usage'

  run log '0'

  assert::wrong_usage 'log' 'color' 'tag' 'message' '...'
}

@test "fails with only the color and tag arguments" {
  load 'helpers/import.bash'
  import 'assert::wrong_usage'

  run log '0' 'foo'

  assert::wrong_usage 'log' 'color' 'tag' 'message' '...'
}

@test "the output contains the tag and the message and uses the color" {
  run log '0;34' 'foo' 'bar'

  ((status == 0))
  [[ "$output" == "$(echo -e '\033[0;34m[foo]\033[0m bar')" ]]
}

@test "the output doesn't have color if the color argument is empty" {
  run log '' 'foo' 'bar'

  ((status == 0))
  [[ "$output" == "$(echo '[foo] bar')" ]]
}

@test "the output contains any additional messages" {
  run log '0' 'foo' 'bar' 'baz'

  ((status == 0))
  ((${#lines[@]} == 2))
  [[ "${lines[1]}" == '      baz' ]]
}

@test "ignores any additional empty messages" {
  run log '0' 'foo' 'bar' '' 'baz'

  ((status == 0))
  ((${#lines[@]} == 2))
  [[ "${lines[1]}" == '      baz' ]]
}

@test "fails if tag is empty" {
  load 'helpers/import.bash'
  import 'assert::exits'
  import 'log::error'

  assert::exits log '0' '' 'bar'

  ((status == 2))
  [[ "${lines[0]}" == "$(log::error 'log' 'expected nonempty argument: tag')" ]]
}

@test "fails if the first message is empty" {
  load 'helpers/import.bash'
  import 'assert::exits'
  import 'log::error'

  assert::exits log '0' 'foo' ''

  ((status == 2))
  [[ "${lines[0]}" == "$(log::error 'log' 'expected nonempty argument: message')" ]]
}
