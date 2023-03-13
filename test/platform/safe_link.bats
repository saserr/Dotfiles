#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'platform::safe_link'

  from="$BATS_TEST_TMPDIR/from"
  [[ ! -e "$from" ]] # $from does not exist

  to="$BATS_TEST_TMPDIR/to"
  [[ ! -e "$to" ]] # $to does not exist
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run platform::safe_link

  assert::wrong_usage 'platform::safe_link' 'name' 'from' 'to'
}

@test "fails with only one argument" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run platform::safe_link 'test'

  assert::wrong_usage 'platform::safe_link' 'name' 'from' 'to'
}

@test "fails with only two arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run platform::safe_link 'test' "$from"

  assert::wrong_usage 'platform::safe_link' 'name' 'from' 'to'
}

@test "makes a symlink from \$from to \$to if \$to does not exist" {
  import 'log::trace'
  import 'path::canonicalize'

  echo 'foo' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<''

  ((status == 0))
  [[ "$output" == "$(log::trace 'test' "$from will be linked to $to")" ]]
  [[ -L "$from" ]] # $from is a symlink
  [[ "$(path::canonicalize "$from")" == "$(path::canonicalize "$to")" ]]
}

@test "does nothing if a symlink from \$from to \$to already exists" {
  import 'log::trace'
  import 'path::canonicalize'

  echo 'foo' >"$to"
  ln -s "$to" "$from"

  run platform::safe_link 'test' "$from" "$to" <<<''

  ((status == 0))
  [[ "$output" == "$(log::trace 'test' "$from already links to $to")" ]]
  [[ -L "$from" ]] # $from is a symlink
  [[ "$(path::canonicalize "$from")" == "$(path::canonicalize "$to")" ]]
}

@test "does nothing if a symlink from \$from to \$to already exists when \$from is also a symbolic link" {
  import 'log::trace'
  import 'path::canonicalize'

  foo="$BATS_TEST_TMPDIR/foo"
  echo 'foo' >"$foo"
  ln -s "$foo" "$to"
  ln -s "$to" "$from"

  run platform::safe_link 'test' "$from" "$to" <<<''

  ((status == 0))
  [[ "$output" == "$(log::trace 'test' "$from already links to $to")" ]]
  [[ -L "$from" ]] # $from is a symlink
  [[ "$(path::canonicalize "$from")" == "$(path::canonicalize "$to")" ]]

}

@test "asks if \$from should be replaced if \$from exists" {
  import 'log::trace'
  import 'text::contains'

  echo 'foo' >"$from"
  echo 'bar' >"$to"
  eof=$'\x04'

  run platform::safe_link 'test' "$from" "$to" <<<"$eof"

  ((status == 1))
  [[ "${lines[0]}" == "$(log::trace 'test' "$from will be linked to $to")" ]]
  text::contains "${lines[1]}" 'test'
  text::contains "${lines[1]}" "$from exists; do you want to replace it? [Y/n]"
}

@test "moves \$from to \$from.old if \$from exists and a positive answer is given at the prompt" {
  import 'log::trace'
  import 'text::ends_with'

  echo 'foo' >"$from"
  echo 'bar' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<'y'

  ((status == 0))
  text::ends_with "${lines[1]}" "$(log::trace 'test' "$from will be moved to $from.old")"
  [[ -f "$from.old" ]] # $from.old is a file
  [[ "$(cat "$from.old")" == 'foo' ]]
}

@test "makes a symlink from \$from to \$to if \$from exists and a positive answer is given at the prompt" {
  import 'path::canonicalize'

  echo 'foo' >"$from"
  echo 'bar' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<'y'

  ((status == 0))
  [[ -L "$from" ]] # $from is a symlink
  [[ "$(path::canonicalize "$from")" == "$(path::canonicalize "$to")" ]]
}

@test "fails and leaves things unchanged if \$from.old exists" {
  import 'log::error'

  echo 'foo' >"$from"
  echo 'bar' >"$from.old"
  echo 'baz' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<''

  ((status == 1))
  [[ "${lines[1]}" == "$(log::error 'test' "both $from and $from.old already exist; aborting!")" ]]
  [[ -f "$from" ]] # $from is still a file
  [[ "$(cat "$from")" == 'foo' ]]
  [[ -f "$from.old" ]] # $from.old is a file
  [[ "$(cat "$from.old")" == 'bar' ]]
}

@test "fails and leaves things unchanged if \$from exists and a negative answer is given at the prompt" {
  import 'log::warn'
  import 'text::ends_with'

  echo 'foo' >"$from"
  echo 'bar' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<'n'

  ((status == 1))
  text::ends_with "${lines[1]}" "$(log::warn 'test' "$from will not be linked to $to")"
  [[ -f "$from" ]] # $from is still a file
  [[ "$(cat "$from")" == 'foo' ]]
  [[ ! -e "$from.old" ]] # $from.old does not exist
}

@test "fails and leaves things unchanged if \$to does not exist" {
  import 'log::error'

  run platform::safe_link 'test' "$from" "$to" <<<''

  ((status == 1))
  [[ "$output" == "$(log::error 'test' "$to does not exist; aborting!")" ]]
  [[ ! -e "$from" ]] # $from does not exist
  [[ ! -e "$to" ]]   # $to does not exist
}
