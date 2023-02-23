#!/usr/bin/env bats

setup() {
  source 'lib/import.bash'
  import 'platform::is_root'
}

@test "succeeds if the current user is root" {
  load ../helpers/mocks/stub

  stub id '-u : echo 0'

  run platform::is_root

  unstub id
  ((status == 0))
  [[ "$output" == '' ]]
}

@test "fails if the current user is not root" {
  load ../helpers/mocks/stub

  stub id '-u : echo 1000'

  run platform::is_root

  unstub id
  ((status == 1))
  [[ "$output" == '' ]]
}

@test "fails if retrieving the current user fails" {
  load ../helpers/mocks/stub

  stub id '-u : exit 1'

  run platform::is_root

  unstub id
  ((status == 1))
  [[ "$output" == '' ]]
}
