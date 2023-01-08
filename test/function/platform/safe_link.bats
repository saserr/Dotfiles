#!/usr/bin/env bats

setup() {
  source function/platform/safe_link

  from="$BATS_TEST_TMPDIR/from"
  [ ! -e "$from" ] # $from does not exist

  to="$BATS_TEST_TMPDIR/to"
  [ ! -e "$to" ] # $to does not exist
}

@test "makes a symlink from \$from to \$to if \$to does not exist" {
  echo 'foo' >"$from"

  run platform::safe_link 'test' "$from" "$to"

  [ $status -eq 0 ]
  [ "$output" = "[test] $to will be linked to $from" ]
  [ -L "$to" ] # $to is a symlink
  [ "$(cat "$to")" = 'foo' ]
}

@test "asks if \$to should be replaced if \$to exists" {
  echo 'foo' >"$from"
  echo 'bar' >"$to"
  eof=$'\x04'

  run platform::safe_link 'test' "$from" "$to" <<<"$eof"

  [ "${lines[0]}" = "[test] $to will be linked to $from" ]
  [ "${lines[1]}" = "[test] $to exists; do you want to replace it (Yes / No)?" ]
  [ "${lines[2]}" = '1) Yes' ]
  [ "${lines[3]}" = '2) No' ]
}

@test "moves \$to to \$to.old if \$to exists and a positive answer is given at the prompt" {
  echo 'foo' >"$from"
  echo 'bar' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<'1'

  [ $status -eq 0 ]
  [ "${lines[4]}" = "#? [test] old $to will be moved to $to.old" ]
  [ -f "$to.old" ] # $to.old is a file
  [ "$(cat "$to.old")" = 'bar' ]
}

@test "makes a symlink from \$from to \$to if \$to exists and a positive answer is given at the prompt" {
  echo 'foo' >"$from"
  echo 'bar' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<'1'

  [ $status -eq 0 ]
  [ -L "$to" ] # $to is a symlink
  [ "$(cat "$to")" = 'foo' ]
}

@test "fails and leaves things unchanged if \$to.old exists" {
  echo 'foo' >"$from"
  echo 'bar' >"$to"
  echo 'baz' >"$to.old"

  run platform::safe_link 'test' "$from" "$to"

  [ $status -eq 1 ]
  [ "${lines[1]}" = "[test] both $to and $to.old already exist; aborting!" ]
  [ -f "$to" ] # $to is still a file
  [ "$(cat "$to")" = 'bar' ]
  [ -f "$to.old" ] # $to.old is a file
  [ "$(cat "$to.old")" = 'baz' ]
}

@test "fails and leaves things unchanged if \$to exists and a negative answer is given at the prompt" {
  echo 'foo' >"$from"
  echo 'bar' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<'2'

  [ $status -eq 1 ]
  [ "${lines[4]}" = "#? [test] $to will not be linked" ]
  [ -f "$to" ] # $to is still a file
  [ "$(cat "$to")" = 'bar' ]
  [ ! -e "$to.old" ] # $to.old does not exist
}

@test "fails and leaves things unchanged if \$from does not exist" {
  run platform::safe_link 'test' "$from" "$to"

  [ $status -eq 1 ]
  [ "${lines[0]}" = "[test] $to will be linked to $from" ]
  [ "${lines[1]}" = "[test] $from does not exist; aborting!" ]
  [ ! -e "$from" ] # $from does not exist
  [ ! -e "$to" ]   # $to does not exist
}
