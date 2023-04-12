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
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'log'
  import 'path::canonicalize'

  echo 'foo' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<''

  ((status == 0))
  [[ "$output" == "$(capture::stderr log trace 'test' "$from will be linked to $to")" ]]
  [[ -L "$from" ]] # $from is a symlink
  [[ "$(path::canonicalize "$from")" == "$(path::canonicalize "$to")" ]]
}

@test "does nothing if a symlink from \$from to \$to already exists" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'log'
  import 'path::canonicalize'

  echo 'foo' >"$to"
  ln -s "$to" "$from"

  run platform::safe_link 'test' "$from" "$to" <<<''

  ((status == 0))
  [[ "$output" == "$(capture::stderr log trace 'test' "$from already links to $to")" ]]
  [[ -L "$from" ]] # $from is a symlink
  [[ "$(path::canonicalize "$from")" == "$(path::canonicalize "$to")" ]]
}

@test "does nothing if a symlink from \$from to \$to already exists when \$from is also a symbolic link" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'log'
  import 'path::canonicalize'

  foo="$BATS_TEST_TMPDIR/foo"
  echo 'foo' >"$foo"
  ln -s "$foo" "$to"
  ln -s "$to" "$from"

  run platform::safe_link 'test' "$from" "$to" <<<''

  ((status == 0))
  [[ "$output" == "$(capture::stderr log trace 'test' "$from already links to $to")" ]]
  [[ -L "$from" ]] # $from is a symlink
  [[ "$(path::canonicalize "$from")" == "$(path::canonicalize "$to")" ]]

}

@test "asks if \$from should be replaced if \$from exists" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'log'
  import 'text::contains'

  echo 'foo' >"$from"
  echo 'bar' >"$to"
  eof=$'\x04'

  run platform::safe_link 'test' "$from" "$to" <<<"$eof"

  ((status == 1))
  [[ "${lines[0]}" == "$(capture::stderr log trace 'test' "$from will be linked to $to")" ]]
  text::contains "${lines[1]}" 'test'
  text::contains "${lines[1]}" "$from exists; do you want to replace it? [Y/n]"
}

@test "moves \$from to \$from.old if \$from exists and a positive answer is given at the prompt" {
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'file::exists'
  import 'log'
  import 'text::ends_with'

  echo 'foo' >"$from"
  echo 'bar' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<'y'

  ((status == 0))
  text::ends_with "${lines[1]}" "$(capture::stderr log trace 'test' "$from will be moved to $from.old")"
  file::exists "$from.old"
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
  load '../helpers/import.bash'
  import 'capture::stderr'
  import 'file::exists'
  import 'log'

  echo 'foo' >"$from"
  echo 'bar' >"$from.old"
  echo 'baz' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<''

  ((status == 1))
  [[ "${lines[1]}" == "$(capture::stderr log error 'test' "both $from and $from.old already exist")" ]]
  [[ "${lines[2]}" == '       aborting!' ]]
  file::exists "$from"
  [[ "$(cat "$from")" == 'foo' ]]
  file::exists "$from.old"
  [[ "$(cat "$from.old")" == 'bar' ]]
}

@test "fails and leaves things unchanged if \$from exists and a negative answer is given at the prompt" {
  load '../helpers/import.bash'
  import 'assert::fails'
  import 'capture::stderr'
  import 'file::exists'
  import 'log'
  import 'path::exists'
  import 'text::ends_with'

  echo 'foo' >"$from"
  echo 'bar' >"$to"

  run platform::safe_link 'test' "$from" "$to" <<<'n'

  ((status == 1))
  text::ends_with "${lines[1]}" "$(capture::stderr log warn 'test' "$from will not be linked to $to")"
  file::exists "$from"
  [[ "$(cat "$from")" == 'foo' ]]
  assert::fails path::exists "$from.old"
}

@test "fails and leaves things unchanged if \$to does not exist" {
  load '../helpers/import.bash'
  import 'assert::fails'
  import 'capture::stderr'
  import 'log'
  import 'path::exists'

  run platform::safe_link 'test' "$from" "$to" <<<''

  ((status == 1))
  [[ "$output" == "$(capture::stderr log error 'test' "$to does not exist" 'aborting!')" ]]
  assert::fails path::exists "$from"
  assert::fails path::exists "$to"
}

@test "fails and leaves things unchanged if path::canonicalize \$from fails" {
  load '../helpers/import.bash'
  import 'assert::fails'
  import 'capture::stderr'
  import 'log'
  import 'path::exists'

  echo 'foo' >"$to"

  path::canonicalize() { [[ "$1" != "$from" ]] && echo "$1"; }
  run platform::safe_link 'test' "$from" "$to" <<<''

  ((status == 1))
  [[ "$output" == "$(capture::stderr log error 'test' "unable to cannonicalize path: $from" 'aborting!')" ]]
  assert::fails path::exists "$from"
  [[ "$(cat "$to")" == 'foo' ]]
}

@test "fails and leaves things unchanged if path::canonicalize \$to fails" {
  load '../helpers/import.bash'
  import 'assert::fails'
  import 'capture::stderr'
  import 'log'
  import 'path::exists'

  echo 'foo' >"$to"

  path::canonicalize() { [[ "$1" != "$to" ]] && echo "$1"; }
  run platform::safe_link 'test' "$from" "$to" <<<''

  ((status == 1))
  [[ "$output" == "$(capture::stderr log error 'test' "unable to cannonicalize path: $to" 'aborting!')" ]]
  assert::fails path::exists "$from"
  [[ "$(cat "$to")" == 'foo' ]]
}

@test "fails and leaves things unchanged if \$from exists and it fails to ask a question to move it" {
  load '../helpers/import.bash'
  import 'assert::fails'
  import 'capture::stderr'
  import 'file::exists'
  import 'log'
  import 'path::exists'
  import 'text::ends_with'

  echo 'foo' >"$from"
  echo 'bar' >"$to"

  prompt::yes_or_no() { return 1; }

  run platform::safe_link 'test' "$from" "$to" <<<''

  ((status == 1))
  [[ "${lines[1]}" == "$(capture::stderr log error 'test' "$from exists")" ]]
  [[ "${lines[2]}" == "       it will not be linked to $to" ]]
  file::exists "$from"
  [[ "$(cat "$from")" == 'foo' ]]
  assert::fails path::exists "$from.old"
}
