setup() {
  source 'lib/import.bash'
  import 'arguments::integer'
}

@test "fails without arguments" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run arguments::integer

  assert::wrong_usage 'arguments::integer' 'name' 'value'
}

@test "fails with only one argument" {
  load '../helpers/import.bash'
  import 'assert::wrong_usage'

  run arguments::integer

  assert::wrong_usage 'arguments::integer' 'name' 'value'
}

@test "succeeds if value is an integer" {
  run arguments::integer 'foo' 42

  ((status == 0))
  [[ "$output" == '' ]]
}

@test "fails if the value is not an integer" {
  load '../helpers/import.bash'
  import 'assert::exits'
  import 'text::contains'

  foo() {
    arguments::integer 'bar' 'baz'
  }
  assert::exits foo

  ((status == 2))
  text::contains "${lines[0]}" 'foo'
  text::contains "${lines[0]}" 'the bar argument is not an integer'
}

@test "the failure message contains the shell if it is invoked outside of a function" {
  import 'text::contains'

  run /usr/bin/env bash -c "source 'lib/import.bash' && import 'arguments::integer' && arguments::integer 'foo' 'bar'"

  text::contains "${lines[0]}" 'bash'
  text::contains "${lines[0]}" 'the foo argument is not an integer'
}

@test "the failure message contains the script name if it is invoked outside of a function" {
  load '../helpers/import.bash'
  import 'file::write'
  import 'text::contains'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'arguments::integer'" \
    "arguments::integer 'bar' 'baz'"
  chmod +x "$script"

  run "$script"

  text::contains "${lines[0]}" "$foo"
  text::contains "${lines[0]}" 'the bar argument is not an integer'
}
