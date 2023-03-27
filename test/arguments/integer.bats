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
  import 'file::write'
  import 'log::error'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'arguments::integer'" \
    "foo() { arguments::integer 'bar' 'baz'; }" \
    'foo'
  chmod +x "$script"

  run "$script"

  ((status == 2))
  ((${#lines[@]} == 3))
  [[ "${lines[0]}" == "$(log::error 'foo' 'expected integer argument: bar')" ]]
  [[ "${lines[1]}" == '      actual: baz' ]]
  [[ "${lines[2]}" == "      at $script (line: 5)" ]]
}

@test "the failure message contains the shell if it is invoked outside of a function" {
  import 'log::error'

  run /usr/bin/env bash -c "source 'lib/import.bash' && import 'arguments::integer' && arguments::integer 'foo' 'bar'"

  ((status == 2))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == "$(log::error 'bash' 'expected integer argument: foo')" ]]
  [[ "${lines[1]}" == "       actual: bar" ]]
}

@test "the failure message contains the script name if it is invoked outside of a function" {
  load '../helpers/import.bash'
  import 'file::write'
  import 'log::error'
  import 'text::ends_with'

  local script="$BATS_TEST_TMPDIR/foo"
  file::write "$script" \
    '#!/usr/bin/env bash' \
    "source 'lib/import.bash'" \
    "import 'arguments::integer'" \
    "arguments::integer 'bar' 'baz'"
  chmod +x "$script"

  run "$script"

  ((status == 2))
  ((${#lines[@]} == 2))
  [[ "${lines[0]}" == "$(log::error "$script" 'expected integer argument: bar')" ]]
  text::ends_with "${lines[1]}" 'actual: baz'
}
