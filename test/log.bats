#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  load helpers/assert/wrong_usage

  import 'log'
  import 'text::contains'
  import 'text::ends_with'
}

@test "fails without arguments" {
  run log

  assert::wrong_usage 'log' 'color' 'tag' 'message' '...'
}

@test "fails with only the color argument" {
  run log '0'

  assert::wrong_usage 'log' 'color' 'tag' 'message' '...'
}

@test "fails with only the color and tag arguments" {
  run log '0' 'foo'

  assert::wrong_usage 'log' 'color' 'tag' 'message' '...'
}

@test "the output contains the tag and the message and uses the color" {
  run log '0;34' 'foo' 'bar'

  [ "$status" -eq 0 ]
  [ "$output" = "$(echo -e '\033[0;34m[foo]\033[0m bar')" ]
}

@test "the output contains any additional messages" {
  run log '0' 'foo' 'bar' 'baz'

  [ "$status" -eq 0 ]
  [ "${lines[1]}" = '      baz' ]
}

@test "log::info uses the green color" {
  run log::info 'foo' 'bar'

  [ "$status" -eq 0 ]
  [ "$output" = "$(echo -e '\033[0;32m[foo]\033[0m bar')" ]
}

@test "log::warn uses the bold yellow color" {
  run log::warn 'foo' 'bar'

  [ "$status" -eq 0 ]
  [ "$output" = "$(echo -e '\033[1;33m[foo]\033[0m bar')" ]
}

@test "log::error uses the bold red color" {
  run log::error 'foo' 'bar'

  [ "$status" -eq 0 ]
  [ "$output" = "$(echo -e '\033[1;31m[foo]\033[0m bar')" ]
}
