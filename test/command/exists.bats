#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'command::exists'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run command::exists

  assert::wrong_usage 'command::exists' 'name'
}

@test "a program on \$PATH exists" {
  command::exists 'env'
}

@test "a function exists" {
  command::exists 'command::exists'
}

@test "an unknown command doesn't exist" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails command::exists 'foo'
}

@test "a variable is not a command and thus doesn't exist" {
  load '../helpers/import.bash'
  import 'assert::fails'

  foo='bar'

  assert::fails command::exists 'foo'
}

@test "a global variable is not a command and thus doesn't exist" {
  import 'bash::support::declare_global'
  if ! bash::support::declare_global; then
    skip 'declare global is not supported'
  fi

  load '../helpers/import.bash'
  import 'assert::fails'

  declare -g foo='bar'

  assert::fails command::exists 'foo'
}

@test "a local variable is not a command and thus doesn't exist" {
  load '../helpers/import.bash'
  import 'assert::fails'

  local foo='bar'

  assert::fails command::exists 'foo'
}

@test "a readonly variable is not a command and thus doesn't exist" {
  load '../helpers/import.bash'
  import 'assert::fails'

  local foo='bar'
  readonly foo

  assert::fails command::exists 'foo'
}
