#!/usr/bin/env bats

setup() {
  load 'setup.bash'
  import 'log'
}

@test "fails without arguments" {
  load 'helpers/import.bash'
  import 'assert::wrong_usage'

  run log

  assert::wrong_usage 'log' 'level' 'tag' 'message' '...'
}

@test "fails with only the level argument" {
  load 'helpers/import.bash'
  import 'assert::wrong_usage'

  run log info

  assert::wrong_usage 'log' 'level' 'tag' 'message' '...'
}

@test "fails with only the level and tag arguments" {
  load 'helpers/import.bash'
  import 'assert::wrong_usage'

  run log info 'bar'

  assert::wrong_usage 'log' 'level' 'tag' 'message' '...'
}

@test "the output contains the tag and the message" {
  test_log_color='0;34' # blue

  run log test 'foo' 'bar'

  ((status == 0))
  [[ "$output" == "$(echo -e '\033[0;34m[foo]\033[0m bar')" ]]
}

@test "the output contains any additional messages" {
  test_log_color='0;34' # blue

  run log test 'foo' 'bar' 'baz'

  ((status == 0))
  ((${#lines[@]} == 2))
  [[ "${lines[1]}" == '      baz' ]]
}

@test "ignores any additional empty messages" {
  test_log_color='0;34' # blue

  run log test 'foo' 'bar' '' 'baz'

  ((status == 0))
  ((${#lines[@]} == 2))
  [[ "${lines[1]}" == '      baz' ]]
}

@test "the empty level prints a warning and uses no color" {
  run log '' 'foo' 'bar'

  ((status == 0))
  [[ "${lines[0]}" == "$(log warn 'log' 'expected nonempty argument: level')" ]]
  [[ "${lines[1]}" == '[foo] bar' ]]
}

@test "fails if tag is empty" {
  load 'helpers/import.bash'
  import 'assert::exits'
  import 'log'

  test_log_color='0;34' # blue

  assert::exits log test '' 'bar'

  ((status == 3))
  [[ "${lines[0]}" == "$(log error 'log' 'expected nonempty argument: tag')" ]]
}

@test "fails if the first message is empty" {
  load 'helpers/import.bash'
  import 'assert::exits'
  import 'log'

  test_log_color='0;34' # blue

  assert::exits log test 'foo' ''

  ((status == 3))
  [[ "${lines[0]}" == "$(log error 'log' 'expected nonempty argument: message')" ]]
}

@test "the trace level uses no color" {
  run log trace 'foo' 'bar'

  ((status == 0))
  [[ "$output" == '[foo] bar' ]]
}

@test "the info level uses the green color" {
  run log info 'foo' 'bar'

  ((status == 0))
  [[ "$output" == "$(echo -e '\033[0;32m[foo]\033[0m bar')" ]]
}

@test "the warn level uses the bold yellow color" {
  run log warn 'foo' 'bar'

  ((status == 0))
  [[ "$output" == "$(echo -e '\033[1;33m[foo]\033[0m bar')" ]]
}

@test "the error level uses the bold red color" {
  run log error 'foo' 'bar'

  ((status == 0))
  [[ "$output" == "$(echo -e '\033[1;31m[foo]\033[0m bar')" ]]
}

@test "an unknown level prints a warning and uses no color" {
  run log test 'foo' 'bar'

  ((status == 0))
  [[ "${lines[0]}" == "$(log warn 'log' 'expected variable: $test_log_color')" ]]
  [[ "${lines[1]}" == '[foo] bar' ]]
}
