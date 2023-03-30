#!/usr/bin/env bats

setup() {
  load '../setup.bash'
  import 'value::integer'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run value::integer

  assert::wrong_usage 'value::integer' 'value'
}

@test "an empty value is not an integer" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails value::integer ''
}

@test "a non-integer value is not an integer" {
  load '../helpers/import.bash'
  import 'assert::fails'

  assert::fails value::integer 'foo'
}

@test "an integer value is an integer" {
  value::integer '42'
}
