#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'platform::safe_link'

  from="$BATS_TEST_TMPDIR/from"
  [ ! -e "$from" ] # $from does not exist

  to="$BATS_TEST_TMPDIR/to"
  [ ! -e "$to" ] # $to does not exist
}

@test "fails without arguments" {
  load ../helpers/assert/wrong_usage

  run platform::safe_link

  assert::wrong_usage 'platform::safe_link' 'name' 'from' 'to'
}

@test "fails with only one argument" {
  load ../helpers/assert/wrong_usage

  run platform::safe_link 'test'

  assert::wrong_usage 'platform::safe_link' 'name' 'from' 'to'
}

@test "fails with only two arguments" {
  load ../helpers/assert/wrong_usage

  run platform::safe_link 'test' "$from"

  assert::wrong_usage 'platform::safe_link' 'name' 'from' 'to'
}

@test "makes a symlink from \$from to \$to if \$to does not exist" {
  import 'log'

  echo 'foo' >"$from"

  run platform::safe_link 'test' "$from" "$to" <<<''

  [ $status -eq 0 ]
  [ "$output" = "$(log::info 'test' "$to will be linked to $from")" ]
  [ -L "$to" ] # $to is a symlink
  [ "$(cat "$to")" = 'foo' ]
}

@test "asks if \$to should be replaced if \$to exists" {
  import 'log'
  import 'text::contains'

  echo 'foo' >"$from"
  echo 'bar' >"$to"
  eof=$'\x04'

  run platform::safe_link 'test' "$from" "$to" <<<"$eof"

  [ $status -eq 1 ]
  [ "${lines[0]}" = "$(log::info 'test' "$to will be linked to $from")" ]
  text::contains "${lines[1]}" 'test'
  text::contains "${lines[1]}" "$to exists; do you want to replace it? [Y/n]"
}

@test "moves \$to to \$to.old if \$to exists and a positive answer is given at the prompt" {
  import 'log'
  import 'text::ends_with'

  echo 'foo' >"$from"
  echo 'bar' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<'y'

  [ $status -eq 0 ]
  text::ends_with "${lines[1]}" "$(log::info 'test' "old $to will be moved to $to.old")"
  [ -f "$to.old" ] # $to.old is a file
  [ "$(cat "$to.old")" = 'bar' ]
}

@test "makes a symlink from \$from to \$to if \$to exists and a positive answer is given at the prompt" {
  echo 'foo' >"$from"
  echo 'bar' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<'y'

  [ $status -eq 0 ]
  [ -L "$to" ] # $to is a symlink
  [ "$(cat "$to")" = 'foo' ]
}

@test "fails and leaves things unchanged if \$to.old exists" {
  import 'log'

  echo 'foo' >"$from"
  echo 'bar' >"$to"
  echo 'baz' >"$to.old"

  run platform::safe_link 'test' "$from" "$to"

  [ $status -eq 1 ]
  [ "${lines[1]}" = "$(log::error 'test' "both $to and $to.old already exist; aborting!")" ]
  [ -f "$to" ] # $to is still a file
  [ "$(cat "$to")" = 'bar' ]
  [ -f "$to.old" ] # $to.old is a file
  [ "$(cat "$to.old")" = 'baz' ]
}

@test "fails and leaves things unchanged if \$to exists and a negative answer is given at the prompt" {
  import 'log'
  import 'text::ends_with'

  echo 'foo' >"$from"
  echo 'bar' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<'n'

  [ $status -eq 1 ]
  text::ends_with "${lines[1]}" "$(log::info 'test' "$to will not be linked")"
  [ -f "$to" ] # $to is still a file
  [ "$(cat "$to")" = 'bar' ]
  [ ! -e "$to.old" ] # $to.old does not exist
}

@test "fails and leaves things unchanged if \$from does not exist" {
  import 'log'

  run platform::safe_link 'test' "$from" "$to"

  [ $status -eq 1 ]
  [ "${lines[0]}" = "$(log::info 'test' "$to will be linked to $from")" ]
  [ "${lines[1]}" = "$(log::error 'test' "$from does not exist; aborting!")" ]
  [ ! -e "$from" ] # $from does not exist
  [ ! -e "$to" ]   # $to does not exist
}
